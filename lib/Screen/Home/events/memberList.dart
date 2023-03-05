import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mate_app/Model/eventListingModel.dart';
import 'package:mate_app/controller/theme_controller.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Providers/AuthUserProvider.dart';
import '../../../Services/connection_service.dart';
import '../../../asset/Colors/MateColors.dart';
import '../../../constant.dart';
import '../../../groupChat/services/database_service.dart';
import '../../Profile/ProfileScreen.dart';
import '../../Profile/UserProfileScreen.dart';

class MemberList extends StatefulWidget {
  final List<GoingList> list;
  const MemberList({Key key, this.list}) : super(key: key);

  @override
  _MemberListState createState() => _MemberListState();
}

class _MemberListState extends State<MemberList> {
  ThemeController themeController = Get.find<ThemeController>();
  String token;
  PageController _pageController;
  int _selectedIndex = 0;

  @override
  void initState() {
    _pageController = PageController(initialPage: _selectedIndex);
    getStoredValue();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  getStoredValue()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token");
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
                    child: Icon(Icons.arrow_back_ios,
                      size: 20,
                      color: themeController.isDarkMode ? Colors.white : MateColors.blackTextColor,
                    ),
                  ),
                  Text(
                    "Going or Interested",
                    style: TextStyle(
                      color: themeController.isDarkMode ? Colors.white : MateColors.blackTextColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 17.0,
                    ),
                  ),
                  SizedBox(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16,right: 16,top: 20,bottom: 5),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: themeController.isDarkMode?Colors.white.withOpacity(0.12):Colors.white.withOpacity(0.2),
                ),
                padding: EdgeInsets.symmetric(horizontal: 7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _pageController.animateToPage(0, duration: Duration(milliseconds: 500), curve: Curves.ease);
                      },
                      child: Container(
                        height: 36,
                        width: MediaQuery.of(context).size.width*0.42,
                        decoration: BoxDecoration(
                          color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                          borderRadius: BorderRadius.circular(9),
                        ),
                        alignment: Alignment.center,
                        child: Text('Going',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w500,
                            overflow: TextOverflow.ellipsis,
                            color: _selectedIndex==0?
                            themeController.isDarkMode?Colors.white:Colors.black :
                            themeController.isDarkMode?Colors.white.withOpacity(0.5):Colors.black.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _pageController.animateToPage(1, duration: Duration(milliseconds: 500), curve: Curves.ease);
                      },
                      child: Container(
                        height: 36,
                        width: MediaQuery.of(context).size.width*0.42,
                        decoration: BoxDecoration(
                          color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                          borderRadius: BorderRadius.circular(9),
                        ),
                        alignment: Alignment.center,
                        child: Text('Interested',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w500,
                            overflow: TextOverflow.ellipsis,
                            color: _selectedIndex==1?
                            themeController.isDarkMode?Colors.white:Colors.black :
                            themeController.isDarkMode?Colors.white.withOpacity(0.5):Colors.black.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (val){
                  setState(() {
                    _selectedIndex = val;
                  });
                },
                children: [
                  ListView(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    padding: EdgeInsets.only(left: 6,top: 16,bottom: 16),
                    children: [
                      ListView.separated(
                        padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount: widget.list.length,
                          itemBuilder: (context, index) {
                            print(widget.list[index].firebaseUid);
                            return FutureBuilder(
                                future: DatabaseService().getUsersDetails(widget.list[index].firebaseUid),
                                builder: (context, snapshot1) {
                                  if(snapshot1.hasData){
                                    return InkWell(
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
                                          radius: 30,
                                          backgroundColor: MateColors.activeIcons,
                                          backgroundImage: NetworkImage(
                                            snapshot1.data.data()['photoURL'],
                                          ),
                                        ):
                                        CircleAvatar(
                                          radius: 30,
                                          backgroundColor: MateColors.activeIcons,
                                          child: Text(snapshot1.data.data()['displayName'].substring(0,1),style: TextStyle(color: themeController.isDarkMode?Colors.black:Colors.white),),
                                        ),
                                        title: Text(
                                          snapshot1.data.data()['displayName'],
                                          style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w600,
                                            color: themeController.isDarkMode?Colors.white:Colors.black,
                                          ),
                                        ),
                                        trailing: !connectionGlobalUidList.contains(snapshot1.data.data()['uid']) && Provider.of<AuthUserProvider>(context, listen: false).authUser.firebaseUid!=snapshot1.data.data()['uid']?
                                        InkWell(
                                          onTap: ()async{
                                            _showAddConnectionAlertDialog(uid: snapshot1.data.data()['uid'], name: snapshot1.data.data()['displayName'],uuid: snapshot1.data.data()['uuid']);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(right: 4,left: 4),
                                            child: Image.asset("lib/asset/icons/addPerson.png",height: 21,
                                              color: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                                            ),
                                          ),
                                        ):Offstage(),
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
                          },
                        separatorBuilder: (BuildContext context, int index) {
                          return  Padding(
                            padding: const EdgeInsets.only(left: 16,right: 16,top: 10,bottom: 10),
                            child: Divider(
                              thickness: 1,
                            color: themeController.isDarkMode?MateColors.dividerDark:MateColors.dividerLight,
                            ),
                          );
                        },),
                    ],
                  ),
                  ListView(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    padding: EdgeInsets.only(left: 6,top: 16,bottom: 16),
                    children: [
                      ListView.separated(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: widget.list.length,
                        itemBuilder: (context, index) {
                          print(widget.list[index].firebaseUid);
                          return FutureBuilder(
                              future: DatabaseService().getUsersDetails(widget.list[index].firebaseUid),
                              builder: (context, snapshot1) {
                                if(snapshot1.hasData){
                                  return InkWell(
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
                                        radius: 30,
                                        backgroundColor: MateColors.activeIcons,
                                        backgroundImage: NetworkImage(
                                          snapshot1.data.data()['photoURL'],
                                        ),
                                      ):
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundColor: MateColors.activeIcons,
                                        child: Text(snapshot1.data.data()['displayName'].substring(0,1),style: TextStyle(color: themeController.isDarkMode?Colors.black:Colors.white),),
                                      ),
                                      title: Text(
                                        snapshot1.data.data()['displayName'],
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w600,
                                          color: themeController.isDarkMode?Colors.white:Colors.black,
                                        ),
                                      ),
                                      trailing: !connectionGlobalUidList.contains(snapshot1.data.data()['uid']) && Provider.of<AuthUserProvider>(context, listen: false).authUser.firebaseUid!=snapshot1.data.data()['uid']?
                                      InkWell(
                                        onTap: ()async{
                                          _showAddConnectionAlertDialog(uid: snapshot1.data.data()['uid'], name: snapshot1.data.data()['displayName'],uuid: snapshot1.data.data()['uuid']);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(right: 4,left: 4),
                                          child: Image.asset("lib/asset/icons/addPerson.png",height: 21,
                                            color: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                                          ),
                                        ),
                                      ):Offstage(),
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
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return  Padding(
                            padding: const EdgeInsets.only(left: 16,right: 16,top: 10,bottom: 10),
                            child: Divider(
                              thickness: 1,
                              color: themeController.isDarkMode?MateColors.dividerDark:MateColors.dividerLight,
                            ),
                          );
                        },),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showAddConnectionAlertDialog({@required String uid, @required String name, @required String uuid})async{
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
                await ConnectionService().addConnection(uid: uid,name: name,uuid:uuid,token: token);
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
