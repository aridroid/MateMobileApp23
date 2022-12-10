import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mate_app/Screen/Home/CommunityTab/addPersonToGroupUsingConnectionSearch.dart';

import '../../../asset/Colors/MateColors.dart';
import '../../../constant.dart';
import '../../../controller/addUserController.dart';
import '../../../controller/theme_controller.dart';
import '../../../groupChat/services/database_service.dart';

class AddPersonToGroupUsingConnection extends StatefulWidget {
  const AddPersonToGroupUsingConnection({Key key}) : super(key: key);

  @override
  State<AddPersonToGroupUsingConnection> createState() => _AddPersonToGroupUsingConnectionState();
}

class _AddPersonToGroupUsingConnectionState extends State<AddPersonToGroupUsingConnection> {
  ThemeController themeController = Get.find<ThemeController>();
  final AddUserController _addUserController = Get.find<AddUserController>();

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
            onTap: ()async{
              await Get.to(AddPersonToGroupUsingConnectionSearch());
              setState(() {});
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
          "Add Recipients",
          style: TextStyle(
            color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
            fontWeight: FontWeight.w700,
            fontSize: 17.0,
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: _addUserController.addConnectionUid.isNotEmpty?InkWell(
        onTap: (){
         Get.back();
        },
        child: Container(
          height: 56,
          width: 56,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: MateColors.activeIcons,
          ),
          child: Icon(
            Icons.check,
            size: 31,
            color: themeController.isDarkMode?Colors.black:Colors.white,
          ),
        ),
      ):Offstage(),
      body: ListView(
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
                              setState(() {
                                if(_addUserController.selected.contains(index)){
                                  _addUserController.selected.remove(index);
                                }else{
                                  _addUserController.selected.add(index);
                                }
                              });
                              if(_addUserController.addConnectionUid.contains(connectionGlobalList[index].uid)){
                                _addUserController.addConnectionUid.remove(connectionGlobalList[index].uid);
                              }else{
                                _addUserController.addConnectionUid.add(connectionGlobalList[index].uid);
                              }
                              if(_addUserController.addConnectionDisplayName.contains(connectionGlobalList[index].name)){
                                _addUserController.addConnectionDisplayName.remove(connectionGlobalList[index].name);
                              }else{
                                _addUserController.addConnectionDisplayName.add(connectionGlobalList[index].name);
                              }
                              print(_addUserController.addConnectionUid);
                              print(_addUserController.addConnectionDisplayName);
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
                              trailing: _addUserController.selected.contains(index)?
                              Icon(Icons.check,color: MateColors.activeIcons,):Offstage(),
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
