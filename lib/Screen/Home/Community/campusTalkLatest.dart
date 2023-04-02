import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mate_app/Model/campusTalkPostsModel.dart';
import 'package:mate_app/Providers/campusTalkProvider.dart';
import 'package:mate_app/Screen/Home/Community/createCampusTalkPost.dart';
import 'package:mate_app/Widget/Home/Community/campusTalkRow.dart';
import 'package:mate_app/Widget/Loaders/Shimmer.dart';
import 'package:mate_app/asset/Colors/MateColors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../../controller/theme_controller.dart';
import 'campusTalkSearch.dart';

class CampusTalkScreenLatest extends StatefulWidget {
  const CampusTalkScreenLatest({Key key}) : super(key: key);

  @override
  _CampusTalkScreenLatestState createState() => _CampusTalkScreenLatestState();
}

class _CampusTalkScreenLatestState extends State<CampusTalkScreenLatest> with TickerProviderStateMixin {
  ThemeController themeController = Get.find<ThemeController>();
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final scH = MediaQuery.of(context).size.height;
    final scW = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _key,
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
                    "Latest",
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
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.to(()=>CampusTalkSearch(searchType: 'latest',));
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 16),
                        height: 60,
                        decoration: BoxDecoration(
                          color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.only(left: 16, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Search here...",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                color: themeController.isDarkMode?MateColors.helpingTextDark:Colors.black.withOpacity(0.72),
                              ),
                            ),
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: themeController.isDarkMode?MateColors.textFieldSearchDark:MateColors.textFieldSearchLight,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Image.asset(
                                  "lib/asset/iconsNewDesign/search.png",
                                  color: themeController.isDarkMode?Colors.white:MateColors.blackText,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16,),
                  InkWell(
                    onTap: () async {
                      Get.to(CreateCampusTalkPost());
                    },
                    child: Container(
                      height: 60,
                      width: 60,
                      margin: EdgeInsets.only(right: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                      ),
                      child: Icon(Icons.add, color: MateColors.blackTextColor, size: 28),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
            Expanded(
              child: CampusTalk(),
            ),
          ],
        ),
      ),
    );
  }
}

class CampusTalk extends StatefulWidget {
  const CampusTalk({Key key}) : super(key: key);

  @override
  _CampusTalkState createState() => _CampusTalkState();
}

class _CampusTalkState extends State<CampusTalk> {
  ScrollController _scrollController;
  int _page;
  CampusTalkProvider campusTalkProvider;

  void _scrollListener() {
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels != 0) {
        Future.delayed(Duration.zero, () {
          _page += 1;
          print('scrolled to bottom page is now $_page');
          Provider.of<CampusTalkProvider>(context, listen: false).fetchCampusTalkPostTLatestList(page: _page,paginationCheck: true);
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    campusTalkProvider = Provider.of<CampusTalkProvider>(context,listen: false);
    Future.delayed(Duration(seconds: 0), () {
      Provider.of<CampusTalkProvider>(context, listen: false).fetchCampusTalkPostTLatestList(page: 1);
    });
    _page = 1;
    _scrollController = new ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
  }

  final audioPlayer = AudioPlayer();

  Future<void> startAudio(String url,int index) async {
    print(url);
    print(index);
    print(campusTalkProvider.campusTalkPostsResultsLatestList[index].isPaused);
    if(campusTalkProvider.campusTalkPostsResultsLatestList[index].isPaused==true){
      for(int i=0;i<campusTalkProvider.campusTalkPostsResultsLatestList.length;i++){
        campusTalkProvider.campusTalkPostsResultsLatestList[i].isPlaying = false;
      }
      campusTalkProvider.campusTalkPostsResultsLatestList[index].isPaused = false;
      audioPlayer.play();
      setState(() {
        campusTalkProvider.campusTalkPostsResultsLatestList[index].isPlaying = true;
      });
      audioPlayer.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          setState(() {
            campusTalkProvider.campusTalkPostsResultsLatestList[index].isPlaying = false;
            campusTalkProvider.campusTalkPostsResultsLatestList[index].isPaused = false;
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
              campusTalkProvider.campusTalkPostsResultsLatestList[index].isPlaying = false;
              campusTalkProvider.campusTalkPostsResultsLatestList[index].isPaused = false;
            });
          }
        });

        audioPlayer.positionStream.listen((event) {
          setState(() {
            //currentDuration = event;
          });
        });

        audioPlayer.stop();
        for(int i=0;i<campusTalkProvider.campusTalkPostsResultsLatestList.length;i++){
          campusTalkProvider.campusTalkPostsResultsLatestList[i].isPlaying = false;
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
            campusTalkProvider.campusTalkPostsResultsLatestList[index].isPlaying = true;
          });
        }else{
          setState(() {
            campusTalkProvider.campusTalkPostsResultsLatestList[index].isLoadingAudio = true;
          });

          String path = await downloadAudio(url);

          setState(() {
            campusTalkProvider.campusTalkPostsResultsLatestList[index].isLoadingAudio = false;
          });

          if(path !=""){
            await audioPlayer.setFilePath(path);
            audioPlayer.play();
            setState(() {
              campusTalkProvider.campusTalkPostsResultsLatestList[index].isPlaying = true;
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
      campusTalkProvider.campusTalkPostsResultsLatestList[index].isPlaying = false;
      campusTalkProvider.campusTalkPostsResultsLatestList[index].isPaused = true;
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
    return Consumer<CampusTalkProvider>(
      builder: (ctx, campusTalkProvider, _) {
        if (campusTalkProvider.talkPostLatestLoader && campusTalkProvider.campusTalkPostsResultsLatestList.length == 0) {
          return timelineLoader();
        }
        if (campusTalkProvider.error != '') {
          return Center(
            child: Container(
              color: Colors.red,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${campusTalkProvider.error}',
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
          );
        }
        return campusTalkProvider.campusTalkPostsResultsLatestList.length == 0 ?
        Center(
          child: Text(
            'Nothing new',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
              letterSpacing: 0.1,
              color: themeController.isDarkMode?Colors.white:Colors.black,
            ),
          ),
        ):
        RefreshIndicator(
          onRefresh: () {
            _page = 1;
            return campusTalkProvider.fetchCampusTalkPostTLatestList(page: 1);
          },
          child: ListView.builder(
            padding: EdgeInsets.zero,
            controller: _scrollController,
            shrinkWrap: true,
            physics: ScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: campusTalkProvider.campusTalkPostsResultsLatestList.length,
            itemBuilder: (context, index) {
              Result campusTalkData = campusTalkProvider.campusTalkPostsResultsLatestList[index];
              return CampusTalkRow(
                talkId: campusTalkData.id,
                description: campusTalkData.description,
                title: campusTalkData.title,
                user: campusTalkData.user,
                isAnonymous: campusTalkData.isAnonymous,
                anonymousUser: campusTalkData.anonymousUser,
                url: campusTalkData.url,
                createdAt: "${DateFormat.yMMMEd().format(DateFormat("yyyy-MM-dd").parse(campusTalkData.createdAt, true))}",
                rowIndex: index,
                isBookmarked: campusTalkData.isBookmarked,
                isLiked: campusTalkData.isLiked,
                likesCount: campusTalkData.likesCount,
                commentsCount: campusTalkData.commentsCount,
                isLatest: true,
                campusTalkType: campusTalkData.campusTalkTypes,
                isDisLiked: campusTalkData.isDisliked,
                disLikeCount: campusTalkData.dislikesCount,
                image: campusTalkData.photoUrl,
                video: campusTalkData.videoUrl,
                audio: campusTalkData.audioUrl,
                isPlaying: campusTalkData.isPlaying,
                isPaused: campusTalkData.isPaused,
                isLoadingAudio: campusTalkData.isLoadingAudio,
                startAudio: startAudio,
                pauseAudio: pauseAudio,
              );
            },
          ),
        );
      },
    );
  }
}
