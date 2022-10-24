// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:expandable_text/expandable_text.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:sizer/sizer.dart';
//
// import '../../../Providers/AuthUserProvider.dart';
// import '../../../asset/Colors/MateColors.dart';
// import '../../../controller/theme_controller.dart';
// import '../../../groupChat/pages/chat_page.dart';
// import '../../../groupChat/services/database_service.dart';
// import '../../Profile/ProfileScreen.dart';
// import '../../Profile/UserProfileScreen.dart';
//
// class GroupDetailsBeforeJoiningPage extends StatefulWidget {
//   final String groupId;
//   const GroupDetailsBeforeJoiningPage({Key key,this.groupId}) : super(key: key);
//
//   @override
//   _GroupDetailsBeforeJoiningPageState createState() => _GroupDetailsBeforeJoiningPageState();
// }
//
// class _GroupDetailsBeforeJoiningPageState extends State<GroupDetailsBeforeJoiningPage> {
//   bool isLoading = false;
//   User currentUser = FirebaseAuth.instance.currentUser;
//   ThemeController themeController = Get.find<ThemeController>();
//   final GlobalKey<ScaffoldState> _key = GlobalKey();
//   User _user;
//
//   QuerySnapshot searchResultSnapshot;
//   bool isLoadedGroup = false;
//
//   @override
//   void initState() {
//     _user = FirebaseAuth.instance.currentUser;
//     DatabaseService().getAllGroups().then((snapshot) {
//       searchResultSnapshot = snapshot;
//       setState(() {
//         isLoadedGroup = true;
//       });
//     });
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//       key: _key,
//       body: StreamBuilder<DocumentSnapshot>(
//           stream: DatabaseService().getGroupDetails(widget.groupId),
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               print(snapshot.data.data()['createdAt']);
//               return NestedScrollView(
//                 headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
//                   return <Widget>[
//                     SliverAppBar(
//                       iconTheme: IconThemeData(
//                         color: MateColors.activeIcons,
//                       ),
//                       elevation: 0,
//                       expandedHeight: MediaQuery.of(context).size.height * 0.45,
//                       floating: true,
//                       pinned: true,
//                       // leadingWidth: 100,
//                       flexibleSpace: FlexibleSpaceBar(
//                           collapseMode: CollapseMode.parallax,
//                           titlePadding: EdgeInsetsDirectional.only(start: 55, bottom: 12),
//                           title: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             mainAxisSize: MainAxisSize.min,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     Text(snapshot.data.data()['groupName'], style: TextStyle(fontFamily: "Poppins",color:themeController.isDarkMode?Colors.white:MateColors.blackTextColor, fontSize: 12.5.sp, fontWeight: FontWeight.w500)),
//                                     SizedBox(
//                                       height: 2,
//                                     ),
//                                     Text(
//                                       "Created By ${snapshot.data.data()['admin']} ${snapshot.data.data()['createdAt'] != null ? "on ${DateFormat.yMd().format(DateTime.fromMillisecondsSinceEpoch(int.parse(snapshot.data.data()['createdAt'].toString())))}" : ""}",
//                                       style: TextStyle(
//                                         fontFamily: "Poppins",
//                                         color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
//                                         fontSize: 6.7.sp,
//                                         fontWeight: FontWeight.w400,
//                                       ),
//                                       overflow: TextOverflow.fade,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               // InkWell(
//                               //   radius: 40,
//                               //   onTap: (){
//                               //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => GroupNamePage(groupId: snapshot.data.data()['groupId'], groupName: snapshot.data.data()['groupName'] ?? "",)));
//                               //   },
//                               //   child: Padding(
//                               //     padding: const EdgeInsets.only(right: 8.0, left: 8),
//                               //     child: Icon(Icons.edit,size: 22,color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,),
//                               //   ),
//                               // )
//                             ],
//                           ),
//                           background: Stack(
//                             fit: StackFit.expand,
//                             children: [
//                               InkWell(
//                                 //onTap: () => modalSheetGroupIconChange(snapshot.data.data()['groupIcon'] != ""),
//                                 child: snapshot.data.data()['groupIcon'] != ""
//                                     ? Stack(
//                                   fit: StackFit.expand,
//                                   children: [
//                                     Center(
//                                       child: CircularProgressIndicator(
//                                         backgroundColor: MateColors.activeIcons,
//                                       ),
//                                     ),
//                                     Image.network(
//                                       snapshot.data.data()['groupIcon'],
//                                       fit: BoxFit.fill,
//                                     ),
//                                     Container(
//                                       decoration: BoxDecoration(
//                                           gradient: LinearGradient(colors: [
//                                             Colors.transparent,
//                                             Colors.transparent,
//                                             Colors.transparent,
//                                             Colors.black87,
//                                           ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
//                                     ),
//                                   ],
//                                 )
//                                     : Container(
//                                   alignment: Alignment.center,
//                                   color: Colors.grey[700],
//                                   padding: EdgeInsets.only(top: 20),
//                                   child: Image.asset(
//                                     "lib/asset/icons/group_icon.png",
//                                     fit: BoxFit.cover,
//                                     height: MediaQuery.of(context).size.height * 0.21,
//                                     width: MediaQuery.of(context).size.height * 0.21,
//                                   ),
//                                 ),
//                               ),
//                               Visibility(
//                                 visible: isLoading,
//                                 child: Center(
//                                   child: CircularProgressIndicator(
//                                     backgroundColor: MateColors.activeIcons,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           )),
//                     ),
//                   ];
//                 },
//                 body: ListView(
//                   shrinkWrap: true,
//                   padding: EdgeInsets.only(top: 17),
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.fromLTRB(15,0,15,0),
//                       child: InkWell(
//                         splashColor:  Colors.transparent,
//                         highlightColor: Colors.transparent,
//                         //onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context) => GroupDescriptionPage(groupId: snapshot.data.data()['groupId'], description: snapshot.data.data()['description'] ?? "",))),
//                         child: (snapshot.data.data()['description']==null || snapshot.data.data()['description']=="")?
//                         Text("Group description appears here",
//                           style:  TextStyle(fontSize: 14.2.sp,fontFamily: "Poppins",fontWeight: FontWeight.w500,color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,),
//                         ):
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text("Description",
//                                 style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w500, color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor)),
//                             Padding(
//                               padding: const EdgeInsets.only(top: 4.0),
//                               child: ExpandableText(
//                                 snapshot.data.data()['description'].toString(),
//                                 style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w500,
//                                   color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
//                                 ),
//                                 animation: true,
//                                 expandText: "Read more",
//                                 collapseOnTextTap: true,
//                                 linkStyle: TextStyle(fontSize: 11.7.sp, fontWeight: FontWeight.w400, color: Theme.of(context).colorScheme.secondary),
//                                 linkEllipsis: false,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     Divider(
//                       color: themeController.isDarkMode?MateColors.darkDivider:MateColors.lightDivider,
//                       height: 40,
//                       thickness: 8,
//                     ),
//                     Container(
//                       height: 40,
//                       width: 120,
//                       margin: EdgeInsets.only(left: 16,right: 16,bottom: 16),
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           primary: MateColors.activeIcons,
//                           onPrimary: Colors.white,
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                         ),
//                         onPressed: ()async{
//                           await DatabaseService(uid: _user.uid).togglingGroupJoin(snapshot.data.data()["groupId"], snapshot.data.data()["groupName"].toString(), Provider.of<AuthUserProvider>(context, listen: false).authUser.displayName);
//                           _showScaffold('Successfully joined the group "${snapshot.data.data()["groupName"].toString()}"');
//                           Future.delayed(Duration(milliseconds: 100), () {
//                             Navigator.of(context).pop();
//                             Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatPage(groupId: snapshot.data.data()["groupId"], userName: Provider.of<AuthUserProvider>(context, listen: false).authUser.displayName, groupName: snapshot.data.data()["groupName"].toString())));
//                           });
//                         },
//                         child: Text("Join Group",
//                           style: TextStyle(
//                             color: themeController.isDarkMode?MateColors.blackTextColor:Colors.white,
//                             fontWeight: FontWeight.w700,
//                             fontSize: 15.0,
//                           ),
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.fromLTRB(15,0,15,0),
//                       child: Text("${snapshot.data.data()['members'].length} ${snapshot.data.data()['members'].length<2 ? "participant": "participants"}",
//                           style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w500, color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor )),
//                     ),
//                     ListView.builder(
//                         padding: EdgeInsets.fromLTRB(15,0,15,0),
//                         shrinkWrap: true,
//                         physics: ScrollPhysics(),
//                         itemCount: snapshot.data.data()['members'].length,
//                         itemBuilder: (context, index) {
//                           return Padding(
//                             padding: EdgeInsets.symmetric(vertical: 2.0),
//                             child: FutureBuilder(
//                                 future: DatabaseService().getUsersDetails(snapshot.data.data()['members'][index].split("_")[0]),
//                                 builder: (context, snapshot1) {
//                                   if(snapshot1.hasData){
//                                     return ListTile(
//                                       onTap: (){
//                                         if(snapshot1.data.data()['uuid']!=null){
//                                           if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == snapshot1.data.data()['uuid']) {
//                                             Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
//                                           } else {
//                                             Navigator.of(context).pushNamed(UserProfileScreen.routeName,
//                                                 arguments: {"id": snapshot1.data.data()['uuid'],
//                                                   "name": snapshot1.data.data()['displayName'],
//                                                   "photoUrl": snapshot1.data.data()['photoURL'],
//                                                   "firebaseUid": snapshot1.data.data()['uid']
//                                                 });
//                                           }
//                                         }
//                                       },
//                                       leading:
//                                       snapshot1.data.data()['photoURL']!=null?
//                                       CircleAvatar(
//                                         radius: 24,
//                                         backgroundColor: MateColors.activeIcons,
//                                         backgroundImage: NetworkImage(
//                                           snapshot1.data.data()['photoURL'],
//                                         ),
//                                       ): CircleAvatar(
//                                         radius: 24,
//                                         backgroundColor: MateColors.activeIcons,
//                                         child: Text(snapshot.data.data()['members'][index].split('_')[1].substring(0,1),style: TextStyle(color: themeController.isDarkMode?Colors.black:Colors.white),),
//                                       ),
//                                       contentPadding: EdgeInsets.only(top: 5),
//                                       title: Text(currentUser.uid==snapshot1.data.data()['uid']?"You":snapshot1.data.data()['displayName'], style: TextStyle(fontFamily: "Poppins",fontSize: 15.0, fontWeight: FontWeight.w500, color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor),),
//                                     );
//                                   }
//                                   else if(snapshot1.connectionState == ConnectionState.waiting){
//                                     return SizedBox(
//                                       height: 50,
//                                       child: Center(
//                                         child: LinearProgressIndicator(
//                                           color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
//                                           //backgroundColor: myHexColor,
//                                           // strokeWidth: 1.2,
//                                           minHeight: 3,
//                                         ),
//                                       ),
//                                     );
//                                   }
//                                   return SizedBox();
//
//                                 }
//                             ),
//
//
//
//                           );
//                         }),
//                     if(isLoadedGroup)
//                     Padding(
//                       padding: EdgeInsets.fromLTRB(15,20,15,0),
//                       child: Text("Group you may be interested in",
//                           style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w500, color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor )),
//                     ),
//                     if(isLoadedGroup)
//                       ListView.builder(
//                         shrinkWrap: true,
//                         physics: ScrollPhysics(),
//                         itemCount: searchResultSnapshot.docs.length,
//                         itemBuilder: (context, index) {
//                           if(searchResultSnapshot.docs[index].data()["isPrivate"] != null){
//                             if(searchResultSnapshot.docs[index].data()["isPrivate"] == false && !searchResultSnapshot.docs[index].data()["members"].contains(_user.uid + '_' + _user.displayName)){
//                               if(searchResultSnapshot.docs[index]["maxParticipantNumber"] != null ? searchResultSnapshot.docs[index].data()["members"].length < searchResultSnapshot.docs[index].data()["maxParticipantNumber"]:false){
//                                 if(searchResultSnapshot.docs[index].data()["groupName"].toString().contains(snapshot.data.data()['groupName'][0]) || searchResultSnapshot.docs[index].data()["admin"].toString().contains(snapshot.data.data()['admin'])){
//                                   return groupTile(
//                                       Provider.of<AuthUserProvider>(context, listen: false).authUser.displayName,
//                                       searchResultSnapshot.docs[index].data()["groupId"],
//                                       searchResultSnapshot.docs[index].data()["groupName"].toString(),
//                                       searchResultSnapshot.docs[index].data()["admin"],
//                                       searchResultSnapshot.docs[index].data()["members"].length,
//                                       searchResultSnapshot.docs[index].data()["maxParticipantNumber"],
//                                       searchResultSnapshot.docs[index].data()["isPrivate"],
//                                       searchResultSnapshot.docs[index].data()["members"].contains(_user.uid + '_' + _user.displayName),
//                                       searchResultSnapshot.docs[index].data()["groupIcon"]
//                                   );
//                                 }else{
//                                   return Container();
//                                 }
//                               }else{
//                                 return Container();
//                               }
//                             }else{
//                               return Container();
//                             }
//                           }else{
//                             return Container();
//                           }
//                         },
// //                       ),
//                   ],
//                 ),
//               );
//             } else
//               return Center(child: Text("Oops! Something went wrong! \nplease trey again..", style: TextStyle(fontSize: 10.9.sp)));
//           }),
//     );
//   }
//   void _showScaffold(String message) {
//     _key.currentState.showSnackBar(SnackBar(
//       backgroundColor: Colors.black,
//       duration: Duration(milliseconds: 1500),
//       content: Text(message, textAlign: TextAlign.center, style: TextStyle(fontSize: 13.0, color: MateColors.activeIcons)),
//     ));
//   }
//   Widget groupTile(String userName, String groupId, String groupName, String admin, int totalParticipant, int maxParticipant, bool isPrivate, bool _isJoined, String imageURL)
//   {
//     // _joinValueInGroup(userName, groupId, groupName, admin);
//     return ListTile(
//       dense: true,
//       contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
//       leading: imageURL!=""?
//       CircleAvatar(
//         radius: 24,
//         backgroundColor: MateColors.activeIcons,
//         backgroundImage: NetworkImage(imageURL),
//       ):CircleAvatar(
//         radius: 24,
//         backgroundColor: MateColors.activeIcons,
//         child: Text(groupName.toLowerCase().substring(0, 1).toUpperCase(), textAlign: TextAlign.center,
//           style: TextStyle(color: themeController.isDarkMode?Colors.black:Colors.white, fontSize: 12.5.sp, fontWeight: FontWeight.bold),
//         ),
//       ),
//       title: Text(
//         groupName,
//         style: TextStyle(fontFamily: "Poppins",fontSize: 15.0, fontWeight: FontWeight.w500, color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor),
//       ),
//       subtitle: Padding(
//         padding: const EdgeInsets.only(top: 3),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               admin,
//               style: TextStyle(fontFamily: "Poppins",fontSize: 14.0, fontWeight: FontWeight.w400, color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor),
//               overflow: TextOverflow.clip,
//             ),
//             Text(
//               "${totalParticipant} people",
//               style: TextStyle(fontFamily: "Poppins",fontSize: 14.0, fontWeight: FontWeight.w400, color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor),
//               overflow: TextOverflow.clip,
//             ),
//           ],
//         ),
//       ),
//       trailing: InkWell(
//         onTap: () async {
//           if(_isJoined){
//             Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatPage(groupId: groupId, userName: userName, groupName: groupName)));
//           }
//           else if (maxParticipant != null ? totalParticipant < maxParticipant : true) {
//             await DatabaseService(uid: _user.uid).togglingGroupJoin(groupId, groupName, userName);
//             // await DatabaseService(uid: _user.uid).userJoinGroup(groupId, groupName, userName);
//             _showScaffold('Successfully joined the group "$groupName"');
//             Future.delayed(Duration(milliseconds: 100), () {
//               Navigator.of(context).pop();
//               Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatPage(groupId: groupId, userName: userName, groupName: groupName)));
//             });
//           }
//         },
//         child: _isJoined ?
//         Container(
//           decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), border: Border.all(color: MateColors.activeIcons, width: 0.6)),
//           padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
//           child: Text('Message', style: TextStyle(color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor, fontWeight: FontWeight.w500,fontSize: 12)),
//         ) :
//         Visibility(
//           visible: maxParticipant != null ? totalParticipant < maxParticipant : true,
//           replacement: Container(
//               decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), border: Border.all(color: Colors.transparent, width: 0.6)),
//               padding: EdgeInsets.symmetric(vertical: 8.0),
//               child: Text('Group Full', style: TextStyle(fontFamily: "Poppins",color: Colors.red, fontWeight: FontWeight.w500))),
//           child: Image.asset("lib/asset/homePageIcons/addIcon@3x.png",height: 18,width: 18,color: MateColors.activeIcons,),
//           // Container(
//           //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), border: Border.all(color: MateColors.activeIcons, width: 0.6)),
//           //   padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 8.0),
//           //   child: Text('Join', style: TextStyle(color: MateColors.activeIcons, fontWeight: FontWeight.w500)),
//           // ),
//         ),
//       ),
//     );
//   }
// }
