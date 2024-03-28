![Reet-Place_intro](https://user-images.githubusercontent.com/26570294/216861762-be640abe-35e6-42fd-98c9-6e2eccda306e.png)

## 🌆 Reet-Place

> 숨겨진 장소를 나만의 약속으로 Reet-place  
> 유저가 약속을 위한 장소를 쉽게 저장할 수 있도록 도와주는 북마크 기반 서비스

> DND 8기 2조 <br>
> 프로젝트 기간 : 2023.01 ~  
> 앱스토어 : https://apps.apple.com/us/app/reet-place/id6450978432

<br>

## 📱 iOS Developers
<div align="left">
    <table border="1">
        <th><a href="https://github.com/kth1210">김태현</a></th>
        <th><a href="https://github.com/iowa329">김희재</a></th>
        <tr>
            <td>
                <img src="https://github.com/kth1210.png" width='80' />
            </td>
            <td>
                <img src="https://github.com/iowa329.png" width='80' />
            </td>
        </tr>
    </table>
</div>
<br>

## 💫 주요 기능
![Group 1683](https://github.com/dnd-side-project/dnd-8th-2-frontend/assets/51712973/c315fe24-07e2-4a7f-9527-f0dbfbb2ec3b)
### 메인 지도
- 장소 카테고리 설정 기능
- 장소 검색, 최근 검색어 저장
- Naver Map SDK를 이용한 카테고리 장소, 북마크 장소 노출
- 선택한 장소의 정보 확인, 북마크 저장

### 북마크
- 사용자가 저장한 북마크의 종류별 노출
- 저장한 북마크 리스트 노출, 수정 및 삭제
- 지도에서 북마크 위치 확인

### 회원 관리
- Kakao, Apple 로그인, 로그인 없이 이용
<br>

## 🛠 기술 스택
- Swift, UIKit, RxSwift, CoreData, Code-based UI
- MVVM -> ReactorKit
- SnapKit, Then, Alamofire, Kingfisher, Fastlane
<br>

## ✅ 트러블 슈팅
### CoreData 도입
- 비로그인 사용자의 카테고리 필터 저장 기능을 위해 도입
- Backend 팀원과의 협업을 통해 로그인, 비로그인 시 시나리오 구현

### Fastlane - 인증서, Provisioning Profile 관리
- 팀원 간 인증서 공유, 관리에서 불편함을 느껴 Fastlane을 도입
- Fastlane match를 통해 기기 등록 및 Provisioning Profile 발급 자동화 구축
- TestFlight 배포 자동화 구축

### GitHub Action - Build Test 자동화
- PR merge에 대한 최소한의 안정성 확보를 위해 도입
- 해당 PR이 정상적으로 빌드되는지 자동으로 확인 가능

### ReactorKit 도입 리팩토링
- 기존 MVVM + RxSwift 구조의 two way 바인딩 문제에 불편함을 느껴 ReactorKit 도입 리팩토링 진행 중
- Action, Mutation, State의 규격화로 팀원 간 통일된 방식으로 코드 작성 가능

