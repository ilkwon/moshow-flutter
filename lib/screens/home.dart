import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key, this.datas});

  final dynamic datas;

  @override
  Widget build(BuildContext context) {
    if (datas == null || datas.isEmpty) {
      return const Center(child: Text('Now Loading...'));
    }
    return ListView.builder(
      itemCount: datas.length,
      itemBuilder: (context, index) => _FeedItem(item: datas[index]),
    );
  }
}

// ----------------------------------------------------------------------------
// 피드 아이템
// ----------------------------------------------------------------------------
class _FeedItem extends StatelessWidget {
  const _FeedItem({required this.item});

  final Map<String, dynamic> item;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildImage(),
        _buildInfo(),
      ],
    );
  }

  Widget _buildImage() {
    if (item['media_url'] == null) return const SizedBox.shrink();
    return Image.network(
      item['media_url'],
      fit: BoxFit.cover,
      width: double.infinity,
    );
  }

  Widget _buildInfo() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('@${item['user_id']}'),
          const SizedBox(height: 4),
          Text(item['caption'] ?? ''),
        ],
      ),
    );
  }
}