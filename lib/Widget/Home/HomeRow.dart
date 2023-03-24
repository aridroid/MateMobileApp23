import 'dart:io';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mate_app/Providers/FeedProvider.dart';
import 'package:mate_app/Screen/Home/HomeScreen.dart';
import 'package:mate_app/Screen/Home/TimeLine/feedComments.dart';
import 'package:mate_app/Screen/Home/TimeLine/feedDetailsFullScreen.dart';
import 'package:mate_app/Screen/Home/TimeLine/feedLikesDetails.dart';
import 'package:mate_app/Screen/Profile/ProfileScreen.dart';
import 'package:mate_app/Screen/Profile/UserProfileScreen.dart';
import 'package:mate_app/Screen/Report/reportPage.dart';
import 'package:mate_app/Screen/chat1/screens/chat.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:mate_app/asset/Colors/MateColors.dart';
import "package:googleapis_auth/auth_io.dart";
import 'package:googleapis/calendar/v3.dart' as gCal;

import '../../Model/FeedItem.dart';
import '../../Providers/AuthUserProvider.dart';
import '../../Screen/Home/TimeLine/editFeed.dart';
import '../../Screen/Home/TimeLine/feed_search.dart';
import '../../Services/FeedService.dart';
import '../../controller/theme_controller.dart';
import '../mediaViewer.dart';
import 'package:http/http.dart'as http;

import '../video_thumbnail.dart';

class HomeRow extends StatefulWidget {
  String previousPageUserId;
  String previousPageFeedId;
  String id;
  int feedId;
  String title;
  String start;
  String end;
  String calenderDate;
  String description;
  String created;
  var user;
  String location;
  String hyperlinkText;
  String hyperlink;
  List media;
  final List mediaOther;
  bool bookMarked;
  bool isFollowed;
  IsLiked isLiked;
  bool liked;
  List feedType;
  int indexVal;
  bool isBookmarkedPage;
  bool isFeedDetailsPage;
  List<LikeCount> likeCount;
  int bookmarkCount;
  int shareCount;
  int commentCount;
  IsShared isShared;
  bool navigateToDetailsPage;
  String pageType;
  bool showUniversityTag;
  final bool isPlaying;
  final bool isPaused;
  final bool isLoadingAudio;
  Function(String url,int index) startAudio;
  Function(int index) pauseAudio;

  HomeRow(
      {this.previousPageUserId,
      this.previousPageFeedId,
      this.id,
      this.feedId,
      this.title,
      this.feedType,
      this.start,
      this.end,
      this.calenderDate,
      this.description,
      this.created,
      this.user,
      this.location,
      this.hyperlinkText,
      this.hyperlink,
      this.media,
      this.isLiked,
      this.liked,
      this.bookMarked,
      this.isFollowed=false,
      this.indexVal,
      this.likeCount,
      this.bookmarkCount,
      this.commentCount,
      this.shareCount,
      this.isBookmarkedPage = false,
      this.isFeedDetailsPage = false,
      this.navigateToDetailsPage = true,
        this.showUniversityTag = false,
        this.pageType,
      this.isShared, this.mediaOther, this.isPlaying, this.isPaused, this.isLoadingAudio,
        this.startAudio,
        this.pauseAudio,
      });

  @override
  _HomeRowState createState() => _HomeRowState(this.id, this.feedId, this.title, this.feedType, this.start, this.end, this.calenderDate, this.description, this.created, this.user, this.location, this.media, this.liked, this.bookMarked,this.showUniversityTag,this.mediaOther);
}

class _HomeRowState extends State<HomeRow> with SingleTickerProviderStateMixin {
  final String id;
  final int feedId;
  final String title;
  final String startTime;
  final String endTime;
  final String calenderDate;
  final String description;
  final String created;
  var user;
  final String location;
  final List media;
  final List mediaOther;
  final List feedType;
  bool bookMarked;
  bool liked;
  bool showUniversityTag;
  auth.User _currentUser = auth.FirebaseAuth.instance.currentUser;
  _HomeRowState(this.id, this.feedId, this.title, this.feedType, this.startTime, this.endTime, this.calenderDate, this.description, this.created, this.user, this.location, this.media, this.liked, this.bookMarked,this.showUniversityTag, this.mediaOther);

  ClientId _credentials;
  String token;
  ThemeController themeController = Get.find<ThemeController>();
  FeedProvider feedProvider;

  @override
  void initState() {
    super.initState();
    getStoredValue();
    feedProvider = Provider.of<FeedProvider>(context, listen: false);
    super.initState();
    if (Platform.isAndroid) {
      _credentials = new ClientId("237545926078-9biln72s9c5h9vot53l84me39unhhnbf.apps.googleusercontent.com", "");
    } else if (Platform.isIOS) {
      _credentials = new ClientId("237545926078-99q5c35ugs0b49spmhf1ru0ghie7opnp.apps.googleusercontent.com", "");
    }
  }

  getStoredValue()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: InkWell(
              onTap: () {
                if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == user.id) {
                  Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                } else {
                  Navigator.of(context).pushNamed(UserProfileScreen.routeName, arguments: {"id": user.id, "name": user.name, "photoUrl": user.photoUrl, "firebaseUid": user.firebaseUid});
                }
              },
              child: user.photoUrl.length == 0 ?
              CircleAvatar(
                radius: 20,
                child: Text(
                  user.name[0],
                ),
              ):
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                  user.photoUrl,
                ),
              ),
            ),
            title: InkWell(
              onTap: () {
                if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == user.id) {
                  Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                } else {
                  Navigator.of(context).pushNamed(UserProfileScreen.routeName, arguments: {"id": user.id, "name": user.name, "photoUrl": user.photoUrl, "firebaseUid": user.firebaseUid});
                }
              },
              child: Text(
                user.name,
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  color: themeController.isDarkMode?Colors.white:Colors.black,
                ),
              ),
            ),
            subtitle: Text(
              "$created",
              style: TextStyle(
                fontSize: 14,
                color: themeController.isDarkMode?MateColors.helpingTextDark:Colors.black.withOpacity(0.72),
              ),
            ),
            trailing: PopupMenuButton<int>(
              padding: EdgeInsets.zero,
              elevation: 0,
              color: themeController.isDarkMode?MateColors.popupDark:MateColors.popupLight,
              icon: Icon(
                Icons.more_vert,
                color: themeController.isDarkMode?Colors.white:MateColors.blackText,
              ),
              onSelected: (index) async {
                if (index == 0) {
                  gCal.Event event = gCal.Event(); // Create object of event
                  event.summary = title; //Setting summary of object
                  event.description = description; //Setting summary of object

                  gCal.EventDateTime start = new gCal.EventDateTime(); //Setting start time
                  start.dateTime = DateTime.parse(calenderDate).toLocal();
                  start.timeZone = "GMT+05:00";
                  event.start = start;

                  gCal.EventDateTime end = new gCal.EventDateTime(); //setting end time
                  end.timeZone = "GMT+05:00";
                  end.dateTime = DateTime.parse(calenderDate).toLocal();
                  event.end = end;

                  insertEvent(event);
                } else if (index == 1) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Chat(peerUuid: user.id, currentUserId: _currentUser.uid, peerId: user.firebaseUid, peerAvatar: user.photoUrl, peerName: user.name)));
                } else if (index == 2) {
                  _showFollowAlertDialog(feedId: widget.feedId, indexVal: widget.indexVal);
                }else if (index == 4) {
                  _showDeleteAlertDialog(feedId: widget.feedId, indexVal: widget.indexVal);
                } else if (index == 5) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReportPage(
                          moduleId: widget.feedId,
                          moduleType: "Feed",
                        ),
                      ));
                }
                else if (index == 6) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => EditFeedPost(
                    id: widget.feedId,
                    title: widget.title,
                    description: widget.description,
                    link: widget.hyperlink,
                    linkText: widget.hyperlinkText,
                    imageUrl: widget.media.isNotEmpty?widget.media[0].url:"",
                    feedType: widget.feedType,
                    videoUrl: widget.mediaOther.isNotEmpty? widget.mediaOther[0].url.contains(".mp4")?widget.mediaOther[0].url:"":"",
                    audioUrl: widget.mediaOther.isNotEmpty? !widget.mediaOther[0].url.contains(".mp4")?widget.mediaOther[0].url:"":"",
                  ),));
                }
              },
              itemBuilder: (context) => [
                // PopupMenuItem(
                //   value: 0,
                //   height: 40,
                //   child: Text(
                //     "Calendar",
                //     textAlign: TextAlign.start,
                //     style: TextStyle(
                //       color: themeController.isDarkMode?Colors.white:Colors.black,
                //       fontWeight: FontWeight.w500,
                //       fontFamily: 'Poppins',
                //       fontSize: 14,
                //     ),
                //   ),
                // ),
                PopupMenuItem(
                  value: 1,
                  height: 40,
                  child: Text(
                    "Message",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: themeController.isDarkMode?Colors.white:Colors.black,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                      fontSize: 14,
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: 2,
                  height: 40,
                  child: Text(
                    widget.isFollowed?"Unfollow Post":"Follow Post",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: themeController.isDarkMode?Colors.white:Colors.black,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                      fontSize: 14,
                    ),
                  ),
                ),
                (!widget.isFeedDetailsPage && widget.user.id != null && (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == widget.user.id)) ?
                PopupMenuItem(
                  value: 4,
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
                ) :
                PopupMenuItem(
                  value: 4,
                  enabled: false,
                  height: 0,
                  child: SizedBox(
                    height: 0,
                    width: 0,
                  ),
                ),
                PopupMenuItem(
                  value: 5,
                  enabled: true,
                  child: Text(
                    "Report Post",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: themeController.isDarkMode?Colors.white:Colors.black,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                      fontSize: 14,
                    ),
                  ),
                ),
                (!widget.isFeedDetailsPage && widget.user.id != null && (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == widget.user.id)) ?
                PopupMenuItem(
                  value: 6,
                  height: 40,
                  child: Text(
                    "Edit Post",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: themeController.isDarkMode?Colors.white:Colors.black,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                      fontSize: 14,
                    ),
                  ),
                ) :
                PopupMenuItem(
                  value: 6,
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
          if(showUniversityTag)
          Container(
            height: 28.0,
            margin: EdgeInsets.only(left: 16,top: 6,bottom: 2,right: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: themeController.isDarkMode?MateColors.smallContainerDark:MateColors.smallContainerLight,
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 15,right: 15),
              child: Center(child: Text(
                user.university??"Others",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 15,
                  color: themeController.isDarkMode?Colors.white:Colors.black,
                ),
              ),
              ),
            ),
          ),
          Container(
            height: 39,
            margin: EdgeInsets.only(left: 16,top: 6),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: feedType.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: InkWell(
                  onTap: () {
                    final page = FeedSearch(text: feedType[index].type.name,);
                    Navigator.push(context,MaterialPageRoute(builder: (context) => page ));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: themeController.isDarkMode?MateColors.smallContainerDark:MateColors.smallContainerLight,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15,right: 15),
                      child: Center(
                        child: Text("${feedType[index].type.name}",
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
          InkWell(
            onTap: () async{
              if (widget.navigateToDetailsPage) {
               await Navigator.push(context,
                    MaterialPageRoute(
                      builder: (context) => FeedDetailsFullScreen(
                          isFeedDetailsPage: widget.isFeedDetailsPage,
                          id: widget.id,
                          feedId: widget.feedId,
                          title: widget.title,
                          feedType: widget.feedType,
                          start: widget.start,
                          end: widget.end,
                          description: widget.description,
                          created: widget.created,
                          user: widget.user,
                          location: widget.location,
                          hyperlinkText: widget.hyperlinkText,
                          hyperlink: widget.hyperlink,
                          media: widget.media,
                          isLiked: widget.isLiked,
                          liked: widget.liked,
                          bookMarked: widget.bookMarked,
                          likeCount: widget.likeCount,
                          bookmarkCount: widget.bookmarkCount,
                          shareCount: widget.shareCount,
                          commentCount: widget.commentCount,
                          isShared: widget.isShared,
                          pageType: widget.pageType,
                          indexVal: widget.indexVal,
                          mediaOther: widget.mediaOther,
                      ),
                    ));
               setState(() {});
              }
            },
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16,top: 20),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      color: themeController.isDarkMode?Colors.white:Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16,top: 10,right: 10),
            child: Linkify(
              onOpen: (link) async {
                print("Clicked ${link.url}!");
                if (await canLaunch(link.url))
                  await launch(link.url);
                else
                  throw "Could not launch ${link.url}";
              },
              text: description,
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                letterSpacing: 0.1,
                color: themeController.isDarkMode?Colors.white:Colors.black,
              ),
              textAlign: TextAlign.left,
              linkStyle: TextStyle(
                fontSize: 14,
                fontFamily: 'Poppins',
                color: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
              ),
            ),
          ),
          widget.hyperlinkText!=null && widget.hyperlink!=null ?
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () async{
              if (await canLaunch(widget.hyperlink))
                await launch(widget.hyperlink);
              else
                Fluttertoast.showToast(msg: " Could not launch given URL '${widget.hyperlink}'", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
              throw "Could not launch ${widget.hyperlink}";
            },
            child: Padding(
              padding: EdgeInsets.only(left: 16,top: 10,right: 10),
              child: Text(
                widget.hyperlinkText,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  color: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                ),
              ),
            ),
          ):SizedBox(),
          ..._buildMedia(context, media),
          ..._buildMediaOther(context, mediaOther),
          widget.isShared != null ? _sharedWidget(widget.isShared) : SizedBox(),
          location!=null?
          Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 16, bottom: 5),
            child: Row(
              children: [
                Icon(
                  Icons.location_on_sharp,
                  size: 25,
                  color: themeController.isDarkMode?Colors.white:Colors.black,
                ),
                Expanded(
                  child: Text(
                    ' $location',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      color: themeController.isDarkMode?Colors.white.withOpacity(0.7):Colors.black.withOpacity(0.7),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ):SizedBox(),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: (){
                    if(widget.pageType == "TimeLineMyCampus"){
                      if(feedProvider.feedListMyCampus[widget.indexVal].likeCount[0].count!=0 || feedProvider.feedListMyCampus[widget.indexVal].likeCount[1].count!=0){
                        Get.to(() => FeedLikesDetails(feedId: widget.feedId,));
                      }
                    }else if(widget.pageType == "TimeLineGlobal"){
                      if(feedProvider.feedList[widget.indexVal].likeCount[0].count!=0 || feedProvider.feedList[widget.indexVal].likeCount[1].count!=0){
                        Get.to(() => FeedLikesDetails(feedId: widget.feedId,));
                      }
                    }else if(widget.pageType == "User"){
                      if(feedProvider.feedItemListOfUser[widget.indexVal].likeCount[0].count!=0 || feedProvider.feedItemListOfUser[widget.indexVal].likeCount[1].count!=0){
                        Get.to(() => FeedLikesDetails(feedId: widget.feedId,));
                      }
                    }else if(widget.pageType == "Bookmark"){
                      if(feedProvider.bookmarkByUserData.data.feeds[widget.indexVal].likeCount[0].count!=0 || feedProvider.bookmarkByUserData.data.feeds[widget.indexVal].likeCount[1].count!=0){
                        Get.to(() => FeedLikesDetails(feedId: widget.feedId,));
                      }
                    }else if(widget.pageType == "Search"){
                      if(feedProvider.feedItem[widget.indexVal].likeCount[0].count!=0 || feedProvider.feedItem[widget.indexVal].likeCount[1].count!=0){
                        Get.to(() => FeedLikesDetails(feedId: widget.feedId,));
                      }
                    }else if(widget.pageType == "BookmarkMyCampus"){
                      if(feedProvider.bookmarkByUserDataMycampus.data.feeds[widget.indexVal].likeCount[0].count!=0 || feedProvider.bookmarkByUserDataMycampus.data.feeds[widget.indexVal].likeCount[1].count!=0){
                        Get.to(() => FeedLikesDetails(feedId: widget.feedId,));
                      }
                    }
                  },
                  onDoubleTap: ()async{
                    print(widget.pageType);
                    String response = await FeedService().likeFeed(feedId, 0, token);
                    if(response == "Feed Liked successfully"){
                      if(widget.pageType == "TimeLineMyCampus"){
                        feedProvider.feedListMyCampus[widget.indexVal].likeCount[0].count++;
                        feedProvider.feedListMyCampus[widget.indexVal].isLiked = IsLiked(feedId: 0,userId: 0,id: 0,emojiValue: 0,createdAt: "",updatedAt: "");
                      }else if(widget.pageType == "TimeLineGlobal"){
                        feedProvider.feedList[widget.indexVal].likeCount[0].count++;
                        feedProvider.feedList[widget.indexVal].isLiked = IsLiked(feedId: 0,userId: 0,id: 0,emojiValue: 0,createdAt: "",updatedAt: "");
                      }else if(widget.pageType == "User"){
                        feedProvider.feedItemListOfUser[widget.indexVal].likeCount[0].count++;
                        feedProvider.feedItemListOfUser[widget.indexVal].isLiked = IsLiked(feedId: 0,userId: 0,id: 0,emojiValue: 0,createdAt: "",updatedAt: "");
                      }else if(widget.pageType == "Bookmark"){
                        feedProvider.bookmarkByUserData.data.feeds[widget.indexVal].likeCount[0].count++;
                        feedProvider.bookmarkByUserData.data.feeds[widget.indexVal].isLiked = IsLiked(feedId: 0,userId: 0,id: 0,emojiValue: 0,createdAt: "",updatedAt: "");
                      }else if(widget.pageType == "Search"){
                        feedProvider.feedItem[widget.indexVal].likeCount[0].count++;
                        feedProvider.feedItem[widget.indexVal].isLiked = IsLiked(feedId: 0,userId: 0,id: 0,emojiValue: 0,createdAt: "",updatedAt: "");
                      }else if(widget.pageType == "BookmarkMyCampus"){
                        feedProvider.bookmarkByUserDataMycampus.data.feeds[widget.indexVal].likeCount[0].count++;
                        feedProvider.bookmarkByUserDataMycampus.data.feeds[widget.indexVal].isLiked = IsLiked(feedId: 0,userId: 0,id: 0,emojiValue: 0,createdAt: "",updatedAt: "");
                      }
                    }else if(response == 'Feed Unliked successfully'){
                      if(widget.pageType == "TimeLineMyCampus"){
                        if(feedProvider.feedListMyCampus[widget.indexVal].isLiked.emojiValue==0){
                          feedProvider.feedListMyCampus[widget.indexVal].likeCount[0].count--;
                          feedProvider.feedListMyCampus[widget.indexVal].isLiked = null;
                        }else{
                          await FeedService().likeFeed(feedId, 0, token);
                          feedProvider.feedListMyCampus[widget.indexVal].likeCount[0].count++;
                          feedProvider.feedListMyCampus[widget.indexVal].isLiked = IsLiked(feedId: 0,userId: 0,id: 0,emojiValue: 0,createdAt: "",updatedAt: "");
                          feedProvider.feedListMyCampus[widget.indexVal].likeCount[1].count--;
                        }
                      }else if(widget.pageType == "TimeLineGlobal"){
                        if(feedProvider.feedList[widget.indexVal].isLiked.emojiValue==0){
                          feedProvider.feedList[widget.indexVal].likeCount[0].count--;
                          feedProvider.feedList[widget.indexVal].isLiked = null;
                        }else{
                          await FeedService().likeFeed(feedId, 0, token);
                          feedProvider.feedList[widget.indexVal].likeCount[0].count++;
                          feedProvider.feedList[widget.indexVal].isLiked = IsLiked(feedId: 0,userId: 0,id: 0,emojiValue: 0,createdAt: "",updatedAt: "");
                          feedProvider.feedList[widget.indexVal].likeCount[1].count--;
                        }
                      }else if(widget.pageType == "User"){
                        if(feedProvider.feedItemListOfUser[widget.indexVal].isLiked.emojiValue==0){
                          feedProvider.feedItemListOfUser[widget.indexVal].likeCount[0].count--;
                          feedProvider.feedItemListOfUser[widget.indexVal].isLiked = null;
                        }else{
                          await FeedService().likeFeed(feedId, 0, token);
                          feedProvider.feedItemListOfUser[widget.indexVal].likeCount[0].count++;
                          feedProvider.feedItemListOfUser[widget.indexVal].isLiked = IsLiked(feedId: 0,userId: 0,id: 0,emojiValue: 0,createdAt: "",updatedAt: "");
                          feedProvider.feedItemListOfUser[widget.indexVal].likeCount[1].count--;
                        }
                      }else if(widget.pageType == "Bookmark"){
                        if(feedProvider.bookmarkByUserData.data.feeds[widget.indexVal].isLiked.emojiValue==0){
                          feedProvider.bookmarkByUserData.data.feeds[widget.indexVal].likeCount[0].count--;
                          feedProvider.bookmarkByUserData.data.feeds[widget.indexVal].isLiked = null;
                        }else{
                          await FeedService().likeFeed(feedId, 0, token);
                          feedProvider.bookmarkByUserData.data.feeds[widget.indexVal].likeCount[0].count++;
                          feedProvider.bookmarkByUserData.data.feeds[widget.indexVal].isLiked = IsLiked(feedId: 0,userId: 0,id: 0,emojiValue: 0,createdAt: "",updatedAt: "");
                          feedProvider.bookmarkByUserData.data.feeds[widget.indexVal].likeCount[1].count--;
                        }
                      }else if(widget.pageType == "Search"){
                        if(feedProvider.feedItem[widget.indexVal].isLiked.emojiValue==0){
                          feedProvider.feedItem[widget.indexVal].likeCount[0].count--;
                          feedProvider.feedItem[widget.indexVal].isLiked = null;
                        }else{
                          await FeedService().likeFeed(feedId, 0, token);
                          feedProvider.feedItem[widget.indexVal].likeCount[0].count++;
                          feedProvider.feedItem[widget.indexVal].isLiked = IsLiked(feedId: 0,userId: 0,id: 0,emojiValue: 0,createdAt: "",updatedAt: "");
                          feedProvider.feedItem[widget.indexVal].likeCount[1].count--;
                        }
                      }else if(widget.pageType == "BookmarkMyCampus"){
                        if(feedProvider.bookmarkByUserDataMycampus.data.feeds[widget.indexVal].isLiked.emojiValue==0){
                          feedProvider.bookmarkByUserDataMycampus.data.feeds[widget.indexVal].likeCount[0].count--;
                          feedProvider.bookmarkByUserDataMycampus.data.feeds[widget.indexVal].isLiked = null;
                        }else{
                          await FeedService().likeFeed(feedId, 0, token);
                          feedProvider.bookmarkByUserDataMycampus.data.feeds[widget.indexVal].likeCount[0].count++;
                          feedProvider.bookmarkByUserDataMycampus.data.feeds[widget.indexVal].isLiked = IsLiked(feedId: 0,userId: 0,id: 0,emojiValue: 0,createdAt: "",updatedAt: "");
                          feedProvider.bookmarkByUserDataMycampus.data.feeds[widget.indexVal].likeCount[1].count--;
                        }
                      }
                    }
                    setState(() {});
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 25, left: 16),
                    height: 32,
                    width: 64,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: themeController.isDarkMode?MateColors.smallContainerDark:MateColors.smallContainerLight,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 1.4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "lib/asset/Reactions/clapping1.png",
                          width: 18,
                          height: 14,
                          fit: BoxFit.fitHeight,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          widget.pageType == "TimeLineMyCampus"?
                          feedProvider.feedListMyCampus[widget.indexVal].likeCount[0].count.toString():
                          widget.pageType == "TimeLineGlobal"?
                          feedProvider.feedList[widget.indexVal].likeCount[0].count.toString():
                          widget.pageType == "User"?
                          feedProvider.feedItemListOfUser[widget.indexVal].likeCount[0].count.toString():
                          widget.pageType == "Bookmark"?
                          feedProvider.bookmarkByUserData.data.feeds[widget.indexVal].likeCount[0].count.toString():
                          widget.pageType == "BookmarkMyCampus"?
                          feedProvider.bookmarkByUserDataMycampus.data.feeds[widget.indexVal].likeCount[0].count.toString():
                          widget.pageType == "Search"?
                          feedProvider.feedItem[widget.indexVal].likeCount[0].count.toString():
                          widget.likeCount[0].count.toString(),
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 15,
                            color: themeController.isDarkMode?Colors.white:Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    if(widget.pageType == "TimeLineMyCampus"){
                      if(feedProvider.feedListMyCampus[widget.indexVal].likeCount[0].count!=0 || feedProvider.feedListMyCampus[widget.indexVal].likeCount[1].count!=0){
                        Get.to(() => FeedLikesDetails(feedId: widget.feedId,));
                      }
                    }else if(widget.pageType == "TimeLineGlobal"){
                      if(feedProvider.feedList[widget.indexVal].likeCount[0].count!=0 || feedProvider.feedList[widget.indexVal].likeCount[1].count!=0){
                        Get.to(() => FeedLikesDetails(feedId: widget.feedId,));
                      }
                    }else if(widget.pageType == "User"){
                      if(feedProvider.feedItemListOfUser[widget.indexVal].likeCount[0].count!=0 || feedProvider.feedItemListOfUser[widget.indexVal].likeCount[1].count!=0){
                        Get.to(() => FeedLikesDetails(feedId: widget.feedId,));
                      }
                    }else if(widget.pageType == "Bookmark"){
                      if(feedProvider.bookmarkByUserData.data.feeds[widget.indexVal].likeCount[0].count!=0 || feedProvider.bookmarkByUserData.data.feeds[widget.indexVal].likeCount[1].count!=0){
                        Get.to(() => FeedLikesDetails(feedId: widget.feedId,));
                      }
                    }else if(widget.pageType == "Search"){
                      if(feedProvider.feedItem[widget.indexVal].likeCount[0].count!=0 || feedProvider.feedItem[widget.indexVal].likeCount[1].count!=0){
                        Get.to(() => FeedLikesDetails(feedId: widget.feedId,));
                      }
                    }else if(widget.pageType == "BookmarkMyCampus"){
                      if(feedProvider.bookmarkByUserDataMycampus.data.feeds[widget.indexVal].likeCount[0].count!=0 || feedProvider.bookmarkByUserDataMycampus.data.feeds[widget.indexVal].likeCount[1].count!=0){
                        Get.to(() => FeedLikesDetails(feedId: widget.feedId,));
                      }
                    }
                  },
                  onDoubleTap: ()async{
                    print(widget.pageType);
                    String response = await FeedService().likeFeed(feedId, 1, token);
                    if(response == "Feed Liked successfully"){
                      if(widget.pageType == "TimeLineMyCampus"){
                        feedProvider.feedListMyCampus[widget.indexVal].likeCount[1].count++;
                        feedProvider.feedListMyCampus[widget.indexVal].isLiked = IsLiked(feedId: 0,userId: 0,id: 0,emojiValue: 1,createdAt: "",updatedAt: "");
                      }else if(widget.pageType == "TimeLineGlobal"){
                        feedProvider.feedList[widget.indexVal].likeCount[1].count++;
                        feedProvider.feedList[widget.indexVal].isLiked = IsLiked(feedId: 0,userId: 0,id: 0,emojiValue: 1,createdAt: "",updatedAt: "");
                      }else if(widget.pageType == "User"){
                        feedProvider.feedItemListOfUser[widget.indexVal].likeCount[1].count++;
                        feedProvider.feedItemListOfUser[widget.indexVal].isLiked = IsLiked(feedId: 0,userId: 0,id: 0,emojiValue: 1,createdAt: "",updatedAt: "");
                      }else if(widget.pageType == "Bookmark"){
                        feedProvider.bookmarkByUserData.data.feeds[widget.indexVal].likeCount[1].count++;
                        feedProvider.bookmarkByUserData.data.feeds[widget.indexVal].isLiked = IsLiked(feedId: 0,userId: 0,id: 0,emojiValue: 1,createdAt: "",updatedAt: "");
                      }else if(widget.pageType == "Search"){
                        feedProvider.feedItem[widget.indexVal].likeCount[1].count++;
                        feedProvider.feedItem[widget.indexVal].isLiked = IsLiked(feedId: 0,userId: 0,id: 0,emojiValue: 1,createdAt: "",updatedAt: "");
                      }else if(widget.pageType == "BookmarkMyCampus"){
                        feedProvider.bookmarkByUserDataMycampus.data.feeds[widget.indexVal].likeCount[1].count++;
                        feedProvider.bookmarkByUserDataMycampus.data.feeds[widget.indexVal].isLiked = IsLiked(feedId: 0,userId: 0,id: 0,emojiValue: 1,createdAt: "",updatedAt: "");
                      }
                    }else if(response == 'Feed Unliked successfully'){
                      if(widget.pageType == "TimeLineMyCampus"){
                        if(feedProvider.feedListMyCampus[widget.indexVal].isLiked.emojiValue==1){
                          feedProvider.feedListMyCampus[widget.indexVal].likeCount[1].count--;
                          feedProvider.feedListMyCampus[widget.indexVal].isLiked = null;
                        }else{
                          await FeedService().likeFeed(feedId, 1, token);
                          feedProvider.feedListMyCampus[widget.indexVal].likeCount[1].count++;
                          feedProvider.feedListMyCampus[widget.indexVal].isLiked = IsLiked(feedId: 0,userId: 0,id: 0,emojiValue: 1,createdAt: "",updatedAt: "");
                          feedProvider.feedListMyCampus[widget.indexVal].likeCount[0].count--;
                        }
                      }else if(widget.pageType == "TimeLineGlobal"){
                        if(feedProvider.feedList[widget.indexVal].isLiked.emojiValue==1){
                          feedProvider.feedList[widget.indexVal].likeCount[1].count--;
                          feedProvider.feedList[widget.indexVal].isLiked = null;
                        }else{
                          await FeedService().likeFeed(feedId, 1, token);
                          feedProvider.feedList[widget.indexVal].likeCount[1].count++;
                          feedProvider.feedList[widget.indexVal].isLiked = IsLiked(feedId: 0,userId: 0,id: 0,emojiValue: 1,createdAt: "",updatedAt: "");
                          feedProvider.feedList[widget.indexVal].likeCount[0].count--;
                        }
                      }else if(widget.pageType == "User"){
                        if(feedProvider.feedItemListOfUser[widget.indexVal].isLiked.emojiValue==1){
                          feedProvider.feedItemListOfUser[widget.indexVal].likeCount[1].count--;
                          feedProvider.feedItemListOfUser[widget.indexVal].isLiked = null;
                        }else{
                          await FeedService().likeFeed(feedId, 1, token);
                          feedProvider.feedItemListOfUser[widget.indexVal].likeCount[1].count++;
                          feedProvider.feedItemListOfUser[widget.indexVal].isLiked = IsLiked(feedId: 0,userId: 0,id: 0,emojiValue: 1,createdAt: "",updatedAt: "");
                          feedProvider.feedItemListOfUser[widget.indexVal].likeCount[0].count--;
                        }
                      }else if(widget.pageType == "Bookmark"){
                        if(feedProvider.bookmarkByUserData.data.feeds[widget.indexVal].isLiked.emojiValue==1){
                          feedProvider.bookmarkByUserData.data.feeds[widget.indexVal].likeCount[1].count--;
                          feedProvider.bookmarkByUserData.data.feeds[widget.indexVal].isLiked = null;
                        }else{
                          await FeedService().likeFeed(feedId, 1, token);
                          feedProvider.bookmarkByUserData.data.feeds[widget.indexVal].likeCount[1].count++;
                          feedProvider.bookmarkByUserData.data.feeds[widget.indexVal].isLiked = IsLiked(feedId: 0,userId: 0,id: 0,emojiValue: 1,createdAt: "",updatedAt: "");
                          feedProvider.bookmarkByUserData.data.feeds[widget.indexVal].likeCount[0].count--;
                        }
                      }else if(widget.pageType == "Search"){
                        if(feedProvider.feedItem[widget.indexVal].isLiked.emojiValue==1){
                          feedProvider.feedItem[widget.indexVal].likeCount[1].count--;
                          feedProvider.feedItem[widget.indexVal].isLiked = null;
                        }else{
                          await FeedService().likeFeed(feedId, 1, token);
                          feedProvider.feedItem[widget.indexVal].likeCount[1].count++;
                          feedProvider.feedItem[widget.indexVal].isLiked = IsLiked(feedId: 0,userId: 0,id: 0,emojiValue: 1,createdAt: "",updatedAt: "");
                          feedProvider.feedItem[widget.indexVal].likeCount[0].count--;
                        }
                      }else if(widget.pageType == "BookmarkMyCampus"){
                        if(feedProvider.bookmarkByUserDataMycampus.data.feeds[widget.indexVal].isLiked.emojiValue==1){
                          feedProvider.bookmarkByUserDataMycampus.data.feeds[widget.indexVal].likeCount[1].count--;
                          feedProvider.bookmarkByUserDataMycampus.data.feeds[widget.indexVal].isLiked = null;
                        }else{
                          await FeedService().likeFeed(feedId, 1, token);
                          feedProvider.bookmarkByUserDataMycampus.data.feeds[widget.indexVal].likeCount[1].count++;
                          feedProvider.bookmarkByUserDataMycampus.data.feeds[widget.indexVal].isLiked = IsLiked(feedId: 0,userId: 0,id: 0,emojiValue: 1,createdAt: "",updatedAt: "");
                          feedProvider.bookmarkByUserDataMycampus.data.feeds[widget.indexVal].likeCount[0].count--;
                        }
                      }
                    }
                    setState(() {});
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 25, left: 16),
                    height: 32,
                    width: 64,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: themeController.isDarkMode?MateColors.smallContainerDark:MateColors.smallContainerLight,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 1.4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "lib/asset/icons/heart.png",
                          width: 18,
                          height: 14,
                          fit: BoxFit.fitHeight,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          widget.pageType == "TimeLineMyCampus"?
                          feedProvider.feedListMyCampus[widget.indexVal].likeCount[1].count.toString():
                          widget.pageType == "TimeLineGlobal"?
                          feedProvider.feedList[widget.indexVal].likeCount[1].count.toString():
                          widget.pageType == "User"?
                          feedProvider.feedItemListOfUser[widget.indexVal].likeCount[1].count.toString():
                          widget.pageType == "Bookmark"?
                          feedProvider.bookmarkByUserData.data.feeds[widget.indexVal].likeCount[1].count.toString():
                          widget.pageType == "BookmarkMyCampus"?
                          feedProvider.bookmarkByUserDataMycampus.data.feeds[widget.indexVal].likeCount[1].count.toString():
                          widget.pageType == "Search"?
                          feedProvider.feedItem[widget.indexVal].likeCount[1].count.toString():
                          widget.likeCount[0].count.toString(),
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 15,
                            color: themeController.isDarkMode?Colors.white:Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    width: 5,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>
                          FeedComments(feedIndex: widget.indexVal, feedId: feedId,)));
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
                            widget.commentCount.toString(),
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
                ),
                Consumer<FeedProvider>(
                  builder: (context, value, child) {
                    if (value.feedItemsBookmarkData != null) {
                      if (widget.isBookmarkedPage && !bookMarked) {
                        value.bookmarkByUserData.data.feeds.removeAt(widget.indexVal);
                        Future.delayed(Duration.zero, () => Provider.of<FeedProvider>(context, listen: false).allBookmarkedFeed());
                      }
                    }
                    return Padding(
                      padding: const EdgeInsets.only(right: 16,left: 10,top: 25),
                      child: InkWell(
                        onTap: (){
                          Provider.of<FeedProvider>(context, listen: false).bookmarkAFeed(feedId, widget.indexVal);
                          setState(() {
                            bookMarked=!bookMarked;
                          });
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
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

  List _buildMedia(BuildContext context, List media) {
    List mda = [];
    for (int i = 0; i < media.length; i++) {
      mda.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 0.0, left: 14, right: 10, top: 10),
          child: ConstrainedBox(
            constraints: new BoxConstraints(
              minHeight: 50.0,
              maxHeight: 300.0,
            ),
            child: InkWell(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>MediaViewer(url: media[i].url,))),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                clipBehavior: Clip.hardEdge,
                child: Image.network(
                  media[i].url,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      );
    }
    return mda;
  }

  List _buildMediaOther(BuildContext context, List mediaOther) {
    List mda = [];
    for (int i = 0; i < mediaOther.length; i++) {
      mda.add(
        mediaOther[i].url.contains(".mp4")?
        VideoThumbnail(videoUrl: mediaOther[i].url):
        Container(
          height: 82,
          margin: EdgeInsets.only(top: 16,left: 16,right: 16),
          padding: EdgeInsets.only(left: 16,right: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: themeController.isDarkMode?Colors.white.withOpacity(0.06):MateColors.containerLight,
          ),
          child: Row(
            children: [
              Icon(Icons.multitrack_audio_sharp,color: themeController.isDarkMode ? Colors.white:Colors.black,),
              Icon(Icons.multitrack_audio_sharp,color: themeController.isDarkMode ? Colors.white:Colors.black,),
              Icon(Icons.multitrack_audio_sharp,color: themeController.isDarkMode ? Colors.white:Colors.black,),
              Icon(Icons.multitrack_audio_sharp,color: themeController.isDarkMode ? Colors.white:Colors.black,),
              Icon(Icons.multitrack_audio_sharp,color: themeController.isDarkMode ? Colors.white:Colors.black,),
              Icon(Icons.multitrack_audio_sharp,color: themeController.isDarkMode ? Colors.white:Colors.black,),
              Icon(Icons.multitrack_audio_sharp,color: themeController.isDarkMode ? Colors.white:Colors.black,),
              Icon(Icons.multitrack_audio_sharp,color: themeController.isDarkMode ? Colors.white:Colors.black,),
              SizedBox(width: 20,),
              GestureDetector(
                onTap: (){
                  if(widget.isLoadingAudio==false){
                    widget.isPlaying ? widget.pauseAudio(widget.indexVal): widget.startAudio(mediaOther[i].url,widget.indexVal);
                  }
                },
                child: Container(
                  height: 34,
                  width: 34,
                  margin: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: themeController.isDarkMode?Colors.white.withOpacity(0.23):Colors.white.withOpacity(0.5),
                  ),
                  alignment: Alignment.center,
                  child: widget.isLoadingAudio?
                  Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: themeController.isDarkMode? Colors.white : MateColors.blackTextColor,
                    ),
                  ):
                  Icon(
                    widget.isPlaying?
                    Icons.pause:Icons.play_arrow,
                    size: 25,
                    color: themeController.isDarkMode?Color(0xFF67AE8C):Color(0xFF049571),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return mda;
  }

  Widget _sharedWidget(IsShared isShared) {
    return Container(
      margin: EdgeInsets.only(left: 50.0, right: 8, bottom: 10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0), border: Border.all(color: MateColors.line, width: 1)),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        ListTile(
          contentPadding: EdgeInsets.fromLTRB(12, 4, 10, 0),
          leading: InkWell(
            onTap: () {
              if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == isShared.user.id) {
                Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
              } else {
                Navigator.of(context).pushNamed(UserProfileScreen.routeName,
                    arguments: {"id": isShared.user.id, "name": isShared.user.name, "photoUrl": isShared.user.photoUrl, "firebaseUid": isShared.user.firebaseUid});
              }
            },
            child: isShared.user.photoUrl.length == 0
                ? ClipOval(
                    child: Text(
                      isShared.user.name[0],
                    ),
                  )
                : ClipOval(
                    child: Image.network(
                      isShared.user.photoUrl,
                      height: 45,
                      width: 38,
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
          title: InkWell(
              onTap: () {
                if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == isShared.user.id) {
                  Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                } else {
                  Navigator.of(context).pushNamed(UserProfileScreen.routeName,
                      arguments: {"id": isShared.user.id, "name": isShared.user.name, "photoUrl": isShared.user.photoUrl, "firebaseUid": isShared.user.firebaseUid});
                }
              },
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      isShared.user.name,
                      style: TextStyle(fontFamily: 'Quicksand', color: Colors.white, fontSize: 13.2),
                      overflow: TextOverflow.clip,
                    ),
                  ),
                  Text(
                    ' $created',
                    style: TextStyle(color: Colors.white70, fontSize: 10),
                  ),
                ],
              )),
          subtitle: SizedBox(
            height: 27,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: isShared.feedTypes.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => HomeScreen(
                              index: 1,
                              feedTypeName: isShared.feedTypes[index].type.name,
                            )));
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    margin: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      color: MateColors.activeIcons,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      '${isShared.feedTypes[index].type.name}',
                      style: TextStyle(color: Colors.black, fontSize: 10),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, left: 60, right: 15),
          child: Text(isShared.title, textAlign: TextAlign.left, style: TextStyle(fontSize: 15.0, fontFamily: 'Quicksand', fontWeight: FontWeight.w700, color: MateColors.activeIcons)),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0, left: 60, right: 15),
          child: Text(
            isShared.description,
            style: TextStyle(color: Colors.white, fontSize: 12),
            textAlign: TextAlign.left,
          ),
        ),
        ..._buildMedia(context, isShared.media),
      ]),
    );
  }

  _showDeleteAlertDialog({@required int feedId, @required int indexVal,}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: new Text("Are you sure?"),
          content: new Text("You want to delete your post"),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text("Yes"),
              onPressed: () async {
                bool isDeleted = await feedProvider.deleteAFeed(feedId);
                if (isDeleted) {
                  Future.delayed(Duration(seconds: 0), () {
                    // Provider.of<FeedProvider>(context, listen: false).fetchCampusLivePostList();
                    // Navigator.pop(context);
                    if (widget.isBookmarkedPage) {
                      Navigator.pop(context);
                      feedProvider.allBookmarkedFeed();
                    } else {
                      Navigator.pop(context);
                      if (widget.previousPageFeedId == null) {
                       feedProvider.fetchFeedList(page: 1, userId: widget.previousPageUserId);
                       feedProvider.fetchFeedListMyCampus(page: 1, feedId: widget.previousPageFeedId);
                      } else {
                        feedProvider.fetchFeedList(page: 1, feedId: widget.previousPageFeedId);
                        feedProvider.fetchFeedListMyCampus(page: 1, feedId: widget.previousPageFeedId);
                      }
                    }
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

  _showFollowAlertDialog({@required int feedId, @required int indexVal,}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: new Text("Are you sure?"),
          content: new Text(widget.isFollowed?"You want to Unfollow this post":"You want to follow this post"),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: feedProvider.feedFollowLoader?
              Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
                  :Text("Yes"),
              onPressed: () async {
                if(widget.isFollowed){
                  Map<String, dynamic> body = {"post_id": widget.feedId, "post_type": "Feed"};
                  bool unFollowDone = await feedProvider.unFollowAFeed(body, widget.feedId);
                  if (unFollowDone) {
                    if (widget.isBookmarkedPage) {
                      feedProvider.bookmarkByUserData.data.feeds[widget.indexVal].isFollowed=false;
                    }else{
                      feedProvider.feedList[widget.indexVal].isFollowed=false;
                    }
                    widget.isFollowed=false;
                    Navigator.pop(context);
                  }
                }else{
                  Map<String, dynamic> body = {"post_id": widget.feedId, "post_type": "Feed"};
                  bool followDone = await feedProvider.followAFeed(body, widget.feedId);
                  if (followDone) {
                    if (widget.isBookmarkedPage) {
                      feedProvider.bookmarkByUserData.data.feeds[widget.indexVal].isFollowed=true;
                    }else{
                      feedProvider.feedList[widget.indexVal].isFollowed=true;
                    }
                    widget.isFollowed=true;
                    Navigator.pop(context);
                  }
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

  insertEvent(event) {
    try {
      const _scopes = const [gCal.CalendarApi.calendarScope];
      clientViaUserConsent(_credentials, _scopes, prompt).then((AuthClient client) {
        var calendar = gCal.CalendarApi(client);
        String calendarId = "primary";
        calendar.events.insert(event, calendarId).then((value) {
          print("ADDEDDD_________________${value.status}");
          if (value.status == "confirmed") {
            print('Event added in google calendar');
          } else {
            print("Unable to add event in google calendar");
          }
        });
      });
    } catch (e) {
      print('Error creating event $e');
    }
  }

  void prompt(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class HomeRowForFeedDetails extends StatefulWidget {
  String previousPageUserId;
  String previousPageFeedId;
  String id;
  int feedId;
  String title;
  String start;
  String end;
  String calenderDate;
  String description;
  String created;
  var user;
  String location;
  String hyperlinkText;
  String hyperlink;
  List media;
  final List mediaOther;
  bool bookMarked;
  bool isFollowed;
  IsLiked isLiked;
  bool liked;
  List feedType;
  int indexVal;
  bool isBookmarkedPage;
  bool isFeedDetailsPage;
  List<LikeCount> likeCount;
  int bookmarkCount;
  int shareCount;
  int commentCount;
  IsShared isShared;
  bool navigateToDetailsPage;
  String pageType;

  HomeRowForFeedDetails(
      {this.previousPageUserId,
        this.previousPageFeedId,
        this.id,
        this.feedId,
        this.title,
        this.feedType,
        this.start,
        this.end,
        this.calenderDate,
        this.description,
        this.created,
        this.user,
        this.location,
        this.hyperlinkText,
        this.hyperlink,
        this.media,
        this.isLiked,
        this.liked,
        this.bookMarked,
        this.isFollowed=false,
        this.indexVal,
        this.likeCount,
        this.bookmarkCount,
        this.commentCount,
        this.shareCount,
        this.isBookmarkedPage = false,
        this.isFeedDetailsPage = false,
        this.navigateToDetailsPage = true,
        this.pageType,
        this.isShared, this.mediaOther});

  @override
  _HomeRowForFeedDetailsState createState() =>
      _HomeRowForFeedDetailsState(this.id, this.feedId, this.title, this.feedType, this.start, this.end, this.calenderDate, this.description, this.created, this.user, this.location, this.media, this.liked, this.bookMarked,this.mediaOther);
}

class _HomeRowForFeedDetailsState extends State<HomeRowForFeedDetails> with SingleTickerProviderStateMixin {
  final String id;
  final int feedId;
  final String title;
  final String startTime;
  final String endTime;
  final String calenderDate;
  final String description;
  final String created;
  var user;
  final String location;
  final List media;
  final List mediaOther;
  final List feedType;
  bool bookMarked;
  bool liked;
  auth.User _currentUser = auth.FirebaseAuth.instance.currentUser;
  _HomeRowForFeedDetailsState(this.id, this.feedId, this.title, this.feedType, this.startTime, this.endTime, this.calenderDate, this.description, this.created, this.user, this.location, this.media, this.liked, this.bookMarked, this.mediaOther);

  ClientId _credentials;
  IsLiked isLiked;
  ThemeController themeController = Get.find<ThemeController>();
  String token;
  FeedProvider feedProvider;

  @override
  void initState() {
    isLiked = widget.isLiked;
    feedProvider = Provider.of<FeedProvider>(context, listen: false);
    super.initState();
    getStoredValue();
    super.initState();
    if (Platform.isAndroid) {
      _credentials = new ClientId("237545926078-9biln72s9c5h9vot53l84me39unhhnbf.apps.googleusercontent.com", "");
    } else if (Platform.isIOS) {
      _credentials = new ClientId("237545926078-99q5c35ugs0b49spmhf1ru0ghie7opnp.apps.googleusercontent.com", "");
    }
  }

  getStoredValue()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token");
  }

  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  bool isPause = false;
  bool isLoadingAudio = false;

  Future<void> startAudio(String url) async {
    if(isPause==true){
      isPlaying = false;
      isPause = false;
      audioPlayer.play();
      setState(() {
        isPlaying = true;
      });
      audioPlayer.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          setState(() {
            isPlaying = false;
            isPause = false;
          });
        }
      });

      audioPlayer.positionStream.listen((event) {
        setState(() {
          // currentDuration = event;
        });
      });

    }else{
      try{
        audioPlayer.playerStateStream.listen((state) {
          if (state.processingState == ProcessingState.completed) {
            setState(() {
              isPlaying = false;
              isPause = false;
            });
          }
        });

        audioPlayer.positionStream.listen((event) {
          setState(() {
            //currentDuration = event;
          });
        });

        audioPlayer.stop();
        for(int i=0;i<feedProvider.feedList.length;i++){
          feedProvider.feedList[i].isPlaying = false;
        }
        setState(() {});

        var dir = await getApplicationDocumentsDirectory();
        var filePathAndName = dir.path + "/audios/" +url.split("/").last + ".mp3";
        if(File(filePathAndName).existsSync()){
          print("------File Already Exist-------");
          print(filePathAndName);
          await audioPlayer.setFilePath(filePathAndName);
          audioPlayer.play();
          setState(() {
            isPlaying = true;
          });
        }else{
          setState(() {
            isLoadingAudio = true;
          });

          String path = await downloadAudio(url);

          setState(() {
           isLoadingAudio = false;
          });

          if(path !=""){
            await audioPlayer.setFilePath(path);
            audioPlayer.play();
            setState(() {
              isPlaying = true;
            });
          }else{
            Fluttertoast.showToast(msg: "Something went wrong while playing audio please try again!", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
          }
        }

      }catch(e){
        print("Error loading audio source: $e");
      }
    }
  }

  void pauseAudio(int index)async{
    audioPlayer.pause();
    setState(() {
      isPlaying = false;
      isPause = true;
    });
  }

  Future<String> downloadAudio(String url)async{
    var dir = await getApplicationDocumentsDirectory();
    var firstPath = dir.path + "/audios";
    var filePathAndName = dir.path + "/audios/" +url.split("/").last + ".mp3";
    await Directory(firstPath).create(recursive: true);
    File file = new File(filePathAndName);
    try{
      var request = await http.get(Uri.parse(url));
      print(request.statusCode);
      var res = await file.writeAsBytes(request.bodyBytes);
      print("---File Path----");
      print(res.path);
      return res.path;
    }catch(e){
      print(e);
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            dense: true,
            horizontalTitleGap: 10,
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: (){
                    Get.back();
                  },
                  child: Icon(Icons.arrow_back,color: MateColors.activeIcons,),
                ),
                SizedBox(width: 15,),
                InkWell(
                  onTap: () {
                    if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == user.id) {
                      Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                    } else {
                      Navigator.of(context).pushNamed(UserProfileScreen.routeName, arguments: {"id": user.id, "name": user.name, "photoUrl": user.photoUrl, "firebaseUid": user.firebaseUid});
                    }
                  },
                  child: user.photoUrl.length == 0 ?
                  CircleAvatar(
                    radius: 20,
                    child: Text(
                      user.name[0],
                    ),
                  ):
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                      user.photoUrl,
                    ),
                  ),
                ),
              ],
            ),
            title: InkWell(
              onTap: () {
                if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == user.id) {
                  Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                } else {
                  Navigator.of(context).pushNamed(UserProfileScreen.routeName, arguments: {"id": user.id, "name": user.name, "photoUrl": user.photoUrl, "firebaseUid": user.firebaseUid});
                }
              },
              child: Text(
                user.name,
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  color: themeController.isDarkMode?Colors.white:Colors.black,
                ),
              ),
            ),
            subtitle: Text(
              "$created",
              style: TextStyle(
                fontSize: 14,
                color: themeController.isDarkMode?MateColors.helpingTextDark:Colors.black.withOpacity(0.72),
              ),
            ),
            trailing: PopupMenuButton<int>(
                padding: EdgeInsets.zero,
                elevation: 0,
                color: themeController.isDarkMode?MateColors.popupDark:MateColors.popupLight,
                icon: Icon(
                  Icons.more_vert,
                  color: themeController.isDarkMode?Colors.white:MateColors.blackText,
                ),
                onSelected: (index) async {
                  if (index == 0) {
                    gCal.Event event = gCal.Event(); // Create object of event
                    event.summary = title; //Setting summary of object
                    event.description = description; //Setting summary of object

                    gCal.EventDateTime start = new gCal.EventDateTime(); //Setting start time
                    start.dateTime = DateTime.parse(calenderDate).toLocal();
                    start.timeZone = "GMT+05:00";
                    event.start = start;

                    gCal.EventDateTime end = new gCal.EventDateTime(); //setting end time
                    end.timeZone = "GMT+05:00";
                    end.dateTime = DateTime.parse(calenderDate).toLocal();
                    event.end = end;

                    insertEvent(event);
                  } else if (index == 1) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Chat(peerUuid: user.id, currentUserId: _currentUser.uid, peerId: user.firebaseUid, peerAvatar: user.photoUrl, peerName: user.name)));
                  } else if (index == 2) {
                    _showFollowAlertDialog(feedId: widget.feedId, indexVal: widget.indexVal);
                  } else if (index == 4) {
                    _showDeleteAlertDialog(feedId: widget.feedId, indexVal: widget.indexVal);
                  } else if (index == 5) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReportPage(
                            moduleId: widget.feedId,
                            moduleType: "Feed",
                          ),
                        ));
                  }
                },
                itemBuilder: (context) => [
                  // PopupMenuItem(
                  //   value: 0,
                  //   height: 40,
                  //   child: Text(
                  //     "Calendar",
                  //     textAlign: TextAlign.start,
                  //     style: TextStyle(
                  //       color: themeController.isDarkMode?Colors.white:Colors.black,
                  //       fontWeight: FontWeight.w500,
                  //       fontFamily: 'Poppins',
                  //       fontSize: 14,
                  //     ),
                  //   ),
                  // ),
                  PopupMenuItem(
                    value: 1,
                    height: 40,
                    child: Text(
                      "Message",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: themeController.isDarkMode?Colors.white:Colors.black,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                        fontSize: 14,
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    value: 2,
                    height: 40,
                    child: Text(
                      widget.isFollowed?"Unfollow Post":"Follow Post",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: themeController.isDarkMode?Colors.white:Colors.black,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                        fontSize: 14,
                      ),
                    ),
                  ),
                ]
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
            height: 39,
            margin: EdgeInsets.only(left: 16,top: 6),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: feedType.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: InkWell(
                  onTap: () {
                    final page = FeedSearch(text: feedType[index].type.name,);
                    Navigator.push(context,MaterialPageRoute(builder: (context) => page ));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: themeController.isDarkMode?MateColors.smallContainerDark:MateColors.smallContainerLight,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15,right: 15),
                      child: Center(
                        child: Text("${feedType[index].type.name}",
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
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16,top: 20),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    color: themeController.isDarkMode?Colors.white:Colors.black,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 16,top: 10,right: 10),
            child: Linkify(
              onOpen: (link) async {
                print("Clicked ${link.url}!");
                if (await canLaunch(link.url))
                  await launch(link.url);
                else
                  throw "Could not launch ${link.url}";
              },
              text: description,
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                letterSpacing: 0.1,
                color: themeController.isDarkMode?Colors.white:Colors.black,
              ),
              textAlign: TextAlign.left,
              linkStyle: TextStyle(
                fontSize: 14,
                fontFamily: 'Poppins',
                color: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
              ),
            ),
          ),
          widget.hyperlinkText!=null && widget.hyperlink!=null ?
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () async{
              if (await canLaunch(widget.hyperlink))
                await launch(widget.hyperlink);
              else
                Fluttertoast.showToast(msg: " Could not launch given URL '${widget.hyperlink}'", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
              throw "Could not launch ${widget.hyperlink}";
            },
            child: Padding(
              padding: EdgeInsets.only(left: 16,top: 10,right: 10),
              child: Text(
                widget.hyperlinkText,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  color: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                ),
              ),
            ),
          ):SizedBox(),
          ..._buildMedia(context, media),
          ..._buildMediaOther(context, mediaOther),
          widget.isShared != null ? _sharedWidget(widget.isShared) : SizedBox(),
          location!=null?
          Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 16, bottom: 5),
            child: Row(
              children: [
                Icon(
                  Icons.location_on_sharp,
                  size: 25,
                  color: themeController.isDarkMode?Colors.white:Colors.black,
                ),
                Expanded(
                  child: Text(
                    ' $location',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      color: themeController.isDarkMode?Colors.white.withOpacity(0.7):Colors.black.withOpacity(0.7),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ):SizedBox(),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: (){
                    if(widget.pageType == "TimeLineMyCampus"){
                      if(feedProvider.feedListMyCampus[widget.indexVal].likeCount[0].count!=0 || feedProvider.feedListMyCampus[widget.indexVal].likeCount[1].count!=0){
                        Get.to(() => FeedLikesDetails(feedId: widget.feedId,));
                      }
                    }else if(widget.pageType == "TimeLineGlobal"){
                      if(feedProvider.feedList[widget.indexVal].likeCount[0].count!=0 || feedProvider.feedList[widget.indexVal].likeCount[1].count!=0){
                        Get.to(() => FeedLikesDetails(feedId: widget.feedId,));
                      }
                    }else if(widget.pageType == "User"){
                      if(feedProvider.feedItemListOfUser[widget.indexVal].likeCount[0].count!=0 || feedProvider.feedItemListOfUser[widget.indexVal].likeCount[1].count!=0){
                        Get.to(() => FeedLikesDetails(feedId: widget.feedId,));
                      }
                    }else if(widget.pageType == "Bookmark"){
                      if(feedProvider.bookmarkByUserData.data.feeds[widget.indexVal].likeCount[0].count!=0 || feedProvider.bookmarkByUserData.data.feeds[widget.indexVal].likeCount[1].count!=0){
                        Get.to(() => FeedLikesDetails(feedId: widget.feedId,));
                      }
                    }else if(widget.pageType == "Search"){
                      if(feedProvider.feedItem[widget.indexVal].likeCount[0].count!=0 || feedProvider.feedItem[widget.indexVal].likeCount[1].count!=0){
                        Get.to(() => FeedLikesDetails(feedId: widget.feedId,));
                      }
                    }else if(widget.pageType == "BookmarkMyCampus"){
                      if(feedProvider.bookmarkByUserDataMycampus.data.feeds[widget.indexVal].likeCount[0].count!=0 || feedProvider.bookmarkByUserDataMycampus.data.feeds[widget.indexVal].likeCount[1].count!=0){
                        Get.to(() => FeedLikesDetails(feedId: widget.feedId,));
                      }
                    }
                  },
                  onDoubleTap: ()async{
                    print(widget.pageType);
                    String response = await FeedService().likeFeed(feedId, 0, token);
                    if(response == "Feed Liked successfully"){
                      if(widget.pageType == "TimeLineMyCampus"){
                        feedProvider.feedListMyCampus[widget.indexVal].likeCount[0].count++;
                        feedProvider.feedListMyCampus[widget.indexVal].isLiked = IsLiked(feedId: 0,userId: 0,id: 0,emojiValue: 0,createdAt: "",updatedAt: "");
                      }else if(widget.pageType == "TimeLineGlobal"){
                        feedProvider.feedList[widget.indexVal].likeCount[0].count++;
                        feedProvider.feedList[widget.indexVal].isLiked = IsLiked(feedId: 0,userId: 0,id: 0,emojiValue: 0,createdAt: "",updatedAt: "");
                      }else if(widget.pageType == "User"){
                        feedProvider.feedItemListOfUser[widget.indexVal].likeCount[0].count++;
                        feedProvider.feedItemListOfUser[widget.indexVal].isLiked = IsLiked(feedId: 0,userId: 0,id: 0,emojiValue: 0,createdAt: "",updatedAt: "");
                      }else if(widget.pageType == "Bookmark"){
                        feedProvider.bookmarkByUserData.data.feeds[widget.indexVal].likeCount[0].count++;
                        feedProvider.bookmarkByUserData.data.feeds[widget.indexVal].isLiked = IsLiked(feedId: 0,userId: 0,id: 0,emojiValue: 0,createdAt: "",updatedAt: "");
                      }else if(widget.pageType == "Search"){
                        feedProvider.feedItem[widget.indexVal].likeCount[0].count++;
                        feedProvider.feedItem[widget.indexVal].isLiked = IsLiked(feedId: 0,userId: 0,id: 0,emojiValue: 0,createdAt: "",updatedAt: "");
                      }else if(widget.pageType == "BookmarkMyCampus"){
                        feedProvider.bookmarkByUserDataMycampus.data.feeds[widget.indexVal].likeCount[0].count++;
                        feedProvider.bookmarkByUserDataMycampus.data.feeds[widget.indexVal].isLiked = IsLiked(feedId: 0,userId: 0,id: 0,emojiValue: 0,createdAt: "",updatedAt: "");
                      }
                    }else if(response == 'Feed Unliked successfully'){
                      if(widget.pageType == "TimeLineMyCampus"){
                        if(feedProvider.feedListMyCampus[widget.indexVal].isLiked.emojiValue==0){
                          feedProvider.feedListMyCampus[widget.indexVal].likeCount[0].count--;
                          feedProvider.feedListMyCampus[widget.indexVal].isLiked = null;
                        }else{
                          await FeedService().likeFeed(feedId, 0, token);
                          feedProvider.feedListMyCampus[widget.indexVal].likeCount[0].count++;
                          feedProvider.feedListMyCampus[widget.indexVal].isLiked = IsLiked(feedId: 0,userId: 0,id: 0,emojiValue: 0,createdAt: "",updatedAt: "");
                          feedProvider.feedListMyCampus[widget.indexVal].likeCount[1].count--;
                        }
                      }else if(widget.pageType == "TimeLineGlobal"){
                        if(feedProvider.feedList[widget.indexVal].isLiked.emojiValue==0){
                          feedProvider.feedList[widget.indexVal].likeCount[0].count--;
                          feedProvider.feedList[widget.indexVal].isLiked = null;
                        }else{
                          await FeedService().likeFeed(feedId, 0, token);
                          feedProvider.feedList[widget.indexVal].likeCount[0].count++;
                          feedProvider.feedList[widget.indexVal].isLiked = IsLiked(feedId: 0,userId: 0,id: 0,emojiValue: 0,createdAt: "",updatedAt: "");
                          feedProvider.feedList[widget.indexVal].likeCount[1].count--;
                        }
                      }else if(widget.pageType == "User"){
                        if(feedProvider.feedItemListOfUser[widget.indexVal].isLiked.emojiValue==0){
                          feedProvider.feedItemListOfUser[widget.indexVal].likeCount[0].count--;
                          feedProvider.feedItemListOfUser[widget.indexVal].isLiked = null;
                        }else{
                          await FeedService().likeFeed(feedId, 0, token);
                          feedProvider.feedItemListOfUser[widget.indexVal].likeCount[0].count++;
                          feedProvider.feedItemListOfUser[widget.indexVal].isLiked = IsLiked(feedId: 0,userId: 0,id: 0,emojiValue: 0,createdAt: "",updatedAt: "");
                          feedProvider.feedItemListOfUser[widget.indexVal].likeCount[1].count--;
                        }
                      }else if(widget.pageType == "Bookmark"){
                        if(feedProvider.bookmarkByUserData.data.feeds[widget.indexVal].isLiked.emojiValue==0){
                          feedProvider.bookmarkByUserData.data.feeds[widget.indexVal].likeCount[0].count--;
                          feedProvider.bookmarkByUserData.data.feeds[widget.indexVal].isLiked = null;
                        }else{
                          await FeedService().likeFeed(feedId, 0, token);
                          feedProvider.bookmarkByUserData.data.feeds[widget.indexVal].likeCount[0].count++;
                          feedProvider.bookmarkByUserData.data.feeds[widget.indexVal].isLiked = IsLiked(feedId: 0,userId: 0,id: 0,emojiValue: 0,createdAt: "",updatedAt: "");
                          feedProvider.bookmarkByUserData.data.feeds[widget.indexVal].likeCount[1].count--;
                        }
                      }else if(widget.pageType == "Search"){
                        if(feedProvider.feedItem[widget.indexVal].isLiked.emojiValue==0){
                          feedProvider.feedItem[widget.indexVal].likeCount[0].count--;
                          feedProvider.feedItem[widget.indexVal].isLiked = null;
                        }else{
                          await FeedService().likeFeed(feedId, 0, token);
                          feedProvider.feedItem[widget.indexVal].likeCount[0].count++;
                          feedProvider.feedItem[widget.indexVal].isLiked = IsLiked(feedId: 0,userId: 0,id: 0,emojiValue: 0,createdAt: "",updatedAt: "");
                          feedProvider.feedItem[widget.indexVal].likeCount[1].count--;
                        }
                      }else if(widget.pageType == "BookmarkMyCampus"){
                        if(feedProvider.bookmarkByUserDataMycampus.data.feeds[widget.indexVal].isLiked.emojiValue==0){
                          feedProvider.bookmarkByUserDataMycampus.data.feeds[widget.indexVal].likeCount[0].count--;
                          feedProvider.bookmarkByUserDataMycampus.data.feeds[widget.indexVal].isLiked = null;
                        }else{
                          await FeedService().likeFeed(feedId, 0, token);
                          feedProvider.bookmarkByUserDataMycampus.data.feeds[widget.indexVal].likeCount[0].count++;
                          feedProvider.bookmarkByUserDataMycampus.data.feeds[widget.indexVal].isLiked = IsLiked(feedId: 0,userId: 0,id: 0,emojiValue: 0,createdAt: "",updatedAt: "");
                          feedProvider.bookmarkByUserDataMycampus.data.feeds[widget.indexVal].likeCount[1].count--;
                        }
                      }
                    }
                    setState(() {});
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 25, left: 16),
                    height: 32,
                    width: 64,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: themeController.isDarkMode?MateColors.smallContainerDark:MateColors.smallContainerLight,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 1.4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "lib/asset/Reactions/clapping1.png",
                          width: 18,
                          height: 14,
                          fit: BoxFit.fitHeight,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          widget.pageType == "TimeLineMyCampus"?
                          feedProvider.feedListMyCampus[widget.indexVal].likeCount[0].count.toString():
                          widget.pageType == "TimeLineGlobal"?
                          feedProvider.feedList[widget.indexVal].likeCount[0].count.toString():
                          widget.pageType == "User"?
                          feedProvider.feedItemListOfUser[widget.indexVal].likeCount[0].count.toString():
                          widget.pageType == "Bookmark"?
                          feedProvider.bookmarkByUserData.data.feeds[widget.indexVal].likeCount[0].count.toString():
                          widget.pageType == "BookmarkMyCampus"?
                          feedProvider.bookmarkByUserDataMycampus.data.feeds[widget.indexVal].likeCount[0].count.toString():
                          widget.pageType == "Search"?
                          feedProvider.feedItem[widget.indexVal].likeCount[0].count.toString():
                          widget.likeCount[0].count.toString(),
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 15,
                            color: themeController.isDarkMode?Colors.white:Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    if(widget.pageType == "TimeLineMyCampus"){
                      if(feedProvider.feedListMyCampus[widget.indexVal].likeCount[0].count!=0 || feedProvider.feedListMyCampus[widget.indexVal].likeCount[1].count!=0){
                        Get.to(() => FeedLikesDetails(feedId: widget.feedId,));
                      }
                    }else if(widget.pageType == "TimeLineGlobal"){
                      if(feedProvider.feedList[widget.indexVal].likeCount[0].count!=0 || feedProvider.feedList[widget.indexVal].likeCount[1].count!=0){
                        Get.to(() => FeedLikesDetails(feedId: widget.feedId,));
                      }
                    }else if(widget.pageType == "User"){
                      if(feedProvider.feedItemListOfUser[widget.indexVal].likeCount[0].count!=0 || feedProvider.feedItemListOfUser[widget.indexVal].likeCount[1].count!=0){
                        Get.to(() => FeedLikesDetails(feedId: widget.feedId,));
                      }
                    }else if(widget.pageType == "Bookmark"){
                      if(feedProvider.bookmarkByUserData.data.feeds[widget.indexVal].likeCount[0].count!=0 || feedProvider.bookmarkByUserData.data.feeds[widget.indexVal].likeCount[1].count!=0){
                        Get.to(() => FeedLikesDetails(feedId: widget.feedId,));
                      }
                    }else if(widget.pageType == "Search"){
                      if(feedProvider.feedItem[widget.indexVal].likeCount[0].count!=0 || feedProvider.feedItem[widget.indexVal].likeCount[1].count!=0){
                        Get.to(() => FeedLikesDetails(feedId: widget.feedId,));
                      }
                    }else if(widget.pageType == "BookmarkMyCampus"){
                      if(feedProvider.bookmarkByUserDataMycampus.data.feeds[widget.indexVal].likeCount[0].count!=0 || feedProvider.bookmarkByUserDataMycampus.data.feeds[widget.indexVal].likeCount[1].count!=0){
                        Get.to(() => FeedLikesDetails(feedId: widget.feedId,));
                      }
                    }
                  },
                  onDoubleTap: ()async{
                    print(widget.pageType);
                    String response = await FeedService().likeFeed(feedId, 1, token);
                    if(response == "Feed Liked successfully"){
                      if(widget.pageType == "TimeLineMyCampus"){
                        feedProvider.feedListMyCampus[widget.indexVal].likeCount[1].count++;
                        feedProvider.feedListMyCampus[widget.indexVal].isLiked = IsLiked(feedId: 0,userId: 0,id: 0,emojiValue: 1,createdAt: "",updatedAt: "");
                      }else if(widget.pageType == "TimeLineGlobal"){
                        feedProvider.feedList[widget.indexVal].likeCount[1].count++;
                        feedProvider.feedList[widget.indexVal].isLiked = IsLiked(feedId: 0,userId: 0,id: 0,emojiValue: 1,createdAt: "",updatedAt: "");
                      }else if(widget.pageType == "User"){
                        feedProvider.feedItemListOfUser[widget.indexVal].likeCount[1].count++;
                        feedProvider.feedItemListOfUser[widget.indexVal].isLiked = IsLiked(feedId: 0,userId: 0,id: 0,emojiValue: 1,createdAt: "",updatedAt: "");
                      }else if(widget.pageType == "Bookmark"){
                        feedProvider.bookmarkByUserData.data.feeds[widget.indexVal].likeCount[1].count++;
                        feedProvider.bookmarkByUserData.data.feeds[widget.indexVal].isLiked = IsLiked(feedId: 0,userId: 0,id: 0,emojiValue: 1,createdAt: "",updatedAt: "");
                      }else if(widget.pageType == "Search"){
                        feedProvider.feedItem[widget.indexVal].likeCount[1].count++;
                        feedProvider.feedItem[widget.indexVal].isLiked = IsLiked(feedId: 0,userId: 0,id: 0,emojiValue: 1,createdAt: "",updatedAt: "");
                      }else if(widget.pageType == "BookmarkMyCampus"){
                        feedProvider.bookmarkByUserDataMycampus.data.feeds[widget.indexVal].likeCount[1].count++;
                        feedProvider.bookmarkByUserDataMycampus.data.feeds[widget.indexVal].isLiked = IsLiked(feedId: 0,userId: 0,id: 0,emojiValue: 1,createdAt: "",updatedAt: "");
                      }
                    }else if(response == 'Feed Unliked successfully'){
                      if(widget.pageType == "TimeLineMyCampus"){
                        if(feedProvider.feedListMyCampus[widget.indexVal].isLiked.emojiValue==1){
                          feedProvider.feedListMyCampus[widget.indexVal].likeCount[1].count--;
                          feedProvider.feedListMyCampus[widget.indexVal].isLiked = null;
                        }else{
                          await FeedService().likeFeed(feedId, 1, token);
                          feedProvider.feedListMyCampus[widget.indexVal].likeCount[1].count++;
                          feedProvider.feedListMyCampus[widget.indexVal].isLiked = IsLiked(feedId: 0,userId: 0,id: 0,emojiValue: 1,createdAt: "",updatedAt: "");
                          feedProvider.feedListMyCampus[widget.indexVal].likeCount[0].count--;
                        }
                      }else if(widget.pageType == "TimeLineGlobal"){
                        if(feedProvider.feedList[widget.indexVal].isLiked.emojiValue==1){
                          feedProvider.feedList[widget.indexVal].likeCount[1].count--;
                          feedProvider.feedList[widget.indexVal].isLiked = null;
                        }else{
                          await FeedService().likeFeed(feedId, 1, token);
                          feedProvider.feedList[widget.indexVal].likeCount[1].count++;
                          feedProvider.feedList[widget.indexVal].isLiked = IsLiked(feedId: 0,userId: 0,id: 0,emojiValue: 1,createdAt: "",updatedAt: "");
                          feedProvider.feedList[widget.indexVal].likeCount[0].count--;
                        }
                      }else if(widget.pageType == "User"){
                        if(feedProvider.feedItemListOfUser[widget.indexVal].isLiked.emojiValue==1){
                          feedProvider.feedItemListOfUser[widget.indexVal].likeCount[1].count--;
                          feedProvider.feedItemListOfUser[widget.indexVal].isLiked = null;
                        }else{
                          await FeedService().likeFeed(feedId, 1, token);
                          feedProvider.feedItemListOfUser[widget.indexVal].likeCount[1].count++;
                          feedProvider.feedItemListOfUser[widget.indexVal].isLiked = IsLiked(feedId: 0,userId: 0,id: 0,emojiValue: 1,createdAt: "",updatedAt: "");
                          feedProvider.feedItemListOfUser[widget.indexVal].likeCount[0].count--;
                        }
                      }else if(widget.pageType == "Bookmark"){
                        if(feedProvider.bookmarkByUserData.data.feeds[widget.indexVal].isLiked.emojiValue==1){
                          feedProvider.bookmarkByUserData.data.feeds[widget.indexVal].likeCount[1].count--;
                          feedProvider.bookmarkByUserData.data.feeds[widget.indexVal].isLiked = null;
                        }else{
                          await FeedService().likeFeed(feedId, 1, token);
                          feedProvider.bookmarkByUserData.data.feeds[widget.indexVal].likeCount[1].count++;
                          feedProvider.bookmarkByUserData.data.feeds[widget.indexVal].isLiked = IsLiked(feedId: 0,userId: 0,id: 0,emojiValue: 1,createdAt: "",updatedAt: "");
                          feedProvider.bookmarkByUserData.data.feeds[widget.indexVal].likeCount[0].count--;
                        }
                      }else if(widget.pageType == "Search"){
                        if(feedProvider.feedItem[widget.indexVal].isLiked.emojiValue==1){
                          feedProvider.feedItem[widget.indexVal].likeCount[1].count--;
                          feedProvider.feedItem[widget.indexVal].isLiked = null;
                        }else{
                          await FeedService().likeFeed(feedId, 1, token);
                          feedProvider.feedItem[widget.indexVal].likeCount[1].count++;
                          feedProvider.feedItem[widget.indexVal].isLiked = IsLiked(feedId: 0,userId: 0,id: 0,emojiValue: 1,createdAt: "",updatedAt: "");
                          feedProvider.feedItem[widget.indexVal].likeCount[0].count--;
                        }
                      }else if(widget.pageType == "BookmarkMyCampus"){
                        if(feedProvider.bookmarkByUserDataMycampus.data.feeds[widget.indexVal].isLiked.emojiValue==1){
                          feedProvider.bookmarkByUserDataMycampus.data.feeds[widget.indexVal].likeCount[1].count--;
                          feedProvider.bookmarkByUserDataMycampus.data.feeds[widget.indexVal].isLiked = null;
                        }else{
                          await FeedService().likeFeed(feedId, 1, token);
                          feedProvider.bookmarkByUserDataMycampus.data.feeds[widget.indexVal].likeCount[1].count++;
                          feedProvider.bookmarkByUserDataMycampus.data.feeds[widget.indexVal].isLiked = IsLiked(feedId: 0,userId: 0,id: 0,emojiValue: 1,createdAt: "",updatedAt: "");
                          feedProvider.bookmarkByUserDataMycampus.data.feeds[widget.indexVal].likeCount[0].count--;
                        }
                      }
                    }
                    setState(() {});
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 25, left: 16),
                    height: 32,
                    width: 64,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: themeController.isDarkMode?MateColors.smallContainerDark:MateColors.smallContainerLight,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 1.4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "lib/asset/icons/heart.png",
                          width: 18,
                          height: 14,
                          fit: BoxFit.fitHeight,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          widget.pageType == "TimeLineMyCampus"?
                          feedProvider.feedListMyCampus[widget.indexVal].likeCount[1].count.toString():
                          widget.pageType == "TimeLineGlobal"?
                          feedProvider.feedList[widget.indexVal].likeCount[1].count.toString():
                          widget.pageType == "User"?
                          feedProvider.feedItemListOfUser[widget.indexVal].likeCount[1].count.toString():
                          widget.pageType == "Bookmark"?
                          feedProvider.bookmarkByUserData.data.feeds[widget.indexVal].likeCount[1].count.toString():
                          widget.pageType == "BookmarkMyCampus"?
                          feedProvider.bookmarkByUserDataMycampus.data.feeds[widget.indexVal].likeCount[1].count.toString():
                          widget.pageType == "Search"?
                          feedProvider.feedItem[widget.indexVal].likeCount[1].count.toString():
                          widget.likeCount[0].count.toString(),
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 15,
                            color: themeController.isDarkMode?Colors.white:Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    width: 5,
                  ),
                ),
                Consumer<FeedProvider>(
                  builder: (context, value, child) {
                    if (value.feedItemsBookmarkData != null) {
                      if (widget.isBookmarkedPage && !bookMarked) {
                        value.bookmarkByUserData.data.feeds.removeAt(widget.indexVal);
                        Future.delayed(Duration.zero, () => Provider.of<FeedProvider>(context, listen: false).allBookmarkedFeed());
                      }
                    }
                    return Padding(
                      padding: const EdgeInsets.only(right: 16,left: 10,top: 25),
                      child: InkWell(
                        onTap: (){
                          Provider.of<FeedProvider>(context, listen: false).bookmarkAFeed(feedId, widget.indexVal);
                          setState(() {
                            bookMarked=!bookMarked;
                          });
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
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

  List _buildMedia(BuildContext context, List media) {
    List mda = [];
    for (int i = 0; i < media.length; i++) {
      mda.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 0.0, left: 14, right: 10, top: 10),
          child: ConstrainedBox(
            constraints: new BoxConstraints(
              minHeight: 50.0,
              maxHeight: 300.0,
            ),
            child: InkWell(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>MediaViewer(url: media[i].url,))),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                clipBehavior: Clip.hardEdge,
                child: Image.network(
                  media[i].url,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      );
    }
    return mda;
  }

  List _buildMediaOther(BuildContext context, List mediaOther) {
    List mda = [];
    for (int i = 0; i < mediaOther.length; i++) {
      mda.add(
        mediaOther[i].url.contains(".mp4")?
        VideoThumbnail(videoUrl: mediaOther[i].url):
        Container(
          height: 82,
          margin: EdgeInsets.only(top: 16,left: 16,right: 16),
          padding: EdgeInsets.only(left: 16,right: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: themeController.isDarkMode?Colors.white.withOpacity(0.06):MateColors.containerLight,
          ),
          child: Row(
            children: [
              Icon(Icons.multitrack_audio_sharp,color: themeController.isDarkMode ? Colors.white:Colors.black,),
              Icon(Icons.multitrack_audio_sharp,color: themeController.isDarkMode ? Colors.white:Colors.black,),
              Icon(Icons.multitrack_audio_sharp,color: themeController.isDarkMode ? Colors.white:Colors.black,),
              Icon(Icons.multitrack_audio_sharp,color: themeController.isDarkMode ? Colors.white:Colors.black,),
              Icon(Icons.multitrack_audio_sharp,color: themeController.isDarkMode ? Colors.white:Colors.black,),
              Icon(Icons.multitrack_audio_sharp,color: themeController.isDarkMode ? Colors.white:Colors.black,),
              Icon(Icons.multitrack_audio_sharp,color: themeController.isDarkMode ? Colors.white:Colors.black,),
              Icon(Icons.multitrack_audio_sharp,color: themeController.isDarkMode ? Colors.white:Colors.black,),
              SizedBox(width: 20,),
              GestureDetector(
                onTap: (){
                  if(isLoadingAudio==false){
                    isPlaying ? pauseAudio(widget.indexVal): startAudio(mediaOther[i].url);
                  }
                },
                child: Container(
                  height: 34,
                  width: 34,
                  margin: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: themeController.isDarkMode?Colors.white.withOpacity(0.23):Colors.white.withOpacity(0.5),
                  ),
                  alignment: Alignment.center,
                  child: isLoadingAudio?
                  Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: themeController.isDarkMode? Colors.white : MateColors.blackTextColor,
                    ),
                  ):
                  Icon(
                    isPlaying?
                    Icons.pause:Icons.play_arrow,
                    size: 25,
                    color: themeController.isDarkMode?Color(0xFF67AE8C):Color(0xFF049571),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return mda;
  }

  Widget _sharedWidget(IsShared isShared) {
    return Container(
      margin: EdgeInsets.only(left: 50.0, right: 8, bottom: 10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0), border: Border.all(color: MateColors.line, width: 1)),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        ListTile(
          contentPadding: EdgeInsets.fromLTRB(12, 4, 10, 0),
          leading: InkWell(
            onTap: () {
              if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == isShared.user.id) {
                Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
              } else {
                Navigator.of(context).pushNamed(UserProfileScreen.routeName,
                    arguments: {"id": isShared.user.id, "name": isShared.user.name, "photoUrl": isShared.user.photoUrl, "firebaseUid": isShared.user.firebaseUid});
              }
            },
            child: isShared.user.photoUrl.length == 0
                ? ClipOval(
              child: Text(
                isShared.user.name[0],
              ),
            )
                : ClipOval(
              child: Image.network(
                isShared.user.photoUrl,
                height: 45,
                width: 38,
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: InkWell(
              onTap: () {
                if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == isShared.user.id) {
                  Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                } else {
                  Navigator.of(context).pushNamed(UserProfileScreen.routeName,
                      arguments: {"id": isShared.user.id, "name": isShared.user.name, "photoUrl": isShared.user.photoUrl, "firebaseUid": isShared.user.firebaseUid});
                }
              },
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      isShared.user.name,
                      style: TextStyle(fontFamily: 'Quicksand', color: Colors.white, fontSize: 13.2),
                      overflow: TextOverflow.clip,
                    ),
                  ),
                  Text(
                    ' $created',
                    style: TextStyle(color: Colors.white70, fontSize: 10),
                  ),
                ],
              )),
          subtitle: SizedBox(
            height: 27,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: isShared.feedTypes.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => HomeScreen(
                          index: 1,
                          feedTypeName: isShared.feedTypes[index].type.name,
                        )));
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    margin: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      color: MateColors.activeIcons,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      '${isShared.feedTypes[index].type.name}',
                      style: TextStyle(color: Colors.black, fontSize: 10),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, left: 60, right: 15),
          child: Text(isShared.title, textAlign: TextAlign.left, style: TextStyle(fontSize: 15.0, fontFamily: 'Quicksand', fontWeight: FontWeight.w700, color: MateColors.activeIcons)),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0, left: 60, right: 15),
          child: Text(
            isShared.description,
            style: TextStyle(color: Colors.white, fontSize: 12),
            textAlign: TextAlign.left,
          ),
        ),
        ..._buildMedia(context, isShared.media),
      ]),
    );
  }

  _showDeleteAlertDialog({@required int feedId, @required int indexVal,}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: new Text("Are you sure?"),
          content: new Text("You want to delete your post"),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text("Yes"),
              onPressed: () async {
                bool isDeleted = await Provider.of<FeedProvider>(context, listen: false).deleteAFeed(feedId);
                if (isDeleted) {
                  Future.delayed(Duration(seconds: 0), () {
                    if (widget.isBookmarkedPage) {
                      Navigator.pop(context);
                      Provider.of<FeedProvider>(context, listen: false).allBookmarkedFeed();
                    } else {
                      Navigator.pop(context);
                      if (widget.previousPageFeedId == null) {
                        Provider.of<FeedProvider>(context, listen: false).fetchFeedList(page: 1, userId: widget.previousPageUserId);
                      } else {
                        Provider.of<FeedProvider>(context, listen: false).fetchFeedList(page: 1, feedId: widget.previousPageFeedId);
                      }
                    }
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

  _showFollowAlertDialog({@required int feedId, @required int indexVal,}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Consumer<FeedProvider>(
          builder: (context, value, child) {
            return CupertinoAlertDialog(
              title: new Text("Are you sure?"),
              content: new Text(widget.isFollowed?"You want to Unfollow this post":"You want to follow this post"),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: value.feedFollowLoader?
                  Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ) :Text("Yes"),
                  onPressed: () async {
                    if(widget.isFollowed){
                      Map<String, dynamic> body = {"post_id": widget.feedId, "post_type": "Feed"};
                      bool unFollowDone = await Provider.of<FeedProvider>(context, listen: false).unFollowAFeed(body, widget.feedId);
                      if (unFollowDone) {
                        if (widget.isBookmarkedPage) {
                          value.bookmarkByUserData.data.feeds[widget.indexVal].isFollowed=false;
                        }else{
                          value.feedList[widget.indexVal].isFollowed=false;
                        }
                        widget.isFollowed=false;
                        Navigator.pop(context);
                      }

                    }else{
                      Map<String, dynamic> body = {"post_id": widget.feedId, "post_type": "Feed"};
                      bool followDone = await Provider.of<FeedProvider>(context, listen: false).followAFeed(body, widget.feedId);
                      if (followDone) {
                        if (widget.isBookmarkedPage) {
                          value.bookmarkByUserData.data.feeds[widget.indexVal].isFollowed=true;
                        }else{
                          value.feedList[widget.indexVal].isFollowed=true;
                        }
                        widget.isFollowed=true;
                        Navigator.pop(context);
                      }
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
      },
    );
  }

  insertEvent(event) {
    try {
      const _scopes = const [gCal.CalendarApi.calendarScope];
      clientViaUserConsent(_credentials, _scopes, prompt).then((AuthClient client) {
        var calendar = gCal.CalendarApi(client);
        String calendarId = "primary";
        calendar.events.insert(event, calendarId).then((value) {
          print("ADDEDDD_________________${value.status}");
          if (value.status == "confirmed") {
            print('Event added in google calendar');
          } else {
            print("Unable to add event in google calendar");
          }
        });
      });
    } catch (e) {
      print('Error creating event $e');
    }
  }

  void prompt(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
