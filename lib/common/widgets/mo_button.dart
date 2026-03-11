// 모쇼 공통 버튼 위젯

import 'package:flutter/material.dart';
import 'package:moshow/common/theme/theme_provider.dart';
import 'package:provider/provider.dart';

enum MoButtonVariant { primary, secondary, text }

// ------------------------------------------------------------------------
// 버튼 위젯
// -------------------------------------------------------------------------
class MoButton extends StatelessWidget {
  // 버튼 텍스트
  final String text;
  // null이면 자동으로 disabled 처리됨.
  final VoidCallback? onPressed;
  // 버튼 스타일
  final MoButtonVariant variant;
  // true면 스피너 표시
  final bool isLoading;

  const MoButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = MoButtonVariant.primary,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    
    // 로딩중이면 onPressed를 null로 만들어 버튼 비활성화
    final VoidCallback? handler = isLoading ? null : onPressed;

    switch (variant) {
      case MoButtonVariant.primary:
      return _buildPrimary(context, handler);
      case MoButtonVariant.secondary:
      return _buildSecondary(context, handler);
      case MoButtonVariant.text:
      return _buildText(context, handler);
    }
  }
// --------------------------------------------------------------------------
  // Primary 버튼
  Widget _buildPrimary(BuildContext context, VoidCallback? handler) {
    // 현재 테마에서 색상 꺼내기
    final colors = context.watch<ThemeProvider>().currentTheme.colors;

    return ElevatedButton(
      onPressed: handler,
      style: ElevatedButton.styleFrom(
        backgroundColor: colors.primary,
        foregroundColor: colors.background,
        minimumSize: Size(double.infinity, 48),        
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: isLoading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: colors.background,
                strokeWidth: 2,
              ),
            )
          : Text(text),
    );
  }
  
  // --------------------------------------------------------------------------
  // Secondary 버튼
  Widget _buildSecondary(BuildContext context, VoidCallback? handler) {
    final colors = context.watch<ThemeProvider>().currentTheme.colors;

    return OutlinedButton(
      onPressed: handler,
      style: OutlinedButton.styleFrom(
        foregroundColor: colors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: colors.primary),
        ),
      ),
      child: isLoading
          ? SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: colors.primary,
              ),
            )
          : Text(text),
    );
  }

  Widget _buildText(BuildContext context, VoidCallback? handler) {
    final colors = context.watch<ThemeProvider>().currentTheme.colors;

    return TextButton(
      onPressed: handler,
      style: TextButton.styleFrom(
        foregroundColor: colors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: isLoading
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.blue,
              ),
            )
          : Text(text),
    );  
  }
}