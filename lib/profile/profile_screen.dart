import 'package:flutter/material.dart';

//------------------------------------------------------------------------------
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

//------------------------------------------------------------------------------
class _ProfileScreenState extends State<ProfileScreen> {
  var _currentTab = 0;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: SizedBox(
            height: MediaQuery.of(context).padding.top + kToolbarHeight,
          ),
        ),
        SliverToBoxAdapter(child: _buildHeader()),
        SliverToBoxAdapter(child: _buildSubTab()),
        _buildGrid(),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          _buildAvatar(),
          const SizedBox(width: 24),
          Expanded(child: _buildStats()),
        ],
      ),
    );
  }

  Widget _buildSubTab() {
    final tabs = ['내 쇼케이스', '좋아요', '저장됨'];

    return Row(
      children: tabs
        .asMap()
        .entries
        .map((entry) => _buildSubTabItem(entry.value, entry.key)).toList(),
    );
  }

  SliverGrid _buildGrid() {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) => _buildGridItem(index),
        childCount: 12,
      ),
    );
  }

  Widget _buildAvatar() {
    return const CircleAvatar(
      radius: 36,
      backgroundColor: Color(0xFFE0D8CC),
      child: Icon(Icons.person, size: 36, color: Color(0xFF888888)),
    );
  }

  _buildStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem('쇼케이스', 12),
        _buildStatItem('팔로워', 128),
        _buildStatItem('팔로잉', 64),
      ],
    );
  }

  Widget _buildStatItem(String label, int count) {
    return Column(
      children: [
        Text(
          '$count',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A2E),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF888888),
          ),
        )
      ],
    );
  }
  
  Widget _buildSubTabItem(String label, int index) {
    final bool isSelected = _currentTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _currentTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom:BorderSide(
                color: isSelected 
                ? const Color(0xFFD4A843)
                : const Color(0xFFEEEEEE),
                width: isSelected ? 2 : 3,
              ),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
              color: isSelected 
              ? const Color(0xFFD4A843)
              : const Color(0xFF888888)
            ),
          ),
        ),
      ));
  }
  
  Widget _buildGridItem(int index) {
    return Image.network('https://picsum.photos/200/200?randome=$index', fit: BoxFit.cover);
  }
}
