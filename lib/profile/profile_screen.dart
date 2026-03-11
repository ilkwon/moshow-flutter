
import 'package:flutter/material.dart';

import 'package:moshow/common/providers/app_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  SliverGridDelegate gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.watch<StoreProvider>().name),),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child:ProfileHeader()),
          SliverGrid(delegate: SliverChildBuilderDelegate((c, i) => Container(color:Colors.grey),
            childCount: 13,
          ), gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2))
        ],
      )
    );
  }
}

//---------------------------------------------------------------------------
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [        
          CircleAvatar(radius: 30, backgroundColor: Colors.grey),
          Text('팔로워 ${context.watch<StoreProvider>().follower}명'),
          ElevatedButton(onPressed: () { 
            context.read<StoreProvider>().addFollower();},
            child: Text('팔로우')
          )    
        ],
    );
  }
}

//---------------------------------------------------------------------------