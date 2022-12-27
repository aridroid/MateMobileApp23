import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mate_app/Model/communityTabModel.dart';
import 'package:mate_app/Services/community_tab_services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

import '../../../Providers/AuthUserProvider.dart';
import '../../../Utility/Utility.dart';
import '../../../Widget/Drawer/DrawerWidget.dart';
import '../../../Widget/Loaders/Shimmer.dart';
import '../../../asset/Colors/MateColors.dart';
import '../../../controller/addUserController.dart';
import '../../../controller/theme_controller.dart';
import '../../../groupChat/pages/chat_page.dart';
import '../../../groupChat/services/database_service.dart';
import '../../chatDashboard/search_group.dart';
import 'addPersonToGroupUsingConnection.dart';

class CommunityTab extends StatefulWidget {
  const CommunityTab({Key key}) : super(key: key);

  @override
  _CommunityTabState createState() => _CommunityTabState();
}

class _CommunityTabState extends State<CommunityTab> with TickerProviderStateMixin{
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  ThemeController themeController = Get.find<ThemeController>();
  final AddUserController _addUserController = Get.put(AddUserController());
  TabController _tabController;
  User _user;
  String token = "";
  CommunityTabService _communityTabService = CommunityTabService();

  Future<CommunityTabModel> futureUcBerkley;
  Future<CommunityTabModel> futureAll;
  bool ucBerkleySchool = false;
  bool ucBerkleyClass = false;
  bool allSchool = false;
  bool allClass = false;
  int universityId = 0;
  String university;

  @override
  void initState(){
    print(Provider.of<AuthUserProvider>(context, listen: false).authUser.universityId);
    universityId = Provider.of<AuthUserProvider>(context, listen: false).authUser.universityId??0;
    university = Provider.of<AuthUserProvider>(context, listen: false).authUser.university??"";
    _tabController = new TabController(length: universityId==0||universityId==1?1:2, vsync: this);
    getStoredValue();
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String displayName;
  getStoredValue()async{
    _user = await FirebaseAuth.instance.currentUser;
    print(_user.uid);
    print(_user.displayName);
    print(_user.email);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token");
    log(token);
    displayName = Provider.of<AuthUserProvider>(context, listen: false).authUser.displayName;

    futureUcBerkley = _communityTabService.getChat(token: token,uid: _user.uid,category: universityId==2?"Stanford":universityId==3?"UC Berkeley":university);
    futureUcBerkley.then((value){
      setState(() {});
    });

    futureAll = _communityTabService.getChat(token: token,uid: _user.uid,category: "All");
    futureAll.then((value){
      setState(() {});
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        elevation: 0,
        leading: _appBarLeading(context),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: InkWell(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SearchGroup())),
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
          "Communities",
          style: TextStyle(
            color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
            fontWeight: FontWeight.w700,
            fontSize: 17.0,
          ),
        ),
        centerTitle: true,
      ),
      drawer: DrawerWidget(),
      floatingActionButton: InkWell(
        onTap: ()async{
          _addUserController.addConnectionUid.clear();
          _addUserController.addConnectionDisplayName.clear();
          _addUserController.selected.clear();
          await Get.to(()=>AddPersonToGroupUsingConnection());
          print(_addUserController.addConnectionUid);
          if(_addUserController.addConnectionUid.isNotEmpty){
            _popupDialog(context);
          }
        },
        child: Container(
          height: 56,
          width: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: MateColors.activeIcons,
          ),
          child: Icon(Icons.add,color: themeController.isDarkMode?Colors.black:Colors.white,size: 28),
        ),
      ),
      body: Column(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.0),
              border: Border(bottom: BorderSide(color: Color(0xFF65656B).withOpacity(0.2), width: 0.8)),
            ),
            child: TabBar(
              controller: _tabController,
              //isScrollable: true,
              unselectedLabelColor: Color(0xFF656568),
              indicatorColor: MateColors.activeIcons,
              indicatorPadding: EdgeInsets.symmetric(horizontal: 20),
              labelColor: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
              labelStyle: TextStyle(fontSize: 15.0,fontFamily: "Poppins",fontWeight: FontWeight.w500),
              tabs: [
                if(universityId!=1 && universityId!=0)
                Tab(
                  text: universityId==3?"UC Berkeley":university,
                  //universityId==2?"Stanford":"UC Berkeley",
                ),
                Tab(
                  text: "All",
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                if(universityId!=1 && universityId!=0)
                  FutureBuilder<CommunityTabModel>(
                    future: futureUcBerkley,
                    builder: (context,snapshotMain){
                      if(snapshotMain.hasData){
                        if(snapshotMain.data.success==true){
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20,top: 15),
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: (){
                                        setState(() {
                                          ucBerkleySchool = !ucBerkleySchool;
                                          if(ucBerkleySchool){
                                            ucBerkleyClass = false;
                                          }
                                        });
                                      },
                                      child: Container(
                                        height: 36.0,
                                        width: 135.0,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(25),
                                          color: themeController.isDarkMode?ucBerkleySchool?Colors.white:MateColors.darkDivider:ucBerkleySchool?MateColors.blackTextColor:MateColors.lightDivider,
                                        ),
                                        child: Center(
                                          child: Text("Campus Chats",style: TextStyle(fontSize: 14,fontFamily: "Poppins",color: themeController.isDarkMode?ucBerkleySchool?MateColors.blackTextColor:Colors.white:ucBerkleySchool?Colors.white:MateColors.blackTextColor),),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    InkWell(
                                      onTap: (){
                                        setState(() {
                                          ucBerkleyClass = !ucBerkleyClass;
                                          if(ucBerkleyClass){
                                            ucBerkleySchool = false;
                                          }
                                        });
                                      },
                                      child: Container(
                                        height: 36.0,
                                        width: 135.0,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(25),
                                          color: themeController.isDarkMode?ucBerkleyClass?Colors.white:MateColors.darkDivider:ucBerkleyClass?MateColors.blackTextColor:MateColors.lightDivider,
                                        ),
                                        child: Center(
                                          child: Text("Class Chats",style: TextStyle(fontFamily: "Poppins",fontSize: 14,color: themeController.isDarkMode?ucBerkleyClass?MateColors.blackTextColor:Colors.white:ucBerkleyClass?Colors.white:MateColors.blackTextColor),),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 30),
                              Expanded(
                                child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  itemCount: snapshotMain.data.data.length,
                                  itemBuilder: (context, index) {
                                    return Visibility(
                                      visible: ucBerkleySchool || ucBerkleyClass ?
                                      ucBerkleySchool && snapshotMain.data.data[index].group == "School" ? true : ucBerkleyClass && snapshotMain.data.data[index].group =="Class" ? true : false:
                                      true,
                                      child: StreamBuilder<DocumentSnapshot>(
                                        stream: DatabaseService().getLastChatMessage(snapshotMain.data.data[index].groupId),
                                        builder: (context, snapshot) {
                                          if(snapshot.hasData){
                                            // if(snapshot.data.data()["members"].contains(_user.uid + '_' + _user.displayName)){
                                            // }else if(snapshot.data.data()["maxParticipantNumber"] != null ? snapshot.data.data()["members"].length < snapshot.data.data()["maxParticipantNumber"] : true){
                                            //   Navigator.of(context).push(MaterialPageRoute(builder: (context)=>GroupDetailsBeforeJoiningPage(groupId: snapshot.data.data()["groupId"])));
                                            // }
                                            return Container(
                                              margin: EdgeInsets.only(bottom: 25),
                                              child: ListTile(
                                                dense: true,
                                                leading: snapshot.data['groupIcon'] != ""?
                                                CircleAvatar(
                                                  radius: 24,
                                                  backgroundColor: MateColors.activeIcons,
                                                  backgroundImage: NetworkImage(snapshot.data['groupIcon']),
                                                ):
                                                CircleAvatar(
                                                  radius: 24,
                                                  backgroundColor: MateColors.activeIcons,
                                                  child: Text(
                                                    snapshot.data['groupName'].substring(0, 1).toUpperCase(),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(color: themeController.isDarkMode?Colors.black:Colors.white, fontSize: 12.5.sp, fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                                title: Text(snapshot.data['groupName'],style: TextStyle(fontFamily: "Poppins",fontSize: 15.0, fontWeight: FontWeight.w500, color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor)),
                                                subtitle: Padding(
                                                  padding: const EdgeInsets.only(top: 3),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(snapshot.data["admin"],style: TextStyle(fontFamily: "Poppins",fontSize: 14.0, fontWeight: FontWeight.w400, color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor)),
                                                      Text("${snapshot.data["members"].length} people",style: TextStyle(fontFamily: "Poppins",fontSize: 14.0, fontWeight: FontWeight.w400, color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor)),
                                                    ],
                                                  ),
                                                ),
                                                trailing: InkWell(
                                                  onTap: () async {
                                                    print(_user.uid);
                                                    if(snapshot.data["members"].contains(_user.uid + '_' + _user.displayName)){
                                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatPage(
                                                          groupId: snapshot.data["groupId"],
                                                          userName:  _user.displayName,
                                                          totalParticipant: snapshot.data["members"].length.toString(),
                                                          photoURL: snapshot.data['groupIcon'],
                                                          groupName: snapshot.data["groupName"].toString(),
                                                          memberList: snapshot.data["members"],
                                                      )));
                                                    }
                                                    //else if(snapshot.data.data()["maxParticipantNumber"] != null ? snapshot.data.data()["members"].length < snapshot.data.data()["maxParticipantNumber"] : true)
                                                    else{
                                                      await DatabaseService(uid: _user.uid).togglingGroupJoin(snapshot.data["groupId"], snapshot.data["groupName"].toString(), _user.displayName);
                                                      _showScaffold('Successfully joined the group "${snapshot.data["groupName"].toString()}"');
                                                      Future.delayed(Duration(milliseconds: 100), () {
                                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatPage(
                                                            groupId: snapshot.data["groupId"],
                                                            userName: _user.displayName,
                                                            totalParticipant: snapshot.data["members"].length.toString(),
                                                            photoURL: snapshot.data['groupIcon'],
                                                            groupName: snapshot.data["groupName"].toString(),
                                                            memberList: snapshot.data["members"],
                                                        )));
                                                      });
                                                    }
                                                  },
                                                  child: snapshot.data["members"].contains(_user.uid + '_' + _user.displayName)?
                                                  Container(
                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), border: Border.all(color: MateColors.activeIcons, width: 0.6)),
                                                    padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                                                    child: Text('Message', style: TextStyle(color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor, fontWeight: FontWeight.w500,fontSize: 12)),
                                                  ):
                                                  Visibility(
                                                    //snapshot.data.data()["maxParticipantNumber"] != null ? snapshot.data.data()["members"].length < snapshot.data.data()["maxParticipantNumber"] : true,
                                                    visible: true,
                                                    replacement: Container(
                                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), border: Border.all(color: Colors.transparent, width: 0.6)),
                                                        padding: EdgeInsets.symmetric(vertical: 8.0),
                                                        child: Text('Group Full', style: TextStyle(fontFamily: "Poppins",color: Colors.red, fontWeight: FontWeight.w500))),
                                                    child: Image.asset("lib/asset/homePageIcons/addIcon@3x.png",height: 18,width: 18,color: MateColors.activeIcons,),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }else{
                                            return Container();
                                            // Text("Loading groups...", style: TextStyle(fontSize: 10.0.sp));
                                          }
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        }else{
                          return Center(
                            child: Text("No group found",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                              ),
                            ),
                          );
                        }
                      }else if(snapshotMain.hasError){
                        return Center(
                          child: Text("Something went wrong",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                            ),
                          ),
                        );
                      }else{
                        return Shimmer.fromColors(
                          baseColor: themeController.isDarkMode?Colors.white12:Colors.black12,
                          highlightColor: themeController.isDarkMode?Colors.white54:Colors.black54,
                          enabled: true,
                          child: GroupLoader(),
                        );
                      }
                    },
                  ),
                FutureBuilder<CommunityTabModel>(
                  future: futureAll,
                  builder: (context,snapshot){
                    if(snapshot.hasData){
                      if(snapshot.data.success==true){
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20,top: 15),
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: (){
                                      setState(() {
                                        allSchool = !allSchool;
                                        if(allSchool){
                                          allClass = false;
                                        }
                                      });
                                    },
                                    child: Container(
                                      height: 36.0,
                                      width: 135.0,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color: themeController.isDarkMode?allSchool?Colors.white:MateColors.darkDivider:allSchool?MateColors.blackTextColor:MateColors.lightDivider,
                                      ),
                                      child: Center(
                                        child: Text("Campus Chats",style: TextStyle(fontSize: 14,fontFamily: "Poppins",color: themeController.isDarkMode?allSchool?MateColors.blackTextColor:Colors.white:allSchool?Colors.white:MateColors.blackTextColor),),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  InkWell(
                                    onTap: (){
                                      setState(() {
                                        allClass = !allClass;
                                        if(allClass){
                                          allSchool = false;
                                        }
                                      });
                                    },
                                    child: Container(
                                      height: 36.0,
                                      width: 135.0,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color: themeController.isDarkMode?allClass?Colors.white:MateColors.darkDivider:allClass?MateColors.blackTextColor:MateColors.lightDivider,
                                      ),
                                      child: Center(
                                        child: Text("Class Chats",style: TextStyle(fontFamily: "Poppins",fontSize: 14,color: themeController.isDarkMode?allClass?MateColors.blackTextColor:Colors.white:allClass?Colors.white:MateColors.blackTextColor),),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 30),
                            Expanded(
                              child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                itemCount: snapshot.data.data.length,
                                itemBuilder: (context, index) {
                                  return Visibility(
                                    visible: allSchool || allClass ?
                                    allSchool && snapshot.data.data[index].group == "School" ? true : allClass && snapshot.data.data[index].group =="Class" ? true : false:
                                    true,
                                    child: StreamBuilder<DocumentSnapshot>(
                                      stream: DatabaseService().getLastChatMessage(snapshot.data.data[index].groupId),
                                      builder: (context, snapshot) {
                                        if(snapshot.hasData){
                                          // if(snapshot.data.data()["members"].contains(_user.uid + '_' + _user.displayName)){
                                          // }else if(snapshot.data.data()["maxParticipantNumber"] != null ? snapshot.data.data()["members"].length < snapshot.data.data()["maxParticipantNumber"] : true){
                                          //   Navigator.of(context).push(MaterialPageRoute(builder: (context)=>GroupDetailsBeforeJoiningPage(groupId: snapshot.data.data()["groupId"])));
                                          // }
                                          return Container(
                                            margin: EdgeInsets.only(bottom: 25),
                                            child: ListTile(
                                              dense: true,
                                              leading: snapshot.data['groupIcon'] != ""?
                                              CircleAvatar(
                                                radius: 24,
                                                backgroundColor: MateColors.activeIcons,
                                                backgroundImage: NetworkImage(snapshot.data['groupIcon']),
                                              ):
                                              CircleAvatar(
                                                radius: 24,
                                                backgroundColor: MateColors.activeIcons,
                                                child: Text(
                                                  snapshot.data['groupName'].substring(0, 1).toUpperCase(),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(color: themeController.isDarkMode?Colors.black:Colors.white, fontSize: 12.5.sp, fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                              title: Text(snapshot.data['groupName'],style: TextStyle(fontFamily: "Poppins",fontSize: 15.0, fontWeight: FontWeight.w500, color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor)),
                                              subtitle: Padding(
                                                padding: const EdgeInsets.only(top: 3),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(snapshot.data["admin"],style: TextStyle(fontFamily: "Poppins",fontSize: 14.0, fontWeight: FontWeight.w400, color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor)),
                                                    Text("${snapshot.data["members"].length} people",style: TextStyle(fontFamily: "Poppins",fontSize: 14.0, fontWeight: FontWeight.w400, color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor)),
                                                  ],
                                                ),
                                              ),
                                              trailing: InkWell(
                                                onTap: () async {
                                                  if(snapshot.data["members"].contains(_user.uid + '_' + _user.displayName)){
                                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatPage(
                                                        groupId: snapshot.data["groupId"],
                                                        userName: _user.displayName,
                                                        totalParticipant: snapshot.data["members"].length.toString(),
                                                        photoURL: snapshot.data['groupIcon'],
                                                        groupName: snapshot.data["groupName"].toString(),
                                                        memberList: snapshot.data["members"],
                                                    )));
                                                    //Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatPage(groupId: snapshot.data.data()["groupId"], userName: Provider.of<AuthUserProvider>(context, listen: false).authUser.displayName, groupName: snapshot.data.data()["groupName"].toString())));
                                                  }
                                                  //else if (snapshot.data.data()["maxParticipantNumber"] != null ? snapshot.data.data()["members"].length < snapshot.data.data()["maxParticipantNumber"] : true)
                                                  else{
                                                    await DatabaseService(uid: _user.uid).togglingGroupJoin(snapshot.data["groupId"], snapshot.data["groupName"].toString(), _user.displayName);
                                                    _showScaffold('Successfully joined the group "${snapshot.data["groupName"].toString()}"');
                                                    Future.delayed(Duration(milliseconds: 100), () {
                                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatPage(
                                                          groupId: snapshot.data["groupId"],
                                                          userName: _user.displayName,
                                                          totalParticipant: snapshot.data["members"].length.toString(),
                                                          photoURL: snapshot.data['groupIcon'],
                                                          groupName: snapshot.data["groupName"].toString(),
                                                          memberList: snapshot.data["members"],
                                                      )));
                                                     // Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatPage(groupId: snapshot.data.data()["groupId"], userName: Provider.of<AuthUserProvider>(context, listen: false).authUser.displayName, groupName: snapshot.data.data()["groupName"].toString())));
                                                    });
                                                  }
                                                },
                                                child: snapshot.data["members"].contains(_user.uid + '_' + _user.displayName)?
                                                Container(
                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), border: Border.all(color: MateColors.activeIcons, width: 0.6)),
                                                  padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                                                  child: Text('Message', style: TextStyle(color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor, fontWeight: FontWeight.w500,fontSize: 12)),
                                                ):
                                                Visibility(
                                                  //snapshot.data.data()["maxParticipantNumber"] != null ? snapshot.data.data()["members"].length < snapshot.data.data()["maxParticipantNumber"] : true,
                                                  visible: true,
                                                  replacement: Container(
                                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), border: Border.all(color: Colors.transparent, width: 0.6)),
                                                      padding: EdgeInsets.symmetric(vertical: 8.0),
                                                      child: Text('Group Full', style: TextStyle(fontFamily: "Poppins",color: Colors.red, fontWeight: FontWeight.w500))),
                                                  child: Image.asset("lib/asset/homePageIcons/addIcon@3x.png",height: 18,width: 18,color: MateColors.activeIcons,),
                                                ),
                                              ),
                                            ),
                                          );
                                        }else{
                                          return Container();
                                            //Text("Loading groups...", style: TextStyle(fontSize: 10.0.sp));
                                        }
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      }else{
                        return Center(
                          child: Text("No group found",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                            ),
                          ),
                        );
                      }
                    }else if(snapshot.hasError){
                      return Center(
                        child: Text("Something went wrong",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                          ),
                        ),
                      );
                    }else{
                      return Shimmer.fromColors(
                        baseColor: themeController.isDarkMode?Colors.white12:Colors.black12,
                        highlightColor: themeController.isDarkMode?Colors.white54:Colors.black54,
                        enabled: true,
                        child: GroupLoader(),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _appBarLeading(BuildContext context) {
    return Selector<AuthUserProvider, String>(
      selector: (ctx, authUserProvider) => authUserProvider.authUserPhoto,
      builder: (ctx, data, _) {
        return InkWell(
          onTap: () {
            _key.currentState.openDrawer();
          },
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 16,
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 16,
              backgroundImage: NetworkImage(data),
            ),
          ),
        );
      },
    );
  }

  void _popupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MyDialog(
          user: _user,
          displayName: displayName,
          universityId: universityId,
          university: university,
        );
      },
    ).whenComplete((){
      Future.delayed(Duration(seconds: 5),(){
        getStoredValue();
      });
    });
  }

  void _showScaffold(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.black,
      duration: Duration(milliseconds: 1500),
      content: Text(message, textAlign: TextAlign.center, style: TextStyle(fontSize: 13.0, color: MateColors.activeIcons)),
    ));
  }

}

class MyDialog extends StatefulWidget {
  final User user;
  final String displayName;
  final int universityId;
  final String university;

  const MyDialog({Key key, this.user,this.displayName,this.universityId, this.university}) : super(key: key);

  @override
  State createState() => new MyDialogState();
}

class MyDialogState extends State<MyDialog> {
  String _groupName;
  int _groupMaxMember = 50;
  bool isPrivate = false;
  ThemeController themeController = Get.find<ThemeController>();
  final AddUserController _addUserController = Get.find<AddUserController>();
  List<String> category;
  String categoryValue = "";
  List<String> type = ["Campus","Class"];// Campus = School
  String typeValue = "";
  CommunityTabService _communityTabService = CommunityTabService();
  String token = "";

  @override
  void initState() {
    if(widget.universityId==0 || widget.universityId==1){
      category = ["All"];
    }else if(widget.universityId==2){
      category = [widget.university,"All"];
    }else if(widget.universityId==3){
      category = ["UC Berkeley","All"];
    }else{
      category = [widget.university,"All"];
    }
    getStoredValue();
    super.initState();
  }

  getStoredValue()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token");
    log(token);
    setState(() {});
  }

  Widget build(BuildContext context) {
    return new SimpleDialog(
      backgroundColor: themeController.isDarkMode?backgroundColor:Colors.white,
      title: Text("Create a group",
        style: TextStyle(
          color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
          fontWeight: FontWeight.w700,
          fontSize: 17.0,
        ),
      ),
      contentPadding: EdgeInsets.all(10),
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 7.0),
              child: TextFormField(
                style: TextStyle(fontSize: 12.5.sp, height: 2.0, color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor),
                cursorColor: MateColors.activeIcons,
                onChanged: (val) {
                  _groupName = val;
                },
                decoration: InputDecoration(
                  hintStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.1,
                    color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
                  ),
                  hintText: "Group Name",
                  fillColor: themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightButtonBackground,
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderSide:  BorderSide(
                      color: themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightButtonBackground,
                    ),
                    borderRadius: BorderRadius.circular(26.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:  BorderSide(
                      color:  themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightButtonBackground,
                    ),
                    borderRadius: BorderRadius.circular(26.0),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide:  BorderSide(
                      color: themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightButtonBackground,
                    ),
                    borderRadius: BorderRadius.circular(26.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide:  BorderSide(
                      color: themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightButtonBackground,
                    ),
                    borderRadius: BorderRadius.circular(26.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide:  BorderSide(
                      color: themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightButtonBackground,
                    ),
                    borderRadius: BorderRadius.circular(26.0),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            // Container(
            //   height: 50,
            //   margin: const EdgeInsets.symmetric(horizontal: 7.0),
            //   child: TextFormField(
            //     style: TextStyle(fontSize: 12.5.sp, height: 2.0, color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor),
            //     keyboardType: TextInputType.number,
            //     inputFormatters: <TextInputFormatter>[
            //       FilteringTextInputFormatter.allow(RegExp("[0-9]")),
            //       LengthLimitingTextInputFormatter(2),
            //     ],
            //     cursorColor: MateColors.activeIcons,
            //     onChanged: (val) {
            //       _groupMaxMember = int.parse(val);
            //     },
            //     decoration: InputDecoration(
            //       hintStyle: TextStyle(
            //         fontSize: 14,
            //         fontWeight: FontWeight.w400,
            //         letterSpacing: 0.1,
            //         color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
            //       ),
            //       hintText: "Max Participant Number",
            //       fillColor: themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightButtonBackground,
            //       filled: true,
            //       focusedBorder: OutlineInputBorder(
            //         borderSide:  BorderSide(
            //           color: themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightButtonBackground,
            //         ),
            //         borderRadius: BorderRadius.circular(26.0),
            //       ),
            //       enabledBorder: OutlineInputBorder(
            //         borderSide:  BorderSide(
            //           color:  themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightButtonBackground,
            //         ),
            //         borderRadius: BorderRadius.circular(26.0),
            //       ),
            //       disabledBorder: OutlineInputBorder(
            //         borderSide:  BorderSide(
            //           color: themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightButtonBackground,
            //         ),
            //         borderRadius: BorderRadius.circular(26.0),
            //       ),
            //       errorBorder: OutlineInputBorder(
            //         borderSide:  BorderSide(
            //           color: themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightButtonBackground,
            //         ),
            //         borderRadius: BorderRadius.circular(26.0),
            //       ),
            //       focusedErrorBorder: OutlineInputBorder(
            //         borderSide:  BorderSide(
            //           color: themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightButtonBackground,
            //         ),
            //         borderRadius: BorderRadius.circular(26.0),
            //       ),
            //     ),
            //   ),
            // ),
            // SizedBox(
            //   height: 10,
            // ),
            Padding(
              padding: const EdgeInsets.only(left: 10,bottom: 5),
              child: Text(
                "Select category",
                style: TextStyle(
                  color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 15.0,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              padding: EdgeInsets.only(right: 10),
              decoration: const ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1,color: MateColors.subTitleTextDark),
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
              ),
              child:DropdownButtonHideUnderline(
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton<String>(
                    isExpanded: true,
                    items: category.map((item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: (value){
                      setState(() {
                        categoryValue = value;
                        print(categoryValue);
                      });
                    },
                    icon: Icon(Icons.keyboard_arrow_down_sharp,size: 20),
                    hint: Text(categoryValue.isEmpty?"Select One":categoryValue,
                      style: TextStyle(
                        color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10,bottom: 5),
              child: Text(
                "Select type",
                style: TextStyle(
                  color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 15.0,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              padding: EdgeInsets.only(right: 10),
              decoration: const ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1,color: MateColors.subTitleTextDark),
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
              ),
              child:DropdownButtonHideUnderline(
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton<String>(
                    isExpanded: true,
                    items: type.map((item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: (value){
                      setState(() {
                        typeValue = value;
                      });
                    },
                    icon: Icon(Icons.keyboard_arrow_down_sharp,size: 20),
                    hint: Text(typeValue.isEmpty?"Select One":typeValue,
                      style: TextStyle(
                        color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Theme(
              data: ThemeData(
                unselectedWidgetColor: MateColors.inActiveIcons,
              ),
              child: RadioListTile(
                activeColor: MateColors.activeIcons,
                contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
                title: Text(
                  "Public",
                  style: TextStyle(
                    color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 15.0,
                  ),
                ),
                value: false,
                groupValue: isPrivate,
                onChanged: (value) {
                  setState(() {
                    isPrivate = value;
                    print(isPrivate);
                  });
                },
              ),
            ),
            Theme(
              data: ThemeData(
                unselectedWidgetColor: MateColors.inActiveIcons, // Your color
              ),
              child: RadioListTile(
                activeColor: MateColors.activeIcons,
                contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
                title: Text(
                  "Private",
                  style: TextStyle(
                    color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 15.0,
                  ),
                ),
                value: true,
                groupValue: isPrivate,
                onChanged: (value) {
                  setState(() {
                    isPrivate = value;
                    print(isPrivate);
                  });
                },
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              child: Text("Cancel", style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w500, color: MateColors.activeIcons)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Create", style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w500, color: MateColors.activeIcons)),
              onPressed: () async {
                //&& _groupMaxMember > 1
                if (_groupName != null && _groupName.isNotEmpty && categoryValue!="" && typeValue!="") {
                  // await HelperFunctions.getUserNameSharedPreference().then((val) {
                  //   DatabaseService(uid: widget.user.uid).createGroup(val, _groupName, _groupMaxMember<1?100:_groupMaxMember,isPrivate);
                  // });
                  //_groupMaxMember < 1 ? 100 : _groupMaxMember
                  DatabaseService(uid: widget.user.uid).createGroup(widget.displayName, widget.user.uid, _groupName, 2000, isPrivate).then((value) async{
                    _communityTabService.createGroup(
                        token: token,
                        category: widget.universityId==2?"Stanford":categoryValue,
                        type: typeValue=="Campus"?"School":typeValue,
                        groupId: value,
                    );
                    Navigator.of(context).pop();

                    for(int i=0;i<_addUserController.addConnectionUid.length;i++){
                      print(_addUserController.addConnectionUid[i]);
                      String res = await DatabaseService().addUserToGroup(_addUserController.addConnectionUid[i],value,_groupName,_addUserController.addConnectionDisplayName[i]);
                      print(res);
                      if(res == "already added"){
                        Fluttertoast.showToast(msg: "User is already added to this group", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
                      }else if(res == "Success"){
                        CommunityTabService().joinGroup(token: token,groupId: value,uid: _addUserController.addConnectionUid[i]);
                        Fluttertoast.showToast(msg: "User successfully added to this group", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
                      }else{
                        Fluttertoast.showToast(msg: "Something went wrong", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
                      }
                    }

                    //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>HomeScreen(index: 3,)), (route) => false);
                    // Navigator.push(context, MaterialPageRoute(
                    //         builder: (context) => ChatPage(
                    //           groupId: value,
                    //           userName: widget.displayName,
                    //           groupName: _groupName,
                    //         )));
                  });

                  // Navigator.of(context).pop();
                } else {
                  Fluttertoast.showToast(msg: " Please fill all fields ", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
                }
              },
            )
          ],
        ),
      ],
    );
  }
}
