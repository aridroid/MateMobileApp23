import 'package:get/get.dart';
import 'package:mate_app/Model/feedsCommentFetchModel.dart';
import 'package:mate_app/Providers/AuthUserProvider.dart';
import 'package:mate_app/Providers/FeedProvider.dart';
import 'package:mate_app/Screen/Profile/ProfileScreen.dart';
import 'package:mate_app/Screen/Profile/UserProfileScreen.dart';
import 'package:mate_app/Utility/Utility.dart';
import 'package:mate_app/Widget/Loaders/Shimmer.dart';
import 'package:mate_app/asset/Colors/MateColors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mate_app/controller/theme_controller.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class FeedCommentsReply extends StatefulWidget {

  final int commentId;
  final int commentIndex;
  final int feedIndex;
  final int feedId;

  const FeedCommentsReply({Key key, this.commentId, this.commentIndex, this.feedIndex, this.feedId}) : super(key: key);

  @override
  _FeedCommentsReplyState createState() => _FeedCommentsReplyState();
}

class _FeedCommentsReplyState extends State<FeedCommentsReply> {

  FocusNode focusNode= FocusNode();
  TextEditingController messageEditingController = new TextEditingController();
  bool messageSentCheck = false;
  ThemeController themeController = Get.find<ThemeController>();

  @override
  void initState() {
    Future.delayed(Duration(seconds: 0), () {
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
          Expanded(
            child:  Consumer<FeedProvider>(
              builder: (context, feedProvider, child) {
                if (!feedProvider.fetchCommentsLoader && feedProvider.commentFetchData != null) {
                  Result result=feedProvider.commentFetchData.data.result[widget.commentIndex];
                  return ListView(
                    children: [
                      Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(0.0), border: Border.all(color: themeController.isDarkMode?MateColors.darkDivider:MateColors.lightDivider, width: 1)),
                        padding: EdgeInsets.fromLTRB(16, 15, 16, 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Row(
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   children: [
                            //     result.user.profilePhoto != null ? CircleAvatar(
                            //       backgroundImage: NetworkImage(
                            //         result.user.profilePhoto,
                            //       ),
                            //     ):
                            //     CircleAvatar(
                            //       child: Text(
                            //         /*widget.user.displayName[0]*/
                            //         result.user.displayName[0],
                            //         style: TextStyle(
                            //           color: Color(0xff75f3e7),
                            //           fontSize: 23,
                            //           fontFamily: "Quicksand",
                            //           fontWeight: FontWeight.w500,
                            //         ),
                            //       ),
                            //     ),
                            //     SizedBox(
                            //       width: 15,
                            //     ),
                            //     Expanded(
                            //       child: Column(
                            //         crossAxisAlignment: CrossAxisAlignment.start,
                            //         children: [
                            //           // Text(result[index].user.displayName,
                            //           //     style: TextStyle(fontFamily: 'Quicksand', color: MateColors.activeIcons, fontWeight: FontWeight.w500, fontSize: 15)),
                            //           InkWell(
                            //             onTap: () {
                            //               if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == result.user.uuid) {
                            //                 Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                            //               } else {
                            //                 Navigator.of(context).pushNamed(UserProfileScreen.routeName, arguments: {
                            //                   "id": result.user.uuid,
                            //                   "name": result.user.displayName,
                            //                   "photoUrl": result.user.profilePhoto,
                            //                   "firebaseUid": result.user.firebaseUid
                            //                 });
                            //               }
                            //             },
                            //             child: RichText(
                            //               text: TextSpan(
                            //                 text: result.user.displayName,
                            //                 style: TextStyle(fontFamily: 'Quicksand', color: MateColors.activeIcons, fontWeight: FontWeight.w400, fontSize: 13.3.sp),
                            //                 children: <TextSpan>[
                            //                   TextSpan(
                            //                     text: "  ",
                            //                     style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400),
                            //                   ),
                            //                   TextSpan(
                            //                     text: result.content,
                            //                     style: TextStyle(color: Colors.white, fontSize: 13.0.sp, fontWeight: FontWeight.w400),
                            //                   ),
                            //                 ],
                            //               ),
                            //             ),
                            //           ),
                            //           SizedBox(
                            //             height: 15,
                            //           ),
                            //           Row(
                            //             mainAxisAlignment: MainAxisAlignment.end,
                            //             children: [
                            //               InkWell(
                            //                 onTap: ()=> focusNode.requestFocus(),
                            //                 child: Text("Reply", style: TextStyle(color: Colors.white, fontSize: 10.5.sp, fontWeight: FontWeight.w400),),
                            //               ),
                            //               Text(result.replies.isEmpty?"":result.replies.length>1?
                            //               "   •   ${result.replies.length} Replies":
                            //               "   •   ${result.replies.length} Reply",
                            //                 style: TextStyle(color: Colors.white70, fontSize: 10.5.sp, fontWeight: FontWeight.w400),),
                            //               Spacer(),
                            //               SizedBox(
                            //                 width: 8,
                            //               ),
                            //               Text(
                            //                 DateFormat.yMMMEd().format(DateFormat("yyyy-MM-dd").parse(result.createdAt, true)),
                            //                 style: TextStyle(color: Colors.white70, fontSize: 10.0.sp, fontWeight: FontWeight.w400),
                            //                 textAlign: TextAlign.end,
                            //               ),
                            //             ],
                            //           )
                            //         ],
                            //       ),
                            //     ),
                            //   ],
                            // ),

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
                                          },
                                          child: ListTile(
                                            horizontalTitleGap: 1,
                                            dense: true,
                                            leading: result.replies[index].user.profilePhoto != null?
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
                                                child: Consumer<FeedProvider>(
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
                                                        onTap: () async{
                                                          bool updated = await Provider.of<FeedProvider>(context, listen: false).deleteCommentsOfAFeed(value.commentFetchData.data.result[widget.commentIndex].replies[index].id, widget.commentIndex,
                                                              isReply: true, replyIndex: index);

                                                          if (updated) {
                                                            --Provider.of<FeedProvider>(context, listen: false).feedList[widget.feedIndex].commentCount;
                                                            Future.delayed(Duration(seconds: 0), () {
                                                              Provider.of<FeedProvider>(context, listen: false).fetchCommentsOfAFeed(widget.feedId);
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





                                //   Padding(
                                //   padding: EdgeInsets.fromLTRB(50, 16, 0, 5),
                                //   child: Column(
                                //     children: [
                                //       Row(
                                //         crossAxisAlignment: CrossAxisAlignment.start,
                                //         children: [
                                //           result.replies[index].user.profilePhoto != null ? CircleAvatar(
                                //             backgroundImage: NetworkImage(
                                //               result.replies[index].user.profilePhoto,
                                //             ),
                                //           )
                                //               : CircleAvatar(
                                //             child: Text(
                                //               /*widget.user.displayName[0]*/
                                //               result.replies[index].user.displayName[0],
                                //               style: TextStyle(
                                //                 color: Color(0xff75f3e7),
                                //                 fontSize: 23,
                                //                 fontFamily: "Quicksand",
                                //                 fontWeight: FontWeight.w500,
                                //               ),
                                //             ),
                                //           ),
                                //           SizedBox(
                                //             width: 15,
                                //           ),
                                //           Expanded(
                                //             child: Column(
                                //               crossAxisAlignment: CrossAxisAlignment.start,
                                //               children: [
                                //                 // Text(result.user.displayName,
                                //                 //     style: TextStyle(fontFamily: 'Quicksand', color: MateColors.activeIcons, fontWeight: FontWeight.w500, fontSize: 15)),
                                //                 InkWell(
                                //                   onTap: () {
                                //                     if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == result.replies[index].user.uuid) {
                                //                       Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                                //                     } else {
                                //                       Navigator.of(context).pushNamed(UserProfileScreen.routeName, arguments: {
                                //                         "id": result.replies[index].user.uuid,
                                //                         "name": result.replies[index].user.displayName,
                                //                         "photoUrl": result.replies[index].user.profilePhoto,
                                //                         "firebaseUid": result.replies[index].user.firebaseUid
                                //                       });
                                //                     }
                                //                   },
                                //                   child: RichText(
                                //                     text: TextSpan(
                                //                       text: result.replies[index].user.displayName,
                                //                       style: TextStyle(fontFamily: 'Quicksand', color: MateColors.activeIcons, fontWeight: FontWeight.w400, fontSize: 13.3.sp),
                                //                       children: <TextSpan>[
                                //                         TextSpan(
                                //                           text: "  ",
                                //                           style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400),
                                //                         ),
                                //                         TextSpan(
                                //                           text: result.replies[index].content,
                                //                           style: TextStyle(color: Colors.white, fontSize: 13.0.sp, fontWeight: FontWeight.w400),
                                //                         ),
                                //                       ],
                                //                     ),
                                //                   ),
                                //                 ),
                                //                 SizedBox(
                                //                   height: 10,
                                //                 ),
                                //                 Row(
                                //                   mainAxisAlignment: MainAxisAlignment.end,
                                //                   children: [
                                //                     Visibility(
                                //                         visible: Provider.of<AuthUserProvider>(context, listen: false).authUser.id == result.replies[index].user.uuid,
                                //                         child: Consumer<FeedProvider>(
                                //                           builder: (context, value, child) {
                                //                             if(value.commentFetchData.data.result[widget.commentIndex].replies[index].isDeleting){
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
                                //                                   bool updated = await Provider.of<FeedProvider>(context, listen: false).deleteCommentsOfAFeed(value.commentFetchData.data.result[widget.commentIndex].replies[index].id, widget.commentIndex,
                                //                                       isReply: true, replyIndex: index);
                                //
                                //                                   if (updated) {
                                //                                     --Provider.of<FeedProvider>(context, listen: false).feedList[widget.feedIndex].commentCount;
                                //                                     Future.delayed(Duration(seconds: 0), () {
                                //                                       Provider.of<FeedProvider>(context, listen: false).fetchCommentsOfAFeed(widget.feedId);
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
                                //                       DateFormat.yMMMEd().format(DateFormat("yyyy-MM-dd").parse(result.createdAt, true)),
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
                                //     ],
                                //   ),
                                // );
                              },
                            ):SizedBox(),
                          ],
                        ),
                      ),
                    ],
                  );
                }
                if (feedProvider.error != '') {
                  return Center(
                      child: Container(
                          color: Colors.red,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '${feedProvider.error}',
                              style: TextStyle(color: Colors.white),
                            ),
                          )));
                }
                if (feedProvider.fetchCommentsLoader) {
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
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.send,
                    size: 20,
                    color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
                  ),
                  onPressed: ()async {
                    if (messageEditingController.text.trim().isNotEmpty) {
                      setState(() {
                        messageSentCheck = true;
                      });
                      Map<String, dynamic> body = {"parent_id":widget.commentId ,"content": messageEditingController.text.trim()};
                      bool updated = await Provider.of<FeedProvider>(context, listen: false).commentAFeed(body, widget.feedId);

                      if (updated) {
                        ++Provider.of<FeedProvider>(context, listen: false).feedList[widget.feedIndex].commentCount;
                        Future.delayed(Duration(seconds: 0), () {
                          messageEditingController.text = "";
                          Provider.of<FeedProvider>(context, listen: false).fetchCommentsOfAFeed(widget.feedId);
                        });
                      }
                      setState(() {
                        messageSentCheck = false;
                      });
                    }
                  },
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
    //   Row(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   mainAxisSize: MainAxisSize.min,
    //   children: [
    //     Expanded(
    //       child: Container(
    //         alignment: Alignment.bottomCenter,
    //         // width: MediaQuery.of(context).size.width * 0.5,
    //         margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
    //         padding: EdgeInsets.only(left: 15),
    //         decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12.0)), color: Colors.transparent, border: Border.all(color: Colors.grey, width: 0.3)),
    //         child: TextField(
    //           focusNode: focusNode,
    //           controller: messageEditingController,
    //           cursorColor: Colors.cyanAccent,
    //           style: TextStyle(color: Colors.white),
    //           textInputAction: TextInputAction.done,
    //           minLines: 1,
    //           maxLines: 4,
    //           decoration: InputDecoration(
    //               hintText: "Write Comment ...",
    //               hintStyle: TextStyle(
    //                 color: Colors.white38,
    //                 fontSize: 13.3.sp,
    //               ),
    //               border: InputBorder.none),
    //         ),
    //       ),
    //     ),
    //     messageSentCheck ? Container(
    //       height: 45.0,
    //       width: 45.0,
    //       decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(50.0)), color: Colors.transparent, border: Border.all(color: Colors.grey, width: 0.3)),
    //       child: Center(
    //         child: CircularProgressIndicator(
    //           color: Colors.white,
    //         ),
    //       ),
    //     )
    //         : GestureDetector(
    //       onTap: () async {
    //         if (messageEditingController.text.trim().isNotEmpty) {
    //           setState(() {
    //             messageSentCheck = true;
    //           });
    //           Map<String, dynamic> body = {"parent_id":widget.commentId ,"content": messageEditingController.text.trim()};
    //           bool updated = await Provider.of<FeedProvider>(context, listen: false).commentAFeed(body, widget.feedId);
    //
    //           if (updated) {
    //             ++Provider.of<FeedProvider>(context, listen: false).feedList[widget.feedIndex].commentCount;
    //             Future.delayed(Duration(seconds: 0), () {
    //               messageEditingController.text = "";
    //               Provider.of<FeedProvider>(context, listen: false).fetchCommentsOfAFeed(widget.feedId);
    //             });
    //           }
    //           setState(() {
    //             messageSentCheck = false;
    //           });
    //         }
    //       },
    //       child: Container(
    //         height: 45.0,
    //         width: 45.0,
    //         decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(50.0)), color: Colors.transparent, border: Border.all(color: Colors.grey, width: 0.3)),
    //         child: Center(child: Icon(Icons.send, color: MateColors.activeIcons)),
    //       ),
    //     )
    //   ],
    // );
  }
}
