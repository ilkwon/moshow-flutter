import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:moshow/common/api_client.dart';
import 'package:moshow/common/define.dart';
import 'package:moshow/common/shared.dart';
import 'package:moshow/common/providers/app_provider.dart';
import 'package:moshow/common/theme/app_theme.dart';
import 'package:moshow/common/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class UploadScreen extends StatefulWidget {
  final List<XFile> images;

  const UploadScreen({
    super.key,
    required this.images,
  });

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final TextEditingController _captionController = TextEditingController();

  late List<XFile> _pickedImages;

  UploadStatus _uploadStatus = UploadStatus.idle;

  @override
  void initState() {
    super.initState();

    _pickedImages = widget.images;
  }

  @override
  void dispose() {
    _captionController.dispose();

    super.dispose();
  }
  //------------------------------------------------------------------------
  Future<void> _upload() async {
    // 가드 조건 (예외 처리)
    if (_uploadStatus == UploadStatus.uploading) return;
    if (_pickedImages.isEmpty) return;

    // DB에 저장.
    final String? userId =
        Provider.of<StoreProvider>(context, listen: false).userId;

    setState(() => _uploadStatus = UploadStatus.uploading);

    try {
      // 이미지 갯수에 따라 타입이 결정
      final String postType = _pickedImages.length > 1 ? 'showcase' : 'post';

      final List<String> mediaUrls = [];
      for (final image in _pickedImages) {
        Shared.log('📸 이미지 업로드 시작: ${image.name}');
        final presign = await ApiClient.instance.post(
          '/uploads/presign',
          {'content_type': 'image/jpeg'},
        );

        final String uploadUrl = presign['upload_url'];
        final String finalUrl = presign['file_url'];

        // 이미지 바이트 읽기
        final Uint8List imageBytes = await image.readAsBytes();

        final http.Response uploadResponse = await http.put(
          Uri.parse(uploadUrl),
          headers: {'Content-Type': 'image/jpeg'},
          body: imageBytes,
        );

        if (uploadResponse.statusCode != 200) {
          throw Exception('업로드 실패: ${uploadResponse.statusCode}');
        }

        mediaUrls.add(finalUrl);
      }

      await ApiClient.instance.post('/posts', {
        'user_id': userId,
        'media_urls': mediaUrls,
        'caption': _captionController.text,
        'type': postType,
        'tags': [],
      });
      // 완료: 홈으로 이동
      setState(() => _uploadStatus = UploadStatus.success);
      if (!mounted) return;
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (error) {
      Shared.log('❌ 업로드 실패 상세: $error');
      Shared.log('❌ 이미지 수: ${_pickedImages.length}');
      setState(() => _uploadStatus = UploadStatus.failed);
    }
  }

  //------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>().currentTheme;
    return Scaffold(
        backgroundColor: theme.colors.background,
        body: SafeArea(child: LayoutBuilder(builder: (context, constraints) {
          final double imageSize = constraints.maxWidth - 40;
          return SingleChildScrollView(
              child: Column(children: [
            _buildTopbar(theme),
            const SizedBox(height: 16),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildImageArea(theme, imageSize)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildCaptionField(theme),
            ),
          ]));
        })));
  }

  //---------------------------------------------------------------------------
  Widget _buildTopbar(AppTheme theme) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Icon(Icons.close, size: 24, color: theme.colors.primary)),
          GestureDetector(
            onTap: _upload,
            child: Text(
              '올리기',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: theme.colors.accent,
              ),
            ),
          )
        ]));
  }

  //---------------------------------------------------------------------------
  Widget _buildImageArea(AppTheme theme, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: theme.colors.surface,
        borderRadius: BorderRadius.circular(theme.radius.large),
      ),
      child: _pickedImages.isEmpty
          ? Icon(Icons.add, size: 32, color: theme.colors.secondary)
          : _buildImageWithOverlay(),
    );
  }

  //---------------------------------------------------------------------------
  Widget _buildCaptionField(AppTheme theme) {
    return TextField(
      controller: _captionController,
      style: TextStyle(
        fontSize: 16,
        color: theme.colors.primary,
      ),
      decoration: InputDecoration(
          hintText: '어떤 순간인가요?',
          hintStyle: TextStyle(color: theme.colors.secondary),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: theme.colors.divider),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: theme.colors.accent),
          )),
    );
  }

  //---------------------------------------------------------------------------
  Widget _buildPreview() {
    if (kIsWeb) {
      return FutureBuilder<Uint8List>(
          future: _pickedImages[0].readAsBytes(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            return Image.memory(snapshot.data!, fit: BoxFit.cover);
          });
    }

    return Image.file(
      File(_pickedImages[0].path),
      fit: BoxFit.cover,
    );
  }

  //---------------------------------------------------------------------------
  Widget _buildImageWithOverlay() {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: _buildPreview(),
        ),
        if (_uploadStatus == UploadStatus.uploading)
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
                child: CircularProgressIndicator(color: Colors.white)),
          ),
      ],
    );
  }
}
