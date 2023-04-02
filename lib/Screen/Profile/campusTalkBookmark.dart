import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mate_app/Model/campusTalkPostsModel.dart';
import 'package:mate_app/Providers/campusTalkProvider.dart';
import 'package:mate_app/Widget/Home/Community/campusTalkRow.dart';
import 'package:mate_app/Widget/Loaders/Shimmer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;

class CampusTalkBookmark extends StatefulWidget {
  const CampusTalkBookmark({Key key}) : super(key: key);

  @override
  _CampusTalkBookmarkState createState() => _CampusTalkBookmarkState();
}

class _CampusTalkBookmarkState extends State<CampusTalkBookmark> {
  CampusTalkProvider campusTalkProvider;

  @override
  void initState() {
    super.initState();
    campusTalkProvider = Provider.of<CampusTalkProvider>(context,listen: false);
    Future.delayed(Duration(milliseconds: 600), () {Provider.of<CampusTalkProvider>(context, listen: false).fetchCampusTalkPostBookmarkedList();});
  }

  final audioPlayer = AudioPlayer();

  Future<void> startAudio(String url,int index) async {
    print(url);
    print(index);
    print(campusTalkProvider.campusTalkPostsBookmarkData.data.result[index].isPaused);
    if(campusTalkProvider.campusTalkPostsBookmarkData.data.result[index].isPaused==true){
      for(int i=0;i<campusTalkProvider.campusTalkPostsBookmarkData.data.result.length;i++){
        campusTalkProvider.campusTalkPostsBookmarkData.data.result[i].isPlaying = false;
      }
      campusTalkProvider.campusTalkPostsBookmarkData.data.result[index].isPaused = false;
      audioPlayer.play();
      setState(() {
        campusTalkProvider.campusTalkPostsBookmarkData.data.result[index].isPlaying = true;
      });
      audioPlayer.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          setState(() {
            campusTalkProvider.campusTalkPostsBookmarkData.data.result[index].isPlaying = false;
            campusTalkProvider.campusTalkPostsBookmarkData.data.result[index].isPaused = false;
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
              campusTalkProvider.campusTalkPostsBookmarkData.data.result[index].isPlaying = false;
              campusTalkProvider.campusTalkPostsBookmarkData.data.result[index].isPaused = false;
            });
          }
        });

        audioPlayer.positionStream.listen((event) {
          setState(() {
            //currentDuration = event;
          });
        });

        audioPlayer.stop();
        for(int i=0;i<campusTalkProvider.campusTalkPostsBookmarkData.data.result.length;i++){
          campusTalkProvider.campusTalkPostsBookmarkData.data.result[i].isPlaying = false;
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
            campusTalkProvider.campusTalkPostsBookmarkData.data.result[index].isPlaying = true;
          });
        }else{
          setState(() {
            campusTalkProvider.campusTalkPostsBookmarkData.data.result[index].isLoadingAudio = true;
          });

          String path = await downloadAudio(url);

          setState(() {
            campusTalkProvider.campusTalkPostsBookmarkData.data.result[index].isLoadingAudio = false;
          });

          if(path !=""){
            await audioPlayer.setFilePath(path);
            audioPlayer.play();
            setState(() {
              campusTalkProvider.campusTalkPostsBookmarkData.data.result[index].isPlaying = true;
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
      campusTalkProvider.campusTalkPostsBookmarkData.data.result[index].isPlaying = false;
      campusTalkProvider.campusTalkPostsBookmarkData.data.result[index].isPaused = true;
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
    return Consumer<CampusTalkProvider>(
      builder: (ctx, campusTalkProvider, _) {
        if (!campusTalkProvider.talkPostBookmarkLoader && campusTalkProvider.campusTalkPostsBookmarkData!=null) {
          return ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 10),
              itemCount: campusTalkProvider.campusTalkPostsBookmarkData.data.result.length,
              itemBuilder: (context, index) {
                Result campusTalkData = campusTalkProvider.campusTalkPostsBookmarkData.data.result[index];
                return CampusTalkRow(
                  isBookmarkedPage: true,
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
              });
        }
        if (campusTalkProvider.error != '') {
          return Center(
            child: Container(
              color: Colors.red,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${campusTalkProvider.error}',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          );
        }
        if(campusTalkProvider.talkPostBookmarkLoader) {
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
    //                 "Campus Forum",
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
    //           child: Consumer<CampusTalkProvider>(
    //               builder: (ctx, campusTalkProvider, _) {
    //                 if (!campusTalkProvider.talkPostBookmarkLoader && campusTalkProvider.campusTalkPostsBookmarkData!=null) {
    //                   return ListView.builder(
    //                       shrinkWrap: true,
    //                       padding: EdgeInsets.only(top: 10),
    //                       itemCount: campusTalkProvider.campusTalkPostsBookmarkData.data.result.length,
    //                       itemBuilder: (context, index) {
    //                         Result campusTalkData = campusTalkProvider.campusTalkPostsBookmarkData.data.result[index];
    //                         return CampusTalkRow(
    //                             isBookmarkedPage: true,
    //                             talkId: campusTalkData.id,
    //                             description: campusTalkData.description,
    //                             title: campusTalkData.title,
    //                             user: campusTalkData.user,
    //                             isAnonymous: campusTalkData.isAnonymous,
    //                             anonymousUser: campusTalkData.anonymousUser,
    //                             url: campusTalkData.url,
    //                             createdAt: "${DateFormat.yMMMEd().format(DateFormat("yyyy-MM-dd").parse(campusTalkData.createdAt, true))}",
    //                             rowIndex: index,
    //                             isBookmarked: campusTalkData.isBookmarked,
    //                             isLiked: campusTalkData.isLiked,
    //                             likesCount: campusTalkData.likesCount,
    //                             commentsCount: campusTalkData.commentsCount,
    //                         );
    //                       });
    //                 }
    //                 if (campusTalkProvider.error != '') {
    //                   return Center(
    //                     child: Container(
    //                       color: Colors.red,
    //                       child: Padding(
    //                         padding: const EdgeInsets.all(8.0),
    //                         child: Text(
    //                           '${campusTalkProvider.error}',
    //                           style: TextStyle(color: Colors.white),
    //                         ),
    //                       ),
    //                     ),
    //                   );
    //                 }
    //                 if(campusTalkProvider.talkPostBookmarkLoader) {
    //                   return timelineLoader();
    //                 }
    //                 return Container();
    //               },
    //             ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
