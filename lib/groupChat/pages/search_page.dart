import 'package:mate_app/asset/Colors/MateColors.dart';
import 'package:mate_app/Providers/AuthUserProvider.dart';
import 'package:mate_app/Utility/Utility.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mate_app/groupChat/helper/helper_functions.dart';
import 'package:mate_app/groupChat/pages/chat_page.dart';
import 'package:mate_app/groupChat/services/database_service.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // data
  TextEditingController searchEditingController = new TextEditingController();
  FocusNode focusNode= FocusNode();
  QuerySnapshot searchResultSnapshot;
  bool isLoading = true;
  bool hasUserSearched = false;
  // bool _isJoined = false;
  String _userName = '';
  User _user;
  String searchedName="";

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  // initState()
  @override
  void initState() {
    super.initState();
    focusNode.requestFocus();
    _getCurrentUserNameAndUid();
    DatabaseService().getAllGroups().then((snapshot) {
      searchResultSnapshot = snapshot;
      //print("$searchResultSnapshot");
      setState(() {
        isLoading = false;
        hasUserSearched = true;
      });
    });

  }

  @override
  void dispose() {
    // TODO: implement dispose
    focusNode.dispose();
    super.dispose();
  }

  // functions
  _getCurrentUserNameAndUid() async {
    await HelperFunctions.getUserNameSharedPreference().then((value) {
      _userName = value;
    });
    _user = FirebaseAuth.instance.currentUser;
  }

  // _initiateSearch(String val) async {
  //   if (val.isNotEmpty) {
  //     setState(() {
  //       isLoading = true;
  //     });
  //     await DatabaseService().searchByName(val).then((snapshot) {
  //       searchResultSnapshot = snapshot;
  //       //print("$searchResultSnapshot");
  //       setState(() {
  //         isLoading = false;
  //         hasUserSearched = true;
  //       });
  //     });
  //   }
  // }

  void _showScaffold(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      backgroundColor: Colors.black,
      duration: Duration(milliseconds: 1500),
      content: Text(message, textAlign: TextAlign.center, style: TextStyle(fontSize: 13.0, color: MateColors.activeIcons)),
    ));
  }

  _joinValueInGroup(String userName, String groupId, String groupName, String admin) async {
    bool value = await DatabaseService(uid: _user.uid).isUserJoined(groupId, groupName, userName);
    setState(() {
      // _isJoined = value;
    });
  }

  // widgets
  Widget groupList() {
    return hasUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchResultSnapshot.docs.length,
            itemBuilder: (context, index) {

              return searchedName!="" && searchResultSnapshot.docs[index]["groupName"].toString().toLowerCase().contains(searchedName.toLowerCase())?
              Visibility(
                visible: /*?*/ searchResultSnapshot.docs[index]["isPrivate"] != null
                    ? searchResultSnapshot.docs[index]["isPrivate"] == true
                        ? searchResultSnapshot.docs[index]["members"].contains(_user.uid + '_' + _user.displayName)
                        : true
                    : true /*: false*/,
                child: groupTile(
                  Provider.of<AuthUserProvider>(context, listen: false).authUser.displayName,
                  searchResultSnapshot.docs[index]["groupId"],
                  searchResultSnapshot.docs[index]["groupName"].toString(),
                  searchResultSnapshot.docs[index]["admin"],
                  searchResultSnapshot.docs[index]["members"].length,
                  searchResultSnapshot.docs[index]["maxParticipantNumber"],
                  searchResultSnapshot.docs[index]["isPrivate"],
                  searchResultSnapshot.docs[index]["members"].contains(_user.uid + '_' + _user.displayName),
                  searchResultSnapshot.docs[index]["groupIcon"],
                  searchResultSnapshot.docs[index]["members"],
                ),
              ):SizedBox();
            })
        : Container();
  }

  Widget groupTile(String userName, String groupId, String groupName, String admin, int totalParticipant, int maxParticipant, bool isPrivate, bool _isJoined, String imageURL,List<String> members)
  {
    // _joinValueInGroup(userName, groupId, groupName, admin);
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      leading: imageURL!=""?CircleAvatar(
        radius: 18.0,
        backgroundImage: NetworkImage(imageURL),
      ):CircleAvatar(
        radius: 18.0,
        backgroundColor: MateColors.activeIcons,
        child: Text(groupName.toLowerCase().substring(0, 1).toUpperCase(), textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
      ),
      title: Text(groupName, style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w700, color: MateColors.activeIcons)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Creator: $admin", style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w100, color: Colors.grey[50]), overflow: TextOverflow.ellipsis),
          maxParticipant != null
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Text("Max Participant: $maxParticipant", style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w100, color: Colors.grey[50]), overflow: TextOverflow.ellipsis),
                )
              : SizedBox(
                  height: 2,
                ),
          Text("Total Participant: $totalParticipant", style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w100, color: Colors.grey[50]), overflow: TextOverflow.ellipsis),
        ],
      ),
      trailing: InkWell(
        onTap: () async {
          if(_isJoined){
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ChatPage(
                groupId: groupId,
                userName: userName,
                groupName: groupName,
              memberList : members,
            )));
          }
          else if (maxParticipant != null
                  ? totalParticipant < maxParticipant
                  : true) {
            await DatabaseService(uid: _user.uid).togglingGroupJoin(groupId, groupName, userName);
              // await DatabaseService(uid: _user.uid).userJoinGroup(groupId, groupName, userName);
              _showScaffold('Successfully joined the group "$groupName"');
              Future.delayed(Duration(milliseconds: 100), () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ChatPage(
                    groupId: groupId,
                    userName: userName,
                    groupName: groupName,
                    memberList: members,
                )));
              });

          }
        },
        child: _isJoined
            ? Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), border: Border.all(color: Colors.white, width: 0.6)),
                padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 8.0),
                child: Text('Message', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
              )
            : Visibility(
                visible: maxParticipant != null ? totalParticipant < maxParticipant : true,
                replacement: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), border: Border.all(color: Colors.transparent, width: 0.6)),
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text('Group Full', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500))),
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), border: Border.all(color: MateColors.activeIcons, width: 0.6)),
                  padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 8.0),
                  child: Text('Join', style: TextStyle(color: MateColors.activeIcons, fontWeight: FontWeight.w500)),
                ),
              ),
      ),
    );
  }

  // building the search page widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: myHexColor,
      appBar: AppBar(
        backgroundColor: myHexColor,
        title: Text('Search Group', style: TextStyle(fontSize: 16.0.sp, fontWeight: FontWeight.bold, color: MateColors.activeIcons)),
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
                : Expanded(child: groupList())
          ],
        ),
      ),
    );
  }
}

// Widget groupTile(String userName, String groupId, String groupName, String admin, int totalParticipant, int maxParticipant, bool isPrivate) {
//   _joinValueInGroup(userName, groupId, groupName, admin);
//   return ListTile(
//     contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
//     leading: CircleAvatar(
//       radius: 18.0,
//       backgroundColor: MateColors.activeIcons,
//       child: Text(groupName.substring(0, 1).toUpperCase(), textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
//     ),
//     title: Text(groupName, style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w700, color: MateColors.activeIcons)),
//     subtitle: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text("Creator: $admin", style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w100, color: Colors.grey[50]), overflow: TextOverflow.ellipsis),
//         maxParticipant != null
//             ? Padding(
//           padding: const EdgeInsets.symmetric(vertical: 2.0),
//           child: Text("Max Participant: $maxParticipant", style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w100, color: Colors.grey[50]), overflow: TextOverflow.ellipsis),
//         )
//             : SizedBox(
//           height: 2,
//         ),
//         Text("Total Participant: $totalParticipant", style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w100, color: Colors.grey[50]), overflow: TextOverflow.ellipsis),
//       ],
//     ),
//     trailing: InkWell(
//       onTap: () async {
//         if (_isJoined
//             ? true
//             : maxParticipant != null
//             ? totalParticipant < maxParticipant
//             : true) {
//           await DatabaseService(uid: _user.uid).togglingGroupJoin(groupId, groupName, userName);
//           if (_isJoined) {
//             setState(() {
//               _isJoined = !_isJoined;
//             });
//             // await DatabaseService(uid: _user.uid).userJoinGroup(groupId, groupName, userName);
//             _showScaffold('Successfully joined the group "$groupName"');
//             Future.delayed(Duration(milliseconds: 100), () {
//               Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ChatPage(groupId: groupId, userName: userName, groupName: groupName)));
//             });
//           } else {
//             setState(() {
//               _isJoined = !_isJoined;
//             });
//             _showScaffold('Left the group "$groupName"');
//           }
//         }
//       },
//       child: _isJoined
//           ? Container(
//         decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), border: Border.all(color: Colors.red, width: 0.6)),
//         padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 8.0),
//         child: Text('Left', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500)),
//       )
//           : Visibility(
//         visible: maxParticipant != null ? totalParticipant < maxParticipant : true,
//         replacement: Container(
//             decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), border: Border.all(color: Colors.transparent, width: 0.6)),
//             padding: EdgeInsets.symmetric(vertical: 8.0),
//             child: Text('Group Full', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500))),
//         child: Container(
//           decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), border: Border.all(color: MateColors.activeIcons, width: 0.6)),
//           padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 8.0),
//           child: Text('Join', style: TextStyle(color: MateColors.activeIcons, fontWeight: FontWeight.w500)),
//         ),
//       ),
//     ),
//   );
// }

