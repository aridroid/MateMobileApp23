import 'package:get/get.dart';
import 'package:mate_app/Providers/AuthUserProvider.dart';
import 'package:mate_app/Providers/FeedProvider.dart';
import 'package:mate_app/Screen/Home/TimeLine/feedCommentsReply.dart';
import 'package:mate_app/Screen/Profile/ProfileScreen.dart';
import 'package:mate_app/Screen/Profile/UserProfileScreen.dart';
import 'package:mate_app/Utility/Utility.dart';
import 'package:mate_app/Widget/Loaders/Shimmer.dart';
import 'package:mate_app/asset/Colors/MateColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../controller/theme_controller.dart';


class FeedComments extends StatefulWidget {
  final int feedIndex;
  final int feedId;

  const FeedComments({Key key, this.feedId, this.feedIndex}) : super(key: key);

  @override
  _CampusLivePostCommentsState createState() => _CampusLivePostCommentsState();
}

class _CampusLivePostCommentsState extends State<FeedComments> {
  ThemeController themeController = Get.find<ThemeController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: FeedCommentsWidget(feedId: widget.feedId,feedIndex: widget.feedIndex,),
    );
  }
}


class FeedCommentsWidget extends StatefulWidget {
  final int feedIndex;
  final int feedId;

  const FeedCommentsWidget({Key key, this.feedIndex, this.feedId}) : super(key: key);

  @override
  _FeedCommentsWidgetState createState() => _FeedCommentsWidgetState();
}

class _FeedCommentsWidgetState extends State<FeedCommentsWidget> {
  TextEditingController messageEditingController = new TextEditingController();

  bool messageSentCheck = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 0), () {
      Provider.of<FeedProvider>(context, listen: false).fetchCommentsOfAFeed(widget.feedId);
    });
  }
  ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _messageSendWidget(),
          Expanded(
            child: SingleChildScrollView(
              child: Consumer<FeedProvider>(
                builder: (context, feedProvider, child) {
                  if (!feedProvider.fetchCommentsLoader && feedProvider.commentFetchData != null) {
                    return ListView.builder(
                      shrinkWrap: true,
                      reverse: true,
                      physics: ScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(16, 10, 16, 16),
                      itemCount: feedProvider.commentFetchData.data.result.length,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: GestureDetector(
                                onTap: (){
                                  if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == feedProvider.commentFetchData.data.result[index].user.uuid) {
                                    Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                                  } else {
                                    Navigator.of(context).pushNamed(UserProfileScreen.routeName, arguments: {
                                      "id": feedProvider.commentFetchData.data.result[index].user.uuid,
                                      "name": feedProvider.commentFetchData.data.result[index].user.displayName,
                                      "photoUrl": feedProvider.commentFetchData.data.result[index].user.profilePhoto,
                                      "firebaseUid": feedProvider.commentFetchData.data.result[index].user.firebaseUid
                                    });
                                  }
                                },
                                child: ListTile(
                                  horizontalTitleGap: 1,
                                  dense: true,
                                  leading: feedProvider.commentFetchData.data.result[index].user.profilePhoto != null?
                                  ClipOval(
                                    child: Image.network(
                                      feedProvider.commentFetchData.data.result[index].user.profilePhoto,
                                      height: 28,
                                      width: 28,
                                      fit: BoxFit.cover,
                                    ),
                                  ):CircleAvatar(
                                    radius: 14,
                                    child: Text(feedProvider.commentFetchData.data.result[index].user.displayName[0]),
                                  ),
                                  title: Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      feedProvider.commentFetchData.data.result[index].content,
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
                                      DateFormat.yMMMEd().format(DateFormat("yyyy-MM-dd").parse(feedProvider.commentFetchData.data.result[index].createdAt, true)),
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
                                        builder: (context) => FeedCommentsReply(
                                          feedIndex: widget.feedIndex,
                                          commentId: feedProvider.commentFetchData.data.result[index].id,
                                          commentIndex: index,
                                          feedId: widget.feedId,
                                        ))),
                                    child: Text("Reply", style: TextStyle(color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor, fontSize: 12.5, fontWeight: FontWeight.w400),),
                                  ),
                                  Text(feedProvider.commentFetchData.data.result[index].replies.isEmpty?"":feedProvider.commentFetchData.data.result[index].replies.length>1?
                                  "   •   ${feedProvider.commentFetchData.data.result[index].replies.length} Replies":
                                  "   •   ${feedProvider.commentFetchData.data.result[index].replies.length} Reply",
                                    style: TextStyle(color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor, fontSize: 12.5, fontWeight: FontWeight.w400),),
                                  Spacer(),
                                  Visibility(
                                      visible: Provider.of<AuthUserProvider>(context, listen: false).authUser.id == feedProvider.commentFetchData.data.result[index].user.uuid,
                                      child: Consumer<FeedProvider>(
                                        builder: (context, value, child) {
                                          if(value.commentFetchData.data.result[index].isDeleting){
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
                                                bool updated = await Provider.of<FeedProvider>(context, listen: false).deleteCommentsOfAFeed(value.commentFetchData.data.result[index].id, index);

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
                              visible: feedProvider.commentFetchData.data.result[index].replies.length>1,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(58, 10, 5, 0),
                                child: InkWell(
                                  onTap: ()=> Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => FeedCommentsReply(
                                        feedIndex: widget.feedIndex,
                                        commentId: feedProvider.commentFetchData.data.result[index].id,
                                        commentIndex: index,
                                        feedId: widget.feedId,
                                      ))),
                                  child: Text(
                                    "Show previous replies...",
                                    style: TextStyle(color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor, fontSize: 13, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                            feedProvider.commentFetchData.data.result[index].replies.isNotEmpty?
                            Padding(
                              padding: EdgeInsets.fromLTRB(40, 0, 0, 5),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == feedProvider.commentFetchData.data.result[index].replies.last.user.uuid) {
                                          Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                                        } else {
                                          Navigator.of(context).pushNamed(UserProfileScreen.routeName, arguments: {
                                            "id": feedProvider.commentFetchData.data.result[index].replies.last.user.uuid,
                                            "name": feedProvider.commentFetchData.data.result[index].replies.last.user.displayName,
                                            "photoUrl": feedProvider.commentFetchData.data.result[index].replies.last.user.profilePhoto,
                                            "firebaseUid": feedProvider.commentFetchData.data.result[index].replies.last.user.firebaseUid
                                          });
                                        }
                                      },
                                      child: ListTile(
                                        horizontalTitleGap: 1,
                                        dense: true,
                                        leading: feedProvider.commentFetchData.data.result[index].replies.last.user.profilePhoto != null ?
                                        ClipOval(
                                          child: Image.network(
                                            feedProvider.commentFetchData.data.result[index].replies.last.user.profilePhoto,
                                            height: 28,
                                            width: 28,
                                            fit: BoxFit.cover,
                                          ),
                                        ):CircleAvatar(
                                          radius: 14,
                                          child: Text(feedProvider.commentFetchData.data.result[index].replies.last.user.displayName[0],),
                                        ),
                                        title: Padding(
                                          padding: const EdgeInsets.only(top: 10),
                                          child: Text(
                                            feedProvider.commentFetchData.data.result[index].replies.last.content,
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
                                            DateFormat.yMMMEd().format(DateFormat("yyyy-MM-dd").parse(feedProvider.commentFetchData.data.result[index].replies.last.createdAt, true)),
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


                            // Column(
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   children: [
                            //     Row(
                            //       crossAxisAlignment: CrossAxisAlignment.start,
                            //       children: [
                            //         feedProvider.commentFetchData.data.result[index].user.profilePhoto != null
                            //             ? CircleAvatar(
                            //           backgroundImage: NetworkImage(
                            //             feedProvider.commentFetchData.data.result[index].user.profilePhoto,
                            //           ),
                            //         )
                            //             : CircleAvatar(
                            //           child: Text(feedProvider.commentFetchData.data.result[index].user.displayName[0]),
                            //         ),
                            //         SizedBox(
                            //           width: 15,
                            //         ),
                            //         Expanded(
                            //           child: Column(
                            //             crossAxisAlignment: CrossAxisAlignment.start,
                            //             children: [
                            //               // Text(feedProvider.commentFetchData.data.result[index].user.displayName,
                            //               //     style: TextStyle(fontFamily: 'Quicksand', color: MateColors.activeIcons, fontWeight: FontWeight.w500, fontSize: 15)),
                            //               InkWell(
                            //                 onTap: () {
                            //                   if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == feedProvider.commentFetchData.data.result[index].user.uuid) {
                            //                     Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                            //                   } else {
                            //                     Navigator.of(context).pushNamed(UserProfileScreen.routeName, arguments: {
                            //                       "id": feedProvider.commentFetchData.data.result[index].user.uuid,
                            //                       "name": feedProvider.commentFetchData.data.result[index].user.displayName,
                            //                       "photoUrl": feedProvider.commentFetchData.data.result[index].user.profilePhoto,
                            //                       "firebaseUid": feedProvider.commentFetchData.data.result[index].user.firebaseUid
                            //                     });
                            //                   }
                            //                 },
                            //                 child: RichText(
                            //                   text: TextSpan(
                            //                     text: feedProvider.commentFetchData.data.result[index].user.displayName,
                            //                     style: TextStyle(fontFamily: 'Quicksand', color: MateColors.activeIcons, fontWeight: FontWeight.w400, fontSize: 16),
                            //                     children: <TextSpan>[
                            //                       TextSpan(
                            //                         text: "  ",
                            //                         style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400),
                            //                       ),
                            //                       TextSpan(
                            //                         text: feedProvider.commentFetchData.data.result[index].content,
                            //                         style: TextStyle(color: Colors.white, fontSize: 15.6, fontWeight: FontWeight.w400),
                            //                       ),
                            //                     ],
                            //                   ),
                            //                 ),
                            //               ),
                            //               SizedBox(
                            //                 height: 15,
                            //               ),
                            //               Row(
                            //                 mainAxisAlignment: MainAxisAlignment.end,
                            //                 children: [
                            //                   InkWell(
                            //                     onTap: ()=> Navigator.of(context).push(MaterialPageRoute(
                            //                         builder: (context) => FeedCommentsReply(
                            //                           feedIndex: widget.indexVal,
                            //                           commentId: feedProvider.commentFetchData.data.result[index].id,
                            //                           commentIndex: index,
                            //                           feedId: widget.feedId,
                            //                         ))),
                            //                     child: Text("Reply", style: TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w400),),
                            //                   ),
                            //                   Text(feedProvider.commentFetchData.data.result[index].replies.isEmpty?"":feedProvider.commentFetchData.data.result[index].replies.length>1?
                            //                   "   •   ${feedProvider.commentFetchData.data.result[index].replies.length} Replies":
                            //                   "   •   ${feedProvider.commentFetchData.data.result[index].replies.length} Reply",
                            //                     style: TextStyle(color: Colors.white70, fontSize: 12.5, fontWeight: FontWeight.w400),),
                            //                   Spacer(),
                            //                   Visibility(
                            //                       visible: Provider.of<AuthUserProvider>(context, listen: false).authUser.id == feedProvider.commentFetchData.data.result[index].user.uuid,
                            //                       child: Consumer<FeedProvider>(
                            //                         builder: (context, value, child) {
                            //                           if(value.commentFetchData.data.result[index].isDeleting){
                            //                             return SizedBox(
                            //                               height: 14,
                            //                               width: 14,
                            //                               child: CircularProgressIndicator(
                            //                                 color: Colors.white,
                            //                                 strokeWidth: 1.2,
                            //                               ),
                            //                             );
                            //                           }else{
                            //                             return InkWell(
                            //                               onTap: () async{
                            //                                 bool updated = await Provider.of<FeedProvider>(context, listen: false).deleteCommentsOfAFeed(value.commentFetchData.data.result[index].id, index);
                            //
                            //                                 if (updated) {
                            //                                   --Provider.of<FeedProvider>(context, listen: false).feedList[widget.indexVal].commentCount;
                            //
                            //                                   Future.delayed(Duration(seconds: 0), () {
                            //                                     Provider.of<FeedProvider>(context, listen: false).fetchCommentsOfAFeed(widget.feedId);
                            //                                   });
                            //                                 }
                            //                               },
                            //                               child: Icon(
                            //                                 Icons.delete_outline,
                            //                                 size: 18,
                            //                                 color: Colors.white70,
                            //                               ),
                            //                             );
                            //
                            //                           }
                            //                         },
                            //                       )),
                            //                   SizedBox(
                            //                     width: 8,
                            //                   ),
                            //                   Text(
                            //                     DateFormat.yMMMEd().format(DateFormat("yyyy-MM-dd").parse(feedProvider.commentFetchData.data.result[index].createdAt, true)),
                            //                     style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w400),
                            //                     textAlign: TextAlign.end,
                            //                   ),
                            //                 ],
                            //               )
                            //             ],
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //     Visibility(
                            //       visible: feedProvider.commentFetchData.data.result[index].replies.length>1,
                            //       child: Padding(
                            //         padding: EdgeInsets.fromLTRB(55, 18, 5, 0),
                            //         child: InkWell(
                            //           onTap: ()=> Navigator.of(context).push(MaterialPageRoute(
                            //               builder: (context) => FeedCommentsReply(
                            //                 feedIndex: widget.indexVal,
                            //                 commentId: feedProvider.commentFetchData.data.result[index].id,
                            //                 commentIndex: index,
                            //                 feedId: widget.feedId,
                            //               ))),
                            //           child: Text(
                            //             "Show previous replies...",
                            //             style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                            //           ),
                            //         ),
                            //       ),
                            //     ),
                            //     feedProvider.commentFetchData.data.result[index].replies.isNotEmpty?
                            //     Padding(
                            //       padding: EdgeInsets.fromLTRB(50, 16, 0, 5),
                            //       child: Row(
                            //         crossAxisAlignment: CrossAxisAlignment.start,
                            //         children: [
                            //           feedProvider.commentFetchData.data.result[index].replies.last.user.profilePhoto != null
                            //               ? CircleAvatar(
                            //             backgroundImage: NetworkImage(
                            //               feedProvider.commentFetchData.data.result[index].replies.last.user.profilePhoto,
                            //             ),
                            //           )
                            //               : CircleAvatar(
                            //             child: Text(
                            //               /*widget.user.displayName[0]*/
                            //               feedProvider.commentFetchData.data.result[index].replies.last.user.displayName[0],
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
                            //                 // Text(feedProvider.commentFetchData.data.result[index].user.displayName,
                            //                 //     style: TextStyle(fontFamily: 'Quicksand', color: MateColors.activeIcons, fontWeight: FontWeight.w500, fontSize: 15)),
                            //                 InkWell(
                            //                   onTap: () {
                            //                     if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == feedProvider.commentFetchData.data.result[index].replies.last.user.uuid) {
                            //                       Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                            //                     } else {
                            //                       Navigator.of(context).pushNamed(UserProfileScreen.routeName, arguments: {
                            //                         "id": feedProvider.commentFetchData.data.result[index].replies.last.user.uuid,
                            //                         "name": feedProvider.commentFetchData.data.result[index].replies.last.user.displayName,
                            //                         "photoUrl": feedProvider.commentFetchData.data.result[index].replies.last.user.profilePhoto,
                            //                         "firebaseUid": feedProvider.commentFetchData.data.result[index].replies.last.user.firebaseUid
                            //                       });
                            //                     }
                            //                   },
                            //                   child: RichText(
                            //                     text: TextSpan(
                            //                       text: feedProvider.commentFetchData.data.result[index].replies.last.user.displayName,
                            //                       style: TextStyle(fontFamily: 'Quicksand', color: MateColors.activeIcons, fontWeight: FontWeight.w400, fontSize: 16),
                            //                       children: <TextSpan>[
                            //                         TextSpan(
                            //                           text: "  ",
                            //                           style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400),
                            //                         ),
                            //                         TextSpan(
                            //                           text: feedProvider.commentFetchData.data.result[index].replies.last.content,
                            //                           style: TextStyle(color: Colors.white, fontSize: 15.6, fontWeight: FontWeight.w400),
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
                            //                         visible: Provider.of<AuthUserProvider>(context, listen: false).authUser.id == feedProvider.commentFetchData.data.result[index].user.uuid,
                            //                         child: Consumer<FeedProvider>(
                            //                           builder: (context, value, child) {
                            //                             if(value.commentFetchData.data.result[index].replies.last.isDeleting){
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
                            //                                   bool updated = await Provider.of<FeedProvider>(context, listen: false).deleteCommentsOfAFeed(value.commentFetchData.data.result[index].replies.last.id, index,
                            //                                       isReply: true, replyIndex: value.commentFetchData.data.result[index].replies.length-1);
                            //
                            //                                   if (updated) {
                            //                                     --Provider.of<FeedProvider>(context, listen: false).feedList[widget.indexVal].commentCount;
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
                            //                       DateFormat.yMMMEd().format(DateFormat("yyyy-MM-dd").parse(feedProvider.commentFetchData.data.result[index].createdAt, true)),
                            //                       style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w400),
                            //                       textAlign: TextAlign.end,
                            //                     ),
                            //                   ],
                            //                 )
                            //               ],
                            //             ),
                            //           ),
                            //         ],
                            //       ),
                            //     ):SizedBox(),
                            //   ],
                            // ),


                          ],
                        );
                      },
                      // separatorBuilder: (context, index) => Divider(
                      //   color: MateColors.line,
                      //   thickness: 2,
                      // ),
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
          ),
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
                      Map<String, dynamic> body = {"content": messageEditingController.text.trim()};
                      bool updated = await Provider.of<FeedProvider>(context, listen: false).commentAFeed(body, widget.feedId);

                      if (updated) {
                        ++Provider.of<FeedProvider>(context, listen: false).feedList[widget.feedIndex].commentCount;
                        messageEditingController.text = "";
                        Future.delayed(Duration(seconds: 0), () {
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
        // GestureDetector(
        //   onTap: () async {
        //     if (messageEditingController.text.trim().isNotEmpty) {
        //       setState(() {
        //         messageSentCheck = true;
        //       });
        //       Map<String, dynamic> body = {
        //         "content": messageEditingController.text.trim(),
        //         "post_id": widget.feedId.toString()
        //       };
        //       bool updated =
        //           await Provider.of<FeedProvider>(context, listen: false)
        //               .commentAFeed(body, widget.feedId);
        //
        //       if (updated) {
        //         messageEditingController.text = "";
        //         Future.delayed(Duration(seconds: 0), () {
        //           Provider.of<FeedProvider>(context, listen: false)
        //               .fetchCommentsOfAFeed(widget.feedId);
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
        //     decoration: BoxDecoration(
        //         borderRadius: BorderRadius.all(Radius.circular(50.0)),
        //         color: Colors.transparent,
        //         border: Border.all(color: Colors.grey, width: 0.3)),
        //     child: messageSentCheck
        //         ? Center(
        //             child: CircularProgressIndicator(
        //               color: Colors.white,
        //             ),
        //           )
        //         : Center(child: Icon(Icons.send, color: MateColors.activeIcons)),
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
        //     if (messageEditingController.text.trim().isNotEmpty) {
        //       setState(() {
        //         messageSentCheck = true;
        //       });
        //       Map<String, dynamic> body = {"content": messageEditingController.text.trim()};
        //       bool updated = await Provider.of<FeedProvider>(context, listen: false).commentAFeed(body, widget.feedId);
        //
        //       if (updated) {
        //         ++Provider.of<FeedProvider>(context, listen: false).feedList[widget.feedIndex].commentCount;
        //         messageEditingController.text = "";
        //         Future.delayed(Duration(seconds: 0), () {
        //           Provider.of<FeedProvider>(context, listen: false).fetchCommentsOfAFeed(widget.feedId);
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
}

