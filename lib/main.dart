import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:moshow/common/api_client.dart';
import 'package:moshow/common/define.dart';

import 'package:moshow/screens/pop_modal.dart';

import 'package:moshow/providers/app_provider.dart';
import 'package:moshow/theme/theme_provider.dart';

import 'package:provider/provider.dart';

// moshow pages.
import 'package:moshow/common/shared.dart';
import 'package:moshow/style.dart' as style;
import 'package:moshow/screens/home.dart';
import 'package:moshow/screens/collect.dart';
///////////////////////////////////////////////////////////////////////////////
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 상태바 투명처리
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    )
  );
  
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (c) => StoreProvider()),
      ChangeNotifierProvider(create: (c) => ThemeProvider()),
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
      if (stateScroll.position.pixels >=
          stateScroll.position.maxScrollExtent - 200) {
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
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: IndexedStack(
        index: tabIndex > TabType.upload.index ? tabIndex - 1 : tabIndex,
        children: [
          Home(datas: homeData),
          Text('탐색', style: Theme.of(context).textTheme.labelLarge),
          Collect(
            datas: collectData,
            scroll: stateScroll,
            loading: isLoading,
            hasMore: hasMore,
          ),
          Text('프로필', style: Theme.of(context).textTheme.labelLarge),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          // update 현재 탭.
          currentIndex: tabIndex,
          onTap: (int i) async {
            if (i == TabType.upload.index) {
              Shared.log('등록 탭이 눌림');
              processPopupModal();
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
  void processPopupModal() async {
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
          tabIndex = TabType.collect.index; // ✅ 자동으로 컬렉션 탭으로 이동
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
          hasMore = result.length ==
              AppConfig.pageSize; // ✅ [변경3] 받은 데이터 수로 더 로딩할지 결정
        }
      });
    } catch (error) {
      Shared.log('데이터 로딩 중 오류: $error');
      setState(() => hasMore = false); // 오류 발생 시 더 이상 로딩 시도하지 않도록 설정
    }

    isLoading = false;
  }
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
