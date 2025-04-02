import 'package:flutter/material.dart';
//-----------------------------------------------------------------------------
// ignore: must_be_immutable
class Home extends StatelessWidget {
  Home({super.key, this.items});
  final items;

  bool hasValue(dynamic value) {
    if (value == null) return false;
    if (value is String && value.trim().isEmpty) return false;
    if (value is List && value.isEmpty) return false;
    if (value is Map && value.isEmpty) return false;
      return true;
  }


  @override  
  Widget build(BuildContext context) {
    if (hasValue(items)){
      return ListView.builder(itemCount: items.length, itemBuilder:(c,i){
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(items[i]['image']),
            SizedBox(height: 8),
            Text('❤️ ${items[i]['likes']}개'),
            Text('@${items[i]['user']}', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(items[i]['content']),
          ],
        );
      });
    } else {
      return Text('Now Loading...');
    }
  }
}