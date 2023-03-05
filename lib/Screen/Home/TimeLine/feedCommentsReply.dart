import 'package:get/get.dart';
import 'package:mate_app/Model/feedsCommentFetchModel.dart';
import 'package:mate_app/Providers/AuthUserProvider.dart';
import 'package:mate_app/Providers/FeedProvider.dart';
import 'package:mate_app/Screen/Profile/ProfileScreen.dart';
import 'package:mate_app/Screen/Profile/UserProfileScreen.dart';
import 'package:mate_app/Widget/Loaders/Shimmer.dart';
import 'package:mate_app/asset/Colors/MateColors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mate_app/controller/theme_controller.dart';
import 'package:provider/provider.dart';

import '../../../constant.dart';

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
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scH = MediaQuery.of(context).size.height;
    final scW = MediaQuery.of(context).size.width;
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
        body: Container(
          height: scH,
          width: scW,
          decoration: BoxDecoration(
            color: themeController.isDarkMode?Color(0xFF000000):Colors.white,
            image: DecorationImage(
              image: AssetImage(themeController.isDarkMode?'lib/asset/Background.png':'lib/asset/BackgroundLight.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height*0.07,
                  left: 16,
                  right: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Get.back();
                      },
                      child: Icon(Icons.arrow_back_ios,
                        size: 20,
                        color: themeController.isDarkMode ? Colors.white : MateColors.blackTextColor,
                      ),
                    ),
                    Text(
                      "Reply",
                      style: TextStyle(
                        color: themeController.isDarkMode ? Colors.white : MateColors.blackTextColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 17.0,
                      ),
                    ),
                    SizedBox(),
                  ],
                ),
              ),
              Expanded(
                child:  Consumer<FeedProvider>(
                  builder: (context, feedProvider, child) {
                    if (!feedProvider.fetchCommentsLoader && feedProvider.commentFetchData != null) {
                      Result result=feedProvider.commentFetchData.data.result[widget.commentIndex];
                      return ListView(
                        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                        children: [
                          Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(0.0), border: Border.all(color: themeController.isDarkMode?MateColors.dividerDark:MateColors.dividerLight, width: 1)),
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
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w400,
                                            letterSpacing: 0.1,
                                            color: themeController.isDarkMode?Colors.white:Colors.black,
                                          ),
                                        ),
                                      ),
                                      subtitle: Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Text(
                                          DateFormat.yMMMEd().format(DateFormat("yyyy-MM-dd").parse(result.createdAt, true)),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: themeController.isDarkMode?MateColors.helpingTextDark:Colors.black.withOpacity(0.72),
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
                                        child: Text("Reply",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w400,
                                            letterSpacing: 0.1,
                                            color: themeController.isDarkMode?Colors.white:Colors.black,
                                          ),
                                        ),
                                      ),
                                      Text(result.replies.isEmpty?"":result.replies.length>1?
                                      "   •   ${result.replies.length} Replies":
                                      "   •   ${result.replies.length} Reply",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w400,
                                          letterSpacing: 0.1,
                                          color: themeController.isDarkMode?Colors.white:Colors.black,
                                        ),
                                      ),
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
                                                      fontWeight: FontWeight.w400,
                                                      letterSpacing: 0.1,
                                                      fontFamily: 'Poppins',
                                                      color: themeController.isDarkMode?Colors.white:Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                subtitle: Padding(
                                                  padding: const EdgeInsets.only(top: 5),
                                                  child: Text(
                                                    DateFormat.yMMMEd().format(DateFormat("yyyy-MM-dd").parse(result.createdAt, true)),
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: themeController.isDarkMode?MateColors.helpingTextDark:Colors.black.withOpacity(0.72),
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
                                                              color: themeController.isDarkMode?Colors.white:Colors.black,
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
        ),
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
              cursorColor: themeController.isDarkMode?MateColors.helpingTextDark:MateColors.helpingTextLight,
              style:  TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.1,
                color: themeController.isDarkMode?Colors.white:Colors.black,
              ),
              textInputAction: TextInputAction.done,
              minLines: 1,
              maxLines: 4,
              decoration: InputDecoration(
                hintStyle: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  color: themeController.isDarkMode?MateColors.helpingTextDark:MateColors.helpingTextLight,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.send,
                    size: 20,
                    color: themeController.isDarkMode?MateColors.helpingTextDark:MateColors.helpingTextLight,
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
                fillColor: themeController.isDarkMode ? MateColors.containerDark : MateColors.containerLight,
                filled: true,
                focusedBorder: commonBorderCircular,
                enabledBorder: commonBorderCircular,
                disabledBorder: commonBorderCircular,
                errorBorder: commonBorderCircular,
                focusedErrorBorder: commonBorderCircular,
              ),
            ),
          ),
        ),
      ],
    );
  }

}
