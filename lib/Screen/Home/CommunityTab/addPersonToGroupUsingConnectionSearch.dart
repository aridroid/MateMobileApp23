import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../asset/Colors/MateColors.dart';
import '../../../constant.dart';
import '../../../controller/addUserController.dart';
import '../../../controller/theme_controller.dart';
import '../../../groupChat/services/database_service.dart';

class AddPersonToGroupUsingConnectionSearch extends StatefulWidget {
  const AddPersonToGroupUsingConnectionSearch({Key key}) : super(key: key);

  @override
  State<AddPersonToGroupUsingConnectionSearch> createState() => _AddPersonToGroupUsingConnectionSearchState();
}

class _AddPersonToGroupUsingConnectionSearchState extends State<AddPersonToGroupUsingConnectionSearch> {
  ThemeController themeController = Get.find<ThemeController>();
  final AddUserController _addUserController = Get.find<AddUserController>();
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
    return Scaffold(
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
      floatingActionButton: _addUserController.addConnectionUid.isNotEmpty?InkWell(
        onTap: (){
          Get.back();
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
                        return Visibility(
                          visible: searchedName!="" && snapshot1.data.data()['displayName'].toString().toLowerCase().contains(searchedName.toLowerCase()),
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
