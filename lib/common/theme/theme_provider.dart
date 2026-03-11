// 테마 전환 상태 관리
// 선택한 테마를 앱 전체에 전달하고 SharedPreferences에 저장

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_theme.dart';
import 'light_theme.dart';
import 'dark_theme.dart';
import 'warm_theme.dart';
import 'gallery_theme.dart';

//----------------------------------------------------------------------------
// 테마 프로바이더
//----------------------------------------------------------------------------
// ChangerNotifier - 테마가 바뀌면 앱 전체에 알림을 보냄
class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'selected_theme';

  AppTheme _currentTheme = LightTheme(); // 기본 테마
  AppTheme get currentTheme => _currentTheme;

  // 사용가능한 테마 목록
  final List<AppTheme> themes = [
    LightTheme(),
    DarkTheme(),
    WarmTheme(),
    GalleryTheme(),
  ];

  //--------------------------------------------------------------------------
  // 생성자
  ThemeProvider() {
    _loadTheme();
  }

  // 테마 변경 메서드
  Future<void> _loadTheme() async {
    final preference = await SharedPreferences.getInstance();
    final String savedTheme = preference.getString(_themeKey) ?? 'light';
    // 저장된 테마 이름과 일치하는 테마를 찾음
    _currentTheme = themes.firstWhere(
      (theme) => theme.name == savedTheme,
      orElse: () => LightTheme(), // 기본 테마로 돌아감
    );
    notifyListeners(); // 테마가 변경되었음을 알림
  }

  // 테마 설정 메서드
  Future<void> setTheme(AppTheme theme) async {
    _currentTheme = theme;
    notifyListeners(); // 테마가 변경되었음을 알림
    final preference = await SharedPreferences.getInstance();
    await preference.setString(_themeKey, theme.name); // 선택한 테마 이름 저장
  }
}
