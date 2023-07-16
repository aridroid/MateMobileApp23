import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mate_app/Widget/video_player_view.dart';
import 'package:video_player/video_player.dart';

class VideoThumbnail extends StatefulWidget {
  final String videoUrl;
  final bool isLeftPadding;
  const VideoThumbnail({Key? key, required this.videoUrl,this.isLeftPadding=true}) : super(key: key);

  @override
  _VideoThumbnailState createState() => _VideoThumbnailState();
}

class _VideoThumbnailState extends State<VideoThumbnail> {
  late VideoPlayerController videoPlayerController;

  @override
  void initState() {
    videoPlayerController = new VideoPlayerController.network(widget.videoUrl)..initialize().then((value){
      setState(() {

      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return videoPlayerController.value.isInitialized?
      Padding(
      padding: EdgeInsets.only(bottom: 0.0, left: widget.isLeftPadding?16:0, right: widget.isLeftPadding?16:0, top: 10),
      child: Stack(
        children: [
          Container(
            height: 150,
            width: MediaQuery.of(context).size.width/1.2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              clipBehavior: Clip.hardEdge,
              child: VideoPlayer(
                videoPlayerController,
              ),
            ),
          ),
          Positioned.fill(
            child: InkWell(
              onTap: (){
                Get.to(VideoPlayerView(videoUrl: widget.videoUrl,));
              },
              child: Icon(Icons.play_circle_fill,color: Colors.white,size: 50),
            ),
          ),
        ],
      ),
    ):Offstage();
  }
}





class VideoThumbnailFile extends StatefulWidget {
  final File videoUrl;
  const VideoThumbnailFile({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoThumbnailFileState createState() => _VideoThumbnailFileState();
}

class _VideoThumbnailFileState extends State<VideoThumbnailFile> {
  late VideoPlayerController videoPlayerController;

  @override
  void initState() {
    videoPlayerController = new VideoPlayerController.file(widget.videoUrl)..initialize().then((value){
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return videoPlayerController.value.isInitialized?
    Stack(
      children: [
        Container(
          height: 150,
          width: MediaQuery.of(context).size.width,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            clipBehavior: Clip.hardEdge,
            child: VideoPlayer(
              videoPlayerController,
            ),
          ),
        ),
      ],
    ):Offstage();
  }
}
