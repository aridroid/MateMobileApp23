import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../Providers/AuthUserProvider.dart';
import '../../asset/Colors/MateColors.dart';
import '../../constant.dart';
import '../../controller/theme_controller.dart';
import '../../groupChat/services/database_service.dart';
import '../Profile/ProfileScreen.dart';
import '../Profile/UserProfileScreen.dart';


class ConnectionSearch extends StatefulWidget {
  const ConnectionSearch({Key? key}) : super(key: key);

  @override
  _ConnectionSearchState createState() => _ConnectionSearchState();
}

class _ConnectionSearchState extends State<ConnectionSearch> {
  ThemeController themeController = Get.find<ThemeController>();
  FocusNode focusNode = FocusNode();
  String searchedName="";
  bool isLoading = true;

  @override
  void initState() {
    focusNode.requestFocus();
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
                child: ListView(
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  children: [
                    SizedBox(height: 25,),
                    ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: connectionGlobalList.length,
                        itemBuilder: (context, index) {
                          return FutureBuilder<DocumentSnapshot>(
                              future: DatabaseService().getUsersDetails(connectionGlobalList[index].uid!),
                              builder: (context, snapshot1) {
                                if(snapshot1.hasData){
                                  return Visibility(
                                    visible: searchedName!="" && snapshot1.data!.get('displayName').toString().toLowerCase().contains(searchedName.toLowerCase()),
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 35),
                                      child: InkWell(
                                        onTap: (){
                                          if(snapshot1.data!.get('uuid')!=null){
                                            if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == snapshot1.data!.get('uuid')) {
                                              Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                                            } else {
                                              Navigator.of(context).pushNamed(UserProfileScreen.routeName,
                                                  arguments: {"id": snapshot1.data!.get('uuid'),
                                                    "name": snapshot1.data!.get('displayName'),
                                                    "photoUrl": snapshot1.data!.get('photoURL'),
                                                    "firebaseUid": snapshot1.data!.get('uid')
                                                  });
                                            }
                                          }
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
      ),
    );
  }
}
