import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mate_app/Screen/Home/CommunityTab/addPersonWhileCreatingGroupSearch.dart';
import 'package:mate_app/audioAndVideoCalling/addParticipantsScreen.dart';

import '../../../asset/Colors/MateColors.dart';
import '../../../controller/addUserController.dart';
import '../../../controller/theme_controller.dart';
import '../../../groupChat/services/database_service.dart';

class AddPersonWhileCreatingGroup extends StatefulWidget {
  const AddPersonWhileCreatingGroup({Key key}) : super(key: key);

  @override
  State<AddPersonWhileCreatingGroup> createState() => _AddPersonWhileCreatingGroupState();
}

class _AddPersonWhileCreatingGroupState extends State<AddPersonWhileCreatingGroup> {
  ThemeController themeController = Get.find<ThemeController>();
  final AddUserController _addUserController = Get.find<AddUserController>();
  QuerySnapshot searchResultSnapshot;
  bool isLoading = true;
  User _user = FirebaseAuth.instance.currentUser;
  List<UserListModel> personList = [];

  @override
  void initState() {
    getData();
    super.initState();
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
        return a.displayName.toLowerCase().compareTo(b.displayName.toLowerCase());
      });
      setState(() {
        isLoading = false;
      });
    });
  }

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
              await Get.to(AddPersonWhileCreatingGroupSearch());
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
      body: isLoading?
      Center(
        child: CircularProgressIndicator(
          color: MateColors.activeIcons,
        ),
      ):
      ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        children: [
          SizedBox(height: 25,),
          ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              itemCount: personList.length,
              itemBuilder: (context, index) {
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
                      if(_addUserController.addConnectionUid.contains(personList[index].uid)){
                        _addUserController.addConnectionUid.remove(personList[index].uid);
                      }else{
                        _addUserController.addConnectionUid.add(personList[index].uid);
                      }
                      if(_addUserController.addConnectionDisplayName.contains(personList[index].displayName)){
                        _addUserController.addConnectionDisplayName.remove(personList[index].displayName);
                      }else{
                        _addUserController.addConnectionDisplayName.add(personList[index].displayName);
                      }
                      print(_addUserController.addConnectionUid);
                      print(_addUserController.addConnectionDisplayName);
                    },
                    child: ListTile(
                      leading: personList[index].photoURL!=null?
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: MateColors.activeIcons,
                        backgroundImage: NetworkImage(
                          personList[index].photoURL,
                        ),
                      ):
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: MateColors.activeIcons,
                        child: Text(personList[index].displayName.substring(0,1),style: TextStyle(color: themeController.isDarkMode?Colors.black:Colors.white),),
                      ),
                      title: Text(personList[index].displayName,
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
              }),
        ],
      ),
    );
  }
}
