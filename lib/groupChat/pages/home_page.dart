// import 'package:get/get.dart';
// import 'package:mate_app/Providers/AuthUserProvider.dart';
// import 'package:mate_app/Utility/Utility.dart';
// import 'package:mate_app/asset/Colors/MateColors.dart';
// import 'package:mate_app/groupChat/services/dynamicLinkService.dart';
// import 'package:mate_app/groupChat/widgets/orbitalChatWebView.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:expandable_text/expandable_text.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:mate_app/groupChat/helper/helper_functions.dart';
// import 'package:mate_app/groupChat/pages/chat_page.dart';
// import 'package:mate_app/groupChat/pages/search_page.dart';
// import 'package:mate_app/groupChat/services/auth_service.dart';
// import 'package:mate_app/groupChat/services/database_service.dart';
// import 'package:mate_app/groupChat/widgets/group_tile.dart';
// import 'package:flutter/services.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:provider/provider.dart';
// import 'package:sizer/sizer.dart';
//
// import '../../Providers/chatProvider.dart';
// import '../../Screen/chat1/personalChatPage.dart';
// import '../../Widget/Loaders/Shimmer.dart';
// import '../../textStyles.dart';
//
// class GroupHomePage extends StatefulWidget {
//   final String groupId;
//
//   const GroupHomePage({Key key, this.groupId}) : super(key: key);
//
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<GroupHomePage> {
//   // data
//   final AuthService _auth = AuthService();
//   User _user;
//   String _groupName;
//   int _groupMaxMember = 100;
//   String _userName = '';
//   String _email = '';
//   Stream _groups;
//   bool isPrivate = false;
//
//   // initState
//   @override
//   initState() {
//     super.initState();
//     _user = FirebaseAuth.instance.currentUser;
//     // _getUserAuthAndJoinedGroups();
//     Future.delayed(Duration.zero,() {
//       Provider.of<ChatProvider>(context,listen: false).groupChatDataFetch(_user.uid);
//     },);
//     if (widget.groupId != null && isDynamicLinkHit) {
//       DatabaseService(uid: _user.uid).getUserExistGroup(widget.groupId, _user.uid, Provider.of<AuthUserProvider>(context, listen: false).authUser.displayName).then((value) => modalSheet(widget.groupId, _user, value));
//     }
//   }
//   Widget _appBarLeading(BuildContext context) {
//     return Selector<AuthUserProvider, String>(
//         selector: (ctx, authUserProvider) => authUserProvider.authUserPhoto,
//         builder: (ctx, data, _) {
//           return Padding(
//             padding:  EdgeInsets.only(left: 12.0.sp),
//             child: InkWell(
//                 onTap: () {
//                   Scaffold.of(ctx).openDrawer();
//                 },
//                 child: CircleAvatar(
//                   backgroundColor: MateColors.activeIcons,
//                   child: CircleAvatar(
//                     backgroundColor: Colors.transparent,
//                     child: ClipOval(
//                         child: Image.network(
//                           data,
//                         )
//                     ),
//                   ),
//                 )
//             ),
//           );
//         });
//   }
//
//   modalSheet(String groupId, User user, bool isUserExist) {
//     isDynamicLinkHit=false;
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: myHexColor,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(
//           top: Radius.circular(15.0),
//         ),
//       ),
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return StreamBuilder<DocumentSnapshot>(
//                 stream: DatabaseService().getGroupDetails(groupId),
//                 builder: (context, snapshot) {
//                   if (snapshot.hasData) {
//                     return Stack(
//                       // overflow: Overflow.visible,
//                       clipBehavior: Clip.none,
//                       children: [
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           mainAxisSize: MainAxisSize.min,
//                           children: <Widget>[
//                             SizedBox(
//                               height: 40.0,
//                             ),
//                             Text(
//                               snapshot.data.data()['groupName'],
//                               style: TextStyle(fontSize: 14.2.sp, fontWeight: FontWeight.w600, color: Colors.white),
//                             ),
//                             SizedBox(
//                               height: 10.0,
//                             ),
//                             Text(
//                               'Created By ~ ${snapshot.data.data()['admin'].split(" ")[0]}',
//                               style: TextStyle(fontSize: 10.9.sp, fontWeight: FontWeight.w500, color: Colors.white70),
//                             ),
//                             (snapshot.data.data()['description'] == null || snapshot.data.data()['description'] == "")
//                                 ? SizedBox()
//                                 : Padding(
//                                     padding: const EdgeInsets.only(top: 4.0),
//                                     child: ExpandableText(
//                                       snapshot.data.data()['description'].toString(),
//                                       style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w500, color: Colors.white70),
//                                       animation: true,
//                                       expandText: "Read more",
//                                       collapseOnTextTap: true,
//                                       linkStyle: TextStyle(fontSize: 11.7.sp, fontWeight: FontWeight.w400, color: Theme.of(context).colorScheme.secondary),
//                                       linkEllipsis: false,
//                                     ),
//                                   ),
//                             Align(
//                               alignment: Alignment.centerLeft,
//                               child: Padding(
//                                 padding: EdgeInsets.fromLTRB(18, 20, 18, 2),
//                                 child: Text("${snapshot.data.data()['members'].length} ${snapshot.data.data()['members'].length < 2 ? "participant" : "participants"}",
//                                     style: TextStyle(fontSize: 10.9.sp, fontWeight: FontWeight.w500, color: Colors.white70)),
//                               ),
//                             ),
//                             Align(
//                               alignment: Alignment.centerLeft,
//                               child: SizedBox(
//                                 height: 90,
//                                 child: ListView.builder(
//                                     shrinkWrap: true,
//                                     physics: ScrollPhysics(),
//                                     padding: EdgeInsets.symmetric(horizontal: 18),
//                                     scrollDirection: Axis.horizontal,
//                                     itemCount: snapshot.data.data()['members'].length,
//                                     itemBuilder: (context, index) {
//                                       return SizedBox(
//                                         height: 90,
//                                         width: 75,
//                                         child: Column(
//                                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                           children: [
//                                             FutureBuilder(
//                                                 future: DatabaseService().getUsersDetails(snapshot.data.data()['members'][index].split("_")[0]),
//                                                 builder: (context, snapshot1) {
//                                                   if (snapshot1.hasData) {
//                                                     return CircleAvatar(
//                                                       radius: 20,
//                                                       backgroundColor: MateColors.activeIcons,
//                                                       backgroundImage: NetworkImage(
//                                                         snapshot1.data.data()['photoURL'],
//                                                       ),
//                                                     );
//                                                   } else
//                                                     return CircleAvatar(
//                                                       radius: 20,
//                                                       backgroundColor: MateColors.activeIcons,
//                                                       child: Text(
//                                                         snapshot.data.data()['members'][index].split('_')[1].substring(0, 1),
//                                                         style: TextStyle(color: Colors.white, fontSize: 12.5.sp),
//                                                       ),
//                                                     );
//                                                 }),
//                                             Text(
//                                               user.uid == snapshot.data.data()['members'][index].split("_")[0] ? "You" : snapshot.data.data()['members'][index].split("_")[1].split(" ")[0],
//                                               style: TextStyle(fontSize: 11.7.sp, fontWeight: FontWeight.w500, color: Colors.white),
//                                               overflow: TextOverflow.ellipsis,
//                                             ),
//                                           ],
//                                         ),
//                                       );
//                                     }),
//                               ),
//                             ),
//                             SizedBox(
//                               height: 8,
//                             ),
//                             Divider(
//                               height: 1,
//                               thickness: 1,
//                               color: MateColors.line,
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 InkWell(
//                                   splashColor: Colors.transparent,
//                                   highlightColor: Colors.transparent,
//                                   onTap: () {
//                                     Navigator.pop(context);
//                                   },
//                                   child: Text(
//                                     'CANCEL',
//                                     style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w500, color: MateColors.activeIcons),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   height: 60,
//                                   width: 25,
//                                 ),
//                                 isUserExist ? InkWell(
//                                   splashColor: Colors.transparent,
//                                   highlightColor: Colors.transparent,
//                                   onTap: () {
//                                     Navigator.pushReplacement(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) => ChatPage(
//                                               groupId: groupId,
//                                               userName: Provider.of<AuthUserProvider>(context, listen: false).authUser.displayName,
//                                               groupName: snapshot.data.data()['groupName'],
//                                             )));
//                                   },
//                                   child: Text(
//                                     'MESSAGE',
//                                     style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w500, color: MateColors.activeIcons),
//                                   ),
//                                 ):
//                                 InkWell(
//                                   splashColor: Colors.transparent,
//                                   highlightColor: Colors.transparent,
//                                   onTap: () {
//                                     DatabaseService(uid: user.uid).userGroupJoin(groupId, snapshot.data.data()['groupName'], Provider.of<AuthUserProvider>(context, listen: false).authUser.displayName).then((value)
//                                     {
//                                       Fluttertoast.showToast(msg: " Successfully joined the group \'${snapshot.data.data()['groupName']}\' ", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
//                                                 Navigator.of(context).pushReplacement(MaterialPageRoute(
//                                                     builder: (context) => ChatPage(
//                                                           groupId: groupId,
//                                                           userName: Provider.of<AuthUserProvider>(context, listen: false).authUser.displayName,
//                                                           groupName: snapshot.data.data()['groupName'],
//                                                           photoURL: snapshot.data.data()['groupIcon'],
//                                                         )));
//                                               });
//                                   },
//                                   child: Text(
//                                     'JOIN',
//                                     style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w500, color: MateColors.activeIcons),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   height: 60,
//                                   width: 18,
//                                 ),
//                               ],
//                             )
//                             // SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
//                           ],
//                         ),
//                         Positioned(
//                           top: -30,
//                           left: MediaQuery.of(context).size.width / 2 - 30,
//                           child: CircleAvatar(
//                             radius: 30,
//                             backgroundColor: Colors.grey[700],
//                             child: snapshot.data.data()['groupIcon'] == ""
//                                 ? Image.asset(
//                                     "lib/asset/icons/group_icon.png",
//                                     fit: BoxFit.cover,
//                                     height: 28,
//                                     width: 28,
//                                   )
//                                 : Stack(
//                                     children: [
//                                       Center(
//                                         child: CircularProgressIndicator(
//                                           backgroundColor: MateColors.activeIcons,
//                                         ),
//                                       ),
//                                       Container(
//                                         decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(50),
//                                           color: Colors.grey[700],
//                                         ),
//                                         clipBehavior: Clip.hardEdge,
//                                         alignment: Alignment.center,
//                                         // padding: EdgeInsets.only(top: 20),
//                                         child: Image.network(
//                                           snapshot.data.data()['groupIcon'],
//                                           fit: BoxFit.fill,
//                                           height: 60,
//                                           width: 60,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                           ),
//                         ),
//                       ],
//                     );
//                   } else {
//                     return Center(
//                       child: CircularProgressIndicator(
//                         backgroundColor: MateColors.activeIcons,
//                       ),
//                     );
//                   }
//                 });
//           },
//         );
//       },
//     );
//   }
//
//
//
//   // widgets
//   Widget noGroupWidget() {
//     return Container(
//         padding: EdgeInsets.symmetric(horizontal: 25.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
//             GestureDetector(
//                 onTap: () {
//                   _popupDialog(context);
//                 },
//                 child: Icon(Icons.add_circle, color: Colors.grey[700], size: 75.0)),
//             SizedBox(height: 20.0),
//             Text("Tap on the 'add' icon to start a community or find your communities using the search field above.",style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w600, color: Colors.grey[700])),
//           ],
//         ));
//   }
//
//   Widget groupsList() {
//     return Consumer<ChatProvider>(
//       builder: (ctx, chatProvider, _) {
//         print("group chat consumer is called");
//
//         if (chatProvider.groupChatDataFetchLoader && chatProvider.groupChatModelData==null) {
//           return timelineLoader();
//         }
//         else if (chatProvider.error != '') {
//           return Center(
//               child: Container(
//                   color: Colors.red,
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(
//                       '${chatProvider.error}',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   )));
//
//         }else if(chatProvider.groupChatModelData!=null){
//           return chatProvider.groupChatModelData.data.length == 0
//               ? noGroupWidget()
//               : RefreshIndicator(
//             onRefresh: () {
//               return chatProvider.groupChatDataFetch(_user.uid);
//             },
//             child: ListView.builder(
//                 itemCount: chatProvider.groupChatModelData.data.length,
//                 shrinkWrap: true,
//                 itemBuilder: (context, index) {
//                   return GroupTile(
//                     userName: _user.displayName,
//                     groupId:chatProvider.groupChatModelData.data[index].groupId,
//                     unreadMessages: chatProvider.groupChatModelData.data[index].unreadMessages,
//                   currentUserUid: _user.uid,);
//                 }),
//           );
//         }else{
//           return Container();
//         }
//
//
//       },
//     );
//
//
//
//     // return StreamBuilder(
//     //   stream: DatabaseService(uid: _user.uid).getUserGroups(),
//     //   builder: (context, snapshot) {
//     //     if (snapshot.hasData) {
//     //       if (snapshot.data.data()['chat-group'] != null) {
//     //         if (snapshot.data.data()['chat-group'].length != 0) {
//     //           return ListView.builder(
//     //               itemCount: snapshot.data.data()['chat-group'].length,
//     //               shrinkWrap: true,
//     //               itemBuilder: (context, index) {
//     //                 int reqIndex = snapshot.data['chat-group'].length - index - 1;
//     //                 return GroupTile(
//     //                     userName: snapshot.data['displayName'], groupId: _destructureId(snapshot.data['chat-group'][reqIndex]), /*groupName: _destructureName(snapshot.data['chat-group'][reqIndex])*/);
//     //               });
//     //         } else {
//     //           return noGroupWidget();
//     //         }
//     //       } else {
//     //         return noGroupWidget();
//     //       }
//     //     } else {
//     //       return Center(child: CircularProgressIndicator());
//     //     }
//     //   },
//     // );
//   }
//
//   // functions
//   // _getUserAuthAndJoinedGroups() async {
//   //   await HelperFunctions.getUserNameSharedPreference().then((value) {
//   //     setState(() {
//   //       _userName = value;
//   //     });
//   //   });
//   //   print("user id ${_user.uid}");
//   //
//   //   // DatabaseService(uid: _user.uid).getUserGroups().then((snapshots) {
//   //   //   // print(snapshots);
//   //   //   setState(() {
//   //   //     _groups = snapshots;
//   //   //   });
//   //   // });
//   //   await HelperFunctions.getUserEmailSharedPreference().then((value) {
//   //     setState(() {
//   //       _email = value;
//   //     });
//   //   });
//   // }
//
//   String _destructureId(String res) {
//     // print(res.substring(0, res.indexOf('_')));
//     return res.substring(0, res.indexOf('_'));
//   }
//
//   String _destructureName(String res, {photoURL}) {
//     // print(res.substring(res.indexOf('_') + 1));
//     return res.substring(res.indexOf('_') + 1);
//   }
//
//   void _popupDialog(BuildContext context) {
//     // Widget cancelButton = FlatButton(
//     //   child: Text("Cancel", style: TextStyle(fontSize: 12.5.sp, fontFamily: 'Quicksand', fontWeight: FontWeight.w500, color: MateColors.activeIcons)),
//     //   onPressed: () {
//     //     Navigator.of(context).pop();
//     //   },
//     // );
//     // Widget createButton = FlatButton(
//     //   child: Text("Create", style: TextStyle(fontSize: 12.5.sp, fontFamily: 'Quicksand', fontWeight: FontWeight.w500, color: MateColors.activeIcons)),
//     //   onPressed: () async {
//     //     if (_groupName != null || _groupName != "" || _groupMaxMember > 1) {
//     //       await HelperFunctions.getUserNameSharedPreference().then((val) {
//     //         // DatabaseService(uid: _user.uid).createGroup(val, _groupName, _groupMaxMember<1?100:_groupMaxMember);
//     //       });
//     //       Navigator.of(context).pop();
//     //     }
//     //   },
//     // );
//     //
//     // AlertDialog alert = AlertDialog(
//     //   backgroundColor: myHexColor,
//     //   title: Text("Create a group", style: TextStyle(fontSize: 18.0, fontFamily: 'Quicksand', fontWeight: FontWeight.w600, color: MateColors.activeIcons)),
//     //   content: Column(
//     //     mainAxisSize: MainAxisSize.min,
//     //     children: [
//     //       TextFormField(
//     //         style: TextStyle(fontSize: 15.0, height: 2.0, color: Colors.white),
//     //         cursorColor: MateColors.activeIcons,
//     //         onChanged: (val) {
//     //           _groupName = val;
//     //         },
//     //         decoration: InputDecoration(
//     //           labelText: "Group Name",
//     //           contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
//     //           enabledBorder: OutlineInputBorder(
//     //             borderSide: const BorderSide(color: Colors.grey, width: 0.3),
//     //             borderRadius: BorderRadius.circular(15.0),
//     //           ),
//     //
//     //           labelStyle: TextStyle(color: Colors.white, fontSize: 15),
//     //           // fillColor: MateColors.activeIcons,
//     //
//     //           focusedBorder: OutlineInputBorder(
//     //             borderSide: const BorderSide(color: Colors.grey, width: 0.3),
//     //             borderRadius: BorderRadius.circular(15.0),
//     //           ),
//     //         ),
//     //       ),
//     //       SizedBox(
//     //         height: 10,
//     //       ),
//     //       TextFormField(
//     //         style: TextStyle(fontSize: 15.0, height: 2.0, color: Colors.white),
//     //         keyboardType: TextInputType.number,
//     //         inputFormatters: <TextInputFormatter>[
//     //           FilteringTextInputFormatter.allow(RegExp("[0-9]")),
//     //           LengthLimitingTextInputFormatter(2),
//     //         ],
//     //         cursorColor: MateColors.activeIcons,
//     //         onChanged: (val) {
//     //           _groupMaxMember = int.parse(val);
//     //         },
//     //         decoration: InputDecoration(
//     //           labelText: "Max Participant Number",
//     //           contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
//     //           enabledBorder: OutlineInputBorder(
//     //             borderSide: const BorderSide(color: Colors.grey, width: 0.3),
//     //             borderRadius: BorderRadius.circular(15.0),
//     //           ),
//     //
//     //           labelStyle: TextStyle(color: Colors.white, fontSize: 15),
//     //           // fillColor: MateColors.activeIcons,
//     //
//     //           focusedBorder: OutlineInputBorder(
//     //             borderSide: const BorderSide(color: Colors.grey, width: 0.3),
//     //             borderRadius: BorderRadius.circular(15.0),
//     //           ),
//     //         ),
//     //       ),
//     //       /*Theme(
//     //         data: ThemeData(
//     //           unselectedWidgetColor: MateColors.inActiveIcons, // Your color
//     //         ),
//     //         child: RadioListTile(
//     //           activeColor: MateColors.activeIcons,
//     //           title: Text(
//     //             "Public",
//     //             style: TextStyle(
//     //               fontSize: 15,
//     //               color: Colors.white70,
//     //               fontWeight: FontWeight.w500,
//     //             ),
//     //           ),
//     //           value: false,
//     //           groupValue: isPrivate,
//     //           onChanged: (value) {
//     //             setState(() {
//     //               isPrivate = value;
//     //               print(isPrivate);
//     //             });
//     //           },
//     //         ),
//     //       ),
//     //       Theme(
//     //         data: ThemeData(
//     //           unselectedWidgetColor: MateColors.inActiveIcons, // Your color
//     //         ),
//     //         child: RadioListTile(
//     //           activeColor: MateColors.activeIcons,
//     //           title: Text(
//     //             "Private",
//     //             style: TextStyle(
//     //               fontSize: 15,
//     //               color: Colors.white70,
//     //               fontWeight: FontWeight.w500,
//     //             ),
//     //           ),
//     //           value: true,
//     //           groupValue: isPrivate,
//     //           onChanged: (value) {
//     //             setState(() {
//     //               isPrivate = value;
//     //               print(isPrivate);
//     //             });
//     //           },
//     //         ),
//     //       ),*/
//     //     ],
//     //   ),
//     //   /*TextFormField(
//     //       cursorColor: Colors.cyanAccent,
//     //     decoration: InputDecoration(
//     //       labelText: "Group Name",
//     //       labelStyle: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w100, color: Colors.grey[50]),
//     //     ),
//     //     onChanged: (val) {
//     //       _groupName = val;
//     //     },
//     //     style: TextStyle(
//     //       fontSize: 15.0,
//     //       height: 2.0,
//     //       color: Colors.white
//     //     )
//     //   ),*/
//     //   actions: [
//     //     cancelButton,
//     //     createButton,
//     //   ],
//     // );
//
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return MyDialog(
//           user: _user,
//         );
//       },
//     );
//   }
//
//   // Building the HomePage widget
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       backgroundColor: myHexColor,
//
//       body: Column(
//         children: [
//           Container(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Expanded(child: Align(
//                     alignment: Alignment.centerLeft,
//                     child: _appBarLeading(context)),),
//                 Padding(
//                   padding: const EdgeInsets.only(right: 25.0),
//                   child: InkWell(
//     onTap: () => _popupDialog(context),
//                       child: Image.asset("lib/asset/homePageIcons/create_post@3x.png",width: 30,fit: BoxFit.fitWidth,)),
//                 ),
//
//                 Padding(
//                   padding: const EdgeInsets.only(right: 25.0),
//                   child: InkWell(onTap: (){
//                     Navigator.push(context, MaterialPageRoute(builder: (context) =>
//                         OrbitalChatWebViewPage(pageUrl: "https://app.orbital.chat/discount/redeem/mate_app20",),));
//                   },
//                       child: Icon(Icons.blur_circular_rounded,color: Colors.white,size: 35,)),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(right: 16.0),
//                   child: InkWell(onTap: ()=>Get.to(() => PersonalChatScreen()),
//                       child: Image.asset("lib/asset/homePageIcons/messenger@3x.png",width: 30,fit: BoxFit.fitWidth,)),
//                 ),
//               ],
//             ),
//           ),
//
//           // Container(
//           //   child: Padding(
//           //     padding: const EdgeInsets.only(left: 18.0,right: 12.0),
//           //     child: Row(
//           //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           //       children: [
//           //         Text("My Communities", style: TextStyle(fontSize: 14.2.sp, fontFamily: 'Quicksand', fontWeight: FontWeight.w700, color: MateColors.activeIcons)),
//           //         IconButton(icon: Icon(Icons.blur_circular_rounded,color: MateColors.activeIcons,size: 28,), onPressed: () {
//           //
//           //         },)
//           //       ],
//           //     ),
//           //   ),
//           // ),
//           Container(
//             margin: const EdgeInsets.only(left:20.0,right: 20.0, bottom: 12.0,top: 20),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(35),
//               color: myLightHexColor
//             ),
//             child: TextFormField(
//               readOnly: true,
//               onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchPage())),
//               style: TextStyle(color: Colors.white, fontSize: 13.0),
//               cursorColor: MateColors.activeIcons,
//               decoration: InputDecoration(
//
//                 prefixIcon: Icon(
//                   Icons.search,
//                   color: Colors.grey[50],
//                   size: 25,
//                 ),
//                 hintText: "Search",
//                 contentPadding: EdgeInsets.symmetric(vertical: -5),
//                 enabledBorder: OutlineInputBorder(
//                   borderSide: const BorderSide(color: Colors.grey, width: 0.3),
//                   borderRadius: BorderRadius.circular(35.0),
//                 ),
//
//                 hintStyle: searchBoxTextStyle,
//                 // fillColor: MateColors.activeIcons,
//
//                 focusedBorder: OutlineInputBorder(
//                   borderSide: const BorderSide(color: Colors.grey, width: 0.3),
//                   borderRadius: BorderRadius.circular(35.0),
//                 ),
//               ),
//             ),
//           ),
//           Expanded(child: groupsList()),
//         ],
//       ),
//     );
//   }
// }
//
// class MyDialog extends StatefulWidget {
//   final User user;
//
//   const MyDialog({Key key, this.user}) : super(key: key);
//
//   @override
//   State createState() => new MyDialogState();
// }
//
// class MyDialogState extends State<MyDialog> {
//   String _groupName;
//   int _groupMaxMember = 50;
//   bool isPrivate = false;
//
//   Widget build(BuildContext context) {
//     return new SimpleDialog(
//       backgroundColor: myHexColor,
//       title: Text("Create a group", style: TextStyle(fontSize: 14.2.sp, fontFamily: 'Quicksand', fontWeight: FontWeight.w600, color: MateColors.activeIcons)),
//       contentPadding: EdgeInsets.all(10),
//       children: <Widget>[
//         Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 7.0),
//               child: TextFormField(
//                 style: TextStyle(fontSize: 12.5.sp, height: 2.0, color: Colors.white),
//                 cursorColor: MateColors.activeIcons,
//                 onChanged: (val) {
//                   _groupName = val;
//                 },
//                 decoration: InputDecoration(
//                   labelText: "Group Name",
//                   contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: const BorderSide(color: Colors.grey, width: 0.3),
//                     borderRadius: BorderRadius.circular(15.0),
//                   ),
//
//                   labelStyle: TextStyle(color: Colors.white, fontSize: 12.0.sp),
//                   // fillColor: MateColors.activeIcons,
//
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: const BorderSide(color: Colors.grey, width: 0.3),
//                     borderRadius: BorderRadius.circular(15.0),
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 7.0),
//               child: TextFormField(
//                 style: TextStyle(fontSize: 12.5.sp, height: 2.0, color: Colors.white),
//                 keyboardType: TextInputType.number,
//                 inputFormatters: <TextInputFormatter>[
//                   FilteringTextInputFormatter.allow(RegExp("[0-9]")),
//                   LengthLimitingTextInputFormatter(2),
//                 ],
//                 cursorColor: MateColors.activeIcons,
//                 onChanged: (val) {
//                   _groupMaxMember = int.parse(val);
//                 },
//                 decoration: InputDecoration(
//                   labelText: "Max Participant Number",
//                   contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
//                   enabledBorder: OutlineInputBorder(
//                     borderSide: const BorderSide(color: Colors.grey, width: 0.3),
//                     borderRadius: BorderRadius.circular(15.0),
//                   ),
//
//                   labelStyle: TextStyle(color: Colors.white, fontSize: 12.0.sp),
//                   // fillColor: MateColors.activeIcons,
//
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: const BorderSide(color: Colors.grey, width: 0.3),
//                     borderRadius: BorderRadius.circular(15.0),
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             Theme(
//               data: ThemeData(
//                 unselectedWidgetColor: MateColors.inActiveIcons, // Your color
//               ),
//               child: RadioListTile(
//                 activeColor: MateColors.activeIcons,
//                 contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
//                 title: Text(
//                   "Public",
//                   style: TextStyle(
//                     fontSize: 12.5.sp,
//                     color: Colors.white70,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 value: false,
//                 groupValue: isPrivate,
//                 onChanged: (value) {
//                   setState(() {
//                     isPrivate = value;
//                     print(isPrivate);
//                   });
//                 },
//               ),
//             ),
//             Theme(
//               data: ThemeData(
//                 unselectedWidgetColor: MateColors.inActiveIcons, // Your color
//               ),
//               child: RadioListTile(
//                 activeColor: MateColors.activeIcons,
//                 contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
//                 title: Text(
//                   "Private",
//                   style: TextStyle(
//                     fontSize: 12.5.sp,
//                     color: Colors.white70,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 value: true,
//                 groupValue: isPrivate,
//                 onChanged: (value) {
//                   setState(() {
//                     isPrivate = value;
//                     print(isPrivate);
//                   });
//                 },
//               ),
//             ),
//           ],
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             FlatButton(
//               child: Text("Cancel", style: TextStyle(fontSize: 12.5.sp, fontFamily: 'Quicksand', fontWeight: FontWeight.w500, color: MateColors.activeIcons)),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             FlatButton(
//               child: Text("Create", style: TextStyle(fontSize: 12.5.sp, fontFamily: 'Quicksand', fontWeight: FontWeight.w500, color: MateColors.activeIcons)),
//               onPressed: () async {
//                 if (_groupName != null && _groupName.isNotEmpty && _groupMaxMember > 1) {
//                   // await HelperFunctions.getUserNameSharedPreference().then((val) {
//                   //   DatabaseService(uid: widget.user.uid).createGroup(val, _groupName, _groupMaxMember<1?100:_groupMaxMember,isPrivate);
//                   // });
//                   DatabaseService(uid: widget.user.uid).createGroup(Provider.of<AuthUserProvider>(context, listen: false).authUser.displayName, widget.user.uid, _groupName, _groupMaxMember < 1 ? 100 : _groupMaxMember, isPrivate).then((value) {
//                    Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => ChatPage(
//                               groupId: value,
//                               userName: Provider.of<AuthUserProvider>(context, listen: false).authUser.displayName,
//                               groupName: _groupName,
//                             )));
//                   });
//
//                   // Navigator.of(context).pop();
//                 } else {
//                   Fluttertoast.showToast(msg: " Please fill all fields ", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
//                 }
//               },
//             )
//           ],
//         ),
//       ],
//     );
//   }
// }


import 'package:get/get.dart';
import 'package:mate_app/Providers/AuthUserProvider.dart';
import 'package:mate_app/Utility/Utility.dart';
import 'package:mate_app/asset/Colors/MateColors.dart';
import 'package:mate_app/groupChat/services/dynamicLinkService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mate_app/groupChat/pages/chat_page.dart';
import 'package:mate_app/groupChat/pages/search_page.dart';
import 'package:mate_app/groupChat/services/auth_service.dart';
import 'package:mate_app/groupChat/services/database_service.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../Providers/chatProvider.dart';
import '../../Widget/Drawer/DrawerWidget.dart';
import '../../Widget/Loaders/Shimmer.dart';
import '../../controller/theme_controller.dart';

class GroupHomePage extends StatefulWidget {
  final String groupId;

  const GroupHomePage({Key key, this.groupId}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<GroupHomePage> with TickerProviderStateMixin{
  ThemeController themeController = Get.find<ThemeController>();
  final AuthService _auth = AuthService();
  User _user;
  String _groupName;
  int _groupMaxMember = 100;
  String _userName = '';
  String _email = '';
  Stream _groups;
  bool isPrivate = false;
  bool firstChat = true;




  TabController _tabController;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // initState
  @override
  initState() {
    super.initState();
    _tabController = new TabController(length: 2, vsync: this);
    _user = FirebaseAuth.instance.currentUser;
    print("////////////${_user.uid}/////////////////////");
    // _getUserAuthAndJoinedGroups();
    Future.delayed(Duration.zero,() {
      Provider.of<ChatProvider>(context,listen: false).groupChatDataFetch(_user.uid);
    },);
    if (widget.groupId != null && isDynamicLinkHit) {
      DatabaseService(uid: _user.uid).getUserExistGroup(widget.groupId, _user.uid, Provider.of<AuthUserProvider>(context, listen: false).authUser.displayName).then((value) => modalSheet(widget.groupId, _user, value));
    }
  }
  Widget _appBarLeading(BuildContext context) {
    return Selector<AuthUserProvider, String>(
        selector: (ctx, authUserProvider) => authUserProvider.authUserPhoto,
        builder: (ctx, data, _) {
          return Padding(
            padding:  EdgeInsets.only(left: 12.0.sp),
            child: InkWell(
                onTap: () {
                  // Scaffold.of(ctx).openDrawer();
                  _key.currentState.openDrawer();
                },
                child: CircleAvatar(
                  backgroundColor: MateColors.activeIcons,
                  radius: 16,
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 16,
                    backgroundImage: NetworkImage(data),
                    // child: ClipOval(
                    //     child: Image.network(
                    //       data,
                    //     )
                    // ),
                  ),
                )
            ),
          );
        });
  }

  modalSheet(String groupId, User user, bool isUserExist) {
    isDynamicLinkHit=false;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: myHexColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15.0),
        ),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return StreamBuilder<DocumentSnapshot>(
                stream: DatabaseService().getGroupDetails(groupId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Stack(
                      // overflow: Overflow.visible,
                      clipBehavior: Clip.none,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SizedBox(
                              height: 40.0,
                            ),
                            Text(
                              snapshot.data['groupName'],
                              style: TextStyle(fontSize: 14.2.sp, fontWeight: FontWeight.w600, color: Colors.white),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              'Created By ~ ${snapshot.data['admin'].split(" ")[0]}',
                              style: TextStyle(fontSize: 10.9.sp, fontWeight: FontWeight.w500, color: Colors.white70),
                            ),
                            (snapshot.data['description'] == null || snapshot.data['description'] == "")
                                ? SizedBox()
                                : Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: ExpandableText(
                                snapshot.data['description'].toString(),
                                style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w500, color: Colors.white70),
                                animation: true,
                                expandText: "Read more",
                                collapseOnTextTap: true,
                                linkStyle: TextStyle(fontSize: 11.7.sp, fontWeight: FontWeight.w400, color: Theme.of(context).colorScheme.secondary),
                                linkEllipsis: false,
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(18, 20, 18, 2),
                                child: Text("${snapshot.data['members'].length} ${snapshot.data['members'].length < 2 ? "participant" : "participants"}",
                                    style: TextStyle(fontSize: 10.9.sp, fontWeight: FontWeight.w500, color: Colors.white70)),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: SizedBox(
                                height: 90,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: ScrollPhysics(),
                                    padding: EdgeInsets.symmetric(horizontal: 18),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: snapshot.data['members'].length,
                                    itemBuilder: (context, index) {
                                      return SizedBox(
                                        height: 90,
                                        width: 75,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            FutureBuilder(
                                                future: DatabaseService().getUsersDetails(snapshot.data['members'][index].split("_")[0]),
                                                builder: (context, snapshot1) {
                                                  if (snapshot1.hasData) {
                                                    return CircleAvatar(
                                                      radius: 20,
                                                      backgroundColor: MateColors.activeIcons,
                                                      backgroundImage: NetworkImage(
                                                        snapshot1.data.data()['photoURL'],
                                                      ),
                                                    );
                                                  } else
                                                    return CircleAvatar(
                                                      radius: 20,
                                                      backgroundColor: MateColors.activeIcons,
                                                      child: Text(
                                                        snapshot.data['members'][index].split('_')[1].substring(0, 1),
                                                        style: TextStyle(color: Colors.white, fontSize: 12.5.sp),
                                                      ),
                                                    );
                                                }),
                                            Text(
                                              user.uid == snapshot.data['members'][index].split("_")[0] ? "You" : snapshot.data['members'][index].split("_")[1].split(" ")[0],
                                              style: TextStyle(fontSize: 11.7.sp, fontWeight: FontWeight.w500, color: Colors.white),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Divider(
                              height: 1,
                              thickness: 1,
                              color: MateColors.line,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'CANCEL',
                                    style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w500, color: MateColors.activeIcons),
                                  ),
                                ),
                                SizedBox(
                                  height: 60,
                                  width: 25,
                                ),
                                isUserExist ? InkWell(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ChatPage(
                                              groupId: groupId,
                                              userName: Provider.of<AuthUserProvider>(context, listen: false).authUser.displayName,
                                              groupName: snapshot.data['groupName'],
                                              memberList : snapshot.data["members"],
                                            )));
                                  },
                                  child: Text(
                                    'MESSAGE',
                                    style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w500, color: MateColors.activeIcons),
                                  ),
                                ):
                                InkWell(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () {
                                    DatabaseService(uid: user.uid).userGroupJoin(groupId, snapshot.data['groupName'], Provider.of<AuthUserProvider>(context, listen: false).authUser.displayName).then((value)
                                    {
                                      Fluttertoast.showToast(msg: " Successfully joined the group \'${snapshot.data['groupName']}\' ", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
                                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                                          builder: (context) => ChatPage(
                                            groupId: groupId,
                                            userName: Provider.of<AuthUserProvider>(context, listen: false).authUser.displayName,
                                            groupName: snapshot.data['groupName'],
                                            photoURL: snapshot.data['groupIcon'],
                                            memberList : snapshot.data["members"],
                                          )));
                                    });
                                  },
                                  child: Text(
                                    'JOIN',
                                    style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w500, color: MateColors.activeIcons),
                                  ),
                                ),
                                SizedBox(
                                  height: 60,
                                  width: 18,
                                ),
                              ],
                            )
                            // SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                          ],
                        ),
                        Positioned(
                          top: -30,
                          left: MediaQuery.of(context).size.width / 2 - 30,
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.grey[700],
                            child: snapshot.data['groupIcon'] == ""
                                ? Image.asset(
                              "lib/asset/icons/group_icon.png",
                              fit: BoxFit.cover,
                              height: 28,
                              width: 28,
                            )
                                : Stack(
                              children: [
                                Center(
                                  child: CircularProgressIndicator(
                                    backgroundColor: MateColors.activeIcons,
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.grey[700],
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                  alignment: Alignment.center,
                                  // padding: EdgeInsets.only(top: 20),
                                  child: Image.network(
                                    snapshot.data['groupIcon'],
                                    fit: BoxFit.fill,
                                    height: 60,
                                    width: 60,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: MateColors.activeIcons,
                      ),
                    );
                  }
                });
          },
        );
      },
    );
  }



  // widgets
  Widget noGroupWidget() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
                onTap: () {
                  _popupDialog(context);
                },
                child: Icon(Icons.add_circle, color: Colors.grey[700], size: 75.0)),
            SizedBox(height: 20.0),
            Text("Tap on the 'add' icon to start a community or find your communities using the search field above.",style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w600, color: Colors.grey[700])),
          ],
        ));
  }

  Widget groupsList() {
    return Consumer<ChatProvider>(
      builder: (ctx, chatProvider, _) {
        print("group chat consumer is called");

        if (chatProvider.groupChatDataFetchLoader && chatProvider.groupChatModelData==null) {
          return timelineLoader();
        }
        else if (chatProvider.error != '') {
          return Center(
              child: Container(
                  color: Colors.red,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${chatProvider.error}',
                      style: TextStyle(color: Colors.white),
                    ),
                  )));

        }else if(chatProvider.groupChatModelData!=null){
          return chatProvider.groupChatModelData.data.length == 0
              ? noGroupWidget()
              : RefreshIndicator(
            onRefresh: () {
              return chatProvider.groupChatDataFetch(_user.uid);
            },
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20,top: 15),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: (){
                          setState(() {
                            firstChat = true;
                          });
                        },
                        child: Container(
                          height: 36.0,
                          width: 135.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: themeController.isDarkMode?firstChat?Colors.white:MateColors.darkDivider:firstChat?MateColors.blackTextColor:MateColors.lightDivider,
                          ),
                          child: Center(
                            child: Text("School Chats",style: TextStyle(fontSize: 14,fontFamily: "Poppins",color: themeController.isDarkMode?firstChat?MateColors.blackTextColor:Colors.white:firstChat?Colors.white:MateColors.blackTextColor),),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      InkWell(
                        onTap: (){
                          setState(() {
                            firstChat = false;
                          });
                        },
                        child: Container(
                          height: 36.0,
                          width: 135.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: themeController.isDarkMode?!firstChat?Colors.white:MateColors.darkDivider:!firstChat?MateColors.blackTextColor:MateColors.lightDivider,
                          ),
                          child: Center(
                            child: Text("Class Chats",style: TextStyle(fontFamily: "Poppins",fontSize: 14,color: themeController.isDarkMode?!firstChat?MateColors.blackTextColor:Colors.white:!firstChat?Colors.white:MateColors.blackTextColor),),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // ListView.builder(
                //     itemCount: chatProvider.groupChatModelData.data.length,
                //     shrinkWrap: true,
                //     itemBuilder: (context, index) {
                //       return GroupTile(
                //         userName: _user.displayName,
                //         groupId:chatProvider.groupChatModelData.data[index].groupId,
                //         unreadMessages: chatProvider.groupChatModelData.data[index].unreadMessages,
                //         currentUserUid: _user.uid,);
                //     }),
                SizedBox(height: 30),
                Expanded(
                  child: ListView.builder(
                    itemCount: 15,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: ScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 25),
                        child: ListTile(
                          dense: true,
                          leading: CircleAvatar(
                            radius: 24,
                            backgroundColor: MateColors.purpleColor,
                            backgroundImage: NetworkImage("https://thumbs.dreamstime.com/z/purple-flower-2212075.jpg"),
                          ),
                          title: Text("Community Name",style: TextStyle(fontFamily: "Poppins",fontSize: 15.0, fontWeight: FontWeight.w500, color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor)),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 3),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("UC Berkeley",style: TextStyle(fontFamily: "Poppins",fontSize: 14.0, fontWeight: FontWeight.w400, color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor)),
                                Text("138 people",style: TextStyle(fontFamily: "Poppins",fontSize: 14.0, fontWeight: FontWeight.w400, color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor)),
                              ],
                            ),
                          ),
                          trailing: Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Image.asset("lib/asset/homePageIcons/addIcon@3x.png",height: 18,width: 18,color: MateColors.activeIcons,),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }else{
          return Container();
        }


      },
    );



    // return StreamBuilder(
    //   stream: DatabaseService(uid: _user.uid).getUserGroups(),
    //   builder: (context, snapshot) {
    //     if (snapshot.hasData) {
    //       if (snapshot.data.data()['chat-group'] != null) {
    //         if (snapshot.data.data()['chat-group'].length != 0) {
    //           return ListView.builder(
    //               itemCount: snapshot.data.data()['chat-group'].length,
    //               shrinkWrap: true,
    //               itemBuilder: (context, index) {
    //                 int reqIndex = snapshot.data['chat-group'].length - index - 1;
    //                 return GroupTile(
    //                     userName: snapshot.data['displayName'], groupId: _destructureId(snapshot.data['chat-group'][reqIndex]), /*groupName: _destructureName(snapshot.data['chat-group'][reqIndex])*/);
    //               });
    //         } else {
    //           return noGroupWidget();
    //         }
    //       } else {
    //         return noGroupWidget();
    //       }
    //     } else {
    //       return Center(child: CircularProgressIndicator());
    //     }
    //   },
    // );
  }

  // functions
  // _getUserAuthAndJoinedGroups() async {
  //   await HelperFunctions.getUserNameSharedPreference().then((value) {
  //     setState(() {
  //       _userName = value;
  //     });
  //   });
  //   print("user id ${_user.uid}");
  //
  //   DatabaseService(uid: _user.uid).getUserGroups().then((snapshots) {
  //     // print(snapshots);
  //     setState(() {
  //       _groups = snapshots;
  //     });
  //   });
  //   await HelperFunctions.getUserEmailSharedPreference().then((value) {
  //     setState(() {
  //       _email = value;
  //     });
  //   });
  // }

  String _destructureId(String res) {
    // print(res.substring(0, res.indexOf('_')));
    return res.substring(0, res.indexOf('_'));
  }

  String _destructureName(String res, {photoURL}) {
    // print(res.substring(res.indexOf('_') + 1));
    return res.substring(res.indexOf('_') + 1);
  }

  void _popupDialog(BuildContext context) {
    // Widget cancelButton = FlatButton(
    //   child: Text("Cancel", style: TextStyle(fontSize: 12.5.sp, fontFamily: 'Quicksand', fontWeight: FontWeight.w500, color: MateColors.activeIcons)),
    //   onPressed: () {
    //     Navigator.of(context).pop();
    //   },
    // );
    // Widget createButton = FlatButton(
    //   child: Text("Create", style: TextStyle(fontSize: 12.5.sp, fontFamily: 'Quicksand', fontWeight: FontWeight.w500, color: MateColors.activeIcons)),
    //   onPressed: () async {
    //     if (_groupName != null || _groupName != "" || _groupMaxMember > 1) {
    //       await HelperFunctions.getUserNameSharedPreference().then((val) {
    //         // DatabaseService(uid: _user.uid).createGroup(val, _groupName, _groupMaxMember<1?100:_groupMaxMember);
    //       });
    //       Navigator.of(context).pop();
    //     }
    //   },
    // );
    //
    // AlertDialog alert = AlertDialog(
    //   backgroundColor: myHexColor,
    //   title: Text("Create a group", style: TextStyle(fontSize: 18.0, fontFamily: 'Quicksand', fontWeight: FontWeight.w600, color: MateColors.activeIcons)),
    //   content: Column(
    //     mainAxisSize: MainAxisSize.min,
    //     children: [
    //       TextFormField(
    //         style: TextStyle(fontSize: 15.0, height: 2.0, color: Colors.white),
    //         cursorColor: MateColors.activeIcons,
    //         onChanged: (val) {
    //           _groupName = val;
    //         },
    //         decoration: InputDecoration(
    //           labelText: "Group Name",
    //           contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
    //           enabledBorder: OutlineInputBorder(
    //             borderSide: const BorderSide(color: Colors.grey, width: 0.3),
    //             borderRadius: BorderRadius.circular(15.0),
    //           ),
    //
    //           labelStyle: TextStyle(color: Colors.white, fontSize: 15),
    //           // fillColor: MateColors.activeIcons,
    //
    //           focusedBorder: OutlineInputBorder(
    //             borderSide: const BorderSide(color: Colors.grey, width: 0.3),
    //             borderRadius: BorderRadius.circular(15.0),
    //           ),
    //         ),
    //       ),
    //       SizedBox(
    //         height: 10,
    //       ),
    //       TextFormField(
    //         style: TextStyle(fontSize: 15.0, height: 2.0, color: Colors.white),
    //         keyboardType: TextInputType.number,
    //         inputFormatters: <TextInputFormatter>[
    //           FilteringTextInputFormatter.allow(RegExp("[0-9]")),
    //           LengthLimitingTextInputFormatter(2),
    //         ],
    //         cursorColor: MateColors.activeIcons,
    //         onChanged: (val) {
    //           _groupMaxMember = int.parse(val);
    //         },
    //         decoration: InputDecoration(
    //           labelText: "Max Participant Number",
    //           contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
    //           enabledBorder: OutlineInputBorder(
    //             borderSide: const BorderSide(color: Colors.grey, width: 0.3),
    //             borderRadius: BorderRadius.circular(15.0),
    //           ),
    //
    //           labelStyle: TextStyle(color: Colors.white, fontSize: 15),
    //           // fillColor: MateColors.activeIcons,
    //
    //           focusedBorder: OutlineInputBorder(
    //             borderSide: const BorderSide(color: Colors.grey, width: 0.3),
    //             borderRadius: BorderRadius.circular(15.0),
    //           ),
    //         ),
    //       ),
    //       /*Theme(
    //         data: ThemeData(
    //           unselectedWidgetColor: MateColors.inActiveIcons, // Your color
    //         ),
    //         child: RadioListTile(
    //           activeColor: MateColors.activeIcons,
    //           title: Text(
    //             "Public",
    //             style: TextStyle(
    //               fontSize: 15,
    //               color: Colors.white70,
    //               fontWeight: FontWeight.w500,
    //             ),
    //           ),
    //           value: false,
    //           groupValue: isPrivate,
    //           onChanged: (value) {
    //             setState(() {
    //               isPrivate = value;
    //               print(isPrivate);
    //             });
    //           },
    //         ),
    //       ),
    //       Theme(
    //         data: ThemeData(
    //           unselectedWidgetColor: MateColors.inActiveIcons, // Your color
    //         ),
    //         child: RadioListTile(
    //           activeColor: MateColors.activeIcons,
    //           title: Text(
    //             "Private",
    //             style: TextStyle(
    //               fontSize: 15,
    //               color: Colors.white70,
    //               fontWeight: FontWeight.w500,
    //             ),
    //           ),
    //           value: true,
    //           groupValue: isPrivate,
    //           onChanged: (value) {
    //             setState(() {
    //               isPrivate = value;
    //               print(isPrivate);
    //             });
    //           },
    //         ),
    //       ),*/
    //     ],
    //   ),
    //   /*TextFormField(
    //       cursorColor: Colors.cyanAccent,
    //     decoration: InputDecoration(
    //       labelText: "Group Name",
    //       labelStyle: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w100, color: Colors.grey[50]),
    //     ),
    //     onChanged: (val) {
    //       _groupName = val;
    //     },
    //     style: TextStyle(
    //       fontSize: 15.0,
    //       height: 2.0,
    //       color: Colors.white
    //     )
    //   ),*/
    //   actions: [
    //     cancelButton,
    //     createButton,
    //   ],
    // );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MyDialog(
          user: _user,
        );
      },
    );
  }
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  // Building the HomePage widget
  @override
  Widget build(BuildContext context) {
    //context.theme;
    return Scaffold(
      key: _key,
      drawer: DrawerWidget(),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 1.0.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: _appBarLeading(context),
                ),
                Text("Communities", style: TextStyle(fontSize: 17, fontFamily: "Poppins",fontWeight: FontWeight.w700, color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor)),
                IconButton(
                  icon: Image.asset("lib/asset/homePageIcons/searchPurple@3x.png",height: 23.7,width: 23.7,color: MateColors.activeIcons,),
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchPage())),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: Container(
              child: Column(
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
                          text: "UC Berkeley",
                        ),
                        Tab(
                          text: "All",
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(controller: _tabController, children: [groupsList(), groupsList(),]),
                  ),
                ],
              ),
            ),
          ),
          // Container(
          //   margin: const EdgeInsets.only(left:20.0,right: 20.0, bottom: 12.0,top: 20),
          //   decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(35),
          //       color: myLightHexColor
          //   ),
          //   child: TextFormField(
          //     readOnly: true,
          //     onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchPage())),
          //     style: TextStyle(color: Colors.white, fontSize: 13.0),
          //     cursorColor: MateColors.activeIcons,
          //     decoration: InputDecoration(
          //
          //       prefixIcon: Icon(
          //         Icons.search,
          //         color: Colors.grey[50],
          //         size: 25,
          //       ),
          //       hintText: "Search",
          //       contentPadding: EdgeInsets.symmetric(vertical: -5),
          //       enabledBorder: OutlineInputBorder(
          //         borderSide: const BorderSide(color: Colors.grey, width: 0.3),
          //         borderRadius: BorderRadius.circular(35.0),
          //       ),
          //
          //       hintStyle: searchBoxTextStyle,
          //       // fillColor: MateColors.activeIcons,
          //
          //       focusedBorder: OutlineInputBorder(
          //         borderSide: const BorderSide(color: Colors.grey, width: 0.3),
          //         borderRadius: BorderRadius.circular(35.0),
          //       ),
          //     ),
          //   ),
          // ),
          //Expanded(child: groupsList()),
        ],
      ),
      floatingActionButton: InkWell(
        onTap: () {
          _popupDialog(context);
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
    );
  }
}

class MyDialog extends StatefulWidget {
  final User user;

  const MyDialog({Key key, this.user}) : super(key: key);

  @override
  State createState() => new MyDialogState();
}

class MyDialogState extends State<MyDialog> {
  String _groupName;
  int _groupMaxMember = 50;
  bool isPrivate = false;

  Widget build(BuildContext context) {
    return new SimpleDialog(
      backgroundColor: myHexColor,
      title: Text("Create a group", style: TextStyle(fontSize: 14.2.sp, fontFamily: 'Quicksand', fontWeight: FontWeight.w600, color: MateColors.activeIcons)),
      contentPadding: EdgeInsets.all(10),
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7.0),
              child: TextFormField(
                style: TextStyle(fontSize: 12.5.sp, height: 2.0, color: Colors.white),
                cursorColor: MateColors.activeIcons,
                onChanged: (val) {
                  _groupName = val;
                },
                decoration: InputDecoration(
                  labelText: "Group Name",
                  contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey, width: 0.3),
                    borderRadius: BorderRadius.circular(15.0),
                  ),

                  labelStyle: TextStyle(color: Colors.white, fontSize: 12.0.sp),
                  // fillColor: MateColors.activeIcons,

                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey, width: 0.3),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7.0),
              child: TextFormField(
                style: TextStyle(fontSize: 12.5.sp, height: 2.0, color: Colors.white),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                  LengthLimitingTextInputFormatter(2),
                ],
                cursorColor: MateColors.activeIcons,
                onChanged: (val) {
                  _groupMaxMember = int.parse(val);
                },
                decoration: InputDecoration(
                  labelText: "Max Participant Number",
                  contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey, width: 0.3),
                    borderRadius: BorderRadius.circular(15.0),
                  ),

                  labelStyle: TextStyle(color: Colors.white, fontSize: 12.0.sp),
                  // fillColor: MateColors.activeIcons,

                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey, width: 0.3),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Theme(
              data: ThemeData(
                unselectedWidgetColor: MateColors.inActiveIcons, // Your color
              ),
              child: RadioListTile(
                activeColor: MateColors.activeIcons,
                contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
                title: Text(
                  "Public",
                  style: TextStyle(
                    fontSize: 12.5.sp,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                value: false,
                groupValue: isPrivate,
                onChanged: (value) {
                  setState(() {
                    isPrivate = value;
                    print(isPrivate);
                  });
                },
              ),
            ),
            Theme(
              data: ThemeData(
                unselectedWidgetColor: MateColors.inActiveIcons, // Your color
              ),
              child: RadioListTile(
                activeColor: MateColors.activeIcons,
                contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
                title: Text(
                  "Private",
                  style: TextStyle(
                    fontSize: 12.5.sp,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                value: true,
                groupValue: isPrivate,
                onChanged: (value) {
                  setState(() {
                    isPrivate = value;
                    print(isPrivate);
                  });
                },
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FlatButton(
              child: Text("Cancel", style: TextStyle(fontSize: 12.5.sp, fontFamily: 'Quicksand', fontWeight: FontWeight.w500, color: MateColors.activeIcons)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Create", style: TextStyle(fontSize: 12.5.sp, fontFamily: 'Quicksand', fontWeight: FontWeight.w500, color: MateColors.activeIcons)),
              onPressed: () async {
                if (_groupName != null && _groupName.isNotEmpty && _groupMaxMember > 1) {
                  // await HelperFunctions.getUserNameSharedPreference().then((val) {
                  //   DatabaseService(uid: widget.user.uid).createGroup(val, _groupName, _groupMaxMember<1?100:_groupMaxMember,isPrivate);
                  // });
                  DatabaseService(uid: widget.user.uid).createGroup(Provider.of<AuthUserProvider>(context, listen: false).authUser.displayName, widget.user.uid, _groupName, _groupMaxMember < 1 ? 100 : _groupMaxMember, isPrivate).then((value) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatPage(
                              groupId: value,
                              userName: Provider.of<AuthUserProvider>(context, listen: false).authUser.displayName,
                              groupName: _groupName,
                              memberList : [Provider.of<AuthUserProvider>(context, listen: false).authUser.firebaseUid],
                            )));
                  });

                  // Navigator.of(context).pop();
                } else {
                  Fluttertoast.showToast(msg: " Please fill all fields ", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
                }
              },
            )
          ],
        ),
      ],
    );
  }
}
