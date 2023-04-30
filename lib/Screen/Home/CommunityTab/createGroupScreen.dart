import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mate_app/Screen/Home/CommunityTab/addPersonWhileCreatingGroupSearch.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Providers/AuthUserProvider.dart';
import '../../../Services/community_tab_services.dart';
import '../../../Widget/loader.dart';
import '../../../asset/Colors/MateColors.dart';
import '../../../controller/addUserController.dart';
import '../../../controller/theme_controller.dart';
import '../../../groupChat/services/database_service.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({Key key}) : super(key: key);

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  ThemeController themeController = Get.find<ThemeController>();
  final AddUserController _addUserController = Get.find<AddUserController>();
  String _groupName;
  bool isPrivate = false;
  List<String> category;
  String categoryValue = "";
  List<String> type = ["Campus","Class"];// Campus = School
  String typeValue = "";
  CommunityTabService _communityTabService = CommunityTabService();
  String token = "";
  int universityId = 0;
  String university;
  String displayName;
  User _user;
  bool isLoading = false;

  @override
  void initState() {
    getStoredValue();
    super.initState();
  }

  getStoredValue()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token");
    _user = FirebaseAuth.instance.currentUser;
    universityId = Provider.of<AuthUserProvider>(context, listen: false).authUser.universityId??0;
    university = Provider.of<AuthUserProvider>(context, listen: false).authUser.university??"";
    displayName = Provider.of<AuthUserProvider>(context, listen: false).authUser.displayName;
    if(universityId==0 || universityId==1){
      category = ["All"];
    }else if(universityId==2){
      category = [university,"All"];
    }else if(universityId==3){
      category = ["UC Berkeley","All"];
    }else{
      category = [university,"All"];
    }
    categoryValue = category[0];
    typeValue = type[0];
    print(category);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final scH = MediaQuery.of(context).size.height;
    final scW = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Scaffold(
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
            child: SingleChildScrollView(
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
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              color: Color(0xFF007AFE),
                              fontWeight: FontWeight.w500,
                              fontSize: 17.0,
                            ),
                          ),
                        ),
                        Text(
                          "New Group",
                          style: TextStyle(
                            color: themeController.isDarkMode ? Colors.white : MateColors.blackTextColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 17.0,
                          ),
                        ),
                        _addUserController.addConnectionUid.isNotEmpty?
                        GestureDetector(
                          onTap: ()async{
                            if (_groupName != null && _groupName.isNotEmpty && categoryValue!="" && typeValue!="") {
                              setState(() {
                                isLoading = true;
                              });
                              DatabaseService(uid: _user.uid).createGroup(displayName, _user.uid, _groupName, 2000, isPrivate).then((value) async{
                                _communityTabService.createGroup(
                                  token: token,
                                  category: universityId==2?"Stanford":categoryValue,
                                  type: typeValue=="Campus"?"School":typeValue,
                                  groupId: value,
                                );
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
                                if(imageFile!=null){
                                  await _uploadFile(value);
                                }
                                ///For current user
                                CommunityTabService().joinGroup(token: token,groupId: value,uid: FirebaseAuth.instance.currentUser.uid);
                                setState(() {
                                  isLoading = false;
                                });
                                Get.back();
                                Get.back();
                              });
                            } else {
                              Fluttertoast.showToast(msg: " Please fill all fields ", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
                            }
                          },
                          child: Text(
                            "Create",
                            style: TextStyle(
                              color: Color(0xFF007AFE),
                              fontWeight: FontWeight.w500,
                              fontSize: 17.0,
                            ),
                          ),
                        ):SizedBox(width: 35,),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: ()async{
                      await Get.to(AddPersonWhileCreatingGroupSearch());
                      setState(() {});
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 16,right: 16,top: 16),
                      height: 60,
                      decoration: BoxDecoration(
                        color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.only(left: 16, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Search people",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              color: themeController.isDarkMode?MateColors.helpingTextDark:Colors.black.withOpacity(0.72),
                            ),
                          ),
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: themeController.isDarkMode?MateColors.textFieldSearchDark:MateColors.textFieldSearchLight,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Image.asset(
                                "lib/asset/iconsNewDesign/search.png",
                                color: themeController.isDarkMode?Colors.white:MateColors.blackText,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16,right: 16,top: 20,bottom: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: themeController.isDarkMode?Colors.white.withOpacity(0.12):Colors.white.withOpacity(0.5),
                              ),
                              child: imageFile!=null?
                              Center(
                                child: CircleAvatar(
                                  radius: 60,
                                  backgroundImage: FileImage(File(imageFile.path)),
                                ),
                              ):
                              Image.asset(
                                "lib/asset/iconsNewDesign/camera.png",
                                color: themeController.isDarkMode?Color(0xFF8BDBE9):Color(0xFF8A8A99),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: GestureDetector(
                                onTap: ()=>modalSheetForProfilePic(),
                                child: Container(
                                  height: 27,
                                  width: 26,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                                  ),
                                  child: Icon(Icons.add,
                                    color: Colors.black,
                                    size: 17,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 20,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 50,
                              width: 250,
                              margin: EdgeInsets.only(top: 10),
                              child: TextFormField(
                                cursorColor: themeController.isDarkMode?MateColors.helpingTextDark:MateColors.helpingTextLight,
                                style:  TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.1,
                                  color: themeController.isDarkMode?Colors.white:Colors.black,
                                ),
                                onChanged: (val) {
                                  _groupName = val;
                                },
                                decoration: InputDecoration(
                                  hintStyle: TextStyle(
                                    fontSize: 17,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                    color: themeController.isDarkMode?Color(0xFFF6F6F6).withOpacity(0.5):Colors.black.withOpacity(0.5),
                                  ),
                                  hintText: "Group Subject",
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: themeController.isDarkMode?Color(0xFFDDE8E8).withOpacity(0.1):Color(0xFFC8E1DF),),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: themeController.isDarkMode?Color(0xFFDDE8E8).withOpacity(0.1):Color(0xFFC8E1DF),),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 16,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: (){
                                    categoryValue = category[0];
                                    setState(() {});
                                  },
                                  child: Row(
                                    children: [
                                      category[0] == categoryValue?
                                      Image.asset(
                                        "lib/asset/iconsNewDesign/radioColor.png",
                                        color: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                                      ):
                                      Image.asset(
                                        "lib/asset/iconsNewDesign/radio.png",
                                        color: themeController.isDarkMode?Colors.white.withOpacity(0.2):Colors.black.withOpacity(0.28),
                                      ),
                                      SizedBox(width: 10,),
                                      Text(
                                        category[0].startsWith("California Polytechnic")?"UC Berkley":category[0],
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w400,
                                          color: themeController.isDarkMode?Color(0xFFF6F6F6).withOpacity(0.5):Colors.black.withOpacity(0.5),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 16,),
                                if(category.length>1)
                                GestureDetector(
                                  onTap: (){
                                    categoryValue = category[1];
                                    setState(() {});
                                  },
                                  child: Row(
                                    children: [
                                      category[1] == categoryValue?
                                      Image.asset(
                                        "lib/asset/iconsNewDesign/radioColor.png",
                                        color: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                                      ):
                                      Image.asset(
                                        "lib/asset/iconsNewDesign/radio.png",
                                        color: themeController.isDarkMode?Colors.white.withOpacity(0.2):Colors.black.withOpacity(0.28),
                                      ),
                                      SizedBox(width: 10,),
                                      Text(
                                        category[1].startsWith("California Polytechnic")?"UC Berkley":category[1],
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w400,
                                          color: themeController.isDarkMode?Color(0xFFF6F6F6).withOpacity(0.5):Colors.black.withOpacity(0.5),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: (){
                                    typeValue = type[0];
                                    setState(() {});
                                  },
                                  child: Row(
                                    children: [
                                      type[0] == typeValue?
                                      Image.asset(
                                        "lib/asset/iconsNewDesign/radioColor.png",
                                        color: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                                      ):
                                      Image.asset(
                                        "lib/asset/iconsNewDesign/radio.png",
                                        color: themeController.isDarkMode?Colors.white.withOpacity(0.2):Colors.black.withOpacity(0.28),
                                      ),
                                      SizedBox(width: 10,),
                                      Text(
                                        type[0],
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w400,
                                          color: themeController.isDarkMode?Color(0xFFF6F6F6).withOpacity(0.5):Colors.black.withOpacity(0.5),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 29,),
                                GestureDetector(
                                    onTap: (){
                                      typeValue = type[1];
                                      setState(() {});
                                    },
                                    child: Row(
                                      children: [
                                        type[1] == typeValue?
                                        Image.asset(
                                          "lib/asset/iconsNewDesign/radioColor.png",
                                          color: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                                        ):
                                        Image.asset(
                                          "lib/asset/iconsNewDesign/radio.png",
                                          color: themeController.isDarkMode?Colors.white.withOpacity(0.2):Colors.black.withOpacity(0.28),
                                        ),
                                        SizedBox(width: 10,),
                                        Text(
                                          type[1],
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.w400,
                                            color: themeController.isDarkMode?Color(0xFFF6F6F6).withOpacity(0.5):Colors.black.withOpacity(0.5),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                SizedBox(height: 16,),
                              ],
                            ),
                            SizedBox(height: 16,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: (){
                                    isPrivate = false;
                                    setState(() {});
                                  },
                                  child: Row(
                                    children: [
                                      isPrivate == false?
                                      Image.asset(
                                        "lib/asset/iconsNewDesign/radioColor.png",
                                        color: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                                      ):
                                      Image.asset(
                                        "lib/asset/iconsNewDesign/radio.png",
                                        color: themeController.isDarkMode?Colors.white.withOpacity(0.2):Colors.black.withOpacity(0.28),
                                      ),
                                      SizedBox(width: 10,),
                                      Text(
                                        "Public",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w400,
                                          color: themeController.isDarkMode?Color(0xFFF6F6F6).withOpacity(0.5):Colors.black.withOpacity(0.5),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 48,),
                                GestureDetector(
                                  onTap: (){
                                    isPrivate = true;
                                    setState(() {});
                                  },
                                  child: Row(
                                    children: [
                                      isPrivate?
                                      Image.asset(
                                        "lib/asset/iconsNewDesign/radioColor.png",
                                        color: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                                      ):
                                      Image.asset(
                                        "lib/asset/iconsNewDesign/radio.png",
                                        color: themeController.isDarkMode?Colors.white.withOpacity(0.2):Colors.black.withOpacity(0.28),
                                      ),
                                      SizedBox(width: 10,),
                                      Text(
                                        "Private",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w400,
                                          color: themeController.isDarkMode?Color(0xFFF6F6F6).withOpacity(0.5):Colors.black.withOpacity(0.5),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 16,),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Text('PARTICIPANTS: ',
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w600,
                            color: themeController.isDarkMode?Colors.white.withOpacity(0.5):Colors.black.withOpacity(0.5),
                          ),
                        ),
                        Text('${_addUserController.selected.length} OF ${_addUserController.personList.length}',
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w600,
                            color: themeController.isDarkMode?Colors.white:Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 1,
                    color: themeController.isDarkMode?MateColors.dividerDark:MateColors.dividerLight,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10,left: 6,right: 16),
                    height: _addUserController.selected.isNotEmpty?100:0,
                    width: scW,
                    child: ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        itemCount: _addUserController.personList.length,
                        itemBuilder: (context, index) {
                          return Visibility(
                            visible: _addUserController.selected.contains(index),
                            child: InkWell(
                              onTap: ()async{
                                setState(() {
                                  if(_addUserController.selected.contains(index)){
                                    _addUserController.selected.remove(index);
                                  }else{
                                    _addUserController.selected.add(index);
                                  }
                                });
                                if(_addUserController.addConnectionUid.contains(_addUserController.personList[index].uid)){
                                  _addUserController.addConnectionUid.remove(_addUserController.personList[index].uid);
                                }else{
                                  _addUserController.addConnectionUid.add(_addUserController.personList[index].uid);
                                }
                                if(_addUserController.addConnectionDisplayName.contains(_addUserController.personList[index].displayName)){
                                  _addUserController.addConnectionDisplayName.remove(_addUserController.personList[index].displayName);
                                }else{
                                  _addUserController.addConnectionDisplayName.add(_addUserController.personList[index].displayName);
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Stack(
                                  children: [
                                    _addUserController.personList[index].photoURL!=null?
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundColor: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                                      backgroundImage: NetworkImage(
                                        _addUserController.personList[index].photoURL,
                                      ),
                                    ):
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundColor: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                                      child: Text(_addUserController.personList[index].displayName.substring(0,1),
                                        style: TextStyle(color: themeController.isDarkMode?Colors.black:Colors.white),),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      left: 0,
                                      child: Text(_addUserController.personList[index].displayName,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w400,
                                          color: themeController.isDarkMode?Colors.white: MateColors.blackTextColor,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      child: Container(
                                        height: 24,
                                        width: 24,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: themeController.isDarkMode?Color(0xFF6A6A6A):Colors.white.withOpacity(0.5),
                                        ),
                                        child: Icon(Icons.clear,
                                          color: themeController.isDarkMode?Colors.white:Colors.black,
                                          size: 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
          ),
        ),
        Visibility(
          visible: isLoading,
          child: Loader(),
        ),
      ],
    );
  }

  modalSheetForProfilePic() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: themeController.isDarkMode?MateColors.bottomSheetBackgroundDark:MateColors.bottomSheetBackgroundLight,
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
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                        letterSpacing: 0.1,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () =>  _getProfileImage(2),
                        child: Column(
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                color: themeController.isDarkMode?MateColors.bottomSheetItemBackgroundDark:MateColors.bottomSheetItemBackgroundLight,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Image.asset(
                                  "lib/asset/icons/cameraNew.png",
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Camera",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Poppins',
                                letterSpacing: 0.1,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () =>  _getProfileImage(1),
                        child: Column(
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                color: themeController.isDarkMode?MateColors.bottomSheetItemBackgroundDark:MateColors.bottomSheetItemBackgroundLight,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Image.asset(
                                  "lib/asset/icons/galleryNew.png",
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Gallery",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Poppins',
                                letterSpacing: 0.1,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  final picker = ImagePicker();
  File imageFile;
  String imageUrl;
  Future _getProfileImage(int option) async {
    PickedFile pickImage;
    if (option == 1) {
      pickImage = await picker.getImage(source: ImageSource.gallery, imageQuality: 50);
    } else{
      pickImage = await picker.getImage(source: ImageSource.camera, imageQuality: 50);
    }
    if (pickImage != null) {
      setState(() {
        imageFile = File(pickImage.path);
      });
    } else {
      print('No image selected.');
    }
    Navigator.of(context).pop();
  }

  Future _uploadFile(String groupId) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    File compressedFile = await FlutterNativeImage.compressImage(imageFile.path, quality: 60, percentage: 60);
    UploadTask uploadTask = reference.putFile(compressedFile);
    TaskSnapshot storageTaskSnapshot = await uploadTask.whenComplete((){});
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      imageUrl = downloadUrl;
      DatabaseService().updateGroupIcon(groupId, imageUrl);
    },
    );
  }

}
