import 'package:flutter/material.dart';
import './shared.dart';

// ignore: must_be_immutable
class Home extends StatelessWidget {
  Home({super.key, this.datas});
  final datas;

  //-------------------------------------------------------------------------
  @override  
  Widget build(BuildContext context) {
    if (Shared.hasValue(datas)){
      return ListView.builder(itemCount: 2, itemBuilder:(c,i){
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Image.network('https://codingapple1.github.io/app/car0.png'),
            SizedBox(height: 4),
            Text('❤️ 100'),
            Text('글쓴이'),
            Text('글 내용'),
            
          ],
        );
      });
    } else {
      return Text('Now Loading...');
    }
  }
   
}