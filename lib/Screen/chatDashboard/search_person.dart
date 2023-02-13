import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mate_app/controller/theme_controller.dart';

import '../../asset/Colors/MateColors.dart';
import '../../groupChat/services/database_service.dart';
import '../chat1/screens/chat.dart';

class SearchPerson extends StatefulWidget {
  const
  SearchPerson({Key key}) : super(key: key);

  @override
  _SearchPersonState createState() => _SearchPersonState();
}

class _SearchPersonState extends State<SearchPerson> {
  TextEditingController searchEditingController = new TextEditingController();
  FocusNode focusNode = FocusNode();
  QuerySnapshot searchResultSnapshot;
  bool isLoading = true;
  bool hasUserSearched = false;
  User _user = FirebaseAuth.instance.currentUser;
  String searchedName="";
  ThemeController themeController = Get.find<ThemeController>();

  @override
  void initState() {
    focusNode.requestFocus();
    DatabaseService().getAllUserData(_user.uid).then((snapshot){
      searchResultSnapshot = snapshot;
      setState(() {
        isLoading = false;
        hasUserSearched = true;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
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
    return hasUserSearched ?
    ListView.builder(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        shrinkWrap: true,
        itemCount: searchResultSnapshot.docs.length,
        itemBuilder: (context, index) {
          return Visibility(
            visible: searchedName!="" && searchResultSnapshot.docs[index]["displayName"].toString().toLowerCase().contains(searchedName.toLowerCase()),
            child: groupTile(
              searchResultSnapshot.docs[index]["uuid"],
              searchResultSnapshot.docs[index]["uid"],
              searchResultSnapshot.docs[index]["displayName"],
              searchResultSnapshot.docs[index]["photoURL"],
              searchResultSnapshot.docs[index]["email"],
            ),
          );
        }) :
    Container();
  }

  Widget groupTile(String peerUuid,String peerId, String peerName, String peerAvatar,String email) {
    return InkWell(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
            Chat(
              peerUuid: peerUuid,
              currentUserId: _user.uid, //
              peerId: peerId,
              peerName: peerName,
              peerAvatar: peerAvatar,
            )
        ));
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
          child: Text("Tap on chat to send message",
            style: TextStyle(letterSpacing: 0.1,fontFamily: "Poppins",fontSize: 14.0, fontWeight: FontWeight.w400, color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        // trailing: InkWell(
        //   onTap: (){
        //
        //   },
        //   child: Container(
        //     decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), border: Border.all(color: MateColors.activeIcons, width: 0.6)),
        //     padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 8.0),
        //     child: Text('Chat', style: TextStyle(color: MateColors.activeIcons, fontWeight: FontWeight.w500)),
        //   ),
        // ),
      ),
    );
  }

}
