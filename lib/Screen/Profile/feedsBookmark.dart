import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mate_app/Model/bookmarkByUserModel.dart';
import 'package:mate_app/Providers/FeedProvider.dart';
import 'package:mate_app/Widget/Home/HomeRow.dart';
import 'package:mate_app/Widget/Loaders/Shimmer.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart'as http;

import '../../asset/Colors/MateColors.dart';

class FeedsBookmark extends StatefulWidget {
  const FeedsBookmark({Key key}) : super(key: key);

  @override
  _FeedsBookmarkState createState() => _FeedsBookmarkState();
}

class _FeedsBookmarkState extends State<FeedsBookmark> {

  FeedProvider feedProvider;

  final audioPlayer = AudioPlayer();

  Future<void> startAudio(String url,int index) async {
    print(url);
    print(index);
    print(feedProvider.bookmarkByUserData.data.feeds[index].isPaused);
    if(feedProvider.bookmarkByUserData.data.feeds[index].isPaused==true){
      for(int i=0;i<feedProvider.bookmarkByUserData.data.feeds.length;i++){
        feedProvider.bookmarkByUserData.data.feeds[i].isPlaying = false;
      }
      feedProvider.bookmarkByUserData.data.feeds[index].isPaused = false;
      audioPlayer.play();
      setState(() {
        feedProvider.bookmarkByUserData.data.feeds[index].isPlaying = true;
      });
      audioPlayer.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          setState(() {
            feedProvider.bookmarkByUserData.data.feeds[index].isPlaying = false;
            feedProvider.bookmarkByUserData.data.feeds[index].isPaused = false;
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
              feedProvider.bookmarkByUserData.data.feeds[index].isPlaying = false;
              feedProvider.bookmarkByUserData.data.feeds[index].isPaused = false;
            });
          }
        });

        audioPlayer.positionStream.listen((event) {
          setState(() {
            //currentDuration = event;
          });
        });

        audioPlayer.stop();
        for(int i=0;i<feedProvider.bookmarkByUserData.data.feeds.length;i++){
          feedProvider.bookmarkByUserData.data.feeds[i].isPlaying = false;
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
            feedProvider.bookmarkByUserData.data.feeds[index].isPlaying = true;
          });
        }else{
          setState(() {
            feedProvider.bookmarkByUserData.data.feeds[index].isLoadingAudio = true;
          });

          String path = await downloadAudio(url);

          setState(() {
            feedProvider.bookmarkByUserData.data.feeds[index].isLoadingAudio = false;
          });

          if(path !=""){
            await audioPlayer.setFilePath(path);
            audioPlayer.play();
            setState(() {
              feedProvider.bookmarkByUserData.data.feeds[index].isPlaying = true;
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
      feedProvider.bookmarkByUserData.data.feeds[index].isPlaying = false;
      feedProvider.bookmarkByUserData.data.feeds[index].isPaused = true;
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
    feedProvider = Provider.of<FeedProvider>(context, listen: false);
    super.initState();
    Future.delayed(Duration(milliseconds: 600),()=>Provider.of<FeedProvider>(context, listen: false).allBookmarkedFeed());
  }

  @override
  Widget build(BuildContext context) {
    final scH = MediaQuery.of(context).size.height;
    final scW = MediaQuery.of(context).size.width;
    return Consumer<FeedProvider>(
      builder: (context, value, child) {
        if(!value.allbookmarkedFeedLoader && value.bookmarkByUserData!=null && value.bookmarkByUserData.data.feeds!=null){
          return ListView.builder(
            itemCount: value.bookmarkByUserData.data.feeds.length,
            padding: EdgeInsets.only(top: 10,left: 16,right: 16,bottom: 16),
            itemBuilder: (context, index) {
              Feeds feeds= value.bookmarkByUserData.data.feeds[index];
              return HomeRow(
                id: feeds.id,
                feedId: feeds.feedId,
                title: feeds.title,
                feedType: feeds.feedTypes,
                start: feeds.start,
                end: feeds.end,
                calenderDate: feeds.feedCreatedAt,
                description: feeds.description,
                created: feeds.created,
                user: feeds.user,
                location: feeds.location,
                hyperlinkText: feeds.hyperlinkText,
                hyperlink: feeds.hyperlink,
                media: feeds.media,
                liked: feeds.isLiked!=null?true:false,
                isLiked: feeds.isLiked,
                bookMarked: feeds.isBookmarked,
                isFollowed: feeds.isFollowed,
                isBookmarkedPage: true,
                likeCount: feeds.likeCount,
                bookmarkCount: feeds.bookmarkCount,
                shareCount: feeds.shareCount,
                commentCount: feeds.commentCount,
                isShared: feeds.isShared,
                indexVal: index,
                pageType: "Bookmark",
                mediaOther: feeds.mediaOther,
                isPlaying: feeds.isPlaying,
                isPaused: feeds.isPaused,
                isLoadingAudio: feeds.isLoadingAudio,
                startAudio: startAudio,
                pauseAudio: pauseAudio,
              );
            },
          );
        }
        if (value.error != '') {
          return Center(
            child: Container(
              color: Colors.red,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${value.error}',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
        }
        if(value.allbookmarkedFeedLoader) {
          return timelineLoader();
        }
        return Container();
      },
    );

    //   Scaffold(
    //   body: Container(
    //     height: scH,
    //     width: scW,
    //     decoration: BoxDecoration(
    //       color: themeController.isDarkMode?Color(0xFF000000):Colors.white,
    //       image: DecorationImage(
    //         image: AssetImage(themeController.isDarkMode?'lib/asset/Background.png':'lib/asset/BackgroundLight.png'),
    //         fit: BoxFit.cover,
    //       ),
    //     ),
    //     child: Column(
    //       children: [
    //         Padding(
    //           padding: EdgeInsets.only(
    //             top: MediaQuery.of(context).size.height*0.07,
    //             left: 16,
    //             right: 16,
    //             bottom: 10,
    //           ),
    //           child: Row(
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             children: [
    //               GestureDetector(
    //                 onTap: (){
    //                   Get.back();
    //                 },
    //                 child: Icon(Icons.arrow_back_ios,
    //                   size: 20,
    //                   color: themeController.isDarkMode ? Colors.white : MateColors.blackTextColor,
    //                 ),
    //               ),
    //               Text(
    //                 "Home Feed",
    //                 style: TextStyle(
    //                   color: themeController.isDarkMode ? Colors.white : MateColors.blackTextColor,
    //                   fontWeight: FontWeight.w700,
    //                   fontSize: 17.0,
    //                 ),
    //               ),
    //               SizedBox(),
    //             ],
    //           ),
    //         ),
    //         Expanded(
    //           child: Consumer<FeedProvider>(
    //             builder: (context, value, child) {
    //               if(!value.allbookmarkedFeedLoader && value.bookmarkByUserData!=null && value.bookmarkByUserData.data.feeds!=null){
    //                 return ListView.builder(
    //                   itemCount: value.bookmarkByUserData.data.feeds.length,
    //                   padding: EdgeInsets.only(top: 10,left: 16,right: 16,bottom: 16),
    //                   itemBuilder: (context, index) {
    //                     Feeds feeds= value.bookmarkByUserData.data.feeds[index];
    //                     return HomeRow(
    //                       id: feeds.id,
    //                       feedId: feeds.feedId,
    //                       title: feeds.title,
    //                       feedType: feeds.feedTypes,
    //                       start: feeds.start,
    //                       end: feeds.end,
    //                       calenderDate: feeds.feedCreatedAt,
    //                       description: feeds.description,
    //                       created: feeds.created,
    //                       user: feeds.user,
    //                       location: feeds.location,
    //                       hyperlinkText: feeds.hyperlinkText,
    //                       hyperlink: feeds.hyperlink,
    //                       media: feeds.media,
    //                       liked: feeds.isLiked!=null?true:false,
    //                       isLiked: feeds.isLiked,
    //                       bookMarked: feeds.isBookmarked,
    //                       isFollowed: feeds.isFollowed,
    //                       isBookmarkedPage: true,
    //                       likeCount: feeds.likeCount,
    //                       bookmarkCount: feeds.bookmarkCount,
    //                       shareCount: feeds.shareCount,
    //                       commentCount: feeds.commentCount,
    //                       isShared: feeds.isShared,
    //                       indexVal: index,
    //                       pageType: "Bookmark",
    //                       mediaOther: feeds.mediaOther,
    //                       isPlaying: feeds.isPlaying,
    //                       isPaused: feeds.isPaused,
    //                       isLoadingAudio: feeds.isLoadingAudio,
    //                       startAudio: startAudio,
    //                       pauseAudio: pauseAudio,
    //                     );
    //                   },
    //                 );
    //               }
    //               if (value.error != '') {
    //                 return Center(
    //                   child: Container(
    //                     color: Colors.red,
    //                     child: Padding(
    //                       padding: const EdgeInsets.all(8.0),
    //                       child: Text(
    //                         '${value.error}',
    //                         style: TextStyle(
    //                           color: Colors.white,
    //                         ),
    //                       ),
    //                     ),
    //                   ),
    //                 );
    //               }
    //               if(value.allbookmarkedFeedLoader) {
    //                 return timelineLoader();
    //               }
    //               return Container();
    //             },
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
