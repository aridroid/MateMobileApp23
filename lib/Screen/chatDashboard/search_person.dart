import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mate_app/controller/theme_controller.dart';

import '../../asset/Colors/MateColors.dart';
import '../../constant.dart';
import '../../groupChat/services/database_service.dart';
import '../chat1/screens/chat.dart';

class SearchPerson extends StatefulWidget {
  const SearchPerson({Key key}) : super(key: key);

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
                child: isLoading ?
                Container(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: MateColors.activeIcons,
                    ),
                  ),
                ):
                groupList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget groupList() {
    return hasUserSearched ?
    ListView.builder(
      padding: EdgeInsets.only(top: 16),
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
          child: Text("Tap on chat to send message",
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
              color: themeController.isDarkMode?
              Colors.white.withOpacity(0.5):
              Colors.black.withOpacity(0.5),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

}
