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
//import 'package:share/share.dart';
import '../../../Providers/AuthUserProvider.dart';
import '../../../Providers/campusTalkProvider.dart';
import '../../../Widget/mediaViewer.dart';
import '../../../Widget/video_thumbnail.dart';
import '../../../asset/Colors/MateColors.dart';
import '../../../constant.dart';
import '../../../controller/theme_controller.dart';
import '../../../groupChat/services/dynamicLinkService.dart';
import '../../Profile/ProfileScreen.dart';
import '../../Report/reportPage.dart';
import 'campusTalkComments.dart';
import 'package:http/http.dart'as http;

class CampusTalkDetailsScreen extends StatefulWidget{
  final User? user;
  final int? talkId;
  final String? url;
  final String? title;
  final String? description;
  final int? isAnonymous;
  final String? anonymousUser;
  final String? createdAt;
  final int? rowIndex;
  final IsBookmarked? isBookmarked;
  final IsLiked? isLiked;
  final IsLiked? isDisLiked;
  int? likesCount;
  int? disLikeCount;
  int? commentsCount;
  final bool? isBookmarkedPage;
  final bool? isUserProfile;
  final bool? isTrending;
  final bool? isLatest;
  final bool? isForums;
  final bool? isYourCampus;
  final bool? isListCard;
  final bool? isSearch;
  final String? image;
  final String? video;
  final String? audio;


  CampusTalkDetailsScreen({Key? key,
    required this.user,
    required this.talkId,
    required this.url,
    required this.title,
    required this.description,
    required this.isAnonymous,
    required this.anonymousUser,
    required this.createdAt,
    required this.rowIndex,
    required this.isBookmarked,
    required this.isLiked,
    required this.likesCount,
    required this.disLikeCount,
    required this.commentsCount,
    this.isBookmarkedPage=false,
    this.isUserProfile=false,
    this.isTrending = false,
    this.isLatest = false,
    this.isForums = false,
    this.isYourCampus = false,
    this.isListCard = false,
    this.isSearch = false,
    required this.isDisLiked,
    required this.image,required this.video,required this.audio
  }) : super(key: key);

  @override
  _CampusTalkDetailsScreenState createState() {
    return _CampusTalkDetailsScreenState();
  }
}

class _CampusTalkDetailsScreenState extends State<CampusTalkDetailsScreen>{
  ThemeController themeController = Get.find<ThemeController>();
  late bool liked;
  late bool bookMarked;
  late bool disLiked;
  late CampusTalkProvider campusTalkProvider;

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

        if(widget.isBookmarkedPage!){
          for(int i=0;i<campusTalkProvider.campusTalkPostsBookmarkData.data!.result!.length;i++){
            campusTalkProvider.campusTalkPostsBookmarkData.data!.result![i].isPlaying = false;
          }
        }
        if(widget.isUserProfile!){
          for(int i=0;i<campusTalkProvider.campusTalkByUserPostsResultsList.length;i++){
            campusTalkProvider.campusTalkByUserPostsResultsList[i].isPlaying = false;
          }
        }
        if(widget.isTrending!){
          for(int i=0;i<campusTalkProvider.campusTalkPostsResultsTrendingList.length;i++){
            campusTalkProvider.campusTalkPostsResultsTrendingList[i].isPlaying = false;
          }
        }
        if(widget.isLatest!){
          for(int i=0;i<campusTalkProvider.campusTalkPostsResultsLatestList.length;i++){
            campusTalkProvider.campusTalkPostsResultsLatestList[i].isPlaying = false;
          }
        }
        if(widget.isForums!){
          for(int i=0;i<campusTalkProvider.campusTalkPostsResultsForumsList.length;i++){
            campusTalkProvider.campusTalkPostsResultsForumsList[i].isPlaying = false;
          }
        }
        if(widget.isYourCampus!){
          for(int i=0;i<campusTalkProvider.campusTalkPostsResultsYourCampusList.length;i++){
            campusTalkProvider.campusTalkPostsResultsYourCampusList[i].isPlaying = false;
          }
        }
        if(widget.isListCard!){
          for(int i=0;i<campusTalkProvider.campusTalkPostsResultsListCard.length;i++){
            campusTalkProvider.campusTalkPostsResultsListCard[i].isPlaying = false;
          }
        }
        if(widget.isSearch!){
          for(int i=0;i<campusTalkProvider.campusTalkBySearchResultsList.length;i++){
            campusTalkProvider.campusTalkBySearchResultsList[i].isPlaying = false;
          }
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
  void initState() {
    campusTalkProvider = Provider.of<CampusTalkProvider>(context,listen: false);
    bookMarked = (widget.isBookmarked == null) ? false : true;
    liked = (widget.isLiked == null) ? false : true;
    disLiked = (widget.isDisLiked == null) ? false : true;
    super.initState();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
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
                                if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == widget.user!.uuid) {
                                  Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                                } else {
                                  Navigator.of(context).pushNamed(UserProfileScreen.routeName, arguments: {"id": widget.user!.uuid, "name": widget.user!.displayName, "photoUrl": widget.user!.profilePhoto, "firebaseUid": widget.user!.firebaseUid});
                                }
                              }
                            },
                            child: CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(
                                widget.user!.profilePhoto!,
                              ),
                            ),
                          ):
                          Container(
                            height: 0,
                            width: 0,
                          ),
                        ],
                      ),
                      horizontalTitleGap: widget.isAnonymous == 0?10:0,
                      title: InkWell(
                          onTap: () {
                            if (widget.isAnonymous == 0) {
                              if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == widget.user!.uuid) {
                                Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                              } else {
                                Navigator.of(context).pushNamed(UserProfileScreen.routeName, arguments: {"id": widget.user!.uuid, "name": widget.user!.displayName, "photoUrl": widget.user!.profilePhoto, "firebaseUid": widget.user!.firebaseUid});
                              }
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 0.0),
                            child: Row(
                              children: [
                                Text(
                                  widget.isAnonymous == 0 ? widget.user!.displayName! : "Anonymous",// widget.anonymousUser ??
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
                                        widget.user!.university!=null?
                                        "@ ${widget.user!.university}":
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
                            String? response  = await DynamicLinkService.buildDynamicLinkCampusTalk(
                              id: widget.talkId.toString(),
                            );
                            if(response!=null){
                              Share.share(response);
                            }
                          } else if (index == 1) {
                            _showDeleteAlertDialog(postId: widget.talkId!, rowIndex: widget.rowIndex!);
                          } else if (index == 2) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReportPage(
                                    moduleId: widget.talkId!,
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
                          (widget.user!.uuid != null && (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == widget.user!.uuid)) ?
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
                            content: widget.title!,
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
                          child: widget.description != null ?
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 14, 0),
                            child: buildEmojiAndText(
                              content: widget.description!,
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

                    if(widget.audio!=null)
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
                                isPlaying ? pauseAudio(widget.rowIndex!): startAudio(widget.audio!);
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

                    if(widget.image!=null || widget.video!=null)
                      Container(
                        height: 150,
                        margin: EdgeInsets.only(bottom: 0.0, left: 16, right: 16, top: 10),
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemCount: widget.image!=null && widget.video!=null? 2 : widget.image!=null?1:widget.video!=null?1:0,
                            itemBuilder: (context,indexSwipe){
                              if(indexSwipe==0){
                                return
                                  widget.image!=null?
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 0.0, left: 0, right: 0, top: 10),
                                    child: Container(
                                      height: 150,
                                      width: MediaQuery.of(context).size.width/1.1,
                                      child: InkWell(
                                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>MediaViewer(url: widget.image!,))),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(12.0),
                                          clipBehavior: Clip.hardEdge,
                                          child: Image.network(
                                            widget.image!,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ):widget.video!=null?
                                  VideoThumbnail(videoUrl: widget.video!,isLeftPadding: false,):Container();
                              }else{
                                return  widget.video!=null?
                                VideoThumbnail(videoUrl: widget.video!):Container();
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
                                        bool likedDone = await Provider.of<CampusTalkProvider>(context, listen: false).upVoteAPost(widget.talkId!, widget.rowIndex!, isBookmarkedPage: widget.isBookmarkedPage!, isUserProfile: widget.isUserProfile!);
                                        if (likedDone && liked) {
                                          if(widget.isUserProfile!){
                                            ++value.campusTalkByUserPostsResultsList[widget.rowIndex!].likesCount;
                                          }
                                          if(widget.isBookmarkedPage!){
                                            ++value.campusTalkPostsBookmarkData.data!.result![widget.rowIndex!].likesCount;
                                          }
                                          if(widget.isTrending!){
                                            ++value.campusTalkPostsResultsTrendingList[widget.rowIndex!].likesCount;
                                          }
                                          if(widget.isLatest!){
                                            ++value.campusTalkPostsResultsLatestList[widget.rowIndex!].likesCount;
                                          }
                                          if(widget.isForums!){
                                            ++value.campusTalkPostsResultsForumsList[widget.rowIndex!].likesCount;
                                          }
                                          if(widget.isYourCampus!){
                                            ++value.campusTalkPostsResultsYourCampusList[widget.rowIndex!].likesCount;
                                          }
                                          if(widget.isSearch!){
                                            ++value.campusTalkBySearchResultsList[widget.rowIndex!].likesCount;
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
                                          widget.talkId!,
                                          widget.rowIndex!,
                                          isBookmarkedPage: widget.isBookmarkedPage!,
                                          isUserProfile: widget.isUserProfile!,
                                          isTrending: widget.isTrending!,
                                          isLatest: widget.isLatest!,
                                          isForums: widget.isForums!,
                                          isYourCampus: widget.isYourCampus!,
                                          isListCard: widget.isListCard!,
                                          isSearch: widget.isSearch!,
                                        );
                                        if (likedDone && disLiked) {
                                          if(widget.isUserProfile!){
                                            ++value.campusTalkByUserPostsResultsList[widget.rowIndex!].dislikesCount;
                                          }
                                          if(widget.isBookmarkedPage!){
                                            ++value.campusTalkPostsBookmarkData.data!.result![widget.rowIndex!].dislikesCount;
                                          }
                                          if(widget.isTrending!){
                                            ++value.campusTalkPostsResultsTrendingList[widget.rowIndex!].dislikesCount;
                                          }
                                          if(widget.isLatest!){
                                            ++value.campusTalkPostsResultsLatestList[widget.rowIndex!].dislikesCount;
                                          }
                                          if(widget.isForums!){
                                            ++value.campusTalkPostsResultsForumsList[widget.rowIndex!].dislikesCount;
                                          }
                                          if(widget.isYourCampus!){
                                            ++value.campusTalkPostsResultsYourCampusList[widget.rowIndex!].dislikesCount;
                                          }
                                          if(widget.isListCard!){
                                            ++value.campusTalkPostsResultsListCard[widget.rowIndex!].dislikesCount;
                                          }
                                          if(widget.isSearch!){
                                            ++value.campusTalkBySearchResultsList[widget.rowIndex!].dislikesCount;
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
                                      postId: widget.talkId!,
                                      postIndex: widget.rowIndex!,
                                      isUserProfile: widget.isUserProfile!,
                                      isBookmarkedPage: widget.isBookmarkedPage!,
                                      isListCard: widget.isListCard!,
                                      isYourCampus: widget.isYourCampus!,
                                      user: widget.user!,
                                      isForums: widget.isForums!,
                                      isLatest: widget.isLatest!,
                                      isTrending: widget.isTrending!,
                                      isSearch: widget.isSearch!,
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
                                      bool isBookmarked = await Provider.of<CampusTalkProvider>(context, listen: false).bookmarkAPost(widget.talkId!, widget.rowIndex!, isBookmarkedPage: widget.isBookmarkedPage!, isUserProfile: widget.isUserProfile!);
                                      if (widget.isBookmarkedPage!) {
                                        if (isBookmarked) {
                                          Future.delayed(Duration(seconds: 0), () {
                                            final campusTalkProvider = Provider.of<CampusTalkProvider>(context, listen: false);
                                            if (widget.isBookmarkedPage!) {
                                              campusTalkProvider.fetchCampusTalkPostBookmarkedList();
                                            } else if (widget.isUserProfile!) {
                                              campusTalkProvider.fetchCampusTalkByAuthUser(widget.user!.uuid!, page: 1);
                                            } else if(widget.isTrending!){
                                              campusTalkProvider.fetchCampusTalkPostTendingList(page: 1);
                                            } else if(widget.isLatest!){
                                              campusTalkProvider.fetchCampusTalkPostTLatestList(page: 1);
                                            }else if(widget.isForums!){
                                              campusTalkProvider.fetchCampusTalkPostForumsList(page: 1);
                                            }else if(widget.isYourCampus!){
                                              campusTalkProvider.fetchCampusTalkPostYourCampusList(page: 1);
                                            }else if(widget.isListCard!){
                                              campusTalkProvider.fetchCampusTalkPostListCard();
                                            }else if(widget.isSearch!){
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
                  postIndex: widget.rowIndex!,
                  postId: widget.talkId!,
                  isBookmarkedPage: widget.isBookmarkedPage!,
                  isUserProfile: widget.isUserProfile!,
                  isTrending: widget.isTrending!,
                  isLatest: widget.isLatest!,
                  isForums: widget.isForums!,
                  isYourCampus: widget.isYourCampus!,
                  isListCard: widget.isListCard!,
                  user: widget.user!,
                  isSearch: widget.isSearch!,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _showDeleteAlertDialog({required int postId, required int rowIndex,}) async {
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
                bool isDeleted = await Provider.of<CampusTalkProvider>(context, listen: false).deleteACampusTalk(widget.talkId!, rowIndex);
                if (isDeleted) {
                  Future.delayed(Duration(seconds: 0), () {
                    if (widget.isBookmarkedPage!) {
                      Provider.of<CampusTalkProvider>(context, listen: false).fetchCampusTalkPostBookmarkedList();
                    } else if (widget.isUserProfile!) {
                      Provider.of<CampusTalkProvider>(context, listen: false).fetchCampusTalkByAuthUser(widget.user!.uuid!, page: 1);
                    } else if(widget.isTrending!){
                      Provider.of<CampusTalkProvider>(context, listen: false).fetchCampusTalkPostTendingList(page: 1);
                    } else if(widget.isLatest!){
                      Provider.of<CampusTalkProvider>(context, listen: false).fetchCampusTalkPostTLatestList(page: 1);
                    }else if(widget.isForums!){
                      Provider.of<CampusTalkProvider>(context, listen: false).fetchCampusTalkPostForumsList(page: 1);
                    }else if(widget.isYourCampus!){
                      Provider.of<CampusTalkProvider>(context, listen: false).fetchCampusTalkPostYourCampusList(page: 1);
                    }else if(widget.isListCard!){
                      Provider.of<CampusTalkProvider>(context, listen: false).fetchCampusTalkPostListCard();
                    }else if(widget.isSearch!){
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