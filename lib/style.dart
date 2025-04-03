import 'package:flutter/material.dart';
var theme = ThemeData(
        iconTheme: IconThemeData(color:Colors.blue.shade300),

        //splashColor: Colors.transparent,
        //highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory, // ✅ 터치 애니메이션 제거

        appBarTheme: AppBarTheme(
          color: const Color.fromARGB(255, 228, 243, 253),
          elevation: 1,
          titleTextStyle: TextStyle(color:Colors.blue.shade300, fontSize: 25),
          actionsIconTheme: IconThemeData(color: Colors.black)
        ),


        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          type: BottomNavigationBarType.fixed, // 👈 추가!  
          enableFeedback: false, // 진동, 소리 등 피드백 제거
          //showSelectedLabels: false,
          //showUnselectedLabels: false,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          selectedIconTheme: IconThemeData(size: 32),
          unselectedIconTheme: IconThemeData(size: 28),
        ),


        textTheme: TextTheme(
          
          labelLarge: TextStyle(fontSize: 42, color: Colors.red.shade200),
          bodyMedium: TextStyle(fontSize: 16, color: Colors.grey.shade900),
        ),
      );