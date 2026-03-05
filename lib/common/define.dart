// lib/define.dart

import 'dart:ui';

const String appName = "모두의 쇼케이스";
const int pageSize = 3;

const bool isProduction = false; // 배포할 땐 true로 변경

const String apiBaseUrl = isProduction
    ? "https://moshow-api-561685747014.asia-northeast3.run.app"
    : "http://localhost:8080";
    
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
