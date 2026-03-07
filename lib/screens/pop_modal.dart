import 'package:flutter/material.dart';
import 'package:moshow/common/define.dart';
import 'package:moshow/screens/pop_modal_collection.dart';
import 'package:moshow/screens/pop_modal_market.dart';


class PopupFactory{
  static Widget getModalContext(TabType tabType, {
    required Function(Map<String, dynamic>) onAdd,
    required VoidCallback onCompleteToCollect,
    }){
      switch (tabType) {
        case TabType.search:
          return PopModalMarket(
            onAdd: onAdd,
            onComplete: onCompleteToCollect,
          );
        case TabType.collect:
          return PopModalCollection(
            onAdd: onAdd,
            onComplete: onCompleteToCollect,
          );
        default:
          return PopModalDefault(
            onComplete: () {}
          );
    }
  }
}

class PopModalDefault extends StatelessWidget 
{
  PopModalDefault({super.key, this.onAdd, this.onComplete});
  final Function(Map<String, dynamic>)? onAdd;
  final Function()? onComplete;
  
  @override
  Widget build(BuildContext context) {
    return Column(
          mainAxisSize: MainAxisSize.min, // ✅ 내용 높이에 맞게 조절
          children: [
            const Text(
              '기본 팝업',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: const Text('미정 1'),
              
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              child: const Text('미정 2'),
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
