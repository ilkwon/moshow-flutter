import 'package:flutter/material.dart';
import './shared.dart';

// ignore: must_be_immutable
class Collect extends StatelessWidget {
  Collect({super.key, this.datas});
  final datas;
  

  //-------------------------------------------------------------------------
  @override  
  Widget build(BuildContext context) {
    if (Shared.hasValue(datas)){
      return ListView.builder(itemCount: datas.length, itemBuilder:(c,i){
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(datas[i]['image']),
            SizedBox(height: 8),
            Text('❤️ ${datas[i]['likes']}개'),
            Text('@${datas[i]['user']}', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(datas[i]['content']),
          ],
        );
      });
    } else {
      return Text('Now Loading...');
    }
  }
 
  //-------------------------------------------------------------------------
}