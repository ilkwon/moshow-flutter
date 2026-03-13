import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  final _tags = ['전체', '공방', '워크숍', '스페이스', '클래스', '전시'];
  var _selectedTag = '전체';
  @override
  void dispose() {
    // TODO: implement dispose
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).padding.top + kToolbarHeight),
        _buildSearchBar(),
        _buildTagChips(),
        Expanded(child: _buildGrid())
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: '검색',
            prefixIcon: const Icon(Icons.search, size: 20),
            filled: true,
            fillColor: const Color(0xFFF0EBE1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
          ),
        ));
  }

  Widget _buildTagChips() {
    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        itemCount: _tags.length,
        itemBuilder: (context, index) => _buildTagItem(_tags[index]),
      ),
    );
  }

  Widget _buildTagItem(String tag) {
    final bool isSelectd = tag == _selectedTag;

    return GestureDetector(
      onTap: () => setState(() => _selectedTag = tag),
      child: AnimatedContainer(
        duration: const Duration(microseconds: 200),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        decoration: BoxDecoration(
          color: isSelectd ? const Color(0xFFD4A843) : const Color(0xFFF0EBE1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          tag,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelectd ? FontWeight.w700 : FontWeight.w400,
            color: isSelectd ? Colors.white : const Color(0xFF666666),
          ),
        ),
      ),
    );
  }

  // 2열 그리드
  Widget _buildGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.8,
      ),
      itemCount: 10,
      itemBuilder: (context, index) => _buildGridItem(index),
    );
  }

// 그리드 아이템 하나
  Widget _buildGridItem(int index) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        'https://picsum.photos/400/500?random=$index',
        fit: BoxFit.cover,
      ),
    );
  }
}
