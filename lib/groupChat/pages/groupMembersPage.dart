import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mate_app/constant.dart';
import 'package:mate_app/groupChat/pages/groupMembersSearch.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../Providers/AuthUserProvider.dart';
import '../../Screen/Home/CommunityTab/addPersonToGroup.dart';
import '../../Screen/Profile/ProfileScreen.dart';
import '../../Screen/Profile/UserProfileScreen.dart';
import '../../Services/connection_service.dart';
import '../../asset/Colors/MateColors.dart';
import '../../controller/theme_controller.dart';
import '../services/database_service.dart';

class GroupMembersPage extends StatefulWidget {
  final String groupId;
  final bool addPerson;
  const GroupMembersPage({Key key, this.groupId, this.addPerson}) : super(key: key);

  @override
  _GroupMembersPageState createState() => _GroupMembersPageState();
}

class _GroupMembersPageState extends State<GroupMembersPage> {
  ThemeController themeController = Get.find<ThemeController>();
  User currentUser = FirebaseAuth.instance.currentUser;
  DocumentSnapshot documentSnapshot;
  List<UserListModel> userListAll = [];
  List<UserListModel> userList = [];
  bool isLoading = false;
  String groupId = "";
  String groupName = "";
  String token;

  getStoredValue()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token");
    log(token);
  }

  @override
  void initState(){
    getStoredValue();
    getData();
    super.initState();
  }

  getData()async{
    setState(() {
      isLoading = true;
      userList.clear();
    });
    documentSnapshot =  await DatabaseService().getGroupDetailsOnce(widget.groupId);
    setState(() {
      groupId = documentSnapshot['groupId'];
      groupName = documentSnapshot['groupName'];
    });

    QuerySnapshot allUser = await DatabaseService().getUsersDetailsAll();

    List<String> uidList = [];
    for(int i=0;i<documentSnapshot['members'].length;i++){
      uidList.add(documentSnapshot['members'][i].split("_")[0]);
    }

    for(int i=0;i<allUser.docs.length;i++){
      if(allUser.docs[i]["displayName"]!=null && allUser.docs[i]["displayName"]!="" && uidList.contains(allUser.docs[i]["uid"])){
        userList.add(
            UserListModel(
              uuid: allUser.docs[i]["uuid"],
              uid: allUser.docs[i]["uid"],
              displayName: allUser.docs[i]["displayName"],
              photoURL: allUser.docs[i]["photoURL"],
              email: allUser.docs[i]["email"],
            )
        );
      }
    }

    // for(int i=0;i<documentSnapshot['members'].length;i++){
    //   print(documentSnapshot['members'][i].split("_")[0]);
    //   DocumentSnapshot value = await DatabaseService().getUsersDetails(documentSnapshot['members'][i].split("_")[0]);
    //   userList.add(
    //       UserListModel(
    //         uuid: value["uuid"],
    //         uid: value["uid"],
    //         displayName: value["displayName"],
    //         photoURL: value["photoURL"],
    //         email: value["email"],
    //       )
    //   );
    //   setState(() {
    //     //isLoading = false;
    //   });
    // }

    userList.sort((a, b) {
      return a.displayName.toLowerCase().compareTo(b.displayName.toLowerCase());
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: MateColors.activeIcons,
        ),
        centerTitle: true,
        title: Text("Members",
          style: TextStyle(
            color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
            fontWeight: FontWeight.w700,
            fontSize: 17.0,
          ),
        ),
        actions: [
          InkWell(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>GroupMembersSearch(groupId: widget.groupId,)));
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 16,left: 16),
              child: Image.asset(
                "lib/asset/homePageIcons/searchPurple@3x.png",
                height: 23.7,
                width: 23.7,
                color: MateColors.activeIcons,
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: DatabaseService().getGroupDetails(widget.groupId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print(snapshot.data['createdAt']);
              return ListView(
                shrinkWrap: true,
                children: [
                  isLoading?
                  Container(
                    height: MediaQuery.of(context).size.height,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: MateColors.activeIcons,
                      ),
                    ),
                  ):
                  ListView.builder(
                      padding: EdgeInsets.fromLTRB(25,0,20,0),
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: userList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          child: ListTile(
                            onTap: (){
                              if(userList[index].uuid!=null){
                                if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == userList[index].uuid) {
                                  Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                                } else {
                                  Navigator.of(context).pushNamed(UserProfileScreen.routeName,
                                      arguments: {"id": userList[index].uuid,
                                        "name": userList[index].displayName,
                                        "photoUrl": userList[index].photoURL,
                                        "firebaseUid": userList[index].uid
                                      });
                                }
                              }
                            },
                            leading: userList[index].photoURL!=null?
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: MateColors.activeIcons,
                              backgroundImage: NetworkImage(
                                userList[index].photoURL,
                              ),
                            ):CircleAvatar(
                              radius: 24,
                              backgroundColor: MateColors.activeIcons,
                              child: Text(userList[index].displayName.substring(0,1),style: TextStyle(color: themeController.isDarkMode?Colors.black:Colors.white),),
                            ),
                            trailing: userList[index].uid == snapshot.data['creatorId']?
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  height: 28,
                                  width: 63,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    color: Color(0xFFFF8740),
                                  ),
                                  child: Text("Owner",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                !connectionGlobalUidList.contains(userList[index].uid) && Provider.of<AuthUserProvider>(context, listen: false).authUser.firebaseUid!=userList[index].uid?
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: InkWell(
                                    onTap: ()async{
                                      _showAddConnectionAlertDialog(uid: userList[index].uid, name: userList[index].displayName,uuid: userList[index].uuid);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 4,left: 4),
                                      child: Image.asset("lib/asset/icons/addPerson.png",height: 21,),
                                    ),
                                  ),
                                ):Offstage(),
                              ],
                            ):
                            !connectionGlobalUidList.contains(userList[index].uid) && Provider.of<AuthUserProvider>(context, listen: false).authUser.firebaseUid!=userList[index].uid?
                            InkWell(
                              onTap: ()async{
                                _showAddConnectionAlertDialog(uid: userList[index].uid, name: userList[index].displayName,uuid: userList[index].uuid);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 4,left: 4),
                                child: Image.asset("lib/asset/icons/addPerson.png",height: 21,),
                              ),
                            ):Offstage(),
                            contentPadding: EdgeInsets.only(top: 5),
                            title: Text(currentUser.uid==userList[index].uid?"You":userList[index].displayName, style: TextStyle(fontFamily: "Poppins",fontSize: 15.0, fontWeight: FontWeight.w500, color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor),),
                          ),
                        );
                      }),
                  // ListView.builder(
                  //     padding: EdgeInsets.fromLTRB(25,0,20,0),
                  //     shrinkWrap: true,
                  //     physics: ScrollPhysics(),
                  //     itemCount: snapshot.data.data()['members'].length,
                  //     itemBuilder: (context, index) {
                  //       return Padding(
                  //         padding: EdgeInsets.symmetric(vertical: 12.0),
                  //         child: FutureBuilder(
                  //             future: DatabaseService().getUsersDetails(snapshot.data.data()['members'][index].split("_")[0]),
                  //             builder: (context, snapshot1) {
                  //               if(snapshot1.hasData){
                  //                 return ListTile(
                  //                   onTap: (){
                  //                     if(snapshot1.data.data()['uuid']!=null){
                  //                       if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == snapshot1.data.data()['uuid']) {
                  //                         Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                  //                       } else {
                  //                         Navigator.of(context).pushNamed(UserProfileScreen.routeName,
                  //                             arguments: {"id": snapshot1.data.data()['uuid'],
                  //                               "name": snapshot1.data.data()['displayName'],
                  //                               "photoUrl": snapshot1.data.data()['photoURL'],
                  //                               "firebaseUid": snapshot1.data.data()['uid']
                  //                             });
                  //                       }
                  //                     }
                  //                   },
                  //                   leading: snapshot1.data.data()['photoURL']!=null?
                  //                   CircleAvatar(
                  //                     radius: 24,
                  //                     backgroundColor: MateColors.activeIcons,
                  //                     backgroundImage: NetworkImage(
                  //                       snapshot1.data.data()['photoURL'],
                  //                     ),
                  //                   ):CircleAvatar(
                  //                     radius: 24,
                  //                     backgroundColor: MateColors.activeIcons,
                  //                     child: Text(snapshot.data.data()['members'][index].split('_')[1].substring(0,1),style: TextStyle(color: themeController.isDarkMode?Colors.black:Colors.white),),
                  //                   ),
                  //                   trailing: snapshot1.data.data()['uid'] == snapshot.data.data()['creatorId']?
                  //                   Container(
                  //                     height: 28,
                  //                     width: 63,
                  //                     alignment: Alignment.center,
                  //                     decoration: BoxDecoration(
                  //                       borderRadius: BorderRadius.circular(14),
                  //                       color: Color(0xFFFF8740),
                  //                     ),
                  //                     child: Text("Owner",
                  //                       style: TextStyle(
                  //                         fontSize: 14,
                  //                         fontWeight: FontWeight.w500,
                  //                         color: Colors.white,
                  //                       ),
                  //                     ),
                  //                   ):
                  //                   Offstage(),
                  //                   contentPadding: EdgeInsets.only(top: 5),
                  //                   title: Text(currentUser.uid==snapshot1.data.data()['uid']?"You":snapshot1.data.data()['displayName'], style: TextStyle(fontFamily: "Poppins",fontSize: 15.0, fontWeight: FontWeight.w500, color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor),),
                  //                 );
                  //               }
                  //               else if(snapshot1.connectionState == ConnectionState.waiting){
                  //                 return SizedBox(
                  //                   height: 50,
                  //                   child: Center(
                  //                     child: LinearProgressIndicator(
                  //                       color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                  //                       //backgroundColor: myHexColor,
                  //                       // strokeWidth: 1.2,
                  //                       minHeight: 3,
                  //                     ),
                  //                   ),
                  //                 );
                  //               }
                  //               return SizedBox();
                  //
                  //             }
                  //         ),
                  //
                  //
                  //
                  //       );
                  //     }),
                ],
              );
            }else
              return Center(child: Text("Oops! Something went wrong! \nplease trey again..", style: TextStyle(fontSize: 10.9.sp)));
          }
      ),
      floatingActionButton: widget.addPerson?InkWell(
        onTap: ()async{
          await Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddPersonToGroup(groupId: groupId,groupName: groupName,)));
          getData();
        },
        child: Container(
          height: 56,
          width: 56,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: MateColors.activeIcons,
          ),
          child: Image.asset("lib/asset/icons/addPerson.png",
            height: 21,
            width: 21,
            color: themeController.isDarkMode?Colors.black:Colors.white,
          ),
        ),
      ):Offstage(),
    );
  }


  _showAddConnectionAlertDialog({@required String uid, @required String name, @required String uuid})async{
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
                String res = await ConnectionService().addConnection(uid: uid,name: name,uuid:uuid,token: token);
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


class UserListModel {
  String uuid;
  String uid;
  String displayName;
  String photoURL;
  String email;
  UserListModel({this.uuid, this.uid, this.displayName,this.photoURL,this.email});
}
