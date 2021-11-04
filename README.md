# 영화 노트 앱 서비스

>  영화를 검색하고 장르별로 기록할 수 있는 앱 (네이버 영화검색 API 사용)

![Swift](https://img.shields.io/badge/Swift-5.5-orange.svg) ![iOS](https://img.shields.io/badge/Platform-iOS-lightgrey.svg)

| 기록 탭 (랜딩 페이지)                                        | 설정 탭                                       | 영화 검색 페이지                                             | 장르별 영화 리스트 페이지                                    |
| ------------------------------------------------------------ | --------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| ![landing](https://user-images.githubusercontent.com/56751259/140325956-64741188-5d0f-411c-ab4f-00ca2e3efcf2.png) | ![settings](https://user-images.githubusercontent.com/56751259/140335673-288792cd-2f9d-4683-bf21-43a41d982e75.png) | ![search-movie](https://user-images.githubusercontent.com/56751259/140327178-4ff53c45-fcde-4485-b33a-fe9679660650.png) | ![watched-movie-list](https://user-images.githubusercontent.com/56751259/140326920-7555c023-0d4c-4181-9026-64cd9a3c681e.png) |

## 화면/기능별 기본 동작

### 기록 탭 - 데이터 추가

![record-add-data](https://user-images.githubusercontent.com/56751259/140322054-b4c55d7d-aafb-4463-9a87-90fed58e17a9.gif)

* 오른쪽 상단 **+ 버튼**을 눌러 본 영화의 데이터를 추가할 수 있습니다.
  1. 영화 장르(카테고리)를 선택합니다.
  2. 영화 이름을 검색합니다: 영화 제목, 개봉년도, 평점을 확인할 수 있습니다.
  3. 목록에서 선택된 영화가 없다면 다음 버튼이 활성화 되지 않습니다. 영화는 한번에 하나만 선택할 수 있습니다.

![record-write-review](https://user-images.githubusercontent.com/56751259/140324241-fe21c730-1818-4d71-94ce-18f41d1ab665.gif)

* 날짜와 메모가 모두 입력된 상태에서만 완료 버튼이 활성화 됩니다.
* 완료 버튼을 누르면 처음 화면(나의 영화 노트)으로 돌아갑니다.

### 기록 탭 - 장르별 영화 리스트

![watched-movie-modal](https://user-images.githubusercontent.com/56751259/140327737-0616f99d-40f8-490b-8348-d7cc1151154c.gif)

* 메인 페이지에서 장르를 선택해 장르별로 본 영화 목록을 확인합니다: 영화 제목과 관람 일자를 확인할 수 있습니다.
* 왼쪽 상단 정렬 방식 선택 버튼을 누르면 방식을 선택할 수 있는 Bottom Sheet가 나타납니다.
  * 정렬 방식을 선택하면 오른쪽에 체크마크가 표시됩니다.
  * X 버튼을 누르거나 음영 부분을 눌러 창을 닫을 수 있습니다.
  * 선택한 정렬 방식으로 버튼 타이틀이 변경됩니다. (정렬 방식 변경은 구현 예정)

### 설정 탭 - 카테고리 추가

![settings-add-genre](https://user-images.githubusercontent.com/56751259/140320851-ab5413f3-b74f-44a1-bd64-332d2f8c83bf.gif)

* 아직 추가된 카테고리가 없다면 **카테고리를 추가해주세요**라는 안내 문구가 보입니다.
* 오른쪽 상단 **+ 버튼**을 눌러 카테고리를 추가할 수 있습니다.
  * 추가된 카테고리는 바로 화면에 반영됩니다.

## 상세 구현 내용

### Architecture - MVVM & Clean Architecture

MVVM과 Clean Architecture를 적용해 프로젝트를 진행했습니다. 영화의 검색, 저장, 확인의 기능을 MVC 패턴 하에서 작성하기에는 다소 범위가 넓고 코드의 분리가 어려워질 것이라 생각했습니다. 다소 코드 구현량은 많아 질 수 있으나 MVVM 패턴을 따르는 것이 코드 작성은 물론 유지보수에서도 이점이 있겠다고 판단하였습니다. 또한 프로젝트 기간 동안은 작성하지 못했지만 View Model에 대한 테스트를 진행할 계획이 있으므로 더더욱 MVVM으로 진행하는 것이 좋겠다고 생각했습니다.

* Layers
  * Domain Layer
    * Entities: API에서 받아온 영화 정보를 보여주는 데 사용하는 `Movie` 엔티티와 카테고리로 사용할 `Genre` 엔티티, 장르별 기록된 영화 리스트를 보여주는데 사용할 `Item` 엔티티를 생성했습니다. 프로젝트 후반 **Realm**을 Persistent Storage로 추가하면서 Realm Object 형태에 맞게 수정해주었습니다.
  * Data Layer
    * API (Network): Alamofire와 RxSwift를 이용해 네트워크 통신 및 디코딩을 처리해주었습니다.
      * `Router`: Router 패턴을 적용해 특정 상황에 맞는 URLRequest를 생성할 수 있도록 구현했습니다. Router 패턴은 Alamofire 공식 문서에서 `URLRequestConvertible` 프로토콜을 사용할 때 Router 패턴을 함께 쓰길 권하고 있습니다.
        처음엔 외부에서 값을 주입하기 어렵다는 점때문에 사용하기 꺼려졌으나 막상 구현해놓고 보니 코드양이 획기적으로 준다는 이점을 발견할 수 있었습니다. 개인적으로는 어떤 상황에서는 Repository와 Use Case를 구현하는 것보다는 Router 하나로 처리하는 것이 더 가독성 있고 짧은 코드를 작성할 수 있지 않나 이번 프로젝트를 통해 느낄 수 있었습니다.
      * `APIClient`: Alamofire와 RxSwift를 조합해 Request를 처리하도록 구현했습니다. 값을 넘기기 위한 Completion Handler를 사용하지 않고 디코딩을 위한 객체를 따로 생성할 필요가 없다는 점에서 역시 코드가 비약적으로 줄어드는 이점을 경험했습니다.
    * Persistence DB: Realm을 사용해 유저의 카테고리 목록과 그 카테고리에 속한 시청 기록을 영구 저장할 수 있도록 구현했습니다. RxRealm 라이브러리를 활용해 Realm과 RxSwift간 시너지를 극대화할 수 있도록 시도했습니다.
  * Presentation Layer (MVVM)
    * Views & View Models
      * Main.Storyboard를 제거하고 코드 혹은 화면별 Storyboard로 화면을 구현했습니다.
      * View Controller에서는 바인딩을 통해 View가 View Model의 상태 변화를 옵저빙할 수 있게 해주었습니다. 바인딩에는 RxSwift를 이용했습니다. 이를 통해 View Model의 속성값이 변경되면 자동으로 View를 업데이트 합니다.

## 개발 환경 설정

* iOS Deployment Target: 12.0
* Xcode Version: 13.1
* API: https://openapi.naver.com/v1/search/movie.json
  * 관련 문서: https://developers.naver.com/docs/search/movie/

## 키워드

MVVM, Dependency Injection, Clean Architecture, RxSwift, Alamofire, Realm

## 로드맵

- [ ] 영화 기록 상세 페이지 구현
- [ ] 장르 관리 Switch On/Off (Toggle) 기능 추가
- [ ] 장르 및 영화 수정, 삭제 기능
- [ ] Flow Coordinator 패턴 리팩토링: Scene별로 분리
- [ ] RxSwift 코드 리팩토링
- [ ] 유닛테스트
- [ ] 에러 핸들링
- [ ] Activity Indicator 추가

## References

* [kudoleh / iOS-Clean-Architecture-MVVM](https://github.com/kudoleh/iOS-Clean-Architecture-MVVM)
* [ReactiveX / RxSwift](https://github.com/ReactiveX/RxSwift)
* [Alamofire / Alamofire](https://github.com/Alamofire/Alamofire)
