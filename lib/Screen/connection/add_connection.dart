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
  }

  @override
  void initState() {
    getStoredValue();
    DatabaseService().getAllUserData(_user.uid).then((snapshot){
      searchResultSnapshot = snapshot;
      print(searchResultSnapshot.docs[0].data());
      for(int i=0;i<searchResultSnapshot.docs.length;i++){
        if(searchResultSnapshot.docs[i]["displayName"]!=null && searchResultSnapshot.docs[i]["displayName"]!="") {
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
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height*0.07,
                left: 16,
                right: 16,
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
                    "Add Connections",
                    style: TextStyle(
                      color: themeController.isDarkMode ? Colors.white : MateColors.blackTextColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 17.0,
                    ),
                  ),
                  SizedBox(),
                ],
              ),
            ),
            GestureDetector(
              onTap: (){
                Get.to(ConnectionPersonSearch());
              },
              child: Container(
                margin: EdgeInsets.only(left: 16,right: 16,top: 16),
                height: 60,
                decoration: BoxDecoration(
                  color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.only(left: 16, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Search here...",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: themeController.isDarkMode?MateColors.helpingTextDark:Colors.black.withOpacity(0.72),
                      ),
                    ),
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: themeController.isDarkMode?MateColors.textFieldSearchDark:MateColors.textFieldSearchLight,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          "lib/asset/iconsNewDesign/search.png",
                          color: themeController.isDarkMode?Colors.white:MateColors.blackText,
                        ),
                      ),
                    ),
                  ],
                ),
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
            trailing: InkWell(
              onTap: ()async{
                if(requestGetUid.contains(peerId)){
                  Get.back();
                }else if(!requestSentUid.contains(peerId)){
                  _showAddConnectionAlertDialog(uid: peerId, name: peerName,uuid: peerUuid);
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 4,left: 4),
                child: requestSentUid.contains(peerId)?
                Text(
                  "Sent",
                  style: TextStyle(
                    color: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    fontFamily: 'Poppins',
                  ),
                ):
                requestGetUid.contains(peerId)?
                Text(
                  "Accept/Delete",
                  style: TextStyle(
                    color: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    fontFamily: 'Poppins',
                  ),
                ):
                Image.asset(
                  "lib/asset/iconsNewDesign/inviteMates.png",
                  height: 21,
                  color: themeController.isDarkMode?Colors.white:Colors.black,
                ),
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
