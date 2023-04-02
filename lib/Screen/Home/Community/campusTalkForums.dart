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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../../Services/campusTalkService.dart';
import '../../../Widget/searchShimmer.dart';
import '../../../controller/theme_controller.dart';
import 'campusTalkSearch.dart';
import 'package:mate_app/Model/campusTalkTypeModel.dart' as campusTalkTypeModel;
import 'package:http/http.dart' as http;

class CampusTalkScreenForums extends StatefulWidget {
  const CampusTalkScreenForums({Key key}) : super(key: key);

  @override
  _CampusTalkScreenForumsState createState() => _CampusTalkScreenForumsState();
}

class _CampusTalkScreenForumsState extends State<CampusTalkScreenForums> with TickerProviderStateMixin {
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
                    "Forums",
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
                        Get.to(()=>CampusTalkSearch(searchType: 'Global',));
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
  List<campusTalkTypeModel.Data> type = [];
  CampusTalkService _campusTalkService = CampusTalkService();
  bool isLoadingType = true;
  List<bool> selected = [];
  String typeKey = "";
  String token = "";
  CampusTalkProvider campusTalkProvider;

  void _scrollListener() {
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels != 0) {
        Future.delayed(Duration.zero, () {
          _page += 1;
          print('scrolled to bottom page is now $_page');
          Provider.of<CampusTalkProvider>(context, listen: false).fetchCampusTalkPostForumsList(
            page: _page,
            paginationCheck: true,
            typeKey: typeKey,
          );
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    campusTalkProvider = Provider.of<CampusTalkProvider>(context,listen: false);
    getStoredValue();
    Future.delayed(Duration(seconds: 0), () {
      Provider.of<CampusTalkProvider>(context, listen: false).fetchCampusTalkPostForumsList(page: 1);
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

  getStoredValue()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token");
    type = await _campusTalkService.getType(token: token);
    for(int i=0;i<type.length;i++){
      selected.add(false);
    }
    setState(() {
      isLoadingType = false;
    });
  }

  fetchData()async{
    _page = 1;
    Provider.of<CampusTalkProvider>(context, listen: false).fetchCampusTalkPostForumsList(
      page: _page,
      paginationCheck: true,
      typeKey: typeKey,
    );
  }


  final audioPlayer = AudioPlayer();

  Future<void> startAudio(String url,int index) async {
    print(url);
    print(index);
    print(campusTalkProvider.campusTalkPostsResultsForumsList[index].isPaused);
    if(campusTalkProvider.campusTalkPostsResultsForumsList[index].isPaused==true){
      for(int i=0;i<campusTalkProvider.campusTalkPostsResultsForumsList.length;i++){
        campusTalkProvider.campusTalkPostsResultsForumsList[i].isPlaying = false;
      }
      campusTalkProvider.campusTalkPostsResultsForumsList[index].isPaused = false;
      audioPlayer.play();
      setState(() {
        campusTalkProvider.campusTalkPostsResultsForumsList[index].isPlaying = true;
      });
      audioPlayer.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          setState(() {
            campusTalkProvider.campusTalkPostsResultsForumsList[index].isPlaying = false;
            campusTalkProvider.campusTalkPostsResultsForumsList[index].isPaused = false;
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
              campusTalkProvider.campusTalkPostsResultsForumsList[index].isPlaying = false;
              campusTalkProvider.campusTalkPostsResultsForumsList[index].isPaused = false;
            });
          }
        });

        audioPlayer.positionStream.listen((event) {
          setState(() {
            //currentDuration = event;
          });
        });

        audioPlayer.stop();
        for(int i=0;i<campusTalkProvider.campusTalkPostsResultsForumsList.length;i++){
          campusTalkProvider.campusTalkPostsResultsForumsList[i].isPlaying = false;
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
            campusTalkProvider.campusTalkPostsResultsForumsList[index].isPlaying = true;
          });
        }else{
          setState(() {
            campusTalkProvider.campusTalkPostsResultsForumsList[index].isLoadingAudio = true;
          });

          String path = await downloadAudio(url);

          setState(() {
            campusTalkProvider.campusTalkPostsResultsForumsList[index].isLoadingAudio = false;
          });

          if(path !=""){
            await audioPlayer.setFilePath(path);
            audioPlayer.play();
            setState(() {
              campusTalkProvider.campusTalkPostsResultsForumsList[index].isPlaying = true;
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
      campusTalkProvider.campusTalkPostsResultsForumsList[index].isPlaying = false;
      campusTalkProvider.campusTalkPostsResultsForumsList[index].isPaused = true;
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
        return RefreshIndicator(
          onRefresh: () {
            _page = 1;
            return campusTalkProvider.fetchCampusTalkPostForumsList(page: 1);
          },
          child: Column(
            children: [
              !isLoadingType?
              Container(
                height: type.isNotEmpty?39:0,
                margin: EdgeInsets.only(left: 16,top: 16),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: type.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: InkWell(
                      onTap: () {
                        for(int i=0;i<selected.length;i++){
                          if(i==index){
                            if(selected[i]){
                              typeKey = "";
                              selected[i] = false;
                            }else{
                              typeKey = type[index].name;
                              selected[i] = true;
                            }
                          }else{
                            selected[i] = false;
                          }
                        }
                        setState(() {});
                        fetchData();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: selected[index]?
                          themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight:
                          themeController.isDarkMode?MateColors.smallContainerDark:MateColors.smallContainerLight,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15,right: 15),
                          child: Center(
                            child: Text("${type[index].name}",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 15,
                                color: selected[index]?
                                themeController.isDarkMode?Colors.black:Colors.white:
                                themeController.isDarkMode?Colors.white:Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ):
              Container(
                height: 55,
                child: Shimmer.fromColors(
                  baseColor: themeController.isDarkMode?Colors.white12:Colors.black12,
                  highlightColor: themeController.isDarkMode?Colors.white54:Colors.black54,
                  enabled: true,
                  child: SearchShimmer(),
                ),
              ),
              Expanded(
                child:
                campusTalkProvider.talkPostForumsLoader && campusTalkProvider.campusTalkPostsResultsForumsList.length == 0?
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: timelineLoader(),
                ):
                campusTalkProvider.campusTalkPostsResultsForumsList.length == 0 ?
                Center(
                  child: Text(
                    'No data found',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                      letterSpacing: 0.1,
                      color: themeController.isDarkMode?Colors.white:Colors.black,
                    ),
                  ),
                ):
                ListView.builder(
                  padding: EdgeInsets.only(top: 10),
                  controller: _scrollController,
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: campusTalkProvider.campusTalkPostsResultsForumsList.length,
                  itemBuilder: (context, index) {
                    Result campusTalkData = campusTalkProvider.campusTalkPostsResultsForumsList[index];
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
                      isForums: true,
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
              ),
            ],
          ),
        );
      },
    );
  }
}
