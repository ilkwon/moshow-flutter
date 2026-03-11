import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:moshow/common/api_client.dart';
import 'package:moshow/common/define.dart';
import 'package:moshow/mo_app.dart';

//import 'package:moshow/screens/pop_modal.dart';

import 'package:moshow/common/providers/app_provider.dart';

import 'package:moshow/shell/mo_shell.dart';
import 'package:moshow/common/theme/theme_provider.dart';

import 'package:provider/provider.dart';

// moshow pages.
import 'package:moshow/common/shared.dart';
import 'package:moshow/style.dart' as style;

///////////////////////////////////////////////////////////////////////////////
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 상태바 투명처리
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (c) => StoreProvider()),
      ChangeNotifierProvider(create: (c) => ThemeProvider()),
    ],
    child: MoApp(),      
  ));
}

//---------------------------------------------------------------------------------
class BottomNavItems {
  static final List<BottomNavigationBarItem> items = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      label: '홈',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.search),
      label: '탐색',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.add_circle_outline),
      label: '등록',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.video_collection),
      label: '컬렉션',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.account_circle),
      label: '프로필',
    ),
  ];
}
