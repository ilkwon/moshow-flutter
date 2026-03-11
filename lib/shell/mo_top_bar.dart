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
      leading: _buildLeading(),
      title:_buildTitle(),
      actions: _buildActions(),
    );
  }
  
  Widget? _buildLeading() {}

  Widget? _buildTitle() {}

  List<Widget> _buildActions() {
    return [];
  }
}