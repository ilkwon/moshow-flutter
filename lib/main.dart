import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:moshow/common/api_client.dart';
import 'package:moshow/common/define.dart';
import 'dart:convert';
import 'package:moshow/pop_modal.dart';

import 'package:moshow/providers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

// moshow pages.
import 'common/shared.dart';
import './style.dart' as style;
import './home.dart';
import './collect.dart';

///////////////////////////////////////////////////////////////////////////////
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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

  bool isLoading = false;
  bool hasMore = true;

  // state vars
  var tabIndex = 0;
  dynamic homeData = [];
  dynamic collectData = [];

  var stateScroll = ScrollController();
  
  //-------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    
    // 앱 시작 시 게스트 로그인.(SharedPreferences에서 user_id 확인 후 없으면 API로 게스트 생성)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StoreProvider>().initUser();
    });

    // 스크롤 끝 감지해서 데이터 추가 로딩.
    stateScroll.addListener(() {
      if (stateScroll.position.pixels >= stateScroll.position.maxScrollExtent - 200) {
        Shared.log('스크롤 끝 감지, 추가 데이터 로딩 시도');
        loadFeeds();
      }
    });
    loadFeeds();

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
  // 등록 팝업 처리 함수
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

  // 데이터 로딩 함수 (스크롤 끝 감지 시 호출)
  void loadFeeds() async {
    Shared.log('🔄 loadFeeds() 호출됨'); // ← 추가
    if (isLoading || !hasMore) return; // ✅ [변경1] 더 이상 로딩할 게 없으면 종료
    Shared.log('🔄 loadFeeds() hasMore: $hasMore'); //
    isLoading = true;

    try {
      Shared.log('🌐 API 요청 시작'); // ← 추가
      final List<dynamic> result = await ApiClient.instance.get('/feed');
      Shared.log('🌐 API 요청 완료, 받은 데이터 수: ${result.length}'); 
      setState(() {
        if (result.isEmpty) {
          hasMore = false; // ✅ [변경2] 빈 데이터가 오면 더 이상 로딩할 게 없는 것으로 간주
        } else {
          collectData.addAll(result);
          homeData = result; // 홈은 최신 3개만 보여주기.
          hasMore = result.length == pageSize; // ✅ [변경3] 받은 데이터 수로 더 로딩할지 결정
        }        
      });
    } catch (error) {
      Shared.log('데이터 로딩 중 오류: $error');
      setState(() => hasMore = false ); // 오류 발생 시 더 이상 로딩 시도하지 않도록 설정      
    } 

    isLoading = false;
  }  
}
//-------------------------------------------------------------------------
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
