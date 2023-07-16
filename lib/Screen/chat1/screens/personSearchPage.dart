import 'package:mate_app/Screen/chat1/screens/chat.dart';
import 'package:mate_app/Utility/Utility.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mate_app/groupChat/helper/helper_functions.dart';
import 'package:mate_app/groupChat/pages/chat_page.dart';
import 'package:mate_app/groupChat/services/database_service.dart';
import 'package:get/get.dart';
import 'package:mate_app/asset/Colors/MateColors.dart';
import 'package:sizer/sizer.dart';

class PersonSearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<PersonSearchPage> {
  TextEditingController searchEditingController = new TextEditingController();
  FocusNode focusNode= FocusNode();
  late QuerySnapshot searchResultSnapshot;
  bool isLoading = true;
  bool hasUserSearched = false;
  User _user = FirebaseAuth.instance.currentUser!;
  String searchedName="";

  // initState()
  @override
  void initState() {
    focusNode.requestFocus();
    DatabaseService().getAllUserData(_user.uid).then((snapshot){
      searchResultSnapshot = snapshot;
      //print("$searchResultSnapshot");
      setState(() {
        isLoading = false;
        hasUserSearched = true;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    focusNode.dispose();
    super.dispose();
  }

  // _initiateSearch(String val) async {
  //   if (val.isNotEmpty) {
  //     setState(() {
  //       isLoading = true;
  //     });
  //     await DatabaseService(uid: _user.uid).searchByUserName(val).then((snapshot) {
  //       searchResultSnapshot = snapshot;
  //       //print("$searchResultSnapshot");
  //       setState(() {
  //         isLoading = false;
  //         hasUserSearched = true;
  //       });
  //     });
  //   }
  // }

  // widgets
  Widget groupList() {
    return hasUserSearched
        ? ListView.builder(
        shrinkWrap: true,
        itemCount: searchResultSnapshot.docs.length,
        itemBuilder: (context, index) {
          return Visibility(
            visible: searchedName!="" && searchResultSnapshot.docs[index]["displayName"].toString().toLowerCase().contains(searchedName.toLowerCase()),
            child: groupTile(
              searchResultSnapshot.docs[index]["uuid"],
              searchResultSnapshot.docs[index]["uid"],
              searchResultSnapshot.docs[index]["displayName"],
              searchResultSnapshot.docs[index]["photoURL"],
              searchResultSnapshot.docs[index]["email"],
            ),
          );
        })
        : Container();
  }

  Widget groupTile(String peerUuid,String peerId, String peerName, String peerAvatar,String email) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: MateColors.activeIcons,
        backgroundImage: NetworkImage(
          peerAvatar??"",
        ),

      ),
      title: Text(peerName, style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w700, color: MateColors.activeIcons)),
      subtitle: Text("Tap on chat to send message", style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w100, color: Colors.grey[50]), overflow: TextOverflow.ellipsis),
      trailing: InkWell(
        onTap: ()=> Get.off(() =>
            Chat(
              peerUuid: peerUuid,
              currentUserId: _user.uid, //
              peerId: peerId,
              peerName: peerName,
              peerAvatar: peerAvatar,
            )),
        child:Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), border: Border.all(color: MateColors.activeIcons, width: 0.6)),
          padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 8.0),
          child: Text('Chat', style: TextStyle(color: MateColors.activeIcons, fontWeight: FontWeight.w500)),
        ),
      ),
    );
  }

  // building the search page widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myHexColor,
      appBar: AppBar(
        backgroundColor: myHexColor,
        title: Text('Search Person', style: TextStyle(fontSize: 16.0.sp, fontWeight: FontWeight.bold, color: MateColors.activeIcons)),
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                onChanged: (val) => setState((){
                  searchedName=val;
                }),
                style: TextStyle(color: Colors.white, fontSize: 14.0),
                cursorColor: Colors.cyanAccent,
                controller: searchEditingController,
                focusNode: focusNode,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey[50],
                    size: 16,
                  ),
                  labelText: "Search",
                  contentPadding: EdgeInsets.symmetric(vertical: -5),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey, width: 0.3),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  labelStyle: TextStyle(color: Colors.white, fontSize: 16),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey, width: 0.3),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
            ),
            isLoading
                ? Container(
                child: Center(
                    child: CircularProgressIndicator(
                      color: MateColors.activeIcons,
                    )))
                : Expanded(child: groupList()),
          ],
        ),
      ),
    );
  }
}

