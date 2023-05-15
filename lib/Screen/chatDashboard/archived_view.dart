import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../Providers/chatProvider.dart';
import '../../Services/community_tab_services.dart';
import '../../Widget/focused_menu/focused_menu.dart';
import '../../Widget/focused_menu/modals.dart';
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
    final scH = MediaQuery.of(context).size.height;
    final scW = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SlidableAutoCloseBehavior(
        closeWhenOpened: true,
        child: Container(
          height: scH,
          width: scW,
          decoration: BoxDecoration(
            color: themeController.isDarkMode?Color(0xFF000000):Colors.white,
            image: DecorationImage(
              image: AssetImage(themeController.isDarkMode?'lib/asset/Background.png':'lib/asset/BackgroundLight.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height*0.07,
                  left: 16,
                  right: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Get.back();
                      },
                      child: Icon(Icons.arrow_back_ios,
                        size: 20,
                        color: themeController.isDarkMode ? Colors.white : MateColors.blackTextColor,
                      ),
                    ),
                    Text(
                      "Archived",
                      style: TextStyle(
                        color: themeController.isDarkMode ? Colors.white : MateColors.blackTextColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 17.0,
                      ),
                    ),
                    SizedBox(),
                  ],
                ),
              ),
              Consumer<ChatProvider>(
                builder: (ctx, chatProvider, _){
                  return
                    chatProvider.archiveList.length == 0 ?
                    Center(
                      child: Text("Nothing in archived",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                          fontWeight: FontWeight.w600,
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
                          padding: EdgeInsets.zero,
                          itemCount: chatProvider.archiveList.length,
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, indexMain) {
                            return chatProvider.archiveList[indexMain].type=="group"?
                            Slidable(
                              key: Key(indexMain.toString()),
                              endActionPane: ActionPane(
                                motion: StretchMotion(),
                                extentRatio: 0.2,
                                children: [
                                  CustomSlidableAction(
                                    onPressed: (v)async{
                                      await CommunityTabService().toggleArchive(roomId: chatProvider.archiveList[indexMain].roomId,uid: _user.uid,token: token);
                                      loadData();
                                    },
                                    padding: EdgeInsets.zero,
                                    backgroundColor: Colors.transparent,
                                    child: VisibilityDetector(
                                      key: Key(indexMain.toString()),
                                      onVisibilityChanged: (visibilityInfo) {
                                        setState(() {
                                          if(visibilityInfo.visibleFraction==1.0){
                                            chatProvider.archiveList[indexMain].isVisible = true;
                                          }else{
                                            chatProvider.archiveList[indexMain].isVisible = false;
                                          }
                                        });
                                        print(visibilityInfo.visibleFraction);
                                        var visiblePercentage = visibilityInfo.visibleFraction * 100;
                                        debugPrint('Widget ${visibilityInfo.key} is ${visiblePercentage}% visible');
                                      },
                                      child: Container(
                                        height: 48,
                                        width: 48,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                                        ),
                                        child: Icon(Icons.unarchive,
                                          size: 20,
                                          color: themeController.isDarkMode?MateColors.helpingTextLight:Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              child: FocusedMenuHolder(
                                menuWidth: MediaQuery.of(context).size.width*0.52,
                                blurSize: 5.0,
                                menuItemExtent: 45,
                                menuBoxDecoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                ),
                                duration: Duration(milliseconds: 100),
                                animateMenuItems: true,
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
                                              fontWeight: FontWeight.w600,
                                              color: themeController.isDarkMode?Colors.white: MateColors.blackTextColor,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.19),
                                          child: Icon(Icons.unarchive,
                                            size: 20,
                                            color: themeController.isDarkMode?MateColors.helpingTextLight:Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    backgroundColor: Colors.white.withOpacity(0.15),
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
                                  showColor: chatProvider.archiveList[indexMain].isVisible,
                                ),
                              ),
                            ):
                            StreamBuilder(
                                stream: DatabaseService().getPeerChatUserDetail(chatProvider.archiveList[indexMain].receiverUid),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return ListView.builder(
                                        shrinkWrap: true,
                                        padding: EdgeInsets.zero,
                                        itemCount: snapshot.data.docs.length,
                                        physics: ScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          if (_user.uid.hashCode <= snapshot.data.docs[index].data()["uid"].hashCode) {
                                            personChatId = '${_user.uid}-${snapshot.data.docs[index].data()["uid"]}';
                                          } else {
                                            personChatId = '${snapshot.data.docs[index].data()["uid"]}-${_user.uid}';
                                          }
                                          return FocusedMenuHolder(
                                            menuWidth: MediaQuery.of(context).size.width*0.52,
                                            blurSize: 5.0,
                                            menuItemExtent: 45,
                                            menuBoxDecoration: BoxDecoration(
                                              color: Colors.transparent,
                                              borderRadius: BorderRadius.all(Radius.circular(20)),
                                            ),
                                            duration: Duration(milliseconds: 100),
                                            animateMenuItems: true,
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
                                                          fontWeight: FontWeight.w600,
                                                          color: themeController.isDarkMode?Colors.white: MateColors.blackTextColor,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.19),
                                                      child: Icon(Icons.unarchive,
                                                        size: 20,
                                                        color: themeController.isDarkMode?MateColors.helpingTextLight:Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                backgroundColor: Colors.white.withOpacity(0.15),
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
                                                  radius: 30,
                                                  backgroundColor: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                                                  backgroundImage: NetworkImage(snapshot.data.docs[index].data()["photoURL"]),
                                                ),
                                                title: Row(
                                                  children: [
                                                    Text(
                                                      snapshot.data.docs[index].data()["displayName"],
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontFamily: "Poppins",
                                                        fontWeight: FontWeight.w600,
                                                        color: themeController.isDarkMode?Colors.white: MateColors.blackTextColor,
                                                      ),
                                                    ),
                                                    chatProvider.archiveList[indexMain].isMuted?
                                                    Padding(
                                                      padding: EdgeInsets.only(left: 10),
                                                      child: Image.asset("lib/asset/icons/mute.png",
                                                        color: themeController.isDarkMode?MateColors.helpingTextLight:MateColors.iconPopupLight,
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
                                                              fontWeight: FontWeight.w400,
                                                              color: themeController.isDarkMode?
                                                              chatProvider.mergedChatModelData.data[indexMain].unreadMessages >0?
                                                              Colors.white: Colors.white.withOpacity(0.5):
                                                              chatProvider.mergedChatModelData.data[indexMain].unreadMessages >0?
                                                              Colors.black: Colors.black.withOpacity(0.5),
                                                            ),
                                                            overflow: TextOverflow.ellipsis,
                                                          );
                                                        } else
                                                          return Text(
                                                            "Tap to send message",
                                                            style: TextStyle(
                                                              fontFamily: "Poppins",
                                                              fontSize: 14.0,
                                                              fontWeight: FontWeight.w400,
                                                              color: themeController.isDarkMode?Colors.white.withOpacity(0.5):Colors.black.withOpacity(0.5),
                                                            ),
                                                            overflow: TextOverflow.ellipsis,
                                                          );
                                                      } else
                                                        return Text(
                                                          "Tap to send message",
                                                          style: TextStyle(
                                                            fontFamily: "Poppins",
                                                            fontSize: 14.0,
                                                            fontWeight: FontWeight.w400,
                                                            color: themeController.isDarkMode?Colors.white.withOpacity(0.5):Colors.black.withOpacity(0.5),
                                                          ),
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
                                                    color: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      chatProvider.archiveList[indexMain].unreadMessages.toString(),
                                                      style: TextStyle(fontFamily: "Poppins",
                                                        fontSize: 12.0,
                                                        fontWeight: FontWeight.w400,
                                                        color: Colors.black,
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
            ],
          ),
        ),
      ),
    );
  }
}
