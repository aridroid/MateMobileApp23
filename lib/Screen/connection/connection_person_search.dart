import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Services/connection_service.dart';
import '../../asset/Colors/MateColors.dart';
import '../../constant.dart';
import '../../controller/theme_controller.dart';
import '../../groupChat/services/database_service.dart';


class ConnectionPersonSearch extends StatefulWidget {
  const ConnectionPersonSearch({Key key}) : super(key: key);

  @override
  _ConnectionPersonSearchState createState() => _ConnectionPersonSearchState();
}

class _ConnectionPersonSearchState extends State<ConnectionPersonSearch> {
  TextEditingController searchEditingController = new TextEditingController();
  FocusNode focusNode = FocusNode();
  QuerySnapshot searchResultSnapshot;
  bool isLoading = true;
  bool hasUserSearched = false;
  User _user = FirebaseAuth.instance.currentUser;
  String searchedName="";
  ThemeController themeController = Get.find<ThemeController>();

  @override
  void initState() {
    getStoredValue();
    focusNode.requestFocus();
    DatabaseService().getAllUserData(_user.uid).then((snapshot){
      searchResultSnapshot = snapshot;
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

  String token;

  getStoredValue()async{
    print("////////////////");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token");
    log(token);
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
        itemCount: searchResultSnapshot.docs.length,
        padding: EdgeInsets.only(top: 5,bottom: 5),
        itemBuilder: (context, index) {
          return Visibility(
            visible: searchedName!="" && searchResultSnapshot.docs[index]["displayName"].toString().toLowerCase().contains(searchedName.toLowerCase()),
            child: Padding(
              padding: EdgeInsets.only(top: connectionGlobalUidList.contains(searchResultSnapshot.docs[index]["uid"])?0:16),
              child: groupTile(
                searchResultSnapshot.docs[index]["uuid"],
                searchResultSnapshot.docs[index]["uid"],
                searchResultSnapshot.docs[index]["displayName"],
                searchResultSnapshot.docs[index]["photoURL"],
                searchResultSnapshot.docs[index]["email"],
              ),
            ),
          );
        }) :
    Container();
  }

  Widget groupTile(String peerUuid,String peerId, String peerName, String peerAvatar,String email) {
    return connectionGlobalUidList.contains(peerId)?
      Offstage():
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
          padding: const EdgeInsets.only(right: 4),
          child: Image.asset("lib/asset/icons/addPerson.png",height: 21,),
        ),
      ),
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
