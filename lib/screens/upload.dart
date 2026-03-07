import 'dart:typed_data';
import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:moshow/providers/app_provider.dart';
import 'package:moshow/common/api_client.dart';
import 'package:moshow/common/shared.dart';

class Upload extends StatefulWidget {
  final XFile selectImage;

  final Function(Map<String, dynamic>)? onAdd; // callback
  const Upload({super.key, required this.selectImage, this.onAdd});

  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  final TextEditingController _txtEditingController = TextEditingController();
  //-------------------------------------------------------------------------
  bool _isUploading = false; // 업로드 상태 관리 변수

  void addData() async {
    if (_isUploading) return; // 이미 업로드 중이면 중복 실행 방지
    setState(() => _isUploading = true); // 업로드 시작

    try {
      final userId = Provider.of<StoreProvider>(context, listen: false).userId;
      if (userId == null) {
        Shared.log('❌ userId가 없습니다. 업로드를 진행할 수 없습니다.');
        return;
      }

      // 1) presign URL 발급
      // ✅ [변경1] presign API에서 content_type을 명시적으로 전달하도록 수정
      // 
      final presign = await ApiClient.instance
          .post('/uploads/presign', {'content_type': 'image/jpeg'});
      // presign 응답에서 업로드 URL과 최종 미디어 URL 추출
      // r2 presign 응답 예시: { "upload_url": "https://...r2.cloudflarestorage.com/...", "file_url": "https://...r2.cloudflarestorage.com/..." }
      // r2는 file_url, DB  posts 테이블에는 media_url로 저장.
      final String uploadUrl = presign['upload_url']; 
      final String fileUrl = presign['file_url'];  

      // 2) 이미지 바이너리 열기
      Uint8List imageBytes = await widget.selectImage.readAsBytes();

      // 3) presign URL로 이미지 업로드
      final uploadResponse = await http.put(
        Uri.parse(uploadUrl),
        headers: {'Content-Type': 'image/jpeg'},
        body: imageBytes,
      );

      if (uploadResponse.statusCode != 200) {
        throw Exception(
            '이미지 업로드 실패: ${uploadResponse.statusCode} ${uploadResponse.reasonPhrase}');
      }
      Shared.log('✅ R2에 image 업로드 성공: $fileUrl');

      // 4) 게시물 삽입.
      await ApiClient.instance.post('/posts', {
        'user_id': userId,
        'media_url': fileUrl,
        'caption': _txtEditingController.text,
      });
      Shared.log('✅ 게시물 등록 완료');

      if (widget.onAdd != null) {
        widget.onAdd!({
          'user_id': userId,
          'media_url': fileUrl,
          'caption': _txtEditingController.text,
        });
      }
      Navigator.pop(context, true); // 업로드 완료 후 팝업 닫기
    } catch (error) {
      Shared.log('업로드 실패: $error');
      setState(() => _isUploading = false); // 업로드 실패 시 상태 초기화
      return;
    }
  }

  //-------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    Widget preview;

    if (kIsWeb) {
      // 웹: memory로 이미지 렌더링
      preview = FutureBuilder<Uint8List>(
        future: widget.selectImage.readAsBytes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Image.memory(snapshot.data!);
          } else {
            return const CircularProgressIndicator();
          }
        },
      );
    } else {
      // 모바일/데스크탑: File로 이미지 렌더링
      preview = Image.file(File(widget.selectImage.path));
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(actions: [
        _isUploading
            ? const CircularProgressIndicator()
            : IconButton(onPressed: addData, icon: Icon(Icons.send))
      ]),
      body: SingleChildScrollView(
        child: Column(children: [
          preview,
          const SizedBox(height: 16),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                controller: _txtEditingController,
                decoration: const InputDecoration(
                  labelText: '내용을 입력하세요',
                ),
              )),
        ]),
      ),
    );
  }
}
