# 출시 프로젝트 (Trip Card)
[Notion](https://difficult-knee-26c.notion.site/cef8341d3430410f9b572669be1811de)

<br/>
<br/>

---

<br/>
<br/>

## 개발일지

### 22.09.13 (화)
* 팀원들과 출시 프로젝트 기획서, 진행상황 공유
* 희철님이 공유해주신 FloatingButton 꿀팁 적용
* 무료 아이콘 사이트 및 저작권 관련 내용 공유
* 태현님이 TabBar Height를 기기별로 적용하는 코드를 공유해주심
* 추석동안 진행하지 못했던 이터레이션1 완료
* 이터레이션2 50% 진행중
    * 메인화면 UI 생성 및 데이터 처리 로직 구현
* 젝님이 추천해주신 방향으로 기획 변경
    * 작성 화면에서 2가지 선택지를 제공하지 않고, 메인으로 보여줄 카드와 여행 날짜별로 저장할 카드를 구분하여 저장하도록 구현
    * 카드를 조회하는 화면에서 카드를 탭 했을 때, 날짜별 기록을 조회하도록 수정 (기존의 기획 방식은 하나의 화면에서 2개의 가로 스크롤이 필요하기 때문에 유저의 사용성을 해칠 수 있음)
    * **Realm, Document를 관리하는 로직 수정 필요**

<br/>
<br/>

### 22.09.14 (수)
* 세모모드로 고정 설정
* 모든 이미지의 비율을 4:5로 맞추기 위해 설정 변경
    * CollectionViewCell Item의 높이를 동적으로 조절하기 위해 Compositional Layout 사용
    * CropViewController 라이브러리를 통해 사용자의 이미지를 가져올 때 4:5 비율로 잘라서 가져오도록 설정
* FloatingButton, addImageButton 크기 설정 (point size)
* WriteViewController 구조 변경 (기획 수정)
* Observable 타입을 사용하여 WriteViewModel 생성
* TextView AutoHeight 내용 공유 (희철님)

<br/>

필요한 추가 작업
* ViewModel 적용 - 지역, 기간 TextField
* FSClaendar 적용(기간 입력) / Local API 적용 (지역 입력)
