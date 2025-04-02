import 'package:flutter/material.dart';
var theme = ThemeData(
        iconTheme: IconThemeData(color:Colors.blue.shade300),

        appBarTheme: AppBarTheme(
          color: const Color.fromARGB(255, 228, 243, 253),
          elevation: 1,
          titleTextStyle: TextStyle(color:Colors.blue.shade300, fontSize: 25),
          actionsIconTheme: IconThemeData(color: Colors.black)
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          type: BottomNavigationBarType.fixed, // 👈 추가!  
          //showSelectedLabels: false,
          //showUnselectedLabels: false,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          selectedIconTheme: IconThemeData(size: 32),
          unselectedIconTheme: IconThemeData(size: 28),
        ),
        textTheme: TextTheme(
          bodySmall: TextStyle(color: Colors.pink.shade200),
          bodyMedium: TextStyle(color: Colors.red),
        ),
      );