import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mate_app/Screen/connection/add_connection.dart';
import 'package:mate_app/Screen/connection/connectionSearch.dart';
import 'package:mate_app/constant.dart';
import 'package:provider/provider.dart';

import '../../Providers/AuthUserProvider.dart';
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

class _ConnectionScreenState extends State<ConnectionScreen> {
  ThemeController themeController = Get.find<ThemeController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        children: [
          // SizedBox(height: 15,),
          // Padding(
          //   padding: const EdgeInsets.only(left: 16),
          //   child: Text("A",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight),),
          // ),
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
    );
  }
}
