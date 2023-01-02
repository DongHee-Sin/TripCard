# Trip Card
### 여행을 카드 형태로 간편하게 기록하고 조회할 수 있는 앱
#### 2022.09.13 ~ 2022.09.29 (출시)
#### 2022.09.30 ~ (업데이트)

<br/>

### [프로젝트 회고](https://co-dong.tistory.com/75)
### [개발일지](https://difficult-knee-26c.notion.site/580f179303614af19b8007aef6c6bfb3)
### [Trouble Shooting](https://difficult-knee-26c.notion.site/TripCard-Trouble-Shooting-4d5f8e1fef3d4a4487c523f54567a107)

<br/>

<img width="100%" alt="스크린샷 2022-12-20 오후 10 02 31" src="https://user-images.githubusercontent.com/82014951/208681754-1f489536-acd8-4296-b2b1-dee9610206c1.png">

<br/>
<br/>

## 🛠️ 기술스택 & 라이브러리 📗
* MVC, MVVM
* Realm, Zip (백업, 복구)
* Firebase (Analytics, Crashlytics)
* SnapKit, Then (Codebase UI)
* GooglePlaces
* IQKeyboardManager, TextFieldEffects
* TOCropViewController
* FSCalendar
* FSPagerView
* Tabman
* JGProgressHUD

<br/>
<br/>

## 📱 실행화면 (gif)

| 메인화면 | 기간 입력 | 지역 입력 | 이미지 등록
|:---:|:---:|:---:|:---:|
| ![메인화면](https://user-images.githubusercontent.com/82014951/210208934-698ec34b-55df-4b1c-a8ae-ad22c8a2a396.gif) | ![기간입력](https://user-images.githubusercontent.com/82014951/210209995-6993d3ef-06e2-456c-88bf-91bd1065d343.gif) | ![지역입력](https://user-images.githubusercontent.com/82014951/210210008-75ee4cde-d222-4f2f-a3e4-17e54eae2d81.gif) | ![이미지등록](https://user-images.githubusercontent.com/82014951/210210015-93749933-a479-44ea-8f9d-9beef91e3f3a.gif)

<br/>
<br/>
<br/>

# 버전 정보
### v1.0
* 22.10.01 심사 통과

### v1.1
* 작성화면 기능 및 UI 업데이트
   1. 이미지 삭제 기능 추가
   2. 이미지 추가(변경) 버튼이 이미지가 등록되어도 중앙에 표시되도록 수정

### v1.2
* 날짜별 이미지 등록 화면에서 삭제 버튼이 항상 노출되던 오류 수정
* 여행 지역을 입력하는 방식 변경
   * 수정 전 : 직접 문자열 입력
   * 수정 후 : google places를 사용하여 실제 지역을 검색하여 입력

### v1.3
* 날짜별 이미지를 한번에 등록할 수 있는 기능 추가
   * FSCalendar에 입력된 기간을 바탕으로 PHPicker를 사용하여 다수의 이미지 입력
   * 이미지 Crop과정 생력하고 등록
* 작성화면에서 등록된 이미지를 Crop할 수 있는 버튼 추가
* 지원하는 폰트 변경 (특정 문자를 지원하지 않는 폰트 교체)

### v1.3.1
* 버그 수정 및 안정성 개선

### v1.3.2
* 버그 수정 및 안정성 개선