// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:mate_app/Screen/chatDashboard/new_message.dart';
// import 'package:mate_app/Screen/chatDashboard/search_group.dart';
// import 'package:mate_app/Screen/chatDashboard/search_person.dart';
// import 'package:provider/provider.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:sizer/sizer.dart';
//
// import '../../Providers/AuthUserProvider.dart';
// import '../../Providers/chatProvider.dart';
// import '../../Widget/Drawer/DrawerWidget.dart';
// import '../../Widget/Loaders/Shimmer.dart';
// import '../../asset/Colors/MateColors.dart';
// import '../../controller/theme_controller.dart';
// import '../../groupChat/services/database_service.dart';
// import '../../groupChat/widgets/group_tile.dart';
// import '../chat1/screens/chat.dart';
//
// class ChatDashboard extends StatefulWidget {
//   static final String routeName = '/chatDashboard';
//
//   @override
//   _ChatDashboardState createState() => _ChatDashboardState();
// }
//
// class _ChatDashboardState extends State<ChatDashboard> with TickerProviderStateMixin {
//   ThemeController themeController = Get.find<ThemeController>();
//   final GlobalKey<ScaffoldState> _key = GlobalKey();
//   TabController _tabController;
//   int _selectedIndex = 0;
//
//   ///Personal chat
//   User _user = FirebaseAuth.instance.currentUser;
//   String personChatId;
//
//   @override
//   void initState() {
//     _tabController = new TabController(length: 2, vsync: this);
//     _tabController.addListener(() {
//       setState(() {
//         _selectedIndex = _tabController.index;
//       });
//       print("Selected Index: " + _tabController.index.toString());
//     });
//
//     ///personal chat
//     Future.delayed(Duration.zero, () {
//       Provider.of<ChatProvider>(context, listen: false).personalChatDataFetch(_user.uid);
//     });
//
//     ///group
//     Future.delayed(Duration.zero,() {
//       Provider.of<ChatProvider>(context,listen: false).groupChatDataFetch(_user.uid);
//     },);
//     // if (widget.groupId != null && isDynamicLinkHit) {
//     //   DatabaseService(uid: _user.uid).getUserExistGroup(widget.groupId, _user.uid, Provider.of<AuthUserProvider>(context, listen: false).authUser.displayName).then((value) => modalSheet(widget.groupId, _user, value));
//     // }
//
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   loadData()async{
//     ///personal chat
//     Future.delayed(Duration.zero, () {
//       Provider.of<ChatProvider>(context, listen: false).personalChatDataFetch(_user.uid);
//     });
//
//     ///group
//     Future.delayed(Duration.zero,() {
//       Provider.of<ChatProvider>(context,listen: false).groupChatDataFetch(_user.uid);
//     },);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _key,
//       drawer: DrawerWidget(),
//       appBar: AppBar(
//         elevation: 0,
//         leading: _appBarLeading(context),
//         iconTheme: IconThemeData(
//           color: MateColors.activeIcons,
//         ),
//         actions: [
//           InkWell(
//             onTap: ()async{
//               if(_tabController.index==1){
//                 Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SearchPerson()));
//               }else{
//                 await Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SearchGroup()));
//                 loadData();
//               }
//             },
//             child: Padding(
//               padding: const EdgeInsets.only(right: 20),
//               child: Image.asset(
//                 "lib/asset/homePageIcons/searchPurple@3x.png",
//                 height: 23.7,
//                 width: 23.7,
//                 color: MateColors.activeIcons,
//               ),
//             ),
//           ),
//         ],
//         title: Text(
//           "Messages",
//           style: TextStyle(
//             color: themeController.isDarkMode ? Colors.white : MateColors.blackTextColor,
//             fontWeight: FontWeight.w700,
//             fontSize: 17.0,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       floatingActionButton: _selectedIndex == 1 ?
//       InkWell(
//         onTap: () {
//           Navigator.of(context).pushNamed(NewMessage.routeName);
//         },
//         child: Container(
//           height: 56,
//           width: 56,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: MateColors.activeIcons,
//           ),
//           child: Icon(Icons.add,
//               color: themeController.isDarkMode
//                   ? Colors.black
//                   : Colors.white,
//               size: 28),
//         ),
//       ):
//       Offstage(),
//       body: Column(
//         children: [
//           DecoratedBox(
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.0),
//               border: Border(
//                   bottom: BorderSide(
//                       color: Color(0xFF65656B).withOpacity(0.2), width: 0.8)),
//             ),
//             child: TabBar(
//               controller: _tabController,
//               unselectedLabelColor: Color(0xFF656568),
//               indicatorColor: MateColors.activeIcons,
//               indicatorPadding: EdgeInsets.symmetric(horizontal: 20),
//               labelColor: themeController.isDarkMode ? Colors.white : MateColors.blackTextColor,
//               labelStyle: TextStyle(
//                   fontSize: 15.0,
//                   fontFamily: "Poppins",
//                   fontWeight: FontWeight.w500),
//               tabs: [
//                 Tab(
//                   text: "Communities",
//                 ),
//                 Tab(
//                   text: "Chats",
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 10,
//           ),
//           Expanded(
//             child: TabBarView(
//               controller: _tabController,
//               children: [
//                 groupsList(),
//                 _personalMessages(),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _appBarLeading(BuildContext context) {
//     return Selector<AuthUserProvider, String>(
//       selector: (ctx, authUserProvider) => authUserProvider.authUserPhoto,
//       builder: (ctx, data, _) {
//         return Padding(
//           padding: EdgeInsets.only(left: 12.0.sp),
//           child: InkWell(
//             onTap: () {
//               _key.currentState.openDrawer();
//             },
//             child: CircleAvatar(
//               backgroundColor: Colors.transparent,
//               radius: 16,
//               child: CircleAvatar(
//                 backgroundColor: Colors.transparent,
//                 radius: 16,
//                 backgroundImage: NetworkImage(data),
//                 // child: ClipOval(
//                 //   child: Image.network(
//                 //     data,
//                 //   ),
//                 // ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget groupsList() {
//     return Consumer<ChatProvider>(
//       builder: (ctx, chatProvider, _) {
//         print("group chat consumer is called");
//         if (chatProvider.groupChatDataFetchLoader && chatProvider.groupChatModelData==null) {
//           return Shimmer.fromColors(
//             baseColor: themeController.isDarkMode?Colors.white12:Colors.black12,
//             highlightColor: themeController.isDarkMode?Colors.white54:Colors.black54,
//             enabled: true,
//             child: GroupLoader(),
//           );
//         }
//         else if (chatProvider.error != '') {
//           return Center(
//             child: Container(
//               color: Colors.red,
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(
//                   '${chatProvider.error}',
//                   style: TextStyle(color: Colors.white,),
//                 ),
//               ),
//             ),
//           );
//         }else if(chatProvider.groupChatModelData!=null){
//           return chatProvider.groupChatModelData.data.length == 0 ?
//           Center(
//             child: Text("You don't have any message",
//               style: TextStyle(
//                 fontSize: 13.0.sp,
//                 fontWeight: FontWeight.w700,
//                 color: MateColors.activeIcons,
//               ),
//             ),
//           ):
//           RefreshIndicator(
//             onRefresh: () {
//               return chatProvider.groupChatDataFetch(_user.uid);
//             },
//             child: ListView(
//               children: [
//                 ListView.builder(
//                   itemCount: chatProvider.groupChatModelData.data.length,
//                   shrinkWrap: true,
//                   physics: ScrollPhysics(),
//                   scrollDirection: Axis.vertical,
//                   itemBuilder: (context, index) {
//                     return GroupTile(
//                       userName: _user.displayName,
//                       groupId: chatProvider.groupChatModelData.data[index].groupId,
//                       unreadMessages: chatProvider.groupChatModelData.data[index].unreadMessages,
//                       currentUserUid: _user.uid,
//                       loadData: loadData,
//                       isMuted: chatProvider.groupChatModelData.data[index].isMuted,
//                       isPinned: chatProvider.groupChatModelData.data[index].isPinned==0?false:true,
//                     );
//                   },
//                 ),
//               ],
//             ),
//           );
//         }else{
//           return Container();
//         }
//       },
//     );
//   }
//
//   Widget _personalMessages() {
//     return Consumer<ChatProvider>(
//       builder: (ctx, chatProvider, _) {
//         print("Personal chat consumer is called");
//         if (chatProvider.personalChatDataFetchLoader && chatProvider.personalChatModelData == null) {
//           return Shimmer.fromColors(
//             baseColor: themeController.isDarkMode?Colors.white12:Colors.black12,
//             highlightColor: themeController.isDarkMode?Colors.white54:Colors.black54,
//             enabled: true,
//             child: GroupLoader(),
//           );
//         }else if(chatProvider.error != '') {
//           return Center(
//             child: Container(
//               color: Colors.red,
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(
//                   '${chatProvider.error}',
//                   style: TextStyle(color: Colors.white,),
//                 ),
//               ),
//             ),
//           );
//         }else if(chatProvider.personalChatModelData != null) {
//           return chatProvider.personalChatModelData.data.length == 0 ?
//           Center(
//             child: Text("You don't have any message",
//               style: TextStyle(
//                 fontSize: 13.0.sp,
//                 fontWeight: FontWeight.w700,
//                 color: MateColors.activeIcons,
//               ),
//             ),
//           ):
//           RefreshIndicator(
//             onRefresh: () {
//               return chatProvider.personalChatDataFetch(_user.uid);
//             },
//             child: ListView(
//               children: [
//                 ListView.builder(
//                     itemCount: chatProvider.personalChatModelData.data.length,
//                     shrinkWrap: true,
//                     itemBuilder: (context, index1) {
//                       return StreamBuilder(
//                           stream: DatabaseService().getPeerChatUserDetail(chatProvider.personalChatModelData.data[index1].receiverUid),
//                           builder: (context, snapshot) {
//                             if (snapshot.hasData) {
//                               // Future.delayed(Duration.zero,(){
//                               //   Provider.of<ChatProvider>(context,listen: false).personalChatDataFetch(_user.uid);
//                               // });
//                               return ListView.builder(
//                                   shrinkWrap: true,
//                                   itemCount: snapshot.data.docs.length,
//                                   physics: ScrollPhysics(),
//                                   itemBuilder: (context, index) {
//                                     if (_user.uid.hashCode <=
//                                         {
//                                           snapshot.data.docs[index].data()["uid"]
//                                         }.hashCode) {
//                                       personChatId = '${_user.uid}-${snapshot.data.docs[index].data()["uid"]}';
//                                     } else {
//                                       personChatId = '${snapshot.data.docs[index].data()["uid"]}-${_user.uid}';
//                                     }
//                                     return Padding(
//                                       padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
//                                       child: ListTile(
//                                         onTap: () => Get.to(() => Chat(
//                                           peerUuid: snapshot.data.docs[index].data()["uuid"],
//                                           currentUserId: _user.uid,
//                                           peerId: snapshot.data.docs[index].data()["uid"],
//                                           peerName: snapshot.data.docs[index].data()["displayName"],
//                                           peerAvatar: snapshot.data.docs[index].data()["photoURL"],
//                                         )),
//                                         leading: CircleAvatar(
//                                           radius: 24,
//                                           backgroundColor: MateColors.activeIcons,
//                                           backgroundImage: NetworkImage(snapshot.data.docs[index].data()["photoURL"]),
//                                         ),
//                                         title: Text(
//                                           snapshot.data.docs[index].data()["displayName"],
//                                           style: TextStyle(
//                                             fontFamily: "Poppins",
//                                             fontSize: 15.0,
//                                             fontWeight: FontWeight.w500,
//                                             letterSpacing: 0.1,
//                                             color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
//                                           ),
//                                         ),
//                                         // Text(
//                                         //     chatProvider.personalChatModelData.data[index1].unreadMessages < 1 ?
//                                         //     "" :
//                                         //     chatProvider.personalChatModelData.data[index1].unreadMessages.toString(),
//                                         //     style: TextStyle(
//                                         //         fontSize: 11.7.sp,
//                                         //         fontWeight:
//                                         //         FontWeight.w700,
//                                         //         color: MateColors.activeIcons,
//                                         //     ),
//                                         // ),
//                                         subtitle: StreamBuilder(
//                                             stream: FirebaseFirestore.instance.collection('messages').doc(personChatId).collection(personChatId).orderBy('timestamp', descending: true).limit(1).snapshots(),
//                                             // stream: DatabaseService().getLastPersonalChatMessage(personChatId),
//                                             builder: (context, snapshot) {
//                                               if (snapshot.hasData) {
//                                                 print(snapshot.data.docs);
//                                                 if (snapshot.data.docs.length > 0) {
//                                                   return Text(
//                                                     snapshot.data.docs[0].data()['type'] == 0 ?
//                                                     "${snapshot.data.docs[0].data()['content']}" : snapshot.data.docs[0].data()['type'] == 1 ?
//                                                     "🖼️ Image" :
//                                                     snapshot.data.docs[0].data()['fileName'],
//                                                     style: TextStyle(
//                                                       fontFamily: "Poppins",
//                                                       fontSize: 14.0,
//                                                       letterSpacing: 0.1,
//                                                       fontWeight: FontWeight.w400,
//                                                       color: themeController.isDarkMode?
//                                                       chatProvider.personalChatModelData.data[index1].unreadMessages >0?
//                                                       Colors.white: MateColors.subTitleTextDark:
//                                                       chatProvider.personalChatModelData.data[index1].unreadMessages >0?
//                                                       MateColors.blackTextColor:
//                                                       MateColors.subTitleTextLight,
//                                                     ),
//                                                     overflow: TextOverflow.ellipsis,
//                                                   );
//                                                 } else
//                                                   return Text(
//                                                     "Tap to send message",
//                                                     style: TextStyle(letterSpacing: 0.1,fontFamily: "Poppins",fontSize: 14.0, fontWeight: FontWeight.w400, color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight),
//                                                     overflow: TextOverflow.ellipsis,
//                                                   );
//                                               } else
//                                                 return Text(
//                                                   "Tap to send message",
//                                                   style: TextStyle(letterSpacing: 0.1,fontFamily: "Poppins",fontSize: 14.0, fontWeight: FontWeight.w400, color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight),
//                                                   overflow: TextOverflow.ellipsis,
//                                                 );
//                                             }),
//                                         trailing: chatProvider.personalChatModelData.data[index1].unreadMessages >0?
//                                         Container(
//                                           height: 20,
//                                           width: 20,
//                                           margin: EdgeInsets.only(right: 10),
//                                           decoration: BoxDecoration(
//                                             shape: BoxShape.circle,
//                                             color: MateColors.activeIcons,
//                                           ),
//                                           child: Center(
//                                             child: Text(
//                                               chatProvider.personalChatModelData.data[index1].unreadMessages.toString(),
//                                               style: TextStyle(fontFamily: "Poppins",
//                                                 fontSize: 12.0,
//                                                 fontWeight: FontWeight.w400,
//                                                 color: themeController.isDarkMode?MateColors.blackTextColor:Colors.white,
//                                               ),
//                                             ),
//                                           ),
//                                         ):Offstage(),
//                                       ),
//                                     );
//                                   });
//                             } else {
//                               return Container();
//                               //   Center(
//                               //   child: CircularProgressIndicator(
//                               //     backgroundColor: MateColors.activeIcons,
//                               //   ),
//                               // );
//                             }
//                           });
//                     }),
//               ],
//             ),
//           );
//         }else{
//           return Container();
//         }
//       },
//     );
//   }
//
// }
//



import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mate_app/Screen/chatDashboard/chatMergedSearch.dart';
import 'package:mate_app/Screen/chatDashboard/new_message.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

import '../../Model/callHistoryModel.dart';
import '../../Providers/AuthUserProvider.dart';
import '../../Providers/chatProvider.dart';
import '../../Services/community_tab_services.dart';
import '../../Widget/Drawer/DrawerWidget.dart';
import '../../Widget/Loaders/Shimmer.dart';
import '../../asset/Colors/MateColors.dart';
import '../../controller/theme_controller.dart';
import '../../groupChat/services/database_service.dart';
import '../../groupChat/widgets/group_tile.dart';
import '../chat1/screens/chat.dart';
import 'archived_view.dart';

class ChatDashboard extends StatefulWidget {
  static final String routeName = '/chatDashboard';
  @override
  _ChatDashboardState createState() => _ChatDashboardState();
}

class _ChatDashboardState extends State<ChatDashboard> with TickerProviderStateMixin {
  ThemeController themeController = Get.find<ThemeController>();
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  User _user = FirebaseAuth.instance.currentUser;
  String personChatId;
  TabController _tabController;
  List<CallHistoryModel> callHistoryList = [];
  bool isLoading = true;

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    getStoredValue();
    getCallHistory();
    Future.delayed(Duration.zero, () {
      Provider.of<ChatProvider>(context, listen: false).mergedChatDataFetch(_user.uid,true);
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String token;
  getStoredValue()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token");
    log(token);
  }

  void getCallHistory()async{
    QuerySnapshot callHistory = await DatabaseService().getCallHistory();
    callHistoryList.clear();
    print("Fetching call history");
    for(int i=0;i<callHistory.docs.length;i++){
      String callType;
      bool isPersonalCall;
      String callerId;
      String createdAt;
      String callSymbol;
      String receiverId;

      if(callHistory.docs[i]['groupIdORPeerId'].contains(_user.uid)){
        callType = callHistory.docs[i]['callType'];
        createdAt = callHistory.docs[i]['createdAt'].toString();
        isPersonalCall = callHistory.docs[i]['groupIdORPeerId'].contains(_user.uid);
        List<String> split = callHistory.docs[i]['groupIdORPeerId'].toString().split("-");
        List<String> splitOther = split.where((element) => element!=_user.uid).toList();
        callerId = _user.displayName ==  callHistory.docs[i]['groupNameORCallerName'] ? _user.uid : splitOther[0];
        receiverId = _user.displayName ==  callHistory.docs[i]['groupNameORCallerName'] ? splitOther[0] : _user.uid;
        callSymbol = _user.displayName ==  callHistory.docs[i]['groupNameORCallerName'] ? 'called' : callHistory.docs[i]['membersWhoJoined'].contains(_user.uid)? 'received' : 'missed';
        callHistoryList.add(CallHistoryModel(callType, isPersonalCall, createdAt, callerId, callSymbol,receiverId));
      }else if(callHistory.docs[i]['groupMember'].contains(_user.uid)){
        callType = callHistory.docs[i]['callType'];
        createdAt = callHistory.docs[i]['createdAt'].toString();
        isPersonalCall = callHistory.docs[i]['groupIdORPeerId'].contains(_user.uid);
        callerId = callHistory.docs[i]['groupIdORPeerId'];
        receiverId = callHistory.docs[i]['groupIdORPeerId'];
        callSymbol = _user.uid == callHistory.docs[i]['callerUid']?'called': callHistory.docs[i]['membersWhoJoined'].contains(_user.uid)?"received":"missed";
        callHistoryList.add(CallHistoryModel(callType, isPersonalCall, createdAt, callerId, callSymbol,receiverId));
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  loadData()async{
    Future.delayed(Duration.zero, () {
      Provider.of<ChatProvider>(context, listen: false).mergedChatDataFetch(_user.uid,false);
    });
  }

  Widget _appBarLeading(BuildContext context) {
    return Selector<AuthUserProvider, String>(
      selector: (ctx, authUserProvider) => authUserProvider.authUserPhoto,
      builder: (ctx, data, _) {
        return Padding(
          padding: EdgeInsets.only(left: 12.0.sp),
          child: InkWell(
            onTap: () {
              _key.currentState.openDrawer();
            },
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 16,
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 16,
                backgroundImage: NetworkImage(data),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer: DrawerWidget(),
      appBar: AppBar(
        elevation: 0,
        leading: _appBarLeading(context),
        iconTheme: IconThemeData(
          color: MateColors.activeIcons,
        ),
        // bottom: PreferredSize(
        //   preferredSize: Size.fromHeight(1),
        //   child: Container(
        //     color: Color(0xFF65656B).withOpacity(0.2),
        //     height: 1.0,
        //   ),
        // ),
        actions: [
          InkWell(
            onTap: ()async{
              await Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ChatMergedSearch()));
              loadData();
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
          "Messages",
          style: TextStyle(
            color: themeController.isDarkMode ? Colors.white : MateColors.blackTextColor,
            fontWeight: FontWeight.w700,
            fontSize: 17.0,
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(NewMessage.routeName);
        },
        child: Container(
          height: 56,
          width: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: MateColors.activeIcons,
          ),
          child:  Icon(Icons.add,
            color: themeController.isDarkMode ? Colors.black : Colors.white,
            size: 28,
          ),
        ),
      ),
      body: Column(
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
              onTap: (value){
                if(value==1){
                  getCallHistory();
                }
              },
              tabs: [
                Tab(
                  text: "Chats",
                ),
                Tab(
                  text: "Calls",
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                RefreshIndicator(
                  onRefresh: () {
                    return Provider.of<ChatProvider>(context, listen: false).mergedChatDataFetch(_user.uid,false);
                  },
                  child: Consumer<ChatProvider>(
                    builder: (ctx, chatProvider, _){
                      if (chatProvider.mergedChatDataFetchLoader) {
                        return Shimmer.fromColors(
                          baseColor: themeController.isDarkMode?Colors.white12:Colors.black12,
                          highlightColor: themeController.isDarkMode?Colors.white54:Colors.black54,
                          enabled: true,
                          child: GroupLoader(),
                        );
                      }else if(chatProvider.mergedChatApiError){
                        return Center(
                          child: Container(
                            color: Colors.red,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Something went wrong!',
                                style: TextStyle(color: Colors.white,),
                              ),
                            ),
                          ),
                        );
                      }else if(chatProvider.mergedChatModelData!=null){
                        return chatProvider.mergedChatModelData.data.length == 0 ?
                        Center(
                          child: Text("You don't have any message",
                            style: TextStyle(
                              fontSize: 13.0.sp,
                              fontWeight: FontWeight.w700,
                              color: MateColors.activeIcons,
                            ),
                          ),
                        ):ListView(
                          padding: EdgeInsets.only(top: 20),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          children: [
                            if(chatProvider.mergedChatModelData.archived.length>0)
                              InkWell(
                                onTap: ()async{
                                  await Get.to(()=>ArchivedView());
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: 25,top: 0,bottom: 16),
                                  child: Row(
                                    children: [
                                      Icon(Icons.archive,color: MateColors.activeIcons,),
                                      SizedBox(width: 35,),
                                      Text("Archived",
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.1,
                                          color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ListView.builder(
                              itemCount: chatProvider.mergedChatModelData.data.length,
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, indexMain) {
                                return chatProvider.mergedChatModelData.data[indexMain].type=="group"?
                                FocusedMenuHolder(
                                  menuWidth: MediaQuery.of(context).size.width*0.5,
                                  blurSize: 5.0,
                                  menuItemExtent: 45,
                                  menuBoxDecoration: BoxDecoration(
                                    //color: Colors.red,
                                    //shape: BoxShape.rectangle,
                                    gradient: LinearGradient(colors: themeController.isDarkMode?[MateColors.drawerTileColor,MateColors.drawerTileColor]:[Colors.white,Colors.white]),
                                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                  duration: Duration(milliseconds: 100),
                                  animateMenuItems: true,
                                  blurBackgroundColor: Colors.black54,
                                  openWithTap: false, // Open Focused-Menu on Tap rather than Long Press
                                  menuOffset: 16.0, // Offset value to show menuItem from the selected item
                                  bottomOffsetHeight: 80.0,
                                  menuItems: <FocusedMenuItem>[
                                    FocusedMenuItem(
                                      title: Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(left: 0),
                                            child: Text(
                                              "Archive",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w500,
                                                color: themeController.isDarkMode?Colors.white: MateColors.blackTextColor,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.23),
                                            child: Icon(Icons.archive,
                                              size: 20,
                                              color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
                                            ),
                                          ),
                                        ],
                                      ),
                                      backgroundColor: themeController.isDarkMode?MateColors.drawerTileColor:Colors.white,
                                      onPressed: ()async{
                                        await CommunityTabService().toggleArchive(roomId: chatProvider.mergedChatModelData.data[indexMain].roomId,uid: _user.uid,token: token);
                                        loadData();
                                      },
                                    ),
                                    FocusedMenuItem(
                                      title: Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(left: 0),
                                            child: Text(
                                              chatProvider.mergedChatModelData.data[indexMain].isMuted?
                                              "Unmute":
                                              "Mute",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w500,
                                                color: themeController.isDarkMode?Colors.white: MateColors.blackTextColor,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left:
                                            chatProvider.mergedChatModelData.data[indexMain].isMuted?
                                            MediaQuery.of(context).size.width*0.23:
                                            MediaQuery.of(context).size.width*0.28),
                                            child: Icon(
                                              chatProvider.mergedChatModelData.data[indexMain].isMuted?
                                              Icons.volume_up:
                                              Icons.volume_off,
                                              size: 20,
                                              color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
                                            ),
                                          ),
                                        ],
                                      ),
                                      backgroundColor: themeController.isDarkMode?MateColors.drawerTileColor:Colors.white,
                                      onPressed: ()async{
                                        if(chatProvider.mergedChatModelData.data[indexMain].isMuted){
                                          DatabaseService().removeIsMuted(chatProvider.mergedChatModelData.data[indexMain].roomId, _user.uid);
                                        }else{
                                          DatabaseService().setIsMuted(chatProvider.mergedChatModelData.data[indexMain].roomId, _user.uid);
                                        }
                                        await CommunityTabService().toggleMute(groupId: chatProvider.mergedChatModelData.data[indexMain].roomId,uid: _user.uid,token: token);
                                        loadData();
                                      },
                                    ),
                                    FocusedMenuItem(
                                      title: Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(left: 0),
                                            child: Text(
                                              "Exit Group",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w500,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.18),
                                            child: Icon(Icons.cancel_outlined,
                                              size: 20,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                      backgroundColor: themeController.isDarkMode?MateColors.drawerTileColor:Colors.white,
                                      onPressed: ()async{
                                        DocumentSnapshot data = await DatabaseService().getMateGroupDetailsData(chatProvider.mergedChatModelData.data[indexMain].roomId);
                                        DatabaseService(uid: _user.uid).togglingGroupJoin(chatProvider.mergedChatModelData.data[indexMain].roomId,data["groupName"],_user.displayName);
                                        await CommunityTabService().exitGroup(token: token,uid: _user.uid,groupId: chatProvider.mergedChatModelData.data[indexMain].roomId);
                                        loadData();
                                      },
                                    ),
                                  ],
                                  onPressed: (){},
                                  child: GroupTile(
                                    userName: _user.displayName,
                                    groupId: chatProvider.mergedChatModelData.data[indexMain].roomId,
                                    unreadMessages: chatProvider.mergedChatModelData.data[indexMain].unreadMessages,
                                    currentUserUid: _user.uid,
                                    loadData: loadData,
                                    isMuted: chatProvider.mergedChatModelData.data[indexMain].isMuted,
                                    isPinned: chatProvider.mergedChatModelData.data[indexMain].isPinned==0?false:true,
                                    index: indexMain,
                                  ),
                                ):
                                StreamBuilder(
                                    stream: DatabaseService().getPeerChatUserDetail(chatProvider.mergedChatModelData.data[indexMain].receiverUid),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: snapshot.data.docs.length,
                                            physics: ScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              if (_user.uid.hashCode <= snapshot.data.docs[index].data()["uid"].hashCode) {
                                                personChatId = '${_user.uid}-${snapshot.data.docs[index].data()["uid"]}';
                                              } else {
                                                personChatId = '${snapshot.data.docs[index].data()["uid"]}-${_user.uid}';
                                              }
                                              chatProvider.messageList[indexMain].name = snapshot.data.docs[index].data()["displayName"];
                                              return FocusedMenuHolder(
                                                menuWidth: MediaQuery.of(context).size.width*0.5,
                                                blurSize: 5.0,
                                                menuItemExtent: 45,
                                                menuBoxDecoration: BoxDecoration(
                                                  //color: Colors.red,
                                                  //shape: BoxShape.rectangle,
                                                  gradient: LinearGradient(colors: themeController.isDarkMode?[MateColors.drawerTileColor,MateColors.drawerTileColor]:[Colors.white,Colors.white]),
                                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                                ),
                                                duration: Duration(milliseconds: 100),
                                                animateMenuItems: true,
                                                blurBackgroundColor: Colors.black54,
                                                openWithTap: false, // Open Focused-Menu on Tap rather than Long Press
                                                menuOffset: 16.0, // Offset value to show menuItem from the selected item
                                                bottomOffsetHeight: 80.0,
                                                menuItems: <FocusedMenuItem>[
                                                  FocusedMenuItem(
                                                    title: Row(
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets.only(left: 0),
                                                          child: Text(
                                                            "Archive",
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              fontFamily: "Poppins",
                                                              fontWeight: FontWeight.w500,
                                                              color: themeController.isDarkMode?Colors.white: MateColors.blackTextColor,
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.23),
                                                          child: Icon(Icons.archive,
                                                            size: 20,
                                                            color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    backgroundColor: themeController.isDarkMode?MateColors.drawerTileColor:Colors.white,
                                                    onPressed: ()async{
                                                      await CommunityTabService().toggleArchive(roomId: chatProvider.mergedChatModelData.data[indexMain].roomId,uid: _user.uid,token: token);
                                                      loadData();
                                                    },
                                                  ),
                                                  FocusedMenuItem(
                                                    title: Row(
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets.only(left: 0),
                                                          child: Text(
                                                            chatProvider.mergedChatModelData.data[indexMain].isMuted?
                                                            "Unmute":
                                                            "Mute",
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              fontFamily: "Poppins",
                                                              fontWeight: FontWeight.w500,
                                                              color: themeController.isDarkMode?Colors.white: MateColors.blackTextColor,
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets.only(left:
                                                          chatProvider.mergedChatModelData.data[indexMain].isMuted?
                                                          MediaQuery.of(context).size.width*0.23:
                                                          MediaQuery.of(context).size.width*0.28),
                                                          child: Icon(
                                                            chatProvider.mergedChatModelData.data[indexMain].isMuted?
                                                            Icons.volume_up:
                                                            Icons.volume_off,
                                                            size: 20,
                                                            color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    backgroundColor: themeController.isDarkMode?MateColors.drawerTileColor:Colors.white,
                                                    onPressed: ()async{
                                                      await CommunityTabService().toggleMutePersonalChat(roomId: chatProvider.mergedChatModelData.data[indexMain].roomId,uid: _user.uid,token: token);
                                                      loadData();
                                                    },
                                                  ),
                                                ],
                                                onPressed: (){},
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                                                  child: ListTile(
                                                    onTap: ()async {
                                                      await Navigator.push(context, MaterialPageRoute(
                                                          builder: (context) => Chat(
                                                            peerUuid: snapshot.data.docs[index].data()["uuid"],
                                                            currentUserId: _user.uid,
                                                            peerId: snapshot.data.docs[index].data()["uid"],
                                                            peerName: snapshot.data.docs[index].data()["displayName"],
                                                            peerAvatar: snapshot.data.docs[index].data()["photoURL"],
                                                            roomId: chatProvider.messageList[indexMain].roomId,
                                                          )));
                                                      // Get.to(() => Chat(
                                                      //   peerUuid: snapshot.data.docs[index].data()["uuid"],
                                                      //   currentUserId: _user.uid,
                                                      //   peerId: snapshot.data.docs[index].data()["uid"],
                                                      //   peerName: snapshot.data.docs[index].data()["displayName"],
                                                      //   peerAvatar: snapshot.data.docs[index].data()["photoURL"],
                                                      //   roomId: chatProvider.messageList[indexMain].roomId,
                                                      // ));
                                                      loadData();
                                                    },
                                                    leading: CircleAvatar(
                                                      radius: 24,
                                                      backgroundColor: MateColors.activeIcons,
                                                      backgroundImage: NetworkImage(snapshot.data.docs[index].data()["photoURL"]),
                                                    ),
                                                    title: Row(
                                                      children: [
                                                        Text(
                                                          snapshot.data.docs[index].data()["displayName"],
                                                          style: TextStyle(
                                                            fontFamily: "Poppins",
                                                            fontSize: 15.0,
                                                            fontWeight: FontWeight.w500,
                                                            letterSpacing: 0.1,
                                                            color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                                                          ),
                                                        ),
                                                        chatProvider.mergedChatModelData.data[indexMain].isMuted?
                                                        Padding(
                                                          padding: EdgeInsets.only(left: 10),
                                                          child: Image.asset("lib/asset/icons/mute.png",
                                                            color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
                                                            height: 14,
                                                            width: 19,
                                                          ),
                                                        ):Offstage(),
                                                      ],
                                                    ),
                                                    subtitle: StreamBuilder(
                                                        stream: FirebaseFirestore.instance.collection('messages').doc(personChatId).collection(personChatId).orderBy('timestamp', descending: true).limit(1).snapshots(),
                                                        builder: (context, snapshot) {
                                                          if (snapshot.hasData) {
                                                            print(snapshot.data.docs);
                                                            if (snapshot.data.docs.length > 0) {
                                                              return Text(
                                                                snapshot.data.docs[0].data()['type'] == 4?
                                                                "Audio" :
                                                                snapshot.data.docs[0].data()['type'] == 0 ?
                                                                "${snapshot.data.docs[0].data()['content']}" : snapshot.data.docs[0].data()['type'] == 1 ?
                                                                "🖼️ Image" :
                                                                snapshot.data.docs[0].data()['fileName'],
                                                                style: TextStyle(
                                                                  fontFamily: "Poppins",
                                                                  fontSize: 14.0,
                                                                  letterSpacing: 0.1,
                                                                  fontWeight: FontWeight.w400,
                                                                  color: themeController.isDarkMode?
                                                                  chatProvider.mergedChatModelData.data[indexMain].unreadMessages >0?
                                                                  Colors.white: MateColors.subTitleTextDark:
                                                                  chatProvider.mergedChatModelData.data[indexMain].unreadMessages >0?
                                                                  MateColors.blackTextColor:
                                                                  MateColors.subTitleTextLight,
                                                                ),
                                                                overflow: TextOverflow.ellipsis,
                                                              );
                                                            } else
                                                              return Text(
                                                                "Tap to send message",
                                                                style: TextStyle(letterSpacing: 0.1,fontFamily: "Poppins",fontSize: 14.0, fontWeight: FontWeight.w400, color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight),
                                                                overflow: TextOverflow.ellipsis,
                                                              );
                                                          } else
                                                            return Text(
                                                              "Tap to send message",
                                                              style: TextStyle(letterSpacing: 0.1,fontFamily: "Poppins",fontSize: 14.0, fontWeight: FontWeight.w400, color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight),
                                                              overflow: TextOverflow.ellipsis,
                                                            );
                                                        }),
                                                    trailing: chatProvider.mergedChatModelData.data[indexMain].unreadMessages >0 && chatProvider.mergedChatModelData.data[indexMain].isMuted==false?
                                                    Container(
                                                      height: 20,
                                                      width: 20,
                                                      margin: EdgeInsets.only(right: 10),
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: MateColors.activeIcons,
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          chatProvider.mergedChatModelData.data[indexMain].unreadMessages.toString(),
                                                          style: TextStyle(fontFamily: "Poppins",
                                                            fontSize: 12.0,
                                                            fontWeight: FontWeight.w400,
                                                            color: themeController.isDarkMode?MateColors.blackTextColor:Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ):Offstage(),
                                                  ),
                                                ),
                                              );
                                            });
                                      } else {
                                        return Container();
                                      }
                                    });
                              },
                            ),
                          ],
                        );
                      }else{
                        return Container();
                      }
                    },
                  ),
                ),
                isLoading?
                Shimmer.fromColors(
                  baseColor: themeController.isDarkMode?Colors.white12:Colors.black12,
                  highlightColor: themeController.isDarkMode?Colors.white54:Colors.black54,
                  enabled: true,
                  child: GroupLoader(),
                ):
                callHistoryList.isEmpty?
                Center(
                  child: Text("No call logs found",
                    style: TextStyle(
                      color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
                      fontWeight: FontWeight.w400,
                      fontSize: 15.0,
                    ),
                  ),
                ):
                ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: ScrollPhysics(),
                  itemCount: callHistoryList.length,
                  itemBuilder: (context,index){
                    String callTime;

                    var dateTimeNowToday = DateTime.now();
                    List<String> splitToday = dateTimeNowToday.toString().split(" ");
                    DateTime dateParsedToday = DateTime.parse(splitToday[0]);
                    String dateFormattedToday = DateFormat('dd MMMM yyyy').format(dateParsedToday);

                    var dateTimeNowYesterday = DateTime.now().subtract(const Duration(days:1));
                    List<String> splitYesterday = dateTimeNowYesterday.toString().split(" ");
                    DateTime dateParsedYesterday = DateTime.parse(splitYesterday[0]);
                    String dateFormattedYesterday = DateFormat('dd MMMM yyyy').format(dateParsedYesterday);

                    DateTime dateFormat = new DateTime.fromMillisecondsSinceEpoch(int.parse(callHistoryList[index].createdAt));
                    String dateFormatted = DateFormat('dd MMMM yyyy').format(dateFormat);
                    String formattedTime = DateFormat.jm().format(dateFormat);
                    if(dateFormatted == dateFormattedToday){
                      callTime = "Today, " + formattedTime;
                    }else if(dateFormatted == dateFormattedYesterday){
                      callTime = "Yesterday, " + formattedTime;
                    }else{
                      callTime = "$dateFormatted, " + formattedTime;
                    }

                    return callHistoryList[index].isPersonalCall?
                    FutureBuilder(
                        future: DatabaseService().getUsersDetails(callHistoryList[index].callSymbol == 'called'? callHistoryList[index].receiverId : callHistoryList[index].callerId),
                        builder: (context, snapshot1) {
                          if(snapshot1.hasData){
                            return Padding(
                              padding: EdgeInsets.only(top: index==0?16:10),
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
                                  child: Text(snapshot1.data.data()['displayName']!=null?
                                    snapshot1.data.data()['displayName'].substring(0,1):'',style: TextStyle(color: themeController.isDarkMode?Colors.black:Colors.white),),
                                ),
                                title: Text(
                                    snapshot1.data.data()['displayName']!=null?
                                  snapshot1.data.data()['displayName']:"",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.1,
                                    color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                                  ),
                                ),
                                trailing: Padding(
                                  padding: const EdgeInsets.only(right: 4,left: 4),
                                  child: Icon(callHistoryList[index].callType == "Video Calling" ? Icons.video_call : Icons.call,color: MateColors.activeIcons,),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      callHistoryList[index].callSymbol=="called"?
                                      Icon(Icons.call_made,color: Colors.green,):
                                      callHistoryList[index].callSymbol=="received"?
                                      Icon(Icons.call_received,color: Colors.green,):
                                      Icon(Icons.call_received,color: Colors.red,),
                                      SizedBox(width: 5,),
                                      Text(callTime,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
                                        ),
                                      ),
                                    ],
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
                    ):
                    FutureBuilder(
                        future: DatabaseService().getGroupDetailsOnce(callHistoryList[index].callerId),
                        builder: (context, snapshot1) {
                          if(snapshot1.hasData){
                            return Padding(
                              padding: EdgeInsets.only(top: index==0?16:10),
                              child: ListTile(
                                leading: snapshot1.data.data()['groupIcon']!=null?
                                CircleAvatar(
                                  radius: 28,
                                  backgroundColor: MateColors.activeIcons,
                                  backgroundImage: NetworkImage(
                                    snapshot1.data.data()['groupIcon'],
                                  ),
                                ):
                                CircleAvatar(
                                  radius: 28,
                                  backgroundColor: MateColors.activeIcons,
                                  child: Text(snapshot1.data.data()['groupName']!=null ?
                                    snapshot1.data.data()['groupName'].substring(0,1):'',style: TextStyle(color: themeController.isDarkMode?Colors.black:Colors.white),),
                                ),
                                title: Text(snapshot1.data.data()['groupName']!=null?
                                  snapshot1.data.data()['groupName']:"",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.1,
                                    color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                                  ),
                                ),
                                trailing: Padding(
                                  padding: const EdgeInsets.only(right: 4,left: 4),
                                  child: Icon(callHistoryList[index].callType == "Video Calling" ? Icons.video_call : Icons.call,color: MateColors.activeIcons,),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      callHistoryList[index].callSymbol=="called"?
                                      Icon(Icons.call_made,color: Colors.green,):
                                      callHistoryList[index].callSymbol=="received"?
                                      Icon(Icons.call_received,color: Colors.green,):
                                      Icon(Icons.call_received,color: Colors.red,),
                                      SizedBox(width: 5,),
                                      Text(callTime,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
                                        ),
                                      ),
                                    ],
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
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
