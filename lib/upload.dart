import 'package:flutter/material.dart';


class Upload extends StatelessWidget {
  const Upload({super.key, this.selectImage});
  final selectImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          selectImage != null ? Image.file(selectImage) : const SizedBox(),
          //Text('업로드 화면'),
          IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: Icon(Icons.close)
          )
        ],
      )
    );
  }
}