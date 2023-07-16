import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mate_app/Model/campusTalkCommentFetchModel.dart';
import 'package:mate_app/Providers/AuthUserProvider.dart';
import 'package:mate_app/Providers/campusTalkProvider.dart';
import 'package:mate_app/Screen/Profile/ProfileScreen.dart';
import 'package:mate_app/Screen/Profile/UserProfileScreen.dart';
import 'package:mate_app/Widget/Loaders/Shimmer.dart';
import 'package:mate_app/asset/Colors/MateColors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../constant.dart';
import 'package:mate_app/Model/campusTalkPostsModel.dart' as postModel;

class CampusTalkCommentReply extends StatefulWidget {
  final bool isBookmarkedPage;
  final bool isUserProfile;
  final int postIndex;
  final int commentId;
  final int commentIndex;
  final int postId;
  final bool isTrending;
  final bool isLatest;
  final bool isForums;
  final bool isYourCampus;
  final bool isListCard;
  final bool isSearch;
  final postModel.User user;

  const CampusTalkCommentReply({Key? key,
    this.isTrending = false,
    this.isLatest = false,
    this.isForums = false,
    this.isYourCampus = false,
    this.isListCard = false,
    this.isSearch = false,
    required this.user,
    required this.commentId, required this.commentIndex, required this.postId, required this.postIndex, this.isBookmarkedPage=false, this.isUserProfile=false}) : super(key: key);

  @override
  _CampusTalkCommentReplyState createState() => _CampusTalkCommentReplyState();
}

class _CampusTalkCommentReplyState extends State<CampusTalkCommentReply> {
  FocusNode focusNode = FocusNode();
  TextEditingController messageEditingController = new TextEditingController();
  bool messageSentCheck = false;
  XFile? imageFile;
  bool isLoading = false;
  bool isAnonymous = false;
  final picker = ImagePicker();

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
              isAnonymous ?
              Container(
                height: 20,
                width: double.infinity,
                color: Colors.teal[900],
                alignment: Alignment.center,
                child: Text(
                  "You are now in INCOGNITO MODE",
                  style: TextStyle(color: Colors.white, fontSize: 11),
                ),
              ):
              SizedBox(),
              Expanded(
                child: Consumer<CampusTalkProvider>(
                  builder: (context, campusLiveProvider, child) {
                    if (!campusLiveProvider.fetchCommentsLoader && campusLiveProvider.commentFetchData != null) {
                      Result result = campusLiveProvider.commentFetchData!.data!.result![widget.commentIndex];
                      return ListView(
                        padding: EdgeInsets.only(top: 20),
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
                                      if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == result.user!.uuid) {
                                        Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                                      } else {
                                        Navigator.of(context).pushNamed(UserProfileScreen.routeName, arguments: {
                                          "id": result.user!.uuid,
                                          "name": result.user!.displayName,
                                          "photoUrl": result.user!.profilePhoto,
                                          "firebaseUid": result.user!.firebaseUid
                                        });
                                      }
                                    },
                                    child: ListTile(
                                      horizontalTitleGap: 1,
                                      dense: true,
                                      leading: result.user!.profilePhoto != null?
                                      ClipOval(
                                        child: Image.network(
                                          result.user!.profilePhoto!,
                                          height: 28,
                                          width: 28,
                                          fit: BoxFit.cover,
                                        ),
                                      ):CircleAvatar(
                                        radius: 14,
                                        child: Text(result.user!.displayName![0]),
                                      ),
                                      title: Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: buildEmojiAndText(
                                          content: result.content!,
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
                                          DateFormat.yMMMEd().format(DateFormat("yyyy-MM-dd").parse(result.createdAt!, true)),
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
                                      Text(result.replies!.isEmpty?"":result.replies!.length>1?
                                      "   •   ${result.replies!.length} Replies":
                                      "   •   ${result.replies!.length} Reply",
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
                                result.replies!.isNotEmpty?
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  itemCount: result.replies!.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.fromLTRB(40, 0, 0, 5),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                if (result.replies![index].isAnonymous == 0) {
                                                  if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == result.replies![index].user!.uuid) {
                                                    Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                                                  } else {
                                                    Navigator.of(context).pushNamed(UserProfileScreen.routeName, arguments: {
                                                      "id": result.replies![index].user!.uuid,
                                                      "name": result.replies![index].user!.displayName,
                                                      "photoUrl": result.replies![index].user!.profilePhoto,
                                                      "firebaseUid": result.replies![index].user!.firebaseUid
                                                    });
                                                  }
                                                }
                                              },
                                              child: ListTile(
                                                horizontalTitleGap: 1,
                                                dense: true,
                                                leading:
                                                result.replies![index].isAnonymous == 1 ?
                                                ClipOval(
                                                  child: Image.asset(
                                                    "lib/asset/logo.png",
                                                    height: 28,
                                                    width: 28,
                                                    fit: BoxFit.fitWidth,
                                                  ),
                                                ):
                                                result.replies![index].user!.profilePhoto != null?
                                                ClipOval(
                                                  child: Image.network(
                                                    result.replies![index].user!.profilePhoto!,
                                                    height: 28,
                                                    width: 28,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ):CircleAvatar(
                                                  radius: 14,
                                                  child: Text(result.replies![index].user!.displayName![0],),
                                                ),
                                                title: Padding(
                                                  padding: const EdgeInsets.only(top: 10),
                                                  child: buildEmojiAndText(
                                                    content: result.replies![index].content!,
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
                                                    DateFormat.yMMMEd().format(DateFormat("yyyy-MM-dd").parse(result.createdAt!, true)),
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: themeController.isDarkMode?MateColors.helpingTextDark:Colors.black.withOpacity(0.72),
                                                    ),
                                                  ),
                                                ),
                                                trailing: Visibility(
                                                    visible: Provider.of<AuthUserProvider>(context, listen: false).authUser.id == result.replies![index].user!.uuid,
                                                    child: Consumer<CampusTalkProvider>(
                                                      builder: (context, value, child) {
                                                        if(value.commentFetchData!.data!.result![widget.commentIndex].replies![index].isDeleting!){
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
                                                              bool updated = await Provider.of<CampusTalkProvider>(context, listen: false).deleteCommentsOfACampusTalk(value.commentFetchData!.data!.result![widget.commentIndex].replies![index].id!, widget.commentIndex, isReply: true, replyIndex: index);
                                                              if (updated) {
                                                                if(widget.isBookmarkedPage){
                                                                  --Provider.of<CampusTalkProvider>(context, listen: false).campusTalkPostsBookmarkData.data!.result![widget.postIndex].commentsCount;
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
                            color: isAnonymous ?
                            themeController.isDarkMode? MateColors.appThemeDark : MateColors.appThemeLight:
                            themeController.isDarkMode?MateColors.helpingTextDark:MateColors.helpingTextLight,
                            size: 24,
                          ),
                        )),
                    IconButton(
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
                          bool updated = await Provider.of<CampusTalkProvider>(context, listen: false).commentACampusTalk(content:messageEditingController.text.trim().isNotEmpty? messageEditingController.text.trim():" ",
                              isAnonymous: isAnonymous?"1":"0",parentId: widget.commentId,postId:  widget.postId, imageFile: imageFile);

                          if (updated) {
                            if(widget.isBookmarkedPage){
                              ++Provider.of<CampusTalkProvider>(context, listen: false).campusTalkPostsBookmarkData.data!.result![widget.postIndex].commentsCount;
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
