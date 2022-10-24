// import 'dart:convert';
// import 'dart:io';
//
// import 'package:mate_app/Providers/AuthUserProvider.dart';
// import 'package:mate_app/Screen/Home/TimeLine/TimeLine.dart';
// import 'package:mate_app/Screen/Profile/CamousLiveByAuthUser.dart';
// import 'package:mate_app/Screen/Profile/ProfileEditScreen.dart';
// import 'package:mate_app/Screen/Profile/communityTalkByUser.dart';
// import 'package:mate_app/Screen/chat1/personalChatPage.dart';
// import 'package:mate_app/Utility/Utility.dart';
// import 'package:mate_app/Widget/Drawer/DrawerWidget.dart';
// import 'package:mate_app/asset/Colors/MateColors.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_switch/flutter_switch.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_navigation/src/extension_navigation.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
// import 'package:sizer/sizer.dart';
// import 'AboutScreen.dart';
// import 'FollowersScreen.dart';
// import 'FollowingScreen.dart';
//
// class ProfileScreen extends StatefulWidget {
//   static final String profileScreenRoute = '/profile';
//
//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends State<ProfileScreen> with TickerProviderStateMixin {
//   File _image;
//   File _coverImage;
//   final picker = ImagePicker();
//   String _base64encodedImage;
//   TabController _tabController;
//   String imageSource = "Camera";
//
//   void initState() {
//     super.initState();
//     _tabController = new TabController(length: 4, vsync: this);
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   Widget _profileScreenAppBar(BuildContext context) {
//     Future.delayed(Duration(seconds: 0), () {
//       Provider.of<AuthUserProvider>(context, listen: false).getUserProfileData();
//     });
//
//     return AppBar(
//         // title: Text('Your Profile'),
//         leading: _appBarLeading(context),
//         backgroundColor: myHexColor,
//         actions: <Widget>[
//           // _messageIcon()
//           Padding(
//               padding: const EdgeInsets.only(right: 12.0),
//               child: IconButton(
//                 icon: Icon(Icons.edit),
//                 onPressed: () {
//                   Navigator.of(context).pushNamed(ProfileEditScreen.profileEditRouteName);
//                 },
//               ))
//         ],
//         elevation: 0,
//         bottom: PreferredSize(preferredSize: Size.fromHeight(2), child: _bottomLine()));
//   }
//
//   modalSheet() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: myHexColor,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(
//           top: Radius.circular(15.0),
//         ),
//       ),
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return Padding(
//               padding: const EdgeInsets.all(18.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: <Widget>[
//                   Text(
//                     "Please select image source.",
//                     style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w500, color: Colors.white),
//                   ),
//                   SizedBox(
//                     height: 10.0,
//                   ),
//                   Theme(
//                     data: ThemeData(
//                       unselectedWidgetColor: MateColors.inActiveIcons, // Your color
//                     ),
//                     child: RadioListTile(
//                       activeColor: MateColors.activeIcons,
//                       contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
//                       title: Text(
//                         "Camera",
//                         style: TextStyle(
//                           fontSize: 12.5.sp,
//                           color: Colors.white70,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       value: "Camera",
//                       groupValue: imageSource,
//                       onChanged: (value) {
//                         setState(() {
//                           imageSource = value;
//                           print(imageSource);
//                         });
//                       },
//                     ),
//                   ),
//                   Theme(
//                     data: ThemeData(
//                       unselectedWidgetColor: MateColors.inActiveIcons, // Your color
//                     ),
//                     child: RadioListTile(
//                       activeColor: MateColors.activeIcons,
//                       contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
//                       title: Text(
//                         "Gallery",
//                         style: TextStyle(
//                           fontSize: 12.5.sp,
//                           color: Colors.white70,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       value: "Gallery",
//                       groupValue: imageSource,
//                       onChanged: (value) {
//                         setState(() {
//                           imageSource = value;
//                           print(imageSource);
//                         });
//                       },
//                     ),
//                   ),
//                   SizedBox(
//                     height: 15.0,
//                   ),
//                   InkWell(
//                     onTap: () {
//                       if (imageSource == "Gallery") {
//                         _getImage(1);
//                       } else {
//                         _getImage(2);
//                       }
//                     },
//                     child: Container(
//                       height: 40.0,
//                       width: MediaQuery.of(context).size.width,
//                       // margin: EdgeInsets.all(2),
//                       alignment: Alignment.center,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                           boxShadow: <BoxShadow>[
//                             BoxShadow(
//                                 color: Colors.transparent,
//                                 // offset: Offset(2, 4),
//                                 blurRadius: 5,
//                                 spreadRadius: 0)
//                           ],
//                           gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Colors.teal, MateColors.activeIcons])),
//                       child: Text(
//                         'Continue',
//                         style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w600, color: Colors.white),
//                       ),
//                     ),
//                   ),
//                   // SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   modalSheetForCoverPic() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: myHexColor,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(
//           top: Radius.circular(15.0),
//         ),
//       ),
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return Padding(
//               padding: const EdgeInsets.all(18.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: <Widget>[
//                   Text(
//                     "Please select image source.",
//                     style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w500, color: Colors.white),
//                   ),
//                   SizedBox(
//                     height: 10.0,
//                   ),
//                   Theme(
//                     data: ThemeData(
//                       unselectedWidgetColor: MateColors.inActiveIcons, // Your color
//                     ),
//                     child: RadioListTile(
//                       activeColor: MateColors.activeIcons,
//                       contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
//                       title: Text(
//                         "Camera",
//                         style: TextStyle(
//                           fontSize: 12.5.sp,
//                           color: Colors.white70,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       value: "Camera",
//                       groupValue: imageSource,
//                       onChanged: (value) {
//                         setState(() {
//                           imageSource = value;
//                           print(imageSource);
//                         });
//                       },
//                     ),
//                   ),
//                   Theme(
//                     data: ThemeData(
//                       unselectedWidgetColor: MateColors.inActiveIcons, // Your color
//                     ),
//                     child: RadioListTile(
//                       activeColor: MateColors.activeIcons,
//                       contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
//                       title: Text(
//                         "Gallery",
//                         style: TextStyle(
//                           fontSize: 12.5.sp,
//                           color: Colors.white70,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       value: "Gallery",
//                       groupValue: imageSource,
//                       onChanged: (value) {
//                         setState(() {
//                           imageSource = value;
//                           print(imageSource);
//                         });
//                       },
//                     ),
//                   ),
//                   SizedBox(
//                     height: 15.0,
//                   ),
//                   InkWell(
//                     onTap: () {
//                       if (imageSource == "Gallery") {
//                         _getCoverImage(1);
//                       } else {
//                         _getCoverImage(2);
//                       }
//                     },
//                     child: Container(
//                       height: 40.0,
//                       width: MediaQuery.of(context).size.width,
//                       // margin: EdgeInsets.all(2),
//                       alignment: Alignment.center,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                           boxShadow: <BoxShadow>[
//                             BoxShadow(
//                                 color: Colors.transparent,
//                                 // offset: Offset(2, 4),
//                                 blurRadius: 5,
//                                 spreadRadius: 0)
//                           ],
//                           gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Colors.teal, MateColors.activeIcons])),
//                       child: Text(
//                         'Continue',
//                         style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w600, color: Colors.white),
//                       ),
//                     ),
//                   ),
//                   // SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   Future _getImage(int option) async {
//     PickedFile pickImage;
//     if (option == 1) {
//       pickImage = await picker.getImage(source: ImageSource.gallery);
//     } else
//       pickImage = await picker.getImage(source: ImageSource.camera);
//
//     if (pickImage != null) {
//       _image = File(pickImage.path);
//
//       var img = _image.readAsBytesSync();
//
//       _base64encodedImage = base64Encode(img);
//
//       print('image selected:: ${_image.toString()}');
//
//       Provider.of<AuthUserProvider>(context, listen: false).updatePhoto(imageFile: _base64encodedImage);
//     } else {
//       print('No image selected.');
//     }
//     Navigator.of(context).pop();
//   }
//
//   Future _getCoverImage(int option) async {
//     PickedFile pickImage;
//     if (option == 1) {
//       pickImage = await picker.getImage(source: ImageSource.gallery, imageQuality: 50);
//     } else
//       pickImage = await picker.getImage(source: ImageSource.camera, imageQuality: 50);
//
//     if (pickImage != null) {
//       _coverImage = File(pickImage.path);
//
//       var img = _coverImage.readAsBytesSync();
//
//       _base64encodedImage = base64Encode(img);
//
//       print('image selected:: ${_coverImage.toString()}');
//
//       Provider.of<AuthUserProvider>(context, listen: false).updateCoverPhoto(imageFile: _base64encodedImage);
//     } else {
//       print('No image selected.');
//     }
//     Navigator.of(context).pop();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Future.delayed(Duration(seconds: 0), () {
//       Provider.of<AuthUserProvider>(context, listen: false).getUserProfileData();
//     });
//
//     return Scaffold(
//       backgroundColor: myHexColor,
//       appBar: _profileScreenAppBar(context),
//       drawer: DrawerWidget(),
//       body: Consumer<AuthUserProvider>(
//         builder: (ctx, authUserProvider, _) {
//           print('Consumer NOtified');
//           // body: SingleChildScrollView(
//
//           return _profileBody(context, authUserProvider);
//         },
//         // ),
//       ),
//     );
//   }
//
//   Widget _appBarLeading(BuildContext context) {
//     // return
//     // Selector<AuthUserProvider, String>(
//     //   selector: (ctx, authUserProvider) => authUserProvider.authUserPhoto,
//     //   builder: (ctx, data, _) {
//     return Consumer<AuthUserProvider>(builder: (ctx, provider, _) {
//       return Padding(
//         padding: const EdgeInsets.only(left: 16.0),
//         child: InkWell(
//             onTap: () {
//               Scaffold.of(ctx).openDrawer();
//             },
//             child: SizedBox(
//                 height: 36,
//                 width: 36,
//                 child: CircleAvatar(
//                     backgroundColor: MateColors.activeIcons,
//                     child: SizedBox(
//                       height: 35,
//                       width: 35,
//                       child: CircleAvatar(
//                         backgroundColor: Colors.transparent,
//                         child: ClipOval(
//                             child: Image.network(
//                           provider.authUser.photoUrl,
//                           height: 35,
//                           width: 35,
//                         )),
//                       ),
//                     )))),
//       );
//       // });
//     });
//   }
//
//   Padding _messageIcon() {
//     return Padding(
//       padding: const EdgeInsets.only(top: 4.0, right: 8.0),
//       child: Stack(
//         children: [
//           IconButton(
//             iconSize: 27,
//             icon: Image.asset(
//               "lib/asset/icons/message.png",
//               width: 27,
//               fit: BoxFit.fitWidth,
//             ),
//             onPressed: () {
//               Get.to(() => PersonalChatScreen());
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   Container _bottomLine() {
//     return Container(
//       color: MateColors.line,
//       height: 2.0,
//     );
//   }
//
//   Widget _backButton() {
//     return Positioned(
//       left: 5,
//       top: 0,
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: <Widget>[
//           IconButton(
//             icon: Icon(Icons.arrow_back_ios),
//             iconSize: 22,
//             color: MateColors.activeIcons,
//             tooltip: 'Back to Home',
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           ),
//           Text(
//             "",
//             textAlign: TextAlign.left,
//             style: TextStyle(
//               color: MateColors.activeIcons,
//               fontSize: 17.5,
//               fontFamily: "Rubik",
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _coverPicEditButton() {
//     return Positioned(
//       right: 5,
//       top: 0,
//       child: IconButton(
//         icon: Icon(Icons.edit),
//         iconSize: 22,
//         color: MateColors.activeIcons,
//         tooltip: 'Edit Cover Photo',
//         onPressed: () {
//           modalSheetForCoverPic();
//         },
//       ),
//     );
//   }
//
//   Widget _profileDisplay(BuildContext context) {
//     // return Selector<AuthUserProvider, String>(
//     //     selector: (ctx, authUserProvider) => authUserProvider.authUserPhoto,
//     //     builder: (ctx, data, _) {
//     return Consumer<AuthUserProvider>(builder: (ctx, provider, _) {
//       return Stack(
//         children: [
//           Container(
//             height: 240,
//             width: MediaQuery.of(context).size.width,
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: (provider.authUser.coverPhotoUrl != null && provider.authUser.coverPhotoUrl != "")
//                     ? NetworkImage(provider.authUser.coverPhotoUrl)
//                     : AssetImage("lib/asset/icons/profile-cover.png"),
//                 fit: BoxFit.cover,
//               ),
//             ),
//             child: null /* add child content here */,
//           ),
//           _profileTopItems(provider),
//           _backButton(),
//           _coverPicEditButton(),
//         ],
//       );
//       // });
//     });
//   }
//
//   Widget _profileBody(BuildContext context, AuthUserProvider provider) {
//     return NestedScrollView(
//       headerSliverBuilder: (context, value) {
//         return [
//           SliverToBoxAdapter(
//             child: Column(
//               mainAxisSize: MainAxisSize.max,
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: <Widget>[
//                 _profileDisplay(context),
//                 _bottomLine(),
//               ],
//             ),
//           ),
//           SliverToBoxAdapter(
//             child: TabBar(
//               controller: _tabController,
//               isScrollable: true,
//               unselectedLabelColor: MateColors.line,
//               indicatorColor: Colors.transparent,
//               labelColor: MateColors.activeIcons,
//               labelStyle: TextStyle(
//                 color: MateColors.activeIcons,
//                 fontSize: 11.7.sp,
//                 fontFamily: "Rubik",
//                 fontWeight: FontWeight.w700,
//               ),
//               tabs: [
//                 Tab(
//                   text: "About",
//                 ),
//                 Tab(
//                   text: "Posts",
//                 ),
//                 Tab(
//                   text: "CampusLive",
//                 ),
//                 Tab(
//                   text: "CampusTalk",
//                 ),
//               ],
//             ),
//           ),
//         ];
//       },
//       body: Container(
//         decoration: BoxDecoration(border: Border(top: BorderSide(color: MateColors.line, width: 2))),
//         child: TabBarView(
//           controller: _tabController,
//           children: [
//             AboutScreen(
//               uuid: provider.authUser.id,
//               authUser: true,
//             ),
//             TimeLine(userId: provider.authUser.id),
//             CampusLiveByAuthUser(
//               uuid: provider.authUser.id,
//             ),
//             CampusTalkByUser(
//               uuid: provider.authUser.id,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _profileTopItems(AuthUserProvider provider) {
//     return Column(
//       mainAxisSize: MainAxisSize.max,
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: <Widget>[
//         Center(
//             child: Padding(
//                 padding: const EdgeInsets.only(top: 30.0),
//                 child: InkWell(
//                   onTap: () {
//                     modalSheet();
//                   },
//                   child: Stack(
//                     // alignment: Alignment.topCenter,
//                     children: [
//                       CircleAvatar(
//                           backgroundColor: MateColors.activeIcons,
//                           radius: 41.4,
//                           child: CircleAvatar(
//                             radius: 40,
//                             backgroundImage: NetworkImage(provider.authUser.photoUrl),
//                             child: Visibility(
//                               visible: provider.photoUpdateLoaderStatus,
//                               child: CircularProgressIndicator(
//                                 color: Colors.white,
//                               ),
//                             ),
//                           )),
//                       Positioned(
//                         right: 0,
//                         top: 4,
//                         child: CircleAvatar(
//                           radius: 11.5,
//                           backgroundColor: MateColors.activeIcons,
//                           child: Icon(
//                             Icons.edit,
//                             color: Colors.black,
//                             size: 13,
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ))),
//         /*Padding(
//           padding: const EdgeInsets.only(bottom: 10, top: 12),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Expanded(
//                   child: Text(
//                     provider.authUser.displayName,
//                     style: TextStyle(fontSize: 25, color: Colors.white),
//                     textAlign: TextAlign.center,
//                   ))
//             ],
//           ),
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Expanded(
//                 child: Text(
//                   provider.authUser.email,
//                   style: TextStyle(fontSize: 12, color: Colors.white),
//                   textAlign: TextAlign.center,
//                 )),
//           ],
//         ),
//         Padding(
//           padding: const EdgeInsets.only(bottom: 8.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Expanded(
//                   child: Text(
//                     provider.authUser.phoneNumber,
//                     style: TextStyle(fontSize: 12, color: Colors.white),
//                     textAlign: TextAlign.center,
//                   )),
//             ],
//           ),
//         ),*/
//         Padding(
//           padding: const EdgeInsets.only(bottom: 20.0, top: 25),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: <Widget>[
//               Column(
//                 children: <Widget>[
//                   Center(
//                       child: GestureDetector(
//                     onTap: () {
//                       Navigator.of(context).pushNamed(FollowersScreen.routeName);
//                     },
//                     child: Text(provider.authUser.totalFollowers.toString(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 11.7.sp)),
//                   )),
//                   Center(
//                       child: GestureDetector(
//                     onTap: () {
//                       Navigator.of(context).pushNamed(FollowersScreen.routeName);
//                     },
//                     child: Text(provider.authUser.totalFollowers > 1 ? 'Followers' : 'Follower', style: TextStyle(color: Colors.white, fontSize: 11.7.sp)),
//                   )),
//                 ],
//               ),
//               Column(
//                 children: <Widget>[
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.of(context).pushNamed(FollowingScreen.routeName);
//                     },
//                     child: Text(
//                       provider.authUser.totalFollowings.toString(),
//                       style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 11.7.sp),
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.of(context).pushNamed(FollowingScreen.routeName);
//                     },
//                     child: Text('Following', style: TextStyle(color: Colors.white, fontSize: 11.7.sp)),
//                   ),
//                 ],
//               ),
//               Column(
//                 children: <Widget>[
//                   Text(
//                     provider.authUser.totalFeeds.toString(),
//                     style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 11.7.sp),
//                   ),
//                   Text('Posts', style: TextStyle(color: Colors.white, fontSize: 11.7.sp)),
//                 ],
//               ),
//               Column(
//                 children: <Widget>[
//                   Text(
//                     provider.authUser.totalFeedComments.toString(),
//                     style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 11.7.sp),
//                   ),
//                   Text('Post Comments', style: TextStyle(color: Colors.white, fontSize: 11.7.sp)),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         Align(
//           alignment: Alignment.centerRight,
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text("Notification Alert", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 11.7.sp)),
//               Padding(
//                 padding: const EdgeInsets.only(left: 8.0, right: 10.0),
//                 child: FlutterSwitch(
//                   width: 45.0,
//                   height: 23.0,
//                   valueFontSize: 0.0,
//                   toggleSize: 16.0,
//                   value: provider.authUser.isNotify??false,
//                   borderRadius: 30.0,
//                   padding: 3.0,
//                   showOnOff: true,
//                   activeColor: myHexColor,
//                   inactiveToggleColor: Colors.white60,
//                   activeToggleColor: MateColors.activeIcons,
//                   inactiveColor: myHexColor,
//                   switchBorder: Border.all(
//                     color: MateColors.activeIcons,
//                     width: 0.5,
//                   ),
//                   onToggle: (val) async {
//                     setState(() {});
//                     bool updated = await Provider.of<AuthUserProvider>(context, listen: false).updateNotification();
//                     // if (updated) {
//                     //   if (value.beAMateActiveData != null) {
//                     //     // IsBookmarked
//                     //     if (value.beAMateActiveData.message == "Post activated successfully" && value.beAMateActiveData.data.id == beAMateId) {
//                     //       value.beAMatePostsDataList[widget.rowIndex].isActive = true;
//                     //       isActive = true;
//                     //     } else if (value.beAMateActiveData.message == "Post de-activated successfully" && value.beAMateActiveData.data.id == beAMateId) {
//                     //       value.beAMatePostsDataList[widget.rowIndex].isActive = false;
//                     //       isActive = false;
//                     //     }
//                     //   }
//                     // }
//                   },
//                 ),
//               ),
//             ],
//           ),
//         )
//       ],
//     );
//   }
//
// // ,
// // Padding(
// // padding: const EdgeInsets.all(16.0),
// // child: Text(
// // authUserProvider.authUser.about,
// // textAlign: TextAlign.center,
// // style: TextStyle(color: Colors.white),
// // ),
// // )
//
// // Widget tdt() {
// //   return Column(
// //     mainAxisSize: MainAxisSize.max,
// //     crossAxisAlignment: CrossAxisAlignment.stretch,
// //     mainAxisAlignment: MainAxisAlignment.start,
// //     children: <Widget>[
// //       Padding(
// //         padding: const EdgeInsets.symmetric(vertical: 16.0),
// //         child: Row(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: <Widget>[
// //             Container(
// //               height: 100,
// //               width: 100,
// //               decoration: BoxDecoration(
// //                   color: Colors.black,
// //                   borderRadius: BorderRadius.circular(100.0),
// //                   boxShadow: [
// //                     BoxShadow(
// //                         color: Colors.black38,
// //                         offset: Offset(0.0, 10.0),
// //                         blurRadius: 10.0),
// //                   ]),
// //               child: ClipRRect(
// //                 borderRadius: BorderRadius.circular(100.0),
// //                 child: InkWell(
// //                   splashColor: Colors.teal,
// //                   onTap: () async {
// //                     _getImage(context);
// //                   },
// //                   child: Image.network(authUserProvider.authUserPhoto,
// //                       height: 100, width: 100, fit: BoxFit.contain),
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //       Padding(
// //         padding: const EdgeInsets.only(bottom: 8.0),
// //         child: Row(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: <Widget>[
// //             Expanded(
// //                 child: Text(
// //               authUserProvider.authUser.displayName,
// //               style: TextStyle(fontSize: 25, color: Colors.white),
// //               textAlign: TextAlign.center,
// //             ))
// //           ],
// //         ),
// //       ),
// //       Row(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: <Widget>[
// //           Expanded(
// //               child: Text(
// //             authUserProvider.authUser.email,
// //             style: TextStyle(fontSize: 12, color: Colors.white),
// //             textAlign: TextAlign.center,
// //           )),
// //         ],
// //       ),
// //       Padding(
// //         padding: const EdgeInsets.only(bottom: 8.0),
// //         child: Row(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: <Widget>[
// //             Expanded(
// //                 child: Text(
// //               authUserProvider.authUser.phoneNumber,
// //               style: TextStyle(fontSize: 12, color: Colors.white),
// //               textAlign: TextAlign.center,
// //             )),
// //           ],
// //         ),
// //       ),
// //       Padding(
// //         padding: const EdgeInsets.only(bottom: 16.0),
// //         child: Row(
// //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //           children: <Widget>[
// //             Column(
// //               children: <Widget>[
// //                 Center(
// //                     child: Text(
// //                         authUserProvider.authUser.totalFollowers
// //                             .toString(),
// //                         style: TextStyle(
// //                             fontWeight: FontWeight.bold,
// //                             color: Colors.white))),
// //                 Center(
// //                     child: Text(
// //                         authUserProvider.authUser.totalFollowers > 1
// //                             ? 'Followers'
// //                             : 'Follower',
// //                         style: TextStyle(color: Colors.white))),
// //               ],
// //             ),
// //             Column(
// //               children: <Widget>[
// //                 Center(
// //                     child: Text(
// //                         authUserProvider.authUser.totalFollowings
// //                             .toString(),
// //                         style: TextStyle(
// //                             fontWeight: FontWeight.bold,
// //                             color: Colors.white))),
// //                 Center(
// //                     child: Text(
// //                   'Following',
// //                   style: TextStyle(color: Colors.white),
// //                 )),
// //               ],
// //             ),
// //           ],
// //         ),
// //       ),
// //       Padding(
// //         padding: const EdgeInsets.symmetric(horizontal: 16),
// //         child: Divider(
// //           thickness: 1,
// //           color: Colors.white24,
// //         ),
// //       ),
// //       Row(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: <Widget>[
// //           Text(
// //             'About',
// //             style: TextStyle(fontSize: 30, color: Colors.white),
// //           )
// //         ],
// //       ),
// //       Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Text(
// //           authUserProvider.authUser.about,
// //           textAlign: TextAlign.center,
// //           style: TextStyle(color: Colors.white),
// //         ),
// //       ),
// //       Row(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: <Widget>[
// //           Text(
// //             'Achievements',
// //             style: TextStyle(fontSize: 30, color: Colors.white),
// //           )
// //         ],
// //       ),
// //       Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Text(
// //           authUserProvider.authUser.achievements,
// //           textAlign: TextAlign.center,
// //           style: TextStyle(color: Colors.white),
// //         ),
// //       ),
// //       Row(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: <Widget>[
// //           Text(
// //             'Societies',
// //             style: TextStyle(fontSize: 30, color: Colors.white),
// //           )
// //         ],
// //       ),
// //       Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Text(
// //           authUserProvider.authUser.societies,
// //           textAlign: TextAlign.center,
// //           style: TextStyle(color: Colors.white),
// //         ),
// //       ),
// //       Row(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: <Widget>[
// //           Text(
// //             'Your Posts',
// //             style: TextStyle(fontSize: 30, color: Colors.white),
// //           )
// //         ],
// //       ),
// //       Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Row(
// //           mainAxisAlignment: MainAxisAlignment.spaceAround,
// //           children: <Widget>[
// //             Image.asset('lib/asset/molla.png',
// //                 fit: BoxFit.cover,
// //                 width: MediaQuery.of(context).size.width / 2.4,
// //                 height: 100),
// //             Image.asset('lib/asset/demo.png',
// //                 fit: BoxFit.cover,
// //                 width: MediaQuery.of(context).size.width / 2.4,
// //                 height: 100),
// //           ],
// //         ),
// //       ),
// //       Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Row(
// //           mainAxisAlignment: MainAxisAlignment.spaceAround,
// //           children: <Widget>[
// //             Image.asset('lib/asset/demo.png',
// //                 fit: BoxFit.cover,
// //                 width: MediaQuery.of(context).size.width / 2.4,
// //                 height: 100),
// //             Image.asset('lib/asset/molla2.png',
// //                 fit: BoxFit.cover,
// //                 width: MediaQuery.of(context).size.width / 2.4,
// //                 height: 100),
// //           ],
// //         ),
// //       ),
// //       Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Row(
// //           mainAxisAlignment: MainAxisAlignment.spaceAround,
// //           children: <Widget>[
// //             Image.asset('lib/asset/molla.png',
// //                 fit: BoxFit.cover,
// //                 width: MediaQuery.of(context).size.width / 2.4,
// //                 height: 100),
// //             Image.asset('lib/asset/demo.png',
// //                 fit: BoxFit.cover,
// //                 width: MediaQuery.of(context).size.width / 2.4,
// //                 height: 100),
// //           ],
// //         ),
// //       ),
// //     ],
// //   );
// // }
//
// }



//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
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mate_app/Screen/Profile/bio_details_page.dart';
import 'package:mate_app/Screen/Profile/updateProfile.dart';
import 'package:mate_app/Screen/SplashScreen.dart';
import 'package:mate_app/Services/AuthUserService.dart';
import 'package:mate_app/constant.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../Providers/AuthUserProvider.dart';
import '../../Providers/FeedProvider.dart';
import '../../Utility/Utility.dart';
import '../../Widget/Home/HomeRow.dart';
import '../../Widget/Loaders/Shimmer.dart';
import '../../asset/Colors/MateColors.dart';
import '../../controller/theme_controller.dart';
import '../Login/GoogleLogin.dart';
import 'FollowersScreen.dart';
import 'FollowingScreen.dart';

class ProfileScreen extends StatefulWidget {
  static final String profileScreenRoute = '/profile';
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String imageSource = "Camera";
  final picker = ImagePicker();
  File _image;
  File _coverImage;
  String _base64encodedImage;
  ScrollController _scrollController;
  int _page;
  String userId;

  @override
  void initState() {
    authUserProvider = Provider.of<AuthUserProvider>(context, listen: false);
    userId = Provider.of<AuthUserProvider>(context, listen: false).authUser.id;
    Future.delayed(Duration(milliseconds: 600), (){
      Provider.of<FeedProvider>(context, listen: false).fetchFeedList(page: 1,userId: userId);
    });
    _page = 1;
    _scrollController = new ScrollController()..addListener(_scrollListener);
    super.initState();
  }

  AuthUserProvider authUserProvider;

  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels != 0) {
        Future.delayed(Duration.zero,(){
          _page += 1;
          print('scrolled to bottom page is now $_page');
          Provider.of<FeedProvider>(context, listen: false).fetchFeedList(page: _page, paginationCheck: true, userId: userId);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeController themeController = Get.find<ThemeController>();
    Future.delayed(Duration(seconds: 0), () {
      Provider.of<AuthUserProvider>(context, listen: false).getUserInfo(userId);
    });
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              height: 360,
              decoration: BoxDecoration(
                color: themeController.isDarkMode?MateColors.drawerTileColor:Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Consumer<AuthUserProvider>(builder: (ctx, provider, _) {
                return Stack(
                  children: [
                    Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: (provider.authUser.coverPhotoUrl != null && provider.authUser.coverPhotoUrl != "")
                              ? NetworkImage(provider.authUser.coverPhotoUrl)
                              : AssetImage("lib/asset/icons/profile-cover-new.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: InkWell(
                          onTap: (){
                            //modalSheet();
                          },
                          child: CircleAvatar(
                            backgroundColor: themeController.isDarkMode?MateColors.blackTextColor:Colors.white,
                            radius: 50,
                            child: CircleAvatar(
                              radius: 46,
                              backgroundImage: NetworkImage(provider.authUser.photoUrl),
                              child: Visibility(
                                visible: provider.photoUpdateLoaderStatus,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 170),
                        child: Text(provider.authUser.displayName,
                          style: TextStyle(
                            color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 17.0,
                          ),
                        ),
                      ),
                    ),
                    Consumer<AuthUserProvider>(
                      builder: (context, userProvider, _){
                        if(!userProvider.userAboutDataLoader && userProvider.userAboutData != null){
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 260,left: 25,right: 25),
                              child: InkWell(
                                onTap: (){
                                  Get.to(BioDetailsPage(bio: userProvider.userAboutData.data.about??"",));
                                  // if(userProvider.userAboutData.data.about!=null){
                                  //   Get.to(ChangeAbout(uuid: provider.authUser.id,text: userProvider.userAboutData.data.about,));
                                  // }
                                },
                                child: Text(
                                  userProvider.userAboutData.data.about??"",
                                  //"hello world just loke other hope value of the text just like hope that is nothing to do with person on the planet hope you are doing well but sould know the value of the person that is very improtant in the field of biology",
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 0.1,
                                    color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }else{
                          return Container();
                        }
                      },
                    ),
                    Positioned(
                      left: 16,
                      top: 20,
                      child: InkWell(
                        onTap: (){
                          Get.back();
                        },
                        child: Icon(Icons.arrow_back,
                          size: 23,
                          color: themeController.isDarkMode?Colors.black:Colors.white,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 16,
                      top: 20,
                      child: InkWell(
                        onTap: (){
                          Get.to(UpdateProfile(
                            fullName: provider.authUser.displayName,
                            about: provider.userAboutData.data.about,
                            uuid: provider.authUser.id,
                            universityId: provider.authUser.universityId,
                            photoUrl: provider.authUser.photoUrl,
                            coverPhotoUrl: provider.authUser.coverPhotoUrl,
                          ));
                         // modalSheetForCoverPic();
                        },
                        child: Image.asset("lib/asset/icons/edit.png",
                          height: 23,
                          color: themeController.isDarkMode?Colors.black:Colors.white,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 50,
                      top: 22,
                      child: InkWell(
                        onTap: (){
                          _showDeleteDialog(uuid: provider.authUser.id);
                        },
                        child: Image.asset(
                          "lib/asset/icons/trashNew.png",
                          height: 20,
                          width: 20,
                          color: themeController.isDarkMode?Colors.black:Colors.white,
                        ),
                      ),
                    ),
                    //_profileTopItems(provider),
                  ],
                );
              }),
            ),
            Container(
              height: 1,
              width: MediaQuery.of(context).size.width,
              color: themeController.isDarkMode?MateColors.darkDivider:Colors.white,
            ),
            Expanded(
              child: Consumer<FeedProvider>(
                builder: (ctx, feedProvider, _){
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    controller: _scrollController,
                    shrinkWrap: true,
                    padding: EdgeInsets.only(top: 10),
                    physics: ScrollPhysics(),
                    itemCount: feedProvider.feedItemListOfUser.length,//feedProvider.feedList.length,
                    itemBuilder: (context,index){
                      var feedItem = feedProvider.feedItemListOfUser[index];//feedProvider.feedList[index];
                      return Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: HomeRow(
                          previousPageUserId: userId,
                          id: feedItem.id,
                          feedId: feedItem.feedId,
                          title: feedItem.title,
                          feedType: feedItem.feedTypes,
                          start: feedItem.start,
                          end: feedItem.end,
                          calenderDate: feedItem.feedCreatedAt,
                          description: feedItem.description,
                          created: feedItem.created,
                          user: feedItem.user,
                          location: feedItem.location,
                          hyperlinkText: feedItem.hyperlinkText,
                          hyperlink: feedItem.hyperlink,
                          media: feedItem.media,
                          isLiked: feedItem.isLiked,
                          liked: feedItem.isLiked!=null?true:false,
                          bookMarked: feedItem.isBookmarked,
                          isFollowed: feedItem.isFollowed??false,
                          likeCount: feedItem.likeCount,
                          bookmarkCount: feedItem.bookmarkCount,
                          shareCount: feedItem.shareCount,
                          commentCount: feedItem.commentCount,
                          isShared: feedItem.isShared,
                          indexVal: index,
                          pageType: "User",
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

    modalSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15.0),
        ),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "Please select image source.",
                    style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w500, color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Theme(
                    data: ThemeData(
                      unselectedWidgetColor: MateColors.inActiveIcons, // Your color
                    ),
                    child: RadioListTile(
                      activeColor: MateColors.activeIcons,
                      contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
                      title: Text(
                        "Camera",
                        style: TextStyle(
                          fontSize: 12.5.sp,
                          color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      value: "Camera",
                      groupValue: imageSource,
                      onChanged: (value) {
                        setState(() {
                          imageSource = value;
                          print(imageSource);
                        });
                      },
                    ),
                  ),
                  Theme(
                    data: ThemeData(
                      unselectedWidgetColor: MateColors.inActiveIcons, // Your color
                    ),
                    child: RadioListTile(
                      activeColor: MateColors.activeIcons,
                      contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
                      title: Text(
                        "Gallery",
                        style: TextStyle(
                          fontSize: 12.5.sp,
                          color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      value: "Gallery",
                      groupValue: imageSource,
                      onChanged: (value) {
                        setState(() {
                          imageSource = value;
                          print(imageSource);
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  InkWell(
                    onTap: () {
                      if (imageSource == "Gallery") {
                        _getImage(1);
                      } else {
                        _getImage(2);
                      }
                    },
                    child: Container(
                      height: 40.0,
                      width: MediaQuery.of(context).size.width,
                      // margin: EdgeInsets.all(2),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.transparent,
                                // offset: Offset(2, 4),
                                blurRadius: 5,
                                spreadRadius: 0)
                          ],
                        color: MateColors.activeIcons,
                      ),
                          //gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Colors.teal, MateColors.activeIcons])),
                      child: Text(
                        'Continue',
                        style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w600, color: themeController.isDarkMode?MateColors.blackTextColor:Colors.white,),
                      ),
                    ),
                  ),
                  // SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                ],
              ),
            );
          },
        );
      },
    );
  }

    Future _getImage(int option) async {
    PickedFile pickImage;
    if (option == 1) {
      pickImage = await picker.getImage(source: ImageSource.gallery);
    } else
      pickImage = await picker.getImage(source: ImageSource.camera);

    if (pickImage != null) {
      _image = File(pickImage.path);

      var img = _image.readAsBytesSync();

      _base64encodedImage = base64Encode(img);

      print('image selected:: ${_image.toString()}');

      Provider.of<AuthUserProvider>(context, listen: false).updatePhoto(imageFile: _base64encodedImage);
    } else {
      print('No image selected.');
    }
    Navigator.of(context).pop();
  }


  modalSheetForCoverPic() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      //backgroundColor: myHexColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15.0),
        ),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "Please select image source.",
                    style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w500, color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Theme(
                    data: ThemeData(
                      unselectedWidgetColor: MateColors.inActiveIcons, // Your color
                    ),
                    child: RadioListTile(
                      activeColor: MateColors.activeIcons,
                      contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
                      title: Text(
                        "Camera",
                        style: TextStyle(
                          fontSize: 12.5.sp,
                          color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      value: "Camera",
                      groupValue: imageSource,
                      onChanged: (value) {
                        setState(() {
                          imageSource = value;
                          print(imageSource);
                        });
                      },
                    ),
                  ),
                  Theme(
                    data: ThemeData(
                      unselectedWidgetColor: MateColors.inActiveIcons, // Your color
                    ),
                    child: RadioListTile(
                      activeColor: MateColors.activeIcons,
                      contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
                      title: Text(
                        "Gallery",
                        style: TextStyle(
                          fontSize: 12.5.sp,
                          color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      value: "Gallery",
                      groupValue: imageSource,
                      onChanged: (value) {
                        setState(() {
                          imageSource = value;
                          print(imageSource);
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  InkWell(
                    onTap: () {
                      if (imageSource == "Gallery") {
                        _getCoverImage(1);
                      } else {
                        _getCoverImage(2);
                      }
                    },
                    child: Container(
                      height: 40.0,
                      width: MediaQuery.of(context).size.width,
                      // margin: EdgeInsets.all(2),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.transparent,
                                // offset: Offset(2, 4),
                                blurRadius: 5,
                                spreadRadius: 0)
                          ],
                          color: MateColors.activeIcons,
                         // gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Colors.teal, MateColors.activeIcons])
                      ),
                      child: Text(
                        'Continue',
                        style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w600, color: themeController.isDarkMode?MateColors.blackTextColor:Colors.white,),
                      ),
                    ),
                  ),
                  // SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future _getCoverImage(int option) async {
    PickedFile pickImage;
    if (option == 1) {
      pickImage = await picker.getImage(source: ImageSource.gallery, imageQuality: 50);
    } else
      pickImage = await picker.getImage(source: ImageSource.camera, imageQuality: 50);

    if (pickImage != null) {
      _coverImage = File(pickImage.path);

      var img = _coverImage.readAsBytesSync();

      _base64encodedImage = base64Encode(img);

      print('image selected:: ${_coverImage.toString()}');

      Provider.of<AuthUserProvider>(context, listen: false).updateCoverPhoto(imageFile: _base64encodedImage);
    } else {
      print('No image selected.');
    }
    Navigator.of(context).pop();
  }


   Widget _profileTopItems(AuthUserProvider provider) {
    return Positioned(
      bottom: -3,
      right: 10,
      left: 10,
      child: Column(
        // mainAxisSize: MainAxisSize.max,
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        // mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0, top: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                // Column(
                //   children: <Widget>[
                //     Center(
                //         child: GestureDetector(
                //       onTap: () {
                //         Navigator.of(context).pushNamed(FollowersScreen.routeName);
                //       },
                //       child: Text(provider.authUser.totalFollowers.toString(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 11.7.sp)),
                //     )),
                //     Center(
                //         child: GestureDetector(
                //       onTap: () {
                //         Navigator.of(context).pushNamed(FollowersScreen.routeName);
                //       },
                //       child: Text(provider.authUser.totalFollowers > 1 ? 'Followers' : 'Follower', style: TextStyle(color: Colors.white, fontSize: 11.7.sp)),
                //     )),
                //   ],
                // ),
                // Column(
                //   children: <Widget>[
                //     GestureDetector(
                //       onTap: () {
                //         Navigator.of(context).pushNamed(FollowingScreen.routeName);
                //       },
                //       child: Text(
                //         provider.authUser.totalFollowings.toString(),
                //         style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 11.7.sp),
                //       ),
                //     ),
                //     GestureDetector(
                //       onTap: () {
                //         Navigator.of(context).pushNamed(FollowingScreen.routeName);
                //       },
                //       child: Text('Following', style: TextStyle(color: Colors.white, fontSize: 11.7.sp)),
                //     ),
                //   ],
                // ),
                Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        //Navigator.of(context).pushNamed(FollowingScreen.routeName);
                      },
                      child: Text(
                        connectionGlobalList.length.toString(),
                        //provider.authUser.totalFollowings.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold, color: themeController.isDarkMode?Colors.white:Colors.black, fontSize: 11.7.sp),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        //Navigator.of(context).pushNamed(FollowingScreen.routeName);
                      },
                      child: Text('Connection', style: TextStyle(color: themeController.isDarkMode?Colors.white:Colors.black, fontSize: 11.7.sp)),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text(
                      provider.authUser.totalFeeds.toString(),
                      style: TextStyle(fontWeight: FontWeight.bold, color: themeController.isDarkMode?Colors.white:Colors.black, fontSize: 11.7.sp),
                    ),
                    Text('Posts', style: TextStyle(color: themeController.isDarkMode?Colors.white:Colors.black, fontSize: 11.7.sp)),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text(
                      provider.authUser.totalFeedComments.toString(),
                      style: TextStyle(fontWeight: FontWeight.bold, color: themeController.isDarkMode?Colors.white:Colors.black, fontSize: 11.7.sp),
                    ),
                    Text('Post Comments', style: TextStyle(color: themeController.isDarkMode?Colors.white:Colors.black, fontSize: 11.7.sp)),
                  ],
                ),
              ],
            ),
          ),
          // Align(
          //   alignment: Alignment.centerRight,
          //   child: Row(
          //     mainAxisSize: MainAxisSize.min,
          //     children: [
          //       Text("Notification Alert", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 11.7.sp)),
          //       Padding(
          //         padding: const EdgeInsets.only(left: 8.0, right: 10.0),
          //         child: FlutterSwitch(
          //           width: 45.0,
          //           height: 23.0,
          //           valueFontSize: 0.0,
          //           toggleSize: 16.0,
          //           value: provider.authUser.isNotify??false,
          //           borderRadius: 30.0,
          //           padding: 3.0,
          //           showOnOff: true,
          //           activeColor: myHexColor,
          //           inactiveToggleColor: Colors.white60,
          //           activeToggleColor: MateColors.activeIcons,
          //           inactiveColor: myHexColor,
          //           switchBorder: Border.all(
          //             color: MateColors.activeIcons,
          //             width: 0.5,
          //           ),
          //           onToggle: (val) async {
          //             setState(() {});
          //             bool updated = await Provider.of<AuthUserProvider>(context, listen: false).updateNotification();
          //             // if (updated) {
          //             //   if (value.beAMateActiveData != null) {
          //             //     // IsBookmarked
          //             //     if (value.beAMateActiveData.message == "Post activated successfully" && value.beAMateActiveData.data.id == beAMateId) {
          //             //       value.beAMatePostsDataList[widget.rowIndex].isActive = true;
          //             //       isActive = true;
          //             //     } else if (value.beAMateActiveData.message == "Post de-activated successfully" && value.beAMateActiveData.data.id == beAMateId) {
          //             //       value.beAMatePostsDataList[widget.rowIndex].isActive = false;
          //             //       isActive = false;
          //             //     }
          //             //   }
          //             // }
          //           },
          //         ),
          //       ),
          //     ],
          //   ),
          // )
        ],
      ),
    );
  }

  Future<void> _showDeleteDialog({@required String uuid}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: new Text("Are you sure?"),
          content: new Text("You want to delete your account?"),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text("Yes"),
              onPressed: ()async{
                SharedPreferences preferences = await SharedPreferences.getInstance();
                String token = preferences.getString("token");
                bool res = await AuthUserService().deleteUser(token: token, uuid: uuid);
                if(res){
                  authUserProvider.logout();
                  Navigator.of(context).pop();
                  Get.offNamedUntil(GoogleLogin.loginScreenRoute, (route) => false);
                }else{
                  Navigator.of(context).pop();
                  Fluttertoast.showToast(msg: "Something went wrong", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
                }
              },
            ),
            CupertinoDialogAction(
                child: Text("No"),
                onPressed: () {
                  print(uuid);
                  Navigator.of(context).pop();
                })
          ],
        );
      },
    );
  }



}

