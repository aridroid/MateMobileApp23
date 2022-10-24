// import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:mate_app/Screen/chat1/screens/chat.dart';
import 'package:mate_app/Screen/chat1/screens/personSearchPage.dart';
import 'package:mate_app/Utility/Utility.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mate_app/groupChat/services/database_service.dart';
import 'package:get/get.dart';
import 'package:mate_app/asset/Colors/MateColors.dart';
import 'package:sizer/sizer.dart';

class AllUsersScreen extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<AllUsersScreen> {
  // data
  User _user = FirebaseAuth.instance.currentUser;
  String searchText="";
  bool contactPermission;

  // initState()
  @override
  void initState() {
    // contactPermissionFunc();
    super.initState();
  }

  // contactPermissionFunc() async{
  //   contactPermission = await FlutterContacts.requestPermission();
  // }

  // building the search page widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myHexColor,
      appBar: AppBar(
        backgroundColor: myHexColor,
        title: Text('Find Your Mates', style: TextStyle(fontSize: 16.0.sp, fontWeight: FontWeight.bold, color: MateColors.activeIcons)),
      ),
      body: _allUsers(),
    );
  }

  Widget _allUsers() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12.0,8.0,12.0,8.0),
          child: TextFormField(
            // readOnly: true,
            // onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => PersonSearchPage())),
            style: TextStyle(color: Colors.white, fontSize: 13.0),
            cursorColor: Colors.cyanAccent,
            onChanged: (value) {
              searchText = value;
              setState(() {});
            },
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey[50],
                size: 16,
              ),
              labelText: "Search",
              contentPadding: EdgeInsets.symmetric(vertical: -5),
              enabledBorder: OutlineInputBorder(
                borderSide:
                const BorderSide(color: Colors.grey, width: 0.3),
                borderRadius: BorderRadius.circular(15.0),
              ),

              labelStyle: TextStyle(color: Colors.white, fontSize: 16),
              // fillColor: MateColors.activeIcons,

              focusedBorder: OutlineInputBorder(
                borderSide:
                const BorderSide(color: Colors.grey, width: 0.3),
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
          ),
        ),
        Expanded(
          child: FutureBuilder(
              future: DatabaseService().getAllUserData(_user.uid),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) =>
                        Visibility(
                          visible: searchText.isNotEmpty?snapshot.data.docs[index].data()["displayName"].toLowerCase().contains(searchText.trim().toLowerCase()): true,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                            child: ListTile(
                              onTap: () =>
                                  Get.to(() =>
                                      Chat(
                                        peerUuid: snapshot.data.docs[index].data()["uuid"],
                                        currentUserId: _user.uid,
                                        peerId: snapshot.data.docs[index].data()["uid"],
                                        peerName: snapshot.data.docs[index].data()["displayName"],
                                        peerAvatar: snapshot.data.docs[index].data()["photoURL"],
                                      )),
                              leading: CircleAvatar(
                                radius: 20,
                                backgroundColor: MateColors.activeIcons,
                                backgroundImage: NetworkImage(
                                  snapshot.data.docs[index].data()["photoURL"]??"",
                                ),

                              ),
                              title: Text(snapshot.data.docs[index].data()["displayName"], style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w700, color: MateColors.activeIcons)),
                              subtitle: Text(
                                "Tap to send message",
                                style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w100, color: Colors.grey[50]),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),);
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: MateColors.activeIcons,
                    ),
                  );
                }
              }),
        ),
      ],
    );
  }
}
