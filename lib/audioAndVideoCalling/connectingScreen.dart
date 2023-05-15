import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart'as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mate_app/groupChat/services/database_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../asset/Colors/MateColors.dart';
import '../controller/theme_controller.dart';
import 'calling.dart';

class ConnectingScreen extends StatefulWidget {
  final String receiverImage;
  final String receiverName;
  final String callType;
  final List<dynamic> uid;
  final bool isGroupCalling;
  final String groupOrPeerId;
  final String groupOrCallerName;
  const ConnectingScreen({Key key, this.receiverImage, this.receiverName, this.callType, this.uid, this.isGroupCalling, this.groupOrPeerId, this.groupOrCallerName}) : super(key: key);

  @override
  State<ConnectingScreen> createState() => _ConnectingScreenState();
}

class _ConnectingScreenState extends State<ConnectingScreen> with SingleTickerProviderStateMixin{
  ThemeController themeController = Get.find<ThemeController>();
  bool callPushApi = true;
  User _user;
  String tokenApi;
  AnimationController _controller;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _user = FirebaseAuth.instance.currentUser;
    _controller = AnimationController(
      vsync: this,
      lowerBound: 0.5,
      duration: Duration(seconds: 3),
    )..repeat();
    getStoredValue();
    onJoin();
    super.initState();
  }

  getStoredValue()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    tokenApi = preferences.getString("token");
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
            SizedBox(
              height: scH*0.07,
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: scH*0.05),
                child: Text(
                  "Connecting...",
                  style: TextStyle(
                    color: themeController.isDarkMode?Colors.white:MateColors.blackText,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
                    fontSize: 17.0,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: scH*0.1,
            ),
            Expanded(
              child: AnimatedBuilder(
                animation: CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
                builder: (context, child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      _buildContainer(150 * _controller.value),
                      _buildContainer(200 * _controller.value),
                      _buildContainer(250 * _controller.value),
                      _buildContainer(300 * _controller.value),
                      Align(
                        child: CachedNetworkImage(
                            imageUrl: widget.receiverImage,
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
                      //Align(child: Icon(Icons.phone_android, size: 44,)),
                    ],
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: scH*0.03),
              child: Text(
                widget.receiverName,
                style: TextStyle(
                  color: themeController.isDarkMode?Colors.white:MateColors.blackText,
                  fontWeight: FontWeight.w700,
                  fontSize: 17.0,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: scH*0.3,bottom: scH*0.05),
              child: InkWell(
                onTap: (){
                  setState(() {
                    callPushApi = false;
                  });
                  Navigator.of(context).pop();
                },
                child: Container(
                  alignment: Alignment.bottomCenter,
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.call,
                      color: Colors.white,
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

  Widget _buildContainer(double radius) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: themeController.isDarkMode?
        Colors.grey.withOpacity(1 - _controller.value):
        Colors.white30.withOpacity(1 - _controller.value),
      ),
    );
  }

  onJoin()async{
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();
    String getRandomString(int length) => String.fromCharCodes(Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
    String channelNameRand = getRandomString(30) + DateTime.now().millisecondsSinceEpoch.toString();

    String response = await joinVideoCall(channelName: channelNameRand);
    print(response);

    if(response !=""){
      if(callPushApi){
        List<String> uid = [];
        for(int i=0;i<widget.uid.length;i++){
          if(widget.uid[i].toString().split("_").first!=_user.uid){
            uid.add(widget.uid[i].toString().split("_").first);
          }
        }
        String res = await notifyPushNotification(
          channelName: channelNameRand,
          token: response,
          callerImage: widget.isGroupCalling ? widget.receiverImage!=""?widget.receiverImage:"" : _user.photoURL??"",
          callerName: widget.isGroupCalling ? widget.receiverName : _user.displayName,
          uid: uid,
          isGroupCall: widget.isGroupCalling,
        );
        if(res=="success"){
          await [Permission.microphone, Permission.camera].request();
          List<String> members = [];
          if(widget.isGroupCalling){
            DocumentSnapshot groupDetails = await DatabaseService().getGroupDetailsOnce(widget.groupOrPeerId);
            List<dynamic> groupMembers = groupDetails["members"];
            for(int i=0;i<groupMembers.length;i++){
              String temp = groupMembers[i].toString().split("_").first;
              members.add(temp);
            }
          }
          await DatabaseService().createCall(
            channelName: channelNameRand,
            groupIdORPeerId: widget.groupOrPeerId,
            groupNameORCallerName: widget.groupOrCallerName,
            videoOrAudio: widget.callType,
            token: response,
            callerUid: _user.uid,
            groupMember: members,
          );
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Calling(
            channelName: channelNameRand,
            token: response,
            callType: widget.callType,
            image: widget.receiverImage,
            name: widget.receiverName,
            isGroupCall: widget.isGroupCalling,
          )));
          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.setBool("isCallOngoing",true);
        }else{
          Navigator.of(context).pop();
          Fluttertoast.showToast(msg: "Something went wrong please try again", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
        }
      }
    }else{
      Navigator.of(context).pop();
      Fluttertoast.showToast(msg: "Something went wrong please try again", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
    }
  }

  Future<String> joinVideoCall({String channelName})async{
    String result = "";
    debugPrint("https://api.mateapp.us/api/agora/token?channel_name=$channelName&user_name=0");
    try {
      final response = await http.get(
        Uri.parse("https://api.mateapp.us/api/agora/token?channel_name=$channelName&user_name=0"),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
        result = parsed["data"]["token"];
      }else {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
      }
    }catch (e) {
      debugPrint(e.toString());
    }
    return result;
  }

  Future<String> notifyPushNotification({String channelName,String token,String callerName,String callerImage,List<String> uid,bool isGroupCall})async{
    String result = "";
    debugPrint("https://api.mateapp.us/api/agora/callPushNotify");
    Map body = {
      "channelName": channelName,
      "token": token,
      "callerName": callerName,
      "callerImage": callerImage,
      "callType": widget.callType,
      "uids": uid,
      "is_group" : isGroupCall?1:0,
    };
    print(jsonEncode(body));
    try {
      final response = await http.post(
        Uri.parse("https://api.mateapp.us/api/agora/callPushNotify"),
        body: jsonEncode(body),
        headers: {"Authorization": "Bearer" +tokenApi,
          'Content-type': 'application/json',
          'Accept': 'application/json',},
      );
      print("===========");
      print(response.statusCode);

      if (response.statusCode == 200 || response.statusCode == 201) {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
        result = "success";
      }else{
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
      }
    }catch (e) {
      debugPrint(e.toString());
    }
    return result;
  }

}
