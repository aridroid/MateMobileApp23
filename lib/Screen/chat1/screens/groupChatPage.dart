// import 'dart:async';
// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_native_image/flutter_native_image.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:image_picker/image_picker.dart';
// import '../chatWidget.dart';
// import 'package:mate_app/Utility/Utility.dart' as config;
// import '../constForChat.dart';
// import 'package:mate_app/asset/Colors/MateColors.dart';
// import 'package:sizer/sizer.dart';
//
// class GroupChat extends StatelessWidget {
//   final String peerId;
//   final String peerAvatar;
//   final String peerName;
//   final String currentUserName;
//   final String currentUserId;
//   GroupChat({Key key, @required this.currentUserId, @required this.peerId, @required this.peerAvatar, @required this.peerName, this.currentUserName}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         leadingWidth: 30,
//         leading: IconButton(onPressed:(){
//           Navigator.pop(context);
//         }, icon: Icon(Icons.arrow_back,size: 30,)),
//         elevation: 6,
//         backgroundColor: config.myHexColor,
//         title: Row(
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(right:10.0),
//               child: ClipRRect(
//                   borderRadius: BorderRadius.circular(8.0),
//                   child: Image.asset(peerAvatar,height: 40,width: 40,)),
//             ),
//             Text(peerName,style: TextStyle(color: MateColors.activeIcons, fontSize: 16.0.sp),),
//           ],
//         ),
//       ),
//       body: new _ChatScreen(
//         currentUserId: currentUserId,
//         peerId: peerId,
//         peerAvatar: peerAvatar,
//           currentUserName:currentUserName
//       ),
//     );
//   }
// }
//
// class _ChatScreen extends StatefulWidget {
//   final String peerId;
//   final String peerAvatar;
//   final String currentUserId;
//   final String currentUserName;
//
//   _ChatScreen({Key key, @required this.peerId, @required this.peerAvatar, @required this.currentUserId, this.currentUserName}) : super(key: key);
//
//   @override
//   State createState() => new _ChatScreenState(peerId: peerId, peerAvatar: peerAvatar);
// }
//
// class _ChatScreenState extends State<_ChatScreen> {
//   _ChatScreenState({Key key, @required this.peerId, @required this.peerAvatar});
//
//   String peerId;
//   String peerAvatar;
//   String id;
//
//   var listMessage;
//   String groupChatId;
//
//   PickedFile imageFile;
//   bool isLoading;
//   bool isShowSticker;
//   String imageUrl;
//
//   final TextEditingController textEditingController = new TextEditingController();
//   final ScrollController listScrollController = new ScrollController();
//   final FocusNode focusNode = new FocusNode();
//
//   @override
//   void initState() {
//     super.initState();
//     focusNode.addListener(onFocusChange);
//     groupChatId = '';
//     isLoading = false;
//     isShowSticker = false;
//     imageUrl = '';
//     readLocal();
//   }
//
//   void onFocusChange() {
//     if (focusNode.hasFocus) {
//       // Hide sticker when keyboard appear
//       setState(() {
//         isShowSticker = false;
//       });
//     }
//   }
//
//   readLocal() async {
//     id = widget.currentUserId ?? '';
//     groupChatId = '$peerId';
//
//
//     FirebaseFirestore.instance.collection('users').doc(id).update({'chattingWith': peerId});
//
//     setState(() {});
//   }
//
//   Future getImage(int index) async {
//     imageFile = index == 0 ? await ImagePicker.platform.pickImage(source: ImageSource.gallery) : await ImagePicker.platform.pickImage(imageQuality: 90,source: ImageSource.camera);
//
//     if (imageFile != null) {
//       setState(() {
//         isLoading = true;
//       });
//       uploadFile();
//     }
//   }
//
//   Future getImage1(int type) async {
//     PickedFile pickedImage = await ImagePicker().getImage(
//         source: type == 1 ? ImageSource.camera : ImageSource.gallery,
//         imageQuality: 50);
//     return pickedImage;
//   }
//
//   Future uploadFile() async {
//     String fileName = DateTime.now().millisecondsSinceEpoch.toString();
//     Reference reference = FirebaseStorage.instance.ref().child(fileName);
//
//     File compressedFile = await FlutterNativeImage.compressImage(imageFile.path, quality: 80, percentage: 90);
//
//     UploadTask uploadTask = reference.putFile(compressedFile);
//     TaskSnapshot storageTaskSnapshot = await uploadTask.whenComplete((){});
//     storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
//       imageUrl = downloadUrl;
//       setState(() {
//         isLoading = false;
//         onSendMessage(imageUrl, 1);
//       });
//     }, onError: (err) {
//       setState(() {
//         isLoading = false;
//       });
//       Fluttertoast.showToast(msg: 'This file is not an image');
//     });
//   }
//
//   void onSendMessage(String content, int type) {
//     // type: 0 = text, 1 = image, 2 = sticker
//     if (content.trim() != '') {
//       textEditingController.clear();
//
//       var documentReference = FirebaseFirestore.instance.collection('messages').doc(groupChatId).collection(groupChatId).doc(DateTime.now().millisecondsSinceEpoch.toString());
//
//       FirebaseFirestore.instance.runTransaction((transaction) async {
//         await transaction.set(
//           documentReference,
//           {'idFrom': id, 'idTo': peerId, 'timestamp': DateTime.now().millisecondsSinceEpoch.toString(), 'content': content, 'type': type},
//         );
//       });
//       listScrollController.animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
//     } else {
//       Fluttertoast.showToast(msg: 'Nothing to send');
//     }
//   }
//
//   Future<bool> onBackPress() {
//     Navigator.pop(context);
//     return Future.value(false);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       child: Stack(
//         children: <Widget>[
//           Column(
//             children: <Widget>[
//               // List of messages
//               ChatWidget.widgetGroupChatBuildListMessage(groupChatId, listMessage, widget.currentUserId, peerAvatar, listScrollController),
//
//               // Input content
//               buildInput(),
//             ],
//           ),
//
//           // Loading
//           buildLoading()
//         ],
//       ),
//       onWillPop: onBackPress,
//     );
//   }
//
//   Widget buildLoading() {
//     return Positioned(
//       child: isLoading
//           ? Container(
//         child: Center(
//           child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(themeColor)),
//         ),
//         color: Colors.white.withOpacity(0.8),
//       )
//           : Container(),
//     );
//   }
//
//   Widget buildInput() {
//     return Container(
//       child: Row(
//         children: <Widget>[
//           // Button send image
//           Material(
//             child: new Container(
//               margin: new EdgeInsets.symmetric(horizontal: 1.0),
//               child: new IconButton(
//                 icon: new Icon(Icons.image),
//                 onPressed: () => getImage1(0),
//                 color: primaryColor,
//               ),
//             ),
//             color: Colors.white,
//           ),
//           // Material(
//           //   child: new Container(
//           //     margin: new EdgeInsets.symmetric(horizontal: 1.0),
//           //     child: new IconButton(
//           //       icon: new Icon(Icons.camera_alt),
//           //       onPressed: () => getImage(1),
//           //       color: primaryColor,
//           //     ),
//           //   ),
//           //   color: Colors.white,
//           // ),
//           // Edit text
//           Flexible(
//             child: Container(
//               child: TextField(
//                 style: TextStyle(color: primaryColor, fontSize: 15.0),
//                 controller: textEditingController,
//                 decoration: InputDecoration.collapsed(
//                   hintText: 'Type your message...',
//                   hintStyle: TextStyle(color: greyColor),
//                 ),
//                 focusNode: focusNode,
//               ),
//             ),
//           ),
//
//           // Button send message
//           Material(
//             child: new Container(
//               margin: new EdgeInsets.symmetric(horizontal: 8.0),
//               child: new IconButton(
//                 icon: new Icon(Icons.send),
//                 onPressed: () => onSendMessage(textEditingController.text + "(<{<[<?>]>}>)"+widget.currentUserName, 0),
//                 color: primaryColor,
//               ),
//             ),
//             color: Colors.white,
//           ),
//         ],
//       ),
//       width: double.infinity,
//       height: 50.0,
//       decoration: new BoxDecoration(border: new Border(top: new BorderSide(color: greyColor2, width: 0.5)), color: Colors.white),
//     );
//   }
// }
