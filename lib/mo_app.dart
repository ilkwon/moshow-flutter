import 'package:flutter/material.dart';
import 'package:moshow/shell/mo_shell.dart';
import 'package:moshow/style.dart' as style;


class MoApp extends StatelessWidget {
  const MoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: style.theme.copyWith(
        textTheme: style.theme.textTheme.apply(fontFamily: 'NotoSansKR'),
      ),
      home: MoShell(),
    );
  }
}
