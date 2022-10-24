import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:mate_app/Model/campusTalkCommentFetchModel.dart';
import 'package:mate_app/Providers/AuthUserProvider.dart';
import 'package:mate_app/Providers/campusTalkProvider.dart';
import 'package:mate_app/Screen/Profile/ProfileScreen.dart';
import 'package:mate_app/Screen/Profile/UserProfileScreen.dart';
import 'package:mate_app/Utility/Utility.dart';
import 'package:mate_app/Widget/Loaders/Shimmer.dart';
import 'package:mate_app/asset/Colors/MateColors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'commentFullImage.dart';

class CampusTalkCommentReply extends StatefulWidget {
  final bool isBookmarkedPage;
  final bool isUserProfile;
  final int postIndex;
  final int commentId;
  final int commentIndex;
  final int postId;

  const CampusTalkCommentReply({Key key, this.commentId, this.commentIndex, this.postId, this.postIndex, this.isBookmarkedPage=false, this.isUserProfile=false}) : super(key: key);

  @override
  _CampusTalkCommentReplyState createState() => _CampusTalkCommentReplyState();
}

class _CampusTalkCommentReplyState extends State<CampusTalkCommentReply> {
  FocusNode focusNode = FocusNode();
  TextEditingController messageEditingController = new TextEditingController();
  bool messageSentCheck = false;
  XFile imageFile;
  bool isLoading = false;
  bool isAnonymous = false;
  final picker = ImagePicker();


  @override
  void initState() {
    Future.delayed(Duration(seconds: 0), () {
      // Provider.of<CampusTalkProvider>(context, listen: false).fetchCommentsOfAPostById(widget.commentId);
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: MateColors.activeIcons,
        ),
        title: Text(
          "Reply",
          style: TextStyle(
            color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
            fontWeight: FontWeight.w700,
            fontSize: 17.0,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          isAnonymous
              ? Container(
                  height: 20,
                  width: double.infinity,
                  color: Colors.teal[900],
                  alignment: Alignment.center,
                  child: Text(
                    "You are now in INCOGNITO MODE",
                    style: TextStyle(color: Colors.white, fontSize: 11),
                  ),
                )
              : SizedBox(),
          Expanded(
            child: Consumer<CampusTalkProvider>(
              builder: (context, campusLiveProvider, child) {
                if (!campusLiveProvider.fetchCommentsLoader && campusLiveProvider.commentFetchData != null) {
                  Result result = campusLiveProvider.commentFetchData.data.result[widget.commentIndex];
                  return ListView(
                    children: [
                      // Container(
                      //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(0.0), border: Border.all(color: MateColors.line, width: 1)),
                      //   padding: EdgeInsets.fromLTRB(16, 15, 16, 15),
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Row(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //           commentData.isAnonymous == 0
                      //               ? ClipOval(
                      //                   child: Image.network(
                      //                     commentData.user.profilePhoto,
                      //                     height: 40,
                      //                     width: 40,
                      //                     fit: BoxFit.cover,
                      //                   ),
                      //                 )
                      //               : ClipOval(
                      //                   child: Image.asset(
                      //                     "lib/asset/logo.png",
                      //                     height: 40,
                      //                     width: 40,
                      //                     fit: BoxFit.fitWidth,
                      //                   ),
                      //                 ),
                      //           SizedBox(
                      //             width: 15,
                      //           ),
                      //           Expanded(
                      //             child: Column(
                      //               crossAxisAlignment: CrossAxisAlignment.start,
                      //               children: [
                      //                 // Text(commentData[index].user.displayName,
                      //                 //     style: TextStyle(fontFamily: 'Quicksand', color: MateColors.activeIcons, fontWeight: FontWeight.w500, fontSize: 15)),
                      //                 InkWell(
                      //                   onTap: () {
                      //                     if (commentData.isAnonymous == 0) {
                      //                       if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == commentData.user.uuid) {
                      //                         Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                      //                       } else {
                      //                         Navigator.of(context).pushNamed(UserProfileScreen.routeName,
                      //                             arguments: {"id": commentData.user.uuid, "name": commentData.user.displayName, "photoUrl": commentData.user.profilePhoto, "firebaseUid": commentData.user.firebaseUid});
                      //                       }
                      //                     }
                      //                   },
                      //                   child: RichText(
                      //                     text: TextSpan(
                      //                       text: commentData.isAnonymous == 1 ? "Anonymous" : commentData.user.displayName,
                      //                       style: TextStyle(fontFamily: 'Quicksand', color: MateColors.activeIcons, fontWeight: FontWeight.w400, fontSize: 13.3.sp),
                      //                       children: <TextSpan>[
                      //                         TextSpan(
                      //                           text: "  ",
                      //                           style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400),
                      //                         ),
                      //                         TextSpan(
                      //                           text: commentData.content,
                      //                           style: TextStyle(color: Colors.white, fontSize: 13.0.sp, fontWeight: FontWeight.w400),
                      //                         ),
                      //                       ],
                      //                     ),
                      //                   ),
                      //                 ),
                      //                 commentData.url!=null?Padding(
                      //                   padding: const EdgeInsets.only(bottom: 5.0, top: 5),
                      //                   child: InkWell(
                      //                     onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      //                         builder: (context) => CommentFullImage(
                      //                           imageNetworkPath: imageBaseUrl+commentData.url,
                      //                         ))),
                      //                     child: ClipRRect(
                      //                       borderRadius: BorderRadius.circular(12.0),
                      //                       clipBehavior: Clip.hardEdge,
                      //                       child: Image.network(
                      //                         imageBaseUrl+commentData.url,
                      //                         fit: BoxFit.contain,
                      //                         height: 150,
                      //                         // width: 400,
                      //                       ),
                      //                     ),
                      //                   ),
                      //                 ):SizedBox(height: 15,),
                      //                 Row(
                      //                   mainAxisAlignment: MainAxisAlignment.end,
                      //                   children: [
                      //                     InkWell(
                      //                       onTap: () => focusNode.requestFocus(),
                      //                       child: Text(
                      //                         "Reply",
                      //                         style: TextStyle(color: Colors.white, fontSize: 10.5.sp, fontWeight: FontWeight.w400),
                      //                       ),
                      //                     ),
                      //                     Text(
                      //                       commentData.replies.isEmpty
                      //                           ? ""
                      //                           : commentData.replies.length > 1
                      //                               ? "   •   ${commentData.replies.length} Replies"
                      //                               : "   •   ${commentData.replies.length} Reply",
                      //                       style: TextStyle(color: Colors.white70, fontSize: 10.5.sp, fontWeight: FontWeight.w400),
                      //                     ),
                      //                     Spacer(),
                      //                     SizedBox(
                      //                       width: 8,
                      //                     ),
                      //                     Text(
                      //                       DateFormat.yMMMEd().format(DateFormat("yyyy-MM-dd").parse(commentData.createdAt, true)),
                      //                       style: TextStyle(color: Colors.white70, fontSize: 10.0.sp, fontWeight: FontWeight.w400),
                      //                       textAlign: TextAlign.end,
                      //                     ),
                      //                   ],
                      //                 )
                      //               ],
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //       commentData.replies.isNotEmpty
                      //           ? ListView.builder(
                      //               shrinkWrap: true,
                      //               physics: ScrollPhysics(),
                      //               // padding: EdgeInsets.fromLTRB(16, 10, 16, 5),
                      //               itemCount: commentData.replies.length,
                      //               itemBuilder: (context, index) {
                      //                 return Padding(
                      //                   padding: EdgeInsets.fromLTRB(50, 16, 0, 5),
                      //                   child: Row(
                      //                     crossAxisAlignment: CrossAxisAlignment.start,
                      //                     children: [
                      //                       commentData.replies[index].isAnonymous == 0
                      //                           ? ClipOval(
                      //                               child: Image.network(
                      //                                 commentData.replies[index].user.profilePhoto,
                      //                                 height: 40,
                      //                                 width: 40,
                      //                                 fit: BoxFit.cover,
                      //                               ),
                      //                             )
                      //                           :
                      //                           ClipOval(
                      //                               child: Image.asset(
                      //                                 "lib/asset/logo.png",
                      //                                 height: 40,
                      //                                 width: 40,
                      //                                 fit: BoxFit.fitWidth,
                      //                               ),
                      //                             ),
                      //                       SizedBox(
                      //                         width: 15,
                      //                       ),
                      //                       Expanded(
                      //                         child: Column(
                      //                           crossAxisAlignment: CrossAxisAlignment.start,
                      //                           children: [
                      //                             // Text(commentData.user.displayName,
                      //                             //     style: TextStyle(fontFamily: 'Quicksand', color: MateColors.activeIcons, fontWeight: FontWeight.w500, fontSize: 15)),
                      //                             InkWell(
                      //                               onTap: () {
                      //                                 if (commentData.replies[index].isAnonymous == 0) {
                      //                                   if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == commentData.replies[index].user.uuid) {
                      //                                     Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                      //                                   } else {
                      //                                     Navigator.of(context).pushNamed(UserProfileScreen.routeName, arguments: {
                      //                                       "id": commentData.replies[index].user.uuid,
                      //                                       "name": commentData.replies[index].user.displayName,
                      //                                       "photoUrl": commentData.replies[index].user.profilePhoto,
                      //                                       "firebaseUid": commentData.replies[index].user.firebaseUid
                      //                                     });
                      //                                   }
                      //                                 }
                      //                               },
                      //                               child: RichText(
                      //                                 text: TextSpan(
                      //                                   text: commentData.replies[index].isAnonymous == 1 ? "Anonymous" : commentData.replies[index].user.displayName,
                      //                                   style: TextStyle(fontFamily: 'Quicksand', color: MateColors.activeIcons, fontWeight: FontWeight.w400, fontSize: 13.3.sp),
                      //                                   children: <TextSpan>[
                      //                                     TextSpan(
                      //                                       text: "  ",
                      //                                       style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400),
                      //                                     ),
                      //                                     TextSpan(
                      //                                       text: commentData.replies[index].content,
                      //                                       style: TextStyle(color: Colors.white, fontSize: 13.0.sp, fontWeight: FontWeight.w400),
                      //                                     ),
                      //                                   ],
                      //                                 ),
                      //                               ),
                      //                             ),
                      //
                      //                             commentData.replies[index].url!=null?Padding(
                      //                               padding: const EdgeInsets.only(bottom: 5.0, top: 5),
                      //                               child: InkWell(
                      //                                 onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      //                                     builder: (context) => CommentFullImage(
                      //                                       imageNetworkPath: imageBaseUrl+commentData.replies[index].url,
                      //                                     ))),
                      //                                 child: ClipRRect(
                      //                                   borderRadius: BorderRadius.circular(12.0),
                      //                                   clipBehavior: Clip.hardEdge,
                      //                                   child: Image.network(
                      //                                     imageBaseUrl+commentData.replies[index].url,
                      //                                     fit: BoxFit.contain,
                      //                                     height: 150,
                      //                                     // width: 400,
                      //                                   ),
                      //                                 ),
                      //                               ),
                      //                             ):SizedBox(height: 15,),
                      //                             Row(
                      //                               mainAxisAlignment: MainAxisAlignment.end,
                      //                               children: [
                      //                                 Consumer<CampusTalkProvider>(
                      //                                   builder: (context, value, child) {
                      //                                     if (value.upVotePostCommentData != null) {
                      //                                       if(value.upVotePostCommentData.message == "Liked successfully" && value.upVotePostCommentData.data.commentId == commentData.replies[index].id.toString()){
                      //                                         commentData.replies[index].isLiked=IsLiked(commentId: commentData.replies[index].id);
                      //                                       }else if(value.upVotePostCommentData.message == "Unliked successfully" && value.upVotePostCommentData.data.commentId == commentData.replies[index].id.toString()){
                      //                                         commentData.replies[index].isLiked=null;
                      //                                       }
                      //                                     }
                      //                                     return !commentData.replies[index].upVoteLoader?
                      //                                     InkWell(
                      //                                         child: Icon(
                      //                                           commentData.replies[index].isLiked!=null ?  Icons.arrow_circle_up_sharp : Icons.arrow_circle_up_sharp,
                      //                                           color: commentData.replies[index].isLiked!=null ? MateColors.activeIcons : Colors.grey[50],
                      //                                           size: 18,
                      //                                         ),
                      //                                         onTap: () async{
                      //                                           bool likedDone = await Provider.of<CampusTalkProvider>(context, listen: false).upVoteAPostComment(
                      //                                               commentId: commentData.replies[index].id, index: widget.commentIndex,
                      //                                               isReply: true, replyIndex: index);
                      //                                           if(likedDone && !(commentData.replies[index].isLiked!=null)) {
                      //                                             ++commentData.replies[index].likesCount;
                      //                                           }else if(likedDone && (commentData.replies[index].isLiked!=null)){
                      //                                             --commentData.replies[index].likesCount;
                      //                                           }
                      //                                         }):
                      //                                     Padding(
                      //                                       padding: const EdgeInsets.only(left: 2, right: 4),
                      //                                       child: SizedBox(
                      //                                         height: 15,
                      //                                         width: 15,
                      //                                         child: CircularProgressIndicator(
                      //                                           color: Colors.white,
                      //                                           strokeWidth: 1.2,
                      //                                         ),
                      //                                       ),
                      //                                     );
                      //                                   },
                      //                                 ),
                      //                                 Text(
                      //                                   " ${commentData.replies[index].likesCount} ",
                      //                                   style: TextStyle(fontFamily: 'Quicksand', color: Colors.grey[50], fontSize: 12.5),
                      //                                   overflow: TextOverflow.visible,
                      //                                 ),
                      //                                 Visibility(
                      //                                     visible: Provider.of<AuthUserProvider>(context, listen: false).authUser.id == commentData.replies[index].user.uuid,
                      //                                     child: Consumer<CampusTalkProvider>(
                      //                                       builder: (context, value, child) {
                      //                                         if (value.commentFetchData.data.result[widget.commentIndex].replies[index].isDeleting) {
                      //                                           return SizedBox(
                      //                                             height: 14,
                      //                                             width: 14,
                      //                                             child: CircularProgressIndicator(
                      //                                               color: Colors.white,
                      //                                               strokeWidth: 1.2,
                      //                                             ),
                      //                                           );
                      //                                         } else {
                      //                                           return InkWell(
                      //                                             onTap: () async {
                      //                                               bool updated = await Provider.of<CampusTalkProvider>(context, listen: false).deleteCommentsOfACampusTalk(value.commentFetchData.data.result[widget.commentIndex].replies[index].id, widget.commentIndex, isReply: true, replyIndex: index);
                      //
                      //                                               if (updated) {
                      //                                                 if(widget.isBookmarkedPage){
                      //                                                   --Provider.of<CampusTalkProvider>(context, listen: false).campusTalkPostsBookmarkData.data.result[widget.postIndex].commentsCount;
                      //                                                 }else if(widget.isUserProfile){
                      //                                                   --Provider.of<CampusTalkProvider>(context, listen: false).campusTalkByUserPostsResultsList[widget.postIndex].commentsCount;
                      //                                                 }else{
                      //                                                   --Provider.of<CampusTalkProvider>(context, listen: false).campusTalkPostsResultsList[widget.postIndex].commentsCount;
                      //                                                 }
                      //                                                 Future.delayed(Duration(seconds: 0), () {
                      //                                                   Provider.of<CampusTalkProvider>(context, listen: false).fetchCommentsOfACampusTalk(widget.postId);
                      //                                                 });
                      //                                               }
                      //                                             },
                      //                                             child: Icon(
                      //                                               Icons.delete_outline,
                      //                                               size: 18,
                      //                                               color: Colors.white70,
                      //                                             ),
                      //                                           );
                      //                                         }
                      //                                       },
                      //                                     )),
                      //                                 SizedBox(
                      //                                   width: 8,
                      //                                 ),
                      //                                 Text(
                      //                                   DateFormat.yMMMEd().format(DateFormat("yyyy-MM-dd").parse(commentData.createdAt, true)),
                      //                                   style: TextStyle(color: Colors.white70, fontSize: 10.0.sp, fontWeight: FontWeight.w400),
                      //                                   textAlign: TextAlign.end,
                      //                                 ),
                      //                               ],
                      //                             )
                      //                           ],
                      //                         ),
                      //                       ),
                      //                     ],
                      //                   ),
                      //                 );
                      //               },
                      //             )
                      //           : SizedBox(),
                      //     ],
                      //   ),
                      // ),
                      Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(0.0), border: Border.all(color: themeController.isDarkMode?MateColors.darkDivider:MateColors.lightDivider, width: 1)),
                        padding: EdgeInsets.fromLTRB(16, 15, 16, 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: GestureDetector(
                                onTap: (){
                                  if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == result.user.uuid) {
                                    Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                                  } else {
                                    Navigator.of(context).pushNamed(UserProfileScreen.routeName, arguments: {
                                      "id": result.user.uuid,
                                      "name": result.user.displayName,
                                      "photoUrl": result.user.profilePhoto,
                                      "firebaseUid": result.user.firebaseUid
                                    });
                                  }
                                },
                                child: ListTile(
                                  horizontalTitleGap: 1,
                                  dense: true,
                                  leading: result.user.profilePhoto != null?
                                  ClipOval(
                                    child: Image.network(
                                      result.user.profilePhoto,
                                      height: 28,
                                      width: 28,
                                      fit: BoxFit.cover,
                                    ),
                                  ):CircleAvatar(
                                    radius: 14,
                                    child: Text(result.user.displayName[0]),
                                  ),
                                  title: Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      result.content,
                                      style:  TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.1,
                                        color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                                      ),
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Text(
                                      DateFormat.yMMMEd().format(DateFormat("yyyy-MM-dd").parse(result.createdAt, true)),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: 0.1,
                                        color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 58,top: 5),
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: ()=> focusNode.requestFocus(),
                                    child: Text("Reply", style: TextStyle(color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor, fontSize: 12.5, fontWeight: FontWeight.w400),),
                                  ),
                                  Text(result.replies.isEmpty?"":result.replies.length>1?
                                  "   •   ${result.replies.length} Replies":
                                  "   •   ${result.replies.length} Reply",
                                    style: TextStyle(color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor, fontSize: 12.5, fontWeight: FontWeight.w400),),
                                ],
                              ),
                            ),
                            result.replies.isNotEmpty?
                            ListView.builder(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              itemCount: result.replies.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.fromLTRB(40, 0, 0, 5),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            if (result.replies[index].isAnonymous == 0) {
                                              if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == result.replies[index].user.uuid) {
                                                Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                                              } else {
                                                Navigator.of(context).pushNamed(UserProfileScreen.routeName, arguments: {
                                                  "id": result.replies[index].user.uuid,
                                                  "name": result.replies[index].user.displayName,
                                                  "photoUrl": result.replies[index].user.profilePhoto,
                                                  "firebaseUid": result.replies[index].user.firebaseUid
                                                });
                                              }
                                            }
                                          },
                                          child: ListTile(
                                            horizontalTitleGap: 1,
                                            dense: true,
                                            leading:
                                            result.replies[index].isAnonymous == 1 ?
                                            ClipOval(
                                              child: Image.asset(
                                                "lib/asset/logo.png",
                                                height: 28,
                                                width: 28,
                                                fit: BoxFit.fitWidth,
                                              ),
                                            ):
                                            result.replies[index].user.profilePhoto != null?
                                            ClipOval(
                                              child: Image.network(
                                                result.replies[index].user.profilePhoto,
                                                height: 28,
                                                width: 28,
                                                fit: BoxFit.cover,
                                              ),
                                            ):CircleAvatar(
                                              radius: 14,
                                              child: Text(result.replies[index].user.displayName[0],),
                                            ),
                                            title: Padding(
                                              padding: const EdgeInsets.only(top: 10),
                                              child: Text(
                                                result.replies[index].content,
                                                style:  TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0.1,
                                                  color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                                                ),
                                              ),
                                            ),
                                            subtitle: Padding(
                                              padding: const EdgeInsets.only(top: 5),
                                              child: Text(
                                                DateFormat.yMMMEd().format(DateFormat("yyyy-MM-dd").parse(result.createdAt, true)),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  letterSpacing: 0.1,
                                                  color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
                                                ),
                                              ),
                                            ),
                                            trailing: Visibility(
                                                visible: Provider.of<AuthUserProvider>(context, listen: false).authUser.id == result.replies[index].user.uuid,
                                                child: Consumer<CampusTalkProvider>(
                                                  builder: (context, value, child) {
                                                    if(value.commentFetchData.data.result[widget.commentIndex].replies[index].isDeleting){
                                                      return SizedBox(
                                                        height: 14,
                                                        width: 14,
                                                        child: CircularProgressIndicator(
                                                          color: themeController.isDarkMode?Colors.white:Colors.black,
                                                          strokeWidth: 1.2,
                                                        ),
                                                      );
                                                    }else{
                                                      return InkWell(
                                                        onTap: () async {
                                                          bool updated = await Provider.of<CampusTalkProvider>(context, listen: false).deleteCommentsOfACampusTalk(value.commentFetchData.data.result[widget.commentIndex].replies[index].id, widget.commentIndex, isReply: true, replyIndex: index);

                                                          if (updated) {
                                                            if(widget.isBookmarkedPage){
                                                              --Provider.of<CampusTalkProvider>(context, listen: false).campusTalkPostsBookmarkData.data.result[widget.postIndex].commentsCount;
                                                            }else if(widget.isUserProfile){
                                                              --Provider.of<CampusTalkProvider>(context, listen: false).campusTalkByUserPostsResultsList[widget.postIndex].commentsCount;
                                                            }else{
                                                              --Provider.of<CampusTalkProvider>(context, listen: false).campusTalkPostsResultsList[widget.postIndex].commentsCount;
                                                            }
                                                            Future.delayed(Duration(seconds: 0), () {
                                                              Provider.of<CampusTalkProvider>(context, listen: false).fetchCommentsOfACampusTalk(widget.postId);
                                                            });
                                                          }
                                                        },
                                                        child: Icon(
                                                          Icons.delete_outline,
                                                          size: 18,
                                                          color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
                                                        ),
                                                      );

                                                    }
                                                  },
                                                )),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ):SizedBox(),
                          ],
                        ),
                      ),
                    ],
                  );
                }
                if (campusLiveProvider.error != '') {
                  return Center(
                      child: Container(
                          color: Colors.red,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '${campusLiveProvider.error}',
                              style: TextStyle(color: Colors.white),
                            ),
                          )));
                }
                if (campusLiveProvider.fetchCommentsLoader) {
                  return timelineLoader();
                }
                return Container();
              },
            ),
          ),
          _messageSendWidget()
        ],
      ),
    );
  }

  Widget _messageSendWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        // imageFile != null
        //     ? Stack(
        //         clipBehavior: Clip.none,
        //         children: [
        //           InkWell(
        //             onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => CommentFullImage(imageFilePath: imageFile,),)),
        //             child: Container(
        //                 clipBehavior: Clip.hardEdge,
        //                 width: 100,
        //                 height: 100,
        //                 alignment: Alignment.center,
        //                 decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), border: Border.all(color: Colors.grey, width: 0.3)),
        //                 padding: EdgeInsets.all(5),
        //                 margin: EdgeInsets.only(left: 5, bottom: 2),
        //                 child: Image.file(
        //                   imageFile,
        //                   fit: BoxFit.fill,
        //                 )),
        //           ),
        //           Positioned(
        //             top: -5,
        //             right: -5,
        //             child: InkWell(
        //               splashColor: Colors.transparent,
        //               highlightColor: Colors.transparent,
        //               onTap: () {
        //                 setState(() {
        //                   imageFile = null;
        //                 });
        //               },
        //               child: SizedBox(
        //                 width: 35,
        //                 height: 35,
        //                 child: Align(
        //                   alignment: Alignment.topRight,
        //                   child: CircleAvatar(
        //                     backgroundColor: myHexColor,
        //                     radius: 11,
        //                     child: ImageIcon(
        //                       AssetImage("lib/asset/icons/cross.png"),
        //                       size: 22,
        //                       color: Colors.white70,
        //                     ),
        //                   ),
        //                 ),
        //               ),
        //             ),
        //           ),
        //         ],
        //       )
        //     : Row(
        //         children: [
        //           Padding(
        //             padding: EdgeInsets.symmetric(horizontal: 8.0),
        //             child: InkWell(
        //               child: new Icon(
        //                 Icons.image,
        //                 color: Colors.grey,
        //               ),
        //               onTap: () => _getImage(0),
        //             ),
        //           ),
        //           InkWell(
        //             child: new Icon(
        //               Icons.camera_alt,
        //               color: Colors.grey,
        //             ),
        //             onTap: () => _getImage(1),
        //           ),
        //         ],
        //       ),

        // Expanded(
        //   child: Container(
        //     alignment: Alignment.bottomCenter,
        //     // width: MediaQuery.of(context).size.width * 0.5,
        //     margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
        //     padding: EdgeInsets.only(left: 15),
        //     decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12.0)), color: Colors.transparent, border: Border.all(color: Colors.grey, width: 0.3)),
        //     child: TextField(
        //       controller: messageEditingController,
        //       cursorColor: Colors.cyanAccent,
        //       focusNode: focusNode,
        //       style: TextStyle(color: Colors.white),
        //       textInputAction: TextInputAction.done,
        //       minLines: 1,
        //       maxLines: 4,
        //       decoration: InputDecoration(
        //           hintText: "Write Comment ...",
        //           hintStyle: TextStyle(
        //             color: Colors.white38,
        //             fontSize: 13.3.sp,
        //           ),
        //           contentPadding: EdgeInsets.fromLTRB(0, 12, 0, 12),
        //           suffixIconConstraints: BoxConstraints(maxHeight: 30, maxWidth: 34),
        //           suffixIcon:
        //           InkWell(
        //               splashColor: Colors.transparent,
        //               highlightColor: Colors.transparent,
        //               onTap: () => setState(() {
        //                     isAnonymous = !isAnonymous;
        //                   }),
        //               child: Padding(
        //                 padding: const EdgeInsets.fromLTRB(5, 0, 7, 0),
        //                 child: ImageIcon(
        //                   AssetImage("lib/asset/icons/incognito_icon.png"),
        //                   color: isAnonymous ? MateColors.activeIcons : Colors.grey,
        //                   size: 24,
        //                 ),
        //               )),
        //           border: InputBorder.none),
        //     ),
        //   ),
        // ),
        // messageSentCheck
        //     ? Container(
        //         height: 45.0,
        //         width: 45.0,
        //         decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(50.0)), color: Colors.transparent, border: Border.all(color: Colors.grey, width: 0.3)),
        //         child: Center(
        //           child: CircularProgressIndicator(
        //             color: Colors.white,
        //           ),
        //         ),
        //       )
        //     : GestureDetector(
        //         onTap: () async {
        //           if (messageEditingController.text.trim().isNotEmpty || imageFile!=null) {
        //             setState(() {
        //               messageSentCheck = true;
        //             });
        //
        //             bool updated = await Provider.of<CampusTalkProvider>(context, listen: false).commentACampusTalk(content:messageEditingController.text.trim().isNotEmpty? messageEditingController.text.trim():" ",
        //                 isAnonymous: isAnonymous?"1":"0",parentId: widget.commentId,postId:  widget.postId, imageFile: imageFile);
        //
        //             if (updated) {
        //               if(widget.isBookmarkedPage){
        //                 ++Provider.of<CampusTalkProvider>(context, listen: false).campusTalkPostsBookmarkData.data.result[widget.postIndex].commentsCount;
        //               }else if(widget.isUserProfile){
        //                 ++Provider.of<CampusTalkProvider>(context, listen: false).campusTalkByUserPostsResultsList[widget.postIndex].commentsCount;
        //               }else{
        //                 ++
        //                 Provider.of<CampusTalkProvider>(context, listen: false).campusTalkPostsResultsList[widget.postIndex].commentsCount;
        //               }
        //               messageEditingController.text = "";
        //               imageFile = null;
        //               Future.delayed(Duration(seconds: 0), () {
        //                 Provider.of<CampusTalkProvider>(context, listen: false).fetchCommentsOfACampusTalk(widget.postId);
        //               });
        //             }
        //             setState(() {
        //               messageSentCheck = false;
        //             });
        //           }
        //         },
        //         child: Container(
        //           height: 45.0,
        //           width: 45.0,
        //           decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(50.0)), color: Colors.transparent, border: Border.all(color: Colors.grey, width: 0.3)),
        //           child: Center(child: Icon(Icons.send, color: MateColors.activeIcons)),
        //         ),
        //       )



        Expanded(
          child: Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.fromLTRB(16,15, 16, 10),
            child: TextField(
              focusNode: focusNode,
              controller: messageEditingController,
              cursorColor: Colors.cyanAccent,
              style: TextStyle(color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor),
              textInputAction: TextInputAction.done,
              minLines: 1,
              maxLines: 4,
              decoration: InputDecoration(
                hintStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.1,
                  color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () => setState(() {
                          isAnonymous = !isAnonymous;
                        }),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(5, 0, 7, 0),
                          child: ImageIcon(
                            AssetImage("lib/asset/icons/incognito_icon.png"),
                            color: isAnonymous ? MateColors.activeIcons : Colors.grey,
                            size: 24,
                          ),
                        )),
                    IconButton(
                      icon: Icon(
                        Icons.send,
                        size: 20,
                        color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
                      ),
                      onPressed: ()async {
                        if (messageEditingController.text.trim().isNotEmpty || imageFile!=null) {
                          setState(() {
                            messageSentCheck = true;
                          });

                          bool updated = await Provider.of<CampusTalkProvider>(context, listen: false).commentACampusTalk(content:messageEditingController.text.trim().isNotEmpty? messageEditingController.text.trim():" ",
                              isAnonymous: isAnonymous?"1":"0",parentId: widget.commentId,postId:  widget.postId, imageFile: imageFile);

                          if (updated) {
                            if(widget.isBookmarkedPage){
                              ++Provider.of<CampusTalkProvider>(context, listen: false).campusTalkPostsBookmarkData.data.result[widget.postIndex].commentsCount;
                            }else if(widget.isUserProfile){
                              ++Provider.of<CampusTalkProvider>(context, listen: false).campusTalkByUserPostsResultsList[widget.postIndex].commentsCount;
                            }else{
                              ++
                              Provider.of<CampusTalkProvider>(context, listen: false).campusTalkPostsResultsList[widget.postIndex].commentsCount;
                            }
                            messageEditingController.text = "";
                            imageFile = null;
                            Future.delayed(Duration(seconds: 0), () {
                              Provider.of<CampusTalkProvider>(context, listen: false).fetchCommentsOfACampusTalk(widget.postId);
                            });
                          }
                          setState(() {
                            messageSentCheck = false;
                          });
                        }
                      },
                    ),
                  ],
                ),
                hintText: "Add a comment...",
                fillColor: themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightButtonBackground,
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderSide:  BorderSide(
                    color: themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightButtonBackground,
                  ),
                  borderRadius: BorderRadius.circular(26.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:  BorderSide(
                    color:  themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightButtonBackground,
                  ),
                  borderRadius: BorderRadius.circular(26.0),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide:  BorderSide(
                    color: themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightButtonBackground,
                  ),
                  borderRadius: BorderRadius.circular(26.0),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide:  BorderSide(
                    color: themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightButtonBackground,
                  ),
                  borderRadius: BorderRadius.circular(26.0),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide:  BorderSide(
                    color: themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightButtonBackground,
                  ),
                  borderRadius: BorderRadius.circular(26.0),
                ),
              ),
            ),
          ),
        ),


      ],
    );
  }

  Future _getImage(int index) async {
    XFile pickImage;
      pickImage =index == 0 ? await picker.pickImage(source: ImageSource.gallery, imageQuality: 40) : await picker.pickImage(source: ImageSource.gallery, imageQuality: 40);

    if (pickImage != null) {
      imageFile = pickImage;
      setState(() {
        isLoading = true;
      });
      // _uploadFile();
    }

  }
}
