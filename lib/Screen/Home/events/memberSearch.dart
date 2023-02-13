import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../Model/eventListingModel.dart';
import '../../../Providers/AuthUserProvider.dart';
import '../../../asset/Colors/MateColors.dart';
import '../../../controller/theme_controller.dart';
import '../../../groupChat/services/database_service.dart';
import '../../Profile/ProfileScreen.dart';
import '../../Profile/UserProfileScreen.dart';

class MemberSearch extends StatefulWidget {
  final List<GoingList> list;
  const MemberSearch({Key key, this.list}) : super(key: key);

  @override
  _MemberSearchState createState() => _MemberSearchState();
}

class _MemberSearchState extends State<MemberSearch> {
  ThemeController themeController = Get.find<ThemeController>();
  String searchedName = "";

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
        body: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          shrinkWrap: true,
          physics: ScrollPhysics(),
          padding: EdgeInsets.only(left: 6,top: 16,bottom: 16),
          children: [
            ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: widget.list.length,
                itemBuilder: (context, index) {
                  return FutureBuilder(
                      future: DatabaseService().getUsersDetails(widget.list[index].firebaseUid),
                      builder: (context, snapshot1) {
                        if(snapshot1.hasData){
                          return Visibility(
                            visible: searchedName==""?true:searchedName!="" && snapshot1.data.data()['displayName'].toString().toLowerCase().contains(searchedName.toLowerCase()),
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
                              child: ListTile(
                                leading:  snapshot1.data.data()['photoURL']!=null?
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
                                  child: Text(snapshot1.data.data()['displayName'].substring(0,1),style: TextStyle(color: themeController.isDarkMode?Colors.black:Colors.white),),
                                ),
                                title: Text(
                                  snapshot1.data.data()['displayName'],
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.1,
                                    color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                                  ),
                                ),
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
          ],
        ),
      ),
    );
  }
}
