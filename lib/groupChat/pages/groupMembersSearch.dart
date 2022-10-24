import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../Providers/AuthUserProvider.dart';
import '../../Screen/Profile/ProfileScreen.dart';
import '../../Screen/Profile/UserProfileScreen.dart';
import '../../asset/Colors/MateColors.dart';
import '../../controller/theme_controller.dart';
import '../services/database_service.dart';

class GroupMembersSearch extends StatefulWidget {
  final String groupId;
  const GroupMembersSearch({Key key, this.groupId}) : super(key: key);

  @override
  _GroupMembersSearchState createState() => _GroupMembersSearchState();
}

class _GroupMembersSearchState extends State<GroupMembersSearch> {
  ThemeController themeController = Get.find<ThemeController>();
  User currentUser = FirebaseAuth.instance.currentUser;
  DocumentSnapshot documentSnapshot;
  List<UserListModel> userList = [];
  bool isLoading = true;
  TextEditingController searchEditingController = new TextEditingController();
  String searchedName="";

  @override
  void initState(){
    getData();
    super.initState();
  }

  getData()async{
    documentSnapshot =  await DatabaseService().getGroupDetailsOnce(widget.groupId);
    for(int i=0;i<documentSnapshot['members'].length;i++){
      print(documentSnapshot['members'][i].split("_")[0]);
      DocumentSnapshot value = await DatabaseService().getUsersDetails(documentSnapshot['members'][i].split("_")[0]);
      userList.add(
          UserListModel(
            uuid: value["uuid"],
            uid: value["uid"],
            displayName: value["displayName"],
            photoURL: value["photoURL"],
            email: value["email"],
          )
      );
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
                        return Visibility(
                          visible: searchedName==""?true:searchedName!="" && userList[index].displayName.toString().toLowerCase().contains(searchedName.toLowerCase()),
                          child: Padding(
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
                              ):
                              Offstage(),
                              contentPadding: EdgeInsets.only(top: 5),
                              title: Text(currentUser.uid==userList[index].uid?"You":userList[index].displayName, style: TextStyle(fontFamily: "Poppins",fontSize: 15.0, fontWeight: FontWeight.w500, color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor),),
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