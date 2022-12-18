import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../Providers/chatProvider.dart';
import '../../Services/community_tab_services.dart';
import '../../asset/Colors/MateColors.dart';
import '../../controller/theme_controller.dart';
import '../../groupChat/services/database_service.dart';
import '../../groupChat/widgets/group_tile.dart';
import '../chat1/screens/chat.dart';

class ArchivedView extends StatefulWidget {
  const ArchivedView({Key key}) : super(key: key);

  @override
  State<ArchivedView> createState() => _ArchivedViewState();
}

class _ArchivedViewState extends State<ArchivedView> {
  ThemeController themeController = Get.find<ThemeController>();
  User _user = FirebaseAuth.instance.currentUser;
  String personChatId;

  @override
  void initState() {
    getStoredValue();
    super.initState();
  }

  String token;
  getStoredValue()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token");
    log(token);
  }

  loadData()async{
    Future.delayed(Duration.zero, () {
      Provider.of<ChatProvider>(context, listen: false).mergedChatDataFetch(_user.uid,false);
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
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(
            color: Color(0xFF65656B).withOpacity(0.2),
            height: 1.0,
          ),
        ),
        title: Text(
          "Archived",
          style: TextStyle(
            color: themeController.isDarkMode ? Colors.white : MateColors.blackTextColor,
            fontWeight: FontWeight.w700,
            fontSize: 17.0,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<ChatProvider>(
        builder: (ctx, chatProvider, _){
          return
            chatProvider.archiveList.length == 0 ?
            Center(
              child: Text("Nothing in archived",
                style: TextStyle(
                  fontSize: 13.0.sp,
                  fontWeight: FontWeight.w700,
                  color: MateColors.activeIcons,
                ),
              ),
            ):
            ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: ScrollPhysics(),
            padding: EdgeInsets.only(top: 16),
            children: [
              ListView.builder(
                itemCount: chatProvider.archiveList.length,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, indexMain) {
                  return chatProvider.archiveList[indexMain].type=="group"?
                  FocusedMenuHolder(
                    menuWidth: MediaQuery.of(context).size.width*0.5,
                    blurSize: 5.0,
                    menuItemExtent: 45,
                    menuBoxDecoration: BoxDecoration(
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
                                "Unarchive",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w500,
                                  color: themeController.isDarkMode?Colors.white: MateColors.blackTextColor,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.19),
                              child: Icon(Icons.unarchive,
                                size: 20,
                                color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
                              ),
                            ),
                          ],
                        ),
                        backgroundColor: themeController.isDarkMode?MateColors.drawerTileColor:Colors.white,
                        onPressed: ()async{
                          await CommunityTabService().toggleArchive(roomId: chatProvider.archiveList[indexMain].roomId,uid: _user.uid,token: token);
                          loadData();
                        },
                      ),
                    ],
                    onPressed: (){},
                    child: GroupTile(
                      userName: _user.displayName,
                      groupId: chatProvider.archiveList[indexMain].roomId,
                      unreadMessages: chatProvider.archiveList[indexMain].unreadMessages,
                      currentUserUid: _user.uid,
                      loadData: loadData,
                      isMuted: chatProvider.archiveList[indexMain].isMuted,
                      isPinned: chatProvider.archiveList[indexMain].isPinned==0?false:true,
                      index: indexMain,
                    ),
                  ):
                  StreamBuilder(
                      stream: DatabaseService().getPeerChatUserDetail(chatProvider.archiveList[indexMain].receiverUid),
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
                                //chatProvider.messageList[indexMain].name = snapshot.data.docs[index].data()["displayName"];
                                return FocusedMenuHolder(
                                  menuWidth: MediaQuery.of(context).size.width*0.5,
                                  blurSize: 5.0,
                                  menuItemExtent: 45,
                                  menuBoxDecoration: BoxDecoration(
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
                                              "Unarchive",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w500,
                                                color: themeController.isDarkMode?Colors.white: MateColors.blackTextColor,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.19),
                                            child: Icon(Icons.unarchive,
                                              size: 20,
                                              color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
                                            ),
                                          ),
                                        ],
                                      ),
                                      backgroundColor: themeController.isDarkMode?MateColors.drawerTileColor:Colors.white,
                                      onPressed: ()async{
                                        await CommunityTabService().toggleArchive(roomId: chatProvider.archiveList[indexMain].roomId,uid: _user.uid,token: token);
                                        loadData();
                                      },
                                    ),
                                  ],
                                  onPressed: (){},
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                                    child: ListTile(
                                      onTap: () => Get.to(() => Chat(
                                        peerUuid: snapshot.data.docs[index].data()["uuid"],
                                        currentUserId: _user.uid,
                                        peerId: snapshot.data.docs[index].data()["uid"],
                                        peerName: snapshot.data.docs[index].data()["displayName"],
                                        peerAvatar: snapshot.data.docs[index].data()["photoURL"],
                                        roomId: chatProvider.archiveList[indexMain].roomId,
                                      )),
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
                                          chatProvider.archiveList[indexMain].isMuted?
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
                                                    chatProvider.archiveList[indexMain].unreadMessages >0?
                                                    Colors.white: MateColors.subTitleTextDark:
                                                    chatProvider.archiveList[indexMain].unreadMessages >0?
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
                                      trailing: chatProvider.archiveList[indexMain].unreadMessages >0 && chatProvider.archiveList[indexMain].isMuted==false?
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
                                            chatProvider.archiveList[indexMain].unreadMessages.toString(),
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
        },
      ),
    );
  }
}
