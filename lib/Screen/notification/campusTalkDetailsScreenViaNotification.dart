import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mate_app/Screen/Profile/UserProfileScreen.dart';
import 'package:mate_app/Model/campusTalkPostsModel.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Providers/AuthUserProvider.dart';
import '../../../Providers/campusTalkProvider.dart';
import '../../../Widget/mediaViewer.dart';
import '../../../Widget/video_thumbnail.dart';
import '../../../asset/Colors/MateColors.dart';
import '../../../constant.dart';
import '../../../controller/theme_controller.dart';
import '../../../groupChat/services/dynamicLinkService.dart';
import 'package:http/http.dart'as http;
import 'package:mate_app/Model/campusTalkPostsModel.dart' as campusTalk;

import '../../Services/notificationService.dart';
import '../../Widget/Loaders/Shimmer.dart';
import '../Home/Community/campusTalkComments.dart';
import '../Profile/ProfileScreen.dart';
import '../Report/reportPage.dart';

class CampusTalkDetailsScreenViaNotification extends StatefulWidget{
  int campusId;
  CampusTalkDetailsScreenViaNotification({Key? key,
    required this.campusId,
  }) : super(key: key);

  @override
  _CampusTalkDetailsScreenState createState() {
    return _CampusTalkDetailsScreenState();
  }
}

class _CampusTalkDetailsScreenState extends State<CampusTalkDetailsScreenViaNotification>{
  ThemeController themeController = Get.find<ThemeController>();
  bool? liked;
  bool? bookMarked;
  bool? disLiked;
  CampusTalkProvider? campusTalkProvider;

  User? user;
  int? talkId;
  String? url;
  String? title;
  String? description;
  int? isAnonymous;
  String? anonymousUser;
  String? createdAt;
  int? rowIndex;
  IsBookmarked? isBookmarked;
  IsLiked? isLiked;
  IsLiked? isDisLiked;
  int? likesCount;
  int? disLikeCount;
  int? commentsCount;
  bool? isBookmarkedPage;
  bool? isUserProfile;
  bool? isTrending;
  bool? isLatest;
  bool? isForums;
  bool? isYourCampus;
  bool? isListCard;
  bool? isSearch;
  String? image;
  String? video;
  String? audio;
  String? token = "";
  bool? isLoading = true;
  campusTalk.Result? result;

  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  bool isPause = false;
  bool isLoadingAudio = false;
  NotificationService _notificationService = NotificationService();

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
  void initState() {
    campusTalkProvider = Provider.of<CampusTalkProvider>(context,listen: false);
    getStoredValue();
    super.initState();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  getStoredValue()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("tokenApp");
    result = await _notificationService.getCampusDetails(token: token!,id: widget.campusId);
    bookMarked = (result!.isBookmarked == null) ? false : true;
    liked = (result!.isLiked == null) ? false : true;
    disLiked = (result!.isDisliked == null) ? false : true;
    setState(() {
      isLoading = false;
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
          child: isLoading!?
          Padding(
            padding: const EdgeInsets.only(top: 80),
            child: timelineLoader(),
          ):
          result!=null?
          Column(
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
                          result!.isAnonymous == 0 ?
                          InkWell(
                            onTap: () {
                              if (result!.isAnonymous == 0) {
                                if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == result!.user!.uuid) {
                                  Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                                } else {
                                  Navigator.of(context).pushNamed(UserProfileScreen.routeName, arguments: {"id": result!.user!.uuid, "name": result!.user!.displayName, "photoUrl": result!.user!.profilePhoto, "firebaseUid": result!.user!.firebaseUid});
                                }
                              }
                            },
                            child: CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(
                                result!.user!.profilePhoto!,
                              ),
                            ),
                          ):
                          Container(
                            height: 0,
                            width: 0,
                          ),
                        ],
                      ),
                      horizontalTitleGap: result!.isAnonymous == 0?10:0,
                      title: InkWell(
                          onTap: () {
                            if (result!.isAnonymous == 0) {
                              if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == result!.user!.uuid) {
                                Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                              } else {
                                Navigator.of(context).pushNamed(UserProfileScreen.routeName, arguments: {"id": result!.user!.uuid, "name": result!.user!.displayName, "photoUrl": result!.user!.profilePhoto, "firebaseUid": result!.user!.firebaseUid});
                              }
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 0.0),
                            child: Row(
                              children: [
                                Text(
                                  result!.isAnonymous == 0 ? result!.user!.displayName! : "Anonymous",// widget.anonymousUser ??
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    color: themeController.isDarkMode?Colors.white:Colors.black,
                                  ),
                                  overflow: TextOverflow.clip,
                                ),
                                if(result!.isAnonymous == 1)
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 5,right: 0),
                                      child: Text(
                                        result!.user!.university!=null?
                                        "@ ${result!.user!.university}":
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
                        "${result!.createdAt}",
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
                            String response  = await DynamicLinkService.buildDynamicLinkCampusTalk(
                              id: widget.campusId.toString(),
                            );
                            if(response!=null){
                              Share.share(response);
                            }
                          } else if (index == 1) {
                            _showDeleteAlertDialog(postId: widget.campusId);
                          } else if (index == 2) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReportPage(
                                    moduleId: widget.campusId,
                                    moduleType: "DiscussionForum",
                                  ),
                                ));
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 0,
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
                          (result!.user!.uuid != null && (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == result!.user!.uuid)) ?
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
                        child: buildEmojiAndText(
                          content: result!.title!,
                          textStyle: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            color: themeController.isDarkMode?Colors.white:Colors.black,
                          ),
                          normalFontSize: 16,
                          emojiFontSize: 26,
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
                          child: result!.description != null ?
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 14, 0),
                            child: buildEmojiAndText(
                              content: result!.description!,
                              textStyle: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.1,
                                color: themeController.isDarkMode?Colors.white:Colors.black,
                              ),
                              normalFontSize: 14,
                              emojiFontSize: 24,
                            ),
                          ) : SizedBox(),
                        ),
                      ),
                    ),

                    if(result!.audioUrl!=null)
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
                                  isPlaying ? pauseAudio(0): startAudio(result!.audioUrl!);
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

                    if(result!.photoUrl!=null || result!.videoUrl!=null)
                      Container(
                        height: 150,
                        margin: EdgeInsets.only(bottom: 0.0, left: 16, right: 16, top: 10),
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemCount: result!.photoUrl!=null && result!.videoUrl!=null? 2 : result!.photoUrl!=null?1:result!.videoUrl!=null?1:0,
                            itemBuilder: (context,indexSwipe){
                              if(indexSwipe==0){
                                return
                                  result!.photoUrl!=null?
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 0.0, left: 0, right: 0, top: 10),
                                    child: Container(
                                      height: 150,
                                      width: MediaQuery.of(context).size.width/1.1,
                                      child: InkWell(
                                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>MediaViewer(url: result!.photoUrl!,))),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(12.0),
                                          clipBehavior: Clip.hardEdge,
                                          child: Image.network(
                                            result!.photoUrl!,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ):result!.videoUrl!=null?
                                  VideoThumbnail(videoUrl: result!.videoUrl!,isLeftPadding: false,):Container();
                              }else{
                                return  result!.videoUrl!=null?
                                VideoThumbnail(videoUrl: result!.videoUrl!):Container();
                              }
                            }
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
                                          color: liked! ?themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight:
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
                                              liked!? Colors.black:Colors.white:
                                              liked!? Colors.white: Colors.black,
                                            ),
                                            SizedBox(width: 5,),
                                            Text("${result!.likesCount}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14,
                                                fontFamily: 'Poppins',
                                                color: themeController.isDarkMode?
                                                liked!? Colors.black:Colors.white:
                                                liked!? Colors.white: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      onTap: () async {
                                        liked=!liked!;
                                        bool likedDone = await Provider.of<CampusTalkProvider>(context, listen: false).upVoteAPostCommentSingle(commentId: widget.campusId);
                                        if (likedDone && liked!) {
                                          ++result!.likesCount;
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
                                          color: disLiked! ?themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight:
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
                                              disLiked!? Colors.black:Colors.white:
                                              disLiked!? Colors.white: Colors.black,
                                            ),
                                            SizedBox(width: 5,),
                                            Text("${result!.dislikesCount}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14,
                                                fontFamily: 'Poppins',
                                                color: themeController.isDarkMode?
                                                disLiked!? Colors.black:Colors.white:
                                                disLiked!? Colors.white: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      onTap: () async {
                                        disLiked=!disLiked!;
                                        bool likedDone = await Provider.of<CampusTalkProvider>(context, listen: false).downVoteAPostSingle(
                                          widget.campusId,
                                        );
                                        if (likedDone && disLiked!) {
                                          ++result!.dislikesCount;
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
                                      postId: widget.campusId,
                                      postIndex: 0,
                                      isUserProfile: false,
                                      isBookmarkedPage: false,
                                      isListCard: false,
                                      isYourCampus: false,
                                      user: result!.user!,
                                      isForums: false,
                                      isLatest: false,
                                      isTrending: false,
                                      isSearch: false,
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
                                        result!.commentsCount==null?"0":result!.commentsCount.toString(),
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
                                      bookMarked=!bookMarked!;
                                      bool isBookmarked = await Provider.of<CampusTalkProvider>(context, listen: false).bookmarkAPostSingle(widget.campusId);
                                    },
                                    child: Container(
                                      height: 39,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        color: themeController.isDarkMode?MateColors.smallContainerDark:MateColors.smallContainerLight,
                                        shape: BoxShape.circle,
                                      ),
                                      child: bookMarked!?
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
                  postIndex: 0,
                  postId: widget.campusId,
                  isBookmarkedPage: false,
                  isUserProfile: false,
                  isTrending: false,
                  isLatest: false,
                  isForums: false,
                  isYourCampus: false,
                  isListCard: false,
                  user: result!.user!,
                  isSearch: false,
                ),
              )
            ],
          ):
          Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height/1.5,
            child: Text("Something went wrong! or post deleted",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: themeController.isDarkMode?Colors.white:Colors.black,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
                fontSize: 15,
              ),
            ),
          ),
        ),
      ),
    );
  }

  _showDeleteAlertDialog({required int postId}) async {
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
                bool isDeleted = await Provider.of<CampusTalkProvider>(context, listen: false).deleteACampusTalk(widget.campusId, rowIndex!);
                if (isDeleted) {
                  Future.delayed(Duration(seconds: 0), () {
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