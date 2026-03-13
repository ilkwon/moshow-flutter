import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:moshow/common/define.dart';
import 'package:moshow/home/widgets/home_sub_tab.dart';
import 'package:moshow/home/widgets/post_card.dart';


//------------------------------------------------------------------------------
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.datas});

  final dynamic datas;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

//------------------------------------------------------------------------------
class _HomeScreenState extends State<HomeScreen> {
  final _pageController = PageController();
  var _currentTab = HomeTabType.recommend;

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
      body: Listener(
        onPointerSignal: _onPointerSignal,
        child: PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          physics: const ClampingScrollPhysics(),
          itemCount: widget.datas.length,
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
    final Map<String, dynamic> item = widget.datas[index];

    return PostCard(
      imageUrl: item['media_url'] as String? ?? '',
      title: item['caption'] as String? ?? '',
      location: '',
      badge: '',
    );
  }
}