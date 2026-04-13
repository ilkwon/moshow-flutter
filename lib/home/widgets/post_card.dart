import 'package:flutter/material.dart';
import 'package:moshow/common/api_client.dart';
import 'package:moshow/common/providers/app_provider.dart';
import 'package:moshow/common/shared.dart';
import 'package:provider/provider.dart';

//------------------------------------------------------------------------------
class PostCard extends StatelessWidget {
  static const _imageCornerRadius = 16.0;
  static const _chipCornerRadius = 6.0;

  final String imageUrl;
  final String title;
  final String badge;
  final String postId;
  final String postUserId;
  final VoidCallback? onDeleted;
  final List<String> tags;
  final String authorName;

  final bool isStared;
  final VoidCallback? onStar;
  final bool fullscreen;

  const PostCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.badge,
    required this.postId,
    required this.postUserId,
    this.onDeleted,
    this.tags = const [],
    this.authorName = '',
    this.isStared = false,
    this.onStar,
    this.fullscreen = false,
  });

  //----------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    if (fullscreen) {
      return _buildFullscreenCard(context);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImageArea(context),
          const SizedBox(height: 14),
          if (badge.isNotEmpty) ...[
            _buildBadge(),
            const SizedBox(height: 10),
          ],
          _buildTitle(),
          if (tags.isNotEmpty) ...[
            const SizedBox(height: 10),
            _buildTags(),
          ],
          const SizedBox(height: 8),
          _buildAuthorRow(context),
          const SizedBox(height: 10),
          const Divider(height: 1, color: Color(0xFFE8E8E8)),
        ],
      ),
    );
  }

  Widget _buildFullscreenCard(BuildContext context) {
    final EdgeInsets safePadding = MediaQuery.of(context).padding;
    final String normalizedTitle = title.trim().isEmpty ? '제목 없음' : title.trim();
    final String authorText = authorName.isEmpty ? '-' : authorName;

    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(
          color: const Color(0xFFEDE5DB),
          child: imageUrl.isEmpty
              ? const SizedBox.shrink()
              : Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stack) {
                    Shared.log('❌ 이미지 로딩 실패: $error');
                    return const ColoredBox(color: Color(0xFFEDE5DB));
                  },
                ),
        ),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0x22000000),
                Color(0x11000000),
                Color(0x99000000),
              ],
            ),
          ),
        ),
        Positioned(
          top: safePadding.top + 8,
          right: 12,
          child: _buildRightTopMenuButton(context),
        ),
        Positioned(
          left: 16,
          right: 16,
          bottom: safePadding.bottom + 84,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (badge.isNotEmpty) ...[
                _buildFullscreenBadge(),
                const SizedBox(height: 12),
              ],
              Text(
                normalizedTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (tags.isNotEmpty) ...[
                const SizedBox(height: 10),
                _buildFullscreenTags(),
              ],
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'by $authorText',
                    style: const TextStyle(
                      color: Color(0xFFE0E0E0),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  GestureDetector(
                    onTap: onStar,
                    child: Icon(
                      isStared ? Icons.star : Icons.star_border,
                      color: isStared ? const Color(0xFFFFD66B) : Colors.white,
                      size: 26,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  //----------------------------------------------------------------------------
  Widget _buildImageArea(BuildContext context) {
    return AspectRatio(
      aspectRatio: 345 / 220,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(_imageCornerRadius),
            child: Container(
              color: const Color(0xFFEDE5DB),
              width: double.infinity,
              height: double.infinity,
              child: imageUrl.isEmpty
                  ? const SizedBox.shrink()
                  : Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stack) {
                        Shared.log('❌ 이미지 로딩 실패: $error');
                        return const ColoredBox(color: Color(0xFFEDE5DB));
                      },
                    ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: _buildRightTopMenuButton(context),
          ),
        ],
      ),
    );
  }

  //----------------------------------------------------------------------------
  Widget _buildBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFEDEDED),
        borderRadius: BorderRadius.circular(_chipCornerRadius),
      ),
      child: Text(
        '#$badge',
        style: const TextStyle(
          color: Color(0xFF878787),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildFullscreenBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0x66FFFFFF),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '#$badge',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  //----------------------------------------------------------------------------
  Widget _buildTags() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tags.take(3).map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xFFEDEDED),
            borderRadius: BorderRadius.circular(_chipCornerRadius),
          ),
          child: Text(
            _normalizeTag(tag),
            style: const TextStyle(
              color: Color(0xFF878787),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFullscreenTags() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tags.take(3).map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0x52FFFFFF),
            borderRadius: BorderRadius.circular(_chipCornerRadius),
          ),
          child: Text(
            _normalizeTag(tag),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }

  //----------------------------------------------------------------------------
  Widget _buildTitle() {
    final normalizedTitle = title.trim();

    return Text(
      normalizedTitle.isEmpty ? '제목 없음' : normalizedTitle,
      style: const TextStyle(
        color: Color(0xFF1A1A1A),
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  String _normalizeTag(String tag) {
    final normalized = tag.trim();
    if (normalized.isEmpty) return '#';
    return normalized.startsWith('#') ? normalized : '#$normalized';
  }

  //----------------------------------------------------------------------------
  Widget _buildAuthorRow(BuildContext context) {
    final authorText = authorName.isEmpty ? '-' : authorName;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'by $authorText',
          style: const TextStyle(
            color: Color(0xFF878787),
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
        ),
        _buildStarButton(),
      ],
    );
  }

  //----------------------------------------------------------------------------
  Widget _buildRightTopMenuButton(BuildContext context) {
    final String? myUserId =
        Provider.of<StoreProvider>(context, listen: false).userId;
    Shared.log("#### my:$myUserId:post:$postUserId");

    // 본인 게시물에서만 표시되게.
    if (myUserId != postUserId) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () => _showMenu(context),
      child: const DecoratedBox(
        decoration: BoxDecoration(
          color: Color(0x66000000),
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: EdgeInsets.all(4),
          child: Icon(Icons.more_horiz, color: Colors.white, size: 18),
        ),
      ),
    );
  }

  //----------------------------------------------------------------------------
  void _showMenu(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (sheetContext) => SafeArea(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.delete_outline, color: Colors.red),
                  title: const Text('삭제', style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    _deletePost(context);
                  },
                )
              ],
            )));
  }

  //----------------------------------------------------------------------------
  void _deletePost(BuildContext context) async {
    final String? userId =
        Provider.of<StoreProvider>(context, listen: false).userId;

    try {
      await ApiClient.instance.delete('/posts', {
        'user_id': userId,
        'post_id': postId,
      });
      Shared.log('✅ 삭제 완료, 콜백 호출');
      onDeleted?.call();
    } catch (error) {
      Shared.log('삭제 실패: $error');
    }
  }

  //----------------------------------------------------------------------------
  Widget _buildStarButton() {
    return GestureDetector(
      onTap: onStar,
      child: Icon(
        isStared ? Icons.star : Icons.star_border,
        color: isStared ? const Color(0xFFB88A59) : const Color(0xFFBDBDBD),
        size: 20,
      ),
    );
  }
  //----------------------------------------------------------------------------
}
