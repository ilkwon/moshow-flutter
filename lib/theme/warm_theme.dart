// Warm 테마 구현 — 베이지/크림 감성 (공방, 핸드메이드)

import 'package:flutter/material.dart';

import 'app_theme.dart';

// ----------------------------------------------------------------------------
// Warm 색상
// ----------------------------------------------------------------------------
class WarmColors implements AppColors {
  @override
  Color get background => const Color(0xFFFAF7F2);
  @override
  Color get surface => const Color(0xFFF2EDE4);
  @override
  Color get primary => const Color(0xFF3D2B1F);
  @override
  Color get secondary => const Color(0xFF9C8070);
  @override
  Color get divider => const Color(0xFFE0D8CE);
  @override
  Color get tagBg => const Color(0xFFEDE5D8);
  @override
  Color get tagText => const Color(0xFF6B5040);
  @override
  Color get error => const Color(0xFFC0503A);
  @override
  Color get accent => const Color(0xFFB8895A);
}

// ----------------------------------------------------------------------------
// Warm 테마
// ----------------------------------------------------------------------------
class WarmTheme implements AppTheme {
  @override
  String get name => 'warm';
  @override
  AppColors get colors => WarmColors();
  @override
  AppTypography get typography => DefaultTypography();
  @override
  AppSpacing get spacing => DefaultSpacing();
  @override
  AppRadius get radius => DefaultRadius();
}