import 'package:flutter/material.dart';

//------------------------------------------------------------------------------
class CollectScreen extends StatefulWidget {
  const CollectScreen({super.key});

  @override
  State<CollectScreen> createState() => _CollectScreenState();
}

//------------------------------------------------------------------------------
class _CollectScreenState extends State<CollectScreen> {
  var _currentTab = 0;

  final _dummyCollections = [
    {
      'title': '나무공방 모음',
      'tag': '공방',
      'count': 5,
      'imageUrl': 'https://picsum.photos/200/200?random=1'
    },
    {
      'title': '도예 클래스',
      'tag': '클래스',
      'count': 3,
      'imageUrl': 'https://picsum.photos/200/200?random=2'
    },
    {
      'title': '가죽공예 스페이스',
      'tag': '스페이스',
      'count': 7,
      'imageUrl': 'https://picsum.photos/200/200?random=3'
    },
    {
      'title': '주말 워크숍',
      'tag': '워크숍',
      'count': 2,
      'imageUrl': 'https://picsum.photos/200/200?random=4'
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).padding.top + kToolbarHeight),
        _buildSubTab(),
        Expanded(child: _buildList()),
      ],
    );
  }

  Widget _buildSubTab() {
    return Row(
      children: [_buildSubTabItem('내 컬렉션', 0), _buildSubTabItem('좋아요', 1)],
    );
  }

  //---------------------------------------------------------------------------
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
                color: isSelected
                    ? const Color(0xFFD4A843)
                    : const Color(0xFFEEEEEE),
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
              color: isSelected
                  ? const Color(0xFFD4A843)
                  : const Color(0xFF888888),
            ),
          ),
        ),
      ),
    );
  }
  
  //---------------------------------------------------------------------------
  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _dummyCollections.length,
      itemBuilder: (context, index) => _buildListItem(_dummyCollections[index]),
    );
  }
  
  //---------------------------------------------------------------------------
  Widget _buildListItem(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F0E8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(children: [
        // 썸네일
        _buildThumbnail(item),
        const SizedBox(width: 12),
        Expanded(child: _buildInfo(item)),
        _buildTrailing(item['count'] as int),
      ]),
    );
  }

  //---------------------------------------------------------------------------
  Widget _buildThumbnail(Map<String, dynamic> item) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          item['imageUrl']  as String,
          width: 64,
          height: 64,
          fit: BoxFit.cover,
        ),
      );
  }
  
  //---------------------------------------------------------------------------
  Widget _buildInfo(Map<String, dynamic> item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item['title'] as String,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '#${item['tag']}',
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF888888),
          ),
        ),
      ],
    );
  }
  
  //---------------------------------------------------------------------------
  Widget _buildTrailing(int count) {
    return Row(
      children: [
        Text(
          '$count개',
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF888888),
          ),
        ),
        const SizedBox(width: 8),
        const Icon(Icons.drag_handle, color: Color(0xFFCCCCCC)),
      ],
    );
  }
  //---------------------------------------------------------------------------
}
