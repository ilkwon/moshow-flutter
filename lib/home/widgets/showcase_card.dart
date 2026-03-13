
import 'package:flutter/material.dart';
import 'package:moshow/home/widgets/post_card.dart';

//------------------------------------------------------------------------------
class ShowcaseCard extends StatelessWidget {
  final List<Map<String, dynamic>>  items;
  
  const ShowcaseCard({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: items.length,
      itemBuilder: (context, index) => _buildItem(items[index]),
    );
  }
  
  Widget _buildItem(Map<String, dynamic> item) {
    return PostCard(
      imageUrl: item['imageUrl'] as String? ?? '',
      title: item['title'] as String? ?? '', 
      location: item['location'] as String? ?? '', 
      badge: item['badge'] as String? ?? ''
    );
  }
}