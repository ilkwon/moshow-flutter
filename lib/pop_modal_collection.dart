import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moshow/upload.dart';

class PopModalCollection extends StatelessWidget {
  PopModalCollection({super.key, this.onAdd, this.onComplete});
  final Function(Map<String, dynamic>)? onAdd;
  final Function()? onComplete;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text('새 콘텐츠 등록하기', style: TextStyle(fontSize: 18)),
          ElevatedButton(
            onPressed: () async {
              final picker = ImagePicker();
              final image = await picker.pickImage(source: ImageSource.gallery);

              if (image != null) {
                Future.microtask(() async {                  
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (c) => Upload(
                        selectImage: image,                        
                         onAdd: onAdd,
                      ),
                    ),
                  );
                  if (result == true) {
                    onComplete?.call();
                  } 
                });
              } else {
                // 사용자가 이미지 선택을 취소한 경우
                Navigator.pop(context); // 그냥 모달만 닫기
              }
            },
            child: const Text('사진 선택'),
          )
        ],
      ),
    );
  }
}


