import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:moshow/common/define.dart';

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

//------------------------------------------------------------------------------
// MoShell의 상태 클래스
class _MoShellState extends State<MoShell> {
  /// Navigator를 위한 키
  final _navigatorKey = GlobalKey<NavigatorState>();

  /// 현재 선택된 탭
  var tabIndex = TabType.home;
  /// 피드 로딩 상태


  var _feedVersion = 0;
  var _profileVersion = 0;

  @override
  void initState() {
    super.initState();

    // 첫 렌더 후 사용자 정보 초기화
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StoreProvider>().initUser();
    });
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
            key: ValueKey(_feedVersion),                        
            onPostDeleted: () => setState(() 
              => _profileVersion++)),  // 홈 탭에서 게시글이 삭제될 때 프로필 탭도 새로고침되도록 콜백 전달
          const SearchScreen(),
          const CollectScreen(),
          ProfileScreen(
            key: ValueKey(_profileVersion), // 프로필 탭 전환 시마다 새로고침 위해 key 업데이트
          ),
        ],
      ),
      bottomNavigationBar: MoBottomNav(
          currentTab: tabIndex,
          onTabSelected: (TabType tab) async {
            // 업로드 탭 선택 시 모달로 업로드 화면 표시
            if (tab == TabType.upload) { await _tabToUpload(); }
            //else if (tab == TabType.profile){
            //  setState(() {
            //    tabIndex = tab;
            //    _profileVersion++;
            //  });
            //}
            else {
              setState(() => tabIndex = tab);
            }
          }),
    );
  }

  //--------------------------------------------------------------------------
  // 피드 새로고침
  Future<void> refreshFeed() async {
    setState(() {
       _feedVersion++;
       _profileVersion++;
    });
  }
  
  Future<void> _tabToUpload() async {
    final picker = ImagePicker();
              final List<XFile> pickedImages = await picker.pickMultiImage(
                imageQuality: 85,
              );

              // 취소시 현재 탭 유지.
              if (pickedImages.isEmpty) return;

              _navigatorKey.currentState!
                  .push(
                    MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (_) => UploadScreen(images:pickedImages),
                    ),
                  )
                  .then((_) => refreshFeed()); // 업로드 후 피드 새로고침
  }

  //--------------------------------------------------------------------------
}
