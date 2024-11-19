import Foundation
import Combine
import PhotoGetherDomainInterface

public final class EditPhotoRoomHostViewModel {
    enum Input {
        case stickerButtonDidTap
    }

    enum Output {
        case sticker(data: Data)
    }
    
    private let fetchStickerListUseCase: FetchStickerListUseCase
    private var stickerList: [Data] = []
    
    private var cancellables = Set<AnyCancellable>()
    private var output = PassthroughSubject<Output, Never>()
    
    public init(
        fetchStickerListUseCase: FetchStickerListUseCase
    ) {
        self.fetchStickerListUseCase = fetchStickerListUseCase
        bind()
        
    }
    
    private func bind() {
        fetchStickerList()  // 처음 한번 부르고 부터는 재호출을 안하도록
    }
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { [weak self] in
            switch $0 {
            case .stickerButtonDidTap:
                self?.addStickerToCanvas()
            }
        }
        .store(in: &cancellables)
        
        return output.eraseToAnyPublisher()
    }
    
    private func fetchStickerList() {
        fetchStickerListUseCase.execute()
            .sink { [weak self] datas in
                self?.stickerList = datas
            }
            .store(in: &cancellables)
    }
    
    private func addStickerToCanvas() {
        output.send(.sticker(data: stickerList.randomElement()!))
    }
}
