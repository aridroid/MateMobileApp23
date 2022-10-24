import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mate_app/Screen/connection/connection_person_search.dart';
import 'package:mate_app/Services/connection_service.dart';
import 'package:mate_app/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../asset/Colors/MateColors.dart';
import '../../controller/theme_controller.dart';
import '../../groupChat/pages/groupMembersPage.dart';
import '../../groupChat/services/database_service.dart';

class AddConnection extends StatefulWidget {
  static final String routeName = '/addConnection';

  @override
  _AddConnectionState createState() => _AddConnectionState();
}

class _AddConnectionState extends State<AddConnection> {
  ThemeController themeController = Get.find<ThemeController>();
  QuerySnapshot searchResultSnapshot;
  bool isLoading = true;
  bool hasUserSearched = false;
  User _user = FirebaseAuth.instance.currentUser;
  String searchedName="";
  List<UserListModel> userList = [];
  String token;

  getStoredValue()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token");
    log(token);
  }

  @override
  void initState() {
    getStoredValue();
    DatabaseService().getAllUserData(_user.uid).then((snapshot){
      searchResultSnapshot = snapshot;
      print(searchResultSnapshot.docs[0].data());
      for(int i=0;i<searchResultSnapshot.docs.length;i++){
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: MateColors.activeIcons,
        ),
        actions: [
          InkWell(
            onTap: (){
              Get.to(ConnectionPersonSearch());
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 20,left: 20),
              child: Image.asset(
                "lib/asset/homePageIcons/searchPurple@3x.png",
                height: 23.7,
                width: 23.7,
                color: MateColors.activeIcons,
              ),
            ),
          ),
        ],
        title: Text(
          "Add Connections",
          style: TextStyle(
            color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
            fontWeight: FontWeight.w700,
            fontSize: 17.0,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading ?
      Container(
        child: Center(
          child: CircularProgressIndicator(
            color: MateColors.activeIcons,
          ),
        ),
      ):
      groupList(),
    );
  }

  Widget groupList() {
    return hasUserSearched ?
    ListView.builder(
        shrinkWrap: true,
        itemCount: userList.length,
        padding: EdgeInsets.only(top: 5,bottom: 5),
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(top: connectionGlobalUidList.contains(userList[index].uid)?0:16),
            child: groupTile(
              userList[index].uuid,
              userList[index].uid,
              userList[index].displayName,
              userList[index].photoURL,
              userList[index].email,
              index==0? true: userList[index].displayName[0].toLowerCase() != userList[index-1].displayName[0].toLowerCase()? true : false,
            ),
          );
        }) :
    Container();
  }

  Widget groupTile(String peerUuid,String peerId, String peerName, String peerAvatar,String email,bool showOrNot) {
    return connectionGlobalUidList.contains(peerId)?
    Offstage():
      Column(
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
            contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            leading: CircleAvatar(
              radius: 24,
              backgroundColor: MateColors.activeIcons,
              backgroundImage: NetworkImage(peerAvatar??""),
            ),
            title: Text(
              peerName,
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.1,
                color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
              ),
            ),
            trailing: InkWell(
              onTap: ()async{
                _showAddConnectionAlertDialog(uid: peerId, name: peerName,uuid: peerUuid);
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 4,left: 4),
                child: Image.asset("lib/asset/icons/addPerson.png",height: 21,),
              ),
            ),
          ),
        ],
      );
  }

  _showAddConnectionAlertDialog({@required String uid, @required String name,@required String uuid})async{
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: new Text("Are you sure?"),
          content: new Text("You want to add ${name} to your connection"),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text("Yes"),
              onPressed: ()async{
                String res = await ConnectionService().addConnection(uid: uid,name: name,uuid: uuid,token: token);
                //Connection saved successfully
                //Connection already exists
                Navigator.of(context).pop();
                await getConnection();
                setState(() {});
              },
            ),
            CupertinoDialogAction(
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}
