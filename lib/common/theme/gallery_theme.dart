// Gallery 테마 구현 — 순백 + 블랙 포인트 (전시, 갤러리)

import 'package:flutter/material.dart';

import 'app_theme.dart';

// ----------------------------------------------------------------------------
// Gallery 색상
// ----------------------------------------------------------------------------
class GalleryColors implements AppColors {
  @override
  Color get background => const Color(0xFFFAFAFA);
  @override
  Color get surface => const Color(0xFFFFFFFF);
  @override
  Color get primary => const Color(0xFF000000);
  @override
  Color get secondary => const Color(0xFF666666);
  @override
  Color get divider => const Color(0xFFE0E0E0);
  @override
  Color get tagBg => const Color(0xFFF0F0F0);
  @override
  Color get tagText => const Color(0xFF333333);
  @override
  Color get error => const Color(0xFFE05C5C);
  @override
  Color get accent => const Color(0xFF000000);
}

// ----------------------------------------------------------------------------
// Gallery 테마
// ----------------------------------------------------------------------------
class GalleryTheme implements AppTheme {
  @override
  String get name => 'gallery';
  @override
  AppColors get colors => GalleryColors();
  @override
  AppTypography get typography => DefaultTypography();
  @override
  AppSpacing get spacing => DefaultSpacing();
  @override
  AppRadius get radius => DefaultRadius();
}