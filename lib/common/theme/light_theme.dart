// Light 테마 구현 — 기본 테마

import 'package:flutter/material.dart';

import 'app_theme.dart';

// ----------------------------------------------------------------------------
// Light 색상
// ----------------------------------------------------------------------------
class LightColors implements AppColors {
  @override
  Color get background => const Color(0xFFFFFFFF);
  @override
  Color get surface => const Color(0xFFF7F7F5);
  @override
  Color get primary => const Color(0xFF1A1A1A);
  @override
  Color get secondary => const Color(0xFF888888);
  @override
  Color get divider => const Color(0xFFE8E8E8);
  @override
  Color get tagBg => const Color(0xFFF0F0EE);
  @override
  Color get tagText => const Color(0xFF555555);
  @override
  Color get error => const Color(0xFFE05C5C);
  @override
  Color get accent => const Color(0xFFB8895A);
}

// ----------------------------------------------------------------------------
// Light 테마
// ----------------------------------------------------------------------------
class LightTheme implements AppTheme {
  @override
  String get name => 'light';
  @override
  AppColors get colors => LightColors();
  @override
  AppTypography get typography => DefaultTypography();
  @override
  AppSpacing get spacing => DefaultSpacing();
  @override
  AppRadius get radius => DefaultRadius();
}