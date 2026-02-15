import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:moshow/common/define.dart';
import 'dart:convert';
import 'package:moshow/pop_modal.dart';

import 'package:moshow/providers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// moshow pages.
import 'common/shared.dart';
import './style.dart' as style;
import './home.dart';
import './collect.dart';

///////////////////////////////////////////////////////////////////////////////
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (c) => StoreProvider()),
    ],
    child: MaterialApp(
      theme: style.theme.copyWith(
        textTheme: style.theme.textTheme.apply(fontFamily: 'NotoSansKR'),
      ),
      home: MyApp(),
    ),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var urls = [
    'https://codingapple1.github.io/app/data.json',
    'https://codingapple1.github.io/app/more1.json'
  ];
  int pageSizeFromJosnData = 3;
  bool isLoading = false;
  bool hasMore = true;

  // state vars
  var tabIndex = 0;
  dynamic homeData = [];
  dynamic collectData = [];

  var stateScroll = ScrollController();
  var userImage;
  //-------------------------------------------------------------------------
  void saveData() async {
    var storage = await SharedPreferences.getInstance();
    storage.setString('name', 'ilkwon.');
    var name = storage.getString('name');

    var map = {'age': 20};
    storage.setString('map', jsonEncode(map));
    var result = storage.getString('map') ?? '없는데요';
    print(jsonDecode(result)['age']);
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
      appBar: AppBar(title: Text(appName)),
      body: (tabIndex == TabType.upload.index)
          ? SizedBox.shrink() // 등록되지 않은 화면 띄우지 않기.
          : [
              Home(datas: homeData),
              Text(
                '마켓',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              //Placeholder(), // 등록 버튼
              Collect(
                  datas: collectData,
                  scroll: stateScroll,
                  loading: isLoading,
                  hasMore: hasMore),
              Text('계 정', style: Theme.of(context).textTheme.labelLarge),
            ][tabIndex > 2 ? tabIndex - 1 : tabIndex],
      bottomNavigationBar: BottomNavigationBar(
          // update 현재 탭.
          currentIndex: tabIndex,
          onTap: (int i) async {
            if (i == TabType.upload.index) {
              Shared.log('등록 탭이 눌림');
              processPopupModal(i);
            } else {
              setState(() {
                tabIndex = i;
              });
            }
          },
          items: BottomNavItems.items),
    );
  }

  //-------------------------------------------------------------------------
  void processPopupModal(int index) async {
    final tabType = TabType.values[tabIndex];
    // Show Popup.
    var result = await showModalBottomSheet(
        context: context,
        isScrollControlled: true, // ✅ 높이 컨트롤 허용
        builder: (BuildContext context) => PopupFactory.getModalContext(
              tabType,
              onAdd: (newData) {
                setState(() {
                  collectData.insert(0, newData);
                });
              },
              onCompleteToCollect: () {
                // 모달 닫을 때 전달값으로 'goToCollect'를 넘김
                Navigator.of(context).pop('goToCollect');
              },
            ));

    if (result == 'goToCollect') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Shared.log('result == goToCollect ########');
        setState(() {
          tabIndex = TabType.collection.index; // ✅ 자동으로 컬렉션 탭으로 이동
        });
      });
    }
  }

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
            collectData.addAll(json);
            hasMore = json.length >= pageSizeFromJosnData;
          } else if (json is Map) {
            collectData.add(json);
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
}

class BottomNavItems {
  static final List<BottomNavigationBarItem> items = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      label: '홈',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.shopping_bag),
      label: '마켓',
    ),
    style.BottomNavigation.uploadButtonNavItem(), // 가운데 등록 버튼
    BottomNavigationBarItem(
      icon: Icon(Icons.video_collection),
      label: '컬렉션',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.account_circle),
      label: '계정',
    ),
  ];
}
