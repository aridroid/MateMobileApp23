// import 'dart:async';
//
// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:mate_app/Model/bookmarkByUserModel.dart';
//
// import '../constant.dart';
//
//
// class CallPage extends StatefulWidget {
//   /// non-modifiable channel name of the page
//   final String channelName;
//
//   /// non-modifiable client role of the page
//   final ClientRole role;
//
//   /// Creates a call page with given channel name.
//   const CallPage({Key key, this.channelName, this.role}) : super(key: key);
//
//   @override
//   _CallPageState createState() => _CallPageState();
// }
//
// class _CallPageState extends State<CallPage> {
//   static final _users = <int>[];
//   final _infoStrings = <String>[];
//   bool muted = false;
//   bool joined = false;
//
//   @override
//   void dispose() {
//     // clear users
//     _users.clear();
//     // destroy sdk
//     AgoraRtcEngine.leaveChannel();
//     print("/////////Dispose/////////");
//     AgoraRtcEngine.destroy();
//     super.dispose();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     // initialize agora sdk
//     initialize();
//   }
//
//   Future<void> initialize() async {
//     if (APP_ID.isEmpty) {
//       setState(() {
//         _infoStrings.add(
//           'APP_ID missing, please provide your APP_ID in settings.dart',
//         );
//         _infoStrings.add('Agora Engine is not starting');
//       });
//       return;
//     }
//
//     await _initAgoraRtcEngine();
//     _addAgoraEventHandlers();
//     await AgoraRtcEngine.enableWebSdkInteroperability(true);
//     VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
//     configuration.dimensions = Size(1920, 1080);
//     await AgoraRtcEngine.setVideoEncoderConfiguration(configuration);
//     //AgoraRtcEngine.setParameters("{\"rtc.log_filter\": 65535}");
//     await AgoraRtcEngine.joinChannel(Token, widget.channelName, null, 0);
//   }
//
//   /// Create agora sdk instance and initialize
//   Future<void> _initAgoraRtcEngine() async {
//     await AgoraRtcEngine.create(APP_ID);
//     await AgoraRtcEngine.enableVideo();
//     print("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
//     await AgoraRtcEngine.setChannelProfile(ChannelProfile.LiveBroadcasting);
//     await AgoraRtcEngine.setClientRole(widget.role);
//   }
//
//   /// Add agora event handlers
//   void _addAgoraEventHandlers() {
//     AgoraRtcEngine.onError = (dynamic code) {
//       setState(() {
//         final info = 'onError: $code';
//         _infoStrings.add(info);
//       });
//     };
//
//     AgoraRtcEngine.onJoinChannelSuccess = (
//         String channel,
//         int uid,
//         int elapsed,
//         ) {
//       setState(() {
//         print("///////////////////////////////////onJoinChaneel///////////////////");
//         final info = 'onJoinChannel: $channel, uid: $uid';
//         _infoStrings.add(info);
//          joined = true;
//       });
//       // setState(() {
//       //   joined = true;
//       // });
//     };
//
//     AgoraRtcEngine.onLeaveChannel = () {
//       setState(() {
//         _infoStrings.add('onLeaveChannel');
//         _users.clear();
//       });
//     };
//
//     AgoraRtcEngine.onUserJoined = (int uid, int elapsed) {
//       setState(() {
//         final info = 'userJoined: $uid';
//         _infoStrings.add(info);
//         _users.add(uid);
//         //joined = true;
//       });
//     };
//
//     AgoraRtcEngine.onUserOffline = (int uid, int reason) {
//       setState(() {
//         final info = 'userOffline: $uid';
//         _infoStrings.add(info);
//         _users.remove(uid);
//       });
//     };
//
//     AgoraRtcEngine.onFirstRemoteVideoFrame = (
//         int uid,
//         int width,
//         int height,
//         int elapsed,
//         ) {
//       setState(() {
//         final info = 'firstRemoteVideo: $uid ${width}x $height';
//         _infoStrings.add(info);
//         // joined = true;
//       });
//     };
//   }
//
//   /// Helper function to get list of native views
//   List<Widget> _getRenderViews() {
//     final List<AgoraRenderWidget> list = [];
//     if (widget.role == ClientRole.Broadcaster) {
//       list.add(AgoraRenderWidget(0, local: true, preview: true));
//     }
//     _users.forEach((int uid) => list.add(AgoraRenderWidget(uid)));
//     return list;
//   }
//
//   /// Video view wrapper
//   Widget _videoView(view) {
//     return Expanded(child: Container(child: view));
//   }
//
//   /// Video view row wrapper
//   Widget _expandedVideoRow(List<Widget> views) {
//     final wrappedViews = views.map<Widget>(_videoView).toList();
//     return Expanded(
//       child: Row(
//         children: wrappedViews,
//       ),
//     );
//   }
//
//   /// Video layout wrapper
//   Widget _viewRows() {
//     final views = _getRenderViews();
//     switch (views.length) {
//       case 1:
//         return Container(
//             child: Column(
//               children: <Widget>[_videoView(views[0])],
//             ));
//       case 2:
//         return Container(
//             child: Column(
//               children: <Widget>[
//                 _expandedVideoRow([views[0]]),
//                 _expandedVideoRow([views[1]])
//               ],
//             ));
//       case 3:
//         return Container(
//             child: Column(
//               children: <Widget>[
//                 _expandedVideoRow(views.sublist(0, 2)),
//                 _expandedVideoRow(views.sublist(2, 3))
//               ],
//             ));
//       case 4:
//         return Container(
//             child: Column(
//               children: <Widget>[
//                 _expandedVideoRow(views.sublist(0, 2)),
//                 _expandedVideoRow(views.sublist(2, 4))
//               ],
//             ));
//       default:
//     }
//     return Container();
//   }
//
//
//
//   //
//   // Widget _viewRows() {
//   //   final views = _getRenderViews();
//   //   switch (views.length) {
//   //     case 1:
//   //       return Container(
//   //           child: Column(
//   //             children: <Widget>[_videoView(views[0])],
//   //           ));
//   //     case 2:
//   //       return Container(
//   //           child: Column(
//   //             children: <Widget>[
//   //               _expandedVideoRow([views[0]]),
//   //               _expandedVideoRow([views[1]])
//   //             ],
//   //           ));
//   //     case 3:
//   //       return Container(
//   //           child: Column(
//   //             children: <Widget>[
//   //               _expandedVideoRow(views.sublist(0, 2)),
//   //               _expandedVideoRow(views.sublist(2, 3))
//   //             ],
//   //           ));
//   //     case 4:
//   //       return Container(
//   //           child: Column(
//   //             children: <Widget>[
//   //               _expandedVideoRow(views.sublist(0, 2)),
//   //               _expandedVideoRow(views.sublist(2, 4))
//   //             ],
//   //           ));
//   //     default:
//   //   }
//   //   return Container();
//   // }
//
//
//
//
//   /// Toolbar layout
//   Widget _toolbar() {
//     if (widget.role == ClientRole.Audience) return Container();
//     return Container(
//       alignment: Alignment.bottomCenter,
//       padding: const EdgeInsets.symmetric(vertical: 48),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           RawMaterialButton(
//             onPressed: _onToggleMute,
//             child: Icon(
//               muted ? Icons.mic_off : Icons.mic,
//               color: muted ? Colors.white : Colors.blueAccent,
//               size: 20.0,
//             ),
//             shape: CircleBorder(),
//             elevation: 2.0,
//             fillColor: muted ? Colors.blueAccent : Colors.white,
//             padding: const EdgeInsets.all(12.0),
//           ),
//           RawMaterialButton(
//             onPressed: () => _onCallEnd(context),
//             child: Icon(
//               Icons.call_end,
//               color: Colors.white,
//               size: 35.0,
//             ),
//             shape: CircleBorder(),
//             elevation: 2.0,
//             fillColor: Colors.redAccent,
//             padding: const EdgeInsets.all(15.0),
//           ),
//           RawMaterialButton(
//             onPressed: _onSwitchCamera,
//             child: Icon(
//               Icons.switch_camera,
//               color: Colors.blueAccent,
//               size: 20.0,
//             ),
//             shape: CircleBorder(),
//             elevation: 2.0,
//             fillColor: Colors.white,
//             padding: const EdgeInsets.all(12.0),
//           )
//         ],
//       ),
//     );
//   }
//
//   /// Info panel to show logs
//   Widget _panel() {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 48),
//       alignment: Alignment.bottomCenter,
//       child: FractionallySizedBox(
//         heightFactor: 0.5,
//         child: Container(
//           padding: const EdgeInsets.symmetric(vertical: 48),
//           child: ListView.builder(
//             reverse: true,
//             itemCount: _infoStrings.length,
//             itemBuilder: (BuildContext context, int index) {
//               if (_infoStrings.isEmpty) {
//                 return null;
//               }
//               return Padding(
//                 padding: const EdgeInsets.symmetric(
//                   vertical: 3,
//                   horizontal: 10,
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Flexible(
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                           vertical: 2,
//                           horizontal: 5,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.yellowAccent,
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                         child: Text(
//                           _infoStrings[index],
//                           style: TextStyle(color: Colors.blueGrey),
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _onCallEnd(BuildContext context) {
//     Navigator.pop(context);
//   }
//
//   void _onToggleMute() {
//     setState(() {
//       muted = !muted;
//     });
//     AgoraRtcEngine.muteLocalAudioStream(muted);
//   }
//
//   void _onSwitchCamera() {
//     AgoraRtcEngine.switchCamera();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: InkWell(
//           onTap: (){
//             Get.back();
//           },
//           child: Icon(Icons.arrow_back,color: Colors.pink,),
//         ),
//         backgroundColor: Colors.grey,
//         title: Text('Video call'),
//         centerTitle: true,
//       ),
//       backgroundColor: Colors.transparent,
//       body: Stack(
//         children: <Widget>[
//            joined?
//           // //height: MediaQuery.of(context).size.height,
//           // //width: MediaQuery.of(context).size.width,
//           // Positioned(
//           //   top: 0,
//           //   // left: 0,
//           //   // right: 0,
//           //   //bottom: 0,
//           //   child: _viewRows(),
//           // )
//           // :Center(child: CircularProgressIndicator()),
//           _viewRows() :Center(child: CircularProgressIndicator()),
//          //_viewRows(),
//           _panel(),
//           _toolbar(),
//         ],
//       ),
//     );
//   }
// }










/// Working code ////



// import 'dart:async';
// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:mate_app/Model/bookmarkByUserModel.dart';
// import 'package:mate_app/calling/session.dart';
// import '../constant.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// class CallPage extends StatefulWidget {
//   /// non-modifiable channel name of the page
//   final String channelName;
//   final String token;
//
//   /// Creates a call page with given channel name.
//   const CallPage({Key key, this.channelName,this.token}) : super(key: key);
//
//   @override
//   _CallPageState createState() {
//     return new _CallPageState();
//   }
// }
//
// class _CallPageState extends State<CallPage> {
//   static final _sessions = List<VideoSession>();
//   final _infoStrings = <String>[];
//   bool muted = false;
//
//     Future<void> _handleCameraAndMic(Permission permission) async {
//     final status = await permission.request();
//     print(status);
//   }
//   permiss()async{
//     await _handleCameraAndMic(Permission.camera);
//     await _handleCameraAndMic(Permission.microphone);
//   }
//
//   @override
//   void dispose() {
//     // clean up native views & destroy sdk
//     _sessions.forEach((session) {
//       AgoraRtcEngine.removeNativeView(session.viewId);
//     });
//     _sessions.clear();
//     AgoraRtcEngine.leaveChannel();
//     super.dispose();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     // initialize agora sdk
//     initialize();
//   }
//
//   void initialize() {
//     if (APP_ID.isEmpty) {
//       setState(() {
//         _infoStrings
//             .add("APP_ID missing, please provide your APP_ID in settings.dart");
//         _infoStrings.add("Agora Engine is not starting");
//       });
//       return;
//     }
//
//    permiss();
//
//     _initAgoraRtcEngine();
//     _addAgoraEventHandlers();
//     // use _addRenderView everytime a native video view is needed
//     _addRenderView(0, (viewId) {
//       AgoraRtcEngine.setupLocalVideo(viewId, VideoRenderMode.Hidden);
//       AgoraRtcEngine.startPreview();
//       // state can access widget directly
//       AgoraRtcEngine.joinChannel(widget.token, widget.channelName, null, 0);
//     });
//   }
//
//   /// Create agora sdk instance and initialze
//   Future<void> _initAgoraRtcEngine() async {
//     AgoraRtcEngine.create(APP_ID);
//     AgoraRtcEngine.enableVideo();
//   }
//
//   /// Add agora event handlers
//   void _addAgoraEventHandlers() {
//     AgoraRtcEngine.onError = (dynamic code) {
//       setState(() {
//         String info = 'onError: ' + code.toString();
//         _infoStrings.add(info);
//       });
//     };
//
//     AgoraRtcEngine.onJoinChannelSuccess =
//         (String channel, int uid, int elapsed) {
//       setState(() {
//         String info = 'onJoinChannel: ' + channel + ', uid: ' + uid.toString();
//         print("///////////////////////////////user Joined/////////////////////////////");
//         _infoStrings.add(info);
//       });
//     };
//
//     AgoraRtcEngine.onLeaveChannel = () {
//       _infoStrings.add('onLeaveChannel');
//       // setState(() {
//       //   _infoStrings.add('onLeaveChannel');
//       // });
//     };
//
//     AgoraRtcEngine.onUserJoined = (int uid, int elapsed) {
//       setState(() {
//         String info = 'userJoined: ' + uid.toString();
//         _infoStrings.add(info);
//         _addRenderView(uid, (viewId) {
//           AgoraRtcEngine.setupRemoteVideo(viewId, VideoRenderMode.Hidden, uid);
//         });
//       });
//     };
//
//     AgoraRtcEngine.onUserOffline = (int uid, int reason) {
//       setState(() {
//         String info = 'userOffline: ' + uid.toString();
//         _infoStrings.add(info);
//         _removeRenderView(uid);
//       });
//     };
//
//     AgoraRtcEngine.onFirstRemoteVideoFrame =
//         (int uid, int width, int height, int elapsed) {
//       setState(() {
//         String info = 'firstRemoteVideo: ' +
//             uid.toString() +
//             ' ' +
//             width.toString() +
//             'x' +
//             height.toString();
//         _infoStrings.add(info);
//       });
//     };
//   }
//
//   /// Create a native view and add a new video session object
//   /// The native viewId can be used to set up local/remote view
//   void _addRenderView(dynamic uid, Function(int viewId) finished) {
//     Widget view = AgoraRtcEngine.createNativeView((viewId) {
//       setState(() {
//         _getVideoSession(uid).viewId = viewId;
//         if (finished != null) {
//           finished(viewId);
//         }
//       });
//     });
//     VideoSession session = VideoSession(uid, view);
//     _sessions.add(session);
//   }
//
//   /// Remove a native view and remove an existing video session object
//   void _removeRenderView(int uid) {
//     VideoSession session = _getVideoSession(uid);
//     if (session != null) {
//       _sessions.remove(session);
//     }
//     AgoraRtcEngine.removeNativeView(session.viewId);
//   }
//
//   /// Helper function to filter video session with uid
//   VideoSession _getVideoSession(int uid) {
//     return _sessions.firstWhere((session) {
//       return session.uid == uid;
//     });
//   }
//
//   /// Helper function to get list of native views
//   List<Widget> _getRenderViews() {
//     return _sessions.map((session) => session.view).toList();
//   }
//
//   /// Video view wrapper
//   Widget _videoView(view) {
//     return Expanded(child: Container(child: view));
//   }
//
//   /// Video view row wrapper
//   Widget _expandedVideoRow(List<Widget> views) {
//     List<Widget> wrappedViews = views.map((Widget view) => _videoView(view)).toList();
//     return Expanded(
//         child: Row(
//           children: wrappedViews,
//         ));
//   }
//
//   /// Video layout wrapper
//   Widget _viewRows() {
//     List<Widget> views = _getRenderViews();
//     switch (views.length) {
//       case 1:
//         return Container(
//             child: Column(
//               children: <Widget>[_videoView(views[0])],
//             ));
//       case 2:
//         return Container(
//             child: Column(
//               children: <Widget>[
//                 _expandedVideoRow([views[0]]),
//                 _expandedVideoRow([views[1]])
//               ],
//             ));
//       case 3:
//         return Container(
//             child: Column(
//               children: <Widget>[
//                 _expandedVideoRow(views.sublist(0, 2)),
//                 _expandedVideoRow(views.sublist(2, 3))
//               ],
//             ));
//       case 4:
//         return Container(
//             child: Column(
//               children: <Widget>[
//                 _expandedVideoRow(views.sublist(0, 2)),
//                 _expandedVideoRow(views.sublist(2, 4))
//               ],
//             ));
//       default:
//     }
//     return Container();
//   }
//
//   Widget _videoViewWidget(){
//     List<Widget> views = _getRenderViews();
//     switch (views.length) {
//       case 1:
//         return Container(
//             child: Column(
//               children: <Widget>[_videoView(views[0])],
//             ));
//       case 2:
//         return Container(
//             child: Stack(
//               children: <Widget>[
//                 Column(
//                 children: <Widget>[
//                   _videoView(views[1]),
//                 ],
//               ), Align(alignment: Alignment.topRight ,child: Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: Container(child: views[0],height: 150,width: 100,),
//               ),)],
//             ));
//       default:
//     }
//     return Container();
//   }
//
//   /// Toolbar layout
//   Widget _toolbar() {
//     return Container(
//       alignment: Alignment.bottomCenter,
//       padding: EdgeInsets.symmetric(vertical: 48),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           RawMaterialButton(
//             onPressed: () => _onToggleMute(),
//             child: new Icon(
//               muted ? Icons.mic : Icons.mic_off,
//               color: muted ? Colors.white : Colors.blueAccent,
//               size: 20.0,
//             ),
//             shape: new CircleBorder(),
//             elevation: 2.0,
//             fillColor: muted ? Colors.blueAccent : Colors.white,
//             padding: const EdgeInsets.all(12.0),
//           ),
//           RawMaterialButton(
//             onPressed: () => _onCallEnd(context),
//             child: new Icon(
//               Icons.call_end,
//               color: Colors.white,
//               size: 35.0,
//             ),
//             shape: new CircleBorder(),
//             elevation: 2.0,
//             fillColor: Colors.redAccent,
//             padding: const EdgeInsets.all(15.0),
//           ),
//           RawMaterialButton(
//             onPressed: () => _onSwitchCamera(),
//             child: new Icon(
//               Icons.switch_camera,
//               color: Colors.blueAccent,
//               size: 20.0,
//             ),
//             shape: new CircleBorder(),
//             elevation: 2.0,
//             fillColor: Colors.white,
//             padding: const EdgeInsets.all(12.0),
//           )
//         ],
//       ),
//     );
//   }
//
//   /// Info panel to show logs
//   Widget _panel() {
//     return Container(
//         padding: EdgeInsets.symmetric(vertical: 48),
//         alignment: Alignment.bottomCenter,
//         child: FractionallySizedBox(
//           heightFactor: 0.5,
//           child: Container(
//               padding: EdgeInsets.symmetric(vertical: 48),
//               child: ListView.builder(
//                   reverse: true,
//                   itemCount: _infoStrings.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     if (_infoStrings.length == 0) {
//                       return null;
//                     }
//                     return Padding(
//                         padding:
//                         EdgeInsets.symmetric(vertical: 3, horizontal: 10),
//                         child: Row(mainAxisSize: MainAxisSize.min, children: [
//                           Flexible(
//                               child: Container(
//                                   padding: EdgeInsets.symmetric(
//                                       vertical: 2, horizontal: 5),
//                                   decoration: BoxDecoration(
//                                       color: Colors.yellowAccent,
//                                       borderRadius: BorderRadius.circular(5)),
//                                   child: Text(_infoStrings[index],
//                                       style:
//                                       TextStyle(color: Colors.blueGrey))))
//                         ]));
//                   })),
//         ));
//   }
//
//   void _onCallEnd(BuildContext context) {
//     Navigator.pop(context);
//   }
//
//   void _onToggleMute() {
//     setState(() {
//       muted = !muted;
//     });
//     AgoraRtcEngine.muteLocalAudioStream(muted);
//   }
//
//   void _onSwitchCamera() {
//     AgoraRtcEngine.switchCamera();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.pink,
//           //automaticallyImplyLeading: true,
//           leading: GestureDetector(
//             onTap: (){
//               Get.back();
//             },
//             child: Icon(Icons.arrow_back),
//           ),
//           title: Text('Agora Flutter QuickStart'),
//           centerTitle: true,
//           // bottom: PreferredSize(
//           //   preferredSize: Size.fromHeight(100),
//           //   child: Container(
//           //     //height: 100,
//           //     color: Colors.green,
//           //   ),
//           // ),
//         ),
//         backgroundColor: Colors.black,
//         body: Stack(
//           children: <Widget>[
//             _videoViewWidget(),
//              _panel(),
//              _toolbar(),
//           ],
//         ));
//   }
// }