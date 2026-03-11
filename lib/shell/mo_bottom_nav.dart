import 'package:flutter/material.dart';
import 'package:moshow/common/define.dart';

//------------------------------------------------------------------------------
class MoBottomNav extends StatelessWidget {
  final TabType currentTab;
  final ValueChanged<TabType> onTabSelected;

  const MoBottomNav({
    super.key,
    required this.currentTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    
    return BottomNavigationBar(
      currentIndex: currentTab.index,
      onTap: (int i) => onTabSelected(TabType.values[i]),
      items: const [            
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '홈'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: '탐색'),
        BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: '등록'),
        BottomNavigationBarItem(icon: Icon(Icons.video_collection), label: '컬렉션'),
        BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: '프로필'),
    ]);
  }
}