import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart'as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mate_app/audioAndVideoCalling/addParticipantsSearchScreen.dart';
import 'package:mate_app/controller/addParticipantsToCallController.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../asset/Colors/MateColors.dart';
import '../controller/theme_controller.dart';
import '../groupChat/services/database_service.dart';

class AddParticipantsToCallScreen extends StatefulWidget {
  final String channelName;
  final String token;
  final String callType;
  final String image;
  final String name;
  final bool isGroupCall;
  const AddParticipantsToCallScreen({Key? key, required this.channelName, required this.token, required this.callType, required this.image, required this.name, required this.isGroupCall}) : super(key: key);

  @override
  State<AddParticipantsToCallScreen> createState() => _AddParticipantsToCallScreenState();
}

class _AddParticipantsToCallScreenState extends State<AddParticipantsToCallScreen> {
  ThemeController themeController = Get.find<ThemeController>();
  late QuerySnapshot searchResultSnapshot;
  bool isLoading = true;
  bool hasUserSearched = false;
  User _user = FirebaseAuth.instance.currentUser!;
  String searchedName="";
  List<UserListModel> userList = [];
  late String tokenApi;
  final AddParticipantsToCallController _addUserController = Get.put(AddParticipantsToCallController());

  @override
  void initState() {
    getStoredValue();
    DatabaseService().getAllUserData(_user.uid).then((snapshot){
      searchResultSnapshot = snapshot;
      for(int i=0;i<searchResultSnapshot.docs.length;i++){
        if(searchResultSnapshot.docs[i]["displayName"]!=null && searchResultSnapshot.docs[i]["displayName"]!=""){
          userList.add(
              UserListModel(
                uuid: searchResultSnapshot.docs[i]["uuid"],
                uid: searchResultSnapshot.docs[i]["uid"],
                displayName: searchResultSnapshot.docs[i]["displayName"],
                photoURL: searchResultSnapshot.docs[i]["photoURL"],
                email: searchResultSnapshot.docs[i]["email"],
              )
          );
        }
      }
      userList.sort((a, b) {
        return a.displayName!.toLowerCase().compareTo(b.displayName!.toLowerCase());
      });
      setState(() {
        isLoading = false;
        hasUserSearched = true;
      });
    });
    super.initState();
  }

  getStoredValue()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    tokenApi = preferences.getString("tokenApp")!;
  }

  @override
  Widget build(BuildContext context) {
    final scH = MediaQuery.of(context).size.height;
    final scW = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: _addUserController.addConnectionUid.isNotEmpty?InkWell(
        onTap: (){
          Get.back();
          Fluttertoast.showToast(msg: "Calling other members", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
          notifyPushNotification(
            channelName: widget.channelName,
            token: widget.token,
            callerImage: widget.isGroupCall ? widget.image!=""?widget.image:"" : _user.photoURL??"",
            callerName: widget.isGroupCall ? widget.name : _user.displayName!,
            uid: _addUserController.addConnectionUid,
            callType: widget.callType,
            tokenApi: tokenApi,
          );
        },
        child: Container(
          height: 56,
          width: 56,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
          ),
          child: Icon(
            Icons.person_add,
            size: 25,
            color: Colors.black,
          ),
        ),
      ):Offstage(),
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
        child:  Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height*0.07,
                left: 16,
                right: 6,
                bottom: 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: (){
                      Get.back();
                    },
                    child: Icon(Icons.arrow_back_ios,
                      size: 20,
                      color: themeController.isDarkMode ? Colors.white : MateColors.blackTextColor,
                    ),
                  ),
                  Text(
                    "Add Participants",
                    style: TextStyle(
                      color: themeController.isDarkMode ? Colors.white : MateColors.blackTextColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 17.0,
                    ),
                  ),
                  InkWell(
                    onTap: ()async{
                      await Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddParticipantsToCallSearch(
                        channelName: widget.channelName,
                        isGroupCall: widget.isGroupCall,
                        image: widget.image,
                        name: widget.name,
                        callType: widget.callType,
                        token: widget.token,
                      )));
                      setState(() {});
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16,left: 16),
                      child: Image.asset(
                        "lib/asset/homePageIcons/searchPurple@3x.png",
                        height: 23.7,
                        width: 23.7,
                        color: themeController.isDarkMode?Colors.white:Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: isLoading ?
              Container(
                child: Center(
                  child: CircularProgressIndicator(
                    color: MateColors.activeIcons,
                  ),
                ),
              ):
              groupList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget groupList() {
    return hasUserSearched ?
    ListView.builder(
        shrinkWrap: true,
        itemCount: userList.length,//searchResultSnapshot.docs.length,
        itemBuilder: (context, index) {
          print(userList[index].displayName);
          return groupTile(
            userList[index].uuid!,
            userList[index].uid!,
            userList[index].displayName!,
            userList[index].photoURL!,
            userList[index].email!,
            index==0? true: userList[index].displayName?[0].toLowerCase() != userList[index-1].displayName?[0].toLowerCase()? true : false,
            index,
          );
        }) :
    Container();
  }

  Widget groupTile(String peerUuid,String peerId, String peerName, String peerAvatar,String email,bool showOrNot,int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        showOrNot?
        Padding(
          padding: EdgeInsets.only(left: 25,top: 5),
          child: Text(peerName[0].toUpperCase(),
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 15.0,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.1,
              color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
            ),
          ),
        ):Offstage(),
        ListTile(
          onTap: ()async{
            setState(() {
              if(_addUserController.selected.contains(index)){
                _addUserController.selected.remove(index);
              }else{
                _addUserController.selected.add(index);
              }
            });
            if(_addUserController.addConnectionUid.contains(userList[index].uid)){
              _addUserController.addConnectionUid.remove(userList[index].uid);
            }else{
              _addUserController.addConnectionUid.add(userList[index].uid!);
            }
          },
          contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
            backgroundImage: NetworkImage(peerAvatar??""),
          ),
          title: Text(
            peerName,
            style: TextStyle(
              fontSize: 15,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w600,
              color: themeController.isDarkMode?Colors.white: MateColors.blackTextColor,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Text("Tap to add on the call",
              style: TextStyle(
                fontSize: 14,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w400,
                color: themeController.isDarkMode?Colors.white: MateColors.blackTextColor,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          trailing: _addUserController.selected.contains(index)?
          Icon(Icons.check,
            color: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
          ):Offstage(),
        ),
      ],
    );
  }

  Future<String> notifyPushNotification({required String channelName,required String token,required String callerName,required String callerImage,required List<String> uid,required String callType,required String tokenApi})async{
    String result = "";
    debugPrint("https://api.mateapp.us/api/agora/callPushNotify");
    Map body = {
      "channelName": channelName,
      "token": token,
      "callerName": callerName,
      "callerImage": callerImage,
      "callType": callType,
      "uids": uid,
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

class UserListModel {
  String? uuid;
  String? uid;
  String? displayName;
  String? photoURL;
  String? email;
  UserListModel({this.uuid, this.uid, this.displayName,this.photoURL,this.email});
}