// 모쇼 공통 태그 칩 위젯
import 'package:flutter/material.dart';
import 'package:moshow/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class MoTagChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  const MoTagChip(
      {super.key, required this.label, required this.isSelected, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.watch<ThemeProvider>().currentTheme.colors;
    // TODO: implement build
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? colors.primary : colors.tagBg,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          '# $label',
          style: TextStyle(
            fontSize: 13,
            color: isSelected ? colors.primary : colors.tagText,
          ),
        ),
      ),
    );
  }
}
