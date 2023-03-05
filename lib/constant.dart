import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mate_app/Model/conncetionListingModel.dart';
import 'package:mate_app/Services/chatService.dart';
import 'package:mate_app/Services/connection_service.dart';
import 'package:mate_app/groupChat/services/database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Widget/Loaders/Shimmer.dart';
import 'asset/Colors/MateColors.dart';



//Agora Project Name : Mate
//Agora App Certificate : 0bd25de6ff1c48e0ba71eadf5e734969
const APP_ID = "789013eabb9c4b2bada1bf76d5004247";
const Token = "007eJxTYEhd8O6Mycu164wFTK5/WDJb5mrT9pC2dRqsvZPqAp6nOF1VYDC3sDQwNE5NTEqyTDZJMkpKTEk0TEozN0sxNTAwMTIx//85PLk+kJHBbMMvFkYGCATxWRkyUnNy8hkYAAwXIlQ=";




List<Datum> connectionGlobalList = [];
List<String> connectionGlobalUidList = [];
ConnectionService _connectionService = ConnectionService();
List<ConnectionGetSentData> requestSent = [];
List<String> requestSentUid = [];
List<ConnectionGetSentData> requestGet = [];
List<String> requestGetUid = [];
List<String> requestGetUidSender = [];

Future<bool> getConnection()async{
  print("Global connection api calling");
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String token = preferences.getString("token");
  print(token);

  connectionGlobalList = await ConnectionService().getConnection(token: token);
  connectionGlobalUidList.clear();

  for(int i=0;i<connectionGlobalList.length;i++){
    connectionGlobalUidList.add(connectionGlobalList[i].uid);
  }

  print("Global connection api calling done list is now");
  print(connectionGlobalList.length);
  print(connectionGlobalList);

  requestGet = await _connectionService.getConnectionRequestsGet(token: token);
  requestGetUid.clear();
  requestGetUidSender.clear();
  for(int i=0;i<requestGet.length;i++){
    requestGetUid.add(requestGet[i].connUid);
    requestGetUidSender.add(requestGet[i].senderUid);
  }
  print("Request Get length : $requestGet");

  requestSent = await _connectionService.getConnectionRequestsSent(token: token);
  requestSentUid.clear();
  for(int i=0;i<requestSent.length;i++){
    requestSentUid.add(requestSent[i].connUid);
  }
  print("Request Sent length : $requestSent");

  return true;
}

User _user;
void getMateSupportGroupDetails()async{
  _user = await FirebaseAuth.instance.currentUser;
  Future<DocumentSnapshot>  data = DatabaseService().getMateGroupDetailsData("BzVXUBjbv1VBkgViOwJJ");
  data.then((value) async {
    print("------------------Mate group Details--------------------------");
    print(value["members"].contains(_user.uid + '_' + _user.displayName));
    if(!value["members"].contains(_user.uid + '_' + _user.displayName)){
      print("------------------Joining group--------------------------");
      await DatabaseService(uid: _user.uid).togglingGroupJoin(value["groupId"], value["groupName"].toString(), _user.displayName);
      Map<String, dynamic> body = {"group_id": value["groupId"], "read_by": _user.uid, "messages_read": 0};
      Future.delayed(Duration.zero, () {
        ChatService().groupChatMessageReadUpdate(body);
        ChatService().groupChatDataFetch(_user.uid);
      });
    }
  });
}


final commonBorder = OutlineInputBorder(
  borderSide:  BorderSide(
    width: 0,
    color: themeController.isDarkMode ? MateColors.containerDark : MateColors.containerLight,
  ),
  borderRadius: BorderRadius.circular(14.0),
);

final commonBorderCircular = OutlineInputBorder(
  borderSide:  BorderSide(
    width: 0,
    strokeAlign: StrokeAlign.inside,
    color: themeController.isDarkMode ? MateColors.containerDark : MateColors.containerLight,
  ),
  borderRadius: BorderRadius.circular(30.0),
);