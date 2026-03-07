// Dark 테마 구현

import 'package:flutter/material.dart';

import 'app_theme.dart';

// ----------------------------------------------------------------------------
// Dark 색상
// ----------------------------------------------------------------------------
class DarkColors implements AppColors {
  @override
  Color get background => const Color(0xFF121212);
  @override
  Color get surface => const Color(0xFF1E1E1E);
  @override
  Color get primary => const Color(0xFFF0F0F0);
  @override
  Color get secondary => const Color(0xFFAAAAAA);
  @override
  Color get divider => const Color(0xFF2C2C2C);
  @override
  Color get tagBg => const Color(0xFF2A2A2A);
  @override
  Color get tagText => const Color(0xFFCCCCCC);
  @override
  Color get error => const Color(0xFFFF6B6B);
  @override
  Color get accent => const Color(0xFFC8A06E);
}

// ----------------------------------------------------------------------------
// Dark 테마
// ----------------------------------------------------------------------------
class DarkTheme implements AppTheme {
  @override
  String get name => 'dark';
  @override
  AppColors get colors => DarkColors();
  @override
  AppTypography get typography => DefaultTypography();
  @override
  AppSpacing get spacing => DefaultSpacing();
  @override
  AppRadius get radius => DefaultRadius();
}