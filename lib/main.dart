import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './style.dart' as style;
import './home.dart';
//-----------------------------------------------------------------------------
void main() {
  runApp(MaterialApp(
      theme: style.theme,
      home: MyApp()
    )
  );
}

//-----------------------------------------------------------------------------
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

//-----------------------------------------------------------------------------
class _MyAppState extends State<MyApp> {


  var stateTab = 0;
  dynamic stateItem = [];
  
  getData() async{
    String jsonurl = 'https://codingapple1.github.io/app/data.json';
    var result = await http.get(Uri.parse(jsonurl));
    var json = jsonDecode(result.body);
    
    setState(() {
      stateItem = json;
    });
    
    print(json[0]);
  }

  @override
  void initState() {    
    super.initState();

    getData();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('모두의 쇼케이스'),
        actions: [
          IconButton(
            onPressed: (){}, 
            icon: Icon(Icons.add_box_outlined), 
            iconSize: 30,
          )
        ]
      ),
      
      body: [ Home(items: stateItem), Text('두번째 탭'),Text('세번째 탭'),Text('네번째 탭'),][stateTab],

      bottomNavigationBar: BottomNavigationBar(
        onTap: (int i){
          setState(() {
            stateTab = i;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: '마켓'),
          //BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: '등록'),
          BottomNavigationBarItem(icon: Icon(Icons.video_collection), label: '컬렉션'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: '계정')
        ]
      ),
    );
  }
}