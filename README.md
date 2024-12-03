# 📷 포토게더 - For Together

![목업 배너](https://github.com/user-attachments/assets/c743749b-a16f-4673-921e-3ac335a80e30)

> ## 멀리 떨어진 친구들과 실시간으로 함께 찍고 편집하는 사진 촬영 앱
### For together?
- 어떤 우리?
- 누구를 위한건가

### PhotoGether!
> #모여봐요 #촬영해요 #편집해요 #공유해요


</br> 

## 플로우 소개
### 모여봐요
|   사진    | 내용                                                                                 |
| :-----: | ---------------------------------------------------------------------------------- |
| 사아진<br> | - 방을 생성하여 친구를 초대할 수 있습니다.<br>- 친구로부터 링크를 받아참여할 수 있습니다.<br>- 오디오/비디오 공유를 할 수 있습니다. |

### 촬영해요
| 사진  | 내용                                                                   |
| :-: | -------------------------------------------------------------------- |
| 사아진 | - 촬영할 수 있습니다.<br>- 전/후면 카메라 전환을 할 수 있습니다.<br>- 마이크를 On/Off 할 수 있습니다. |


### 편집해요
| 사진  | 내용                                                                     |
| :-: | ---------------------------------------------------------------------- |
| 사아진 | - 편집 과정이 실시간으로 공유됩니다.<br>- 스티커를 붙여 사진을 꾸밀 수 있습니다.<br>- 프레임을 바꿀 수 있습니다. |

### 공유해요
| 사진  | 내용                                           |
| :-: | -------------------------------------------- |
| 사아진 | - 편집 결과를 확인할 수 있습니다.<br>- 사진을 공유/저장할 수 있습니다. |


## 💻 개발 환경

| 환경  | 버전 |
|:---|:---|
| XCode | 16+ |
|Swift | 5.9 |
| Deployment Target | iOS 16+ |
| Packaging | SPM |

## 📚 기술 스택

### WebRTC

> 실시간으로 영상/음성/데이터를 주고 받기 위해 사용했습니다.
> 
> 멀리 떨어진 사용자와 실시간으로 통신하기 위해 레이턴시가 짧고 p2p 방식으로 서버 부담이 적은 WebRTC를 채택했습니다.

### Combine

> 비동기 프로그래밍과 UI 바인딩을 위해 사용했습니다.
>
> 다른 선택지로는 RxSwift가 있었고, 성능과 퍼스트 파티라는 이유에서 Combine을 선택하게 되었습니다.
> 
> 만약 다양한 UI 컴포넌트와의 바인딩이 필요했다면 RxSwift와 RxCocoa를 사용했겠지만,
>
> 해당 프로젝트에선 화면이 적고 비교적 UI 컴포넌트들이 간단해 Combine을 사용하기로 결정했습니다.

### AVFoundation

> 카메라 촬영 및 편집 그리고 VoIP 기능을 위해 사용했습니다.

</br>

## 🛠️ 아키텍쳐 구조

3-layer Clean Architecture 를 기반하고 있습니다.

짧은 프로젝트 기간동안 팀의 생산성을 높일 수 있는 구조를 고민했습니다.

최종적으로 test double과 demo 앱을 활용해 작업간의 종속성을 끊어 독립적인 작업을 할 수 있도록 했습니다.

<img src="https://github.com/user-attachments/assets/11d8c188-af32-47fc-811f-88bd83417863" width="600">

</br>

## 👋 팀원 소개



|                [S009_김기영](https://github.com/Kiyoung-Kim-57)                |                   [S034_송영규](https://github.com/youn9k)                    |                   [S035_송영훈](https://github.com/0Hooni)                    |                   [S077_홍승완](https://github.com/hsw1920)                   |
| :-------------------------------------------------------------------------: | :------------------------------------------------------------------------: | :------------------------------------------------------------------------: | :------------------------------------------------------------------------: |
| <img src="https://avatars.githubusercontent.com/u/121777185?v=4" width=150> | <img src="https://avatars.githubusercontent.com/u/60254939?v=4" width=150> | <img src="https://avatars.githubusercontent.com/u/37678646?v=4" width=150> | <img src="https://avatars.githubusercontent.com/u/66902876?v=4" width=150> |
|                         건강한 코드를 써내는<br>개발자가 되고싶습니다.                         |                               지는거에요?<br>이겨.                                |                                디버깅 다 해줬잖아.                                 |                                정상화... 해야겠지?                                |
|                                     iOS                                     |                                    iOS                                     |                                    iOS                                     |                                    iOS                                     |

</br>

|🏷️ 바로가기|[Wiki](https://github.com/boostcampwm-2024/iOS04-HARU/wiki)|[팀 노션](https://www.notion.so/0hooni/HARU-12e07f89fdcd8077a443dbba60cb124d)|[그라운드 룰](https://github.com/boostcampwm-2024/iOS04-HARU/wiki/그라운드-룰)|[컨벤션](https://github.com/boostcampwm-2024/iOS04-HARU/wiki/컨벤션)|[회의록](https://www.notion.so/0hooni/05cb406cd61f460ba7294ae3ffa31f7e)|[기획/디자인](https://www.figma.com/design/6jACkAa5WxD8mm4KgsPtzg/iOS04-GP?node-id=11-32851)|
|:-:|:-:|:-:|:-:|:-:|:-:|:--:|
