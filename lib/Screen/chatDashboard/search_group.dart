import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../Providers/AuthUserProvider.dart';
import '../../asset/Colors/MateColors.dart';
import '../../controller/theme_controller.dart';
import '../../groupChat/helper/helper_functions.dart';
import '../../groupChat/pages/chat_page.dart';
import '../../groupChat/services/database_service.dart';
import '../Home/CommunityTab/groupDetailsBeforeJoiningPage.dart';

class SearchGroup extends StatefulWidget {
  const SearchGroup({Key key}) : super(key: key);

  @override
  _SearchGroupState createState() => _SearchGroupState();
}

class _SearchGroupState extends State<SearchGroup> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController searchEditingController = new TextEditingController();
  ThemeController themeController = Get.find<ThemeController>();
  FocusNode focusNode= FocusNode();
  QuerySnapshot searchResultSnapshot;
  bool isLoading = true;
  bool hasUserSearched = false;
  String _userName = '';
  User _user;
  String searchedName="";

  @override
  void initState() {
    super.initState();
    focusNode.requestFocus();
    _getCurrentUserNameAndUid();
    DatabaseService().getAllGroups().then((snapshot) {
      searchResultSnapshot = snapshot;
      //print("$searchResultSnapshot");
      setState(() {
        isLoading = false;
        hasUserSearched = true;
      });
    });

  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  _getCurrentUserNameAndUid() async {
    await HelperFunctions.getUserNameSharedPreference().then((value) {
      _userName = value;
    });
    _user = FirebaseAuth.instance.currentUser;
  }

  void _showScaffold(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.black,
      duration: Duration(milliseconds: 1500),
      content: Text(message, textAlign: TextAlign.center, style: TextStyle(fontSize: 13.0, color: MateColors.activeIcons)),
    ));
  }


  @override
  Widget build(BuildContext context) {
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
        key: _scaffoldKey,
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
    );
  }

  Widget groupList() {
    return hasUserSearched
        ? ListView.builder(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        shrinkWrap: true,
        itemCount: searchResultSnapshot.docs.length,
        itemBuilder: (context, index) {

          return searchedName!="" && searchResultSnapshot.docs[index]["groupName"].toString().toLowerCase().contains(searchedName.toLowerCase())?
          Visibility(
            visible: /*?*/ searchResultSnapshot.docs[index]["isPrivate"] != null
                ? searchResultSnapshot.docs[index]["isPrivate"] == true
                ? searchResultSnapshot.docs[index]["members"].contains(_user.uid + '_' + _user.displayName)
                : true
                : true /*: false*/,
            child: groupTile(
                Provider.of<AuthUserProvider>(context, listen: false).authUser.displayName,
                searchResultSnapshot.docs[index]["groupId"],
                searchResultSnapshot.docs[index]["groupName"].toString(),
                searchResultSnapshot.docs[index]["admin"],
                searchResultSnapshot.docs[index]["members"].length,
                searchResultSnapshot.docs[index]["maxParticipantNumber"],
                searchResultSnapshot.docs[index]["isPrivate"],
                searchResultSnapshot.docs[index]["members"].contains(_user.uid + '_' + _user.displayName),
                searchResultSnapshot.docs[index]["groupIcon"],
                searchResultSnapshot.docs[index]["members"],
            ),
          ):SizedBox();
        })
        : Container();
  }

  // onTap: (){
  // if(searchResultSnapshot.docs[index].data()["members"].contains(_user.uid + '_' + _user.displayName)){
  // }else if(searchResultSnapshot.docs[index].data()["maxParticipantNumber"] != null ? searchResultSnapshot.docs[index].data()["members"].length < searchResultSnapshot.docs[index].data()["maxParticipantNumber"] : true){
  // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>GroupDetailsBeforeJoiningPage(groupId: searchResultSnapshot.docs[index].data()["groupId"])));
  // }
  // },

  Widget groupTile(String userName, String groupId, String groupName, String admin, int totalParticipant, int maxParticipant, bool isPrivate, bool _isJoined, String imageURL,List<dynamic> members)
  {
    // _joinValueInGroup(userName, groupId, groupName, admin);
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      leading: imageURL!=""?
      CircleAvatar(
        radius: 24,
        backgroundColor: MateColors.activeIcons,
        backgroundImage: NetworkImage(imageURL),
      ):CircleAvatar(
        radius: 24,
        backgroundColor: MateColors.activeIcons,
        child: Text(groupName.toLowerCase().substring(0, 1).toUpperCase(), textAlign: TextAlign.center,
            style: TextStyle(color: themeController.isDarkMode?Colors.black:Colors.white, fontSize: 12.5.sp, fontWeight: FontWeight.bold),
      ),
      ),
      title: Text(
         groupName,
        style: TextStyle(fontFamily: "Poppins",fontSize: 15.0, fontWeight: FontWeight.w500, color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
               admin,
              style: TextStyle(fontFamily: "Poppins",fontSize: 14.0, fontWeight: FontWeight.w400, color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor),
              overflow: TextOverflow.clip,
            ),
            Text(
              "${totalParticipant} people",
              style: TextStyle(fontFamily: "Poppins",fontSize: 14.0, fontWeight: FontWeight.w400, color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor),
              overflow: TextOverflow.clip,
            ),
          ],
        ),
      ),
      trailing: InkWell(
        onTap: () async {
          if(_isJoined){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatPage(
              groupId: groupId,
              userName: userName,
              groupName: groupName,
              totalParticipant: totalParticipant.toString(),
              photoURL: imageURL,
              memberList: members,
            )));
          }
          //else if (maxParticipant != null ? totalParticipant < maxParticipant : true)
          else{
            await DatabaseService(uid: _user.uid).togglingGroupJoin(groupId, groupName, userName);
            // await DatabaseService(uid: _user.uid).userJoinGroup(groupId, groupName, userName);
            _showScaffold('Successfully joined the group "$groupName"');
            Future.delayed(Duration(milliseconds: 100), () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatPage(
                groupId: groupId,
                userName: userName,
                groupName: groupName,
                totalParticipant: totalParticipant.toString(),
                photoURL: imageURL,
                memberList: members,
              )));
            });
          }
        },
        child: _isJoined ?
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), border: Border.all(color: MateColors.activeIcons, width: 0.6)),
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Text('Message', style: TextStyle(color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor, fontWeight: FontWeight.w500,fontSize: 12)),
        ) :
        Visibility(
          // maxParticipant != null ? totalParticipant < maxParticipant : true,
          visible: true,
          replacement: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), border: Border.all(color: Colors.transparent, width: 0.6)),
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text('Group Full', style: TextStyle(fontFamily: "Poppins",color: Colors.red, fontWeight: FontWeight.w500))),
          child: Image.asset("lib/asset/homePageIcons/addIcon@3x.png",height: 18,width: 18,color: MateColors.activeIcons,),
          // Container(
          //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), border: Border.all(color: MateColors.activeIcons, width: 0.6)),
          //   padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 8.0),
          //   child: Text('Join', style: TextStyle(color: MateColors.activeIcons, fontWeight: FontWeight.w500)),
          // ),
        ),
      ),
    );
  }

}
