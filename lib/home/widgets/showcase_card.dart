import 'package:flutter/material.dart';
import 'package:moshow/home/widgets/post_card.dart';

//------------------------------------------------------------------------------
class ShowcaseCard extends StatelessWidget {
  final List<Map<String, dynamic>> items;

  const ShowcaseCard({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: items.length,
          itemBuilder: (context, index) => _buildItem(items[index]),
        ),
        if (items.length > 1) ..._buildArrows(),
      ],
    );
  }

  //----------------------------------------------------------------------------
  // showcase 아이템 카드 — post_id, media_urls, caption
  Widget _buildItem(Map<String, dynamic> item) {
    return PostCard(
      imageUrl: (item['media_urls'] as List<dynamic>?)?.first as String? ?? '',
      title: item['caption'] as String? ?? '',
      badge: 'showcase',
      postId: item['post_id'] as String? ?? '',
      postUserId: '',
      fullscreen: true,
    );
  }

  //----------------------------------------------------------------------------
  // 좌우 스와이프 화살표
  List<Widget> _buildArrows() {
    return [
      const Positioned(
        left: 12,
        top: 0,
        bottom: 0,
        child: Center(
          child: Icon(Icons.chevron_left, color: Colors.white70, size: 36),
        ),
      ),
      const Positioned(
        right: 12,
        top: 0,
        bottom: 0,
        child: Center(
          child: Icon(Icons.chevron_right, color: Colors.white70, size: 36),
        ),
      ),
    ];
  }
}
