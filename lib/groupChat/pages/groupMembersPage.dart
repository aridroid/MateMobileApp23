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

    userList.sort((a, b) {
      return a.displayName.toLowerCase().compareTo(b.displayName.toLowerCase());
    });
    setState(() {
      isLoading = false;
    });
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
                    "Members",
                    style: TextStyle(
                      color: themeController.isDarkMode ? Colors.white : MateColors.blackTextColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 17.0,
                    ),
                  ),
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
                        color: themeController.isDarkMode?Colors.white:Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<DocumentSnapshot>(
                stream: DatabaseService().getGroupDetails(widget.groupId),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      print(snapshot.data['createdAt']);
                      return ListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.only(top: 0),
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
                                      radius: 30,
                                      backgroundColor: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                                      backgroundImage: NetworkImage(
                                        userList[index].photoURL,
                                      ),
                                    ):CircleAvatar(
                                      radius: 30,
                                      backgroundColor: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
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
                                              child: Image.asset("lib/asset/icons/addPerson.png",
                                                height: 21,
                                                color: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                                              ),
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
                                        child: Image.asset("lib/asset/icons/addPerson.png",height: 21,color: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,),
                                      ),
                                    ):Offstage(),
                                    contentPadding: EdgeInsets.only(top: 5),
                                    title: Text(currentUser.uid==userList[index].uid?"You":userList[index].displayName,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w600,
                                        color: themeController.isDarkMode?Colors.white: MateColors.blackTextColor,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ],
                      );
                    }else
                      return Center(child: Text("Oops! Something went wrong! \nplease trey again..", style: TextStyle(fontSize: 10.9.sp)));
                  }
              ),
            ),
          ],
        ),
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
            color: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
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
