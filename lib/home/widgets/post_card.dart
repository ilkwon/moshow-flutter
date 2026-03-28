import 'package:flutter/material.dart';
import 'package:moshow/common/api_client.dart';
import 'package:moshow/common/providers/app_provider.dart';
import 'package:moshow/common/shared.dart';
import 'package:provider/provider.dart';

//------------------------------------------------------------------------------
class PostCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String location;
  final String badge;
  final String postId;
  final String postUserId;
  final VoidCallback? onDeleted;

  final bool isStared; 
  final VoidCallback? onStar; 

  const PostCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.location,
    required this.badge,
    required this.postId,
    required this.postUserId,
    this.onDeleted,
    this.isStared = false,
    this.onStar,
  });

  //----------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _buildImage(),
        _buildGradient(),
        _buildInfo(context),
        Positioned(
          top: MediaQuery.of(context).padding.top + kToolbarHeight + 8,
          right: 8,
          child: _buildMenuButton(context),
        ),
      ],
    );
  }

  //----------------------------------------------------------------------------
  Widget _buildImage() {
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stack) {
        Shared.log('❌ 이미지 로딩 실패: $error');
        return const ColoredBox(color: Colors.red);
      },
    );
  }

  //----------------------------------------------------------------------------
  Widget _buildGradient() {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black54],
        ),
      ),
    );
  }

  //----------------------------------------------------------------------------
  Widget _buildInfo(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        MediaQuery.of(context).padding.top + kToolbarHeight + 12,
        16,
        MediaQuery.of(context).padding.bottom + 80,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (badge.isNotEmpty) _buildBadge(),
          const Spacer(),
          _buildTitle(),
          const SizedBox(height: 4),
          _buildLocation(),
          _buildStarButton(),
        ],
      ),
    );
  }

  //----------------------------------------------------------------------------
  Widget _buildBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        badge,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }

  //----------------------------------------------------------------------------
  Widget _buildTitle() {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  //----------------------------------------------------------------------------
  Widget _buildLocation() {
    return Row(
      children: [
        const Icon(Icons.location_on, color: Colors.white70, size: 14),
        const SizedBox(width: 4),
        Text(
          location,
          style: const TextStyle(color: Colors.white70, fontSize: 13),
        ),
      ],
    );
  }

  //----------------------------------------------------------------------------
  Widget _buildMenuButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _showMenu(context),
      child: const Icon(Icons.more_vert, color: Colors.white),
    );
  }
  
  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => SafeArea(child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.delete_outline, color: Colors.red),
            title: const Text('삭제', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(sheetContext);
              _deletePost(context);
            },
          )
        ],
      ))
    );
  }
  
  void _deletePost(BuildContext context) async {
    final String? userId =  Provider.of<StoreProvider>(context, listen: false).userId;

    try{
      await ApiClient.instance.delete('/posts', {
        'user_id': userId,
        'post_id': postId,
    });
      Shared.log('✅ 삭제 완료, 콜백 호출');
      onDeleted?.call();
    } catch (error){
      Shared.log('삭제 실패: $error');
    }
  }
  
  Widget _buildStarButton() {
    return GestureDetector(
      onTap: onStar,
      child: Icon(
        isStared ? Icons.star : Icons.star_border,
        color: isStared ? const Color(0xFFD4A843) : Colors.white,
        size: 28,
      ),      
    );
  }
  //----------------------------------------------------------------------------
}