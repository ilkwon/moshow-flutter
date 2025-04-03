// onTap: (int i) async {
//             if (i == 2){
//               Shared.log('등록 탭이 눌림');
// 
//               var picker = ImagePicker();
//               var image = await picker.pickImage(source: ImageSource.gallery);
//               if (image != null) {
//                 setState(() {
//                   userImage = File(image.path);
//                 });
//               }
//   
//               // ignore: use_build_context_synchronously
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (c) => Upload(selectImage: userImage)));
//                 // Show Popup.
//               } else {            
//                 setState(() {
//                   stateTabIndex = i;
//                 });
//             }
//           },