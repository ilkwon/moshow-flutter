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
  final PageController _pageController = PageController();

  var _currentTab = HomeTabType.recommend;
  var _feedStatus = FeedStatus.idle;
  var _feedItems = <Map<String, dynamic>>[];
  
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
  Future<void> _loadFeed() async {
    if (_feedStatus == FeedStatus.loading) return;

    setState(() => _feedStatus = FeedStatus.loading);

    try {
      Shared.log('피드 로딩 시작');

      final List<dynamic> result = await ApiClient.instance.get('/feed');
      Shared.log('피드 결과 : ${result.length}개');
      setState(() {
        _feedItems = result.whereType<Map<String, dynamic>>().toList();
        _feedStatus = FeedStatus.done;
      });
    } catch (error) {
      Shared.log('피드 로딩 오류: $error');
      setState(() => _feedStatus = FeedStatus.error);
    }
  }
  //----------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.transparent, body: _buildBody());
  }

  //----------------------------------------------------------------------------
  Widget _buildBody() {
    if (_feedStatus == FeedStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_feedStatus == FeedStatus.error) {
      return const Center(child: Text('피드를 불러오지 못했습니다.'));
    }

    if (_feedItems.isEmpty) {
      return const SizedBox.shrink();
    }

    final double topInset =
        MediaQuery.of(context).padding.top + kToolbarHeight + 10;

    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          physics: const PageScrollPhysics(),
          itemCount: _feedItems.length,
          itemBuilder: (context, index) => _buildFeedItem(index),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: topInset,
          child: HomeSubTab(
            currentTab: _currentTab,
            onTabSelected: (tab) => setState(() => _currentTab = tab),
          ),
        ),
      ],
    );
  }

  //----------------------------------------------------------------------------
  // 피드 아이템 하나
  Widget _buildFeedItem(int index) {
    final item = _feedItems[index];
    final String type = item['type'] as String? ?? 'post';
    Shared.log('피드 아이템 username: ${item['username']}');

    if (type == 'showcase') {
      final List<Map<String, dynamic>> items = _extractShowcaseItems(item);
      return ShowcaseCard(items: items);
    }

    return PostCard(
      imageUrl: _extractPrimaryImageUrl(item),
      title: item['caption'] as String? ?? '',
      badge: type == 'sponsored' ? 'AD' : '',
      postId: item['id'] as String? ?? '',
      postUserId: item['user_id'] as String? ?? '',
      onDeleted: () => _onPostDeleted(index),
      isStared: item['is_starred'] as bool? ?? false,
      authorName: _extractAuthorName(item),
      tags: _extractTags(item),
      fullscreen: true,
      onStar: () => _onStar(
        item['id'] as String? ?? '', 
        item['is_starred'] as bool? ?? false),
    );
  }

  //----------------------------------------------------------------------------
  //
  void _onPostDeleted(int index) {
    Shared.log('🗑 게시물 삭제 콜백 호출');
    setState(() => _feedItems.removeAt(index));
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
        final index = _feedItems.indexWhere((item) => item['id'] == postId);
        if (index != -1) {
          _feedItems[index]['is_starred'] = !isStarred;
        }
      });
    } catch (error) {
      Shared.log('❌ 스타 실패: $error');
    }
  }

  List<String> _extractTags(Map<String, dynamic> item) {
    final dynamic rawTags = item['tags'];
    if (rawTags is! List) return const [];

    return rawTags
        .map((e) => e?.toString().trim() ?? '')
        .where((tag) => tag.isNotEmpty)
        .toList();
  }

  List<Map<String, dynamic>> _extractShowcaseItems(Map<String, dynamic> item) {
    final dynamic rawItems = item['items'];
    if (rawItems is! List) return const [];

    return rawItems.whereType<Map<String, dynamic>>().toList();
  }

  String _extractPrimaryImageUrl(Map<String, dynamic> item) {
    final dynamic mediaUrls = item['media_urls'];
    if (mediaUrls is List && mediaUrls.isNotEmpty) {
      return mediaUrls.first.toString();
    }
    return '';
  }

  String _extractAuthorName(Map<String, dynamic> item) {
    final candidates = [
      item['username'],
      item['author_name'],
      item['user_name'],
      item['nickname'],
      item['name'],
    ];

    for (final candidate in candidates) {
      final value = candidate?.toString().trim() ?? '';
      if (value.isNotEmpty) return value;
    }
    return '';
  }

}
