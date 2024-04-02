# HelloKorea

## Overview
HelloKorea는 K-콘텐츠(드라마, 영화)에 관련된 콘텐츠의 설명을 알려주고 촬영 장소를 지도에 표시, 관련 내용을 검색할 수 있게 도와주는 앱입니다.
저의 주변 대부분의 외국인 친구들이 K-콘텐츠를 통해 한국을 알게 되게 관심이 생겨 방문하는 외국인이 많았습니다. 그래서 HelloKorea를 통해 손쉽게 관련 정보를 제공하려는 목적으로 앱을 개발하게 되었습니다.

## Tech stack
- UIKit(codebase)
- MapKit
- CoreLoacation
  - 주소 데이터를 좌표 데이터로 변환

- firebase(fireStore, Storage)
  - fireStore 내 출연자, 드라마 제목, Storage에 저장된 이미지의 URL, 콘텐츠 관련 촬영 장소 정보 저장
  - Storage 내 콘텐츠 관련 이미지 저장
  - firebase 서비스에 저장된 리소스 패치

- RxSwift
  - 패치한 데이터 바인딩을 위한 비동기 처리
  - CoreLocation으로 얻어진 좌표 위 핀을 찍기 위한 비동기 처리

- Toast_Swift
  - 콘텐츠 관련 촬영 장소의 주소 복사 완료 표시
    
- MVC

<br>

| Locations 기능 | Facilities 기능
|----------------------------------------------------------|----------------------------------------------------------|
| <img src = "https://github.com/dongju0561/HelloKorea/assets/77201628/816b46ad-f4a9-4c71-9f39-2cd62caeebec" width="300" height="500"> | <img src = "https://github.com/dongju0561/HelloKorea/assets/77201628/5a656dd7-11db-4d79-b63a-de6dfea3324a" width="300" height="500">

<br>

## Function
### Locations 기능
- firebase(fireStore, Storage)로부터 촬영 장소 관련 리소스(이미지, 텍스트) 패치 후 관련 데이터들 바인딩
- 콘텐츠의 촬영 장소들을 지도상에서 핀을 통해 위치 정보를 제공
- 검색이 용이하도록 콘텐츠의 제목 문자열 복사하기 기능을 지원
- 검색이 용이하도록 해당 앱상에서 콘텐츠의 제목 문자열을 검색어로 사용하여 safari로 검색
### Facilities 기능
- 이슬람 교인들을 위한 시설(할랄 인증된 음식점, 기도실)을 핀을 통해 위치 정보 제공
- 핀 이미지를 구별하여 음식점과 기도실의 위치 확인 가능

<br>

## 프로젝트를 도와준 친구들

<img src = "https://github.com/dongju0561/HelloKorea/assets/77201628/6b8bc951-7d67-4e57-806a-7a1300761149" width="400" height="400">
