import 'package:flutter/material.dart';

class PopModalMarket extends StatelessWidget 
{
  PopModalMarket({super.key, this.onAdd, this.onComplete});
  final Function(Map<String, dynamic>)? onAdd;
  final Function()? onComplete;
  
  @override
  Widget build(BuildContext context) {
    return  Column(
          mainAxisSize: MainAxisSize.min, // ✅ 내용 높이에 맞게 조절
          children: [
            const Text(
              '마켓 팝업',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: const Text('판매 등록'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              child: const Text('트레이드 등록'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // 닫기
              },
              child: const Text('닫기'),
            ),
          ],
        );
  }
}
