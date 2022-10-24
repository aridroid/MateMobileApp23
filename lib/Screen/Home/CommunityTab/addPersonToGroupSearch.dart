import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Services/community_tab_services.dart';
import '../../../Widget/loader.dart';
import '../../../asset/Colors/MateColors.dart';
import '../../../controller/theme_controller.dart';
import '../../../groupChat/pages/groupMembersPage.dart';
import '../../../groupChat/services/database_service.dart';


class AddPersonToGroupSearch extends StatefulWidget {
  final String groupId,groupName;
  const AddPersonToGroupSearch({Key key, this.groupId, this.groupName}) : super(key: key);

  @override
  _AddPersonToGroupSearchState createState() => _AddPersonToGroupSearchState();
}

class _AddPersonToGroupSearchState extends State<AddPersonToGroupSearch> {
  ThemeController themeController = Get.find<ThemeController>();
  QuerySnapshot searchResultSnapshot;
  bool isLoading = true;
  bool hasUserSearched = false;
  User _user = FirebaseAuth.instance.currentUser;
  String searchedName="";
  List<UserListModel> userList = [];
  bool addingUser = false;


  @override
  void initState() {
    print(widget.groupId);
    print(widget.groupName);
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
        return a.displayName.toLowerCase().compareTo(b.displayName.toLowerCase());
      });
      setState(() {
        isLoading = false;
        hasUserSearched = true;
      });
    });
    super.initState();
  }


  String token;
  getStoredValue()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token");
    log(token);
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
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
        ),
        Visibility(
          visible: addingUser,
          child: Loader(),
        ),
      ],
    );
  }

  Widget groupList() {
    return hasUserSearched ?
    ListView.builder(
        shrinkWrap: true,
        itemCount: userList.length,//searchResultSnapshot.docs.length,
        itemBuilder: (context, index) {
          return Visibility(
            visible: searchedName==""?true:searchedName!="" && userList[index].displayName.toString().toLowerCase().contains(searchedName.toLowerCase()),
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
        InkWell(
          onTap: ()async{
            _showSendAlertDialog(peerId: peerId, groupId: widget.groupId, groupName: widget.groupName, peerName: peerName);
          },
          child: ListTile(
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
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Text("Tap to add in the group",
                style: TextStyle(letterSpacing: 0.1,fontFamily: "Poppins",fontSize: 14.0, fontWeight: FontWeight.w400, color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showSendAlertDialog({@required String peerId, @required String groupId,@required groupName,@required String peerName}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: new Text("Are you sure?"),
          content: new Text("You want to add this person to $groupName?"),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text("Yes"),
              onPressed: ()async{
                Navigator.of(context).pop();
                setState(() {
                  addingUser = true;
                });
                String res = await DatabaseService().addUserToGroup(peerId,groupId,groupName,peerName);
                print(res);
                if(res == "already added"){
                  Fluttertoast.showToast(msg: "User is already added to this group", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
                }else if(res == "Success"){
                  CommunityTabService().joinGroup(token: token,groupId: widget.groupId,uid: peerId);
                  Fluttertoast.showToast(msg: "User successfully added to this group", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
                }else{
                  Fluttertoast.showToast(msg: "Something went wrong", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
                }
                setState(() {
                  addingUser = false;
                });
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
