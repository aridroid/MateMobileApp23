import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mate_app/Screen/Home/CommunityTab/addPersonWhileCreatingGroupSearch.dart';
import 'package:mate_app/audioAndVideoCalling/addParticipantsScreen.dart';

import '../../../asset/Colors/MateColors.dart';
import '../../../controller/addUserController.dart';
import '../../../controller/theme_controller.dart';
import '../../../groupChat/services/database_service.dart';
import 'createGroupScreen.dart';

class AddPersonWhileCreatingGroup extends StatefulWidget {
  const AddPersonWhileCreatingGroup({Key? key}) : super(key: key);

  @override
  State<AddPersonWhileCreatingGroup> createState() => _AddPersonWhileCreatingGroupState();
}

class _AddPersonWhileCreatingGroupState extends State<AddPersonWhileCreatingGroup> {
  ThemeController themeController = Get.find<ThemeController>();
  final AddUserController _addUserController = Get.find<AddUserController>();
  late QuerySnapshot searchResultSnapshot;
  bool isLoading = true;
  User _user = FirebaseAuth.instance.currentUser!;
  List<UserListModel> personList = [];

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData()async{
    DatabaseService().getAllUserData(_user.uid).then((snapshot){
      searchResultSnapshot = snapshot;
      _addUserController.personList.clear();
      _addUserController.selected.clear();
      _addUserController.addConnectionUid.clear();
      _addUserController.addConnectionDisplayName.clear();
      for(int i=0;i<searchResultSnapshot.docs.length;i++){
        if(searchResultSnapshot.docs[i]["displayName"]!=null && searchResultSnapshot.docs[i]["displayName"]!="")
        {
          personList.add(
              UserListModel(
                uuid: searchResultSnapshot.docs[i]["uuid"],
                uid: searchResultSnapshot.docs[i]["uid"],
                displayName: searchResultSnapshot.docs[i]["displayName"],
                photoURL: searchResultSnapshot.docs[i]["photoURL"],
                email: searchResultSnapshot.docs[i]["email"],
              )
          );
          _addUserController.personList.add(
              UserListModel(
                uuid: searchResultSnapshot.docs[i]["uuid"],
                uid: searchResultSnapshot.docs[i]["uid"],
                displayName: searchResultSnapshot.docs[i]["displayName"],
                photoURL: searchResultSnapshot.docs[i]["photoURL"],
                email: searchResultSnapshot.docs[i]["email"],
              )
          );
        }
      }
      personList.sort((a, b) {
        return a.displayName!.toLowerCase().compareTo(b.displayName!.toLowerCase());
      });
      _addUserController.personList.sort((a, b) {
        return a.displayName!.toLowerCase().compareTo(b.displayName!.toLowerCase());
      });
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final scH = MediaQuery.of(context).size.height;
    final scW = MediaQuery.of(context).size.width;
    return Scaffold(
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
                      await Get.to(CreateGroupScreen());
                      setState(() {});
                    },
                    child: Text(
                      "Next",
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
            isLoading?
            SizedBox():
            Container(
              margin: EdgeInsets.only(top: 20,left: 6,right: 16),
              height: _addUserController.selected.isNotEmpty?100:0,
              width: scW,
              child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  itemCount: personList.length,
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
                          if(_addUserController.addConnectionUid.contains(personList[index].uid)){
                            _addUserController.addConnectionUid.remove(personList[index].uid);
                          }else{
                            _addUserController.addConnectionUid.add(personList[index].uid!);
                          }
                          if(_addUserController.addConnectionDisplayName.contains(personList[index].displayName)){
                            _addUserController.addConnectionDisplayName.remove(personList[index].displayName);
                          }else{
                            _addUserController.addConnectionDisplayName.add(personList[index].displayName!);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Stack(
                            children: [
                              personList[index].photoURL!=null?
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                                backgroundImage: NetworkImage(
                                  personList[index].photoURL!,
                                ),
                              ):
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                                child: Text(personList[index].displayName!.substring(0,1),
                                  style: TextStyle(color: themeController.isDarkMode?Colors.black:Colors.white),),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                left: 0,
                                child: Text(personList[index].displayName!,
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
            Expanded(
              child: isLoading?
              Center(
                child: CircularProgressIndicator(
                  color: MateColors.activeIcons,
                ),
              ):
              ListView(
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.only(top: 0),
                shrinkWrap: true,
                physics: ScrollPhysics(),
                children: [
                  SizedBox(height: 25,),
                  ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.vertical,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: personList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 35),
                          child: InkWell(
                            onTap: ()async{
                              setState(() {
                                if(_addUserController.selected.contains(index)){
                                  _addUserController.selected.remove(index);
                                }else{
                                  _addUserController.selected.add(index);
                                }
                              });
                              if(_addUserController.addConnectionUid.contains(personList[index].uid)){
                                _addUserController.addConnectionUid.remove(personList[index].uid);
                              }else{
                                _addUserController.addConnectionUid.add(personList[index].uid!);
                              }
                              if(_addUserController.addConnectionDisplayName.contains(personList[index].displayName)){
                                _addUserController.addConnectionDisplayName.remove(personList[index].displayName);
                              }else{
                                _addUserController.addConnectionDisplayName.add(personList[index].displayName!);
                              }
                            },
                            child: ListTile(
                              leading: personList[index].photoURL!=null?
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                                backgroundImage: NetworkImage(
                                  personList[index].photoURL!,
                                ),
                              ):
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                                child: Text(personList[index].displayName!.substring(0,1),
                                  style: TextStyle(color: themeController.isDarkMode?Colors.black:Colors.white),),
                              ),
                              title: Text(personList[index].displayName!,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                  color: themeController.isDarkMode?Colors.white: MateColors.blackTextColor,
                                ),
                              ),
                              trailing:
                              _addUserController.selected.contains(index)?
                              Image.asset(
                                "lib/asset/iconsNewDesign/radioColor.png",
                                color: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                              ):
                              Image.asset(
                                "lib/asset/iconsNewDesign/radio.png",
                                color: themeController.isDarkMode?Colors.white.withOpacity(0.2):Colors.black.withOpacity(0.28),
                              ),
                            ),
                          ),
                        );
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
