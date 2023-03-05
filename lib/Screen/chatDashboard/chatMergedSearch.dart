import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../Providers/chatProvider.dart';
import '../../asset/Colors/MateColors.dart';
import '../../constant.dart';
import '../../controller/theme_controller.dart';
import '../../groupChat/services/database_service.dart';
import '../../groupChat/widgets/group_tile.dart';
import '../chat1/screens/chat.dart';

class ChatMergedSearch extends StatefulWidget {
  final bool onlyGroupSearch;
  const ChatMergedSearch({Key key, this.onlyGroupSearch}) : super(key: key);

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
    final scH = MediaQuery.of(context).size.height;
    final scW = MediaQuery.of(context).size.width;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: null,
      onPanUpdate: (details) {
        if (details.delta.dy > 0){
          FocusScope.of(context).requestFocus(FocusNode());
          print("Dragging in +Y direction");
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        body: Container(
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
              SizedBox(
                height: scH*0.07,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: searchEditingController,
                  onChanged: (val) => setState((){
                    searchedName=val;
                  }),
                  cursorColor: themeController.isDarkMode?MateColors.helpingTextDark:MateColors.helpingTextLight,
                  style:  TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.1,
                    color: themeController.isDarkMode?Colors.white:Colors.black,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: themeController.isDarkMode ? MateColors.containerDark : MateColors.containerLight,
                    hintStyle: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      color: themeController.isDarkMode?MateColors.helpingTextDark:MateColors.helpingTextLight,
                    ),
                    hintText: "Search",
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 15,top: 15,bottom: 15),
                      child: Image.asset(
                        "lib/asset/homePageIcons/searchPurple@3x.png",
                        height: 10,
                        width: 10,
                        color: themeController.isDarkMode?Colors.white:Colors.black,
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
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            color: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                          ),
                        ),
                      ),
                    ),
                    enabledBorder: commonBorder,
                    focusedBorder: commonBorder,
                  ),
                ),
              ),
              Expanded(
                child: Consumer<ChatProvider>(
                  builder: (ctx, chatProvider, _){
                    return chatProvider.messageList.length == 0 ?
                    Center(
                      child: Text("You don't have any message",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ):
                    ListView(
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: EdgeInsets.only(top: 16),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      children: [
                        ListView.builder(
                          itemCount: chatProvider.messageList.length,
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: ScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, indexMain) {
                            return Visibility(
                              visible: searchedName!="" && chatProvider.messageList[indexMain].name.toString().toLowerCase().contains(searchedName.toLowerCase()),
                              child: chatProvider.messageList[indexMain].type=="group" && widget.onlyGroupSearch?
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
                                          padding: EdgeInsets.zero,
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
                                                  radius: 30,
                                                  backgroundColor: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                                                  backgroundImage: NetworkImage(snapshot.data.docs[index].data()["photoURL"]),
                                                ),
                                                title: Text(
                                                  snapshot.data.docs[index].data()["displayName"],
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontFamily: "Poppins",
                                                    fontWeight: FontWeight.w600,
                                                    color: themeController.isDarkMode?Colors.white: MateColors.blackTextColor,
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
                                                            snapshot.data.docs[0].data()['fileName']??"${snapshot.data.docs[0].data()['content']}",
                                                            style: TextStyle(
                                                              fontFamily: "Poppins",
                                                              fontSize: 14.0,
                                                              letterSpacing: 0.1,
                                                              fontWeight: FontWeight.w400,
                                                              color: themeController.isDarkMode?
                                                              chatProvider.messageList[indexMain].unreadMessages >0?
                                                              Colors.white: Colors.white.withOpacity(0.5):
                                                              chatProvider.messageList[indexMain].unreadMessages >0?
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
                                                trailing: chatProvider.messageList[indexMain].unreadMessages >0?
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
                                                      chatProvider.messageList[indexMain].unreadMessages.toString(),
                                                      style: TextStyle(fontFamily: "Poppins",
                                                        fontSize: 12.0,
                                                        fontWeight: FontWeight.w400,
                                                        color: Colors.black,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
