import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../Providers/chatProvider.dart';
import '../../asset/Colors/MateColors.dart';
import '../../controller/theme_controller.dart';
import '../../groupChat/services/database_service.dart';
import '../../groupChat/widgets/group_tile.dart';
import '../chat1/screens/chat.dart';

class ChatMergedSearch extends StatefulWidget {
  const ChatMergedSearch({Key key}) : super(key: key);

  @override
  State<ChatMergedSearch> createState() => _ChatMergedSearchState();
}

class _ChatMergedSearchState extends State<ChatMergedSearch> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController searchEditingController = new TextEditingController();
  ThemeController themeController = Get.find<ThemeController>();
  FocusNode focusNode= FocusNode();
  bool hasUserSearched = false;
  User _user = FirebaseAuth.instance.currentUser;
  String personChatId;
  String searchedName="";

  @override
  void initState() {
    super.initState();
    focusNode.requestFocus();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  loadData()async{
    // Future.delayed(Duration.zero, () {
    //   Provider.of<ChatProvider>(context, listen: false).mergedChatDataFetch(_user.uid,false);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: TextField(
          onChanged: (val) => setState((){
            searchedName=val;
          }),
          style: TextStyle(color: themeController.isDarkMode?Colors.white:Colors.black),
          decoration: InputDecoration(
            hintStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.1,
              color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
            ),
            hintText: "Search",
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 15,top: 15,bottom: 15),
              child: Image.asset(
                "lib/asset/homePageIcons/searchPurple@3x.png",
                height: 10,
                width: 10,
                color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
              ),
            ),
            suffixIcon: InkWell(
              onTap: (){
                Get.back();
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 16,right: 15),
                child: Text(
                  "Close",
                  style: TextStyle(
                    fontSize: 15,
                    letterSpacing: 0.1,
                    fontWeight: FontWeight.w700,
                    color: MateColors.activeIcons,
                  ),
                ),
              ),
            ),
            enabledBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(width: 3,color: themeController.isDarkMode?MateColors.darkDivider:MateColors.lightDivider),
            ),
            focusedBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(width: 3,color: themeController.isDarkMode?MateColors.darkDivider:MateColors.lightDivider),
            ),
          ),
        ),
      ),
      body: Consumer<ChatProvider>(
        builder: (ctx, chatProvider, _){
          return chatProvider.messageList.length == 0 ?
          Center(
            child: Text("You don't have any message",
              style: TextStyle(
                fontSize: 13.0.sp,
                fontWeight: FontWeight.w700,
                color: MateColors.activeIcons,
              ),
            ),
          ):
          ListView(
            padding: EdgeInsets.only(top: 20),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: ScrollPhysics(),
            children: [
              ListView.builder(
                itemCount: chatProvider.messageList.length,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, indexMain) {
                  return Visibility(
                    visible: searchedName!="" && chatProvider.messageList[indexMain].name.toString().toLowerCase().contains(searchedName.toLowerCase()),
                    child:  chatProvider.messageList[indexMain].type=="group"?
                    GroupTile(
                      userName: _user.displayName,
                      groupId: chatProvider.messageList[indexMain].roomId,
                      unreadMessages: chatProvider.messageList[indexMain].unreadMessages,
                      currentUserUid: _user.uid,
                      loadData: loadData,
                      isMuted: chatProvider.messageList[indexMain].isMuted,
                      isPinned: chatProvider.messageList[indexMain].isPinned==0?false:true,
                      index: indexMain,
                    ):
                    StreamBuilder(
                        stream: DatabaseService().getPeerChatUserDetail(chatProvider.messageList[indexMain].receiverUid),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data.docs.length,
                                physics: ScrollPhysics(),
                                itemBuilder: (context, index) {
                                  if (_user.uid.hashCode <=
                                      {
                                        snapshot.data.docs[index].data()["uid"]
                                      }.hashCode) {
                                    personChatId = '${_user.uid}-${snapshot.data.docs[index].data()["uid"]}';
                                  } else {
                                    personChatId = '${snapshot.data.docs[index].data()["uid"]}-${_user.uid}';
                                  }
                                  chatProvider.messageList[indexMain].name = snapshot.data.docs[index].data()["displayName"];
                                  return Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                                    child: ListTile(
                                      onTap: () => Get.to(() => Chat(
                                        peerUuid: snapshot.data.docs[index].data()["uuid"],
                                        currentUserId: _user.uid,
                                        peerId: snapshot.data.docs[index].data()["uid"],
                                        peerName: snapshot.data.docs[index].data()["displayName"],
                                        peerAvatar: snapshot.data.docs[index].data()["photoURL"],
                                      )),
                                      leading: CircleAvatar(
                                        radius: 24,
                                        backgroundColor: MateColors.activeIcons,
                                        backgroundImage: NetworkImage(snapshot.data.docs[index].data()["photoURL"]),
                                      ),
                                      title: Text(
                                        snapshot.data.docs[index].data()["displayName"],
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.1,
                                          color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                                        ),
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
                                                    chatProvider.messageList[indexMain].unreadMessages >0?
                                                    Colors.white: MateColors.subTitleTextDark:
                                                    chatProvider.messageList[indexMain].unreadMessages >0?
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
                                      trailing: chatProvider.messageList[indexMain].unreadMessages >0?
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
                                            chatProvider.messageList[indexMain].unreadMessages.toString(),
                                            style: TextStyle(fontFamily: "Poppins",
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w400,
                                              color: themeController.isDarkMode?MateColors.blackTextColor:Colors.white,
                                            ),
                                          ),
                                        ),
                                      ):Offstage(),
                                    ),
                                  );
                                });
                          } else {
                            return Container();
                          }
                        }),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
