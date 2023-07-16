// import 'dart:io';
// import 'package:dotted_border/dotted_border.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// import 'package:mate_app/Providers/FeedProvider.dart';
// import 'package:mate_app/Widget/loader.dart';
// import 'package:mate_app/asset/Colors/MateColors.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
// import '../../../controller/theme_controller.dart';
// import '../HomeScreen.dart';
//
// class CreateStory extends StatefulWidget {
//   static final String routeName = 'create-story';
//
//   @override
//   _CreateStoryState createState() => _CreateStoryState();
// }
//
// class _CreateStoryState extends State<CreateStory> {
//   ThemeController themeController = Get.find<ThemeController>();
//   TextEditingController _textMessage = new TextEditingController(text: "");
//   File _image;
//   final picker = ImagePicker();
//   bool isLoading = false;
//
//   void _submitForm(BuildContext context) async {
//     FocusScope.of(context).unfocus();
//     bool validated = _image!=null;
//     if (validated) {
//       setState(() {
//         isLoading = true;
//       });
//       bool updated = await Provider.of<FeedProvider>(context, listen: false).postStory(text: _textMessage.text, imageFile: _image,);
//       if(updated){
//         setState(() {
//           isLoading = false;
//         });
//         Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen(index: 0,)));
//       }else{
//         setState(() {
//           isLoading = false;
//         });
//         Fluttertoast.showToast(msg: "Something went wrong", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
//       }
//     }else{
//       Fluttertoast.showToast(msg: "Please select video", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
//     }
//   }
//
//   Widget _submitButton(BuildContext context) {
//     final scH = MediaQuery.of(context).size.height;
//     final scW = MediaQuery.of(context).size.width;
//     return Align(
//       alignment: Alignment.bottomCenter,
//       child: Container(
//         height: 56,
//         margin: EdgeInsets.only(top: scH/3,left: scW*0.3,right: scW*0.3,bottom: 0),
//         width: 160,
//         child: ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             primary: MateColors.activeIcons,
//             onPrimary: Colors.white,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
//           ),
//           onPressed: (){
//             _submitForm(context);
//           },
//           child: Text(
//             "Post",
//             style: TextStyle(
//               color: themeController.isDarkMode?MateColors.blackTextColor:Colors.white,
//               fontWeight: FontWeight.w700,
//               fontSize: 17.0,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     final scH = MediaQuery.of(context).size.height;
//     final scW = MediaQuery.of(context).size.width;
//     return Stack(
//       children: [
//         Scaffold(
//           appBar: AppBar(
//             elevation: 0,
//             iconTheme: IconThemeData(
//               color: MateColors.activeIcons,
//             ),
//             title: Text(
//               "Create Live Post",
//               style: TextStyle(
//                 color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
//                 fontWeight: FontWeight.w700,
//                 fontSize: 17.0,
//               ),
//             ),
//             centerTitle: true,
//           ),
//           body: GestureDetector(
//             onTap: () {
//               FocusScope.of(context).unfocus();
//             },
//             child: SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(left: 2),
//                       child: Text(
//                         "Upload video",
//                         style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w500,
//                           letterSpacing: 0.1,
//                           color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
//                         ),
//                       ),
//                     ),
//                     InkWell(
//                       onTap: ()async{
//                         final pickedFile = await picker.getVideo(source: ImageSource.gallery);
//                         if (pickedFile != null) {
//                           _image = File(pickedFile.path);
//                           setState(() {});
//                           print('image selected Path:: ${_image.path}');
//                         }else{
//                           print('No image selected.');
//                         }
//                       },
//                       child: Container(
//                         height: 112,
//                         margin: EdgeInsets.only(top: scH*0.01),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(16),
//                           color: themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightButtonBackground,
//                         ),
//                         child: DottedBorder(
//                           color: MateColors.activeIcons,
//                           strokeWidth: 1,
//                           dashPattern: [10, 6, 10, 6],
//                           radius: Radius.circular(16),
//                           borderType: BorderType.RRect,
//                           child: Center(
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Icon(Icons.video_call,color: MateColors.activeIcons,),
//                                 SizedBox(
//                                   width: 5,
//                                 ),
//                                 Text(
//                                   "Select video",
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w500,
//                                     letterSpacing: 0.1,
//                                     color: MateColors.activeIcons,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(left: 2,top: scH*0.05,bottom: 10,right: 2),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             "Description",
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500,
//                               letterSpacing: 0.1,
//                               color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
//                             ),
//                           ),
//                           Text(
//                             "0/256",
//                             style: TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.w400,
//                               letterSpacing: 0.1,
//                               color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     TextFormField(
//                       controller: _textMessage,
//                       keyboardType: TextInputType.text,
//                       autofocus: false,
//                       maxLines: 4,
//                       style:  TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                         letterSpacing: 0.1,
//                         color: themeController.isDarkMode?Colors.white:Colors.black,
//                       ),
//                       decoration: InputDecoration(
//                         hintStyle: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w400,
//                           letterSpacing: 0.1,
//                           color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
//                         ),
//                         hintText: "What’s on your mind?",
//                         fillColor: themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightButtonBackground,
//                         filled: true,
//                         focusedBorder: OutlineInputBorder(
//                           borderSide:  BorderSide(
//                             color: themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightButtonBackground,
//                           ),
//                           borderRadius: BorderRadius.circular(16.0),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderSide:  BorderSide(
//                             color:  themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightButtonBackground,
//                           ),
//                           borderRadius: BorderRadius.circular(16.0),
//                         ),
//                         disabledBorder: OutlineInputBorder(
//                           borderSide:  BorderSide(
//                             color: themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightButtonBackground,
//                           ),
//                           borderRadius: BorderRadius.circular(16.0),
//                         ),
//                         errorBorder: OutlineInputBorder(
//                           borderSide:  BorderSide(
//                             color:  themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightButtonBackground,
//                           ),
//                           borderRadius: BorderRadius.circular(16.0),
//                         ),
//                         focusedErrorBorder: OutlineInputBorder(
//                           borderSide:  BorderSide(
//                             color: themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightButtonBackground,
//                           ),
//                           borderRadius: BorderRadius.circular(16.0),
//                         ),
//                       ),
//                     ),
//                     _submitButton(context),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//         Visibility(
//           visible: isLoading,
//           child: Loader(),
//         ),
//       ],
//     );
//   }
// }
