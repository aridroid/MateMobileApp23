// import 'dart:developer';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:mate_app/Model/getStoryModel.dart';
// import 'package:mate_app/Screen/Home/TimeLine/postAStory.dart';
// import 'package:mate_app/Screen/Profile/UserProfileScreen.dart';
// import 'package:mate_app/Services/FeedService.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sizer/sizer.dart';
// import 'package:video_player/video_player.dart';
// import '../../../Providers/AuthUserProvider.dart';
// import '../../../Utility/Utility.dart';
// import '../../../asset/Colors/MateColors.dart';
// import '../../../controller/theme_controller.dart';
// import '../../Profile/ProfileScreen.dart';
// import '../HomeScreen.dart';
//
// class StoryPreviewScreen extends StatefulWidget {
//   final int id;
//   final String picUrl;
//   final String message;
//   final String displayName;
//   final String displayPic;
//   final String created;
//   final User user;
//
//   StoryPreviewScreen({this.id,this.user,this.picUrl, this.message, this.displayName, this.displayPic,this.created});
//
//   @override
//   _StoryPreviewScreenState createState() => _StoryPreviewScreenState();
// }
//
// class _StoryPreviewScreenState extends State<StoryPreviewScreen> with SingleTickerProviderStateMixin {
//   bool _onTouch = false;
//   VideoPlayerController _controller;
//   ThemeController themeController = Get.find<ThemeController>();
//
//   @override
//   void initState() {
//     super.initState();
//     getStoredValue();
//     _controller = VideoPlayerController.network(widget.picUrl)..initialize().then((_) {
//       _controller.play();
//       setState(() {});
//     });
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   String token;
//   getStoredValue()async{
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     token = preferences.getString("tokenApp");
//     log(token);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final scw = MediaQuery.of(context).size.width;
//     final sch = MediaQuery.of(context).size.height;
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         leading: IconButton(
//           color: Colors.white,
//           icon: Icon(Icons.clear),
//           onPressed: () {
//             Get.back();
//           },
//         ),
//         centerTitle: true,
//         title: Text(
//           "Campus Live",
//           style: TextStyle(fontSize: 17.0, fontFamily: "Poppins", fontWeight: FontWeight.w700, color: Colors.white,),
//         ),
//       ),
//       floatingActionButton: InkWell(
//         onTap: () {
//           Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateStory()));
//         },
//         child: Container(
//           height: 56,
//           width: 56,
//           margin: EdgeInsets.only(bottom: 10),
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: MateColors.activeIcons,
//           ),
//           child: Icon(Icons.add, color: themeController.isDarkMode ? Colors.black : Colors.white, size: 28,),
//         ),
//       ),
//       body: Stack(
//         children: [
//           Center(
//             child: _controller.value.isInitialized?
//             VideoPlayer(_controller):
//             CircularProgressIndicator(
//               color: Colors.white,
//             ),
//           ),
//           Positioned(
//             width: MediaQuery.of(context).size.width,
//             height: MediaQuery.of(context).size.height,
//             child: Center(
//               child: InkWell(
//                 splashColor: Colors.transparent,
//                 highlightColor: Colors.transparent,
//                 onTap: () {
//                   setState(() {
//                     _onTouch = !_onTouch;
//                   });
//                 },
//                 child: Visibility(
//                   maintainAnimation: true,
//                   maintainState: true,
//                   maintainInteractivity: true,
//                   maintainSize: true,
//                   visible: _controller.value.isInitialized && _onTouch,
//                   child: Container(
//                     padding: EdgeInsets.only(bottom: sch/1.9),
//                     alignment: Alignment.bottomCenter,
//                     child: TextButton(
//                       style: TextButton.styleFrom(
//                         foregroundColor: Colors.grey.withOpacity(0.5),
//                         padding: EdgeInsets.all(10),
//                         shape: CircleBorder(side: BorderSide(color: Colors.white, width: 1.2)),
//                       ),
//                       // color: Colors.grey.withOpacity(0.5),
//                       // padding: EdgeInsets.all(10),
//                       // shape: CircleBorder(side: BorderSide(color: Colors.white, width: 1.2)),
//                       child: Icon(
//                         _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//                         color: Colors.white,
//                         size: 30,
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           _controller.value.isPlaying ? _controller.pause() : _controller.play();
//                         });
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: sch*0.03,
//             left: scw*0.08,
//             right: scw*0.4,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 InkWell(
//                   onTap: () {
//                     if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == widget.user.uuid) {
//                       Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
//                     } else {
//                       Navigator.of(context).pushNamed(UserProfileScreen.routeName, arguments: {"id": widget.user.uuid, "name": widget.user.displayName, "photoUrl": widget.user.profilePhoto, "firebaseUid": widget.user.firebaseUid});
//                     }
//                   },
//                   child: Text(
//                     "@${widget.displayName}",
//                     style: TextStyle(fontFamily: 'Poppins', color: Colors.white, fontWeight: FontWeight.w700, fontSize: 17,),
//                   ),
//                 ),
//                 SizedBox(
//                   height: sch*0.01,
//                 ),
//                 // Text(
//                 //   widget.created,
//                 //   style: TextStyle(
//                 //     fontSize: 12,
//                 //     color: MateColors.subTitleTextDark,
//                 //   ),
//                 // ),
//                 // SizedBox(
//                 //   height: sch*0.01,
//                 // ),
//                 Text(
//                  widget.message??"",
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Colors.white,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Positioned(
//             bottom: sch*0.15,
//             right: scw*0.0,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 PopupMenuButton<int>(
//                     padding: EdgeInsets.only(bottom: 0, top: 0, left: 0, right: 0),
//                     color: themeController.isDarkMode?backgroundColor:Colors.white,
//                     icon: Image.asset(
//                       "lib/asset/icons/menu@3x.png",
//                       height: 18,
//                       color: Colors.white,
//                     ),
//                     onSelected: (index) async {
//                       if (index == 0) {
//                         bool response = await FeedService().deleteStory(id: widget.id,token: token);
//                         if(response){
//                           Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen(index: 0,)));
//                         }
//                       }
//                     },
//                     itemBuilder: (context) => [
//                       if(Provider.of<AuthUserProvider>(context, listen: false).authUser.id == widget.user.uuid)
//                       PopupMenuItem(
//                         value: 0,
//                         height: 40,
//                         child: Text(
//                           "Delete",
//                           textAlign: TextAlign.start,
//                           style: TextStyle(color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor, fontWeight: FontWeight.w500, fontSize: 12.6.sp),
//                         ),
//                       ),
//                     ]
//                 ),
//                 // Icon(
//                 //   1==2 ? Icons.favorite : Icons.favorite_border,
//                 //   color: 1==2 ? MateColors.activeIcons : Colors.white,
//                 //   size: 23,
//                 // ),
//                 // Text(
//                 //   '8',
//                 //   style: TextStyle(fontSize: 14.0, fontFamily: "Poppins", color: Colors.white,),
//                 // ),
//                 // SizedBox(
//                 //   height: sch*0.025,
//                 // ),
//                 // Icon(
//                 //   Icons.mode_comment_outlined,
//                 //   color: Colors.white,
//                 //   size: 23,
//                 // ),
//                 // Text(
//                 //   '8',
//                 //   style: TextStyle(fontSize: 14.0, fontFamily: "Poppins", color: Colors.white,),
//                 // ),
//                 // SizedBox(
//                 //   height: sch*0.025,
//                 // ),
//                 // Icon(
//                 //   1==2 ? Icons.bookmark : Icons.bookmark_border,
//                 //   color: 1==2 ? MateColors.activeIcons : Colors.white,
//                 //   size: 23,
//                 // ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
