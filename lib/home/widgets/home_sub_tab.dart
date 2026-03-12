import 'package:flutter/material.dart';
import 'package:moshow/common/define.dart';

//------------------------------------------------------------------------------
class HomeSubTab extends StatelessWidget implements PreferredSizeWidget {
  final HomeTabType currentTab;
  final ValueChanged<HomeTabType> onTabSelected;

  const HomeSubTab({
    super.key,
    required this.currentTab,
    required this.onTabSelected,
  });

  @override
  Size get preferredSize => const Size.fromHeight(40);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: HomeTabType.values.map(_buildTabItem).toList(),
        ),
      ),
    );
  }

  //--
  Widget _buildTabItem(HomeTabType tabType) {
    final bool isSelected = tabType == currentTab;
    
    return GestureDetector(
      onTap: () => onTabSelected(tabType),
      child: AnimatedContainer(duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 8),        
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
          ? const Color(0xFFD4A843)
          : const Color(0xFFF5F0E8),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          tabType.label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
            color: isSelected ? Colors.white : const Color(0xFF666666),
          ),

        ),
      )
    );
  }
}
