import 'dart:async';

import 'package:mate_app/Model/campusLivePostsModel.dart';
import 'package:mate_app/Providers/AuthUserProvider.dart';
import 'package:mate_app/Providers/campusLiveProvider.dart';
import 'package:mate_app/Screen/Home/Community/CampusLivePostComments.dart';
import 'package:mate_app/Utility/Utility.dart';
import 'package:mate_app/asset/Colors/MateColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:sizer/sizer.dart';


class CreditVideo extends StatefulWidget {
  final bool isBookmarkPage;
  final bool isUsersPostsPage;
  final String description;
  final String created;
  final User user;
  final String creditVideoURL;
  final int postId;
  final IsLiked isLiked;
  final Credit credit;
  final VideoPlayerController videoPlayerController;

  const CreditVideo({Key key,this.isBookmarkPage,this.isUsersPostsPage, this.description, this.created, this.user, this.creditVideoURL, this.postId, this.isLiked, this.credit, this.videoPlayerController}) : super(key: key);

  @override
  _CreditVideoState createState() => _CreditVideoState();
}

class _CreditVideoState extends State<CreditVideo> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  bool liked;

  bool _onTouch = false;

  @override
  void initState() {
    print("hiiitt");
    _controller = VideoPlayerController.network(
      widget.creditVideoURL,
    );

    // Initielize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize();

    // Use the controller to loop the video.
    _controller.setLooping(true);
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      // If the video is paused, play it.
      print("k");
      _controller.play();
    }

    liked = (widget.isLiked == null) ? false : true;
    super.initState();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    super.dispose();
    _controller.dispose();
    widget.videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Credit Video", style: TextStyle(fontSize: 16.0.sp)),
      ),
      backgroundColor: myHexColor,
      body: Padding(
        padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * .85,
              child: Stack(
                clipBehavior: Clip.hardEdge,
                children: [
                  Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        gradient: LinearGradient(colors: [
                          Colors.transparent,
                          Colors.transparent,
                          // Colors.transparent,
                          Colors.black87,
                        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                    child: Center(
                        child: FutureBuilder(
                          future: _initializeVideoPlayerFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.done && _controller.value.size.aspectRatio>0.0) {
                              // If the VideoPlayerController has finished initialization, use
                              // the data it provides to limit the aspect ratio of the video.
                              print("starting video");
                              return AspectRatio(
                                  aspectRatio: _controller.value.size.aspectRatio,
                                  child: VideoPlayer(_controller));
                            } else {
                              // If the VideoPlayerController is still initializing, show a
                              // loading spinner.
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              );
                            }
                          },
                        )),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Colors.transparent,
                          Colors.transparent,
                          Colors.transparent,
                          Colors.black87,
                        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                  ),
                  Positioned(
                    top: 0,
                    left: 54,
                    width: MediaQuery.of(context).size.width * 1 - 112,
                    height: MediaQuery.of(context).size.height * .45 + 110,
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
                          // width: 100,
                          padding: EdgeInsets.only(bottom: 90),
                          // color: Colors.grey.withOpacity(0.7),
                          alignment: Alignment.bottomCenter,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.grey.withOpacity(0.5),
                              padding: EdgeInsets.all(10),
                              shape: CircleBorder(side: BorderSide(color: Colors.white, width: 1.2)),
                            ),
                            // color: Colors.grey.withOpacity(0.5),
                            // padding: EdgeInsets.all(10),
                            // shape: CircleBorder(side: BorderSide(color: Colors.white, width: 1.2)),
                            child: Icon(
                              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                              color: Colors.white,
                              size: 30,
                            ),
                            onPressed: () {
                              // pause while video is playing, play while video is pausing
                              setState(() {
                                _controller.value.isPlaying ? _controller.pause() : _controller.play();
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    // height: 100,
                    width: MediaQuery.of(context).size.width * .65,
                    bottom: 20,
                    left: 10,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        widget.credit != null
                            ? Padding(
                          padding: const EdgeInsets.only(bottom: 3),
                          child: Text("${widget.credit.displayName}", style: TextStyle(fontFamily: 'Quicksand', color: Colors.white, fontWeight: FontWeight.w600)),
                        )
                            : SizedBox(),
                        /*Text(
                          '${widget.created}',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Flexible(
                          child: Text(
                            "${widget.description}",
                            overflow: TextOverflow.fade,
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),*/
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    width: 100,
                    height: 100,
                    child: (widget.user.uuid!=null && (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == widget.user.uuid))?
                    Container(
                      alignment: Alignment.topRight,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            Colors.black87,
                            Colors.black87,
                            Colors.black54,
                            Colors.black38,
                            Colors.transparent
                          ], begin: Alignment.topRight, end: Alignment.center)),
                      child:
                      PopupMenuButton<int>(
                        icon: Icon(Icons.more_vert,color: Colors.white,),
                        color: Colors.grey[850],
                        onSelected: (index){
                          if(index==0){
                            _showDeleteAlertDialog(postId: widget.postId);
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 0,
                            enabled: (widget.user.uuid!=null && (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == widget.user.uuid)),
                            child: Text(
                              "Delete Post",
                              textAlign: TextAlign.start,
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                            ),
                          ),

                        ],
                      ),
                    ):
                    SizedBox(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  _showDeleteAlertDialog({@required int postId}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: new Text("Are you sure?"),
          content: new Text("You want to delete your Supercharge post"),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text("Yes"),
              onPressed: () async{
                bool isDeleted = await Provider.of<CampusLiveProvider>(context, listen: false).deleteASuperchargePost(postId);
                if (isDeleted) {
                  Navigator.pop(context);
                  Future.delayed(Duration(seconds: 0), () {
                    if(widget.isBookmarkPage){
                      Provider.of<CampusLiveProvider>(context, listen: false).fetchCampusLivePostBookmarkedList();
                    }else if(widget.isUsersPostsPage){
                      Provider.of<CampusLiveProvider>(context, listen: false).fetchCampusLiveByAuthUser(widget.user.uuid);
                    }else{
                      Provider.of<CampusLiveProvider>(context, listen: false).fetchCampusLivePostList();
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
