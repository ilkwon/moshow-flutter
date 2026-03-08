import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import 'package:moshow/theme/app_theme.dart';
import 'package:moshow/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({super.key, this.datas});

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

// 
class _ShowcaseCard extends StatelessWidget {
  const _ShowcaseCard({required this.item});

  final Map<String, dynamic> item;

  @override
  Widget build(BuildContext context) {    
    final colors = context.watch<ThemeProvider>().currentTheme.colors;
    return Stack(
      children: [
        _buildImage(),
        _buildInfo(colors, context),
      ],
    );
  }
  
  Widget _buildImage() {
    if (item['media_url'] == null) return const SizedBox.expand();

    return Image.network(
      item['media_url'],
      fit:BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
  }
  
  Widget _buildInfo(AppColors colors, BuildContext context) {
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
            _buildTitle(colors),
            const SizedBox(height: 8),
            _buildAuthor(colors),
          ],
        ),
    ));
  }
  
  Widget _buildTitle(AppColors colors) {
    return Text(
      item['caption'] ?? '',
      style: TextStyle(
        color:colors.background,
        fontSize: 22,
      )       
    );
  }
  
  Widget _buildAuthor(AppColors colors) {
    
    return Text(
      '@${item['user_id']}',
      style: TextStyle(
        color: colors.background,
        fontSize: 14
      ),
    );
  }
}

