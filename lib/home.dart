import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  Home({super.key, this.datas});
  final dynamic datas;

  @override
  Widget build(BuildContext context) {
    if (datas == null || datas.isEmpty) {
      return const Center(child: Text('Now Loading...'));
    }

    return ListView.builder(
      itemCount: datas.length,
      itemBuilder: (context, index) {
        final item = datas[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 이미지 — media_url이 없으면 빈 박스
            if (item['media_url'] != null)
              Image.network(
                item['media_url'],
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('@${item['user_id']}'),
                  const SizedBox(height: 4),
                  Text(item['caption'] ?? ''),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}