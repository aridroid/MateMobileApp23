// // import 'dart:async';
// // import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// // import 'package:flutter/material.dart';
// // import 'package:permission_handler/permission_handler.dart';
// //
// // import './call.dart';
// //
// // class IndexPage extends StatefulWidget {
// //   @override
// //   State<StatefulWidget> createState() => IndexState();
// // }
// //
// // class IndexState extends State<IndexPage> {
// //   /// create a channelController to retrieve text value
// //   final _channelController = TextEditingController();
// //
// //   /// if channel textField is validated to have error
// //   bool _validateError = false;
// //
// //   ClientRole _role = ClientRole.Broadcaster;
// //
// //   @override
// //   void dispose() {
// //     // dispose input controller
// //     _channelController.dispose();
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       appBar: AppBar(
// //         title: Text('Agora Flutter QuickStart main screen'),
// //       ),
// //       body: Center(
// //         child: Container(
// //           padding: const EdgeInsets.symmetric(horizontal: 20),
// //           height: 400,
// //           child: Column(
// //             children: <Widget>[
// //               Row(
// //                 children: <Widget>[
// //                   Expanded(
// //                       child: TextField(
// //                         controller: _channelController,
// //                         decoration: InputDecoration(
// //                           errorText:
// //                           _validateError ? 'Channel name is mandatory' : null,
// //                           border: UnderlineInputBorder(
// //                             borderSide: BorderSide(width: 1),
// //                           ),
// //                           hintText: 'Channel name',
// //                         ),
// //                       ))
// //                 ],
// //               ),
// //               Column(
// //                 children: [
// //                   ListTile(
// //                     title: Text(ClientRole.Broadcaster.toString()),
// //                     leading: Radio(
// //                       value: ClientRole.Broadcaster,
// //                       groupValue: _role,
// //                       onChanged: (ClientRole value) {
// //                         setState(() {
// //                           _role = value;
// //                         });
// //                       },
// //                     ),
// //                   ),
// //                   ListTile(
// //                     title: Text(ClientRole.Audience.toString()),
// //                     leading: Radio(
// //                       value: ClientRole.Audience,
// //                       groupValue: _role,
// //                       onChanged: (ClientRole value) {
// //                         setState(() {
// //                           _role = value;
// //                         });
// //                       },
// //                     ),
// //                   )
// //                 ],
// //               ),
// //               Padding(
// //                 padding: const EdgeInsets.symmetric(vertical: 20),
// //                 child: Row(
// //                   children: <Widget>[
// //                     Expanded(
// //                       child: ElevatedButton(
// //                         onPressed: onJoin,
// //                         child: Text('Join'),
// //                         style: ButtonStyle(
// //                             backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
// //                             foregroundColor: MaterialStateProperty.all(Colors.white)
// //                         ),
// //                       ),
// //                     ),
// //                     // Expanded(
// //                     //   child: RaisedButton(
// //                     //     onPressed: onJoin,
// //                     //     child: Text('Join'),
// //                     //     color: Colors.blueAccent,
// //                     //     textColor: Colors.white,
// //                     //   ),
// //                     // )
// //                   ],
// //                 ),
// //               )
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Future<void> onJoin() async {
// //     // update input validation
// //     setState(() {
// //       _channelController.text.isEmpty
// //           ? _validateError = true
// //           : _validateError = false;
// //     });
// //     if (_channelController.text.isNotEmpty) {
// //       // await for camera and mic permissions before pushing video page
// //       await _handleCameraAndMic(Permission.camera);
// //       await _handleCameraAndMic(Permission.microphone);
// //       // push video page with given channel name
// //       await Navigator.push(
// //         context,
// //         MaterialPageRoute(
// //           builder: (context) => CallPage(
// //             channelName: _channelController.text,
// //             role: _role,
// //           ),
// //         ),
// //       );
// //     }
// //   }
// //
// //   Future<void> _handleCameraAndMic(Permission permission) async {
// //     final status = await permission.request();
// //     print(status);
// //   }
// // }
//
//
//
// import 'dart:convert';
// import 'dart:developer';
// import 'dart:math';
//
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:mate_app/Providers/AuthUserProvider.dart';
// import 'package:mate_app/Widget/loader.dart';
// import 'package:mate_app/audioAndVideoCalling/calling.dart';
// import 'package:mate_app/constant.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:provider/provider.dart';
// import './call.dart';
// import 'package:http/http.dart'as http;
//
// class IndexPage extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return new IndexState();
//   }
// }
//
// class IndexState extends State<IndexPage> {
//   /// create a channelController to retrieve text value
//   final _channelController = TextEditingController();
//
//   /// if channel textfield is validated to have error
//   bool _validateError = false;
//   bool isLoading = false;
//
//   @override
//   void dispose() {
//     // dispose input controller
//     _channelController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Scaffold(
//           backgroundColor: Colors.white,
//             appBar: AppBar(
//               title: Text('Flutter Video Call'),
//             ),
//             body: Center(
//               child: Container(
//                   padding: EdgeInsets.symmetric(horizontal: 20),
//                   height: 400,
//                   child: Column(
//                     children: <Widget>[
//                       // Row(children: <Widget>[]),
//                       // Row(children: <Widget>[
//                       //   Expanded(
//                       //       child: TextField(
//                       //         controller: _channelController,
//                       //         decoration: InputDecoration(
//                       //             errorText: _validateError
//                       //                 ? "Channel name is mandatory"
//                       //                 : null,
//                       //             border: UnderlineInputBorder(
//                       //                 borderSide: BorderSide(width: 1)),
//                       //             hintText: 'Channel name'),
//                       //       ))
//                       // ]),
//                       Padding(
//                           padding: EdgeInsets.symmetric(vertical: 20),
//                           child: Row(
//                             children: <Widget>[
//                               Expanded(
//                                 child: RaisedButton(
//                                   onPressed: () => onJoin(0),
//                                   child: Text("Join Video Call"),
//                                   color: Colors.blueAccent,
//                                   textColor: Colors.white,
//                                 ),
//                               ),
//                               SizedBox(
//                                 width: 20.0,
//                               ),
//                               Expanded(
//                                 child: RaisedButton(
//                                   onPressed: () => onJoin(1),
//                                   child: Text("Join Voice Call"),
//                                   color: Colors.blueAccent,
//                                   textColor: Colors.white,
//                                 ),
//                               )
//                             ],
//                           ))
//                     ],
//                   )),
//             )),
//         Visibility(
//           visible: isLoading,
//           child: Loader(),
//         ),
//       ],
//     );
//   }
//
//   onJoin(int callType) async{
//     // update input validation
//     // String auth_name = Provider.of<AuthUserProvider>(context,listen: false).authUser.displayName;
//     // print(auth_name);
//     setState(() {
//       isLoading = true;
//     });
//     const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
//     Random _rnd = Random();
//     String getRandomString(int length) => String.fromCharCodes(Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
//     String channelNameRand = getRandomString(30);
//
//     String response = await joinVideoCall(channelName: channelNameRand);
//     print(response);
//
//     if(response !=""){
//       setState(() {
//         _channelController.text.isEmpty ? _validateError = true : _validateError = false;
//         isLoading = false;
//       });
//      // if (_channelController.text.isNotEmpty) {
//         // push video page with given channel name
//        await [Permission.microphone, Permission.camera].request();
//        if(callType==0){
//          Navigator.push(context, MaterialPageRoute(builder: (context) => Calling(
//            channelName: channelNameRand,//"hello",
//            token: response,//Token,
//            callType: "Video Calling",
//          )));
//        }else{
//          Navigator.push(context, MaterialPageRoute(builder: (context) => Calling(
//            channelName: channelNameRand,//"hello",
//            token: response,//Token,
//            callType: "Audio Calling",
//          )));
//        }
//
//      // }
//     }else{
//       Fluttertoast.showToast(msg: "Something went wrong", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
//     }
//
//
//   }
//
//   // redirectToPage(int callType) {
//   //   switch (callType) {
//   //     case 0:
//   //       return CallPage(
//   //         channelName: _channelController.text,
//   //       );
//   //     case 1:
//   //       return VoiceCall();
//   //   /*  return VoiceCall(
//   //         channelName: _channelController.text,
//   //       );*/
//   //   }
//   // }
//
//
//   Future<String> joinVideoCall({String channelName})async{
//     String result = "";
//     debugPrint("https://api.mateapp.us/api/agora/token?channel_name=$channelName&user_name=0");
//     try {
//       final response = await http.get(
//         Uri.parse("https://api.mateapp.us/api/agora/token?channel_name=$channelName&user_name=0"),
//       );
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         var parsed = json.decode(utf8.decode(response.bodyBytes));
//         debugPrint(parsed.toString());
//         result = parsed["data"]["token"];
//       }else {
//         var parsed = json.decode(utf8.decode(response.bodyBytes));
//         debugPrint(parsed.toString());
//       }
//     }catch (e) {
//       debugPrint(e.toString());
//     }
//     return result;
//   }
//
//
//
//
// }