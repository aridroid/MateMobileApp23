// import 'dart:async';
//
// import 'package:get_storage/get_storage.dart';
// import 'package:mate_app/Model/campusLivePostsModel.dart';
// import 'package:mate_app/Providers/AuthUserProvider.dart';
// import 'package:mate_app/Providers/campusLiveProvider.dart';
// import 'package:mate_app/Screen/Home/Community/CampusLivePostComments.dart';
// import 'package:mate_app/Screen/Home/Community/createCampusLivePost.dart';
// import 'package:mate_app/Screen/Home/Community/creditVideo.dart';
// import 'package:mate_app/Screen/Home/HomeScreen.dart';
// import 'package:mate_app/Screen/Profile/UserProfileScreen.dart';
// import 'package:mate_app/Screen/Report/reportPage.dart';
// import 'package:mate_app/Utility/Utility.dart';
// import 'package:mate_app/asset/Colors/MateColors.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:video_player/video_player.dart';
// import 'package:sizer/sizer.dart';
//
// import '../../../Screen/Profile/ProfileScreen.dart';
//
// class CampusLiveRow extends StatefulWidget {
//   final String description;
//   final String created;
//   final User user;
//   final String videoURL;
//   final int postId;
//   final IsLiked isLiked;
//   final IsBookmarked isBookmarked;
//   bool isFollowed;
//   final Credit credit;
//   final String creditUrl;
//   final VideoPlayerController videoPlayerController;
//   final int indexVal;
//   final int likeCount;
//   final int commentCount;
//   final bool isBookmarkPage;
//   final bool isUsersPostsPage;
//   final IsShared isShared;
//
//
//   // List<Media> media;
//
//   CampusLiveRow({
//     required this.description,
//     required this.created,
//     required this.videoURL,
//     required this.user,
//     required this.postId,
//     required this.isLiked,
//     required this.isBookmarked,
//     this.isFollowed=false,
//     required this.credit,
//     required this.creditUrl,
//     required this.videoPlayerController,
//     required this.indexVal,
//     required this.likeCount,
//     required this.commentCount,
//     this.isBookmarkPage=false,
//     this.isUsersPostsPage=false,
//     required this.isShared});
//
//   @override
//   _CampusLiveRowState createState() => _CampusLiveRowState();
// }
//
// class _CampusLiveRowState extends State<CampusLiveRow> {
//   late VideoPlayerController _controller;
//   late Future<void> _initializeVideoPlayerFuture;
//   late bool liked;
//   late bool bookMarked;
//   bool _onTouch = false;
//
//   @override
//   void initState() {
//     _controller = VideoPlayerController.network(
//       widget.videoURL,
//     );
//
//     // Initielize the controller and store the Future for later use.
//     _initializeVideoPlayerFuture = _controller.initialize();
//
//     // Use the controller to loop the video.
//     _controller.setLooping(true);
//     if (_controller.value.isPlaying) {
//       _controller.pause();
//     } else {
//       // If the video is paused, play it.
//       print("k");
//       _controller.play();
//     }
//
//     liked = (widget.isLiked == null) ? false : true;
//     bookMarked = (widget.isBookmarked == null) ? false : true;
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     // Ensure disposing of the VideoPlayerController to free up resources.
//     super.dispose();
//     _controller.dispose();
//     widget.videoPlayerController.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           Container(
//             color: Colors.black,
//             width: 100.0.w,
//             height: widget.isBookmarkPage? MediaQuery.of(context).size.height * .8: widget.isUsersPostsPage? MediaQuery.of(context).size.height * .8:80.0.h,
//             child: Stack(
//               clipBehavior: Clip.hardEdge,
//               children: [
//                 Container(
//                   clipBehavior: Clip.hardEdge,
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(5.0),
//                       gradient: LinearGradient(colors: [
//                         Colors.transparent,
//                         Colors.transparent,
//                         // Colors.transparent,
//                         Colors.black87,
//                       ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
//                   // width: 360,
//                   // height: 640,
//                   child: Align(
//                     alignment: Alignment.center,
//                     child: FutureBuilder(
//                       future: _initializeVideoPlayerFuture,
//                       builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.done && _controller.value.size.aspectRatio>0.0) {
//                       // If the VideoPlayerController has finished initialization, use
//                       // the data it provides to limit the aspect ratio of the video.
//                       print("starting video");
//                       // return VideoPlayer(_controller);
//                       return AspectRatio(
//                         aspectRatio: _controller.value.size.aspectRatio,
//                         child: VideoPlayer(_controller));
//                     } else {
//                       // If the VideoPlayerController is still initializing, show a
//                       // loading spinner.
//                       return const Center(
//                         child: CircularProgressIndicator(
//                           color: Colors.white,
//                         ),
//                       );
//                     }
//                       },
//                     ),
//                   ),
//                 ),
//                 Container(
//                   decoration: BoxDecoration(
//                       gradient: LinearGradient(colors: [
//                     Colors.transparent,
//                     Colors.transparent,
//                     Colors.black87,
//                   ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
//                 ),
//
//                 Positioned(
//                   top: 0,
//                   right: 0,
//                   width: 100,
//                   height: 100,
//                   child: Container(
//                     alignment: Alignment.topRight,
//                     // decoration: BoxDecoration(
//                     //     gradient: LinearGradient(colors: [
//                     //       Colors.black87,
//                     //       Colors.black87,
//                     //       Colors.black54,
//                     //       Colors.black38,
//                     //       Colors.transparent
//                     //     ], begin: Alignment.topRight, end: Alignment.center)),
//                     child: PopupMenuButton<int>(
//                       icon: Icon(Icons.more_vert,color: Colors.white,),
//                       color: Colors.grey[850],
//                       onSelected: (index){
//                         if(index==0){
//                           modalSheetToShare();
//                         }
//                         else if(index==1){
//                           _showFollowAlertDialog(postId: widget.postId, indexVal: widget.indexVal);
//                         }
//                         else if(index==2){
//                           _showDeleteAlertDialog(postId: widget.postId, indexVal: widget.indexVal);
//                         }
//                         else if(index==3){
//                           if (_controller.value.isPlaying) {
//                             _controller.pause();
//                           }
//                           Navigator.push(context, MaterialPageRoute(builder: (context) => ReportPage(moduleId: widget.postId,moduleType: "CampusLive",),));
//
//                         }
//
//
//                       },
//                       itemBuilder: (context) => [
//                         /*PopupMenuItem(
//                           value: 0,
//                           enabled: true,
//                           child: Text(
//                             "Share Post",
//                             textAlign: TextAlign.start,
//                             style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
//                           ),
//                         ),*/
//                         PopupMenuItem(
//                           value: 1,
//                           height: 40,
//                           child: Text(
//                             widget.isFollowed?"Unfollow Post":"Follow Post",
//                             textAlign: TextAlign.start,
//                             style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12.6.sp),
//                           ),
//                         ),
//                         (widget.user.uuid != null && (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == widget.user.uuid))
//                             ? PopupMenuItem(
//                           value: 2,
//                           height: 40,
//                           child: Text(
//                             "Delete Post",
//                             textAlign: TextAlign.start,
//                             style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12.6.sp),
//                           ),
//                         )
//                             : PopupMenuItem(
//                           value: 2,
//                           enabled: false,
//                           height: 0,
//                           child: SizedBox(
//                             height: 0,
//                             width: 0,
//                           ),
//                         ),
//                         PopupMenuItem(
//                           value: 3,
//                           enabled: true,
//                           child: Text(
//                             "Report Post",
//                             textAlign: TextAlign.start,
//                             style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12.6.sp),
//                           ),
//                         ),
//
//                       ],
//                     ),
//                   ),
//                 ),
//
//                 Positioned(
//                   top: 0,
//                   left: 54,
//                   width: MediaQuery.of(context).size.width * 1 - 112,
//                   height: MediaQuery.of(context).size.height * .35 + 110,
//                   child: InkWell(
//                     splashColor: Colors.transparent,
//                     highlightColor: Colors.transparent,
//                     onTap: () {
//                       setState(() {
//                         _onTouch = !_onTouch;
//                       });
//                     },
//                     child: Visibility(
//                       maintainAnimation: true,
//                       maintainState: true,
//                       maintainInteractivity: true,
//                       maintainSize: true,
//                       visible: _controller.value.isInitialized && _onTouch,
//                       child: Container(
//                         // width: 100,
//                         padding: EdgeInsets.only(bottom: 90),
//                         // color: Colors.grey.withOpacity(0.7),
//                         alignment: Alignment.bottomCenter,
//                         child: TextButton(
//                           style: TextButton.styleFrom(
//                             foregroundColor: Colors.grey.withOpacity(0.5),
//                             padding: EdgeInsets.all(10),
//                             shape: CircleBorder(side: BorderSide(color: Colors.white, width: 1.2)),
//                           ),
//                           // color: Colors.grey.withOpacity(0.5),
//                           // padding: EdgeInsets.all(10),
//                           // shape: CircleBorder(side: BorderSide(color: Colors.white, width: 1.2)),
//                           child: Icon(
//                             _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//                             color: Colors.white,
//                             size: 30,
//                           ),
//                           onPressed: () {
//                             // pause while video is playing, play while video is pausing
//                             setState(() {
//                               _controller.value.isPlaying ? _controller.pause() : _controller.play();
//                             });
//                           },
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   height: 220,
//                   width: 55,
//                   bottom: 10,
//                   right: 5,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       InkWell(
//                         onTap: () async {
//                           if (_controller.value.isPlaying) {
//                             _controller.pause();
//                           }
//                           // bool superchargeUpdate = await Provider.of<CampusLiveProvider>(context, listen: false).superchargeAPost(widget.postId);
//                           // if (superchargeUpdate) Provider.of<CampusLiveProvider>(context, listen: false).fetchCampusLivePostList();
//                           Navigator.of(context).push(MaterialPageRoute(
//                               builder: (context) => CreateCampusLivePost(
//                                 postId: widget.postId,
//                                 pathName: "superCharge",
//                               )));
//
//                         },
//                         child: Image.asset(
//                           "lib/asset/icons/flash.png",
//                           fit: BoxFit.cover,
//                           height: 55,
//                           width: 58,
//                         ),
//                       ),
//                       // InkWell(
//                       //   onTap: () async {
//                       //     if (_controller.value.isPlaying) {
//                       //       _controller.pause();
//                       //     }
//                       //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateCampusLivePost()));
//                       //   },
//                       //   child: Image.asset(
//                       //     "lib/asset/icons/addbutton.png",
//                       //     fit: BoxFit.cover,
//                       //     height: 45,
//                       //     width: 45,
//                       //   ),
//                       // ),
//                       SizedBox(height: 8,),
//                       InkWell(
//                         child: Icon(
//                           Icons.mode_comment_outlined,
//                           color: Colors.grey[50],
//                           size: 21,
//                         ),
//                         onTap: () {
//                           if (_controller.value.isPlaying) {
//                             _controller.pause();
//                           }
//                           Navigator.of(context).push(MaterialPageRoute(
//                               builder: (context) => CampusLivePostComments(
//                                 postIndex: widget.indexVal,
//                                     postId: widget.postId,
//                                   )));
//                         },
//                       ),
//                       Text(
//                         '${widget.commentCount}',
//                         style: TextStyle(color: Colors.white, fontSize: 12),
//                       ),
//                       SizedBox(height: 7,),
//                       Consumer<CampusLiveProvider>(
//                         builder: (context, value, child) {
//
//                           return InkWell(
//                               child: Icon(
//                                 liked ? Icons.favorite :  Icons.favorite_border,
//                                 color: liked ? MateColors.activeIcons : Colors.grey[50],
//                                 size: 21,
//                               ),
//                               onTap: () async {
//                                 liked=!liked;
//                                 bool likedDone=await Provider.of<CampusLiveProvider>(context, listen: false).likeAPost(widget.postId, widget.indexVal);
//                                 if(likedDone && liked) {
//                                   widget.isBookmarkPage? ++value.campusLivePostsBookmarkData.data!.result![widget.indexVal].likesCount : widget.isUsersPostsPage? ++value.campusLiveByAuthUserData.data!.result![widget.indexVal].likesCount : ++value.campusLivePostsModelData.data!.result![widget.indexVal].likesCount;
//                                 }else if(likedDone && !liked){
//                                   widget.isBookmarkPage? --value.campusLivePostsBookmarkData.data!.result![widget.indexVal].likesCount : widget.isUsersPostsPage? --value.campusLiveByAuthUserData.data!.result![widget.indexVal].likesCount : --value.campusLivePostsModelData.data!.result![widget.indexVal].likesCount;
//                                 }
//                               });
//                         },
//                       ),
//                       Text(
//                         '${widget.likeCount}',
//                         style: TextStyle(color: Colors.white, fontSize: 12),
//                       ),
//                       SizedBox(height: 7,),
//                       Consumer<CampusLiveProvider>(
//                         builder: (context, value, child) {
//                           if (value.bookmarkPostData != null) {
//                             if(widget.isBookmarkPage && !bookMarked){
//                               Future.delayed(Duration.zero,()=>Provider.of<CampusLiveProvider>(context, listen: false).fetchCampusLivePostBookmarkedList());
//                             }
//                           }
//                           return InkWell(
//                               child: Icon(
//                                 bookMarked ? Icons.bookmark : Icons.bookmark_border,
//                                 color: bookMarked ? MateColors.activeIcons : Colors.grey[50],
//                                 size: 21,
//                               ),
//                               onTap: () {
//                                 Provider.of<CampusLiveProvider>(context, listen: false).bookmarkAPost(widget.postId, widget.indexVal);
//                                 // setState(() {
//                                   bookMarked=!bookMarked;
//                                 // });
//                               });
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//                 Positioned(
//                   // height: 100,
//                   width: MediaQuery.of(context).size.width * .65,
//                   bottom: 10,
//                   left: 10,
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       InkWell(
//                           onTap: (){
//                             if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == widget.user.uuid) {
//                               Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
//                             } else {
//                               Navigator.of(context).pushNamed(UserProfileScreen.routeName, arguments: {"id": widget.user.uuid, "name": widget.user.displayName, "photoUrl": widget.user.profilePhoto, "firebaseUid": widget.user.firebaseUid});
//                             }
//                           },
//                           child: Text("@${widget.user.displayName}", style: TextStyle(fontFamily: 'Quicksand', color: Colors.white, fontWeight: FontWeight.w600, fontSize: 11.5.sp))),
//                       SizedBox(
//                         height: 3,
//                       ),
//                       (widget.credit != null && widget.creditUrl!=null)
//                           ? InkWell(
//                               onTap: () {
//                                 if (_controller.value.isPlaying) {
//                                   _controller.pause();
//                                 }
//                                 Navigator.of(context).push(MaterialPageRoute(
//                                     builder: (context) => CreditVideo(
//                                       isBookmarkPage: widget.isBookmarkPage,
//                                           isUsersPostsPage: widget.isUsersPostsPage,
//                                           created: widget.created,
//                                           credit: widget.credit,
//                                           description: widget.description,
//                                           isLiked: widget.isLiked,
//                                           postId: widget.postId,
//                                           user: widget.user,
//                                           creditVideoURL: widget.creditUrl,
//                                         )));
//                               },
//                               child: Padding(
//                                 padding: const EdgeInsets.only(bottom: 3),
//                                 child: Text("#HiThereMate \n ▶ @${widget.credit.displayName}", style: TextStyle(fontFamily: 'Quicksand', color: Colors.white, fontWeight: FontWeight.w600, fontSize: 11.5.sp)),
//                               ),
//                             )
//                           : SizedBox(),
//                       Text(
//                         '${widget.created}',
//                         style: TextStyle(color: Colors.white70, fontSize: 9.2.sp),
//                       ),
//                       SizedBox(
//                         height: 5,
//                       ),
//                       widget.description!=null?Flexible(
//                         child: Text(
//                           widget.description,
//                           overflow: TextOverflow.fade,
//                           style: TextStyle(color: Colors.white, fontSize: 11.4.sp),
//                         ),
//                       ):SizedBox(),
//                       widget.isShared!=null?
//
//                       _sharedWidget(widget.isShared)
//                           :
//                       SizedBox(
//                         height: 2,
//                       ),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   _showDeleteAlertDialog({required int postId, required int indexVal,}) async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false, // user must tap button!
//       builder: (BuildContext context) {
//         return CupertinoAlertDialog(
//           title: new Text("Are you sure?"),
//           content: new Text("You want to delete your post"),
//           actions: <Widget>[
//             CupertinoDialogAction(
//               isDefaultAction: true,
//               child: Text("Yes"),
//               onPressed: () async{
//                 bool isDeleted = await Provider.of<CampusLiveProvider>(context, listen: false).deleteAPost(postId,indexVal);
//                 if (isDeleted) {
//                   Future.delayed(Duration(seconds: 0), () {
//                     if(widget.isBookmarkPage){
//                       Provider.of<CampusLiveProvider>(context, listen: false).fetchCampusLivePostBookmarkedList();
//                     }else if(widget.isUsersPostsPage){
//                       Provider.of<CampusLiveProvider>(context, listen: false).fetchCampusLiveByAuthUser(widget.user.uuid!);
//                     }else{
//                       Provider.of<CampusLiveProvider>(context, listen: false).fetchCampusLivePostList();
//                     }
//                     Navigator.pop(context);
//                   });
//                 }
//               },
//             ),
//             CupertinoDialogAction(
//                 child: Text("No"),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 })
//           ],
//         );
//       },
//     );
//   }
//
//   _showFollowAlertDialog({required int postId, required int indexVal,
//   }) async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false, // user must tap button!
//       builder: (BuildContext context) {
//         return Consumer<CampusLiveProvider>(
//           builder: (context, value, child) {
//
//             return CupertinoAlertDialog(
//               title: new Text("Are you sure?"),
//               content: new Text(widget.isFollowed?"You want to Unfollow this post":"You want to follow this post"),
//               actions: <Widget>[
//                 CupertinoDialogAction(
//                   isDefaultAction: true,
//                   child: value.postFollowLoader?
//                   Center(
//                     child: CircularProgressIndicator(
//                       color: Colors.white,
//                     ),
//                   )
//                       :Text("Yes"),
//                   onPressed: () async {
//                       Map<String, dynamic> body = {"post_id": widget.postId, "post_type": "CampusLive"};
//                     if(widget.isFollowed){
//                       bool unFollowDone = await Provider.of<CampusLiveProvider>(context, listen: false).unFollowAPost(body);
//                       if (unFollowDone) {
//                         if (widget.isBookmarkPage) {
//                           value.campusLivePostsBookmarkData.data!.result![widget.indexVal].isFollowed=false;
//                         }else{
//                           value.campusLivePostsModelData.data!.result![widget.indexVal].isFollowed=false;
//                         }
//                         widget.isFollowed=false;
//                         Navigator.pop(context);
//                       }
//
//                     }else{
//                       bool followDone = await Provider.of<CampusLiveProvider>(context, listen: false).followAPost(body);
//                       if (followDone) {
//                         if (widget.isBookmarkPage) {
//                           value.campusLivePostsBookmarkData.data!.result![widget.indexVal].isFollowed=true;
//                         }else{
//                           value.campusLivePostsModelData.data!.result![widget.indexVal].isFollowed=true;
//                         }
//                         widget.isFollowed=true;
//                         Navigator.pop(context);
//                       }
//                     }
//                   },
//                 ),
//                 CupertinoDialogAction(
//                     child: Text("No"),
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     })
//               ],
//             );
//           },
//         );
//
//
//
//       },
//     );
//   }
//
//   modalSheetToShare() {
//     TextEditingController _description = new TextEditingController();
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
//         return Padding(
//           padding: const EdgeInsets.all(18.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   "Share this post",
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: MateColors.activeIcons),
//                 ),
//               ),
//               SizedBox(
//                 height: 15.0,
//               ),
//               TextFormField(
//                 minLines: 2,
//                 maxLines: 8,
//                 maxLength: 512,
//                 decoration: InputDecoration(
//                   counterStyle: TextStyle(color: Colors.grey),
//                   labelStyle: TextStyle(fontSize: 16.0, color: MateColors.activeIcons),
//                   labelText: "Description",
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: const BorderSide(color: Colors.grey, width: 0.3),
//                     borderRadius: BorderRadius.circular(15.0),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: const BorderSide(color: Colors.white, width: 0.3),
//                     borderRadius: BorderRadius.circular(15.0),
//                   ),
//                 ),
//                 style: TextStyle(color: Colors.white, fontSize: 18.0),
//                 cursorColor: Colors.cyanAccent,
//                 textInputAction: TextInputAction.done,
//                 controller: _description,
//                 validator: (value) {
//                   return value!.isEmpty ? "*description" : null; //returning null means no error occurred. if there are any error then simply return a string
//                 },
//               ),
//               SizedBox(
//                 height: 16.0,
//               ),
//               ButtonTheme(
//                 minWidth: MediaQuery.of(context).size.width - 40,
//                 height: 50,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     foregroundColor: MateColors.activeIcons,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(15.0),
//                     ),
//                   ),
//                   // shape: RoundedRectangleBorder(
//                   //   borderRadius: BorderRadius.circular(15.0),
//                   // ),
//                   // color: MateColors.activeIcons,
//                   child: Consumer<CampusLiveProvider>(
//                     builder: (ctx, campusLiveProvider, _) {
//                       if (campusLiveProvider.postShareLoader) {
//                         return Center(
//                           child: CircularProgressIndicator(
//                             color: Colors.white,
//                           ),
//                         );
//                       }
//
//                       return Text(
//                         'Share',
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       );
//                     },
//                   ),
//
//                   onPressed: () async {
//                     // Navigator.pop(context);
//
//                     Map<String, dynamic> body = {"share_desc": _description.text.trim()};
//                     bool shareDone = await Provider.of<CampusLiveProvider>(context, listen: false).shareAPost(body, widget.postId);
//                     if (shareDone) {
//                       Navigator.pop(context);
//                       // Navigator.of(context).pushReplacement(MaterialPageRoute(
//                       //     builder: (context) => HomeScreen(
//                       //           index: 2,
//                       //         )));
//                       Navigator.of(context).pushAndRemoveUntil(
//                           MaterialPageRoute(
//                               builder: (context) => HomeScreen(
//                                 index: 2,
//                               )),
//                               (Route<dynamic> route) => false);
//                     }
//                   },
//                 ),
//               ),
//
//               SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _sharedWidget(IsShared isShared) {
//     return Container(
//       margin: EdgeInsets.only(left: 5.0, top: 5, bottom: 5),
//       padding: EdgeInsets.fromLTRB(8,7,8,7),
//       decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0), border: Border.all(color: MateColors.line, width: 1)),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text("@${widget.isShared.user!.displayName!}", style: TextStyle(fontFamily: 'Quicksand', color: Colors.white, fontWeight: FontWeight.w600)),
//           SizedBox(
//             height: 3,
//           ),
//           /*(widget.isShared.credit != null && widget.isShared.creditUrl!=null)
//               ? InkWell(
//             onTap: () {
//               if (_controller.value.isPlaying) {
//                 _controller.pause();
//               }
//               Navigator.of(context).push(MaterialPageRoute(
//                   builder: (context) => CreditVideo(
//                     isBookmarkPage: widget.isBookmarkPage,
//                     created: widget.created,
//                     credit: widget.credit,
//                     description: widget.description,
//                     isLiked: widget.isLiked,
//                     postId: widget.postId,
//                     user: widget.user,
//                     creditVideoURL: widget.creditUrl,
//                   )));
//             },
//             child: Padding(
//               padding: const EdgeInsets.only(bottom: 3),
//               child: Text("#HiThereMate \n ▶ @${widget.credit.displayName}", style: TextStyle(fontFamily: 'Quicksand', color: Colors.white, fontWeight: FontWeight.w600)),
//             ),
//           )
//               : SizedBox(),*/
//           Text(
//             "${DateFormat.yMMMMEEEEd().format(DateFormat("yyyy-MM-dd").parse(widget.isShared.createdAt!, true))}",
//             style: TextStyle(color: Colors.white70, fontSize: 12),
//           ),
//           SizedBox(
//             height: 5,
//           ),
//           widget.isShared.subject!=null?Flexible(
//             child: Text(
//               widget.isShared.subject!,
//               overflow: TextOverflow.fade,
//               style: TextStyle(color: Colors.white, fontSize: 14),
//             ),
//           ):SizedBox(),
//         ],
//       ),
//     );
//   }
// }
//
