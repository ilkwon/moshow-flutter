import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/rendering.dart';

import 'package:image_picker/image_picker.dart';
import 'dart:io';

// moshow pages.
import './shared.dart';
import './style.dart' as style;
import './home.dart';
import './collect.dart';
import './upload.dart';

///////////////////////////////////////////////////////////////////////////////
void main() {
  runApp(MaterialApp(theme: style.theme, home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var stateTabIndex = 0;
  dynamic stateHomeData = [];
  var stateScroll = ScrollController();
  var urls = [
    'https://codingapple1.github.io/app/data.json',
    'https://codingapple1.github.io/app/more1.json'
  ];
  int pageSize = 3;
  bool isLoading = false;
  bool hasMore = true;
  var userImage;
  //-------------------------------------------------------------------------
  void getData(String jsonurl) async {
    if (isLoading || !hasMore) return; // ✅ [변경1] 더 이상 로딩할 게 없으면 종료
    isLoading = true;

    Shared.log('요청 URL: $jsonurl');

    try {
      var result = await http.get(Uri.parse(jsonurl));
      var json = jsonDecode(result.body);

      // ✅ [변경2] JSON이 null 또는 비어있으면 로딩 중단
      if (!Shared.hasValue(json)) {
        setState(() {
          hasMore = false; // ✅ 더 이상 데이터 없음
        });
        Shared.log('⚠️ 더 이상 가져올 데이터가 없습니다.');
      } else {
        // ✅ [변경3] 유효한 json이면 List/Map 구분하여 처리
        setState(() {
          if (json is List) {
            stateHomeData.addAll(json);
            hasMore = json.length >= pageSize;
          } else if (json is Map) {
            stateHomeData.add(json);
            hasMore = false; // Map 하나만 온 경우는 더 이상 없음
          }
          Shared.log('✅ 데이터 추가 완료: ${json is List ? json.length : 1}개');
        });
      }
    } catch (e) {
      Shared.log('❌ 로딩 중 예외 발생: $e');

      // ✅ [변경5] 예외 발생 시 더 이상 로딩하지 않도록 막기
      setState(() {
        hasMore = false;
      });
    }

    isLoading = false;
  }

  //-------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    stateScroll.addListener(() {
      if (stateScroll.position.pixels >=
          stateScroll.position.maxScrollExtent - 100) {
        if (!isLoading && hasMore) {
          getData(urls[1]);
          Shared.log('=========== 스크롤 끝 =========== ');
        }
      }
    });
    getData(urls[0]);
  }

  //-------------------------------------------------------------------------
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('모두의 쇼케이스'), actions: [
        IconButton(
          icon: Icon(Icons.add_box_outlined),
          iconSize: 30,
          onPressed: () async {
            var picker = ImagePicker();
            var image = await picker.pickImage(source: ImageSource.gallery);
            if (image != null) {
              setState(() {
                userImage = File(image.path);
              });
            }

            // ignore: use_build_context_synchronously
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (c) => Upload(selectImage: userImage)));
          },
        )
      ]),
      body: (stateTabIndex == 2) ? SizedBox.shrink() // 등록되지 않은 화면 띄우지 않기.
      : [
        Home(datas: stateHomeData),
        Text(
          '마켓',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        //Placeholder(), // 등록 버튼
        Collect(
            datas: stateHomeData,
            scroll: stateScroll,
            loading: isLoading,
            hasMore: hasMore),
        Text('계 정', style: Theme.of(context).textTheme.labelLarge),
      ][stateTabIndex > 2 ? stateTabIndex - 1 : stateTabIndex],
      bottomNavigationBar: BottomNavigationBar(
          // update 현재 탭.
          currentIndex: stateTabIndex,
          onTap: (int i) {
            if (i == 2){
              Shared.log('등록 탭이 눌림');
              // Show Popup.
              showModalBottomSheet(context: context,
                builder: (BuildContext context) => PopModal());
            } else {            
              setState(() {
                stateTabIndex = i;
              });
            }
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined), 
                label: '홈'),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag), 
                label: '마켓'),
            
            // 등록처럼 보이게 커스텀
            BottomNavigationBarItem(              
              icon:  IgnorePointer(
                child: Container(
                  width:56, 
                  height: 56,                
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                    child: Icon(Icons.add,
                    color:Colors.white,
                    size: 32,
                  )
                )
              ), label: '등록',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.video_collection), label: '컬렉션'),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle), label: '계정')
          ]),
    );
  }
  //-------------------------------------------------------------------------
}

class PopModal extends StatelessWidget {
  const PopModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text('새 콘텐츠 등록하기', style: TextStyle(fontSize: 18)),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // 모달 닫기
              // 등록 동작 실행
            },
            child: Text('사진 선택'),
          )
        ],
      ),
    );
  }
}