# moshow

취향과 취미를 가볍게 구경하고, 궁금하면 깊게 들어가는 앱.

공방, 워크숍, 핸드메이드, 취미 공간이 쇼케이스가 되고  
자연스럽게 커뮤니티 허브로 성장하는 플랫폼을 목표로 개발 중입니다.

> **현재 상태**: MVP v0.1 개발 진행 중 (Flutter 화면 조립 완료, 백엔드 API 연결 중)

---

## 화면 구성

| 화면 | 설명 |
|---|---|
| 홈 | 풀스크린 세로 스와이프 피드. post / showcase / sponsored 카드 혼합 |
| 탐색 | 검색창 + 태그 필터 + 2열 그리드 |
| 업로드 | 이미지 선택 → 미리보기 → 캡션 입력. 멀티 이미지 지원 |
| 컬렉션 | 내가 발견한 것을 모으는 큐레이션 공간 |
| 프로필 | 내 쇼케이스 목록 + 팔로워/팔로잉/게시물 통계 |

---

## 피드 카드 타입

```
post       — 개인 게시물 (사진 + 캡션)
showcase   — 큐레이션 묶음 (가로 PageView 내장)
sponsored  — 브랜드/팝업스토어 광고
```

피드 아이템은 서버 응답의 `type` 필드에 따라 카드 위젯이 분기됩니다.

---

## 앱 아키텍처

```
MoShell (루트, 절대 파괴 안 됨)
  ├── MoTopBar      고정. 탭에 따라 내용만 바뀜
  ├── IndexedStack  4개 탭 동시 메모리 유지 (탭 전환 시 상태 보존)
  │     ├── [0] HomeTab
  │     ├── [1] SearchTab
  │     ├── [2] CollectTab
  │     └── [3] ProfileTab
  └── MoBottomNav   5개 탭 고정

모달 (MoShell 위에 덮음)
  ├── UploadScreen  전체화면
  └── LoginSheet    바텀시트 (소셜 로그인, 예정)
```

---

## 기술 스택

| 구분 | 선택 | 비고 |
|---|---|---|
| 프론트 | Flutter | iOS · Android · Web |
| 백엔드 | Go | Google Cloud Run (서울) · Private |
| DB | Neon PostgreSQL | ap-southeast-1 |
| 미디어 | Cloudflare R2 | S3 호환, egress 무료 |
| 인증 | 게스트 허용 → 소셜 로그인 예정 | |
| 상태관리 | Provider | |

---

## 파일 구조

```
lib/
├── main.dart
├── mo_app.dart
├── shell/
│   ├── mo_shell.dart        앱 루트. 탭 상태 + 피드 로딩
│   ├── mo_top_bar.dart      탭별 TopBar 분기
│   └── mo_bottom_nav.dart   하단 5개 탭
├── common/
│   ├── define.dart          enum, 상수 정의
│   ├── shared.dart          SharedPreferences 래퍼
│   ├── api_client.dart      HTTP 통신 헬퍼
│   ├── providers/
│   │   └── app_provider.dart
│   ├── theme/               테마 4종 (light / dark / warm / gallery)
│   └── widgets/
│       ├── mo_button.dart
│       └── mo_tag_chip.dart
├── home/
│   ├── home_screen.dart
│   └── widgets/
│       ├── post_card.dart
│       ├── showcase_card.dart
│       └── home_sub_tab.dart
├── search/
│   └── search_screen.dart
├── collect/
│   └── collect_screen.dart
├── profile/
│   ├── profile_screen.dart
│   └── widgets/
│       ├── profile_header.dart
│       └── profile_sub_tab.dart
└── upload/
    └── upload_screen.dart
```

---

## MVP 로드맵

```
v0.1  개인 쇼케이스          ← 현재
v0.2  쇼케이스에 여러 Post 묶기
v0.3  커뮤니티 (팔로우, 댓글)
v0.4  오프라인 공간 연결 (위치, 일정)
v1.x  3D 전시관 커스터마이징 (Unity WebGL, 장기 계획)
```

---

## 개발 배경

Unity/C++/C# 기반 게임·3D 개발 경력을 가진 개발자가  
Flutter와 Go를 처음 배우면서 1인 개발로 진행 중인 프로젝트입니다.

"전체 구도를 이해하고 조각을 맞춰가는" 방식으로 개발하고 있으며,  
단계별 설계 결정과 그 근거를 기록하면서 진행하고 있습니다.

백엔드(moshow-api)는 별도 Private 레포지토리로 관리됩니다.

---

## 디자인 톤

```
배경     웜 베이지 / 오프화이트
액센트   골드 / 머스타드
모서리   둥근 처리
그림자   부드러운 그림자
```
