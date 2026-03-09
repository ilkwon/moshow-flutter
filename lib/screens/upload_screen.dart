import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:moshow/common/api_client.dart';
import 'package:moshow/common/define.dart';
import 'package:moshow/common/shared.dart';
import 'package:moshow/providers/app_provider.dart';
import 'package:moshow/theme/app_theme.dart';
import 'package:moshow/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final TextEditingController _captionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  XFile? _pickedImage;
  UploadStatus _uploadStatus = UploadStatus.idle;

  @override
  void initState() {
    super.initState();
    // 화면 열리자마자 갤러리 오픈
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pickImage();
    });
  }

  @override
  void dispose() {
    _captionController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked == null) return;
    setState(() => _pickedImage = picked);
  }

  Future<void> _upload() async {
    // 가드 조건 (예외 처리)
    if (_uploadStatus == UploadStatus.uploading) return;
    if (_pickedImage == null) return;

    setState(() => _uploadStatus = UploadStatus.uploading);

    try {
      // 1단계: presigned URL 발급
      final presign = await ApiClient.instance.post(
        '/uploads/presign',
        {'content_type': 'image/jpeg'},
      );
      final String uploadUrl = presign['upload_url'];
      final String fileUrl = presign['file_url'];

      // 2단계: 이미지 바이트 읽기
      final Uint8List imageBytes = await _pickedImage!.readAsBytes();
      // 3단계: R2에 직접 업로드
      final http.Response uploadResponse = await http.put(
        Uri.parse(uploadUrl),
        headers: {'Content-Type': 'image/jpeg'},
        body: imageBytes,
      );

      if (uploadResponse.statusCode != 200) {
        throw Exception('업로드 실패: ${uploadResponse.statusCode}');
      }
      // 4단계: DB에 저장
      final String? userId =
          Provider.of<StoreProvider>(context, listen: false).userId;
      await ApiClient.instance.post('/posts', {
        'user_id': userId,
        'media_url': fileUrl,
        'caption': _captionController.text,
      });
    } catch (error) {
      // TODO
      Shared.log('❌ 업로드 실패: $error');
    }

    // 완료: 홈으로 이동
    setState(() => _uploadStatus = UploadStatus.success);
    if (!mounted) return;
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>().currentTheme;
    return Scaffold(
      backgroundColor: theme.colors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopbar(theme),
            const SizedBox(height: 16),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildImageArea(theme)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildCaptionField(theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopbar(AppTheme theme) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Icon(Icons.close, size: 24, color: theme.colors.primary),
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

  Widget _buildImageArea(AppTheme theme) {
    final double size = MediaQuery.of(context).size.width - 40;
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: theme.colors.surface,
          borderRadius: BorderRadius.circular(theme.radius.large),
        ),
        child: _pickedImage == null
            ? Icon(
                Icons.add,
                size: 32,
                color: theme.colors.secondary,
              )
            : _buildPreview(),
      ),
    );
  }

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

  Widget _buildPreview() {
    if (kIsWeb) {
      return FutureBuilder<Uint8List>(
          future: _pickedImage!.readAsBytes(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            return Image.memory(snapshot.data!, fit: BoxFit.cover);
          });
    }

    return Image.file(
      File(_pickedImage!.path),
      fit: BoxFit.cover,
    );
  }
}
