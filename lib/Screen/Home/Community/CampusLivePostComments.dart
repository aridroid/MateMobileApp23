import 'package:mate_app/Providers/AuthUserProvider.dart';
import 'package:mate_app/Providers/campusLiveProvider.dart';
import 'package:mate_app/Screen/Home/Community/campusLivePostCommentReply.dart';
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

class CampusLivePostComments extends StatefulWidget {
  final int postIndex;
  final int postId;

  const CampusLivePostComments({Key key, this.postId, this.postIndex}) : super(key: key);

  @override
  _CampusLivePostCommentsState createState() => _CampusLivePostCommentsState();
}

class _CampusLivePostCommentsState extends State<CampusLivePostComments> {
  TextEditingController messageEditingController = new TextEditingController();
  bool messageSentCheck = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 0), () {
      Provider.of<CampusLiveProvider>(context, listen: false).fetchCommentsOfAPost(widget.postId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myHexColor,
      appBar: AppBar(
        elevation: 0,
        title: Text('Comments'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(2),
          child: Container(
            color: MateColors.line,
            height: 2.0,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<CampusLiveProvider>(
              builder: (context, campusLiveProvider, child) {
                if (!campusLiveProvider.fetchCommentsLoader && campusLiveProvider.commentFetchData != null) {
                  return ListView(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        reverse: true,
                        physics: ScrollPhysics(),
                        // padding: EdgeInsets.fromLTRB(16, 10, 16, 5),
                        itemCount: campusLiveProvider.commentFetchData.data.result.length,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(0.0), border: Border.all(color: MateColors.line, width: 1)),
                            padding: EdgeInsets.fromLTRB(16, 15, 16, 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    campusLiveProvider.commentFetchData.data.result[index].user.profilePhoto != null
                                        ? CircleAvatar(
                                          backgroundImage: NetworkImage(
                                            campusLiveProvider.commentFetchData.data.result[index].user.profilePhoto,
                                          ),
                                        )
                                        : CircleAvatar(
                                          child: Text(
                                            /*widget.user.displayName[0]*/
                                            campusLiveProvider.commentFetchData.data.result[index].user.displayName[0],
                                            style: TextStyle(
                                              color: Color(0xff75f3e7),
                                              fontSize: 23,
                                              fontFamily: "Quicksand",
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Text(campusLiveProvider.commentFetchData.data.result[index].user.displayName,
                                          //     style: TextStyle(fontFamily: 'Quicksand', color: MateColors.activeIcons, fontWeight: FontWeight.w500, fontSize: 15)),
                                          InkWell(
                                            onTap: () {
                                              if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == campusLiveProvider.commentFetchData.data.result[index].user.uuid) {
                                                Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                                              } else {
                                                Navigator.of(context).pushNamed(UserProfileScreen.routeName, arguments: {
                                                  "id": campusLiveProvider.commentFetchData.data.result[index].user.uuid,
                                                  "name": campusLiveProvider.commentFetchData.data.result[index].user.displayName,
                                                  "photoUrl": campusLiveProvider.commentFetchData.data.result[index].user.profilePhoto,
                                                  "firebaseUid": campusLiveProvider.commentFetchData.data.result[index].user.firebaseUid
                                                });
                                              }
                                            },
                                            child: RichText(
                                              text: TextSpan(
                                                text: campusLiveProvider.commentFetchData.data.result[index].user.displayName,
                                                style: TextStyle(fontFamily: 'Quicksand', color: MateColors.activeIcons, fontWeight: FontWeight.w400, fontSize: 13.3.sp),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text: "  ",
                                                    style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400),
                                                  ),
                                                  TextSpan(
                                                    text: campusLiveProvider.commentFetchData.data.result[index].content,
                                                    style: TextStyle(color: Colors.white, fontSize: 13.0.sp, fontWeight: FontWeight.w400),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              InkWell(
                                                onTap: ()=> Navigator.of(context).push(MaterialPageRoute(
                                                    builder: (context) => CampusLivePostCommentReply(
                                                      postIndex: widget.postIndex,
                                                      commentId: campusLiveProvider.commentFetchData.data.result[index].id,
                                                      commentIndex: index,
                                                      postId: widget.postId,
                                                    ))),
                                                child: Text("Reply", style: TextStyle(color: Colors.white, fontSize: 10.5.sp, fontWeight: FontWeight.w400),),
                                              ),
                                              Text(campusLiveProvider.commentFetchData.data.result[index].replies.isEmpty?"":campusLiveProvider.commentFetchData.data.result[index].replies.length>1?
                                              "   •   ${campusLiveProvider.commentFetchData.data.result[index].replies.length} Replies":
                                              "   •   ${campusLiveProvider.commentFetchData.data.result[index].replies.length} Reply",
                                                style: TextStyle(color: Colors.white70, fontSize: 10.5.sp, fontWeight: FontWeight.w400),),
                                              Spacer(),
                                              Visibility(
                                                  visible: Provider.of<AuthUserProvider>(context, listen: false).authUser.id == campusLiveProvider.commentFetchData.data.result[index].user.uuid,
                                                  child: Consumer<CampusLiveProvider>(
                                                    builder: (context, value, child) {
                                                      if(value.commentFetchData.data.result[index].isDeleting){
                                                       return SizedBox(
                                                         height: 14,
                                                         width: 14,
                                                         child: CircularProgressIndicator(
                                                           color: Colors.white,
                                                           strokeWidth: 1.2,
                                                         ),
                                                       );
                                                      }else{
                                                        return InkWell(
                                                          onTap: () async{
                                                            bool updated = await Provider.of<CampusLiveProvider>(context, listen: false).deleteCommentsOfAPost(value.commentFetchData.data.result[index].id, index);
                                                            --Provider.of<CampusLiveProvider>(context, listen: false).campusLivePostsModelData.data.result[widget.postIndex].commentsCount;
                                                            if (updated) {
                                                              Future.delayed(Duration(seconds: 0), () {
                                                                Provider.of<CampusLiveProvider>(context, listen: false).fetchCommentsOfAPost(widget.postId);
                                                              });
                                                            }
                                                          },
                                                          child: Icon(
                                                            Icons.delete_outline,
                                                            size: 18,
                                                            color: Colors.white70,
                                                          ),
                                                        );

                                                      }
                                                    },
                                                  )),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Text(
                                                DateFormat.yMMMEd().format(DateFormat("yyyy-MM-dd").parse(campusLiveProvider.commentFetchData.data.result[index].createdAt, true)),
                                                style: TextStyle(color: Colors.white70, fontSize: 10.0.sp, fontWeight: FontWeight.w400),
                                                textAlign: TextAlign.end,
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Visibility(
                                  visible: campusLiveProvider.commentFetchData.data.result[index].replies.length>1,
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(55, 18, 5, 0),
                                    child: InkWell(
                                      onTap: ()=> Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => CampusLivePostCommentReply(
                                            postIndex: widget.postIndex,
                                            commentId: campusLiveProvider.commentFetchData.data.result[index].id,
                                            commentIndex: index,
                                            postId: widget.postId,
                                          ))),
                                      child: Text(
                                        "Show previous replies...",
                                        style: TextStyle(color: Colors.white, fontSize: 10.9.sp, fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ),
                                campusLiveProvider.commentFetchData.data.result[index].replies.isNotEmpty?
                                Padding(
                                  padding: EdgeInsets.fromLTRB(50, 16, 0, 5),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      campusLiveProvider.commentFetchData.data.result[index].replies.last.user.profilePhoto != null
                                          ? CircleAvatar(
                                            backgroundImage: NetworkImage(
                                              campusLiveProvider.commentFetchData.data.result[index].replies.last.user.profilePhoto,
                                            ),
                                          )
                                          : CircleAvatar(
                                            child: Text(
                                              /*widget.user.displayName[0]*/
                                              campusLiveProvider.commentFetchData.data.result[index].replies.last.user.displayName[0],
                                              style: TextStyle(
                                                color: Color(0xff75f3e7),
                                                fontSize: 23,
                                                fontFamily: "Quicksand",
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // Text(campusLiveProvider.commentFetchData.data.result[index].user.displayName,
                                            //     style: TextStyle(fontFamily: 'Quicksand', color: MateColors.activeIcons, fontWeight: FontWeight.w500, fontSize: 15)),
                                            InkWell(
                                              onTap: () {
                                                if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == campusLiveProvider.commentFetchData.data.result[index].replies.last.user.uuid) {
                                                  Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                                                } else {
                                                  Navigator.of(context).pushNamed(UserProfileScreen.routeName, arguments: {
                                                    "id": campusLiveProvider.commentFetchData.data.result[index].replies.last.user.uuid,
                                                    "name": campusLiveProvider.commentFetchData.data.result[index].replies.last.user.displayName,
                                                    "photoUrl": campusLiveProvider.commentFetchData.data.result[index].replies.last.user.profilePhoto,
                                                    "firebaseUid": campusLiveProvider.commentFetchData.data.result[index].replies.last.user.firebaseUid
                                                  });
                                                }
                                              },
                                              child: RichText(
                                                text: TextSpan(
                                                  text: campusLiveProvider.commentFetchData.data.result[index].replies.last.user.displayName,
                                                  style: TextStyle(fontFamily: 'Quicksand', color: MateColors.activeIcons, fontWeight: FontWeight.w400, fontSize: 13.3.sp),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text: "  ",
                                                      style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400),
                                                    ),
                                                    TextSpan(
                                                      text: campusLiveProvider.commentFetchData.data.result[index].replies.last.content,
                                                      style: TextStyle(color: Colors.white, fontSize: 13.0.sp, fontWeight: FontWeight.w400),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Visibility(
                                                    visible: Provider.of<AuthUserProvider>(context, listen: false).authUser.id == campusLiveProvider.commentFetchData.data.result[index].replies.last.user.uuid,
                                                    child: Consumer<CampusLiveProvider>(
                                                      builder: (context, value, child) {
                                                        if(value.commentFetchData.data.result[index].replies.last.isDeleting){
                                                          return SizedBox(
                                                            height: 14,
                                                            width: 14,
                                                            child: CircularProgressIndicator(
                                                              color: Colors.white,
                                                              strokeWidth: 1.2,
                                                            ),
                                                          );
                                                        }else{
                                                          return InkWell(
                                                            onTap: () async{
                                                              bool updated = await Provider.of<CampusLiveProvider>(context, listen: false).deleteCommentsOfAPost(value.commentFetchData.data.result[index].replies.last.id, index,
                                                                  isReply: true, replyIndex: value.commentFetchData.data.result[index].replies.length-1);

                                                              if (updated) {
                                                                --Provider.of<CampusLiveProvider>(context, listen: false).campusLivePostsModelData.data.result[widget.postIndex].commentsCount;
                                                                Future.delayed(Duration(seconds: 0), () {
                                                                  Provider.of<CampusLiveProvider>(context, listen: false).fetchCommentsOfAPost(widget.postId);
                                                                });
                                                              }
                                                            },
                                                            child: Icon(
                                                              Icons.delete_outline,
                                                              size: 18,
                                                              color: Colors.white70,
                                                            ),
                                                          );

                                                        }
                                                      },
                                                    )),
                                                SizedBox(
                                                  width: 8,
                                                ),
                                                Text(
                                                  DateFormat.yMMMEd().format(DateFormat("yyyy-MM-dd").parse(campusLiveProvider.commentFetchData.data.result[index].createdAt, true)),
                                                  style: TextStyle(color: Colors.white70, fontSize: 10.0.sp, fontWeight: FontWeight.w400),
                                                  textAlign: TextAlign.end,
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ):SizedBox(),
                              ],
                            ),
                          );
                        },
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
        Expanded(
          child: Container(
            alignment: Alignment.bottomCenter,
            // width: MediaQuery.of(context).size.width * 0.5,
            margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
            padding: EdgeInsets.only(left: 15),
            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12.0)), color: Colors.transparent, border: Border.all(color: Colors.grey, width: 0.3)),
            child: TextField(
              controller: messageEditingController,
              cursorColor: Colors.cyanAccent,
              style: TextStyle(color: Colors.white),
              textInputAction: TextInputAction.done,
              minLines: 1,
              maxLines: 4,
              decoration: InputDecoration(
                  hintText: "Write Comment ...",
                  hintStyle: TextStyle(
                    color: Colors.white38,
                    fontSize: 13.3.sp,
                  ),
                  border: InputBorder.none),
            ),
          ),
        ),
        messageSentCheck
            ? Container(
                height: 45.0,
                width: 45.0,
                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(50.0)), color: Colors.transparent, border: Border.all(color: Colors.grey, width: 0.3)),
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              )
            : GestureDetector(
                onTap: () async {
                  if (messageEditingController.text.trim().isNotEmpty) {
                    setState(() {
                      messageSentCheck = true;
                    });
                    Map<String, dynamic> body = {"content": messageEditingController.text.trim(), "post_id": widget.postId.toString()};
                    bool updated = await Provider.of<CampusLiveProvider>(context, listen: false).commentAPost(body, widget.postId);

                    if (updated) {
                      ++Provider.of<CampusLiveProvider>(context, listen: false).campusLivePostsModelData.data.result[widget.postIndex].commentsCount;
                      Future.delayed(Duration(seconds: 0), () {
                        messageEditingController.text = "";
                        Provider.of<CampusLiveProvider>(context, listen: false).fetchCommentsOfAPost(widget.postId);
                      });
                    }
                    setState(() {
                      messageSentCheck = false;
                    });
                  }
                },
                child: Container(
                  height: 45.0,
                  width: 45.0,
                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(50.0)), color: Colors.transparent, border: Border.all(color: Colors.grey, width: 0.3)),
                  child: Center(child: Icon(Icons.send, color: MateColors.activeIcons)),
                ),
              )
      ],
    );
  }
}
