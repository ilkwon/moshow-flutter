import 'package:flutter/material.dart';
import 'package:moshow/common/define.dart';
import 'package:moshow/common/providers/app_provider.dart';
import 'package:provider/provider.dart';

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
    return AppBar(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      elevation: 0,
      bottom: PreferredSize(preferredSize: const Size.fromHeight(1),
       child: Container(
        height: 1,
        color: Colors.white.withValues(alpha: 0.2),
       )),
      leading: _buildLeading(),
      title: _buildTitle(context),
      actions: _buildActions(context),
    );
  }

  Widget? _buildLeading() {
    if (currentTab == TabType.home) {
      return const Icon(Icons.menu);
    }
    return null;
  }

  Widget? _buildTitle(BuildContext context) {
    return switch (currentTab) {
      TabType.home => const Text(
        'moshow',
        style: TextStyle(color: Colors.white)),
      TabType.search => const Text('탐색'),
      TabType.collect => const Text('컬렉션'),
      TabType.profile => _buildProfileTitle(context),
      _ => null,
    };
  }

  List<Widget> _buildActions(BuildContext context) {
    if (currentTab == TabType.home) {
      return [
        const Icon(Icons.notifications_none),
        const SizedBox(width: 12),
      ];
    }
    return [];
  }
  
  Widget _buildProfileTitle(BuildContext context) {    
    final String? username = Provider.of<StoreProvider>(context, listen: false).username;
    return Text(username != null ? '@$username' : '프로필');
  }
}