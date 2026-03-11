import 'package:flutter/material.dart';
import 'package:moshow/common/theme/app_theme.dart';
import 'package:moshow/common/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, this.datas});

  final dynamic datas;

  @override
  Widget build(BuildContext context) {
    if (datas == null || datas.isEmpty) {
      return const Center(child: Text('Now Loading...'));
    }
    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: datas.length,
      itemBuilder: (context, index) => _ShowcaseCard(item: datas[index]),
    );
  }
}

class _ShowcaseCard extends StatelessWidget {
  const _ShowcaseCard({required this.item});

  final Map<String, dynamic> item;

  @override
  Widget build(BuildContext context) {    
    final theme = context.watch<ThemeProvider>().currentTheme;
    return Stack(
      fit: StackFit.expand,
      children: [
        _buildImage(),
        _buildInfo(theme, context),
      ],
    );
  }
  
  Widget _buildImage() {
    if (item['media_url'] == null) return const SizedBox.expand();

    return SizedBox.expand(
      child: Image.network(
        item['media_url'],
        fit:BoxFit.cover,
      ),
    );
  }
  
  Widget _buildInfo(AppTheme theme, BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 60, 20, MediaQuery.of(context).padding.bottom + 80),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: const [
              Color(0xCC000000),
              Color(0x00000000),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(theme),
            const SizedBox(height: 8),
            _buildAuthor(theme),
          ],
        ),
    ));
  }
  
  Widget _buildTitle(AppTheme theme) {
    return Text(
      item['caption'] ?? '',
      style: theme.typography.titleLarge.copyWith(
        color:theme.colors.background,        
      )       
    );
  }
  
  Widget _buildAuthor(AppTheme theme) {
    
    return Text(
      '@${item['user_id']}',
      style: theme.typography.bodyMedium.copyWith(
        color: theme.colors.background,
      ),
    );
  }
}

