import 'dart:async';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mate_app/audioAndVideoCalling/addParticipantsScreen.dart';
import 'package:mate_app/constant.dart';
import 'package:mate_app/groupChat/services/database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../asset/Colors/MateColors.dart';

class Calling extends StatefulWidget {
  final String channelName;
  final String token;
  final String callType;
  final String image;
  final String name;
  final bool isGroupCall;
  const Calling({Key key, this.channelName, this.token, this.callType, this.image, this.name, this.isGroupCall}) : super(key: key);

  @override
  State<Calling> createState() => _CallingState();
}

class _CallingState extends State<Calling> {
  static final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;
  bool disableVideo = false;
  bool speakerOn = false;
  RtcEngine _engine;

  @override
  void dispose() {
    // clear users
    _users.clear();
    // destroy sdk
    _engine.leaveChannel();
    _engine.destroy();
    setSharedPreference();
    super.dispose();
  }

  setSharedPreference()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool("isCallOngoing",false);
    print("========================");
    print(preferences.getBool("isCallOngoing"));
  }

  User _user;
  addUserToFirebase()async{
    _user = FirebaseAuth.instance.currentUser;
    DatabaseService().joinCall(channelName: widget.channelName,uid: _user.uid);
  }

  @override
  void initState() {
    super.initState();
    addUserToFirebase();
    // initialize agora sdk
    // Future.delayed(Duration.zero,(){
    //   showBottomSheetTool();
    // });
    initialize();
  }

  Future<void> initialize() async {
    if (APP_ID.isEmpty) {
      setState(() {
        _infoStrings.add(
          'APP_ID missing, please provide your APP_ID in settings.dart',
        );
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }
    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    // await _engine.enableWebSdkInteroperability(true);
    await _engine.joinChannel(widget.token, widget.channelName, null, 0);
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.create(APP_ID);
    await _engine.enableVideo();
    if(widget.callType=="Video Calling"){
      print("Video calling started");
      await _engine.enableVideo();
    }else{
      print("Audio calling started");
      await _engine.disableVideo();
    }
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    _engine.setEventHandler(RtcEngineEventHandler(
      error: (code) {
        setState(() {
          final info = 'onError: $code';
          _infoStrings.add(info);
        });
      },
      joinChannelSuccess: (channel, uid, elapsed) {
        print("//////////////////////////////////////");
        setState(() {
          final info = 'onJoinChannel: $channel, uid: $uid';
          _infoStrings.add(info);
        });
      },
      leaveChannel: (stats) {
        setState(() {
          _infoStrings.add('onLeaveChannel');
          _users.clear();
        });
      },
      userJoined: (uid, elapsed) {
        setState(() {
          final info = 'userJoined: $uid';
          _infoStrings.add(info);
          _users.add(uid);
        });
      },
      userOffline: (uid, reason) {
        setState(() {
          final info = 'userOffline: $uid , reason: $reason';
          _infoStrings.add(info);
          _users.remove(uid);
        });
      },
      firstRemoteVideoFrame: (uid, width, height, elapsed) {
        setState(() {
          final info = 'firstRemoteVideoFrame: $uid';
          _infoStrings.add(info);
        });
      },
    ));
  }

  /// Toolbar layout
  // Widget _toolbar() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: <Widget>[
  //       RawMaterialButton(
  //         onPressed: _onToggleMute,
  //         child: Icon(
  //           disableVideo ? Icons.videocam_off : Icons.videocam,
  //           color: disableVideo ? Colors.white : Colors.blueAccent,
  //           size: 20.0,
  //         ),
  //         shape: CircleBorder(),
  //         elevation: 2.0,
  //         fillColor: muted ? Colors.blueAccent : Colors.white,
  //         padding: const EdgeInsets.all(12.0),
  //       ),
  //       RawMaterialButton(
  //         onPressed: _onToggleMute,
  //         child: Icon(
  //           muted ? Icons.mic_off : Icons.mic,
  //           color: muted ? Colors.white : Colors.blueAccent,
  //           size: 20.0,
  //         ),
  //         shape: CircleBorder(),
  //         elevation: 2.0,
  //         fillColor: muted ? Colors.blueAccent : Colors.white,
  //         padding: const EdgeInsets.all(12.0),
  //       ),
  //       RawMaterialButton(
  //         onPressed: _onSwitchCamera,
  //         child: Icon(
  //           Icons.switch_camera,
  //           color: Colors.blueAccent,
  //           size: 20.0,
  //         ),
  //         shape: CircleBorder(),
  //         elevation: 2.0,
  //         fillColor: Colors.white,
  //         padding: const EdgeInsets.all(12.0),
  //       ),
  //       RawMaterialButton(
  //         onPressed: () => _onCallEnd(context),
  //         child: Icon(
  //           Icons.call_end,
  //           color: Colors.white,
  //           size: 20.0,
  //         ),
  //         shape: CircleBorder(),
  //         elevation: 2.0,
  //         fillColor: Colors.redAccent,
  //         padding: const EdgeInsets.all(15.0),
  //       ),
  //     ],
  //   );
  // }

  // Create UI with local view and remote view
  @override
  Widget build(BuildContext context) {
    final scH = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: widget.callType=="Video Calling"?Colors.white:Colors.grey.shade900,
      body:
      widget.callType=="Video Calling"?
      Center(
        child: Stack(
          children: <Widget>[
              _viewRows(),
            _draggableScrollableSheet(),
          ],
        ),
      ):
      Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: scH*0.2,
              ),
              Center(
                child: CachedNetworkImage(
                    imageUrl: widget.image,
                    progressIndicatorBuilder: (context, url, downloadProgress){
                      return CircleAvatar(
                        radius: 60,
                        backgroundImage: AssetImage("lib/asset/profile.png"),
                      );
                    },
                    errorWidget: (context, url, error){
                      return CircleAvatar(
                        radius: 60,
                        backgroundImage: AssetImage("lib/asset/profile.png"),
                      );
                    },
                    imageBuilder: (context,url){
                      return CircleAvatar(
                        radius: 60,
                        backgroundImage: url,
                      );
                    }
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15),
                child: Text(
                  widget.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 17.0,
                  ),
                ),
              ),
            ],
          ),
          _draggableScrollableSheet(),
        ],
      ),
    );
  }

  DraggableScrollableSheet _draggableScrollableSheet(){
    return DraggableScrollableSheet(
      initialChildSize: 0.18,
      minChildSize: 0.18,
      maxChildSize: 0.5,
      controller: _draggableScrollableController,
      builder: (BuildContext context, ScrollController scrollController) {
        return WillPopScope(
          onWillPop: ()async{
            return false;
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: InkWell(
                      onTap: (){
                        _draggableScrollableController.animateTo(0.5, duration: Duration(milliseconds: 200), curve: Curves.ease);
                        setState(() {});
                      },
                      child: Icon(Icons.keyboard_arrow_up_outlined,
                        color: Colors.grey.shade900,
                        size: 50,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      if(widget.callType=="Video Calling")
                        RawMaterialButton(
                          onPressed: (){
                            setState(() {
                              disableVideo = !disableVideo;
                            });
                            _engine.enableLocalVideo(!disableVideo);
                          },
                          child: Icon(
                            disableVideo ? Icons.videocam_off : Icons.videocam,
                            color: Colors.white,
                            size: 25.0,
                          ),
                          shape: CircleBorder(),
                          elevation: 2.0,
                          fillColor: Colors.grey.shade900,
                          padding: const EdgeInsets.all(12.0),
                        ),
                      if(widget.callType=="Audio Calling")
                        RawMaterialButton(
                          onPressed: (){
                            setState(() {
                              speakerOn = !speakerOn;
                            });
                            _engine.setEnableSpeakerphone(speakerOn);
                          },
                          child: Icon(
                            speakerOn ? Icons.volume_up : Icons.volume_off,
                            color: Colors.white,
                            size: 25.0,
                          ),
                          shape: CircleBorder(),
                          elevation: 2.0,
                          fillColor: Colors.grey.shade900,
                          padding: const EdgeInsets.all(12.0),
                        ),
                      RawMaterialButton(
                        onPressed: (){
                          setState(() {
                            muted = !muted;
                          });
                          _engine.muteLocalAudioStream(muted);
                        },
                        child: Icon(
                          muted ? Icons.mic_off : Icons.mic,
                          color: Colors.white,
                          size: 25.0,
                        ),
                        shape: CircleBorder(),
                        elevation: 2.0,
                        fillColor: Colors.grey.shade900,
                        padding: const EdgeInsets.all(12.0),
                      ),
                      if(widget.callType == "Video Calling")
                        RawMaterialButton(
                          onPressed: _onSwitchCamera,
                          child: Icon(
                            Icons.switch_camera,
                            color: Colors.white,
                            size: 25.0,
                          ),
                          shape: CircleBorder(),
                          elevation: 2.0,
                          fillColor: Colors.grey.shade900,
                          padding: const EdgeInsets.all(12.0),
                        ),
                      RawMaterialButton(
                        onPressed: () => _onCallEnd(context),
                        child: Icon(
                          Icons.call_end,
                          color: Colors.white,
                          size: 25.0,
                        ),
                        shape: CircleBorder(),
                        elevation: 2.0,
                        fillColor: Colors.redAccent,
                        padding: const EdgeInsets.all(12.0),
                      ),
                    ],
                  ),
                  if(widget.isGroupCall==false)
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: ListTile(
                        onTap: (){
                          Get.to(()=>AddParticipantsToCallScreen(
                            channelName: widget.channelName,
                            isGroupCall: widget.isGroupCall,
                            image: widget.image,
                            name: widget.name,
                            callType: widget.callType,
                            token: widget.token,
                          ));
                        },
                        leading: Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.shade900,
                          ),
                          child: Icon(Icons.person_add, color: Colors.white, size: 25.0,),
                        ),
                        title: Text(
                          "Add Participants",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.1,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  StreamBuilder(
                      stream: DatabaseService().getCallDetailByChannelName(widget.channelName),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data['memberWhoIsOnCall'].length,
                              physics: ScrollPhysics(),
                              padding: EdgeInsets.only(top: widget.isGroupCall?20:0),
                              itemBuilder: (context, index) {
                                return FutureBuilder(
                                    future: DatabaseService().getUsersDetails(snapshot.data['memberWhoIsOnCall'][index]),
                                    builder: (context, snapshot1) {
                                      if(snapshot1.hasData){
                                        return Padding(
                                          padding: const EdgeInsets.only(bottom: 3),
                                          child: ListTile(
                                            leading: snapshot1.data.data()['photoURL']!=null?
                                            CircleAvatar(
                                              radius: 20,
                                              backgroundColor: MateColors.activeIcons,
                                              backgroundImage: NetworkImage(
                                                snapshot1.data.data()['photoURL'],
                                              ),
                                            ):
                                            CircleAvatar(
                                              radius: 20,
                                              backgroundColor: MateColors.activeIcons,
                                              child: Text(snapshot1.data.data()['displayName'].substring(0,1),style: TextStyle(color: Colors.black),),
                                            ),
                                            title: Text(
                                              snapshot.data['memberWhoIsOnCall'][index] == _user.uid?
                                                  "You":
                                              snapshot1.data.data()['displayName'],
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 0.1,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                      else if(snapshot1.connectionState == ConnectionState.waiting){
                                        return SizedBox(
                                          height: 50,
                                          width: 50,
                                          child: Center(
                                            child: LinearProgressIndicator(
                                              color: Colors.white,
                                              minHeight: 3,
                                            ),
                                          ),
                                        );
                                      }
                                      return SizedBox();
                                    }
                                );
                              });
                        } else {
                          return Container();
                        }
                      }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Display remote user's video
  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [];
    list.add(RtcLocalView.SurfaceView());
    _users.forEach((int uid) => list.add(RtcRemoteView.SurfaceView(uid: uid,)));
    return list;
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  /// Video layout wrapper
  Widget _viewRows() {
    final views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Container(
            child: Column(
              children: <Widget>[_videoView(views[0])],
            ));
      case 2:
        return Container(
            child: Column(
              children: <Widget>[
                _expandedVideoRow([views[0]]),
                _expandedVideoRow([views[1]])
              ],
            ));
      case 3:
        return Container(
            child: Column(
              children: <Widget>[
                _expandedVideoRow(views.sublist(0, 2)),
                _expandedVideoRow(views.sublist(2, 3))
              ],
            ));
      case 4:
        return Container(
            child: Column(
              children: <Widget>[
                _expandedVideoRow(views.sublist(0, 2)),
                _expandedVideoRow(views.sublist(2, 4))
              ],
            ));
      default:
    }
    return Container();
  }

  void _onCallEnd(BuildContext context) {
    DatabaseService().leaveCall(channelName: widget.channelName,uid: _user.uid);
    //Navigator.pop(context);
    Navigator.pop(context);
  }

  // void _onToggleMute() {
  //   setState(() {
  //     muted = !muted;
  //   });
  //   _engine.muteLocalAudioStream(muted);
  // }

  void _onSwitchCamera() {
    _engine.switchCamera();
  }

  DraggableScrollableController _draggableScrollableController = DraggableScrollableController();
  // showBottomSheetTool(){
  //   Get.bottomSheet(
  //     DraggableScrollableSheet(
  //       initialChildSize: 0.3,
  //       minChildSize: 0.3,
  //       maxChildSize: 0.7,
  //       controller: _draggableScrollableController,
  //       builder: (BuildContext context, ScrollController scrollController) {
  //         return StatefulBuilder(
  //           builder: (context,setState){
  //             return WillPopScope(
  //               onWillPop: ()async{
  //                 return false;
  //               },
  //               child: Container(
  //                 //height: 100,
  //                 decoration: BoxDecoration(
  //                   color: Colors.black,
  //                   borderRadius: BorderRadius.only(
  //                     topLeft: Radius.circular(25),
  //                     topRight: Radius.circular(25),
  //                   ),
  //                 ),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Center(
  //                       child: InkWell(
  //                         onTap: (){
  //                           scrollController.animateTo(0.7, duration: Duration.zero, curve: Curves.ease);
  //                         },
  //                         child: Icon(Icons.keyboard_arrow_up_outlined,
  //                           color: Colors.grey.shade900,
  //                           size: 50,
  //                         ),
  //                       ),
  //                     ),
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       children: <Widget>[
  //                         if(widget.callType=="Video Calling")
  //                           RawMaterialButton(
  //                             onPressed: (){
  //                               setState(() {
  //                                 disableVideo = !disableVideo;
  //                               });
  //                               _engine.enableLocalVideo(!disableVideo);
  //                             },
  //                             child: Icon(
  //                               disableVideo ? Icons.videocam_off : Icons.videocam,
  //                               color: Colors.white,
  //                               size: 20.0,
  //                             ),
  //                             shape: CircleBorder(),
  //                             elevation: 2.0,
  //                             fillColor: Colors.grey.shade900,
  //                             padding: const EdgeInsets.all(12.0),
  //                           ),
  //                         if(widget.callType=="Audio Calling")
  //                           RawMaterialButton(
  //                             onPressed: (){
  //                               setState(() {
  //                                 speakerOn = !speakerOn;
  //                               });
  //                               _engine.setEnableSpeakerphone(speakerOn);
  //                             },
  //                             child: Icon(
  //                               speakerOn ? Icons.volume_up : Icons.volume_off,
  //                               color: Colors.white,
  //                               size: 20.0,
  //                             ),
  //                             shape: CircleBorder(),
  //                             elevation: 2.0,
  //                             fillColor: Colors.grey.shade900,
  //                             padding: const EdgeInsets.all(12.0),
  //                           ),
  //                         RawMaterialButton(
  //                           onPressed: (){
  //                             setState(() {
  //                               muted = !muted;
  //                             });
  //                             _engine.muteLocalAudioStream(muted);
  //                           },
  //                           child: Icon(
  //                             muted ? Icons.mic_off : Icons.mic,
  //                             color: Colors.white,
  //                             size: 20.0,
  //                           ),
  //                           shape: CircleBorder(),
  //                           elevation: 2.0,
  //                           fillColor: Colors.grey.shade900,
  //                           padding: const EdgeInsets.all(12.0),
  //                         ),
  //                         if(widget.callType == "Video Calling")
  //                           RawMaterialButton(
  //                             onPressed: _onSwitchCamera,
  //                             child: Icon(
  //                               Icons.switch_camera,
  //                               color: Colors.white,
  //                               size: 20.0,
  //                             ),
  //                             shape: CircleBorder(),
  //                             elevation: 2.0,
  //                             fillColor: Colors.grey.shade900,
  //                             padding: const EdgeInsets.all(12.0),
  //                           ),
  //                         RawMaterialButton(
  //                           onPressed: () => _onCallEnd(context),
  //                           child: Icon(
  //                             Icons.call_end,
  //                             color: Colors.white,
  //                             size: 20.0,
  //                           ),
  //                           shape: CircleBorder(),
  //                           elevation: 2.0,
  //                           fillColor: Colors.redAccent,
  //                           padding: const EdgeInsets.all(12.0),
  //                         ),
  //                       ],
  //                     ),
  //                     Container(
  //                       height: 100,
  //                       color: Colors.pink,
  //                     )
  //                   ],
  //                 ),
  //               ),
  //             );
  //           },
  //         );
  //       },
  //     ),
  //     isDismissible: false,
  //     enableDrag: false,
  //     useRootNavigator: false,
  //     backgroundColor: Colors.transparent,
  //     elevation: 0,
  //     barrierColor: Colors.transparent,
  //     isScrollControlled: true,
  //   );
  // }

  // DraggableScrollableController _draggableScrollableController = DraggableScrollableController();
  // showBottomSheetTool(){
  //   Get.bottomSheet(
  //     StatefulBuilder(
  //       builder: (context,setState){
  //         return WillPopScope(
  //           onWillPop: ()async{
  //             return false;
  //           },
  //           child: Container(
  //             height: 100,
  //             decoration: BoxDecoration(
  //               color: Colors.black,
  //               borderRadius: BorderRadius.only(
  //                 topLeft: Radius.circular(25),
  //                 topRight: Radius.circular(25),
  //               ),
  //             ),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: <Widget>[
  //                 if(widget.callType=="Video Calling")
  //                 RawMaterialButton(
  //                   onPressed: (){
  //                     setState(() {
  //                       disableVideo = !disableVideo;
  //                     });
  //                     _engine.enableLocalVideo(!disableVideo);
  //                   },
  //                   child: Icon(
  //                     disableVideo ? Icons.videocam_off : Icons.videocam,
  //                     color: Colors.white,
  //                     size: 20.0,
  //                   ),
  //                   shape: CircleBorder(),
  //                   elevation: 2.0,
  //                   fillColor: Colors.grey.shade900,
  //                   padding: const EdgeInsets.all(12.0),
  //                 ),
  //                 if(widget.callType=="Audio Calling")
  //                   RawMaterialButton(
  //                     onPressed: (){
  //                       setState(() {
  //                         speakerOn = !speakerOn;
  //                       });
  //                       _engine.setEnableSpeakerphone(speakerOn);
  //                     },
  //                     child: Icon(
  //                       speakerOn ? Icons.volume_up : Icons.volume_off,
  //                       color: Colors.white,
  //                       size: 20.0,
  //                     ),
  //                     shape: CircleBorder(),
  //                     elevation: 2.0,
  //                     fillColor: Colors.grey.shade900,
  //                     padding: const EdgeInsets.all(12.0),
  //                   ),
  //                 RawMaterialButton(
  //                   onPressed: (){
  //                     setState(() {
  //                       muted = !muted;
  //                     });
  //                     _engine.muteLocalAudioStream(muted);
  //                   },
  //                   child: Icon(
  //                     muted ? Icons.mic_off : Icons.mic,
  //                     color: Colors.white,
  //                     size: 20.0,
  //                   ),
  //                   shape: CircleBorder(),
  //                   elevation: 2.0,
  //                   fillColor: Colors.grey.shade900,
  //                   padding: const EdgeInsets.all(12.0),
  //                 ),
  //                 if(widget.callType == "Video Calling")
  //                 RawMaterialButton(
  //                   onPressed: _onSwitchCamera,
  //                   child: Icon(
  //                     Icons.switch_camera,
  //                     color: Colors.white,
  //                     size: 20.0,
  //                   ),
  //                   shape: CircleBorder(),
  //                   elevation: 2.0,
  //                   fillColor: Colors.grey.shade900,
  //                   padding: const EdgeInsets.all(12.0),
  //                 ),
  //                 RawMaterialButton(
  //                   onPressed: () => _onCallEnd(context),
  //                   child: Icon(
  //                     Icons.call_end,
  //                     color: Colors.white,
  //                     size: 20.0,
  //                   ),
  //                   shape: CircleBorder(),
  //                   elevation: 2.0,
  //                   fillColor: Colors.redAccent,
  //                   padding: const EdgeInsets.all(12.0),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //     isDismissible: false,
  //     enableDrag: false,
  //     useRootNavigator: false,
  //     backgroundColor: Colors.transparent,
  //     elevation: 0,
  //     barrierColor: Colors.transparent,
  //   );
  // }

}
