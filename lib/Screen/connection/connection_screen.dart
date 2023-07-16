import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mate_app/Screen/connection/add_connection.dart';
import 'package:mate_app/Screen/connection/connectionSearch.dart';
import 'package:mate_app/Services/connection_service.dart';
import 'package:mate_app/constant.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Providers/AuthUserProvider.dart';
import '../../Widget/loader.dart';
import '../../asset/Colors/MateColors.dart';
import '../../controller/theme_controller.dart';
import '../../groupChat/services/database_service.dart';
import '../Profile/ProfileScreen.dart';
import '../Profile/UserProfileScreen.dart';

class ConnectionScreen extends StatefulWidget {
  static final String routeName = '/connectionScreen';

  @override
  _ConnectionScreenState createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends State<ConnectionScreen> with TickerProviderStateMixin{
  ThemeController themeController = Get.find<ThemeController>();
  String token = "";
  bool isLoading = false;
  late PageController _pageController;
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
    token = preferences.getString("tokenApp")!;
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
                        "Connections",
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
                  padding: EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Get.to(ConnectionSearch());
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 16),
                            height: 60,
                            decoration: BoxDecoration(
                              color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.only(left: 16, right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Search here...",
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
                      ),
                      SizedBox(width: 16,),
                      InkWell(
                        onTap: () async {
                          await Navigator.of(context).pushNamed(AddConnection.routeName);
                          setState(() {});
                        },
                        child: Container(
                          height: 60,
                          width: 60,
                          margin: EdgeInsets.only(right: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                          ),
                          child: Icon(Icons.add, color: MateColors.blackTextColor, size: 28),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16,right: 16,top: 16,bottom: 5),
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
                            width: MediaQuery.of(context).size.width*0.28,
                            decoration: BoxDecoration(
                              color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                              borderRadius: BorderRadius.circular(9),
                            ),
                            alignment: Alignment.center,
                            child: Text('Connections',
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
                            width: MediaQuery.of(context).size.width*0.28,
                            decoration: BoxDecoration(
                              color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                              borderRadius: BorderRadius.circular(9),
                            ),
                            alignment: Alignment.center,
                            child: Text('Requests',
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
                        GestureDetector(
                          onTap: () {
                            _pageController.animateToPage(2, duration: Duration(milliseconds: 500), curve: Curves.ease);
                          },
                          child: Container(
                            height: 36,
                            width: MediaQuery.of(context).size.width*0.28,
                            decoration: BoxDecoration(
                              color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                              borderRadius: BorderRadius.circular(9),
                            ),
                            alignment: Alignment.center,
                            child: Text('Sent',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w500,
                                overflow: TextOverflow.ellipsis,
                                color: _selectedIndex==2?
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
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        children: [
                          SizedBox(height: 25,),
                          connectionGlobalList.length==0?
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 30),
                                alignment: Alignment.center,
                                height: MediaQuery.of(context).size.height/1.5,
                                child: Text("Tap the + icon to make connections and grow your network",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: themeController.isDarkMode?Colors.white:Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Poppins',
                                    fontSize: 15,
                                  ),
                                ),
                              ):
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
                                        return Padding(
                                          padding: const EdgeInsets.only(bottom: 35),
                                          child: InkWell(
                                            onTap: ()async{
                                              if(snapshot1.data!.get('uuid')!=null){
                                                if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == snapshot1.data!.get('uuid')) {
                                                  Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                                                } else {
                                                  await Navigator.of(context).pushNamed(UserProfileScreen.routeName,
                                                      arguments: {"id": snapshot1.data!.get('uuid'),
                                                        "name": snapshot1.data!.get('displayName'),
                                                        "photoUrl": snapshot1.data!.get('photoURL'),
                                                        "firebaseUid": snapshot1.data!.get('uid')
                                                      });
                                                  setState(() {});
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
                                              backgroundColor: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
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
                      ListView(
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        children: [
                          requestGet.length==0?
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 30),
                            alignment: Alignment.center,
                            height: MediaQuery.of(context).size.height/1.5,
                            child: Text("You don't have any connection request",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: themeController.isDarkMode?Colors.white:Colors.black,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Poppins',
                                fontSize: 15,
                              ),
                            ),
                          ):
                          ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: requestGet.length,
                              itemBuilder: (context, index) {
                                return FutureBuilder<DocumentSnapshot>(
                                    future: DatabaseService().getUsersDetails(requestGet[index].senderUid!),
                                    builder: (context, snapshot1) {
                                      if(snapshot1.hasData){
                                        return Padding(
                                          padding: EdgeInsets.only(bottom: 0,top: index==0?16:8),
                                          child: InkWell(
                                            onTap: ()async{
                                              if(snapshot1.data!.get('uuid')!=null){
                                                if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == snapshot1.data!.get('uuid')) {
                                                  Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                                                } else {
                                                  await Navigator.of(context).pushNamed(UserProfileScreen.routeName,
                                                      arguments: {"id": snapshot1.data!.get('uuid'),
                                                        "name": snapshot1.data!.get('displayName'),
                                                        "photoUrl": snapshot1.data!.get('photoURL'),
                                                        "firebaseUid": snapshot1.data!.get('uid')
                                                      });
                                                  setState(() {});
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
                                              title: Padding(
                                                padding: const EdgeInsets.only(top: 5),
                                                child: Text(snapshot1.data!.get('displayName'),
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontFamily: "Poppins",
                                                    fontWeight: FontWeight.w600,
                                                    color: themeController.isDarkMode?Colors.white: MateColors.blackTextColor,
                                                  ),
                                                ),
                                              ),
                                              subtitle: Padding(
                                                padding: const EdgeInsets.only(top: 5),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Container(
                                                      width: MediaQuery.of(context).size.width/3,
                                                      child: ElevatedButton(
                                                        onPressed: ()async{
                                                          setState(() {
                                                            isLoading = true;
                                                          });
                                                          await ConnectionService().connectionAcceptReject(
                                                            status: "Accepted",
                                                            connectionRequestId: requestGet[index].id!,
                                                            token: token,
                                                          );
                                                          await getConnection();
                                                          setState(() {
                                                            isLoading = false;
                                                          });
                                                        },
                                                        style: ElevatedButton.styleFrom(
                                                          elevation: 0,
                                                          primary: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                                                          onPrimary: Colors.white,
                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                                        ),
                                                        child: Text("Confirm",
                                                          style: TextStyle(
                                                            color: MateColors.blackTextColor,
                                                            fontWeight: FontWeight.w600,
                                                            fontFamily: "Poppins",
                                                            fontSize: 18.0,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: MediaQuery.of(context).size.width/3,
                                                      child: ElevatedButton(
                                                        onPressed: ()async{
                                                          setState(() {
                                                            isLoading = true;
                                                          });
                                                          await ConnectionService().connectionAcceptReject(
                                                            status: "Deleted",
                                                            connectionRequestId: requestGet[index].id!,
                                                            token: token,
                                                          );
                                                          await getConnection();
                                                          setState(() {
                                                            isLoading = false;
                                                          });
                                                        },
                                                        style: ElevatedButton.styleFrom(
                                                          elevation: 0,
                                                          primary: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                                                          onPrimary: Colors.white,
                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                                        ),
                                                        child: Text("Delete",
                                                          style: TextStyle(
                                                            color: MateColors.blackTextColor,
                                                            fontWeight: FontWeight.w600,
                                                            fontFamily: "Poppins",
                                                            fontSize: 18.0,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
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
                                              backgroundColor: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
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
                      ListView(
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        children: [
                          requestSent.length==0?
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 30),
                            alignment: Alignment.center,
                            height: MediaQuery.of(context).size.height/1.5,
                            child: Text("No connection request sent",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: themeController.isDarkMode?Colors.white:Colors.black,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Poppins',
                                fontSize: 15,
                              ),
                            ),
                          ):
                          ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: requestSent.length,
                              itemBuilder: (context, index) {
                                return FutureBuilder<DocumentSnapshot>(
                                    future: DatabaseService().getUsersDetails(requestSent[index].connUid!),
                                    builder: (context, snapshot1) {
                                      if(snapshot1.hasData){
                                        return Padding(
                                          padding: EdgeInsets.only(top: 16),
                                          child: InkWell(
                                            onTap: ()async{
                                              if(snapshot1.data!.get('uuid')!=null){
                                                if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == snapshot1.data!.get('uuid')) {
                                                  Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                                                } else {
                                                  await Navigator.of(context).pushNamed(UserProfileScreen.routeName,
                                                      arguments: {"id": snapshot1.data!.get('uuid'),
                                                        "name": snapshot1.data!.get('displayName'),
                                                        "photoUrl": snapshot1.data!.get('photoURL'),
                                                        "firebaseUid": snapshot1.data!.get('uid')
                                                      });
                                                  setState(() {});
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
                                              trailing: InkWell(
                                                onTap: ()async{
                                                  _showAddConnectionAlertDialog(uid: snapshot1.data!.get('uid'), name: snapshot1.data!.get('displayName'),uuid: snapshot1.data!.get('uuid'));
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.only(right: 4,left: 4),
                                                  child: Text("Remove",
                                                    style: TextStyle(
                                                      color: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 12,
                                                      fontFamily: 'Poppins',
                                                    ),
                                                  ),
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
                                              backgroundColor: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
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
                    ],
                  ),
                ),
              ],
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

  _showAddConnectionAlertDialog({required String uid, required String name,required String uuid})async{
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: new Text("Are you sure?"),
          content: new Text("You want to remove this request"),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text("Yes"),
              onPressed: ()async{
                Navigator.of(context).pop();
                setState(() {
                  isLoading = true;
                });
                await ConnectionService().addConnection(uid: uid,name: name,uuid: uuid,token: token);
                await getConnection();
                setState(() {
                  isLoading = false;
                });
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
