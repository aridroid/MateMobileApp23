import 'dart:convert';
import 'package:http/http.dart'as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../asset/Colors/MateColors.dart';
import '../controller/addParticipantsToCallController.dart';
import '../controller/theme_controller.dart';
import '../groupChat/services/database_service.dart';

class AddParticipantsToCallSearch extends StatefulWidget {
  final String channelName;
  final String token;
  final String callType;
  final String image;
  final String name;
  final bool isGroupCall;
  const AddParticipantsToCallSearch({Key key, this.channelName, this.token, this.callType, this.image, this.name, this.isGroupCall}) : super(key: key);

  @override
  State<AddParticipantsToCallSearch> createState() => _AddParticipantsToCallSearchState();
}

class _AddParticipantsToCallSearchState extends State<AddParticipantsToCallSearch> {
  ThemeController themeController = Get.find<ThemeController>();
  final AddParticipantsToCallController _addUserController = Get.find<AddParticipantsToCallController>();
  FocusNode focusNode = FocusNode();
  String searchedName="";
  bool isLoading = true;
  QuerySnapshot searchResultSnapshot;
  User _user = FirebaseAuth.instance.currentUser;
  List<UserListModel> userList = [];
  bool hasUserSearched = false;
  String tokenApi;

  @override
  void initState() {
    getStoredValue();
    focusNode.requestFocus();
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
        return a.displayName.toLowerCase().compareTo(b.displayName.toLowerCase());
      });
      setState(() {
        isLoading = false;
        hasUserSearched = true;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  getStoredValue()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    tokenApi = preferences.getString("token");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: TextField(
          onChanged: (val) => setState((){
            searchedName=val;
          }),
          style: TextStyle(color: themeController.isDarkMode?Colors.white:Colors.black),
          decoration: InputDecoration(
            hintStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.1,
              color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
            ),
            hintText: "Search",
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 15,top: 15,bottom: 15),
              child: Image.asset(
                "lib/asset/homePageIcons/searchPurple@3x.png",
                height: 10,
                width: 10,
                color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
              ),
            ),
            suffixIcon: InkWell(
              onTap: (){
                Get.back();
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 16,right: 15),
                child: Text(
                  "Close",
                  style: TextStyle(
                    fontSize: 15,
                    letterSpacing: 0.1,
                    fontWeight: FontWeight.w700,
                    color: MateColors.activeIcons,
                  ),
                ),
              ),
            ),
            enabledBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(width: 3,color: themeController.isDarkMode?MateColors.darkDivider:MateColors.lightDivider),
            ),
            focusedBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(width: 3,color: themeController.isDarkMode?MateColors.darkDivider:MateColors.lightDivider),
            ),
          ),
        ),
      ),
      floatingActionButton: _addUserController.addConnectionUid.isNotEmpty?InkWell(
        onTap: (){
          Get.back();
          Get.back();
          Fluttertoast.showToast(msg: "Calling other members", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
          notifyPushNotification(
            channelName: widget.channelName,
            token: widget.token,
            callerImage: widget.isGroupCall ? widget.image!=""?widget.image:"" : _user.photoURL??"",
            callerName: widget.isGroupCall ? widget.name : _user.displayName,
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
            color: MateColors.activeIcons,
          ),
          child: Icon(
            Icons.person_add,
            size: 25,
            color: themeController.isDarkMode?Colors.black:Colors.white,
          ),
        ),
      ):Offstage(),
      body: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        children: [
          SizedBox(height: 25,),
          ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              itemCount: userList.length,
              itemBuilder: (context, index) {
                return FutureBuilder(
                    future: DatabaseService().getUsersDetails(userList[index].uid),
                    builder: (context, snapshot1) {
                      if(snapshot1.hasData){
                        return Visibility(
                          visible: searchedName!="" && snapshot1.data.data()['displayName'].toString().toLowerCase().contains(searchedName.toLowerCase()),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 35),
                            child: InkWell(
                              onTap: (){
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
                                  _addUserController.addConnectionUid.add(userList[index].uid);
                                }
                              },
                              child: ListTile(
                                leading: snapshot1.data.data()['photoURL']!=null?
                                CircleAvatar(
                                  radius: 28,
                                  backgroundColor: MateColors.activeIcons,
                                  backgroundImage: NetworkImage(
                                    snapshot1.data.data()['photoURL'],
                                  ),
                                ):
                                CircleAvatar(
                                  radius: 28,
                                  backgroundColor: MateColors.activeIcons,
                                  child: Text(snapshot1.data.data()['displayName'].substring(0,1),style: TextStyle(color: themeController.isDarkMode?Colors.black:Colors.white),),
                                ),
                                title: Text(snapshot1.data.data()['displayName'],
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.1,
                                    color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                                  ),
                                ),
                                trailing: _addUserController.selected.contains(index)?
                                Icon(Icons.check,color: MateColors.activeIcons,):Offstage(),
                              ),
                            ),
                          ),
                        );
                      }
                      return SizedBox();
                    }
                );
              }),
        ],
      ),
    );
  }
  Future<String> notifyPushNotification({String channelName,String token,String callerName,String callerImage,List<String> uid,String callType,String tokenApi})async{
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
  String uuid;
  String uid;
  String displayName;
  String photoURL;
  String email;
  UserListModel({this.uuid, this.uid, this.displayName,this.photoURL,this.email});
}