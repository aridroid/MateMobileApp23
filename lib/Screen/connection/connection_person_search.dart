import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Services/connection_service.dart';
import '../../asset/Colors/MateColors.dart';
import '../../constant.dart';
import '../../controller/theme_controller.dart';
import '../../groupChat/services/database_service.dart';


class ConnectionPersonSearch extends StatefulWidget {
  const ConnectionPersonSearch({Key? key}) : super(key: key);

  @override
  _ConnectionPersonSearchState createState() => _ConnectionPersonSearchState();
}

class _ConnectionPersonSearchState extends State<ConnectionPersonSearch> {
  TextEditingController searchEditingController = new TextEditingController();
  FocusNode focusNode = FocusNode();
  late QuerySnapshot searchResultSnapshot;
  bool isLoading = true;
  bool hasUserSearched = false;
  User _user = FirebaseAuth.instance.currentUser!;
  String searchedName="";
  ThemeController themeController = Get.find<ThemeController>();
  late String token;

  @override
  void initState() {
    getStoredValue();
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

  getStoredValue()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("tokenApp")!;
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
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        shrinkWrap: true,
        itemCount: searchResultSnapshot.docs.length,
        padding: EdgeInsets.only(top: 5,bottom: 5),
        itemBuilder: (context, index) {
          return Visibility(
            visible: searchedName!="" && searchResultSnapshot.docs[index]["displayName"].toString().toLowerCase().contains(searchedName.toLowerCase()),
            child: Padding(
              padding: EdgeInsets.only(top: connectionGlobalUidList.contains(searchResultSnapshot.docs[index]["uid"])?0:16),
              child: groupTile(
                searchResultSnapshot.docs[index]["uuid"],
                searchResultSnapshot.docs[index]["uid"],
                searchResultSnapshot.docs[index]["displayName"],
                searchResultSnapshot.docs[index]["photoURL"],
                searchResultSnapshot.docs[index]["email"],
              ),
            ),
          );
        }) :
    Container();
  }

  Widget groupTile(String peerUuid,String peerId, String peerName, String peerAvatar,String email) {
    return connectionGlobalUidList.contains(peerId)?
      Offstage():
      ListTile(
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
      trailing: InkWell(
        onTap: ()async{
          if(requestGetUid.contains(peerId)){
            Get.back();
            Get.back();
          }else if(!requestSentUid.contains(peerId)){
            _showAddConnectionAlertDialog(uid: peerId, name: peerName,uuid: peerUuid);
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(right: 4),
          child: requestSentUid.contains(peerId)?
          Text("Sent",
            style: TextStyle(
              color: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
              fontWeight: FontWeight.w500,
              fontSize: 12,
              fontFamily: 'Poppins',
            ),
          ):
          requestGetUid.contains(peerId)?
          Text("Accept/Delete",
            style: TextStyle(
              color: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
              fontWeight: FontWeight.w500,
              fontSize: 12,
              fontFamily: 'Poppins',
            ),
          ):
          Image.asset(
            "lib/asset/iconsNewDesign/inviteMates.png",
            height: 21,
            color: themeController.isDarkMode?Colors.white:Colors.black,
          ),
        ),
      ),
    );
  }

  _showAddConnectionAlertDialog({required String uid, required String name,required String uuid})async{
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
                await ConnectionService().addConnection(uid: uid,name: name,uuid: uuid,token: token);
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
