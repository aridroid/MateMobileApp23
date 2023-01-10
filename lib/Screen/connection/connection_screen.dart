import 'dart:developer';

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
import 'package:mate_app/Model/conncetionListingModel.dart';

class ConnectionScreen extends StatefulWidget {
  static final String routeName = '/connectionScreen';

  @override
  _ConnectionScreenState createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends State<ConnectionScreen> with TickerProviderStateMixin{
  ThemeController themeController = Get.find<ThemeController>();
  TabController _tabController;
  String token = "";
  bool isLoading = false;

  getStoredValue()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token");
    print(token);
  }

  @override
  void initState() {
    getStoredValue();
    _tabController = new TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            elevation: 0,
            iconTheme: IconThemeData(
              color: MateColors.activeIcons,
            ),
            actions: [
              InkWell(
                onTap: (){
                  Get.to(ConnectionSearch());
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 20,left: 20),
                  child: Image.asset(
                    "lib/asset/homePageIcons/searchPurple@3x.png",
                    height: 23.7,
                    width: 23.7,
                    color: MateColors.activeIcons,
                  ),
                ),
              ),
            ],
            title: Text(
              "Connections",
              style: TextStyle(
                color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                fontWeight: FontWeight.w700,
                fontSize: 17.0,
              ),
            ),
            centerTitle: true,
          ),
          floatingActionButton: InkWell(
            onTap: () async{
              await Navigator.of(context).pushNamed(AddConnection.routeName);
              setState(() {});
            },
            child: Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: MateColors.activeIcons,
              ),
              child: Icon(Icons.add,color: themeController.isDarkMode?Colors.black:Colors.white,size: 28),
            ),
          ),
          body: Column(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.0),
                  border: Border(bottom: BorderSide(color: Color(0xFF65656B).withOpacity(0.2), width: 0.8)),
                ),
                child: TabBar(
                  controller: _tabController,
                  unselectedLabelColor: Color(0xFF656568),
                  indicatorColor: MateColors.activeIcons,
                  indicatorPadding: EdgeInsets.symmetric(horizontal: 20),
                  labelColor: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                  labelStyle: TextStyle(fontSize: 15.0,fontFamily: "Poppins",fontWeight: FontWeight.w500),
                  tabs: [
                    Tab(
                      text: "Connections",
                    ),
                    Tab(
                      text: "Requests",
                    ),
                    Tab(
                      text: "Sent",
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    ListView(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      children: [
                        SizedBox(height: 25,),
                        connectionGlobalList.length==0?
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 30),
                              alignment: Alignment.center,
                              height: MediaQuery.of(context).size.height/1.3,
                              child: Text("Tap the + icon to make connections and grow your network",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 17.0,
                                ),
                              ),
                            ):
                        ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: connectionGlobalList.length,
                            itemBuilder: (context, index) {
                              return FutureBuilder(
                                  future: DatabaseService().getUsersDetails(connectionGlobalList[index].uid),
                                  builder: (context, snapshot1) {
                                    if(snapshot1.hasData){
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 35),
                                        child: InkWell(
                                          onTap: ()async{
                                            if(snapshot1.data.data()['uuid']!=null){
                                              if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == snapshot1.data.data()['uuid']) {
                                                Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                                              } else {
                                                await Navigator.of(context).pushNamed(UserProfileScreen.routeName,
                                                    arguments: {"id": snapshot1.data.data()['uuid'],
                                                      "name": snapshot1.data.data()['displayName'],
                                                      "photoUrl": snapshot1.data.data()['photoURL'],
                                                      "firebaseUid": snapshot1.data.data()['uid']
                                                    });
                                                setState(() {});
                                              }
                                            }
                                          },
                                          child: ListTile(
                                            leading: snapshot1.data.data()['photoURL']!=null?
                                            CircleAvatar(
                                              radius: 28,
                                              backgroundColor: MateColors.activeIcons,
                                              backgroundImage: NetworkImage(
                                                snapshot1.data.data()['photoURL'],
                                              ),
                                            ):
                                            CircleAvatar(
                                              radius: 28,
                                              backgroundColor: MateColors.activeIcons,
                                              child: Text(snapshot1.data.data()['displayName'].substring(0,1),style: TextStyle(color: themeController.isDarkMode?Colors.black:Colors.white),),
                                            ),
                                            title: Text(snapshot1.data.data()['displayName'],
                                              style: TextStyle(
                                                fontSize: 15,
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
                    ListView(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      children: [
                        requestGet.length==0?
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 30),
                          alignment: Alignment.center,
                          height: MediaQuery.of(context).size.height/1.3,
                          child: Text("You don't have any connection request",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
                              fontWeight: FontWeight.w400,
                              fontSize: 15.0,
                            ),
                          ),
                        ):
                        ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: requestGet.length,
                            itemBuilder: (context, index) {
                              return FutureBuilder(
                                  future: DatabaseService().getUsersDetails(requestGet[index].senderUid),
                                  builder: (context, snapshot1) {
                                    if(snapshot1.hasData){
                                      return Padding(
                                        padding: EdgeInsets.only(bottom: 0,top: index==0?16:8),
                                        child: InkWell(
                                          onTap: ()async{
                                            if(snapshot1.data.data()['uuid']!=null){
                                              if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == snapshot1.data.data()['uuid']) {
                                                Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                                              } else {
                                                await Navigator.of(context).pushNamed(UserProfileScreen.routeName,
                                                    arguments: {"id": snapshot1.data.data()['uuid'],
                                                      "name": snapshot1.data.data()['displayName'],
                                                      "photoUrl": snapshot1.data.data()['photoURL'],
                                                      "firebaseUid": snapshot1.data.data()['uid']
                                                    });
                                                setState(() {});
                                              }
                                            }
                                          },
                                          child: ListTile(
                                            leading: snapshot1.data.data()['photoURL']!=null?
                                            CircleAvatar(
                                              radius: 28,
                                              backgroundColor: MateColors.activeIcons,
                                              backgroundImage: NetworkImage(
                                                snapshot1.data.data()['photoURL'],
                                              ),
                                            ):
                                            CircleAvatar(
                                              radius: 28,
                                              backgroundColor: MateColors.activeIcons,
                                              child: Text(snapshot1.data.data()['displayName'].substring(0,1),style: TextStyle(color: themeController.isDarkMode?Colors.black:Colors.white),),
                                            ),
                                            title: Padding(
                                              padding: const EdgeInsets.only(top: 5),
                                              child: Text(snapshot1.data.data()['displayName'],
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0.1,
                                                  color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
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
                                                          connectionRequestId: requestGet[index].id,
                                                          token: token,
                                                        );
                                                        await getConnection();
                                                        setState(() {
                                                          isLoading = false;
                                                        });
                                                      },
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: MateColors.activeIcons,
                                                      ),
                                                      child: Text("Confirm",
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight: FontWeight.w500,
                                                          letterSpacing: 0.1,
                                                          color: themeController.isDarkMode?MateColors.blackTextColor:Colors.white,
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
                                                          connectionRequestId: requestGet[index].id,
                                                          token: token,
                                                        );
                                                        await getConnection();
                                                        setState(() {
                                                          isLoading = false;
                                                        });
                                                      },
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
                                                      ),
                                                      child: Text("Delete",
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight: FontWeight.w500,
                                                          letterSpacing: 0.1,
                                                          color: themeController.isDarkMode?MateColors.blackTextColor:Colors.white,
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
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      children: [
                        requestSent.length==0?
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 30),
                          alignment: Alignment.center,
                          height: MediaQuery.of(context).size.height/1.3,
                          child: Text("No connection request sent",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
                              fontWeight: FontWeight.w400,
                              fontSize: 15.0,
                            ),
                          ),
                        ):
                        ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: requestSent.length,
                            itemBuilder: (context, index) {
                              return FutureBuilder(
                                  future: DatabaseService().getUsersDetails(requestSent[index].connUid),
                                  builder: (context, snapshot1) {
                                    if(snapshot1.hasData){
                                      return Padding(
                                        padding: EdgeInsets.only(top: 16),
                                        child: InkWell(
                                          onTap: ()async{
                                            if(snapshot1.data.data()['uuid']!=null){
                                              if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == snapshot1.data.data()['uuid']) {
                                                Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                                              } else {
                                                await Navigator.of(context).pushNamed(UserProfileScreen.routeName,
                                                    arguments: {"id": snapshot1.data.data()['uuid'],
                                                      "name": snapshot1.data.data()['displayName'],
                                                      "photoUrl": snapshot1.data.data()['photoURL'],
                                                      "firebaseUid": snapshot1.data.data()['uid']
                                                    });
                                                setState(() {});
                                              }
                                            }
                                          },
                                          child: ListTile(
                                            leading: snapshot1.data.data()['photoURL']!=null?
                                            CircleAvatar(
                                              radius: 28,
                                              backgroundColor: MateColors.activeIcons,
                                              backgroundImage: NetworkImage(
                                                snapshot1.data.data()['photoURL'],
                                              ),
                                            ):
                                            CircleAvatar(
                                              radius: 28,
                                              backgroundColor: MateColors.activeIcons,
                                              child: Text(snapshot1.data.data()['displayName'].substring(0,1),style: TextStyle(color: themeController.isDarkMode?Colors.black:Colors.white),),
                                            ),
                                            title: Text(snapshot1.data.data()['displayName'],
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 0.1,
                                                color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                                              ),
                                            ),
                                            trailing: InkWell(
                                              onTap: ()async{
                                                _showAddConnectionAlertDialog(uid: snapshot1.data.data()['uid'], name: snapshot1.data.data()['displayName'],uuid: snapshot1.data.data()['uuid']);
                                              },
                                              child: Padding(
                                                  padding: const EdgeInsets.only(right: 4,left: 4),
                                                  child: Text("Remove",style: TextStyle(color: MateColors.activeIcons, fontWeight: FontWeight.w500,fontSize: 12),)
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
                  ],
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: isLoading,
          child: Loader(),
        ),
      ],
    );
  }

  _showAddConnectionAlertDialog({@required String uid, @required String name,@required String uuid})async{
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
