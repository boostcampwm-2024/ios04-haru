import Foundation
import WebRTC
import Combine
import PhotoGetherDomainInterface

public final class ConnectionClientImpl: ConnectionClient {
    private var cancellables: Set<AnyCancellable> = []
    
    private let webRTCService: WebRTCService
    
    public var receivedDataPublisher = PassthroughSubject<Data, Never>()
    
    public var remoteVideoView: UIView = CapturableVideoView()
    public var remoteUserInfo: UserInfo?
        
    public init(
        webRTCService: WebRTCService,
        remoteUserInfo: UserInfo? = nil
    ) {
        self.webRTCService = webRTCService
        self.remoteUserInfo = remoteUserInfo
        
        bindSignalingService()
        bindWebRTCService()
                
        // VideoTrack과 나와 상대방의 화면을 볼 수 있는 뷰를 바인딩합니다.
        self.bindRemoteVideo()
    }
    
    public func setRemoteUserInfo(_ remoteUserInfo: UserInfo) {
        self.remoteUserInfo = remoteUserInfo
    }
    
    // MARK: 해당 클라이언트에게 보낼 Offer SDP를 생성합니다.
    public func createOffer() async throws -> RTCSessionDescription {
        guard remoteUserInfo != nil else { throw NSError() }
        return try await self.webRTCService.offer()
    }
    
//    public func sendOffer(myID: String) {
//        guard let remoteUserInfo else { return }
//        
//        self.webRTCService.offer { sdp in
//            self.signalingService.send(
//                type: .offerSDP,
//                sdp: sdp,
//                roomID: remoteUserInfo.roomID,
//                offerID: myID,
//                answerID: nil
//            )
//        }
//    }
    
    public func sendData(data: Data) {
        self.webRTCService.sendData(data)
    }
    
    public func captureVideo() -> UIImage {
        guard let videoView = self.remoteVideoView as? CapturableVideoView else {
            return UIImage()
        }
        
        guard let capturedImage = videoView.capturedImage else {
            return UIImage()
        }
        
        return capturedImage
    }
    
    
    /// remoteVideoTrack과 상대방의 화면을 볼 수 있는 뷰를 바인딩합니다.
    private func bindRemoteVideo() {
        guard let remoteVideoView = remoteVideoView as? RTCMTLVideoView else { return }
        self.webRTCService.renderRemoteVideo(to: remoteVideoView)
    }
    
    public func bindLocalVideo(_ localVideoView: UIView) {
        guard let localVideoView = localVideoView as? RTCMTLVideoView else { return }
        self.webRTCService.startCaptureLocalVideo(renderer: localVideoView)
    }
    
    private func bindSignalingService() {
        // MARK: 이미 방에 있던 놈들이 받는 이벤트
        self.signalingService.didReceiveOfferSdpPublisher
            .filter { [weak self] _ in self?.remoteUserInfo != nil }
            .sink { [weak self] sdpMessage in
                guard let self else { return }
                let remoteSDP = sdpMessage.rtcSessionDescription
                
                PTGDataLogger.log("didReceiveRemoteSdpPublisher sink!! \(remoteSDP)")
                
                // MARK: remoteDescription이 있으면 이미 연결된 클라이언트
                guard self.webRTCService.peerConnection.remoteDescription == nil else {
                    PTGDataLogger.log("remoteSDP가 이미 있어요!")
                    return
                }
                PTGDataLogger.log("remoteSDP가 없어요! remoteSDP 저장하기 직전")
                guard let userInfo = self.remoteUserInfo else {
                    PTGDataLogger.log("answer를 받을 remote User가 없어요!! 비상!!!")
                    return
                }
                
                guard userInfo.id == sdpMessage.offerID else {
                    PTGDataLogger.log("Offer를 보낸 유저가 일치하지 않습니다.")
                    return
                }
                
                guard self.webRTCService.peerConnection.localDescription == nil else {
                    PTGDataLogger.log("localSDP가 이미 있어요!")
                    return
                }
                
            self.webRTCService.set(remoteSdp: remoteSDP) { error in
                PTGDataLogger.log("remoteSDP가 저장되었어요!")

                if let error { PTGDataLogger.log(error.localizedDescription) }
                
                self.webRTCService.answer { sdp in
                    self.signalingService.send(
                        type: .answerSDP,
                        sdp: sdp,
                        roomID: userInfo.roomID,
                        offerID: userInfo.id,
                        answerID: sdpMessage.answerID
                    )
                }
            }
        }.store(in: &cancellables)
        
        self.signalingService.didReceiveAnswerSdpPublisher
            .filter { [weak self] _ in self?.remoteUserInfo != nil }
            .sink { [weak self] sdpMessage in
                guard let self else { return }
                let remoteSDP = sdpMessage.rtcSessionDescription
                
                guard let userInfo = remoteUserInfo else {
                    PTGDataLogger.log("UserInfo가 없어요")
                    return
                }
                
                guard userInfo.id == sdpMessage.answerID else {
                    return
                }
                
                guard self.webRTCService.peerConnection.localDescription != nil else {
                    PTGDataLogger.log("localDescription이 없어요")
                    return
                }
                
                guard self.webRTCService.peerConnection.remoteDescription == nil else {
                    PTGDataLogger.log("remoteDescription이 있어요")
                    return
                }
                
                self.webRTCService.set(remoteSdp: remoteSDP) { error in
                    if let error = error {
                        PTGDataLogger.log("Error setting remote SDP: \(error.localizedDescription)")
                    }
                }
            }.store(in: &cancellables)
        
        self.signalingService.didReceiveCandidatePublisher.sink { [weak self] candidate in
            guard let self else { return }
            self.webRTCService.set(remoteCandidate: candidate) { _ in }
        }.store(in: &cancellables)
    }
    
    private func bindWebRTCService() {
        self.webRTCService.didReceiveDataPublisher.sink { [weak self] data in
            guard let self else { return }
            receivedDataPublisher.send(data)
        }.store(in: &cancellables)
        
        self.webRTCService.didGenerateLocalCandidatePublisher.sink { [weak self] candidate in
            guard let self, let remoteUserInfo else { return }
            self.signalingService.send(
                type: .iceCandidate,
                candidate: candidate,
                roomID: remoteUserInfo.roomID,
                userID: remoteUserInfo.id
            )
        }.store(in: &cancellables)
    }
}
