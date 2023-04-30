import 'package:get/get.dart';
import 'package:mate_app/Model/campusTalkCommentFetchModel.dart';
import 'package:mate_app/Providers/AuthUserProvider.dart';
import 'package:mate_app/Providers/campusTalkProvider.dart';
import 'package:mate_app/Screen/Home/Community/campusTalkCommentReply.dart';
import 'package:mate_app/Screen/Profile/ProfileScreen.dart';
import 'package:mate_app/Screen/Profile/UserProfileScreen.dart';
import 'package:mate_app/Widget/Loaders/Shimmer.dart';
import 'package:mate_app/asset/Colors/MateColors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../constant.dart';
import '../../../controller/theme_controller.dart';
import 'package:mate_app/Model/campusTalkPostsModel.dart' as postModel;

class CampusTalkComments extends StatefulWidget {
  final bool isBookmarkedPage;
  final bool isUserProfile;
  final int postIndex;
  final int postId;
  final bool isTrending;
  final bool isLatest;
  final bool isForums;
  final bool isYourCampus;
  final bool isListCard;
  final bool isSearch;
  final postModel.User user;
  const CampusTalkComments({Key key,
    this.isTrending = false,
    this.isLatest = false,
    this.isForums = false,
    this.isYourCampus = false,
    this.isListCard = false,
    this.isSearch = false,
    this.user,
    this.postId, this.postIndex, this.isBookmarkedPage=false, this.isUserProfile=false}) : super(key: key);

  @override
  _CampusTalkCommentsState createState() => _CampusTalkCommentsState();
}

class _CampusTalkCommentsState extends State<CampusTalkComments> {
  ThemeController themeController = Get.find<ThemeController>();
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
                      "Comments",
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
                child: CampusTalkCommentsWidget(
                  isUserProfile: widget.isUserProfile,
                  isBookmarkedPage: widget.isBookmarkedPage,
                  postId: widget.postId,
                  postIndex: widget.postIndex,
                  isTrending: widget.isTrending,
                  isLatest: widget.isLatest,
                  isForums: widget.isForums,
                  isYourCampus: widget.isYourCampus,
                  isListCard: widget.isListCard,
                  user: widget.user,
                  isSearch: widget.isSearch,
                ),
              ),
            ],
          ),
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
  final bool isTrending;
  final bool isLatest;
  final bool isForums;
  final bool isYourCampus;
  final bool isListCard;
  final bool isSearch;
  final postModel.User user;
  const CampusTalkCommentsWidget({Key key, this.isBookmarkedPage, this.isUserProfile, this.postIndex, this.postId,
    this.isTrending = false,
    this.isLatest = false,
    this.isForums = false,
    this.isYourCampus = false,
    this.isListCard = false,
    this.isSearch = false,
    this.user,
  }) : super(key: key);

  @override
  _CampusTalkCommentsWidgetState createState() => _CampusTalkCommentsWidgetState();
}

class _CampusTalkCommentsWidgetState extends State<CampusTalkCommentsWidget> {
  TextEditingController messageEditingController = new TextEditingController();
  ThemeController themeController = Get.find<ThemeController>();
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
        isAnonymous?
        Container(
          height: 20,
          width: double.infinity,
          color: Colors.teal[900],
          alignment: Alignment.center,
          child: Text("You are now in INCOGNITO MODE",style: TextStyle(color: Colors.white,fontSize: 11),),
        ):
        SizedBox(),
        _messageSendWidget(),
        Expanded(
          child: Consumer<CampusTalkProvider>(
            builder: (context, campusTalkProvider, child) {
              if (!campusTalkProvider.fetchCommentsLoader && campusTalkProvider.commentFetchData != null) {
                return ListView(
                  padding: EdgeInsets.only(),
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
                                    child: buildEmojiAndText(
                                      content: commentData.content,
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: 0.1,
                                        fontFamily: 'Poppins',
                                        color: themeController.isDarkMode?Colors.white:Colors.black,
                                      ),
                                      normalFontSize: 14,
                                      emojiFontSize: 24,
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Text(
                                      DateFormat.yMMMEd().format(DateFormat("yyyy-MM-dd").parse(commentData.createdAt, true)),
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
                                    onTap: ()=> Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => CampusTalkCommentReply(
                                          commentId: commentData.id,
                                          commentIndex: index,
                                          postId: widget.postId,
                                          isBookmarkedPage: widget.isBookmarkedPage,
                                          isUserProfile: widget.isUserProfile,
                                          postIndex: widget.postIndex,
                                          isTrending: widget.isTrending,
                                          isLatest: widget.isLatest,
                                          isForums: widget.isForums,
                                          isYourCampus: widget.isYourCampus,
                                          isListCard: widget.isListCard,
                                          user: widget.user,
                                          isSearch: widget.isSearch,
                                        ))),
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
                                  Text(commentData.replies.isEmpty?"":commentData.repliesCount>1?
                                  "   •   ${commentData.repliesCount} Replies":
                                  "   •   ${commentData.repliesCount} Reply",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0.1,
                                      color: themeController.isDarkMode?Colors.white:Colors.black,
                                    ),
                                  ),
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
                                                  }
                                                  if(widget.isUserProfile){
                                                    --Provider.of<CampusTalkProvider>(context, listen: false).campusTalkByUserPostsResultsList[widget.postIndex].commentsCount;
                                                  }
                                                  if(widget.isTrending){
                                                    --Provider.of<CampusTalkProvider>(context, listen: false).campusTalkPostsResultsTrendingList[widget.postIndex].commentsCount;
                                                  }
                                                  if(widget.isLatest){
                                                    --Provider.of<CampusTalkProvider>(context, listen: false).campusTalkPostsResultsLatestList[widget.postIndex].commentsCount;
                                                  }
                                                  if(widget.isForums){
                                                    --Provider.of<CampusTalkProvider>(context, listen: false).campusTalkPostsResultsForumsList[widget.postIndex].commentsCount;
                                                  }
                                                  if(widget.isYourCampus){
                                                    --Provider.of<CampusTalkProvider>(context, listen: false).campusTalkPostsResultsYourCampusList[widget.postIndex].commentsCount;
                                                  }
                                                  if(widget.isListCard){
                                                    --Provider.of<CampusTalkProvider>(context, listen: false).campusTalkPostsResultsListCard[widget.postIndex].commentsCount;
                                                  }
                                                  if(widget.isSearch){
                                                    --Provider.of<CampusTalkProvider>(context, listen: false).campusTalkBySearchResultsList[widget.postIndex].commentsCount;
                                                  }
                                                  Future.delayed(Duration(seconds: 0), () {
                                                    Provider.of<CampusTalkProvider>(context, listen: false).fetchCommentsOfACampusTalk(widget.postId);
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
                                        isTrending: widget.isTrending,
                                        isLatest: widget.isLatest,
                                        isForums: widget.isForums,
                                        isYourCampus: widget.isYourCampus,
                                        isListCard: widget.isListCard,
                                        user: widget.user,
                                        isSearch: widget.isSearch,
                                      ))),
                                  child: Text(
                                    "Show previous replies...",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: 'Poppins',
                                      letterSpacing: 0.1,
                                      color: themeController.isDarkMode?Colors.white:Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
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
                                          child: buildEmojiAndText(
                                            content: commentData.replies.last.content,
                                            textStyle: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              letterSpacing: 0.1,
                                              fontFamily: 'Poppins',
                                              color: themeController.isDarkMode?Colors.white:Colors.black,
                                            ),
                                            normalFontSize: 14,
                                            emojiFontSize: 24,
                                          ),
                                        ),
                                        subtitle: Padding(
                                          padding: const EdgeInsets.only(top: 5),
                                          child: Text(
                                            DateFormat.yMMMEd().format(DateFormat("yyyy-MM-dd").parse(commentData.replies.last.createdAt, true)),
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: themeController.isDarkMode?MateColors.helpingTextDark:Colors.black.withOpacity(0.72),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ):SizedBox(),
                          ],
                        );
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

  Widget _messageSendWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.fromLTRB(16, 25, 16, 5),
            child: TextField(
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
                            color: isAnonymous ? themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight :
                            themeController.isDarkMode?MateColors.helpingTextDark:MateColors.helpingTextLight,
                            size: 24,
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                      child: IconButton(
                        icon: Icon(
                          Icons.send,
                          size: 20,
                          color: themeController.isDarkMode?MateColors.helpingTextDark:MateColors.helpingTextLight,
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
                              }
                              if(widget.isUserProfile){
                                ++Provider.of<CampusTalkProvider>(context, listen: false).campusTalkByUserPostsResultsList[widget.postIndex].commentsCount;
                              }
                              if(widget.isTrending){
                                ++Provider.of<CampusTalkProvider>(context, listen: false).campusTalkPostsResultsTrendingList[widget.postIndex].commentsCount;
                              }
                              if(widget.isLatest){
                                ++Provider.of<CampusTalkProvider>(context, listen: false).campusTalkPostsResultsLatestList[widget.postIndex].commentsCount;
                              }
                              if(widget.isForums){
                                ++Provider.of<CampusTalkProvider>(context, listen: false).campusTalkPostsResultsForumsList[widget.postIndex].commentsCount;
                              }
                              if(widget.isYourCampus){
                                ++Provider.of<CampusTalkProvider>(context, listen: false).campusTalkPostsResultsYourCampusList[widget.postIndex].commentsCount;
                              }
                              if(widget.isListCard){
                                ++Provider.of<CampusTalkProvider>(context, listen: false).campusTalkPostsResultsListCard[widget.postIndex].commentsCount;
                              }
                              if(widget.isSearch){
                                ++Provider.of<CampusTalkProvider>(context, listen: false).campusTalkBySearchResultsList[widget.postIndex].commentsCount;
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
