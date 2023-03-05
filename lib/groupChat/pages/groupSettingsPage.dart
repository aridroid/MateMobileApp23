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
  bool isUserMember = false;
  bool updateIsUserMember = true;

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
  }

  @override
  Widget build(BuildContext context) {
    final scH = MediaQuery.of(context).size.height;
    final scW = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: themeController.isDarkMode?backgroundColor:Colors.white,
      key: _key,
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
                  SizedBox(),
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
                      Future.delayed(Duration.zero,(){
                        groupName = snapshot.data['groupName'];
                        groupIcon = snapshot.data['groupIcon']??"";
                        if(updateIsUserMember){
                          isUserMember = snapshot.data['members'].contains(_user.uid + '_' + _user.displayName);
                          updateIsUserMember = false;
                          setState(() {});
                        }
                      });
                      return ListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.only(top: 30),
                        children: [
                          Center(
                            child: InkWell(
                              onTap: () => isUserMember?modalSheetGroupIconChange(snapshot.data['groupIcon'] != ""):null,
                              child:  snapshot.data['groupIcon']!=""?
                              CircleAvatar(
                                radius: 55,
                                backgroundColor: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                                backgroundImage: NetworkImage(snapshot.data['groupIcon']),
                              ):
                              CircleAvatar(
                                radius: 55,
                                backgroundColor: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                                child: Text(snapshot.data['groupName'].substring(0, 1).toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: themeController.isDarkMode?Colors.black:Colors.white, fontSize: 28.5.sp, fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              if(isUserMember){
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => GroupNamePage(groupId: snapshot.data['groupId'], groupName: snapshot.data['groupName'] ?? "",)));
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Text(snapshot.data['groupName'],
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style:  TextStyle(fontSize: 18,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                  color: themeController.isDarkMode?Colors.white:MateColors.blackText,
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5,bottom: 10),
                              child: Text("${snapshot.data['members'].length} ${snapshot.data['members'].length<2 ? "member": "members"}",
                                style:  TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w500,
                                  color: themeController.isDarkMode?Colors.white.withOpacity(0.7):Colors.black.withOpacity(0.7),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 88,
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(left: 16,right: 16,top: 20),
                            padding: EdgeInsets.fromLTRB(20,20,20,0),
                            decoration: BoxDecoration(
                              color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                              borderRadius: BorderRadius.circular(125),
                            ),
                            child: InkWell(
                              onTap: (){
                                if(isUserMember){
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>GroupMembersPage(groupId: widget.groupId,addPerson: true,)));
                                }
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 48,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        ListView.builder(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            physics: NeverScrollableScrollPhysics(),
                                            itemCount: snapshot.data['members'].length>4?4:snapshot.data['members'].length,
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
                                                            radius: 24,
                                                            backgroundColor: MateColors.activeIcons,
                                                            backgroundImage: NetworkImage(
                                                              snapshot1.data.data()['photoURL'],
                                                            ),
                                                          ):
                                                          CircleAvatar(
                                                            radius: 24,
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
                                        snapshot.data['members'].length>4?
                                        Container(
                                          height: 48,
                                          width: 48,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight
                                          ),
                                          child: Text("+${snapshot.data['members'].length - 4}",
                                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: MateColors.blackText),
                                          ),
                                        ):Offstage(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16,top: 16),
                            child: Text("Community description",
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w500,
                                color: themeController.isDarkMode?Colors.white:MateColors.blackText,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          (snapshot.data['description']==null || snapshot.data['description']=="")?
                          Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: InkWell(
                              splashColor:  Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: ()=>isUserMember?Navigator.of(context).push(MaterialPageRoute(builder: (context) => GroupDescriptionPage(
                                groupId: snapshot.data['groupId'],
                                description: snapshot.data['description'] ?? "",
                              ))):null,
                              child: Text("Add group description",
                                style:  TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w400,
                                  color: themeController.isDarkMode?Colors.white:MateColors.blackText,
                                ),
                              ),
                            ),
                          ):
                          Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: InkWell(
                              splashColor:  Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: ()=>isUserMember?Navigator.of(context).push(MaterialPageRoute(builder: (context) => GroupDescriptionShowPage(
                                groupId: snapshot.data['groupId'],
                                description: snapshot.data['description'] ?? "",
                                descriptionCreatorName: snapshot.data['descriptionCreatorName']??"",
                                descriptionCreatorImage: snapshot.data['descriptionCreatorImage']??"",
                                descriptionCreationTime: snapshot.data['descriptionCreationTime']??0,
                              ))):null,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(snapshot.data['description'].toString().length>100?
                                  snapshot.data['description'].toString().substring(0,100) + "...":
                                  snapshot.data['description'].toString(),
                                    style:  TextStyle(
                                      fontSize: 14,
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w400,
                                      color: themeController.isDarkMode?Colors.white:MateColors.blackText,
                                    ),
                                  ),
                                  if(snapshot.data['description'].toString().length>100)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: Text("See more",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w400,
                                          color: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                                        ),
                                      ),
                                    )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16,right: 16,top: 10,bottom: 16),
                            child: Divider(
                              thickness: 1,
                              color: themeController.isDarkMode?MateColors.dividerDark:MateColors.dividerLight,
                            ),
                          ),
                          if(isUserMember)
                            Padding(
                              padding: const EdgeInsets.only(left: 16,right: 16),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Mute community",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w500,
                                          color: themeController.isDarkMode?Colors.white:MateColors.blackText,
                                        ),
                                      ),
                                      Container(
                                        child: FlutterSwitch(
                                          width: 48,
                                          height: 28,
                                          valueFontSize: 25.0,
                                          toggleSize: 20.0,
                                          activeText: "",
                                          inactiveText: "",
                                          toggleColor: Color(0xFF1E1E1E),
                                          inactiveColor: themeController.isDarkMode?Colors.white.withOpacity(0.12):Colors.black.withOpacity(0.1),
                                          activeColor: themeController.isDarkMode?Color(0xFF67AE8C):Color(0xFF17F3DE),
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
                                    height: 30,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Pin to top",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w500,
                                          color: themeController.isDarkMode?Colors.white:MateColors.blackText,
                                        ),
                                      ),
                                      Container(
                                        child: FlutterSwitch(
                                          width: 48,
                                          height: 28,
                                          valueFontSize: 25.0,
                                          toggleSize: 20.0,
                                          activeText: "",
                                          inactiveText: "",
                                          toggleColor: Color(0xFF1E1E1E),
                                          inactiveColor: themeController.isDarkMode?Colors.white.withOpacity(0.12):Colors.black.withOpacity(0.1),
                                          activeColor: themeController.isDarkMode?Color(0xFF67AE8C):Color(0xFF17F3DE),
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
                          Padding(
                            padding: const EdgeInsets.only(left: 16,right: 16,top: 16,bottom: 16),
                            child: Divider(
                              thickness: 1,
                              color: themeController.isDarkMode?MateColors.dividerDark:MateColors.dividerLight,
                            ),
                          ),
                          if(isLoadedGroup)
                            Padding(
                              padding: const EdgeInsets.only(left: 16,bottom: 16,top: 10),
                              child: Text("Communities you might be interested in",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w500,
                                  color: themeController.isDarkMode?Colors.white:MateColors.blackText,
                                ),
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
                                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatPage(
                                                groupId: snapshot.data["groupId"],
                                                userName: Provider.of<AuthUserProvider>(context, listen: false).authUser.displayName,
                                                totalParticipant: snapshot.data["members"].length.toString(),
                                                photoURL: snapshot.data['groupIcon'],
                                                groupName: snapshot.data["groupName"].toString(),
                                                memberList : snapshot.data["members"],
                                              )));
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
                              if(isUserMember){
                                await DatabaseService(uid: _user.uid).togglingGroupJoin(snapshot.data['groupId'],snapshot.data['groupName'],_user.displayName);
                                isUserMember = false;
                                setState(() {});
                              }else{
                                await CommunityTabService().exitGroup(token: token,uid: _user.uid,groupId: snapshot.data['groupId']);
                                Get.back();
                                Get.back();
                              }
                            },
                            child: Container(
                              height: 50,
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                isUserMember?
                                'Exit Group':"Delete Group",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.0,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    } else
                      return Center(child: Text("Oops! Something went wrong! \nplease trey again..", style: TextStyle(fontSize: 10.9.sp)));
                  }),
            ),
          ],
        ),
      ),
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
      width: 140,
      margin: EdgeInsets.only(right: 20,bottom: 10,top: 10),
      padding: EdgeInsets.only(top: 25,left: 0,right: 0),
      decoration: BoxDecoration(
        color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
        borderRadius: BorderRadius.circular(20),
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
              style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontFamily: "Poppins",
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                  color: themeController.isDarkMode?Colors.white:MateColors.blackText,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Text(
              "${totalParticipant} members",
              style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 13.0,
                  fontWeight: FontWeight.w400,
                  color: themeController.isDarkMode?Colors.white.withOpacity(0.5):Colors.black.withOpacity(0.5),
              ),
              overflow: TextOverflow.clip,
            ),
          ),
        ],
      ),
    );
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
