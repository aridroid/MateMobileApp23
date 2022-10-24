import 'dart:developer';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:mate_app/Providers/AuthUserProvider.dart';
import 'package:mate_app/Screen/Profile/ProfileScreen.dart';
import 'package:mate_app/Screen/Profile/UserProfileScreen.dart';
import 'package:mate_app/Services/community_tab_services.dart';
import 'package:mate_app/Utility/Utility.dart';
import 'package:mate_app/asset/Colors/MateColors.dart';
import 'package:mate_app/controller/theme_controller.dart';
import 'package:mate_app/groupChat/pages/groupDescriptionPage.dart';
import 'package:mate_app/groupChat/pages/groupDescriptionShowpage.dart';
import 'package:mate_app/groupChat/pages/groupDetailsBeforeJoining.dart';
import 'package:mate_app/groupChat/pages/groupMembersPage.dart';
import 'package:mate_app/groupChat/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../services/dynamicLinkService.dart';
import 'chat_page.dart';
import 'groupNamePage.dart';

class GroupSettingsPage extends StatefulWidget {
  final String groupId;
  const GroupSettingsPage({Key key, this.groupId}) : super(key: key);

  @override
  _GroupSettingsPageState createState() => _GroupSettingsPageState();
}

class _GroupSettingsPageState extends State<GroupSettingsPage> {
  File imageFile;
  String imageUrl;
  bool isLoading = false;
  ImagePicker picker = ImagePicker();
  User currentUser = FirebaseAuth.instance.currentUser;
  ThemeController themeController = Get.find<ThemeController>();
  User _user;
  QuerySnapshot searchResultSnapshot;
  bool isLoadedGroup = false;
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  String groupName;
  String groupIcon;

  @override
  void initState() {
    _user = FirebaseAuth.instance.currentUser;
    getStoredValue();
    DatabaseService().getAllGroups().then((snapshot) {
      searchResultSnapshot = snapshot;
      setState(() {
        isLoadedGroup = true;
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
    return Scaffold(
      backgroundColor: themeController.isDarkMode?backgroundColor:Colors.white,
      key: _key,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: themeController.isDarkMode?MateColors.drawerTileColor:Colors.white,
        iconTheme: IconThemeData(
          color: MateColors.activeIcons,
        ),
        actions: [
          InkWell(
            onTap: ()async{
              String response  = await DynamicLinkService.buildDynamicLink(
                groupId: widget.groupId,
                groupName: groupName,
                groupIcon: groupIcon,
                userName: _user.displayName
              );
              if(response!=null){
                Share.share(response);
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 20,left: 20),
              child: Image.asset(
                "lib/asset/icons/share.png",
                height: 19,
                width: 19,
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
              Future.delayed(Duration.zero,(){
                groupName = snapshot.data['groupName'];
                groupIcon = snapshot.data['groupIcon']??"";
              });
              return ListView(
                shrinkWrap: true,
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: themeController.isDarkMode?MateColors.drawerTileColor:Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () => modalSheetGroupIconChange(snapshot.data['groupIcon'] != ""),
                          child:  snapshot.data['groupIcon']!=""?
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: MateColors.activeIcons,
                            backgroundImage: NetworkImage(snapshot.data['groupIcon']),
                          ):
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: MateColors.activeIcons,
                            child: Text(snapshot.data['groupName'].substring(0, 1).toUpperCase(),
                              textAlign: TextAlign.center,
                              style: TextStyle(color: themeController.isDarkMode?Colors.black:Colors.white, fontSize: 28.5.sp, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: InkWell(
                              onTap: (){
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => GroupNamePage(groupId: snapshot.data['groupId'], groupName: snapshot.data['groupName'] ?? "",)));
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Text(snapshot.data['groupName'],
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style:  TextStyle(fontSize: 17,fontFamily: "Poppins",fontWeight: FontWeight.w700,color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10,bottom: 10),
                          child: Text("${snapshot.data['members'].length} ${snapshot.data['members'].length<2 ? "member": "members"}",
                            style:  TextStyle(fontSize: 14,fontFamily: "Poppins",fontWeight: FontWeight.w400,color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: themeController.isDarkMode?MateColors.darkDivider:MateColors.lightDivider,
                    thickness: 2,
                    height: 0,
                  ),
                  Container(
                    height: 120,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(left: 16,right: 16,top: 20),
                    padding: EdgeInsets.fromLTRB(20,20,20,0),
                    decoration: BoxDecoration(
                      color: themeController.isDarkMode?MateColors.drawerTileColor:Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: InkWell(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>GroupMembersPage(groupId: widget.groupId,addPerson: true,)));
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${snapshot.data['members'].length} ${snapshot.data['members'].length<2 ? "member": "members"}",
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,),
                          ),
                          Container(
                            height: 50,
                            margin: EdgeInsets.only(top: 8,right: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: snapshot.data['members'].length>5?5:snapshot.data['members'].length,
                                    itemBuilder: (context, index) {
                                      return FutureBuilder(
                                          future: DatabaseService().getUsersDetails(snapshot.data['members'][index].split("_")[0]),
                                          builder: (context, snapshot1) {
                                            if(snapshot1.hasData){
                                              return Padding(
                                                padding: EdgeInsets.only(left: index==0?0:16),
                                                child: InkWell(
                                                  onTap: (){
                                                    if(snapshot1.data.data()['uuid']!=null){
                                                      if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == snapshot1.data.data()['uuid']) {
                                                        Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                                                      } else {
                                                        Navigator.of(context).pushNamed(UserProfileScreen.routeName,
                                                            arguments: {"id": snapshot1.data.data()['uuid'],
                                                              "name": snapshot1.data.data()['displayName'],
                                                              "photoUrl": snapshot1.data.data()['photoURL'],
                                                              "firebaseUid": snapshot1.data.data()['uid']
                                                            });
                                                      }
                                                    }
                                                  },
                                                  child: snapshot1.data.data()['photoURL']!=null?
                                                  CircleAvatar(
                                                    radius: 20,
                                                    backgroundColor: MateColors.activeIcons,
                                                    backgroundImage: NetworkImage(
                                                      snapshot1.data.data()['photoURL'],
                                                    ),
                                                  ):
                                                  CircleAvatar(
                                                    radius: 20,
                                                    backgroundColor: MateColors.activeIcons,
                                                    child: Text(snapshot.data['members'][index].split('_')[1].substring(0,1),style: TextStyle(color: themeController.isDarkMode?Colors.black:Colors.white),),
                                                  ),
                                                ),
                                              );
                                            }
                                            else if(snapshot1.connectionState == ConnectionState.waiting){
                                              return SizedBox(
                                                height: 50,
                                                width: 50,
                                                child: Center(
                                                  child: LinearProgressIndicator(
                                                    color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                                                    minHeight: 3,
                                                  ),
                                                ),
                                              );
                                            }
                                            return SizedBox();
                                          }
                                      );
                                    }),
                                snapshot.data['members'].length>5?
                                Text("+${snapshot.data['members'].length - 5}",
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: themeController.isDarkMode?MateColors.subTitleTextLight:MateColors.subTitleTextLight,),
                                ):Offstage(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(left: 16,right: 16,top: 20,bottom: 20),
                    padding: EdgeInsets.fromLTRB(20,20,20,20),
                    decoration: BoxDecoration(
                      color: themeController.isDarkMode?MateColors.drawerTileColor:Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Community description",
                          style: TextStyle(letterSpacing: 0.1,fontSize: 14,fontFamily: "Poppins",fontWeight: FontWeight.w500,color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        (snapshot.data['description']==null || snapshot.data['description']=="")?
                        InkWell(
                          splashColor:  Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context) => GroupDescriptionPage(
                            groupId: snapshot.data['groupId'],
                            description: snapshot.data['description'] ?? "",
                          ))),
                          child: Text("Add group description",
                            style:  TextStyle(fontSize: 14,fontFamily: "Poppins",fontWeight: FontWeight.w400,color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,),
                          ),
                        ):
                        InkWell(
                          splashColor:  Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context) => GroupDescriptionShowPage(
                            groupId: snapshot.data['groupId'],
                            description: snapshot.data['description'] ?? "",
                            descriptionCreatorName: snapshot.data['descriptionCreatorName']??"",
                            descriptionCreatorImage: snapshot.data['descriptionCreatorImage']??"",
                            descriptionCreationTime: snapshot.data['descriptionCreationTime']??0,
                          ))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(snapshot.data['description'].toString().length>100?
                                snapshot.data['description'].toString().substring(0,100) + "...":
                                snapshot.data['description'].toString(),
                                style:  TextStyle(fontSize: 14,fontFamily: "Poppins",fontWeight: FontWeight.w400,color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,),
                              ),
                              if(snapshot.data['description'].toString().length>100)
                              Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text("See more",
                                  style: TextStyle(fontSize: 14,fontFamily: "Poppins",fontWeight: FontWeight.w500,color: MateColors.activeIcons,),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 16,right: 16,top: 0,bottom: 20),
                    padding: EdgeInsets.fromLTRB(20,20,20,20),
                    decoration: BoxDecoration(
                      color: themeController.isDarkMode?MateColors.drawerTileColor:Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Mute community",
                              style: TextStyle(letterSpacing: 0.1,fontSize: 15,fontFamily: "Poppins",fontWeight: FontWeight.w500,color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,),
                            ),
                            Container(
                              child: FlutterSwitch(
                                width: 48,
                                height: 28,
                                valueFontSize: 25.0,
                                toggleSize: 20.0,
                                activeText: "",
                                inactiveText: "",
                                toggleColor: themeController.isDarkMode?Color(0xFF0B0B0D):Colors.white,
                                inactiveColor: themeController.isDarkMode?Color(0xFF414147):Color(0xFFB4B4C2),
                                activeColor: MateColors.activeIcons,
                                value: !snapshot.data.data().toString().contains('isMuted')?false:snapshot.data['isMuted'].contains(_user.uid),
                                borderRadius: 14.0,
                                showOnOff: true,
                                onToggle: (val) {
                                  if(!snapshot.data.data().toString().contains('isMuted')){
                                    DatabaseService().setIsMuted(widget.groupId, _user.uid);
                                  }else if(snapshot.data['isMuted'].contains(_user.uid)){
                                    DatabaseService().removeIsMuted(widget.groupId, _user.uid);
                                  }else{
                                    DatabaseService().setIsMuted(widget.groupId, _user.uid);
                                  }
                                  CommunityTabService().toggleMute(groupId: widget.groupId,uid: _user.uid,token: token);
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Pin to top",
                              style: TextStyle(letterSpacing: 0.1,fontSize: 15,fontFamily: "Poppins",fontWeight: FontWeight.w500,color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,),
                            ),
                            Container(
                              child: FlutterSwitch(
                                width: 48,
                                height: 28,
                                valueFontSize: 25.0,
                                toggleSize: 20.0,
                                activeText: "",
                                inactiveText: "",
                                toggleColor: themeController.isDarkMode?Color(0xFF0B0B0D):Colors.white,
                                inactiveColor: themeController.isDarkMode?Color(0xFF414147):Color(0xFFB4B4C2),
                                activeColor: MateColors.activeIcons,
                                value: !snapshot.data.data().toString().contains('isPinned')?false:snapshot.data['isPinned'].contains(_user.uid),
                                borderRadius: 14.0,
                                showOnOff: true,
                                onToggle: (val) {
                                  if(!snapshot.data.data().toString().contains('isPinned')){
                                    DatabaseService().setTopToPin(widget.groupId, _user.uid);
                                  }else if(snapshot.data['isPinned'].contains(_user.uid)){
                                    DatabaseService().removeTopToPin(widget.groupId, _user.uid);
                                  }else{
                                    DatabaseService().setTopToPin(widget.groupId, _user.uid);
                                  }
                                  CommunityTabService().toggleTopToPin(groupId: widget.groupId,uid: _user.uid,token: token);
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if(isLoadedGroup)
                    Padding(
                      padding: const EdgeInsets.only(left: 16,bottom: 16,top: 10),
                      child: Text("Communities you might be interested in",
                        style: TextStyle(letterSpacing: 0.1,fontSize: 14,fontFamily: "Poppins",fontWeight: FontWeight.w500,color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,),
                      ),
                    ),
                  if(isLoadedGroup)
                  Container(
                    height: 170,
                    margin: EdgeInsets.only(bottom: 16),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.only(left: 16,right: 0),
                      scrollDirection: Axis.horizontal,
                      itemCount: searchResultSnapshot.docs.length,
                      itemBuilder: (context, index) {
                        if(searchResultSnapshot.docs[index]["isPrivate"] != null){
                          if(searchResultSnapshot.docs[index]["isPrivate"] == false && !searchResultSnapshot.docs[index]["members"].contains(_user.uid + '_' + _user.displayName)){
                              if(searchResultSnapshot.docs[index]["groupName"].toString().contains(snapshot.data['groupName'][0]) || searchResultSnapshot.docs[index]["admin"].toString().contains(snapshot.data['admin'])){
                                return InkWell(
                                  onTap: (){
                                    if(searchResultSnapshot.docs[index]["members"].contains(_user.uid + '_' + _user.displayName)){
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatPage(groupId: snapshot.data["groupId"], userName: Provider.of<AuthUserProvider>(context, listen: false).authUser.displayName, totalParticipant: snapshot.data["members"].length.toString(),photoURL: snapshot.data['groupIcon'],groupName: snapshot.data["groupName"].toString(),)));
                                    }else{
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>GroupDetailsBeforeJoining(groupId: searchResultSnapshot.docs[index]["groupId"],)));
                                    }
                                  },
                                  child: groupTile(
                                      Provider.of<AuthUserProvider>(context, listen: false).authUser.displayName,
                                      searchResultSnapshot.docs[index]["groupId"],
                                      searchResultSnapshot.docs[index]["groupName"].toString(),
                                      searchResultSnapshot.docs[index]["admin"],
                                      searchResultSnapshot.docs[index]["members"].length,
                                      searchResultSnapshot.docs[index]["maxParticipantNumber"],
                                      searchResultSnapshot.docs[index]["isPrivate"],
                                      searchResultSnapshot.docs[index]["members"].contains(_user.uid + '_' + _user.displayName),
                                      searchResultSnapshot.docs[index]["groupIcon"]
                                  ),
                                );
                              }else{
                                return Container();
                              }
                          }else{
                            return Container();
                          }
                        }else{
                          return Container();
                        }
                      },
                    ),
                  ),
                  InkWell(
                    onTap: ()async{
                      DatabaseService(uid: _user.uid).togglingGroupJoin(snapshot.data['groupId'],snapshot.data['groupName'],_user.displayName);
                      await CommunityTabService().exitGroup(token: token,uid: _user.uid,groupId: snapshot.data['groupId']);
                      Get.back();
                      Get.back();
                    },
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: themeController.isDarkMode?MateColors.drawerTileColor:Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Text(
                        'Exit Group',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                          fontSize: 14.0,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),



                  //
                  // Padding(
                  //   padding: EdgeInsets.fromLTRB(15,0,15,0),
                  //   child: InkWell(
                  //     splashColor:  Colors.transparent,
                  //     highlightColor: Colors.transparent,
                  //     onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context) => GroupDescriptionPage(groupId: snapshot.data.data()['groupId'], description: snapshot.data.data()['description'] ?? "",))),
                  //     child: (snapshot.data.data()['description']==null || snapshot.data.data()['description']=="")?
                  //     Text("Add group description",
                  //       style:  TextStyle(fontSize: 14.2.sp,fontFamily: "Poppins",fontWeight: FontWeight.w500,color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,),
                  //     ):
                  //     Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Text("Description",
                  //             style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w500, color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor)),
                  //         Padding(
                  //           padding: const EdgeInsets.only(top: 4.0),
                  //           child: ExpandableText(
                  //             snapshot.data.data()['description'].toString(),
                  //             style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w500,
                  //               color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                  //             ),
                  //             animation: true,
                  //             expandText: "Read more",
                  //             collapseOnTextTap: true,
                  //             linkStyle: TextStyle(fontSize: 11.7.sp, fontWeight: FontWeight.w400, color: Theme.of(context).colorScheme.secondary),
                  //             linkEllipsis: false,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // Divider(
                  //   color: themeController.isDarkMode?MateColors.darkDivider:MateColors.lightDivider,
                  //   height: 20,
                  //   thickness: 2,
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 16,right: 10),
                  //   child:
                  //   snapshot.data.data()["notice"]!=null?
                  //   InkWell(
                  //     onTap: (){
                  //       Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewNoticePage(groupId: snapshot.data.data()['groupId'],notice: snapshot.data.data()['notice']??"",)));
                  //     },
                  //     child: Row(
                  //       children: [
                  //         Text("Notice : ",
                  //           style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w500, color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor),
                  //         ),
                  //         Expanded(
                  //           child: Text(snapshot.data.data()["notice"],
                  //             style: TextStyle(overflow: TextOverflow.ellipsis,fontSize: 12.5.sp, fontWeight: FontWeight.w500, color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ):
                  //   InkWell(
                  //     onTap: (){
                  //       Navigator.push(context, MaterialPageRoute(builder: (context)=>AddNoticePage(groupId: snapshot.data.data()['groupId'],notice: snapshot.data.data()['notice']??"",)));
                  //     },
                  //     child: Text("Add notice to this group",
                  //       style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w500, color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor),
                  //     ),
                  //   ),
                  // ),
                  // Divider(
                  //   color: themeController.isDarkMode?MateColors.darkDivider:MateColors.lightDivider,
                  //   height: 40,
                  //   thickness: 8,
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.only(bottom: 5),
                  //   child: InkWell(
                  //     onTap: (){
                  //       if(snapshot.data.data()["maxParticipantNumber"] != null ? snapshot.data.data()["members"].length < snapshot.data.data()["maxParticipantNumber"] : true){
                  //         Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddPersonToGroup(groupId: snapshot.data.data()['groupId'],groupName: snapshot.data.data()['groupName'],)));
                  //       }else{
                  //         Fluttertoast.showToast(msg: "Group is already full", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
                  //       }
                  //     },
                  //     child: ListTile(
                  //       leading: CircleAvatar(
                  //         radius: 24,
                  //         backgroundColor: MateColors.activeIcons,
                  //         child: Icon(Icons.group_add,
                  //           color: MateColors.blackTextColor,
                  //         ),
                  //       ),
                  //       title: Text("Add Participants",
                  //         style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w500, color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // Divider(
                  //   color: themeController.isDarkMode?MateColors.darkDivider:MateColors.lightDivider,
                  //   //height: 40,
                  //   thickness: 2,
                  // ),
                  // Padding(
                  //   padding: EdgeInsets.fromLTRB(15,0,15,0),
                  //   child: Text("${snapshot.data.data()['members'].length} ${snapshot.data.data()['members'].length<2 ? "participant": "participants"}",
                  //       style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w500, color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor )),
                  // ),
                  // ListView.builder(
                  //     padding: EdgeInsets.fromLTRB(15,0,15,0),
                  //     shrinkWrap: true,
                  //     physics: ScrollPhysics(),
                  //     itemCount: snapshot.data.data()['members'].length,
                  //     itemBuilder: (context, index) {
                  //       return Padding(
                  //         padding: EdgeInsets.symmetric(vertical: 2.0),
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
                  //                   leading:
                  //                   snapshot1.data.data()['photoURL']!=null?
                  //                   CircleAvatar(
                  //                     radius: 24,
                  //                     backgroundColor: MateColors.activeIcons,
                  //                     backgroundImage: NetworkImage(
                  //                       snapshot1.data.data()['photoURL'],
                  //                     ),
                  //                   ): CircleAvatar(
                  //                     radius: 24,
                  //                     backgroundColor: MateColors.activeIcons,
                  //                     child: Text(snapshot.data.data()['members'][index].split('_')[1].substring(0,1),style: TextStyle(color: themeController.isDarkMode?Colors.black:Colors.white),),
                  //                   ),
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

              // NestedScrollView(
              //     headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              //       return <Widget>[
              //         SliverAppBar(
              //           iconTheme: IconThemeData(
              //             color: MateColors.activeIcons,
              //           ),
              //           elevation: 0,
              //           expandedHeight: MediaQuery.of(context).size.height * 0.45,
              //           floating: true,
              //           pinned: true,
              //           flexibleSpace: FlexibleSpaceBar(
              //               collapseMode: CollapseMode.parallax,
              //               titlePadding: EdgeInsetsDirectional.only(start: 55, bottom: 12),
              //               title: Row(
              //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                 mainAxisSize: MainAxisSize.min,
              //                 crossAxisAlignment: CrossAxisAlignment.center,
              //                 children: [
              //                   Expanded(
              //                     child: Column(
              //                       crossAxisAlignment: CrossAxisAlignment.start,
              //                       mainAxisSize: MainAxisSize.min,
              //                       children: [
              //                         Text(snapshot.data.data()['groupName'], style: TextStyle(fontFamily: "Poppins",color:themeController.isDarkMode?Colors.white:MateColors.blackTextColor, fontSize: 12.5.sp, fontWeight: FontWeight.w500)),
              //                         SizedBox(
              //                           height: 2,
              //                         ),
              //                         Text(
              //                           "Created By ${snapshot.data.data()['admin']} ${snapshot.data.data()['createdAt'] != null ? "on ${DateFormat.yMd().format(DateTime.fromMillisecondsSinceEpoch(int.parse(snapshot.data.data()['createdAt'].toString())))}" : ""}",
              //                           style: TextStyle(
              //                             fontFamily: "Poppins",
              //                             color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
              //                             fontSize: 6.7.sp,
              //                             fontWeight: FontWeight.w400,
              //                           ),
              //                           overflow: TextOverflow.fade,
              //                         ),
              //                       ],
              //                     ),
              //                   ),
              //                   InkWell(
              //                     radius: 40,
              //                     onTap: (){
              //                       Navigator.of(context).push(MaterialPageRoute(builder: (context) => GroupNamePage(groupId: snapshot.data.data()['groupId'], groupName: snapshot.data.data()['groupName'] ?? "",)));
              //                     },
              //                     child: Padding(
              //                       padding: const EdgeInsets.only(right: 8.0, left: 8),
              //                       child: Icon(Icons.edit,size: 22,color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,),
              //                     ),
              //                   )
              //                 ],
              //               ),
              //               background: Stack(
              //                 fit: StackFit.expand,
              //                 children: [
              //                   InkWell(
              //                     onTap: () => modalSheetGroupIconChange(snapshot.data.data()['groupIcon'] != ""),
              //                     child: snapshot.data.data()['groupIcon'] != ""
              //                         ? Stack(
              //                       fit: StackFit.expand,
              //                       children: [
              //                         Center(
              //                           child: CircularProgressIndicator(
              //                             backgroundColor: MateColors.activeIcons,
              //                           ),
              //                         ),
              //                         Image.network(
              //                           snapshot.data.data()['groupIcon'],
              //                           fit: BoxFit.fill,
              //                         ),
              //                         Container(
              //                           decoration: BoxDecoration(
              //                               gradient: LinearGradient(colors: [
              //                                 Colors.transparent,
              //                                 Colors.transparent,
              //                                 Colors.transparent,
              //                                 Colors.black87,
              //                               ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
              //                         ),
              //                       ],
              //                     )
              //                         : Container(
              //                       alignment: Alignment.center,
              //                       color: Colors.grey[700],
              //                       padding: EdgeInsets.only(top: 20),
              //                       child: Image.asset(
              //                         "lib/asset/icons/group_icon.png",
              //                         fit: BoxFit.cover,
              //                         height: MediaQuery.of(context).size.height * 0.21,
              //                         width: MediaQuery.of(context).size.height * 0.21,
              //                       ),
              //                     ),
              //                   ),
              //                   Visibility(
              //                     visible: isLoading,
              //                     child: Center(
              //                       child: CircularProgressIndicator(
              //                         backgroundColor: MateColors.activeIcons,
              //                       ),
              //                     ),
              //                   ),
              //                 ],
              //               )),
              //         ),
              //       ];
              //     },
              //     body:
              // );


            } else
              return Center(child: Text("Oops! Something went wrong! \nplease trey again..", style: TextStyle(fontSize: 10.9.sp)));
          }),
    );
  }





  modalSheetGroupIconChange(bool isImageAvailable) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      //backgroundColor: myHexColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15.0),
        ),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: 10.0,
                  ),
                  Center(
                    child: Text(
                      "Select image source",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor),
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  isImageAvailable?
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () => _getImage(0),
                        child: Column(
                          children: [
                            Image.asset(
                              "lib/asset/icons/cameraNew.png",
                              height: 25,
                              width: 25,
                              color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Camera",
                              style: TextStyle(fontSize: 11.7.sp, fontWeight: FontWeight.w500, color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor),
                            )
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () => _getImage(1),
                        child: Column(
                          children: [
                            Image.asset(
                              "lib/asset/icons/galleryNew.png",
                              height: 25,
                              width: 25,
                              color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Gallery",
                              style: TextStyle(fontSize: 11.7.sp, fontWeight: FontWeight.w500, color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor),
                            )
                          ],
                        ),
                      ),
                      InkWell(
                          onTap: () {
                            DatabaseService().updateGroupIcon(widget.groupId, "");
                            Navigator.pop(context);
                          },
                          child: Column(
                            children: [
                              Image.asset(
                                "lib/asset/icons/trashNew.png",
                                height: 25,
                                width: 25,
                                color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Remove",
                                style: TextStyle(fontSize: 11.7.sp, fontWeight: FontWeight.w500, color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor),
                              )
                            ],
                          ),
                        ),
                    ],
                  ):
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () => _getImage(0),
                        child: Column(
                          children: [
                            Image.asset(
                              "lib/asset/icons/cameraNew.png",
                              height: 25,
                              width: 25,
                              color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Camera",
                              style: TextStyle(fontSize: 11.7.sp, fontWeight: FontWeight.w500, color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor),
                            )
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () => _getImage(1),
                        child: Column(
                          children: [
                            Image.asset(
                              "lib/asset/icons/galleryNew.png",
                              height: 25,
                              width: 25,
                              color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Gallery",
                              style: TextStyle(fontSize: 11.7.sp, fontWeight: FontWeight.w500, color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  // SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                ],
              ),
            );
          },
        );
      },
    );
  }


  Widget groupTile(String userName, String groupId, String groupName, String admin, int totalParticipant, int maxParticipant, bool isPrivate, bool _isJoined, String imageURL) {
    return Container(
      width: 130,
      margin: EdgeInsets.only(right: 20,bottom: 10,top: 10),
      padding: EdgeInsets.only(top: 25,left: 0,right: 0),
      decoration: BoxDecoration(
        color: themeController.isDarkMode?MateColors.drawerTileColor:Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          imageURL!=""?
          CircleAvatar(
            radius: 24,
            backgroundColor: MateColors.activeIcons,
            backgroundImage: NetworkImage(imageURL),
          ):
          CircleAvatar(
            radius: 24,
            backgroundColor: MateColors.activeIcons,
            child: Text(groupName.toLowerCase().substring(0, 1).toUpperCase(), textAlign: TextAlign.center,
              style: TextStyle(color: themeController.isDarkMode?Colors.black:Colors.white, fontSize: 12.5.sp, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
            child: Text(
              groupName,
              style: TextStyle(overflow: TextOverflow.ellipsis,fontFamily: "Poppins",fontSize: 14.0, fontWeight: FontWeight.w500, color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Text(
              "${totalParticipant} members",
              style: TextStyle(fontFamily: "Poppins",fontSize: 12.0, fontWeight: FontWeight.w400, color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight),
              overflow: TextOverflow.clip,
            ),
          ),
        ],
      ),
    );
    //   ListTile(
    //   dense: true,
    //   contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
    //   leading: imageURL!=""?
    //   CircleAvatar(
    //     radius: 24,
    //     backgroundColor: MateColors.activeIcons,
    //     backgroundImage: NetworkImage(imageURL),
    //   ):CircleAvatar(
    //     radius: 24,
    //     backgroundColor: MateColors.activeIcons,
    //     child: Text(groupName.toLowerCase().substring(0, 1).toUpperCase(), textAlign: TextAlign.center,
    //       style: TextStyle(color: themeController.isDarkMode?Colors.black:Colors.white, fontSize: 12.5.sp, fontWeight: FontWeight.bold),
    //     ),
    //   ),
    //   title: Text(
    //     groupName,
    //     style: TextStyle(fontFamily: "Poppins",fontSize: 15.0, fontWeight: FontWeight.w500, color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor),
    //   ),
    //   subtitle: Padding(
    //     padding: const EdgeInsets.only(top: 3),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         Text(
    //           admin,
    //           style: TextStyle(fontFamily: "Poppins",fontSize: 14.0, fontWeight: FontWeight.w400, color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor),
    //           overflow: TextOverflow.clip,
    //         ),
    //         Text(
    //           "${totalParticipant} people",
    //           style: TextStyle(fontFamily: "Poppins",fontSize: 14.0, fontWeight: FontWeight.w400, color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor),
    //           overflow: TextOverflow.clip,
    //         ),
    //       ],
    //     ),
    //   ),
    //   trailing: InkWell(
    //     onTap: () async {
    //       if(_isJoined){
    //         Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatPage(groupId: groupId, userName: userName, groupName: groupName)));
    //       }
    //       else if (maxParticipant != null ? totalParticipant < maxParticipant : true) {
    //         await DatabaseService(uid: _user.uid).togglingGroupJoin(groupId, groupName, userName);
    //         // await DatabaseService(uid: _user.uid).userJoinGroup(groupId, groupName, userName);
    //         _showScaffold('Successfully joined the group "$groupName"');
    //         Future.delayed(Duration(milliseconds: 100), () {
    //           Navigator.of(context).pop();
    //           Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatPage(groupId: groupId, userName: userName, groupName: groupName)));
    //         });
    //       }
    //     },
    //     child: _isJoined ?
    //     Container(
    //       decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), border: Border.all(color: MateColors.activeIcons, width: 0.6)),
    //       padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
    //       child: Text('Message', style: TextStyle(color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor, fontWeight: FontWeight.w500,fontSize: 12)),
    //     ) :
    //     Visibility(
    //       visible: maxParticipant != null ? totalParticipant < maxParticipant : true,
    //       replacement: Container(
    //           decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), border: Border.all(color: Colors.transparent, width: 0.6)),
    //           padding: EdgeInsets.symmetric(vertical: 8.0),
    //           child: Text('Group Full', style: TextStyle(fontFamily: "Poppins",color: Colors.red, fontWeight: FontWeight.w500))),
    //       child: Image.asset("lib/asset/homePageIcons/addIcon@3x.png",height: 18,width: 18,color: MateColors.activeIcons,),
    //       // Container(
    //       //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), border: Border.all(color: MateColors.activeIcons, width: 0.6)),
    //       //   padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 8.0),
    //       //   child: Text('Join', style: TextStyle(color: MateColors.activeIcons, fontWeight: FontWeight.w500)),
    //       // ),
    //     ),
    //   ),
    // );
  }


  void _showScaffold(String message) {
    _key.currentState.showSnackBar(SnackBar(
      backgroundColor: Colors.black,
      duration: Duration(milliseconds: 1500),
      content: Text(message, textAlign: TextAlign.center, style: TextStyle(fontSize: 13.0, color: MateColors.activeIcons)),
    ));
  }

  Future _getImage(int index) async {
    PickedFile pickImage;
    if (index == 1) {
      pickImage = await picker.getImage(source: ImageSource.gallery,);
    } else
      pickImage = await picker.getImage(source: ImageSource.camera,);

    if (pickImage != null) {
      imageFile = File(pickImage.path);
      Navigator.pop(context);
      setState(() {
        isLoading = true;
      });
      _uploadFile();
    }
  }

  Future _uploadFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference = FirebaseStorage.instance.ref().child(fileName);

    File compressedFile = await FlutterNativeImage.compressImage(imageFile.path, quality: 60, percentage: 60);


    UploadTask uploadTask = reference.putFile(compressedFile);
    TaskSnapshot storageTaskSnapshot = await uploadTask.whenComplete((){});
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      imageUrl = downloadUrl;
      setState(() {
        DatabaseService().updateGroupIcon(widget.groupId, imageUrl);
        isLoading = false;
      });
    }, onError: (err) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: " Please add a video file ", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
    });
  }
}
