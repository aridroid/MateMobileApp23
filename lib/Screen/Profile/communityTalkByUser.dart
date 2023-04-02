import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mate_app/Model/campusTalkPostsModel.dart';
import 'package:mate_app/Providers/campusTalkProvider.dart';
import 'package:http/http.dart' as http;
import 'package:mate_app/Widget/Loaders/Shimmer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mate_app/asset/Colors/MateColors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../Widget/Home/Community/campusTalkRow.dart';

class CampusTalkByUser extends StatefulWidget {

  final String uuid;

  const CampusTalkByUser({Key key, @required this.uuid}) : super(key: key);
  
  @override
  _CampusTalkByUserState createState() => _CampusTalkByUserState();
}

class _CampusTalkByUserState extends State<CampusTalkByUser> {
  ScrollController _scrollController;
  int _page;
  CampusTalkProvider campusTalkProvider;

  void _scrollListener() {
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels != 0) {
        Future.delayed(Duration.zero, () {
          _page += 1;
          print('scrolled to bottom page is now $_page');
          Provider.of<CampusTalkProvider>(context, listen: false).fetchCampusTalkByAuthUser(widget.uuid, page: _page);
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    campusTalkProvider = Provider.of<CampusTalkProvider>(context,listen: false);
    Future.delayed(Duration(seconds: 0), () {
      Provider.of<CampusTalkProvider>(context, listen: false).fetchCampusTalkByAuthUser(widget.uuid, page: 1);
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
    print(campusTalkProvider.campusTalkByUserPostsResultsList[index].isPaused);
    if(campusTalkProvider.campusTalkByUserPostsResultsList[index].isPaused==true){
      for(int i=0;i<campusTalkProvider.campusTalkByUserPostsResultsList.length;i++){
        campusTalkProvider.campusTalkByUserPostsResultsList[i].isPlaying = false;
      }
      campusTalkProvider.campusTalkByUserPostsResultsList[index].isPaused = false;
      audioPlayer.play();
      setState(() {
        campusTalkProvider.campusTalkByUserPostsResultsList[index].isPlaying = true;
      });
      audioPlayer.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          setState(() {
            campusTalkProvider.campusTalkByUserPostsResultsList[index].isPlaying = false;
            campusTalkProvider.campusTalkByUserPostsResultsList[index].isPaused = false;
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
              campusTalkProvider.campusTalkByUserPostsResultsList[index].isPlaying = false;
              campusTalkProvider.campusTalkByUserPostsResultsList[index].isPaused = false;
            });
          }
        });

        audioPlayer.positionStream.listen((event) {
          setState(() {
            //currentDuration = event;
          });
        });

        audioPlayer.stop();
        for(int i=0;i<campusTalkProvider.campusTalkByUserPostsResultsList.length;i++){
          campusTalkProvider.campusTalkByUserPostsResultsList[i].isPlaying = false;
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
            campusTalkProvider.campusTalkByUserPostsResultsList[index].isPlaying = true;
          });
        }else{
          setState(() {
            campusTalkProvider.campusTalkByUserPostsResultsList[index].isLoadingAudio = true;
          });

          String path = await downloadAudio(url);

          setState(() {
            campusTalkProvider.campusTalkByUserPostsResultsList[index].isLoadingAudio = false;
          });

          if(path !=""){
            await audioPlayer.setFilePath(path);
            audioPlayer.play();
            setState(() {
              campusTalkProvider.campusTalkByUserPostsResultsList[index].isPlaying = true;
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
      campusTalkProvider.campusTalkByUserPostsResultsList[index].isPlaying = false;
      campusTalkProvider.campusTalkByUserPostsResultsList[index].isPaused = true;
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
        print("timline consumer is called");

        if (campusTalkProvider.talkPostByUserLoader && campusTalkProvider.campusTalkByUserPostsResultsList.length == 0) {
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
                      style: TextStyle(color: Colors.white),
                    ),
                  )));
        }

        return campusTalkProvider.campusTalkByUserPostsResultsList.length == 0
            ? Center(
          child: Text(
            'Nothing new',
            style: TextStyle(color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor),
          ),
        )
            : RefreshIndicator(
          onRefresh: () {
            _page = 1;
            return campusTalkProvider.fetchCampusTalkByAuthUser(widget.uuid, page: 1);
          },
          child: ListView.builder(
            controller: _scrollController,
            shrinkWrap: true,
            itemCount: campusTalkProvider.campusTalkByUserPostsResultsList.length,
            itemBuilder: (context, index) {
              Result campusTalkData = campusTalkProvider.campusTalkByUserPostsResultsList[index];
              return Visibility(
                visible: true,
                child: CampusTalkRow(
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
                  isUserProfile: true,
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
                ),
              );
            },
          ),
        );
      },
    );
  }
}
