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
import '../../constant.dart';
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
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: null,
      onPanUpdate: (details) {
        if (details.delta.dy > 0){
          FocusScope.of(context).requestFocus(FocusNode());
          print("Dragging in +Y direction");
        }
      },
      child: Scaffold(
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
              SizedBox(
                height: scH*0.07,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: searchEditingController,
                  onChanged: (val) => setState((){
                    searchedName=val;
                  }),
                  cursorColor: themeController.isDarkMode?MateColors.helpingTextDark:MateColors.helpingTextLight,
                  style:  TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.1,
                    color: themeController.isDarkMode?Colors.white:Colors.black,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: themeController.isDarkMode ? MateColors.containerDark : MateColors.containerLight,
                    hintStyle: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      color: themeController.isDarkMode?MateColors.helpingTextDark:MateColors.helpingTextLight,
                    ),
                    hintText: "Search",
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 15,top: 15,bottom: 15),
                      child: Image.asset(
                        "lib/asset/homePageIcons/searchPurple@3x.png",
                        height: 10,
                        width: 10,
                        color: themeController.isDarkMode?Colors.white:Colors.black,
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
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            color: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                          ),
                        ),
                      ),
                    ),
                    enabledBorder: commonBorder,
                    focusedBorder: commonBorder,
                  ),
                ),
              ),
              Expanded(
                child: StreamBuilder<DocumentSnapshot>(
                    stream: DatabaseService().getGroupDetails(widget.groupId),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        print(snapshot.data['createdAt']);
                        return ListView(
                          padding: EdgeInsets.only(top: 10),
                          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                                        title: Text(currentUser.uid==userList[index].uid?"You":userList[index].displayName,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.w600,
                                            color: themeController.isDarkMode?Colors.white: MateColors.blackTextColor,
                                          ),
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