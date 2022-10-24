// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:mate_app/Screen/chatDashboard/search_person.dart';
// import 'package:provider/provider.dart';
// import 'package:sizer/sizer.dart';
//
// import '../../Providers/chatProvider.dart';
// import '../../Widget/Loaders/Shimmer.dart';
// import '../../asset/Colors/MateColors.dart';
// import '../../controller/theme_controller.dart';
// import '../../groupChat/services/database_service.dart';
// import '../chat1/screens/chat.dart';
//
// class NewMessage extends StatefulWidget {
//   static final String routeName = '/newMessage';
//
//   @override
//   _NewMessageState createState() => _NewMessageState();
// }
//
// class _NewMessageState extends State<NewMessage> {
//   ThemeController themeController = Get.find<ThemeController>();
//   User _user = FirebaseAuth.instance.currentUser;
//   String personChatId;
//
//   @override
//   void initState() {
//     Future.delayed(Duration.zero, () {
//       Provider.of<ChatProvider>(context, listen: false).personalChatDataFetch(_user.uid);
//     });
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         iconTheme: IconThemeData(
//           color: MateColors.activeIcons,
//         ),
//         actions: [
//           InkWell(
//             onTap: (){
//               Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SearchPerson()));
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
//           "New Message",
//           style: TextStyle(
//             color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
//             fontWeight: FontWeight.w700,
//             fontSize: 17.0,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: _personalMessages(),
//
//       // ListView(
//       //   scrollDirection: Axis.vertical,
//       //   shrinkWrap: true,
//       //   physics: ScrollPhysics(),
//       //   children: [
//       //     SizedBox(height: 15,),
//       //     Padding(
//       //       padding: const EdgeInsets.only(left: 16),
//       //       child: Text("A",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight),),
//       //     ),
//       //     SizedBox(height: 25,),
//       //     ListView.builder(
//       //       scrollDirection: Axis.vertical,
//       //       shrinkWrap: true,
//       //       physics: ScrollPhysics(),
//       //       itemCount: 10,
//       //       itemBuilder: (context,index){
//       //         return Padding(
//       //           padding: const EdgeInsets.only(bottom: 35),
//       //           child: ListTile(
//       //             leading: CircleAvatar(
//       //               radius: 28,
//       //               backgroundColor: MateColors.activeIcons,
//       //               backgroundImage: NetworkImage("https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80"),
//       //             ),
//       //             title: Text("Anne Holmes",
//       //               style: TextStyle(
//       //                 fontSize: 15,
//       //                 fontWeight: FontWeight.w500,
//       //                 letterSpacing: 0.1,
//       //                 color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
//       //               ),
//       //             ),
//       //           ),
//       //         );
//       //       },
//       //     ),
//       //   ],
//       // ),
//     );
//   }
//
//   Widget _personalMessages() {
//     return Consumer<ChatProvider>(
//       builder: (ctx, chatProvider, _) {
//         print("Personal chat consumer is called");
//         if (chatProvider.personalChatDataFetchLoader && chatProvider.personalChatModelData == null) {
//           return timelineLoader();
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
//             child: Text("You don't have any connection",
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
//             child: ListView.builder(
//                 itemCount: chatProvider.personalChatModelData.data.length,
//                 shrinkWrap: true,
//                 itemBuilder: (context, index1) {
//                   return StreamBuilder(
//                       stream: DatabaseService().getPeerChatUserDetail(chatProvider.personalChatModelData.data[index1].receiverUid),
//                       builder: (context, snapshot) {
//                         if (snapshot.hasData) {
//                           // Future.delayed(Duration.zero,(){
//                           //   Provider.of<ChatProvider>(context,listen: false).personalChatDataFetch(_user.uid);
//                           // });
//                           return ListView.builder(
//                               shrinkWrap: true,
//                               itemCount: snapshot.data.docs.length,
//                               physics: ScrollPhysics(),
//                               itemBuilder: (context, index) {
//                                 if (_user.uid.hashCode <=
//                                     {
//                                       snapshot.data.docs[index].data()["uid"]
//                                     }.hashCode) {
//                                   personChatId = '${_user.uid}-${snapshot.data.docs[index].data()["uid"]}';
//                                 } else {
//                                   personChatId = '${snapshot.data.docs[index].data()["uid"]}-${_user.uid}';
//                                 }
//                                 return Padding(
//                                   padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
//                                   child: ListTile(
//                                     onTap: () => Get.to(() => Chat(
//                                       peerUuid: snapshot.data.docs[index].data()["uuid"],
//                                       currentUserId: _user.uid,
//                                       peerId: snapshot.data.docs[index].data()["uid"],
//                                       peerName: snapshot.data.docs[index].data()["displayName"],
//                                       peerAvatar: snapshot.data.docs[index].data()["photoURL"],
//                                     )),
//                                     leading: CircleAvatar(
//                                       radius: 24,
//                                       backgroundColor: MateColors.activeIcons,
//                                       backgroundImage: NetworkImage(snapshot.data.docs[index].data()["photoURL"]),
//                                     ),
//                                     title: Text(
//                                       snapshot.data.docs[index].data()["displayName"],
//                                       style: TextStyle(
//                                         fontFamily: "Poppins",
//                                         fontSize: 15.0,
//                                         fontWeight: FontWeight.w500,
//                                         letterSpacing: 0.1,
//                                         color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
//                                       ),
//                                     ),
//                                     // Text(
//                                     //     chatProvider.personalChatModelData.data[index1].unreadMessages < 1 ?
//                                     //     "" :
//                                     //     chatProvider.personalChatModelData.data[index1].unreadMessages.toString(),
//                                     //     style: TextStyle(
//                                     //         fontSize: 11.7.sp,
//                                     //         fontWeight:
//                                     //         FontWeight.w700,
//                                     //         color: MateColors.activeIcons,
//                                     //     ),
//                                     // ),
//                                     subtitle: StreamBuilder(
//                                         stream: FirebaseFirestore.instance.collection('messages').doc(personChatId).collection(personChatId).orderBy('timestamp', descending: true).limit(1).snapshots(),
//                                         // stream: DatabaseService().getLastPersonalChatMessage(personChatId),
//                                         builder: (context, snapshot) {
//                                           if (snapshot.hasData) {
//                                             print(snapshot.data.docs);
//                                             if (snapshot.data.docs.length > 0) {
//                                               return Text(
//                                                 snapshot.data.docs[0].data()['type'] == 0 ?
//                                                 "${snapshot.data.docs[0].data()['content']}" : snapshot.data.docs[0].data()['type'] == 1 ?
//                                                 "🖼️ Image" :
//                                                 snapshot.data.docs[0].data()['fileName'],
//                                                 style: TextStyle(
//                                                   fontFamily: "Poppins",
//                                                   fontSize: 14.0,
//                                                   letterSpacing: 0.1,
//                                                   fontWeight: FontWeight.w400,
//                                                   color: themeController.isDarkMode?
//                                                   chatProvider.personalChatModelData.data[index1].unreadMessages >0?
//                                                   Colors.white: MateColors.subTitleTextDark:
//                                                   chatProvider.personalChatModelData.data[index1].unreadMessages >0?
//                                                   MateColors.blackTextColor:
//                                                   MateColors.subTitleTextLight,
//                                                 ),
//                                                 overflow: TextOverflow.ellipsis,
//                                               );
//                                             } else
//                                               return Text(
//                                                 "Tap to send message",
//                                                 style: TextStyle(letterSpacing: 0.1,fontFamily: "Poppins",fontSize: 14.0, fontWeight: FontWeight.w400, color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight),
//                                                 overflow: TextOverflow.ellipsis,
//                                               );
//                                           } else
//                                             return Text(
//                                               "Tap to send message",
//                                               style: TextStyle(letterSpacing: 0.1,fontFamily: "Poppins",fontSize: 14.0, fontWeight: FontWeight.w400, color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight),
//                                               overflow: TextOverflow.ellipsis,
//                                             );
//                                         }),
//                                     trailing: chatProvider.personalChatModelData.data[index1].unreadMessages >0?
//                                     Container(
//                                       height: 20,
//                                       width: 20,
//                                       margin: EdgeInsets.only(right: 10),
//                                       decoration: BoxDecoration(
//                                         shape: BoxShape.circle,
//                                         color: MateColors.activeIcons,
//                                       ),
//                                       child: Center(
//                                         child: Text(
//                                           chatProvider.personalChatModelData.data[index1].unreadMessages.toString(),
//                                           style: TextStyle(fontFamily: "Poppins",
//                                             fontSize: 12.0,
//                                             fontWeight: FontWeight.w400,
//                                             color: themeController.isDarkMode?MateColors.blackTextColor:Colors.white,
//                                           ),
//                                         ),
//                                       ),
//                                     ):Offstage(),
//                                   ),
//                                 );
//                               });
//                         } else {
//                           return Center(
//                             child: CircularProgressIndicator(
//                               backgroundColor: MateColors.activeIcons,
//                             ),
//                           );
//                         }
//                       });
//                 }),
//           );
//         }else{
//           return Container();
//         }
//       },
//     );
//   }
//
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mate_app/Screen/chatDashboard/search_person.dart';

import '../../asset/Colors/MateColors.dart';
import '../../controller/theme_controller.dart';
import '../../groupChat/services/database_service.dart';
import '../chat1/screens/chat.dart';

class NewMessage extends StatefulWidget {
  static final String routeName = '/newMessage';
  const NewMessage({Key key}) : super(key: key);

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  ThemeController themeController = Get.find<ThemeController>();
  QuerySnapshot searchResultSnapshot;
  bool isLoading = true;
  bool hasUserSearched = false;
  User _user = FirebaseAuth.instance.currentUser;
  String searchedName="";
  List<UserListModel> userList = [];

  @override
  void initState() {
    DatabaseService().getAllUserData(_user.uid).then((snapshot){
      searchResultSnapshot = snapshot;
      for(int i=0;i<searchResultSnapshot.docs.length;i++){
        if(searchResultSnapshot.docs[i]["displayName"]!=null && searchResultSnapshot.docs[i]["displayName"]!=""){
          userList.add(
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
      userList.sort((a, b) {
        return a.displayName.toLowerCase().compareTo(b.displayName.toLowerCase());
      });
      setState(() {
        isLoading = false;
        hasUserSearched = true;
      });
    });
    super.initState();
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
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SearchPerson()));
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
        title: Text(
          "New Message",
          style: TextStyle(
            color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
            fontWeight: FontWeight.w700,
            fontSize: 17.0,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading ?
      Container(
        child: Center(
          child: CircularProgressIndicator(
            color: MateColors.activeIcons,
          ),
        ),
      ):
      groupList(),
    );
  }

  Widget groupList() {
    return hasUserSearched ?
    ListView.builder(
        shrinkWrap: true,
        itemCount: userList.length,//searchResultSnapshot.docs.length,
        itemBuilder: (context, index) {
          print(userList[index].displayName);
          return groupTile(
            userList[index].uuid,
            userList[index].uid,
            userList[index].displayName,
            userList[index].photoURL,
            userList[index].email,
            index==0? true: userList[index].displayName[0].toLowerCase() != userList[index-1].displayName[0].toLowerCase()? true : false,
            // searchResultSnapshot.docs[index].data()["uuid"],
            // searchResultSnapshot.docs[index].data()["uid"],
            // searchResultSnapshot.docs[index].data()["displayName"],
            // searchResultSnapshot.docs[index].data()["photoURL"],
            // searchResultSnapshot.docs[index].data()["email"],
          );
        }) :
    Container();
  }

  Widget groupTile(String peerUuid,String peerId, String peerName, String peerAvatar,String email,bool showOrNot) {
    return InkWell(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
            Chat(
              peerUuid: peerUuid,
              currentUserId: _user.uid, //
              peerId: peerId,
              peerName: peerName,
              peerAvatar: peerAvatar,
            )
        ));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          showOrNot?
          Padding(
            padding: EdgeInsets.only(left: 25,top: 5),
            child: Text(peerName[0].toUpperCase(),
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.1,
                color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
              ),
            ),
          ):Offstage(),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            leading: CircleAvatar(
              radius: 24,
              backgroundColor: MateColors.activeIcons,
              backgroundImage: NetworkImage(peerAvatar??""),
            ),
            title: Text(
              peerName,
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.1,
                color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Text("Tap on chat to send message",
                style: TextStyle(letterSpacing: 0.1,fontFamily: "Poppins",fontSize: 14.0, fontWeight: FontWeight.w400, color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // trailing: InkWell(
            //   onTap: (){
            //
            //   },
            //   child: Container(
            //     decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), border: Border.all(color: MateColors.activeIcons, width: 0.6)),
            //     padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 8.0),
            //     child: Text('Chat', style: TextStyle(color: MateColors.activeIcons, fontWeight: FontWeight.w500)),
            //   ),
            // ),
          ),
        ],
      ),
    );
  }

}


class UserListModel {
  String uuid;
  String uid;
  String displayName;
  String photoURL;
  String email;
  UserListModel({this.uuid, this.uid, this.displayName,this.photoURL,this.email});
}
