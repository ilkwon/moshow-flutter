import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moshow/mo_app.dart';

import 'package:moshow/common/providers/app_provider.dart';
import 'package:moshow/common/theme/theme_provider.dart';
import 'package:provider/provider.dart';

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
