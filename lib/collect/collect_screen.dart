import 'package:flutter/material.dart';
import 'package:moshow/collect/create_collection_sheet.dart';
import 'package:moshow/common/api_client.dart';
import 'package:moshow/common/define.dart';
import 'package:moshow/common/providers/app_provider.dart';
import 'package:moshow/common/shared.dart';
import 'package:provider/provider.dart';

//------------------------------------------------------------------------------
// 컬렉션 화면 — 내 컬렉션 / 공개 컬렉션 탭
//------------------------------------------------------------------------------
class CollectScreen extends StatefulWidget {
  const CollectScreen({super.key});

  @override
  State<CollectScreen> createState() => _CollectScreenState();
}

//------------------------------------------------------------------------------
class _CollectScreenState extends State<CollectScreen> {
  var _currentTab = 0;           // 0: 내 컬렉션, 1: 공개 컬렉션
  var _selectedCategory = '전체'; // 공개 탭 카테고리 필터
  var _myCollections = <dynamic>[];
  var _publicCollections = <dynamic>[];
  var _status = FeedStatus.idle;

  final _categories = ['전체', '공방', '클래스', '스페이스', '워크숍'];

  @override
  void initState() {
    super.initState();
  }

  //----------------------------------------------------------------------------
  // 내 컬렉션 + 공개 컬렉션 동시 로드
  Future<void> _loadData(String userId) async {
    setState(() => _status = FeedStatus.loading);

    try {
      final my = await ApiClient.instance.get('/collections?user_id=$userId');
      final public = await ApiClient.instance.get('/collections?is_public=true');
      setState(() {
        _myCollections = my;
        _publicCollections = public;
        _status = FeedStatus.done;
      });
    } catch (error) {
      Shared.log('❌ 컬렉션 로딩 오류: $error');
      setState(() => _status = FeedStatus.error);
    }
  }

  //----------------------------------------------------------------------------
  // 새 컬렉션 생성 후 목록 갱신
  Future<void> _createCollection(String title, String tag) async {
    final String? userId = context.read<StoreProvider>().userId;
    if (userId == null) return;

    try {
      await ApiClient.instance.post('/collections', {
        'user_id': userId,
        'title': title,
        'tag': tag,
      });
      await _loadData(userId);
    } catch (error) {
      Shared.log('❌ 컬렉션 생성 오류: $error');
    }
  }

  //----------------------------------------------------------------------------
  // 새 컬렉션 만들기 바텀시트 표시
  void _showCreateCollectionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => CreateCollectionSheet(onCreated: _createCollection),
    );
  }

  //----------------------------------------------------------------------------
  // userId 세팅 완료 시점에 데이터 로드 트리거
  @override
  Widget build(BuildContext context) {
    final String? userId = context.watch<StoreProvider>().userId;

    if (userId != null && _status == FeedStatus.idle) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadData(userId));
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: _buildBody(context),
      floatingActionButton: _currentTab == 0
          ? FloatingActionButton(
              onPressed: () => _showCreateCollectionSheet(context),
              backgroundColor: const Color(0xFFD4A843),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }

  //----------------------------------------------------------------------------
  // 탭 + 카테고리 칩 + 그리드 세로 배치
  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).padding.top + kToolbarHeight),
        _buildSubTab(),
        if (_currentTab == 1) _buildCategoryChips(),
        Expanded(child: _buildGrid()),
      ],
    );
  }

  //----------------------------------------------------------------------------
  // 내 컬렉션 / 공개 컬렉션 탭 바
  Widget _buildSubTab() {
    final tabs = ['내 컬렉션', '공개 컬렉션'];

    return Row(
      children: tabs
          .asMap()
          .entries
          .map<Widget>((entry) => _buildSubTabItem(entry.value, entry.key))
          .toList(),
    );
  }

  //----------------------------------------------------------------------------
  // 탭 아이템 — 선택 시 골드 언더라인
  Widget _buildSubTabItem(String label, int index) {
    final bool isSelected = _currentTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _currentTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? const Color(0xFFD4A843) : const Color(0xFFEEEEEE),
                width: isSelected ? 2 : 1,
              ),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
              color: isSelected ? const Color(0xFFD4A843) : const Color(0xFF888888),
            ),
          ),
        ),
      ),
    );
  }

  //----------------------------------------------------------------------------
  // 공개 컬렉션 탭 — 카테고리 필터 칩 (전체/공방/클래스/스페이스/워크숍)
  Widget _buildCategoryChips() {
    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;

          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = category),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFD4A843) : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? const Color(0xFFD4A843) : const Color(0xFFDDDDDD),
                ),
              ),
              child: Text(
                category,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                  color: isSelected ? Colors.white : const Color(0xFF888888),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  //----------------------------------------------------------------------------
  // 탭에 따라 내 컬렉션 / 필터된 공개 컬렉션 그리드
  Widget _buildGrid() {
    final data = _currentTab == 0 ? _myCollections : _filteredPublicCollections;

    if (data.isEmpty) {
      return const Center(
        child: Text('컬렉션이 없어요', style: TextStyle(color: Color(0xFF888888))),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: data.length,
      itemBuilder: (context, index) => _buildGridItem(data[index]),
    );
  }

  //----------------------------------------------------------------------------
  // 선택된 카테고리로 공개 컬렉션 필터링
  List<dynamic> get _filteredPublicCollections {
    if (_selectedCategory == '전체') return _publicCollections;
    return _publicCollections
        .where((c) => c['tag'] == _selectedCategory)
        .toList();
  }

  //----------------------------------------------------------------------------
  // 컬렉션 카드 — 커버 이미지 + 제목 + 비공개 자물쇠 / 공개 유저명
  Widget _buildGridItem(Map<String, dynamic> item) {
    final bool isPublic = _currentTab == 1;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(color: const Color(0xFFD4C4A8)),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black54],
              ),
            ),
          ),
          Positioned(
            left: 8,
            right: 8,
            bottom: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'] as String? ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (isPublic)
                  Text(
                    '@${item['user_id']?.toString().substring(0, 8) ?? ''}',
                    style: const TextStyle(color: Colors.white70, fontSize: 11),
                  ),
              ],
            ),
          ),
          if (_currentTab == 0 && item['is_published'] == false)
            const Positioned(
              top: 8,
              right: 8,
              child: Icon(Icons.lock_outline, color: Colors.white70, size: 16),
            ),
        ],
      ),
    );
  }

  //----------------------------------------------------------------------------
}


//------------------------------------------------------------------------------
