import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moshow/common/api_client.dart';
import 'package:moshow/common/define.dart';
import 'package:moshow/common/providers/app_provider.dart';
import 'package:moshow/common/shared.dart';
import 'package:provider/provider.dart';

//------------------------------------------------------------------------------
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

//------------------------------------------------------------------------------
class _ProfileScreenState extends State<ProfileScreen> {
  var _currentTab = 0;
  var _profileStatus = FeedStatus.idle;
  Map<String, dynamic>? _profile;
  var _posts = <dynamic>[];

  @override
  void initState() {
    super.initState();
  }

  //----------------------------------------------------------------------------
  Future<void> _loadData(String userId) async {
    setState(() => _profileStatus = FeedStatus.loading);

    try {
      final profile = await ApiClient.instance.get('/users/?id=$userId');
      Shared.log('✅ 프로필 데이터 로드 성공: $profile');
      final posts = await ApiClient.instance.get('/users/$userId/posts');
      setState(() {
        _profile = profile;
        _posts = posts;
        _profileStatus = FeedStatus.done;
      });
    } catch (error) {
      Shared.log('❌ 프로필 로딩 오류: $error');
      setState(() => _profileStatus = FeedStatus.error);
    }
  }

  //----------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final String? userId = context.watch<StoreProvider>().userId;

    if (userId != null && _profileStatus == FeedStatus.idle) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadData(userId));
    }

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

  //----------------------------------------------------------------------------
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildAvatar(),
          const SizedBox(height: 12),
          _buildUsername(),
          const SizedBox(height: 4),
          _buildBio(),
          const SizedBox(height: 20),
          _buildStats(),
        ],
      ),
    );
  }

  //----------------------------------------------------------------------------
  Widget _buildAvatar() {
    final String? imageUrl = _profile?['profile_image'] as String?;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      return CircleAvatar(
        radius: 48,
        backgroundImage: NetworkImage(imageUrl),
      );
    }

    return const CircleAvatar(
      radius: 48,
      backgroundColor: Color(0xFFE0D8CC),
      child: Icon(Icons.person, size: 48, color: Color(0xFF888888)),
    );
  }

  //----------------------------------------------------------------------------
  Widget _buildUsername() {
    final String username = _profile?['username'] as String? ?? '';

    return Text(
      username,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Color(0xFF1A1A2E),
      ),
    );
  }

  //----------------------------------------------------------------------------
  Widget _buildBio() {
    final String bio = _profile?['bio'] as String? ?? '';

    if (bio.isEmpty) return const SizedBox.shrink();

    return Text(
      bio,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 14,
        color: Color(0xFF888888),
      ),
    );
  }

  //----------------------------------------------------------------------------
  Widget _buildStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatItem('팔로워', _profile?['follower_count'] as int? ?? 0),
        _buildStatItem('팔로잉', _profile?['following_count'] as int? ?? 0),
        _buildStatItem('게시물', _profile?['post_count'] as int? ?? 0),
      ],
    );
  }

  //----------------------------------------------------------------------------
  Widget _buildStatItem(String label, int count) {
    return Column(
      children: [
        Text(
          '$count',
          style: const TextStyle(
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
        ),
      ],
    );
  }

  //----------------------------------------------------------------------------
  Widget _buildSubTab() {
    final tabs = ['내 게시물', '스타'];

    return Row(
      children: tabs
          .asMap()
          .entries
          .map((entry) => _buildSubTabItem(entry.value, entry.key))
          .toList(),
    );
  }

  //----------------------------------------------------------------------------
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
              fontSize: 13,
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

  //----------------------------------------------------------------------------
  SliverGrid _buildGrid() {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) => _buildGridItem(index),
        childCount: _posts.length,
      ),
    );
  }

  //----------------------------------------------------------------------------
  Widget _buildGridItem(int index) {
    final Map<String, dynamic> post = _posts[index];
    final String imageUrl =
        (post['media_urls'] as List<dynamic>?)?.first as String? ?? '';

    return Image.network(imageUrl, fit: BoxFit.cover);
  }

  //----------------------------------------------------------------------------
}
