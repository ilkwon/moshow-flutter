import 'dart:typed_data';
import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Upload extends StatefulWidget {
  final XFile selectImage;
  
  final Function(Map<String, dynamic>)? onAdd; // callback 
  const Upload({super.key, required this.selectImage,  this.onAdd});

  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  final TextEditingController _txtEditingController = TextEditingController();
  //-------------------------------------------------------------------------
  void addData(){
    var rowData = {
        "id": 0,              // unique id
        "image": widget.selectImage.path,
        "likes": 5,
        "date": "July 25",
        "content": _txtEditingController.text,
        "liked": false,
        "user": "moshow"
    };

    if (widget.onAdd != null){
      widget.onAdd!(rowData);
    }

    Navigator.pop(context, true); // 업로드완료 후 돌아가기 결과 true 리턴.
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
      appBar: AppBar(        
        actions: [
          IconButton(onPressed: addData,            
          icon: Icon(Icons.send))
        ]), 

        body: Column(children: [
          preview,

          const SizedBox(height:16),
          TextField(
            controller: _txtEditingController,
            decoration: const InputDecoration(labelText: '내용을 입력하세요',),
          )
        ]),
    );
  }
}
