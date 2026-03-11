// 모든 테마가 상속하는 베이스 추상 클래스

import 'package:flutter/material.dart';

// ----------------------------------------------------------------------------
// 색상
// ----------------------------------------------------------------------------
// 테마마다 반드시 구현해야 하는 색상 목록
abstract class AppColors {
  // 페이지 배경
  Color get background;
  // 카드, 시트 배경
  Color get surface;
  // 주요 텍스트, 버튼
  Color get primary;
  // 보조 텍스트
  Color get secondary;
  // 구분선
  Color get divider;
  // 태그 칩 배경
  Color get tagBg;
  // 태그 칩 텍스트
  Color get tagText;
  // 에러
  Color get error;
  // 포인트 컬러 (브랜드)
  Color get accent;
}

// ----------------------------------------------------------------------------
// 타이포그래피
// ----------------------------------------------------------------------------
// 테마마다 반드시 구현해야 하는 텍스트 스타일 목록
abstract class AppTypography {
  // 28px Bold — 쇼케이스 이름
  TextStyle get displayLarge;
  // 22px Bold — 상세 화면 제목
  TextStyle get titleLarge;
  // 18px SemiBold — 섹션 제목
  TextStyle get titleMedium;
  // 16px Regular — 본문
  TextStyle get bodyLarge;
  // 14px Regular — 보조 본문
  TextStyle get bodyMedium;
  // 13px Medium — 태그, 버튼
  TextStyle get labelMedium;
  // 11px Regular — 날짜, 작성자
  TextStyle get labelSmall;
}

// ----------------------------------------------------------------------------
// 간격
// ----------------------------------------------------------------------------
// 숫자 대신 이름으로 쓰면 나중에 한 곳에서 수정 가능
abstract class AppSpacing {
  // 4px
  double get tiny;
  // 8px
  double get small;
  // 16px
  double get medium;
  // 24px
  double get large;
  // 32px
  double get xLarge;
  // 48px
  double get xxLarge;
}
// ----------------------------------------------------------------------------
// 반경
// ----------------------------------------------------------------------------
// 숫자 대신 이름으로 쓰면 디자인 변경 시 한 곳에서 수정 가능
abstract class AppRadius {
  // 6px — 태그 칩
  double get small;
  // 12px — 카드
  double get medium;
  // 20px — 버튼
  double get large;
  // 999px — 아바타, pill 버튼
  double get full;
}

// ----------------------------------------------------------------------------
// 테마
// ----------------------------------------------------------------------------
// 4개 추상 클래스를 하나로 묶는 베이스 테마 클래스
abstract class AppTheme {
  // 테마 이름 (light, dark, etc.) 설정화면에 표시
  String get name;
  // 색상
  AppColors get colors;
  // 타이포그래피
  AppTypography get typography;
  // 간격
  AppSpacing get spacing;
  // 반경
  AppRadius get radius;
}

// ----------------------------------------------------------------------------
// 기본 간격 — 모든 테마 공통
// ----------------------------------------------------------------------------
// 테마마다 간격이 달라질 일이 없으므로 한 번만 구현
class DefaultSpacing implements AppSpacing {
  @override
  double get tiny => 4;
  @override
  double get small => 8;
  @override
  double get medium => 16;
  @override
  double get large => 24;
  @override
  double get xLarge => 32;
  @override
  double get xxLarge => 48;
}

// ----------------------------------------------------------------------------
// 기본 반경 — 모든 테마 공통
// ----------------------------------------------------------------------------
// 테마마다 반경이 달라질 일이 없으므로 한 번만 구현
class DefaultRadius implements AppRadius {
  @override
  double get small => 6;
  @override
  double get medium => 12;
  @override
  double get large => 20;
  @override
  double get full => 999;
}

// ----------------------------------------------------------------------------
// 기본 타이포그래피 — 모든 테마 공통
// ----------------------------------------------------------------------------
// 색상은 각 테마에서 적용하므로 여기선 크기/굵기만 정의
class DefaultTypography implements AppTypography {
  @override
  TextStyle get displayLarge => const TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
  );
  @override
  TextStyle get titleLarge => const TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );
  @override
  TextStyle get titleMedium => const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );
  @override
  TextStyle get bodyLarge => const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );
  @override
  TextStyle get bodyMedium => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );
  @override
  TextStyle get labelMedium => const TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );
  @override
  TextStyle get labelSmall => const TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.normal,
  );
}