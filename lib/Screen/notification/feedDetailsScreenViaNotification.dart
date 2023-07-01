import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mate_app/Model/FeedItem.dart';
import 'package:mate_app/Providers/AuthUserProvider.dart';
import 'package:mate_app/Providers/FeedProvider.dart';
import 'package:mate_app/Screen/Profile/ProfileScreen.dart';
import 'package:mate_app/Screen/Profile/UserProfileScreen.dart';
import 'package:mate_app/Widget/Home/HomeRow.dart';
import 'package:mate_app/Widget/Loaders/Shimmer.dart';
import 'package:mate_app/asset/Colors/MateColors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../constant.dart';
import '../../../controller/theme_controller.dart';
import '../../Services/FeedService.dart';
import '../../Widget/mediaViewer.dart';
import '../../Widget/video_thumbnail.dart';
import '../../groupChat/services/dynamicLinkService.dart';
import '../Home/HomeScreen.dart';
import '../Home/TimeLine/feedCommentsReply.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:http/http.dart'as http;
import 'package:googleapis/calendar/v3.dart' as gCal;

import '../Home/TimeLine/feedLikesDetails.dart';
import '../Home/TimeLine/feed_search.dart';
import '../Report/reportPage.dart';
import '../chat1/screens/chat.dart';

class FeedDetailsViaNotification extends StatefulWidget{
  int feedId;
  FeedDetailsViaNotification({this.feedId,});

  @override
  State<StatefulWidget> createState() => FeedDetailsViaNotificationState();
}

class FeedDetailsViaNotificationState extends State<FeedDetailsViaNotification>{
  ThemeController themeController = Get.find<ThemeController>();
  TextEditingController messageEditingController = new TextEditingController();
  bool messageSentCheck = false;
  ClientId _credentials;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      _credentials = new ClientId("237545926078-9biln72s9c5h9vot53l84me39unhhnbf.apps.googleusercontent.com", "");
    } else if (Platform.isIOS) {
      _credentials = new ClientId("237545926078-99q5c35ugs0b49spmhf1ru0ghie7opnp.apps.googleusercontent.com", "");
    }
    Future.delayed(Duration(seconds: 0), () {
      Provider.of<FeedProvider>(context, listen: false).fetchFeedDetail(widget.feedId);
      Provider.of<FeedProvider>(context, listen: false).fetchCommentsOfAFeed(widget.feedId);
    });
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
        body: Consumer<FeedProvider>(
          builder: (context,feedProvider,_){
            print(feedProvider.isLoadingFeedDetails);
            return Container(
              height: scH,
              width: scW,
              decoration: BoxDecoration(
                color: themeController.isDarkMode?Color(0xFF000000):Colors.white,
                image: DecorationImage(
                  image: AssetImage(themeController.isDarkMode?'lib/asset/Background.png':'lib/asset/BackgroundLight.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: feedProvider.isLoadingFeedDetails?
              Padding(
                padding: const EdgeInsets.only(top: 80),
                child: timelineLoader(),
              ):
              ListView(
                children: [
                  // HomeRowForFeedDetails(
                  //   isFeedDetailsPage: widget.isFeedDetailsPage,
                  //   id: widget.id,
                  //   feedId: widget.feedId,
                  //   title: widget.title,
                  //   feedType: widget.feedType,
                  //   start: widget.start,
                  //   end: widget.end,
                  //   calenderDate: widget.calenderDate,
                  //   description: widget.description,
                  //   created: widget.created,
                  //   user: widget.user,
                  //   location: widget.location,
                  //   hyperlinkText: widget.hyperlinkText,
                  //   hyperlink: widget.hyperlink,
                  //   media: widget.media,
                  //   isLiked: widget.isLiked,
                  //   liked: widget.liked,
                  //   bookMarked: widget.bookMarked,
                  //   likeCount: widget.likeCount,
                  //   bookmarkCount: widget.bookmarkCount,
                  //   shareCount: widget.shareCount,
                  //   commentCount: widget.commentCount,
                  //   isShared: widget.isShared,
                  //   indexVal: widget.indexVal,
                  //   navigateToDetailsPage: false,
                  //   pageType: widget.pageType,
                  //   mediaOther: widget.mediaOther,
                  // ),
                  HomeRowForFeedDetailsNotification(
                    isFeedDetailsPage: true,
                    id: feedProvider.feedItemDetails.id,
                    feedId: widget.feedId,
                    title: feedProvider.feedItemDetails.title,
                    feedType: feedProvider.feedItemDetails.feedTypes,
                    start: feedProvider.feedItemDetails.start,
                    end: feedProvider.feedItemDetails.end,
                    //calenderDate: feedProvider.feedItemDetails.start,
                    description: feedProvider.feedItemDetails.description,
                    created: feedProvider.feedItemDetails.created,
                    user: feedProvider.feedItemDetails.user,
                    location: feedProvider.feedItemDetails.location,
                    hyperlinkText: feedProvider.feedItemDetails.hyperlinkText,
                    hyperlink: feedProvider.feedItemDetails.hyperlink,
                    media: feedProvider.feedItemDetails.media,
                    isLiked: feedProvider.feedItemDetails.isLiked,
                    //liked: feedProvider.feedItemDetails.,
                    bookMarked: feedProvider.feedItemDetails.isBookmarked,
                    likeCount: feedProvider.feedItemDetails.likeCount,
                    bookmarkCount: feedProvider.feedItemDetails.bookmarkCount,
                    shareCount: feedProvider.feedItemDetails.shareCount,
                    commentCount: feedProvider.feedItemDetails.commentCount,
                    isShared: feedProvider.feedItemDetails.isShared,
                    //indexVal: feedProvider.feedItemDetails.indexVal,
                    navigateToDetailsPage: false,
                    //pageType: feedProvider.feedItemDetails.pageType,
                    mediaOther: feedProvider.feedItemDetails.mediaOther,
                  ),
                  _messageSendWidget(),
                   _comments(),
                ],
              ),
            );
          },
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
            margin: EdgeInsets.fromLTRB(16,15, 16, 5),
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
                      Map<String, dynamic> body = {"content": messageEditingController.text.trim()};
                      bool updated = await Provider.of<FeedProvider>(context, listen: false).commentAFeed(body, widget.feedId);

                      if (updated) {
                        ++Provider.of<FeedProvider>(context, listen: false).feedItemDetails.commentCount;
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

  Widget _comments(){
    return Consumer<FeedProvider>(
      builder: (context, feedProvider, child) {
        if (!feedProvider.fetchCommentsLoader && feedProvider.commentFetchData != null) {
          return ListView.builder(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                          child: buildEmojiAndText(
                            content:  feedProvider.commentFetchData.data.result[index].content,
                            textStyle: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.1,
                              color: themeController.isDarkMode?Colors.white:Colors.black,
                            ),
                            normalFontSize: 14,
                            emojiFontSize: 24,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            DateFormat.yMMMEd().format(DateFormat("yyyy-MM-dd").parse(feedProvider.commentFetchData.data.result[index].createdAt, true)),
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
                              builder: (context) => FeedCommentsReply(
                                feedIndex: 0,//widget.indexVal,
                                commentId: feedProvider.commentFetchData.data.result[index].id,
                                commentIndex: index,
                                feedId: widget.feedId,
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
                        Text(feedProvider.commentFetchData.data.result[index].replies.isEmpty?"":feedProvider.commentFetchData.data.result[index].replies.length>1?
                        "   •   ${feedProvider.commentFetchData.data.result[index].replies.length} Replies":
                        "   •   ${feedProvider.commentFetchData.data.result[index].replies.length} Reply",
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
                                        --Provider.of<FeedProvider>(context, listen: false).feedItemDetails.commentCount;

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
                              feedIndex: 0,//widget.indexVal,
                              commentId: feedProvider.commentFetchData.data.result[index].id,
                              commentIndex: index,
                              feedId: widget.feedId,
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
                                child: buildEmojiAndText(
                                  content: feedProvider.commentFetchData.data.result[index].replies.last.content,
                                  textStyle: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 0.1,
                                    color: themeController.isDarkMode?Colors.white:Colors.black,
                                  ),
                                  normalFontSize: 14,
                                  emojiFontSize: 24,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  DateFormat.yMMMEd().format(DateFormat("yyyy-MM-dd").parse(feedProvider.commentFetchData.data.result[index].replies.last.createdAt, true)),
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
    );
  }

}


class HomeRowForFeedDetailsNotification extends StatefulWidget {
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

  HomeRowForFeedDetailsNotification(
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
  _HomeRowForFeedDetailsNotificationState createState() =>
      _HomeRowForFeedDetailsNotificationState(this.id, this.feedId, this.title, this.feedType, this.start, this.end, this.calenderDate, this.description, this.created, this.user, this.location, this.media, this.liked, this.bookMarked,this.mediaOther);
}

class _HomeRowForFeedDetailsNotificationState extends State<HomeRowForFeedDetailsNotification> with SingleTickerProviderStateMixin {
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
  _HomeRowForFeedDetailsNotificationState(this.id, this.feedId, this.title, this.feedType, this.startTime, this.endTime, this.calenderDate, this.description, this.created, this.user, this.location, this.media, this.liked, this.bookMarked, this.mediaOther);

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
                  } else if (index == 3) {
                    // Map<String, dynamic> body;
                    // Provider.of<ExternalShareProvider>(context,listen: false).externalSharePost(body);
                    // modalSheetToShare();
                    String response  = await DynamicLinkService.buildDynamicLinkFeed(
                      id: widget.feedId.toString(),
                    );
                    if(response!=null){
                      Share.share(response);
                    }
                  }
                  else if (index == 4) {
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
                  PopupMenuItem(
                    value: 3,
                    height: 40,
                    child: Text(
                      "Share",
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
                child: buildEmojiAndText(
                  content: title,
                  textStyle: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    color: themeController.isDarkMode?Colors.white:Colors.black,
                  ),
                  normalFontSize: 16,
                  emojiFontSize: 26,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 16,top: 10,right: 10),
            child: REGEX_EMOJI.allMatches(description).isNotEmpty?
            buildEmojiAndText(
              content: description,
              textStyle: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                letterSpacing: 0.1,
                color: themeController.isDarkMode?Colors.white:Colors.black,
              ),
              normalFontSize: 14,
              emojiFontSize: 24,
            ):
            Linkify(
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
                    if(widget.likeCount[0].count!=0 || widget.likeCount[1].count!=0){
                      Get.to(() => FeedLikesDetails(feedId: widget.feedId,));
                    }
                  },
                  onDoubleTap: ()async{
                    print(widget.pageType);
                    String response = await FeedService().likeFeed(feedId, 0, token);
                    if(response == "Feed Liked successfully"){
                      widget.likeCount[0].count++;
                      widget.isLiked = IsLiked(feedId: 0,userId: 0,id: 0,emojiValue: 0,createdAt: "",updatedAt: "");
                    }else if(response == 'Feed Unliked successfully'){
                      if(widget.isLiked.emojiValue==0){
                        widget.likeCount[0].count--;
                        widget.isLiked = null;
                      }else{
                        await FeedService().likeFeed(feedId, 0, token);
                        widget.likeCount[0].count++;
                        widget.isLiked = IsLiked(feedId: 0,userId: 0,id: 0,emojiValue: 0,createdAt: "",updatedAt: "");
                        widget.likeCount[1].count--;
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
                    if(widget.likeCount[0].count!=0 || widget.likeCount[1].count!=0){
                      Get.to(() => FeedLikesDetails(feedId: widget.feedId,));
                    }
                  },
                  onDoubleTap: ()async{
                    print(widget.pageType);
                    String response = await FeedService().likeFeed(feedId, 1, token);
                    if(response == "Feed Liked successfully"){
                      widget.likeCount[1].count++;
                      widget.isLiked = IsLiked(feedId: 0,userId: 0,id: 0,emojiValue: 1,createdAt: "",updatedAt: "");
                    }else if(response == 'Feed Unliked successfully'){
                      if(widget.isLiked.emojiValue==1){
                        widget.likeCount[1].count--;
                        widget.isLiked = null;
                      }else{
                        await FeedService().likeFeed(feedId, 1, token);
                        widget.likeCount[1].count++;
                        widget.isLiked = IsLiked(feedId: 0,userId: 0,id: 0,emojiValue: 1,createdAt: "",updatedAt: "");
                        widget.likeCount[0].count--;
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
                          widget.likeCount[1].count.toString(),
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
                    return Padding(
                      padding: const EdgeInsets.only(right: 16,left: 10,top: 25),
                      child: InkWell(
                        onTap: (){
                          Provider.of<FeedProvider>(context, listen: false).bookmarkAFeedSingle(feedId);
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
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
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
                        widget.isFollowed=false;
                        Navigator.pop(context);
                      }

                    }else{
                      Map<String, dynamic> body = {"post_id": widget.feedId, "post_type": "Feed"};
                      bool followDone = await Provider.of<FeedProvider>(context, listen: false).followAFeed(body, widget.feedId);
                      if (followDone) {
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
