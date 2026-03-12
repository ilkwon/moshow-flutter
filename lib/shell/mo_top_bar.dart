import 'package:flutter/material.dart';
import 'package:moshow/common/define.dart';

//------------------------------------------------------------------------------
class MoTopBar extends StatelessWidget implements PreferredSizeWidget {
  final TabType currentTab;

  const MoTopBar({
    super.key,
    required this.currentTab,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AppBar(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      elevation: 0,
      leading: _buildLeading(),
      title: _buildTitle(),
      actions: _buildActions(),
    );
  }

  Widget? _buildLeading() {
    if (currentTab == TabType.home) {
      return const Icon(Icons.menu);
    }
    return null;
  }

  Widget? _buildTitle() {
    return switch (currentTab) {
      TabType.home => const Text(
        'moshow',
        style: TextStyle(color: Colors.white)),
      TabType.search => const Text('탐색'),
      TabType.collect => const Text('컬렉션'),
      TabType.profile => const Text('프로필'),
      _ => null,
    };
  }

  List<Widget> _buildActions() {
    if (currentTab == TabType.home) {
      return [
        const Icon(Icons.notifications_none),
        const SizedBox(width: 12),
      ];
    }
    return [];
  }
}
