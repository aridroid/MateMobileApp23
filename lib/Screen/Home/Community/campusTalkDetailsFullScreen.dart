import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mate_app/Screen/Profile/UserProfileScreen.dart';
import 'package:mate_app/Model/campusTalkPostsModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Providers/AuthUserProvider.dart';
import '../../../Providers/campusTalkProvider.dart';
import '../../../asset/Colors/MateColors.dart';
import '../../../controller/theme_controller.dart';
import '../../Profile/ProfileScreen.dart';
import '../../Report/reportPage.dart';
import 'campusTalkComments.dart';

class CampusTalkDetailsScreen extends StatefulWidget{
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
  final IsLiked isDisLiked;
  int likesCount;
  int disLikeCount;
  int commentsCount;
  final bool isBookmarkedPage;
  final bool isUserProfile;
  final bool isTrending;
  final bool isLatest;
  final bool isForums;
  final bool isYourCampus;
  final bool isListCard;
  final bool isSearch;

  CampusTalkDetailsScreen({Key key, 
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
    this.disLikeCount,
    this.commentsCount,
    this.isBookmarkedPage=false,
    this.isUserProfile=false,
    this.isTrending = false,
    this.isLatest = false,
    this.isForums = false,
    this.isYourCampus = false,
    this.isListCard = false,
    this.isSearch = false,
    this.isDisLiked,
  }) : super(key: key);

  @override
  _CampusTalkDetailsScreenState createState() {
    return _CampusTalkDetailsScreenState();
  }
}

class _CampusTalkDetailsScreenState extends State<CampusTalkDetailsScreen>{
  ThemeController themeController = Get.find<ThemeController>();
  bool liked;
  bool bookMarked;
  bool disLiked;

  @override
  void initState() {
    bookMarked = (widget.isBookmarked == null) ? false : true;
    liked = (widget.isLiked == null) ? false : true;
    disLiked = (widget.isDisLiked == null) ? false : true;
    super.initState();
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
              SizedBox(
                height: scH*0.07,
              ),
              Container(
                decoration: BoxDecoration(
                  color: themeController.isDarkMode ? MateColors.containerDark : MateColors.containerLight,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: (){
                              Get.back();
                            },
                            child: Icon(Icons.arrow_back,color: MateColors.activeIcons,),
                          ),
                          SizedBox(width: 10,),
                          widget.isAnonymous == 0 ?
                          InkWell(
                            onTap: () {
                              if (widget.isAnonymous == 0) {
                                if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == widget.user.uuid) {
                                  Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                                } else {
                                  Navigator.of(context).pushNamed(UserProfileScreen.routeName, arguments: {"id": widget.user.uuid, "name": widget.user.displayName, "photoUrl": widget.user.profilePhoto, "firebaseUid": widget.user.firebaseUid});
                                }
                              }
                            },
                            child: CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(
                                widget.user.profilePhoto,
                              ),
                            ),
                          ):
                          Container(
                            height: 0,
                            width: 0,
                          ),
                        ],
                      ),
                      horizontalTitleGap: widget.isAnonymous == 0?10:-40,
                      title: InkWell(
                          onTap: () {
                            if (widget.isAnonymous == 0) {
                              if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == widget.user.uuid) {
                                Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                              } else {
                                Navigator.of(context).pushNamed(UserProfileScreen.routeName, arguments: {"id": widget.user.uuid, "name": widget.user.displayName, "photoUrl": widget.user.profilePhoto, "firebaseUid": widget.user.firebaseUid});
                              }
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 0.0),
                            child: Row(
                              children: [
                                Text(
                                  widget.isAnonymous == 0 ? widget.user.displayName : "Anonymous",// widget.anonymousUser ??
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    color: themeController.isDarkMode?Colors.white:Colors.black,
                                  ),
                                  overflow: TextOverflow.clip,
                                ),
                                if(widget.isAnonymous == 1)
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 5,right: 0),
                                      child: Text(
                                        widget.user.university!=null?
                                        "@ ${widget.user.university}":
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
                        "${widget.createdAt}",
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
                          }
                        },
                        itemBuilder: (context) => [
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
                    Padding(
                      padding: EdgeInsets.only(left: 16,top: 10),
                      child: InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          child: Text(widget.title, textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                              color: themeController.isDarkMode?Colors.white:Colors.black,
                            ),
                          ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16,top: 10,right: 10),
                      child: InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: SizedBox(
                          width: double.infinity,
                          child: widget.description != null ?
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 14, 0),
                            child: Text(
                              widget.description,
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
                                        bool likedDone = await Provider.of<CampusTalkProvider>(context, listen: false).upVoteAPost(widget.talkId, widget.rowIndex, isBookmarkedPage: widget.isBookmarkedPage, isUserProfile: widget.isUserProfile);
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
                                          if(widget.isSearch){
                                            ++value.campusTalkBySearchResultsList[widget.rowIndex].likesCount;
                                          }
                                          setState(() {});
                                        }
                                      }
                                  );
                                },
                              ),
                              SizedBox(width: 10,),
                              Consumer<CampusTalkProvider>(
                                builder: (context, value, child) {
                                  return InkWell(
                                      child: Container(
                                        height: 32,
                                        width: 64,
                                        decoration: BoxDecoration(
                                          color: disLiked ?themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight:
                                          themeController.isDarkMode?MateColors.smallContainerDark:MateColors.smallContainerLight,
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Image.asset("lib/asset/icons/downArrow.png",
                                              height: 20,
                                              width: 13,
                                              color:  themeController.isDarkMode?
                                              disLiked? Colors.black:Colors.white:
                                              disLiked? Colors.white: Colors.black,
                                            ),
                                            SizedBox(width: 5,),
                                            Text("${widget.disLikeCount}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14,
                                                fontFamily: 'Poppins',
                                                color: themeController.isDarkMode?
                                                disLiked? Colors.black:Colors.white:
                                                disLiked? Colors.white: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      onTap: () async {
                                        disLiked=!disLiked;
                                        bool likedDone = await Provider.of<CampusTalkProvider>(context, listen: false).downVoteAPost(
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
                                        if (likedDone && disLiked) {
                                          if(widget.isUserProfile){
                                            ++value.campusTalkByUserPostsResultsList[widget.rowIndex].dislikesCount;
                                          }
                                          if(widget.isBookmarkedPage){
                                            ++value.campusTalkPostsBookmarkData.data.result[widget.rowIndex].dislikesCount;
                                          }
                                          if(widget.isTrending){
                                            ++value.campusTalkPostsResultsTrendingList[widget.rowIndex].dislikesCount;
                                          }
                                          if(widget.isLatest){
                                            ++value.campusTalkPostsResultsLatestList[widget.rowIndex].dislikesCount;
                                          }
                                          if(widget.isForums){
                                            ++value.campusTalkPostsResultsForumsList[widget.rowIndex].dislikesCount;
                                          }
                                          if(widget.isYourCampus){
                                            ++value.campusTalkPostsResultsYourCampusList[widget.rowIndex].dislikesCount;
                                          }
                                          if(widget.isListCard){
                                            ++value.campusTalkPostsResultsListCard[widget.rowIndex].dislikesCount;
                                          }
                                          if(widget.isSearch){
                                            ++value.campusTalkBySearchResultsList[widget.rowIndex].dislikesCount;
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
                                      postId: widget.talkId,
                                      postIndex: widget.rowIndex,
                                      isUserProfile: widget.isUserProfile,
                                      isBookmarkedPage: widget.isBookmarkedPage,
                                      isListCard: widget.isListCard,
                                      isYourCampus: widget.isYourCampus,
                                      user: widget.user,
                                      isForums: widget.isForums,
                                      isLatest: widget.isLatest,
                                      isTrending: widget.isTrending,
                                      isSearch: widget.isSearch,
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
                                      bool isBookmarked = await Provider.of<CampusTalkProvider>(context, listen: false).bookmarkAPost(widget.talkId, widget.rowIndex, isBookmarkedPage: widget.isBookmarkedPage, isUserProfile: widget.isUserProfile);
                                      if (widget.isBookmarkedPage) {
                                        if (isBookmarked) {
                                          Future.delayed(Duration(seconds: 0), () {
                                            final campusTalkProvider = Provider.of<CampusTalkProvider>(context, listen: false);
                                            if (widget.isBookmarkedPage) {
                                              campusTalkProvider.fetchCampusTalkPostBookmarkedList();
                                            } else if (widget.isUserProfile) {
                                              campusTalkProvider.fetchCampusTalkByAuthUser(widget.user.uuid, page: 1);
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
                                              //campusTalkProvider.fetchCampusTalkPostSearchList();
                                            }
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
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                  ],
                ),
              ),
              Expanded(
                child: CampusTalkCommentsWidget(
                  postIndex: widget.rowIndex,
                  postId: widget.talkId,
                  isBookmarkedPage: widget.isBookmarkedPage,
                  isUserProfile: widget.isUserProfile,
                  isTrending: widget.isTrending,
                  isLatest: widget.isLatest,
                  isForums: widget.isForums,
                  isYourCampus: widget.isYourCampus,
                  isListCard: widget.isListCard,
                  user: widget.user,
                  isSearch: widget.isSearch,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _showDeleteAlertDialog({@required int postId, @required int rowIndex,}) async {
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
                bool isDeleted = await Provider.of<CampusTalkProvider>(context, listen: false).deleteACampusTalk(widget.talkId, rowIndex);
                if (isDeleted) {
                  Future.delayed(Duration(seconds: 0), () {
                    if (widget.isBookmarkedPage) {
                      Provider.of<CampusTalkProvider>(context, listen: false).fetchCampusTalkPostBookmarkedList();
                    } else if (widget.isUserProfile) {
                      Provider.of<CampusTalkProvider>(context, listen: false).fetchCampusTalkByAuthUser(widget.user.uuid, page: 1);
                    } else if(widget.isTrending){
                      Provider.of<CampusTalkProvider>(context, listen: false).fetchCampusTalkPostTendingList(page: 1);
                    } else if(widget.isLatest){
                      Provider.of<CampusTalkProvider>(context, listen: false).fetchCampusTalkPostTLatestList(page: 1);
                    }else if(widget.isForums){
                      Provider.of<CampusTalkProvider>(context, listen: false).fetchCampusTalkPostForumsList(page: 1);
                    }else if(widget.isYourCampus){
                      Provider.of<CampusTalkProvider>(context, listen: false).fetchCampusTalkPostYourCampusList(page: 1);
                    }else if(widget.isListCard){
                      Provider.of<CampusTalkProvider>(context, listen: false).fetchCampusTalkPostListCard();
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

}