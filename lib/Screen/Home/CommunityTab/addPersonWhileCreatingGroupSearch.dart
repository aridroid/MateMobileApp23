import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../asset/Colors/MateColors.dart';
import '../../../audioAndVideoCalling/addParticipantsScreen.dart';
import '../../../constant.dart';
import '../../../controller/addUserController.dart';
import '../../../controller/theme_controller.dart';
import '../../../groupChat/services/database_service.dart';

class AddPersonWhileCreatingGroupSearch extends StatefulWidget {
  const AddPersonWhileCreatingGroupSearch({Key? key}) : super(key: key);

  @override
  State<AddPersonWhileCreatingGroupSearch> createState() => _AddPersonWhileCreatingGroupSearchState();
}

class _AddPersonWhileCreatingGroupSearchState extends State<AddPersonWhileCreatingGroupSearch> {
  ThemeController themeController = Get.find<ThemeController>();
  final AddUserController _addUserController = Get.find<AddUserController>();
  late QuerySnapshot searchResultSnapshot;
  bool isLoading = true;
  User _user = FirebaseAuth.instance.currentUser!;
  List<UserListModel> personList = [];
  String searchedName="";
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    focusNode.requestFocus();
    getData();
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  getData()async{
    DatabaseService().getAllUserData(_user.uid).then((snapshot){
      searchResultSnapshot = snapshot;
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
        }
      }
      personList.sort((a, b) {
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
              child:  isLoading?
              Center(
                child: CircularProgressIndicator(
                  color: MateColors.activeIcons,
                ),
              ):
              ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                padding: EdgeInsets.only(),
                physics: ScrollPhysics(),
                children: [
                  SizedBox(height: 25,),
                  ListView.builder(
                    padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: personList.length,
                      itemBuilder: (context, index) {
                        return FutureBuilder<DocumentSnapshot>(
                            future: DatabaseService().getUsersDetails(personList[index].uid!),
                            builder: (context, snapshot1) {
                              if(snapshot1.hasData){
                                return Visibility(
                                  visible: searchedName!="" && snapshot1.data!.get('displayName').toString().toLowerCase().contains(searchedName.toLowerCase()),
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 35),
                                    child: InkWell(
                                      onTap: (){
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
                                        print(_addUserController.addConnectionUid);
                                        print(_addUserController.addConnectionDisplayName);
                                      },
                                      child: ListTile(
                                        leading: snapshot1.data!.get('photoURL')!=null?
                                        CircleAvatar(
                                          radius: 30,
                                          backgroundColor: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                                          backgroundImage: NetworkImage(
                                            snapshot1.data!.get('photoURL'),
                                          ),
                                        ):
                                        CircleAvatar(
                                          radius: 30,
                                          backgroundColor: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                                          child: Text(snapshot1.data!.get('displayName').substring(0,1),style: TextStyle(color: themeController.isDarkMode?Colors.black:Colors.white),),
                                        ),
                                        title: Text(snapshot1.data!.get('displayName'),
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.w600,
                                            color: themeController.isDarkMode?Colors.white: MateColors.blackTextColor,
                                          ),
                                        ),
                                        trailing: _addUserController.selected.contains(index)?
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
                                  ),
                                );
                              }
                              return SizedBox();
                            }
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
