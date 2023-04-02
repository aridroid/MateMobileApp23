import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mate_app/Providers/campusTalkProvider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mate_app/Model/campusTalkPostsModel.dart';
import 'package:shimmer/shimmer.dart';

import '../../../Services/campusTalkService.dart';
import '../../../Widget/Home/Community/campusTalkRow.dart';
import 'package:http/http.dart' as http;
import '../../../Widget/Loaders/Shimmer.dart';
import '../../../Widget/searchShimmer.dart';
import '../../../asset/Colors/MateColors.dart';
import '../../../constant.dart';
import '../../../controller/theme_controller.dart';
import 'package:mate_app/Model/campusTalkTypeModel.dart' as campusTalkTypeModel;

class CampusTalkSearch extends StatefulWidget {
  final String searchType;
  const CampusTalkSearch({Key key, this.searchType}) : super(key: key);

  @override
  State<CampusTalkSearch> createState() => _CampusTalkSearchState();
}

class _CampusTalkSearchState extends State<CampusTalkSearch> {
  TextEditingController _textEditingController = TextEditingController();
  ThemeController themeController = Get.find<ThemeController>();
  String token = "";
  int page = 1;
  bool enterFutureBuilder = false;
  bool doingPagination = false;
  ScrollController _scrollController;
  CampusTalkProvider campusTalkProvider;
  List<campusTalkTypeModel.Data> type = [];
  CampusTalkService _campusTalkService = CampusTalkService();
  bool isLoadingType = true;
  List<bool> selected = [];
  String typeKey = "";

  Timer _throttle;
  _onSearchChanged() {
    if (_throttle?.isActive??false) _throttle?.cancel();
    _throttle = Timer(const Duration(milliseconds: 200), () {
      if(_textEditingController.text.length>2){
        fetchData();
      }
    });
  }

  fetchData()async{
    page = 1;
    campusTalkProvider.campusTalkBySearchResultsList.clear();
    await campusTalkProvider.fetchCampusTalkPostSearchList(
      page: page,
      text: _textEditingController.text,
      searchType: widget.searchType,
      paginationCheck: false,
      typeKey: typeKey,
    );
  }

  void _scrollListener(){
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels != 0) {
        Future.delayed(Duration.zero,()async{
          page += 1;
          print('scrolled to bottom page is now $page');
          await campusTalkProvider.fetchCampusTalkPostSearchList(
            page: page,
            text: _textEditingController.text,
            searchType: widget.searchType,
            paginationCheck: true,
          );
        });
      }
    }
  }

  @override
  void initState() {
    campusTalkProvider = Provider.of<CampusTalkProvider>(context, listen: false);
    campusTalkProvider.campusTalkBySearchResultsList.clear();
    getStoredValue();
    _textEditingController.addListener(_onSearchChanged);
    _scrollController = new ScrollController()..addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.removeListener(_onSearchChanged);
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
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

  final audioPlayer = AudioPlayer();

  Future<void> startAudio(String url,int index) async {
    print(url);
    print(index);
    print(campusTalkProvider.campusTalkBySearchResultsList[index].isPaused);
    if(campusTalkProvider.campusTalkBySearchResultsList[index].isPaused==true){
      for(int i=0;i<campusTalkProvider.campusTalkBySearchResultsList.length;i++){
        campusTalkProvider.campusTalkBySearchResultsList[i].isPlaying = false;
      }
      campusTalkProvider.campusTalkBySearchResultsList[index].isPaused = false;
      audioPlayer.play();
      setState(() {
        campusTalkProvider.campusTalkBySearchResultsList[index].isPlaying = true;
      });
      audioPlayer.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          setState(() {
            campusTalkProvider.campusTalkBySearchResultsList[index].isPlaying = false;
            campusTalkProvider.campusTalkBySearchResultsList[index].isPaused = false;
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
              campusTalkProvider.campusTalkBySearchResultsList[index].isPlaying = false;
              campusTalkProvider.campusTalkBySearchResultsList[index].isPaused = false;
            });
          }
        });

        audioPlayer.positionStream.listen((event) {
          setState(() {
            //currentDuration = event;
          });
        });

        audioPlayer.stop();
        for(int i=0;i<campusTalkProvider.campusTalkBySearchResultsList.length;i++){
          campusTalkProvider.campusTalkBySearchResultsList[i].isPlaying = false;
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
            campusTalkProvider.campusTalkBySearchResultsList[index].isPlaying = true;
          });
        }else{
          setState(() {
            campusTalkProvider.campusTalkBySearchResultsList[index].isLoadingAudio = true;
          });

          String path = await downloadAudio(url);

          setState(() {
            campusTalkProvider.campusTalkBySearchResultsList[index].isLoadingAudio = false;
          });

          if(path !=""){
            await audioPlayer.setFilePath(path);
            audioPlayer.play();
            setState(() {
              campusTalkProvider.campusTalkBySearchResultsList[index].isPlaying = true;
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
      campusTalkProvider.campusTalkBySearchResultsList[index].isPlaying = false;
      campusTalkProvider.campusTalkBySearchResultsList[index].isPaused = true;
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _textEditingController,
                  onChanged: (value){
                    if(value.length>2){
                      _onSearchChanged();
                    }
                  },
                  cursorColor: themeController.isDarkMode?MateColors.helpingTextDark:MateColors.helpingTextLight,
                  style:  TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.1,
                    color: themeController.isDarkMode?Colors.white:Colors.black,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: themeController.isDarkMode ? MateColors.containerDark : MateColors.containerLight,
                    hintStyle: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      color: themeController.isDarkMode?MateColors.helpingTextDark:MateColors.helpingTextLight,
                    ),
                    hintText: "Search",
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 15,top: 15,bottom: 15),
                      child: Image.asset(
                        "lib/asset/homePageIcons/searchPurple@3x.png",
                        height: 10,
                        width: 10,
                        color: themeController.isDarkMode?Colors.white:Colors.black,
                      ),
                    ),
                    suffixIcon: InkWell(
                      onTap: (){
                        Get.back();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16,right: 15),
                        child: Text(
                          "Close",
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            color: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                          ),
                        ),
                      ),
                    ),
                    enabledBorder: commonBorder,
                    focusedBorder: commonBorder,
                  ),
                ),
              ),
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
                            selected[i] = true;
                          }else{
                            selected[i] = false;
                          }
                        }
                        typeKey = type[index].name;
                        _textEditingController.clear();
                        setState(() {});
                        fetchData();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: themeController.isDarkMode?MateColors.smallContainerDark:MateColors.smallContainerLight,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15,right: 15),
                          child: Center(
                            child: Text("${type[index].name}",
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
                child: Consumer<CampusTalkProvider>(
                  builder: (context,campusTalk,_){
                    return ListView(
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                      controller: _scrollController,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      padding: EdgeInsets.only(top: 15),
                      children: [
                        campusTalkProvider.campusTalkBySearchResultsList.length!=0?
                        ListView.builder(
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount: campusTalkProvider.campusTalkBySearchResultsList.length,
                          itemBuilder: (context,index){
                            Result campusTalkData = campusTalkProvider.campusTalkBySearchResultsList[index];
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
                              isSearch: true,
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
                        ):
                        campusTalkProvider.searchLoader?
                        timelineLoader():
                        Container(
                          height: MediaQuery.of(context).size.height/1.2,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 50),
                              child: Text(
                                "Try searching by post title, description, or author.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  color: themeController.isDarkMode?Colors.white.withOpacity(0.7):Colors.black.withOpacity(0.5),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
