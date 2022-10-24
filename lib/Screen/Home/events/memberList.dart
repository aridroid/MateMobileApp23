import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mate_app/Model/eventListingModel.dart';
import 'package:mate_app/Screen/Home/events/memberSearch.dart';
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

  @override
  void initState() {
    getStoredValue();
    super.initState();
  }

  getStoredValue()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token");
    log(token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: themeController.isDarkMode?MateColors.drawerTileColor:Colors.white,
        iconTheme: IconThemeData(
          color: MateColors.activeIcons,
        ),
        title: Text(
          "Going or Interested",
          style: TextStyle(
            color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
            fontWeight: FontWeight.w700,
            fontSize: 17.0,
          ),
        ),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MemberSearch(list: widget.list,)));
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Image.asset(
                "lib/asset/homePageIcons/searchPurple@3x.png",
                height: 23.7,
                width: 23.7,
                color: MateColors.activeIcons,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        padding: EdgeInsets.only(left: 6,top: 16,bottom: 16),
        children: [
          ListView.builder(
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
                            trailing: !connectionGlobalUidList.contains(snapshot1.data.data()['uid']) && Provider.of<AuthUserProvider>(context, listen: false).authUser.firebaseUid!=snapshot1.data.data()['uid']?
                            InkWell(
                              onTap: ()async{
                                _showAddConnectionAlertDialog(uid: snapshot1.data.data()['uid'], name: snapshot1.data.data()['displayName'],uuid: snapshot1.data.data()['uuid']);
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 4,left: 4),
                                child: Image.asset("lib/asset/icons/addPerson.png",height: 21,),
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
              }),
        ],
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
                String res = await ConnectionService().addConnection(uid: uid,name: name,uuid:uuid,token: token);
                //Connection saved successfully
                //Connection already exists
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
