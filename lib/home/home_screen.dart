import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:moshow/common/api_client.dart';
import 'package:moshow/common/define.dart';
import 'package:moshow/common/providers/app_provider.dart';
import 'package:moshow/common/shared.dart';
import 'package:moshow/home/widgets/home_sub_tab.dart';
import 'package:moshow/home/widgets/post_card.dart';
import 'package:moshow/home/widgets/showcase_card.dart';
import 'package:provider/provider.dart';

//------------------------------------------------------------------------------
class HomeScreen extends StatefulWidget {
  final VoidCallback? onPostDeleted;
  const HomeScreen({super.key, this.onPostDeleted});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

//------------------------------------------------------------------------------
class _HomeScreenState extends State<HomeScreen> {
  final _pageController = PageController();
  var _currentTab = HomeTabType.recommend;
  var _feedStatus = FeedStatus.idle;
  var _datas = <dynamic>[];

  @override
  void initState() {
    super.initState();
    _loadFeed();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  //----------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 0,
        bottom: HomeSubTab(
          currentTab: _currentTab,
          onTabSelected: (tab) => setState(() => _currentTab = tab),
        ),
      ),
      body: _datas.isEmpty
          ? const SizedBox.shrink()
          : Listener(
              onPointerSignal: _onPointerSignal,
              child: PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                physics: const ClampingScrollPhysics(),
                itemCount: _datas.length,
                itemBuilder: (context, index) => _buildFeedItem(index),
              ),
            ),
    );
  }

  //----------------------------------------------------------------------------
  void _onPointerSignal(PointerSignalEvent event) {
    if (event is! PointerScrollEvent) return;

    if (event.scrollDelta.dy > 0) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  //----------------------------------------------------------------------------
  // 피드 아이템 하나
  Widget _buildFeedItem(int index) {
    Shared.log('카드 빌드 : $index');
    final Map<String, dynamic> item = _datas[index];
    final String type = item['type'] as String? ?? 'post';
    Shared.log('🖼 imageUrl: ${(item['media_urls'] as List<dynamic>?)?.first}');
    if (type == 'showcase') {
      return ShowcaseCard(items: const []);
    }

    return PostCard(
      //imageUrl: item['media_url'] as String? ?? '',
      imageUrl: (item['media_urls'] as List<dynamic>?)?.first as String? ?? '',
      title: item['caption'] as String? ?? '',
      location: '',
      badge: type == 'sponsored' ? 'AD' : '',
      postId: item['id'] as String? ?? '',
      postUserId: item['user_id'] as String? ?? '',
      onDeleted: () => _onPostDeleted(index),
      isStared: item['is_starred'] as bool? ?? false,
      onStar: () => _onStar(
        item['id'] as String? ?? '', 
        item['is_starred'] as bool? ?? false),
    );
  }

  //----------------------------------------------------------------------------
  Future<void> _loadFeed() async {
    if (_feedStatus == FeedStatus.loading) return;

    setState(() => _feedStatus = FeedStatus.loading);

    try {
      Shared.log('피드 로딩 시작');

      final List<dynamic> result = await ApiClient.instance.get('/feed');

      Shared.log('피드 결과 : ${result.length}개');
      setState(() {
        _datas = result;
        _feedStatus = FeedStatus.done;
      });
    } catch (error) {
      Shared.log('피드 로딩 오류: $error');
      setState(() => _feedStatus = FeedStatus.error);
    }
  }

  void _onPostDeleted(int index) {
    Shared.log('🗑 게시물 삭제 콜백 호출');
    setState(() => _datas.removeAt(index));
    widget.onPostDeleted?.call();
  }

  Future<void> _onStar(String postId, bool isStarred) async {
    final String? userId =
        Provider.of<StoreProvider>(context, listen: false).userId;

    try {
      Shared.log('⭐ 스타 요청 - postId: $postId, userId: $userId, isStarred: $isStarred');
      if (isStarred) {
        await ApiClient.instance.delete('/ratings', {
          'user_id': userId,
          'post_id': postId,
        });
        Shared.log('⭐ 스타 취소');
      } else {        
        await ApiClient.instance.post('/ratings', {
          'user_id': userId,
          'post_id': postId,
        });
        Shared.log('⭐ 스타 완료');
      }

      setState(() {
        final index = _datas.indexWhere((item) => item['id'] == postId);
        if (index != -1) {
          _datas[index]['is_starred'] = !isStarred;
        }
      });
    } catch (error) {
      Shared.log('❌ 스타 실패: $error');
    }
  }

  //----------------------------------------------------------------------------
}
