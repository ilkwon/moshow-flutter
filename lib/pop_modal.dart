import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:moshow/upload.dart';

class PopModal extends StatelessWidget {
  PopModal({super.key, this.onAdd});
  final Function(Map<String, dynamic>)? onAdd;
  
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
                // 모달 닫고 → 다음 프레임에 push
                Navigator.pop(context);

                Future.microtask(() {
                  //final selectedImage = File(image.path);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (c) => Upload(
                        selectImage: image,                        
                         onAdd: onAdd,
                      ),
                    ),
                  );
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
