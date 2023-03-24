import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../../Providers/FeedProvider.dart';
import '../../../Widget/Home/HomeRow.dart';
import '../../../Widget/Loaders/Shimmer.dart';
import '../../../asset/Colors/MateColors.dart';
import '../../../controller/theme_controller.dart';
import 'feed_search.dart';
import 'package:http/http.dart'as http;

class GlobalFeed extends StatefulWidget {
  const GlobalFeed({Key key}) : super(key: key);

  @override
  State<GlobalFeed> createState() => _GlobalFeedState();
}

class _GlobalFeedState extends State<GlobalFeed> {
  ThemeController themeController = Get.find<ThemeController>();
  ScrollController _scrollController;
  int _pageGlobal;
  FeedProvider feedProvider;

  @override
  void initState() {
    feedProvider = Provider.of<FeedProvider>(context, listen: false);
    Future.delayed(Duration(milliseconds: 600), (){
      Provider.of<FeedProvider>(context, listen: false).fetchFeedList(page: 1);
    });
    _pageGlobal = 1;
    _scrollController = new ScrollController()..addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels != 0) {
        Future.delayed(Duration.zero,(){
          _pageGlobal += 1;
          print('scrolled to bottom page is now $_pageGlobal');
          Provider.of<FeedProvider>(context, listen: false).fetchFeedList(page: _pageGlobal, paginationCheck: true,);
        });
      }
    }
  }

  final audioPlayer = AudioPlayer();

  Future<void> startAudio(String url,int index) async {
    print(url);
    print(index);
    print(feedProvider.feedList[index].isPaused);
    if(feedProvider.feedList[index].isPaused==true){
      for(int i=0;i<feedProvider.feedList.length;i++){
        feedProvider.feedList[i].isPlaying = false;
      }
      feedProvider.feedList[index].isPaused = false;
      audioPlayer.play();
      setState(() {
        feedProvider.feedList[index].isPlaying = true;
      });
      audioPlayer.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          setState(() {
            feedProvider.feedList[index].isPlaying = false;
            feedProvider.feedList[index].isPaused = false;
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
              feedProvider.feedList[index].isPlaying = false;
              feedProvider.feedList[index].isPaused = false;
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
            feedProvider.feedList[index].isPlaying = true;
          });
        }else{
          setState(() {
            feedProvider.feedList[index].isLoadingAudio = true;
          });

          String path = await downloadAudio(url);

          setState(() {
            feedProvider.feedList[index].isLoadingAudio = false;
          });

          if(path !=""){
            await audioPlayer.setFilePath(path);
            audioPlayer.play();
            setState(() {
              feedProvider.feedList[index].isPlaying = true;
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
      feedProvider.feedList[index].isPlaying = false;
      feedProvider.feedList[index].isPaused = true;
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
    return Scaffold(
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
                    "Global Feed",
                    style: TextStyle(
                      color: themeController.isDarkMode ? Colors.white : MateColors.drawerTileColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 18.0,
                    ),
                  ),
                  SizedBox(),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(()=>FeedSearch(text: ''));
              },
              child: Container(
                margin: EdgeInsets.only(left: 16,right: 16,top: 20,bottom: 10),
                height: 60,
                decoration: BoxDecoration(
                  color: themeController.isDarkMode ? MateColors.containerDark : MateColors.containerLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Search posts, mates, communities",
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
                        color: themeController.isDarkMode?MateColors.bottomSheetItemBackgroundDark:MateColors.containerLight,
                      ),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
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
            Expanded(
              child: Consumer<FeedProvider>(
                builder: (ctx, feedProvider, _) {
                  if (feedProvider.feedLoader && feedProvider.feedList.length == 0) {
                    return timelineLoader();
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
                        ),
                      ),
                    );
                  }
                  return feedProvider.feedList.length == 0 ?
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
                      _pageGlobal = 1;
                      return feedProvider.fetchFeedList(page: 1);
                    },
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: feedProvider.feedList.length,
                      itemBuilder: (_, index) {
                        var feedItem = feedProvider.feedList[index];
                        return Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: HomeRow(
                            previousPageUserId: '',
                            id: feedItem.id,
                            feedId: feedItem.feedId,
                            title: feedItem.title,
                            feedType: feedItem.feedTypes,
                            start: feedItem.start,
                            end: feedItem.end,
                            calenderDate: feedItem.feedCreatedAt,
                            description: feedItem.description,
                            created: feedItem.created,
                            user: feedItem.user,
                            location: feedItem.location,
                            hyperlinkText: feedItem.hyperlinkText,
                            hyperlink: feedItem.hyperlink,
                            media: feedItem.media,
                            isLiked: feedItem.isLiked,
                            liked: feedItem.isLiked!=null?true:false,
                            bookMarked: feedItem.isBookmarked,
                            isFollowed: feedItem.isFollowed??false,
                            likeCount: feedItem.likeCount,
                            bookmarkCount: feedItem.bookmarkCount,
                            shareCount: feedItem.shareCount,
                            commentCount: feedItem.commentCount,
                            isShared: feedItem.isShared,
                            indexVal: index,
                            pageType : "TimeLineGlobal",
                            mediaOther: feedItem.mediaOther,
                            isPlaying: feedItem.isPlaying,
                            isPaused: feedItem.isPaused,
                            isLoadingAudio: feedItem.isLoadingAudio,
                            startAudio: startAudio,
                            pauseAudio: pauseAudio,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
