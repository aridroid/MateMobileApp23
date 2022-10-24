// import 'package:flutter/material.dart';
//
//
// class Test extends StatelessWidget {
//   const Test({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         ListTile(
//           contentPadding: EdgeInsets.fromLTRB(14, 0, 14, 0),
//           leading: InkWell(
//             onTap: () {
//               if (isAnonymous == 0) {
//                 if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == user.uuid) {
//                   Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
//                 } else {
//                   Navigator.of(context).pushNamed(UserProfileScreen.routeName, arguments: {"id": user.uuid, "name": user.displayName, "photoUrl": user.profilePhoto, "firebaseUid": user.firebaseUid});
//                 }
//               }
//             },
//             child: isAnonymous == 0
//                 ? ClipOval(
//               child: Image.network(
//                 user.profilePhoto,
//                 height: 40,
//                 width: 40,
//                 fit: BoxFit.cover,
//               ),
//             )
//                 : ClipOval(
//               child: Image.asset(
//                 "lib/asset/logo.png",
//                 height: 40,
//                 width: 40,
//                 fit: BoxFit.fitWidth,
//               ),
//             ),
//           ),
//           title: InkWell(
//               onTap: () {
//                 if (isAnonymous == 0) {
//                   if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == user.uuid) {
//                     Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
//                   } else {
//                     Navigator.of(context)
//                         .pushNamed(UserProfileScreen.routeName, arguments: {"id": user.uuid, "name": user.displayName, "photoUrl": user.profilePhoto, "firebaseUid": user.firebaseUid});
//                   }
//                 }
//               },
//               child: Padding(
//                 padding: const EdgeInsets.only(bottom: 10.0),
//                 child: Text(
//                   isAnonymous == 0 ? user.displayName : widget.anonymousUser ?? "Anonymous",
//                   style: TextStyle(fontFamily: 'Quicksand', color: Colors.white, fontSize: 11.5.sp),
//                   overflow: TextOverflow.clip,
//                 ),
//               )),
//           subtitle:
//           InkWell(
//               splashColor: Colors.transparent,
//               highlightColor: Colors.transparent,
//               onTap: () => _navigateToDetailsPage(),
//               child: Text(title, textAlign: TextAlign.left, style: TextStyle(fontSize: 12.0.sp, fontFamily: 'Quicksand', fontWeight: FontWeight.w700, color: MateColors.activeIcons))),
//         ),
//         InkWell(
//           splashColor: Colors.transparent,
//           highlightColor: Colors.transparent,
//           onTap: () => _navigateToDetailsPage(),
//           child: SizedBox(
//             width: double.infinity,
//             child: description != null
//                 ? Padding(
//               padding: EdgeInsets.fromLTRB(15, 0, 14, 0),
//               child: Linkify(
//                 onOpen: (link) async {
//                   print("Clicked ${link.url}!");
//                   if (await canLaunch(link.url))
//                     await launch(link.url);
//                   else
//                     // can't launch url, there is some error
//                     throw "Could not launch ${link.url}";
//                 },
//                 text: description,
//                 style: TextStyle(fontFamily: 'Quicksand', color: Colors.white, fontSize: 11.4.sp),
//                 textAlign: TextAlign.left,
//                 linkStyle: TextStyle(color: MateColors.activeIcons, fontSize: 11.4.sp),
//               ),
//             )
//                 : SizedBox(),
//           ),
//         ),
//         Padding(
//           padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
//           child: Row(
//             children: [
//               InkWell(
//                 splashColor: Colors.transparent,
//                 highlightColor: Colors.transparent,
//                 onTap: () => _navigateToDetailsPage(),
//                 child: Text(
//                   "Posted: $createdAt",
//                   style: TextStyle(fontFamily: 'Quicksand', color: Colors.white70, fontSize: 9.2.sp),
//                   overflow: TextOverflow.visible,
//                 ),
//               ),
//               Spacer(),
//               Consumer<CampusTalkProvider>(
//                 builder: (context, campusTalkProvider, child) {
//                   return Text(
//                       widget.isUserProfile
//                           ? campusTalkProvider.campusTalkByUserPostsResultsList[widget.rowIndex].commentsCount.toString()
//                           : widget.isBookmarkedPage
//                           ? campusTalkProvider.campusTalkPostsBookmarkData.data.result[widget.rowIndex].commentsCount.toString()
//                           : campusTalkProvider.campusTalkPostsResultsList[widget.rowIndex].commentsCount.toString(),
//                       style: TextStyle(fontFamily: 'Quicksand', color: Colors.grey[50], fontSize: 12.5),
//                       overflow: TextOverflow.visible);
//                 },
//               ),
//               InkWell(
//                 onTap: () => Navigator.of(context).push(MaterialPageRoute(
//                   builder: (context) => CampusTalkComments(
//                     postId: talkId,
//                     postIndex: widget.rowIndex,
//                     isUserProfile: widget.isUserProfile,
//                     isBookmarkedPage: widget.isBookmarkedPage,
//                   ),
//                 )),
//                 child: Icon(
//                   Icons.mode_comment_outlined,
//                   color: Colors.grey[200],
//                   size: 20,
//                 ),
//               ),
//               SizedBox(
//                 width: 5,
//               ),
//               Consumer<CampusTalkProvider>(
//                 builder: (context, value, child) {
//                   return InkWell(
//                       child: Icon(
//                         liked ? Icons.arrow_circle_up_sharp : Icons.arrow_circle_up_sharp,
//                         color: liked ? MateColors.activeIcons : Colors.grey[50],
//                         size: 21,
//                       ),
//                       onTap: () async {
//                         // setState(() {
//                         liked=!liked;
//                         // });
//                         bool likedDone = await Provider.of<CampusTalkProvider>(context, listen: false)
//                             .upVoteAPost(widget.talkId, widget.rowIndex, isBookmarkedPage: widget.isBookmarkedPage, isUserProfile: widget.isUserProfile);
//                         if (likedDone && liked) {
//                           widget.isUserProfile
//                               ? ++value.campusTalkByUserPostsResultsList[widget.rowIndex].likesCount
//                               : widget.isBookmarkedPage
//                               ? ++value.campusTalkPostsBookmarkData.data.result[widget.rowIndex].likesCount
//                               : ++value.campusTalkPostsResultsList[widget.rowIndex].likesCount;
//                         } else if (likedDone && !liked) {
//                           widget.isUserProfile
//                               ? --value.campusTalkByUserPostsResultsList[widget.rowIndex].likesCount
//                               : widget.isBookmarkedPage
//                               ? --value.campusTalkPostsBookmarkData.data.result[widget.rowIndex].likesCount
//                               : --value.campusTalkPostsResultsList[widget.rowIndex].likesCount;
//                         }
//
//                       });
//                 },
//               ),
//               Text(
//                 " ${widget.likesCount} ",
//                 style: TextStyle(fontFamily: 'Quicksand', color: Colors.grey[50], fontSize: 12.5),
//                 overflow: TextOverflow.visible,
//               ),
//               Consumer<CampusTalkProvider>(
//                 builder: (context, value, child) {
//                   return InkWell(
//                       child: Icon(
//                         bookMarked ? Icons.bookmark : Icons.bookmark_border,
//                         color: bookMarked ? MateColors.activeIcons : Colors.grey[50],
//                         size: 21,
//                       ),
//                       onTap: () async {
//                         // setState(() {
//                         bookMarked=!bookMarked;
//                         // });
//                         bool isBookmarked = await Provider.of<CampusTalkProvider>(context, listen: false)
//                             .bookmarkAPost(widget.talkId, widget.rowIndex, isBookmarkedPage: widget.isBookmarkedPage, isUserProfile: widget.isUserProfile);
//                         if (widget.isBookmarkedPage) {
//                           if (isBookmarked) {
//                             Future.delayed(Duration(seconds: 0), () {
//                               Provider.of<CampusTalkProvider>(context, listen: false).fetchCampusTalkPostBookmarkedList();
//                             });
//                           }
//                         }
//
//                       });
//                 },
//               ),
//               PopupMenuButton<int>(
//                 padding: EdgeInsets.only(bottom: 0, top: 0, left: 0, right: 0),
//                 icon: Icon(
//                   Icons.more_vert,
//                   color: Colors.white,
//                 ),
//                 color: Colors.grey[850],
//                 onSelected: (index) async {
//                   if (index == 0) {
//                     // Map<String, dynamic> body;
//                     // Provider.of<ExternalShareProvider>(context,listen: false).externalSharePost(body);
//                     // modalSheetToShare();
//                   } else if (index == 1) {
//                     _showDeleteAlertDialog(postId: widget.talkId, rowIndex: widget.rowIndex);
//                   } else if (index == 2) {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ReportPage(
//                             moduleId: widget.talkId,
//                             moduleType: "DiscussionForum",
//                           ),
//                         ));
//                   }
//                 },
//                 itemBuilder: (context) => [
//                   /*PopupMenuItem(
//                     value: 0,
//                     height: 40,
//                     child: Text(
//                       "Share",
//                       textAlign: TextAlign.start,
//                       style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
//                     ),
//                   ),*/
//                   (widget.user.uuid != null && (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == widget.user.uuid))
//                       ? PopupMenuItem(
//                     value: 1,
//                     height: 40,
//                     child: Text(
//                       "Delete Post",
//                       textAlign: TextAlign.start,
//                       style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12.6.sp),
//                     ),
//                   )
//                       : PopupMenuItem(
//                     value: 1,
//                     enabled: false,
//                     height: 0,
//                     child: SizedBox(
//                       height: 0,
//                       width: 0,
//                     ),
//                   ),
//                   PopupMenuItem(
//                     value: 2,
//                     height: 40,
//                     child: Text(
//                       "Report",
//                       textAlign: TextAlign.start,
//                       style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12.6.sp),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         Divider(
//           thickness: 1.5,
//           color: MateColors.line,
//         ),
//       ],
//     );
//   }
// }
