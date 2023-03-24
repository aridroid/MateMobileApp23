import 'package:get/get.dart';
import 'package:mate_app/Model/campusTalkPostsModel.dart';
import 'package:mate_app/Providers/AuthUserProvider.dart';
import 'package:mate_app/Providers/campusTalkProvider.dart';
import 'package:mate_app/Providers/externalShareProvider.dart';
import 'package:mate_app/Screen/Home/Community/campusTalkComments.dart';
import 'package:mate_app/Screen/Home/Community/campusTalkDetailsFullScreen.dart';
import 'package:mate_app/Screen/Home/Community/editCampusTalk.dart';
import 'package:mate_app/Screen/Profile/ProfileScreen.dart';
import 'package:mate_app/Screen/Profile/UserProfileScreen.dart';
import 'package:mate_app/Screen/Report/reportPage.dart';
import 'package:mate_app/Utility/Utility.dart';
import 'package:mate_app/asset/Colors/MateColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../controller/theme_controller.dart';

class CampusTalkRow extends StatefulWidget {
  final User user;
  final int talkId;
  final String url;
  final String title;
  final String description;
  final int isAnonymous;
  final String anonymousUser;
  final String createdAt;
  final int rowIndex;
  final IsBookmarked isBookmarked;
  final IsLiked isLiked;
  int likesCount;
  int commentsCount;
  final bool isBookmarkedPage;
  final bool isUserProfile;
  final bool navigateToDetailsPage;
  final bool isTrending;
  final bool isLatest;
  final bool isForums;
  final bool isYourCampus;
  final bool isListCard;
  final bool isSearch;
  final List<CampusTalkTypes> campusTalkType;

  CampusTalkRow(
      {Key key,
      this.user,
      this.talkId,
      this.url,
      this.title,
      this.description,
      this.isAnonymous,
      this.anonymousUser,
      this.createdAt,
      this.rowIndex,
      this.isBookmarked,
      this.isLiked,
      this.likesCount,
      this.commentsCount,
      this.isBookmarkedPage = false,
      this.isUserProfile = false,
      this.navigateToDetailsPage = true,
        this.isTrending = false,
        this.isLatest = false,
        this.isForums = false,
        this.isYourCampus = false,
        this.isListCard = false,
        this.isSearch = false,
        this.campusTalkType,
      })
      : super(key: key);

  @override
  _CampusTalkRowState createState() => _CampusTalkRowState(this.user, this.talkId, this.url, this.title, this.description, this.isAnonymous, this.createdAt, this.rowIndex);
}

class _CampusTalkRowState extends State<CampusTalkRow> {
  final User user;
  final int talkId;
  final String url;
  final String title;
  final String description;
  final int isAnonymous;
  final String createdAt;
  final int rowIndex;
  _CampusTalkRowState(this.user, this.talkId, this.url, this.title, this.description, this.isAnonymous, this.createdAt, this.rowIndex);

  bool bookMarked;
  bool liked;
  CampusTalkProvider campusTalkProvider;

  @override
  void initState() {
    campusTalkProvider = Provider.of<CampusTalkProvider>(context, listen: false);
    bookMarked = (widget.isBookmarked == null) ? false : true;
    liked = (widget.isLiked == null) ? false : true;
    super.initState();
  }

  ThemeController themeController = Get.find<ThemeController>();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16,vertical: 10),
      decoration: BoxDecoration(
        color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: isAnonymous == 0 ?
            InkWell(
              onTap: () {
                if (isAnonymous == 0) {
                  if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == user.uuid) {
                    Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                  } else {
                    Navigator.of(context).pushNamed(UserProfileScreen.routeName, arguments: {"id": user.uuid, "name": user.displayName, "photoUrl": user.profilePhoto, "firebaseUid": user.firebaseUid});
                  }
                }
              },
              child: CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                  user.profilePhoto,
                ),
              ),
            ):
            SizedBox(),
            horizontalTitleGap: isAnonymous == 0?10:-40,
            title: InkWell(
                onTap: () {
                  if (isAnonymous == 0) {
                    if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == user.uuid) {
                      Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                    } else {
                      Navigator.of(context).pushNamed(UserProfileScreen.routeName, arguments: {"id": user.uuid, "name": user.displayName, "photoUrl": user.profilePhoto, "firebaseUid": user.firebaseUid});
                    }
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 0.0),
                  child: Row(
                    children: [
                      Text(
                        isAnonymous == 0 ? user.displayName : "Anonymous",
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          color: themeController.isDarkMode?Colors.white:Colors.black,
                        ),
                        overflow: TextOverflow.clip,
                      ),
                      if(isAnonymous == 1)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5,right: 0),
                            child: Text(
                                user.university!=null?
                              "@ ${user.university}":
                              "@ Others",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                color: themeController.isDarkMode?Colors.white:Colors.black,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                )),
            subtitle: Text(
              "$createdAt",
              style: TextStyle(
                fontSize: 14,
                color: themeController.isDarkMode?MateColors.helpingTextDark:Colors.black.withOpacity(0.72),
              ),
            ),
            trailing: PopupMenuButton<int>(
              padding: EdgeInsets.only(left: 25),
              elevation: 0,
              color: themeController.isDarkMode?MateColors.popupDark:MateColors.popupLight,
              icon: Icon(
                Icons.more_vert,
                color: themeController.isDarkMode?Colors.white:MateColors.blackText,
              ),
              onSelected: (index) async {
                if (index == 0) {
                  // Map<String, dynamic> body;
                  // Provider.of<ExternalShareProvider>(context,listen: false).externalSharePost(body);
                  // modalSheetToShare();
                } else if (index == 1) {
                  _showDeleteAlertDialog(postId: widget.talkId, rowIndex: widget.rowIndex);
                } else if (index == 2) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReportPage(
                          moduleId: widget.talkId,
                          moduleType: "DiscussionForum",
                        ),
                      ));
                }else if (index == 3) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditCampusTalk(
                          id: widget.talkId,
                          title: widget.title,
                          description: widget.description,
                          isAnonymous: widget.isAnonymous,
                          anonymousUser: widget.anonymousUser,
                          isBookmarkedPage: widget.isBookmarkedPage,
                          isUserProfile: widget.isUserProfile,
                          isTrending: widget.isTrending,
                          isLatest: widget.isLatest,
                          isForums: widget.isForums,
                          isYourCampus: widget.isYourCampus,
                          isListCard: widget.isListCard,
                          user: widget.user,
                          campusTalkTypes: widget.campusTalkType,
                        ),
                      ));
                }
              },
              itemBuilder: (context) => [
                // PopupMenuItem(
                //     value: 0,
                //     height: 40,
                //     child: Text(
                //       "Share",
                //       textAlign: TextAlign.start,
                //       style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                //     ),
                //   ),
                (widget.user.uuid != null && (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == widget.user.uuid)) ?
                PopupMenuItem(
                  value: 1,
                  height: 40,
                  child: Text(
                    "Delete Post",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: themeController.isDarkMode?Colors.white:Colors.black,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                      fontSize: 14,
                    ),
                  ),
                ):
                PopupMenuItem(
                  value: 1,
                  enabled: false,
                  height: 0,
                  child: SizedBox(
                    height: 0,
                    width: 0,
                  ),
                ),
                PopupMenuItem(
                  value: 2,
                  height: 40,
                  child: Text(
                    "Report",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: themeController.isDarkMode?Colors.white:Colors.black,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                      fontSize: 14,
                    ),
                  ),
                ),
                (widget.user.uuid != null && (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == widget.user.uuid))?
                PopupMenuItem(
                  value: 3,
                  height: 40,
                  child: Text(
                    "Edit",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: themeController.isDarkMode?Colors.white:Colors.black,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                      fontSize: 14,
                    ),
                  ),
                ):PopupMenuItem(
                  value: 3,
                  enabled: false,
                  height: 0,
                  child: SizedBox(
                    height: 0,
                    width: 0,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(
              thickness: 1,
              color: themeController.isDarkMode?MateColors.dividerDark:MateColors.dividerLight,
            ),
          ),
          Container(
            height: widget.campusTalkType.isNotEmpty?39:0,
            margin: EdgeInsets.only(left: 16,top: 6),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.campusTalkType.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: themeController.isDarkMode?MateColors.smallContainerDark:MateColors.smallContainerLight,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15,right: 15),
                      child: Center(
                        child: Text("${widget.campusTalkType[index].type.name}",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 15,
                            color: themeController.isDarkMode?Colors.white:Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16,top: 10),
                child: InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () => _navigateToDetailsPage(),
                    child: Text(title, textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        color: themeController.isDarkMode?Colors.white:Colors.black,
                      ),
                    )),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 16,top: 10,right: 10),
            child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () => _navigateToDetailsPage(),
              child: SizedBox(
                width: double.infinity,
                child: description != null ?
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 14, 0),
                  child: Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.1,
                      color: themeController.isDarkMode?Colors.white:Colors.black,
                    ),
                  ),
                ) : SizedBox(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16,right: 16,top: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Consumer<CampusTalkProvider>(
                      builder: (context, value, child) {
                        return InkWell(
                            child: Container(
                              height: 32,
                              width: 64,
                              decoration: BoxDecoration(
                                color: liked ?themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight:
                                themeController.isDarkMode?MateColors.smallContainerDark:MateColors.smallContainerLight,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset("lib/asset/icons/upArrow.png",
                                    height: 20,
                                    width: 13,
                                    color:  themeController.isDarkMode?
                                    liked? Colors.black:Colors.white:
                                    liked? Colors.white: Colors.black,
                                  ),
                                  SizedBox(width: 5,),
                                  Text("${widget.likesCount}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      color: themeController.isDarkMode?
                                      liked? Colors.black:Colors.white:
                                      liked? Colors.white: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () async {
                              liked=!liked;
                              bool likedDone = await Provider.of<CampusTalkProvider>(context, listen: false).upVoteAPost(
                                  widget.talkId,
                                  widget.rowIndex,
                                  isBookmarkedPage: widget.isBookmarkedPage,
                                  isUserProfile: widget.isUserProfile,
                                isTrending: widget.isTrending,
                                isLatest: widget.isLatest,
                                isForums: widget.isForums,
                                isYourCampus: widget.isYourCampus,
                                isListCard: widget.isListCard,
                                isSearch: widget.isSearch,

                              );
                              if (likedDone && liked) {
                                if(widget.isUserProfile){
                                  ++value.campusTalkByUserPostsResultsList[widget.rowIndex].likesCount;
                                }
                                if(widget.isBookmarkedPage){
                                  ++value.campusTalkPostsBookmarkData.data.result[widget.rowIndex].likesCount;
                                }
                                if(widget.isTrending){
                                  ++value.campusTalkPostsResultsTrendingList[widget.rowIndex].likesCount;
                                }
                                if(widget.isLatest){
                                  ++value.campusTalkPostsResultsLatestList[widget.rowIndex].likesCount;
                                }
                                if(widget.isForums){
                                  ++value.campusTalkPostsResultsForumsList[widget.rowIndex].likesCount;
                                }
                                if(widget.isYourCampus){
                                  ++value.campusTalkPostsResultsYourCampusList[widget.rowIndex].likesCount;
                                }
                                if(widget.isListCard){
                                  ++value.campusTalkPostsResultsListCard[widget.rowIndex].likesCount;
                                }
                                if(widget.isSearch){
                                  ++value.campusTalkBySearchResultsList[widget.rowIndex].likesCount;
                                }
                                setState(() {});
                              }
                            }
                        );
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CampusTalkComments(
                            postId: talkId,
                            postIndex: widget.rowIndex,
                            isUserProfile: widget.isUserProfile,
                            isBookmarkedPage: widget.isBookmarkedPage,
                            isTrending: widget.isTrending,
                            isLatest: widget.isLatest,
                            isForums: widget.isForums,
                            isYourCampus: widget.isYourCampus,
                            isListCard: widget.isListCard,
                            user: widget.user,
                          ),
                        ));
                      },
                      child: Container(
                        height: 39,
                        width: 83,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: themeController.isDarkMode?MateColors.smallContainerDark:MateColors.smallContainerLight,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Image.asset("lib/asset/iconsNewDesign/msg.png",
                                color: themeController.isDarkMode?Colors.white:Colors.black,
                              ),
                            ),
                            Text(
                              widget.commentsCount.toString(),
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: themeController.isDarkMode?Colors.white:Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Consumer<CampusTalkProvider>(
                      builder: (context, value, child){
                        return InkWell(
                          onTap: ()async{
                            bookMarked=!bookMarked;
                            bool isBookmarked = await Provider.of<CampusTalkProvider>(context, listen: false).bookmarkAPost(widget.talkId, widget.rowIndex,
                                isBookmarkedPage: widget.isBookmarkedPage,
                                isUserProfile: widget.isUserProfile,
                              isTrending: widget.isTrending,
                              isLatest: widget.isLatest,
                              isForums: widget.isForums,
                              isYourCampus: widget.isYourCampus,
                              isListCard: widget.isListCard,
                              isSearch: widget.isSearch,
                            );
                            if (widget.isBookmarkedPage) {
                              if (isBookmarked) {
                                Future.delayed(Duration(seconds: 0), () {
                                  Provider.of<CampusTalkProvider>(context, listen: false).fetchCampusTalkPostBookmarkedList();
                                });
                              }
                            }
                          },
                          child: Container(
                            height: 39,
                            width: 40,
                            decoration: BoxDecoration(
                              color: themeController.isDarkMode?MateColors.smallContainerDark:MateColors.smallContainerLight,
                              shape: BoxShape.circle,
                            ),
                            child: bookMarked?
                            Padding(
                              padding: const EdgeInsets.all(11.0),
                              child: Image.asset("lib/asset/icons/bookmarkColor.png",
                                color: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                              ),
                            ):
                            Padding(
                              padding: const EdgeInsets.all(11.0),
                              child: Image.asset("lib/asset/homePageIcons/drawerBookmark@3x.png",
                                color: themeController.isDarkMode?Colors.white:Colors.black,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                // Row(
                //   children: [
                //     InkWell(
                //       onTap: ()async{
                //         String response = await DynamicLinkService.buildDynamicLinkCampusTalk(id: widget.talkId.toString());
                //         if(response!=null){
                //           Share.share(response);
                //         }
                //       },
                //       child: Image.asset("lib/asset/icons/share.png",height: 20,color: themeController.isDarkMode?MateColors.iconDark:MateColors.iconLight,),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
          SizedBox(height: 20,),
        ],
      ),
    );
  }

  _navigateToDetailsPage() {
    if (widget.navigateToDetailsPage) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CampusTalkDetailsScreen(
              talkId: widget.talkId,
              description: widget.description,
              title: widget.title,
              user: widget.user,
              isAnonymous: widget.isAnonymous,
              anonymousUser: widget.anonymousUser,
              url: widget.url,
              createdAt: widget.createdAt,
              rowIndex: widget.rowIndex,
              isBookmarked: widget.isBookmarked,
              isLiked: widget.isLiked,
              likesCount: widget.likesCount,
              commentsCount: widget.commentsCount,
              isBookmarkedPage: widget.isBookmarkedPage,
              isUserProfile: widget.isUserProfile,
              isTrending: widget.isTrending,
              isLatest: widget.isLatest,
              isForums: widget.isForums,
              isYourCampus: widget.isYourCampus,
              isListCard: widget.isListCard,
              isSearch: widget.isSearch,
            ),
          ));
    }
  }

  _showDeleteAlertDialog({
    @required int postId,
    @required int rowIndex,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: new Text("Are you sure?"),
          content: new Text("You want to delete your Discussion Post"),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text("Yes"),
              onPressed: () async {
                bool isDeleted = await campusTalkProvider.deleteACampusTalk(talkId, rowIndex);
                if (isDeleted) {
                  Future.delayed(Duration(seconds: 0), () {
                    if (widget.isBookmarkedPage) {
                      campusTalkProvider.fetchCampusTalkPostBookmarkedList();
                    } else if (widget.isUserProfile) {
                      campusTalkProvider.fetchCampusTalkByAuthUser(user.uuid, page: 1);
                    } else if(widget.isTrending){
                      campusTalkProvider.fetchCampusTalkPostTendingList(page: 1);
                    } else if(widget.isLatest){
                      campusTalkProvider.fetchCampusTalkPostTLatestList(page: 1);
                    }else if(widget.isForums){
                      campusTalkProvider.fetchCampusTalkPostForumsList(page: 1);
                    }else if(widget.isYourCampus){
                      campusTalkProvider.fetchCampusTalkPostYourCampusList(page: 1);
                    }else if(widget.isListCard){
                      campusTalkProvider.fetchCampusTalkPostListCard();
                    }else if(widget.isSearch){
                      Get.back();
                    }
                    Navigator.pop(context);
                  });
                }
              },
            ),
            CupertinoDialogAction(
                child: Text("No"),
                onPressed: () {
                  Navigator.of(context).pop();
                })
          ],
        );
      },
    );
  }

  modalSheetToShare() {
    TextEditingController _link = new TextEditingController(text: "shareableLink");
    final FlutterShareMe flutterShareMe = FlutterShareMe();
    String shareableLink = "shareableLink";
    List<String> socialIcons = ["fb.png", "whatsapp.png", "twitter.png", "telegram.png"];
    List<String> socialName = ["Facebook", "Whatsapp", "Twitter", "Telegram"];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: myHexColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15.0),
        ),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(18.0),
          child: Consumer<ExternalShareProvider>(
            builder: (ctx, externalShareProvider, _) {
              if (externalShareProvider.postExternalShareLoader) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Share post 😊",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: MateColors.activeIcons),
                    ),
                  ),
                  Container(
                    height: 45,
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(12, 8, 8, 8),
                    margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.white38, width: 0.6),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            shareableLink,
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                        InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: shareableLink));
                            Fluttertoast.showToast(msg: " Link Copied ", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_SHORT);
                          },
                          child: CircleAvatar(
                            radius: 22,
                            backgroundColor: Colors.teal[700],
                            child: Icon(
                              Icons.content_copy_outlined,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GridView.builder(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 4,
                    padding: EdgeInsets.only(left: 8, right: 8),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 10 / 3,
                    ),
                    itemBuilder: (context, index) {
                      return InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          try {
                            var response;
                            if (index == 0) {
                              response = await flutterShareMe.shareToSystem(msg: "Follow this link to join my MATE group $shareableLink");
                            } else if (index == 1) {
                              response = await flutterShareMe.shareToWhatsApp(msg: "Follow this link to join my MATE group $shareableLink");
                            } else if (index == 2) {
                              response = await flutterShareMe.shareToTwitter(msg: "Follow this link to join my MATE group $shareableLink");
                            } else if (index == 3) {
                              response = await flutterShareMe.shareToTelegram(msg: "Follow this link to join my MATE group $shareableLink");
                            }
                          } on Exception catch (e) {
                            print(e);
                          }
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ImageIcon(
                              AssetImage("lib/asset/Social_Icons/${socialIcons[index]}"),
                              size: 16,
                              color: Colors.white70,
                            ),
                            Text(
                              "  Share on ${socialName[index]}",
                              style: TextStyle(color: Colors.white70, fontSize: 13.5, fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ButtonTheme(
                    minWidth: MediaQuery.of(context).size.width - 40,
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: MateColors.activeIcons,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.circular(10.0),
                      // ),
                      // color: MateColors.activeIcons,
                      child: Text(
                        'Share Externally',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: () async {
                        var response = await flutterShareMe.shareToSystem(msg: "Follow this link to join my MATE group shareableLink");

                        // Share.share("Follow this link to join my MATE group shareableLink");
                      },
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                ],
              );
            },
          ),
        );
      },
    );
  }

}
