import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mate_app/Screen/Home/CommunityTab/addPersonToGroupSearch.dart';
import 'package:mate_app/Services/community_tab_services.dart';
import 'package:mate_app/Widget/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../asset/Colors/MateColors.dart';
import '../../../controller/theme_controller.dart';
import '../../../groupChat/services/database_service.dart';


class AddPersonToGroup extends StatefulWidget {
  final String groupId,groupName;
  const AddPersonToGroup({Key? key,required this.groupId,required this.groupName}) : super(key: key);

  @override
  _AddPersonToGroupState createState() => _AddPersonToGroupState();
}

class _AddPersonToGroupState extends State<AddPersonToGroup> {
  ThemeController themeController = Get.find<ThemeController>();
  late QuerySnapshot searchResultSnapshot;
  bool isLoading = true;
  bool hasUserSearched = false;
  User _user = FirebaseAuth.instance.currentUser!;
  List<UserListModel> userList = [];
  bool addingUser = false;
  List<int> addUserIndex = [];

  @override
  void initState() {
    print(widget.groupId);
    print(widget.groupName);
    getStoredValue();
    getData();
    super.initState();
  }

  late DocumentSnapshot documentSnapshot;
  getData()async{
    documentSnapshot =  await DatabaseService().getGroupDetailsOnce(widget.groupId);
    List<String> uidList = [];
    for(int i=0;i<documentSnapshot['members'].length;i++){
      uidList.add(documentSnapshot['members'][i].split("_")[0]);
    }
    DatabaseService().getAllUserData(_user.uid).then((snapshot){
      searchResultSnapshot = snapshot;
      for(int i=0;i<searchResultSnapshot.docs.length;i++){
        if(searchResultSnapshot.docs[i]["displayName"]!=null &&
            searchResultSnapshot.docs[i]["displayName"]!=""
            && !uidList.contains(searchResultSnapshot.docs[i]["uid"])
        ){
          userList.add(
              UserListModel(
                uuid: searchResultSnapshot.docs[i]["uuid"],
                uid: searchResultSnapshot.docs[i]["uid"],
                displayName: searchResultSnapshot.docs[i]["displayName"],
                photoURL: searchResultSnapshot.docs[i]["photoURL"],
                email: searchResultSnapshot.docs[i]["email"],
                isSelected: false,
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
  }

  late String token;
  getStoredValue()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("tokenApp")!;
    log(token);
  }

  addUser()async{
    setState(() {
      addingUser = true;
    });
    for(int i=0;i<addUserIndex.length;i++){
      print(userList[addUserIndex[i]].displayName);
      String res = await DatabaseService().addUserToGroup(userList[addUserIndex[i]].uid,widget.groupId,widget.groupName,userList[addUserIndex[i]].displayName);
      print(res);
      if(res == "already added"){
        Fluttertoast.showToast(msg: "User is already added to this group", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
      }else if(res == "Success"){
        CommunityTabService().joinGroup(token: token,groupId: widget.groupId,uid: userList[addUserIndex[i]].uid);
        Fluttertoast.showToast(msg: "User successfully added to this group", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
      }else{
        Fluttertoast.showToast(msg: "Something went wrong", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
      }
    }
    setState(() {
      addingUser = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final scH = MediaQuery.of(context).size.height;
    final scW = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Scaffold(
          floatingActionButton: addUserIndex.isNotEmpty?InkWell(
            onTap: ()async{
              addUser();
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
                Icons.check,
                size: 31,
                color: themeController.isDarkMode?Colors.black:Colors.white,
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
            child:  isLoading ?
            Container(
              child: Center(
                child: CircularProgressIndicator(
                  color: MateColors.activeIcons,
                ),
              ),
            ):
            Column(
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
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddPersonToGroupSearch(groupId: widget.groupId,groupName: widget.groupName,)));
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
                Expanded(child: groupList()),
              ],
            ),
          ),
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
        padding: EdgeInsets.only(top: 10),
        itemCount: userList.length,
        itemBuilder: (context, index) {
          return groupTile(
            userList[index].uuid,
            userList[index].uid,
            userList[index].displayName,
            userList[index].photoURL,
            userList[index].email,
            index==0? true: userList[index].displayName[0].toLowerCase() != userList[index-1].displayName[0].toLowerCase()? true : false,
            userList[index].isSelected,
            index,
          );
        }) :
    Container();
  }

  Widget groupTile(String peerUuid,String peerId, String peerName, String peerAvatar,String email,bool showOrNot,bool isSelected,int index) {
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
            setState(() {
              userList[index].isSelected = !userList[index].isSelected;
            });
            if(addUserIndex.contains(index)){
              addUserIndex.remove(index);
            }else{
              addUserIndex.add(index);
            }
            print(addUserIndex);
            //_showSendAlertDialog(peerId: peerId, groupId: widget.groupId, groupName: widget.groupName, peerName: peerName);
          },
          child: ListTile(
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
              child: Text("Tap to add in the group",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w400,
                  color: themeController.isDarkMode?Colors.white.withOpacity(0.5): Colors.black.withOpacity(0.5),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            trailing: userList[index].isSelected?
            Icon(Icons.check,color: MateColors.activeIcons,):Offstage(),
          ),
        ),
      ],
    );
  }

  // Future<void> _showSendAlertDialog({required String peerId, required String groupId,required groupName,required String peerName}) async {
  //   return showDialog<void>(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return CupertinoAlertDialog(
  //         title: new Text("Are you sure?"),
  //         content: new Text("You want to add this person to $groupName?"),
  //         actions: <Widget>[
  //           CupertinoDialogAction(
  //             isDefaultAction: true,
  //             child: Text("Yes"),
  //             onPressed: ()async{
  //               Navigator.of(context).pop();
  //               setState(() {
  //                 addingUser = true;
  //               });
  //               String res = await DatabaseService().addUserToGroup(peerId,groupId,groupName,peerName);
  //               print(res);
  //               if(res == "already added"){
  //                 Fluttertoast.showToast(msg: "User is already added to this group", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
  //               }else if(res == "Success"){
  //                 CommunityTabService().joinGroup(token: token,groupId: widget.groupId,uid: peerId);
  //                 Fluttertoast.showToast(msg: "User successfully added to this group", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
  //               }else{
  //                 Fluttertoast.showToast(msg: "Something went wrong", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
  //               }
  //               setState(() {
  //                 addingUser = false;
  //               });
  //             },
  //           ),
  //           CupertinoDialogAction(
  //             child: Text("No"),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}


class UserListModel {
  String uuid;
  String uid;
  String displayName;
  String photoURL;
  String email;
  bool isSelected;
  UserListModel({required this.uuid, required this.uid, required this.displayName,required this.photoURL,required this.email,required this.isSelected});
}

