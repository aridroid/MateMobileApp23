import 'dart:io';

import 'package:get/get.dart';
import 'package:mate_app/Model/campusTalkCommentFetchModel.dart';
import 'package:mate_app/Providers/AuthUserProvider.dart';
import 'package:mate_app/Providers/campusTalkProvider.dart';
import 'package:mate_app/Screen/Home/Community/campusTalkCommentReply.dart';
import 'package:mate_app/Screen/Profile/ProfileScreen.dart';
import 'package:mate_app/Screen/Profile/UserProfileScreen.dart';
import 'package:mate_app/Utility/Utility.dart';
import 'package:mate_app/Widget/Loaders/Shimmer.dart';
import 'package:mate_app/asset/Colors/MateColors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../controller/theme_controller.dart';
import 'commentFullImage.dart';
import 'package:sizer/sizer.dart';

class CampusTalkComments extends StatefulWidget {
  final bool isBookmarkedPage;
  final bool isUserProfile;
  final int postIndex;
  final int postId;

  const CampusTalkComments({Key key, this.postId, this.postIndex, this.isBookmarkedPage=false, this.isUserProfile=false}) : super(key: key);

  @override
  _CampusTalkCommentsState createState() => _CampusTalkCommentsState();
}

class _CampusTalkCommentsState extends State<CampusTalkComments> {
  ThemeController themeController = Get.find<ThemeController>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
       behavior: HitTestBehavior.translucent,
          onTap: null,
          onPanUpdate: (details) {
            if (details.delta.dy > 0){
              FocusScope.of(context).requestFocus(FocusNode());
              print("Dragging in +Y direction");
            }
          },
      child: Scaffold(
        //backgroundColor: myHexColor,
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(
            color: MateColors.activeIcons,
          ),
          title: Text('Comments', style: TextStyle(
          color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
            fontWeight: FontWeight.w700,
            fontSize: 17.0,
          ),
        ),
          centerTitle: true,
        ),
        body: CampusTalkCommentsWidget(
          isUserProfile: widget.isUserProfile,
          isBookmarkedPage: widget.isBookmarkedPage,
          postId: widget.postId,
          postIndex: widget.postIndex,
        ),
      ),
    );
  }
}


class CampusTalkCommentsWidget extends StatefulWidget {
  final bool isBookmarkedPage;
  final bool isUserProfile;
  final int postIndex;
  final int postId;

  const CampusTalkCommentsWidget({Key key, this.isBookmarkedPage, this.isUserProfile, this.postIndex, this.postId}) : super(key: key);

  @override
  _CampusTalkCommentsWidgetState createState() => _CampusTalkCommentsWidgetState();
}

class _CampusTalkCommentsWidgetState extends State<CampusTalkCommentsWidget> {
  TextEditingController messageEditingController = new TextEditingController();

  bool messageSentCheck = false;
  XFile imageFile;
  bool isLoading = false;
  bool  isAnonymous =false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 0), () {
      Provider.of<CampusTalkProvider>(context, listen: false).fetchCommentsOfACampusTalk(widget.postId);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        isAnonymous? Container(
          height: 20,
          width: double.infinity,
          color: Colors.teal[900],
          alignment: Alignment.center,
          child: Text("You are now in INCOGNITO MODE",style: TextStyle(color: Colors.white,fontSize: 11),),
        ):SizedBox(),
        _messageSendWidget(),
        Expanded(
          child: Consumer<CampusTalkProvider>(
            builder: (context, campusTalkProvider, child) {
              if (!campusTalkProvider.fetchCommentsLoader && campusTalkProvider.commentFetchData != null) {
                return ListView(
                  children: [
                    ListView.builder(
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                      shrinkWrap: true,
                      reverse: true,
                      physics: ScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(16, 10, 16, 16),
                      itemCount: campusTalkProvider.commentFetchData.data.result.length,
                      itemBuilder: (context, index) {
                        Result commentData=campusTalkProvider.commentFetchData.data.result[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: GestureDetector(
                                onTap: (){
                                  if(commentData.isAnonymous==0){
                                    if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == commentData.user.uuid) {
                                      Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                                    } else {
                                      Navigator.of(context).pushNamed(UserProfileScreen.routeName, arguments: {
                                        "id": commentData.user.uuid,
                                        "name": commentData.user.displayName,
                                        "photoUrl": commentData.user.profilePhoto,
                                        "firebaseUid": commentData.user.firebaseUid
                                      });
                                    }
                                  }
                                },
                                child: ListTile(
                                  horizontalTitleGap: 1,
                                  dense: true,
                                  leading: commentData.isAnonymous==0?
                                  ClipOval(
                                    child: Image.network(
                                      commentData.user.profilePhoto,
                                      height: 28,
                                      width: 28,
                                      fit: BoxFit.cover,
                                    ),
                                  ):
                                  ClipOval(
                                    child: Image.asset(
                                      "lib/asset/logo.png",
                                      height: 28,
                                      width: 28,
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                  title: Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      commentData.content,
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
                                      DateFormat.yMMMEd().format(DateFormat("yyyy-MM-dd").parse(commentData.createdAt, true)),
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
                                    onTap: ()=> Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => CampusTalkCommentReply(
                                          commentId: commentData.id,
                                          commentIndex: index,
                                          postId: widget.postId,
                                          isBookmarkedPage: widget.isBookmarkedPage,
                                          isUserProfile: widget.isUserProfile,
                                          postIndex: widget.postIndex,
                                        ))),
                                    child: Text("Reply", style: TextStyle(color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor, fontSize: 12.5, fontWeight: FontWeight.w400),),
                                  ),
                                  Text(commentData.replies.isEmpty?"":commentData.repliesCount>1?
                                  "   •   ${commentData.repliesCount} Replies":
                                  "   •   ${commentData.repliesCount} Reply",
                                    style: TextStyle(color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor, fontSize: 12.5, fontWeight: FontWeight.w400),),
                                  Spacer(),
                                  Visibility(
                                      visible: Provider.of<AuthUserProvider>(context, listen: false).authUser.id == commentData.user.uuid,
                                      child: Consumer<CampusTalkProvider>(
                                        builder: (context, value, child) {
                                          if(commentData.isDeleting){
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
                                              onTap: () async{
                                                bool updated = await Provider.of<CampusTalkProvider>(context, listen: false).deleteCommentsOfACampusTalk(commentData.id, index);

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
                                                color: themeController.isDarkMode?MateColors.lightDivider:MateColors.darkDivider,
                                              ),
                                            );

                                          }
                                        },
                                      )),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: commentData.repliesCount>1,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(55, 10, 5, 0),
                                child: InkWell(
                                  onTap: ()=> Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => CampusTalkCommentReply(
                                        commentId: commentData.id,
                                        commentIndex: index,
                                        postId: widget.postId,
                                        isBookmarkedPage: widget.isBookmarkedPage,
                                        isUserProfile: widget.isUserProfile,
                                        postIndex: widget.postIndex,
                                      ))),
                                  child: Text(
                                    "Show previous replies...",
                                    style: TextStyle(color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor, fontSize: 13, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                            commentData.replies.isNotEmpty?
                            Padding(
                              padding: EdgeInsets.fromLTRB(40, 0, 0, 5),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        if( commentData.replies.last.isAnonymous==0){
                                          if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == commentData.replies.last.user.uuid) {
                                            Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                                          } else {
                                            Navigator.of(context).pushNamed(UserProfileScreen.routeName, arguments: {
                                              "id": commentData.replies.last.user.uuid,
                                              "name": commentData.replies.last.user.displayName,
                                              "photoUrl": commentData.replies.last.user.profilePhoto,
                                              "firebaseUid": commentData.replies.last.user.firebaseUid
                                            });
                                          }
                                        }
                                      },
                                      child: ListTile(
                                        horizontalTitleGap: 1,
                                        dense: true,
                                        leading: commentData.replies.last.isAnonymous==1?
                                        ClipOval(
                                          child: Image.asset(
                                            "lib/asset/logo.png",
                                            height: 28,
                                            width: 28,
                                            fit: BoxFit.fitWidth,
                                          ),
                                        ):
                                        commentData.replies.last.user.profilePhoto != null ?
                                        ClipOval(
                                          child: Image.network(
                                            commentData.replies.last.user.profilePhoto,
                                            height: 28,
                                            width: 28,
                                            fit: BoxFit.cover,
                                          ),
                                        ):CircleAvatar(
                                          radius: 14,
                                          child: Text(commentData.replies.last.user.displayName[0],),
                                        ),
                                        title: Padding(
                                          padding: const EdgeInsets.only(top: 10),
                                          child: Text(
                                            commentData.replies.last.content,
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
                                            DateFormat.yMMMEd().format(DateFormat("yyyy-MM-dd").parse(commentData.replies.last.createdAt, true)),
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
                                ],
                              ),
                            ):SizedBox(),




                            // Padding(
                            //   padding: EdgeInsets.fromLTRB(50, 16, 0, 5),
                            //   child: Row(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: [
                            //       commentData.replies.last.isAnonymous==0
                            //           ? ClipOval(
                            //         child: Image.network(
                            //           commentData.replies.last.user.profilePhoto,
                            //           height: 40,
                            //           width: 40,
                            //           fit: BoxFit.cover,
                            //         ),
                            //       ):ClipOval(
                            //         child: Image.asset(
                            //           "lib/asset/logo.png",
                            //           height: 40,
                            //           width: 40,
                            //           fit: BoxFit.fitWidth,
                            //         ),
                            //       ),
                            //       SizedBox(
                            //         width: 15,
                            //       ),
                            //       Expanded(
                            //         child: Column(
                            //           crossAxisAlignment: CrossAxisAlignment.start,
                            //           children: [
                            //             // Text(commentData.user.displayName,
                            //             //     style: TextStyle(fontFamily: 'Quicksand', color: MateColors.activeIcons, fontWeight: FontWeight.w500, fontSize: 15)),
                            //             InkWell(
                            //               onTap: () {
                            //                 if( commentData.replies.last.isAnonymous==0){
                            //                   if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == commentData.replies.last.user.uuid) {
                            //                     Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                            //                   } else {
                            //                     Navigator.of(context).pushNamed(UserProfileScreen.routeName, arguments: {
                            //                       "id": commentData.replies.last.user.uuid,
                            //                       "name": commentData.replies.last.user.displayName,
                            //                       "photoUrl": commentData.replies.last.user.profilePhoto,
                            //                       "firebaseUid": commentData.replies.last.user.firebaseUid
                            //                     });
                            //                   }
                            //                 }
                            //               },
                            //               child: RichText(
                            //                 text: TextSpan(
                            //                   text: commentData.replies.last.isAnonymous==1?"Anonymous": commentData.replies.last.user.displayName,
                            //                   style: TextStyle(fontFamily: 'Quicksand', color: MateColors.activeIcons, fontWeight: FontWeight.w400, fontSize: 13.3.sp),
                            //                   children: <TextSpan>[
                            //                     TextSpan(
                            //                       text: "  ",
                            //                       style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400),
                            //                     ),
                            //                     TextSpan(
                            //                       text: commentData.replies.last.content,
                            //                       style: TextStyle(color: Colors.white, fontSize: 13.0.sp, fontWeight: FontWeight.w400),
                            //                     ),
                            //                   ],
                            //                 ),
                            //               ),
                            //             ),
                            //             commentData.replies.last.url!=null?Padding(
                            //               padding: const EdgeInsets.only(bottom: 5.0, top: 5),
                            //               child: InkWell(
                            //                 onTap: () => Navigator.of(context).push(MaterialPageRoute(
                            //                     builder: (context) => CommentFullImage(
                            //                       imageNetworkPath: imageBaseUrl+commentData.replies.last.url,
                            //                     ))),
                            //                 child: ClipRRect(
                            //                   borderRadius: BorderRadius.circular(12.0),
                            //                   clipBehavior: Clip.hardEdge,
                            //                   child: Image.network(
                            //                     imageBaseUrl+commentData.replies.last.url,
                            //                     fit: BoxFit.contain,
                            //                     height: 150,
                            //                     // width: 400,
                            //                   ),
                            //                 ),
                            //               ),
                            //             ):SizedBox(height: 10,),
                            //             Row(
                            //               mainAxisAlignment: MainAxisAlignment.end,
                            //               children: [
                            //                 Consumer<CampusTalkProvider>(
                            //                   builder: (context, value, child) {
                            //                     if (value.upVotePostCommentData != null) {
                            //                       if(value.upVotePostCommentData.message == "Liked successfully" && value.upVotePostCommentData.data.commentId == commentData.replies.last.id.toString()){
                            //                         commentData.replies.last.isLiked=IsLiked(commentId: commentData.replies.last.id);
                            //                       }else if(value.upVotePostCommentData.message == "Unliked successfully" && value.upVotePostCommentData.data.commentId == commentData.replies.last.id.toString()){
                            //                         commentData.replies.last.isLiked=null;
                            //                       }
                            //                     }
                            //                     return !commentData.replies.last.upVoteLoader?
                            //                     InkWell(
                            //                         child: Icon(
                            //                           commentData.replies.last.isLiked!=null ?  Icons.arrow_circle_up_sharp : Icons.arrow_circle_up_sharp,
                            //                           color: commentData.replies.last.isLiked!=null ? MateColors.activeIcons : Colors.grey[50],
                            //                           size: 18,
                            //                         ),
                            //                         onTap: () async{
                            //                           bool likedDone = await Provider.of<CampusTalkProvider>(context, listen: false).upVoteAPostComment(
                            //                               commentId: commentData.replies.last.id, index: index,
                            //                               isReply: true, replyIndex: commentData.replies.length-1);
                            //                           if(likedDone && !(commentData.replies.last.isLiked!=null)) {
                            //                             ++commentData.replies.last.likesCount;
                            //                           }else if(likedDone && (commentData.replies.last.isLiked!=null)){
                            //                             --commentData.replies.last.likesCount;
                            //                           }
                            //                         }):
                            //                     Padding(
                            //                       padding: const EdgeInsets.only(left: 2, right: 4),
                            //                       child: SizedBox(
                            //                         height: 15,
                            //                         width: 15,
                            //                         child: CircularProgressIndicator(
                            //                           color: Colors.white,
                            //                           strokeWidth: 1.2,
                            //                         ),
                            //                       ),
                            //                     );
                            //                   },
                            //                 ),
                            //                 Text(
                            //                   " ${commentData.replies.last.likesCount} ",
                            //                   style: TextStyle(fontFamily: 'Quicksand', color: Colors.grey[50], fontSize: 12.5),
                            //                   overflow: TextOverflow.visible,
                            //                 ),
                            //                 Visibility(
                            //                     visible: Provider.of<AuthUserProvider>(context, listen: false).authUser.id == commentData.replies.last.user.uuid,
                            //                     child: Consumer<CampusTalkProvider>(
                            //                       builder: (context, value, child) {
                            //                         if(commentData.replies.last.isDeleting){
                            //                           return SizedBox(
                            //                             height: 14,
                            //                             width: 14,
                            //                             child: CircularProgressIndicator(
                            //                               color: Colors.white,
                            //                               strokeWidth: 1.2,
                            //                             ),
                            //                           );
                            //                         }else{
                            //                           return InkWell(
                            //                             onTap: () async{
                            //                               bool updated = await Provider.of<CampusTalkProvider>(context, listen: false).deleteCommentsOfACampusTalk(commentData.replies.last.id, index,
                            //                                   isReply: true, replyIndex: commentData.replies.length-1);
                            //
                            //                               if (updated) {
                            //                                 if(widget.isBookmarkedPage){
                            //                                   --Provider.of<CampusTalkProvider>(context, listen: false).campusTalkPostsBookmarkData.data.result[widget.postIndex].commentsCount;
                            //                                 }else if(widget.isUserProfile){
                            //                                   --Provider.of<CampusTalkProvider>(context, listen: false).campusTalkByUserPostsResultsList[widget.postIndex].commentsCount;
                            //                                 }else{
                            //                                   --Provider.of<CampusTalkProvider>(context, listen: false).campusTalkPostsResultsList[widget.postIndex].commentsCount;
                            //                                 }
                            //
                            //                                 Future.delayed(Duration(seconds: 0), () {
                            //                                   Provider.of<CampusTalkProvider>(context, listen: false).fetchCommentsOfACampusTalk(widget.postId);
                            //                                 });
                            //                               }
                            //                             },
                            //                             child: Icon(
                            //                               Icons.delete_outline,
                            //                               size: 18,
                            //                               color: Colors.white70,
                            //                             ),
                            //                           );
                            //
                            //                         }
                            //                       },
                            //                     )),
                            //                 SizedBox(
                            //                   width: 8,
                            //                 ),
                            //                 Text(
                            //                   DateFormat.yMMMEd().format(DateFormat("yyyy-MM-dd").parse(commentData.createdAt, true)),
                            //                   style: TextStyle(color: Colors.white70, fontSize: 10.0.sp, fontWeight: FontWeight.w400),
                            //                   textAlign: TextAlign.end,
                            //                 ),
                            //               ],
                            //             )
                            //           ],
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ):SizedBox(),
                          ],
                        );




                        //   Container(
                        //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(0.0), border: Border.all(color: MateColors.line, width: 1)),
                        //   padding: EdgeInsets.fromLTRB(16, 15, 16, 15),
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       Row(
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //           commentData.isAnonymous==0
                        //               ? ClipOval(
                        //             child: Image.network(
                        //               commentData.user.profilePhoto,
                        //               height: 40,
                        //               width: 40,
                        //               fit: BoxFit.cover,
                        //             ),
                        //           ):ClipOval(
                        //             child: Image.asset(
                        //               "lib/asset/logo.png",
                        //               height: 40,
                        //               width: 40,
                        //               fit: BoxFit.fitWidth,
                        //             ),
                        //           ),
                        //           SizedBox(
                        //             width: 15,
                        //           ),
                        //           Expanded(
                        //             child: Column(
                        //               crossAxisAlignment: CrossAxisAlignment.start,
                        //               children: [
                        //                 // Text(commentData.user.displayName,
                        //                 //     style: TextStyle(fontFamily: 'Quicksand', color: MateColors.activeIcons, fontWeight: FontWeight.w500, fontSize: 15)),
                        //                 InkWell(
                        //                   onTap: () {
                        //                     if(commentData.isAnonymous==0){
                        //                       if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == commentData.user.uuid) {
                        //                         Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                        //                       } else {
                        //                         Navigator.of(context).pushNamed(UserProfileScreen.routeName, arguments: {
                        //                           "id": commentData.user.uuid,
                        //                           "name": commentData.user.displayName,
                        //                           "photoUrl": commentData.user.profilePhoto,
                        //                           "firebaseUid": commentData.user.firebaseUid
                        //                         });
                        //                       }
                        //                     }
                        //                   },
                        //                   child: RichText(
                        //                     text: TextSpan(
                        //                       text: commentData.isAnonymous==1?"Anonymous":commentData.user.displayName,
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
                        //                       onTap: ()=> Navigator.of(context).push(MaterialPageRoute(
                        //                           builder: (context) => CampusTalkCommentReply(
                        //                             commentId: commentData.id,
                        //                             commentIndex: index,
                        //                             postId: widget.postId,
                        //                             isBookmarkedPage: widget.isBookmarkedPage,
                        //                             isUserProfile: widget.isUserProfile,
                        //                             postIndex: widget.postIndex,
                        //                           ))),
                        //                       child: Text("Reply", style: TextStyle(color: Colors.white, fontSize: 10.5.sp, fontWeight: FontWeight.w400),),
                        //                     ),
                        //                     Text(commentData.replies.isEmpty?"":commentData.repliesCount>1?
                        //                     "   •   ${commentData.repliesCount} Replies":
                        //                     "   •   ${commentData.repliesCount} Reply",
                        //                       style: TextStyle(color: Colors.white70, fontSize: 10.5.sp, fontWeight: FontWeight.w400),),
                        //                     Spacer(),
                        //                     Consumer<CampusTalkProvider>(
                        //                       builder: (context, value, child) {
                        //                         if (value.upVotePostCommentData != null) {
                        //                           if(value.upVotePostCommentData.message == "Liked successfully" && value.upVotePostCommentData.data.commentId == commentData.id.toString()){
                        //                             commentData.isLiked=IsLiked(commentId: commentData.id);
                        //                           }else if(value.upVotePostCommentData.message == "Unliked successfully" && value.upVotePostCommentData.data.commentId == commentData.id.toString()){
                        //                             commentData.isLiked=null;
                        //                           }
                        //                         }
                        //                         return !commentData.upVoteLoader?
                        //                         InkWell(
                        //                             child: Icon(
                        //                               commentData.isLiked!=null ?  Icons.arrow_circle_up_sharp : Icons.arrow_circle_up_sharp,
                        //                               color: commentData.isLiked!=null ? MateColors.activeIcons : Colors.grey[50],
                        //                               size: 18,
                        //                             ),
                        //                             onTap: () async{
                        //                               bool likedDone = await Provider.of<CampusTalkProvider>(context, listen: false).upVoteAPostComment(commentId: commentData.id,index: index);
                        //                               if(likedDone && !(commentData.isLiked!=null)) {
                        //                                 ++commentData.likesCount;
                        //                               }else if(likedDone && (commentData.isLiked!=null)){
                        //                                 --commentData.likesCount;
                        //                               }
                        //                             }):
                        //                         Padding(
                        //                           padding: const EdgeInsets.only(left: 2, right: 4),
                        //                           child: SizedBox(
                        //                             height: 15,
                        //                             width: 15,
                        //                             child: CircularProgressIndicator(
                        //                               color: Colors.white,
                        //                               strokeWidth: 1.2,
                        //                             ),
                        //                           ),
                        //                         );
                        //                       },
                        //                     ),
                        //                     Text(
                        //                       " ${commentData.likesCount} ",
                        //                       style: TextStyle(fontFamily: 'Quicksand', color: Colors.grey[50], fontSize: 12.5),
                        //                       overflow: TextOverflow.visible,
                        //                     ),
                        //                     Visibility(
                        //                         visible: Provider.of<AuthUserProvider>(context, listen: false).authUser.id == commentData.user.uuid,
                        //                         child: Consumer<CampusTalkProvider>(
                        //                           builder: (context, value, child) {
                        //                             if(commentData.isDeleting){
                        //                               return SizedBox(
                        //                                 height: 14,
                        //                                 width: 14,
                        //                                 child: CircularProgressIndicator(
                        //                                   color: Colors.white,
                        //                                   strokeWidth: 1.2,
                        //                                 ),
                        //                               );
                        //                             }else{
                        //                               return InkWell(
                        //                                 onTap: () async{
                        //                                   bool updated = await Provider.of<CampusTalkProvider>(context, listen: false).deleteCommentsOfACampusTalk(commentData.id, index);
                        //
                        //                                   if (updated) {
                        //                                     if(widget.isBookmarkedPage){
                        //                                       --Provider.of<CampusTalkProvider>(context, listen: false).campusTalkPostsBookmarkData.data.result[widget.postIndex].commentsCount;
                        //                                     }else if(widget.isUserProfile){
                        //                                       --Provider.of<CampusTalkProvider>(context, listen: false).campusTalkByUserPostsResultsList[widget.postIndex].commentsCount;
                        //                                     }else{
                        //                                       --Provider.of<CampusTalkProvider>(context, listen: false).campusTalkPostsResultsList[widget.postIndex].commentsCount;
                        //                                     }
                        //
                        //                                     Future.delayed(Duration(seconds: 0), () {
                        //                                       Provider.of<CampusTalkProvider>(context, listen: false).fetchCommentsOfACampusTalk(widget.postId);
                        //                                     });
                        //                                   }
                        //                                 },
                        //                                 child: Icon(
                        //                                   Icons.delete_outline,
                        //                                   size: 18,
                        //                                   color: Colors.white70,
                        //                                 ),
                        //                               );
                        //
                        //                             }
                        //                           },
                        //                         )),
                        //                     SizedBox(
                        //                       width: 8,
                        //                     ),
                        //                     Text(
                        //                       DateFormat.yMMMEd().format(DateFormat("yyyy-MM-dd").parse(commentData.createdAt, true)),
                        //                       style: TextStyle(color: Colors.white70, fontSize: 9.0.sp, fontWeight: FontWeight.w400),
                        //                       textAlign: TextAlign.end,
                        //                     ),
                        //                   ],
                        //                 )
                        //               ],
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //       Visibility(
                        //         visible: commentData.repliesCount>1,
                        //         child: Padding(
                        //           padding: EdgeInsets.fromLTRB(55, 18, 5, 0),
                        //           child: InkWell(
                        //             onTap: ()=> Navigator.of(context).push(MaterialPageRoute(
                        //                 builder: (context) => CampusTalkCommentReply(
                        //                   commentId: commentData.id,
                        //                   commentIndex: index,
                        //                   postId: widget.postId,
                        //                   isBookmarkedPage: widget.isBookmarkedPage,
                        //                   isUserProfile: widget.isUserProfile,
                        //                   postIndex: widget.postIndex,
                        //                 ))),
                        //             child: Text(
                        //               "Show previous replies...",
                        //               style: TextStyle(color: Colors.white, fontSize: 10.9.sp, fontWeight: FontWeight.w600),
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //       commentData.replies.isNotEmpty?
                        //       Padding(
                        //         padding: EdgeInsets.fromLTRB(50, 16, 0, 5),
                        //         child: Row(
                        //           crossAxisAlignment: CrossAxisAlignment.start,
                        //           children: [
                        //             commentData.replies.last.isAnonymous==0
                        //                 ? ClipOval(
                        //               child: Image.network(
                        //                 commentData.replies.last.user.profilePhoto,
                        //                 height: 40,
                        //                 width: 40,
                        //                 fit: BoxFit.cover,
                        //               ),
                        //             ):ClipOval(
                        //               child: Image.asset(
                        //                 "lib/asset/logo.png",
                        //                 height: 40,
                        //                 width: 40,
                        //                 fit: BoxFit.fitWidth,
                        //               ),
                        //             ),
                        //             SizedBox(
                        //               width: 15,
                        //             ),
                        //             Expanded(
                        //               child: Column(
                        //                 crossAxisAlignment: CrossAxisAlignment.start,
                        //                 children: [
                        //                   // Text(commentData.user.displayName,
                        //                   //     style: TextStyle(fontFamily: 'Quicksand', color: MateColors.activeIcons, fontWeight: FontWeight.w500, fontSize: 15)),
                        //                   InkWell(
                        //                     onTap: () {
                        //                       if( commentData.replies.last.isAnonymous==0){
                        //                         if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == commentData.replies.last.user.uuid) {
                        //                           Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                        //                         } else {
                        //                           Navigator.of(context).pushNamed(UserProfileScreen.routeName, arguments: {
                        //                             "id": commentData.replies.last.user.uuid,
                        //                             "name": commentData.replies.last.user.displayName,
                        //                             "photoUrl": commentData.replies.last.user.profilePhoto,
                        //                             "firebaseUid": commentData.replies.last.user.firebaseUid
                        //                           });
                        //                         }
                        //                       }
                        //                     },
                        //                     child: RichText(
                        //                       text: TextSpan(
                        //                         text: commentData.replies.last.isAnonymous==1?"Anonymous": commentData.replies.last.user.displayName,
                        //                         style: TextStyle(fontFamily: 'Quicksand', color: MateColors.activeIcons, fontWeight: FontWeight.w400, fontSize: 13.3.sp),
                        //                         children: <TextSpan>[
                        //                           TextSpan(
                        //                             text: "  ",
                        //                             style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400),
                        //                           ),
                        //                           TextSpan(
                        //                             text: commentData.replies.last.content,
                        //                             style: TextStyle(color: Colors.white, fontSize: 13.0.sp, fontWeight: FontWeight.w400),
                        //                           ),
                        //                         ],
                        //                       ),
                        //                     ),
                        //                   ),
                        //                   commentData.replies.last.url!=null?Padding(
                        //                     padding: const EdgeInsets.only(bottom: 5.0, top: 5),
                        //                     child: InkWell(
                        //                       onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        //                           builder: (context) => CommentFullImage(
                        //                             imageNetworkPath: imageBaseUrl+commentData.replies.last.url,
                        //                           ))),
                        //                       child: ClipRRect(
                        //                         borderRadius: BorderRadius.circular(12.0),
                        //                         clipBehavior: Clip.hardEdge,
                        //                         child: Image.network(
                        //                           imageBaseUrl+commentData.replies.last.url,
                        //                           fit: BoxFit.contain,
                        //                           height: 150,
                        //                           // width: 400,
                        //                         ),
                        //                       ),
                        //                     ),
                        //                   ):SizedBox(height: 10,),
                        //                   Row(
                        //                     mainAxisAlignment: MainAxisAlignment.end,
                        //                     children: [
                        //                       Consumer<CampusTalkProvider>(
                        //                         builder: (context, value, child) {
                        //                           if (value.upVotePostCommentData != null) {
                        //                             if(value.upVotePostCommentData.message == "Liked successfully" && value.upVotePostCommentData.data.commentId == commentData.replies.last.id.toString()){
                        //                               commentData.replies.last.isLiked=IsLiked(commentId: commentData.replies.last.id);
                        //                             }else if(value.upVotePostCommentData.message == "Unliked successfully" && value.upVotePostCommentData.data.commentId == commentData.replies.last.id.toString()){
                        //                               commentData.replies.last.isLiked=null;
                        //                             }
                        //                           }
                        //                           return !commentData.replies.last.upVoteLoader?
                        //                           InkWell(
                        //                               child: Icon(
                        //                                 commentData.replies.last.isLiked!=null ?  Icons.arrow_circle_up_sharp : Icons.arrow_circle_up_sharp,
                        //                                 color: commentData.replies.last.isLiked!=null ? MateColors.activeIcons : Colors.grey[50],
                        //                                 size: 18,
                        //                               ),
                        //                               onTap: () async{
                        //                                 bool likedDone = await Provider.of<CampusTalkProvider>(context, listen: false).upVoteAPostComment(
                        //                                     commentId: commentData.replies.last.id, index: index,
                        //                                     isReply: true, replyIndex: commentData.replies.length-1);
                        //                                 if(likedDone && !(commentData.replies.last.isLiked!=null)) {
                        //                                   ++commentData.replies.last.likesCount;
                        //                                 }else if(likedDone && (commentData.replies.last.isLiked!=null)){
                        //                                   --commentData.replies.last.likesCount;
                        //                                 }
                        //                               }):
                        //                           Padding(
                        //                             padding: const EdgeInsets.only(left: 2, right: 4),
                        //                             child: SizedBox(
                        //                               height: 15,
                        //                               width: 15,
                        //                               child: CircularProgressIndicator(
                        //                                 color: Colors.white,
                        //                                 strokeWidth: 1.2,
                        //                               ),
                        //                             ),
                        //                           );
                        //                         },
                        //                       ),
                        //                       Text(
                        //                         " ${commentData.replies.last.likesCount} ",
                        //                         style: TextStyle(fontFamily: 'Quicksand', color: Colors.grey[50], fontSize: 12.5),
                        //                         overflow: TextOverflow.visible,
                        //                       ),
                        //                       Visibility(
                        //                           visible: Provider.of<AuthUserProvider>(context, listen: false).authUser.id == commentData.replies.last.user.uuid,
                        //                           child: Consumer<CampusTalkProvider>(
                        //                             builder: (context, value, child) {
                        //                               if(commentData.replies.last.isDeleting){
                        //                                 return SizedBox(
                        //                                   height: 14,
                        //                                   width: 14,
                        //                                   child: CircularProgressIndicator(
                        //                                     color: Colors.white,
                        //                                     strokeWidth: 1.2,
                        //                                   ),
                        //                                 );
                        //                               }else{
                        //                                 return InkWell(
                        //                                   onTap: () async{
                        //                                     bool updated = await Provider.of<CampusTalkProvider>(context, listen: false).deleteCommentsOfACampusTalk(commentData.replies.last.id, index,
                        //                                         isReply: true, replyIndex: commentData.replies.length-1);
                        //
                        //                                     if (updated) {
                        //                                       if(widget.isBookmarkedPage){
                        //                                         --Provider.of<CampusTalkProvider>(context, listen: false).campusTalkPostsBookmarkData.data.result[widget.postIndex].commentsCount;
                        //                                       }else if(widget.isUserProfile){
                        //                                         --Provider.of<CampusTalkProvider>(context, listen: false).campusTalkByUserPostsResultsList[widget.postIndex].commentsCount;
                        //                                       }else{
                        //                                         --Provider.of<CampusTalkProvider>(context, listen: false).campusTalkPostsResultsList[widget.postIndex].commentsCount;
                        //                                       }
                        //
                        //                                       Future.delayed(Duration(seconds: 0), () {
                        //                                         Provider.of<CampusTalkProvider>(context, listen: false).fetchCommentsOfACampusTalk(widget.postId);
                        //                                       });
                        //                                     }
                        //                                   },
                        //                                   child: Icon(
                        //                                     Icons.delete_outline,
                        //                                     size: 18,
                        //                                     color: Colors.white70,
                        //                                   ),
                        //                                 );
                        //
                        //                               }
                        //                             },
                        //                           )),
                        //                       SizedBox(
                        //                         width: 8,
                        //                       ),
                        //                       Text(
                        //                         DateFormat.yMMMEd().format(DateFormat("yyyy-MM-dd").parse(commentData.createdAt, true)),
                        //                         style: TextStyle(color: Colors.white70, fontSize: 10.0.sp, fontWeight: FontWeight.w400),
                        //                         textAlign: TextAlign.end,
                        //                       ),
                        //                     ],
                        //                   )
                        //                 ],
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //       ):SizedBox(),
                        //     ],
                        //   ),
                        // );
                      },
                    ),
                  ],
                );
              }
              if (campusTalkProvider.error != '') {
                return Center(
                    child: Container(
                        color: Colors.red,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${campusTalkProvider.error}',
                            style: TextStyle(color: Colors.white),
                          ),
                        )));
              }
              if (campusTalkProvider.fetchCommentsLoader) {
                return timelineLoader();
              }
              return Container();
            },
          ),
        ),
      ],
    );
  }
  ThemeController themeController = Get.find<ThemeController>();
  Widget _messageSendWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Container(
            alignment: Alignment.bottomCenter,
            // width: MediaQuery.of(context).size.width * 0.5,
            margin: EdgeInsets.fromLTRB(16, 25, 16, 5),
            //padding: EdgeInsets.only(left: 15),
            //decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12.0)), color: Colors.transparent, border: Border.all(color: Colors.grey, width: 0.3)),
            child: TextField(
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
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: ImageIcon(
                            AssetImage("lib/asset/icons/incognito_icon.png"),
                            color: isAnonymous ? MateColors.activeIcons : Colors.grey,
                            size: 24,
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                      child: IconButton(
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

                            bool updated = await Provider.of<CampusTalkProvider>(context, listen: false).commentACampusTalk(content:messageEditingController.text.trim().isNotEmpty? messageEditingController.text.trim():""
                                ""
                                "",
                                isAnonymous: isAnonymous?"1":"0",postId:  widget.postId, imageFile: imageFile);

                            if (updated) {
                              if(widget.isBookmarkedPage){
                                ++Provider.of<CampusTalkProvider>(context, listen: false).campusTalkPostsBookmarkData.data.result[widget.postIndex].commentsCount;
                              }else if(widget.isUserProfile){
                                ++Provider.of<CampusTalkProvider>(context, listen: false).campusTalkByUserPostsResultsList[widget.postIndex].commentsCount;
                              }else{
                                ++Provider.of<CampusTalkProvider>(context, listen: false).campusTalkPostsResultsList[widget.postIndex].commentsCount;
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
              // decoration: InputDecoration(
              //     hintText: "Write Comment ...",
              //     hintStyle: TextStyle(
              //       color: Colors.white38,
              //       fontSize: 13.3.sp,
              //     ),
              //     border: InputBorder.none),
            ),
          ),
        ),
        // imageFile != null
        //     ? Stack(
        //   clipBehavior: Clip.none,
        //   children: [
        //     InkWell(
        //       onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => CommentFullImage(imageFilePath: imageFile,),)),
        //       child: Container(
        //           clipBehavior: Clip.hardEdge,
        //           width: 100,
        //           height: 100,
        //           alignment: Alignment.center,
        //           decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), border: Border.all(color: Colors.grey, width: 0.3)),
        //           padding: EdgeInsets.all(5),
        //           margin: EdgeInsets.only(left: 5, bottom: 2),
        //           child: Image.file(
        //             imageFile,
        //             fit: BoxFit.fill,
        //           )),
        //     ),
        //     Positioned(
        //       top: -5,
        //       right: -5,
        //       child: InkWell(
        //         splashColor: Colors.transparent,
        //         highlightColor: Colors.transparent,
        //         onTap: () {
        //           setState(() {
        //             imageFile = null;
        //           });
        //         },
        //         child: SizedBox(
        //           width: 35,
        //           height: 35,
        //           child: Align(
        //             alignment: Alignment.topRight,
        //             child: CircleAvatar(
        //               backgroundColor: myHexColor,
        //               radius: 11,
        //               child: ImageIcon(
        //                 AssetImage("lib/asset/icons/cross.png"),
        //                 size: 22,
        //                 color: Colors.white70,
        //               ),
        //             ),
        //           ),
        //         ),
        //       ),
        //     ),
        //   ],
        // )
        //     : Row(
        //   children: [
        //     Padding(
        //       padding: EdgeInsets.symmetric(horizontal: 8.0),
        //       child: InkWell(
        //         child: new Icon(
        //           Icons.image,
        //           color: Colors.grey,
        //         ),
        //         onTap: () => _getImage(0),
        //       ),
        //     ),
        //     InkWell(
        //       child: new Icon(
        //         Icons.camera_alt,
        //         color: Colors.grey,
        //       ),
        //       onTap: () => _getImage(1),
        //     ),
        //   ],
        // ),
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
        //           suffixIcon: InkWell(
        //               splashColor: Colors.transparent,
        //               highlightColor: Colors.transparent,
        //               onTap: () => setState(() {
        //                 isAnonymous = !isAnonymous;
        //               }),
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
        //   height: 45.0,
        //   width: 45.0,
        //   decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(50.0)), color: Colors.transparent, border: Border.all(color: Colors.grey, width: 0.3)),
        //   child: Center(
        //     child: CircularProgressIndicator(
        //       color: Colors.white,
        //     ),
        //   ),
        // )
        //     : GestureDetector(
        //   onTap: () async {
        //     if (messageEditingController.text.trim().isNotEmpty || imageFile!=null) {
        //       setState(() {
        //         messageSentCheck = true;
        //       });
        //
        //       bool updated = await Provider.of<CampusTalkProvider>(context, listen: false).commentACampusTalk(content:messageEditingController.text.trim().isNotEmpty? messageEditingController.text.trim():""
        //           ""
        //           "",
        //           isAnonymous: isAnonymous?"1":"0",postId:  widget.postId, imageFile: imageFile);
        //
        //       if (updated) {
        //         if(widget.isBookmarkedPage){
        //           ++Provider.of<CampusTalkProvider>(context, listen: false).campusTalkPostsBookmarkData.data.result[widget.postIndex].commentsCount;
        //         }else if(widget.isUserProfile){
        //           ++Provider.of<CampusTalkProvider>(context, listen: false).campusTalkByUserPostsResultsList[widget.postIndex].commentsCount;
        //         }else{
        //           ++Provider.of<CampusTalkProvider>(context, listen: false).campusTalkPostsResultsList[widget.postIndex].commentsCount;
        //         }
        //
        //         messageEditingController.text = "";
        //         imageFile = null;
        //         Future.delayed(Duration(seconds: 0), () {
        //           Provider.of<CampusTalkProvider>(context, listen: false).fetchCommentsOfACampusTalk(widget.postId);
        //         });
        //       }
        //       setState(() {
        //         messageSentCheck = false;
        //       });
        //     }
        //   },
        //   child: Container(
        //     height: 45.0,
        //     width: 45.0,
        //     decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(50.0)), color: Colors.transparent, border: Border.all(color: Colors.grey, width: 0.3)),
        //     child: Center(child: Icon(Icons.send, color: MateColors.activeIcons)),
        //   ),
        // )
      ],
    );
  }

  Future _getImage(int index) async {
    ImagePicker imagePicker = ImagePicker();
    imageFile = index == 0 ? await imagePicker.pickImage(source: ImageSource.gallery) : await imagePicker.pickImage(source: ImageSource.camera);

    if (imageFile != null) {
      setState(() {
        isLoading = true;
      });
      // _uploadFile();
    }
  }
}
