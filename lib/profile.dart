
import 'package:flutter/material.dart';
import 'package:moshow/main.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.watch<StoreProvider>().name),),
      body: Text('프로필 페이지'),
    );
  }
}