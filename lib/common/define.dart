// lib/define.dart

import 'dart:ui';

const String appName = "모두의 쇼케이스";
const int pageSize = 3;

class RouteName {
  static const home = '/home';
  static const upload = '/upload';
}

class AppColors {
  static const primary = Color(0xFF2196F3);
  static const secondary = Color(0xFF42A5F5);
}

enum TabType {
  home,
  market,
  upload,
  collection,
  account,
}
