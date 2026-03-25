import 'package:flutter/material.dart';
import 'package:moshow/common/api_client.dart';
import 'package:moshow/common/define.dart';
import 'package:moshow/common/shared.dart';
import 'package:moshow/common/providers/app_provider.dart';
import 'package:moshow/shell/mo_bottom_nav.dart';
import 'package:moshow/shell/mo_top_bar.dart';
import 'package:moshow/upload/upload_screen.dart';
import 'package:provider/provider.dart';

import 'package:moshow/home/home_screen.dart';
import 'package:moshow/search/search_screen.dart';
import 'package:moshow/collect/collect_screen.dart';
import 'package:moshow/profile/profile_screen.dart';

/// 앱의 메인 셸 위젯
class MoShell extends StatefulWidget {
  const MoShell({super.key});

  @override
  State<StatefulWidget> createState() => _MoShellState();
}

/// MoShell의 상태 클래스
class _MoShellState extends State<MoShell> {
  /// Navigator를 위한 키
  final _navigatorKey = GlobalKey<NavigatorState>();

  /// 현재 선택된 탭
  var tabIndex = TabType.home;
  /// 피드 로딩 상태
  var feedStatus = FeedStatus.idle;

  /// 추가 데이터 여부
  var hasMore = true;
  /// 홈 피드 데이터
  dynamic homeData = [];
  
  @override
  void initState() {
    super.initState();

    // 첫 렌더 후 사용자 정보 초기화
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StoreProvider>().initUser();
    });

    // 피드 데이터 로드
    loadFeed();
  }

  //-------------------------------------------------------
  /// 피드 데이터 로드
  Future<void> loadFeed() async {
    // 이미 로딩 중이거나 더 이상 데이터가 없으면 종료
    if (feedStatus == FeedStatus.loading || !hasMore) return;
    setState(() => feedStatus = FeedStatus.loading);

    try {
      // API에서 피드 데이터 가져오기
      final List<dynamic> result = await ApiClient.instance.get('/feed');
      setState(() {
        if (result.isEmpty) {
          hasMore = false;
          feedStatus = FeedStatus.done;
        } else {
          homeData = result;

          hasMore = result.length == AppConfig.pageSize;
          feedStatus = FeedStatus.done;
        }
      });
    } catch (error) {
      // 오류 발생 시 상태 변경
      Shared.log('피드 로딩 오류: $error');
      setState(() {
        hasMore = false;
        feedStatus = FeedStatus.error;
      });
    }
  }

  //---------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    // upload는 모달이라 IndexedStack에서 제외

    return Center(
        child: SizedBox(
      width: 480,
      height: MediaQuery.of(context).size.height.clamp(0, 853),
      // Navigator로 화면 전환 관리
      child: Navigator(
          key: _navigatorKey,
          onGenerateRoute: (_) => MaterialPageRoute(
                builder: (_) => _buildShell(),
              )),
    ));
  }

  //---------------------------------------------------------
  /// 셸 UI 빌드
  Widget _buildShell() {
    // home=0, search=1, collect=2, profile=3
    // upload는 모달이므로 stack에서 제외
    final stackIndex = tabIndex.index > TabType.upload.index
        ? tabIndex.index - 1
        : tabIndex.index;

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: MoTopBar(currentTab: tabIndex),
      body: IndexedStack(
        index: stackIndex,
        children: [
          HomeScreen(
            datas: homeData,
          ),
          const SearchScreen(),
          const CollectScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: MoBottomNav(
          currentTab: tabIndex,
          onTabSelected: (TabType tab) {
            // 업로드 탭 선택 시 모달로 업로드 화면 표시
            if (tab == TabType.upload) {
              _navigatorKey.currentState!
                  .push(
                    MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (_) => const UploadScreen(),
                    ),
                  )
                  .then((_) => refreshFeed()); // 업로드 후 피드 새로고침
            } else {
              setState(() => tabIndex = tab);
            }
          }),
    );
  }

  //--------------------------------------------------------------------------
  /// 피드 새로고침
  Future<void> refreshFeed() async {
    setState(() {
      hasMore = true;
      feedStatus = FeedStatus.idle;
      homeData = [];
    });

    await loadFeed();
  }

  //--------------------------------------------------------------------------
}
