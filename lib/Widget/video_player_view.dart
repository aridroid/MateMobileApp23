import 'package:flutter/material.dart';
import 'package:mate_app/asset/Colors/MateColors.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerView extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerView({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoPlayerViewState createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  late VideoPlayerController _controller;
  bool _onTouch = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)..initialize().then((_) {
      _controller.play();
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sch = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(
          color: MateColors.activeIcons,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 100,bottom: 100),
        child: Stack(
          children: [
            Center(
              child: _controller.value.isInitialized?
              FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                    height: _controller.value.size?.height ?? 0,
                    width: _controller.value.size?.width ?? 0,
                    child: VideoPlayer(_controller)),
              ):
              CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
            Positioned(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/1.14,
              child: Center(
                child: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    setState(() {
                      _onTouch = !_onTouch;
                    });
                  },
                  child: Visibility(
                    maintainAnimation: true,
                    maintainState: true,
                    maintainInteractivity: true,
                    maintainSize: true,
                    visible: _controller.value.isInitialized && _onTouch,
                    child: Container(
                      padding: EdgeInsets.only(bottom: sch/1.9),
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.grey.withOpacity(0.5),
                          padding: EdgeInsets.all(10),
                          shape: CircleBorder(side: BorderSide(color: Colors.white, width: 1.2)),
                        ),
                        child: Icon(
                          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () {
                          setState(() {
                            _controller.value.isPlaying ? _controller.pause() : _controller.play();
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
