import 'dart:typed_data';
import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Upload extends StatelessWidget {
  final XFile selectImage;
  const Upload({super.key, required this.selectImage});

  @override
  Widget build(BuildContext context) {
    Widget preview;

    if (kIsWeb) {
      // 웹: memory로 이미지 렌더링
      preview = FutureBuilder<Uint8List>(
        future: selectImage.readAsBytes(),
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
      preview = Image.file(File(selectImage.path));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('업로드 화면')),
      body: Center(child: preview),
    );
  }
}
