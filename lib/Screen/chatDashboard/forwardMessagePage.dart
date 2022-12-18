import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:get/get.dart';
import 'package:mate_app/Screen/chatDashboard/forwardMessageArchived.dart';
import 'package:mate_app/Screen/chatDashboard/forwardMessagePersonSearch.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import '../../Providers/chatProvider.dart';
import '../../Services/chatService.dart';
import '../../Widget/Loaders/Shimmer.dart';
import '../../asset/Colors/MateColors.dart';
import '../../constant.dart';
import '../../controller/theme_controller.dart';
import '../../groupChat/services/database_service.dart';
import '../../groupChat/widgets/group_tile.dart';
import '../chat1/screens/chat.dart';
import 'archived_view.dart';

class ForwardMessagePage extends StatefulWidget {
  final Map messageData;
  static final String routeName = '/chatDashboard';
  const ForwardMessagePage({Key key, this.messageData}) : super(key: key);

  @override
  _ForwardMessagePage createState() => _ForwardMessagePage();
}

class _ForwardMessagePage extends State<ForwardMessagePage> with TickerProviderStateMixin {
  ThemeController themeController = Get.find<ThemeController>();
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  TabController _tabController;
  int _selectedIndex = 0;

  ///Personal chat
  User _user = FirebaseAuth.instance.currentUser;
  String personChatId;

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
      print("Selected Index: " + _tabController.index.toString());
    });

    ///personal chat
    Future.delayed(Duration.zero, () {
      Provider.of<ChatProvider>(context, listen: false).personalChatDataFetch(_user.uid);
    });

    ///group
    Future.delayed(Duration.zero,() {
      Provider.of<ChatProvider>(context,listen: false).groupChatDataFetch(_user.uid);
    },);

    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _key,
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(
            color: MateColors.activeIcons,
          ),
          actions: [
           // _tabController.index==1?
            InkWell(
              onTap: (){
                //if(_tabController.index==1){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ForwardMessagePersonSearch(messageData: widget.messageData,)));
                //}
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
            )
                //:Offstage(),
          ],
          title: Text(
            "Forward Message",
            style: TextStyle(
              color: themeController.isDarkMode ? Colors.white : MateColors.blackTextColor,
              fontWeight: FontWeight.w700,
              fontSize: 17.0,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.0),
                border: Border(
                    bottom: BorderSide(
                        color: Color(0xFF65656B).withOpacity(0.2), width: 0.8)),
              ),
              child: TabBar(
                controller: _tabController,
                unselectedLabelColor: Color(0xFF656568),
                indicatorColor: MateColors.activeIcons,
                indicatorPadding: EdgeInsets.symmetric(horizontal: 20),
                labelColor: themeController.isDarkMode ? Colors.white : MateColors.blackTextColor,
                labelStyle: TextStyle(
                    fontSize: 15.0,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w500),
                tabs: [
                  Tab(
                    text: "Recent Chat",
                  ),
                  Tab(
                    text: "Connection",
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  Consumer<ChatProvider>(
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
                          padding: EdgeInsets.only(top: 10),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          children: [
                            if(chatProvider.mergedChatModelData.archived.length>0)
                              InkWell(
                                onTap: ()async{
                                  await Get.to(()=>ForwardMessageArchiveView(messageData: widget.messageData,));
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
                                Container(
                                  padding: EdgeInsets.only(top: 0),
                                  child: StreamBuilder<DocumentSnapshot>(
                                      stream: DatabaseService().getLastChatMessage(chatProvider.mergedChatModelData.data[indexMain].roomId),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return InkWell(
                                            onTap: (){
                                              _showSendAlertDialog(
                                                groupId: chatProvider.mergedChatModelData.data[indexMain].roomId,
                                                messageData: widget.messageData,
                                                userImage: _user.photoURL,
                                              );
                                            },
                                            child: Container(
                                              margin: EdgeInsets.only(left: 10),
                                              child: ListTile(
                                                dense: true,
                                                leading: snapshot.data['groupIcon'] != "" ? CircleAvatar(
                                                  radius: 24,
                                                  backgroundColor: MateColors.activeIcons,
                                                  backgroundImage: NetworkImage(snapshot.data['groupIcon']),
                                                ):
                                                CircleAvatar(
                                                  radius: 24,
                                                  backgroundColor: MateColors.activeIcons,
                                                  child: Text(snapshot.data['groupName'].substring(0, 1).toUpperCase(),
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(color: themeController.isDarkMode?Colors.black:Colors.white, fontSize: 12.5.sp, fontWeight: FontWeight.bold)),
                                                ),
                                                title: Padding(
                                                  padding: EdgeInsets.only(top: snapshot.data['recentMessageSender'] != "" ? 0:10),
                                                  child: Text(snapshot.data['groupName'],
                                                    style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      fontSize: 15.0,
                                                      fontWeight: FontWeight.w500,
                                                      color: themeController.isDarkMode ? Colors.white : MateColors.blackTextColor,
                                                    ),
                                                  ),
                                                ),
                                                subtitle: Padding(
                                                  padding: const EdgeInsets.only(top: 3),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        snapshot.data['recentMessageSender'] != "" ?
                                                        "${snapshot.data['recentMessageSender']}" :
                                                        "Send first message to this group",
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
                                                        overflow: TextOverflow.clip,
                                                      ),
                                                      Text(
                                                        snapshot.data.data().toString().contains('isAudio') && snapshot.data['isAudio']?
                                                        "Audio" :
                                                        "${snapshot.data.data().toString().contains('isImage')?snapshot.data['isImage'] != null ? snapshot.data['isImage'] ? " 🖼️ Image" : snapshot.data['isGif'] != null ? snapshot.data['isGif'] ? " 🖼️ GIF File" : snapshot.data['isFile'] ? "File" : snapshot.data['recentMessage'] : snapshot.data['recentMessage'] : snapshot.data['recentMessage']: snapshot.data['recentMessage']}",
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
                                                        overflow: TextOverflow.clip,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                trailing: chatProvider.mergedChatModelData.data[indexMain].unreadMessages >0?
                                                Container(
                                                  height: 20,
                                                  width: 20,
                                                  margin: EdgeInsets.only(right: 10,top: 15),
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
                                        } else
                                          return Container();
                                      }),
                                ) :
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
                                              return Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                                                child: ListTile(
                                                  onTap: (){
                                                    String personChatIdLocal;

                                                    personChatIdLocal = chatProvider.mergedChatModelData.data[indexMain].roomId;


                                                    // if (_user.uid.hashCode <= {snapshot.data.docs[index].data()["uid"]}.hashCode) {
                                                    //   print("---true---");
                                                    //   personChatIdLocal = '${_user.uid}-${snapshot.data.docs[index].data()["uid"]}';
                                                    // } else {
                                                    //   personChatIdLocal = '${snapshot.data.docs[index].data()["uid"]}-${_user.uid}';
                                                    // }

                                                    int type;
                                                    String message = widget.messageData["message"];
                                                    bool isImage = widget.messageData["isImage"];
                                                    bool isGif = widget.messageData["isGif"];
                                                    bool isFile = widget.messageData["isFile"];
                                                    bool isAudio = widget.messageData["isAudio"];

                                                    if(isImage){
                                                      type = 1;
                                                    }else if(isGif){
                                                      type = 1;
                                                    }else if(isFile){
                                                      type = 3;
                                                    }else if(isAudio){
                                                      type = 4;
                                                    } else{
                                                      type = 0;
                                                    }

                                                    String fileExtension = widget.messageData["fileExtension"];
                                                    String fileName = widget.messageData["fileName"];
                                                    int fileSize = widget.messageData["fileSize"];

                                                    Map<String, dynamic> chatMessageMapLocal = {'idFrom': _user.uid, 'idTo': snapshot.data.docs[index].data()["uid"], 'timestamp': DateTime.now().millisecondsSinceEpoch.toString(), 'content': message.trim(), 'type': type,"isForwarded":true};

                                                    if (fileExtension!=null) {
                                                      chatMessageMapLocal['fileExtension'] = fileExtension;
                                                    }
                                                    if (fileName!=null) {
                                                      chatMessageMapLocal['fileName'] = fileName;
                                                    }
                                                    if (fileSize!=null) {
                                                      chatMessageMapLocal['fileSize'] = fileSize;
                                                    }

                                                    print(snapshot.data.docs[index].data()["uid"]);
                                                    print(personChatIdLocal);
                                                    print(chatMessageMapLocal);
                                                    _showSendAlertDialogPersonalMessage(messageData: chatMessageMapLocal,personChatId: personChatIdLocal);
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
                  //groupsList(),
                  _connectionMessages(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _connectionMessages() {
    return ListView(
      children: [
        connectionGlobalList.length==0?
        Container(
          margin: EdgeInsets.symmetric(horizontal: 30),
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height/1.3,
          child: Text("Tap the + icon to make connections and grow your network",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
              fontWeight: FontWeight.w500,
              fontSize: 17.0,
            ),
          ),
        ):
        ListView.builder(
            itemCount: connectionGlobalList.length,
            shrinkWrap: true,
            itemBuilder: (context, index1) {
              return StreamBuilder(
                  stream: DatabaseService().getPeerChatUserDetail(connectionGlobalList[index1].uid),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.docs.length,
                          physics: ScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                              child: ListTile(
                                onTap: (){
                                  String personChatIdLocal;

                                  if (_user.uid.hashCode <= snapshot.data.docs[index].data()["uid"].hashCode) {
                                    personChatIdLocal = '${_user.uid}-${snapshot.data.docs[index].data()["uid"]}';
                                  } else {
                                    personChatIdLocal = '${snapshot.data.docs[index].data()["uid"]}-${_user.uid}';
                                  }

                                  int type;
                                  String message = widget.messageData["message"];
                                  bool isImage = widget.messageData["isImage"];
                                  bool isGif = widget.messageData["isGif"];
                                  bool isFile = widget.messageData["isFile"];
                                  bool isAudio = widget.messageData["isAudio"];

                                  if(isImage){
                                    type = 1;
                                  }else if(isGif){
                                    type = 1;
                                  }else if(isFile){
                                    type = 3;
                                  }else if(isAudio){
                                    type = 4;
                                  } else{
                                    type = 0;
                                  }

                                  String fileExtension = widget.messageData["fileExtension"];
                                  String fileName = widget.messageData["fileName"];
                                  int fileSize = widget.messageData["fileSize"];

                                  Map<String, dynamic> chatMessageMapLocal = {'idFrom': _user.uid, 'idTo': snapshot.data.docs[index].data()["uid"], 'timestamp': DateTime.now().millisecondsSinceEpoch.toString(), 'content': message.trim(), 'type': type,"isForwarded":true};

                                  if (fileExtension!=null) {
                                    chatMessageMapLocal['fileExtension'] = fileExtension;
                                  }
                                  if (fileName!=null) {
                                    chatMessageMapLocal['fileName'] = fileName;
                                  }
                                  if (fileSize!=null) {
                                    chatMessageMapLocal['fileSize'] = fileSize;
                                  }

                                  print(personChatIdLocal);
                                  print(chatMessageMapLocal);
                                  _showSendAlertDialogPersonalMessage(messageData: chatMessageMapLocal,personChatId: personChatIdLocal);
                                },
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
                              ),
                            );
                          });
                    } else {
                      return Container();
                    }
                  });
            }),
      ],
    );
  }

  // Widget groupsList() {
  //   return Consumer<ChatProvider>(
  //     builder: (ctx, chatProvider, _) {
  //       print("group chat consumer is called");
  //       if (chatProvider.groupChatDataFetchLoader && chatProvider.groupChatModelData==null) {
  //         return timelineLoader();
  //       }
  //       else if (chatProvider.error != '') {
  //         return Center(
  //           child: Container(
  //             color: Colors.red,
  //             child: Padding(
  //               padding: const EdgeInsets.all(8.0),
  //               child: Text(
  //                 '${chatProvider.error}',
  //                 style: TextStyle(color: Colors.white,),
  //               ),
  //             ),
  //           ),
  //         );
  //       }else if(chatProvider.groupChatModelData!=null){
  //         return chatProvider.groupChatModelData.data.length == 0 ?
  //         Center(
  //           child: Text("You don't have any message",
  //             style: TextStyle(
  //               fontSize: 13.0.sp,
  //               fontWeight: FontWeight.w700,
  //               color: MateColors.activeIcons,
  //             ),
  //           ),
  //         ):
  //         RefreshIndicator(
  //           onRefresh: () {
  //             return chatProvider.groupChatDataFetch(_user.uid);
  //           },
  //           child: ListView(
  //             children: [
  //               ListView.builder(
  //                 itemCount: chatProvider.groupChatModelData.data.length,
  //                 shrinkWrap: true,
  //                 physics: ScrollPhysics(),
  //                 scrollDirection: Axis.vertical,
  //                 itemBuilder: (context, index) {
  //                   return Container(
  //                     padding: EdgeInsets.only(top: 0),
  //                     child: StreamBuilder<DocumentSnapshot>(
  //                         stream: DatabaseService().getLastChatMessage(chatProvider.groupChatModelData.data[index].groupId),
  //                         builder: (context, snapshot) {
  //                           if (snapshot.hasData) {
  //                             return InkWell(
  //                               onTap: (){
  //                                 _showSendAlertDialog(
  //                                   groupId: chatProvider.groupChatModelData.data[index].groupId,
  //                                   messageData: widget.messageData,
  //                                   userImage: _user.photoURL,
  //                                 );
  //                               },
  //                               child: Container(
  //                                 margin: EdgeInsets.only(left: 10),
  //                                 child: ListTile(
  //                                   dense: true,
  //                                   leading: snapshot.data['groupIcon'] != "" ? CircleAvatar(
  //                                     radius: 24,
  //                                     backgroundColor: MateColors.activeIcons,
  //                                     backgroundImage: NetworkImage(snapshot.data['groupIcon']),
  //                                   ):
  //                                   CircleAvatar(
  //                                     radius: 24,
  //                                     backgroundColor: MateColors.activeIcons,
  //                                     child: Text(snapshot.data['groupName'].substring(0, 1).toUpperCase(),
  //                                         textAlign: TextAlign.center,
  //                                         style: TextStyle(color: themeController.isDarkMode?Colors.black:Colors.white, fontSize: 12.5.sp, fontWeight: FontWeight.bold)),
  //                                   ),
  //                                   title: Padding(
  //                                     padding: EdgeInsets.only(top: snapshot.data['recentMessageSender'] != "" ? 0:10),
  //                                     child: Text(snapshot.data['groupName'],
  //                                       style: TextStyle(
  //                                         fontFamily: "Poppins",
  //                                         fontSize: 15.0,
  //                                         fontWeight: FontWeight.w500,
  //                                         color: themeController.isDarkMode ? Colors.white : MateColors.blackTextColor,
  //                                       ),
  //                                     ),
  //                                   ),
  //                                   subtitle: Padding(
  //                                     padding: const EdgeInsets.only(top: 3),
  //                                     child: Column(
  //                                       crossAxisAlignment: CrossAxisAlignment.start,
  //                                       children: [
  //                                         Text(
  //                                           snapshot.data['recentMessageSender'] != "" ?
  //                                           "${snapshot.data['recentMessageSender']}" :
  //                                           "Send first message to this group",
  //                                           style: TextStyle(
  //                                             fontFamily: "Poppins",
  //                                             fontSize: 14.0,
  //                                             letterSpacing: 0.1,
  //                                             fontWeight: FontWeight.w400,
  //                                             color: themeController.isDarkMode?
  //                                             chatProvider.groupChatModelData.data[index].unreadMessages >0?
  //                                             Colors.white: MateColors.subTitleTextDark:
  //                                             chatProvider.groupChatModelData.data[index].unreadMessages >0?
  //                                             MateColors.blackTextColor:
  //                                             MateColors.subTitleTextLight,
  //                                           ),
  //                                           overflow: TextOverflow.clip,
  //                                         ),
  //                                         Text(
  //                                           snapshot.data.data().toString().contains('isAudio') && snapshot.data['isAudio']?
  //                                           "Audio" :
  //                                           "${snapshot.data.data().toString().contains('isImage')?snapshot.data['isImage'] != null ? snapshot.data['isImage'] ? " 🖼️ Image" : snapshot.data['isGif'] != null ? snapshot.data['isGif'] ? " 🖼️ GIF File" : snapshot.data['isFile'] ? "File" : snapshot.data['recentMessage'] : snapshot.data['recentMessage'] : snapshot.data['recentMessage']: snapshot.data['recentMessage']}",
  //                                           style: TextStyle(
  //                                             fontFamily: "Poppins",
  //                                             fontSize: 14.0,
  //                                             letterSpacing: 0.1,
  //                                             fontWeight: FontWeight.w400,
  //                                             color: themeController.isDarkMode?
  //                                             chatProvider.groupChatModelData.data[index].unreadMessages >0?
  //                                             Colors.white: MateColors.subTitleTextDark:
  //                                             chatProvider.groupChatModelData.data[index].unreadMessages >0?
  //                                             MateColors.blackTextColor:
  //                                             MateColors.subTitleTextLight,
  //                                           ),
  //                                           overflow: TextOverflow.clip,
  //                                         ),
  //                                       ],
  //                                     ),
  //                                   ),
  //                                   trailing: chatProvider.groupChatModelData.data[index].unreadMessages >0?
  //                                   Container(
  //                                     height: 20,
  //                                     width: 20,
  //                                     margin: EdgeInsets.only(right: 10,top: 15),
  //                                     decoration: BoxDecoration(
  //                                       shape: BoxShape.circle,
  //                                       color: MateColors.activeIcons,
  //                                     ),
  //                                     child: Center(
  //                                       child: Text(
  //                                         chatProvider.groupChatModelData.data[index].unreadMessages.toString(),
  //                                         style: TextStyle(fontFamily: "Poppins",
  //                                           fontSize: 12.0,
  //                                           fontWeight: FontWeight.w400,
  //                                           color: themeController.isDarkMode?MateColors.blackTextColor:Colors.white,
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   ):Offstage(),
  //                                 ),
  //                               ),
  //                             );
  //                           } else
  //                             return Container();
  //                         }),
  //                   );
  //                 },
  //               ),
  //             ],
  //           ),
  //         );
  //       }else{
  //         return Container();
  //       }
  //     },
  //   );
  // }
  //


  // Widget _personalMessages() {
  //   return Consumer<ChatProvider>(
  //     builder: (ctx, chatProvider, _) {
  //       print("Personal chat consumer is called");
  //       if (chatProvider.personalChatDataFetchLoader && chatProvider.personalChatModelData == null) {
  //         return timelineLoader();
  //       }else if(chatProvider.error != '') {
  //         return Center(
  //           child: Container(
  //             color: Colors.red,
  //             child: Padding(
  //               padding: const EdgeInsets.all(8.0),
  //               child: Text(
  //                 '${chatProvider.error}',
  //                 style: TextStyle(color: Colors.white,),
  //               ),
  //             ),
  //           ),
  //         );
  //       }else if(chatProvider.personalChatModelData != null) {
  //         return chatProvider.personalChatModelData.data.length == 0 ?
  //         Center(
  //           child: Text("You don't have any message",
  //             style: TextStyle(
  //               fontSize: 13.0.sp,
  //               fontWeight: FontWeight.w700,
  //               color: MateColors.activeIcons,
  //             ),
  //           ),
  //         ):
  //         RefreshIndicator(
  //           onRefresh: () {
  //             return chatProvider.personalChatDataFetch(_user.uid);
  //           },
  //           child: ListView(
  //             children: [
  //               ListView.builder(
  //                   itemCount: chatProvider.personalChatModelData.data.length,
  //                   shrinkWrap: true,
  //                   itemBuilder: (context, index1) {
  //                     return StreamBuilder(
  //                         stream: DatabaseService().getPeerChatUserDetail(chatProvider.personalChatModelData.data[index1].receiverUid),
  //                         builder: (context, snapshot) {
  //                           if (snapshot.hasData) {
  //                             return ListView.builder(
  //                                 shrinkWrap: true,
  //                                 itemCount: snapshot.data.docs.length,
  //                                 physics: ScrollPhysics(),
  //                                 itemBuilder: (context, index) {
  //                                   print("//////");
  //                                   print(snapshot.data.docs.length);
  //                                   print(snapshot.data.docs[index].data()["uid"]);
  //                                   if (_user.uid.hashCode <= {snapshot.data.docs[index].data()["uid"]}.hashCode) {
  //                                     personChatId = '${_user.uid}-${snapshot.data.docs[index].data()["uid"]}';
  //                                   } else {
  //                                     personChatId = '${snapshot.data.docs[index].data()["uid"]}-${_user.uid}';
  //                                   }
  //                                   return Padding(
  //                                     padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
  //                                     child: ListTile(
  //                                       onTap: (){
  //                                         String personChatIdLocal;
  //
  //                                         if (_user.uid.hashCode <= {snapshot.data.docs[index].data()["uid"]}.hashCode) {
  //                                           personChatIdLocal = '${_user.uid}-${snapshot.data.docs[index].data()["uid"]}';
  //                                         } else {
  //                                           personChatIdLocal = '${snapshot.data.docs[index].data()["uid"]}-${_user.uid}';
  //                                         }
  //
  //                                         int type;
  //                                         String message = widget.messageData["message"];
  //                                         bool isImage = widget.messageData["isImage"];
  //                                         bool isGif = widget.messageData["isGif"];
  //                                         bool isFile = widget.messageData["isFile"];
  //                                         bool isAudio = widget.messageData["isAudio"];
  //
  //                                         if(isImage){
  //                                           type = 1;
  //                                         }else if(isGif){
  //                                           type = 1;
  //                                         }else if(isFile){
  //                                           type = 3;
  //                                         }else if(isAudio){
  //                                           type = 4;
  //                                         } else{
  //                                           type = 0;
  //                                         }
  //
  //                                         String fileExtension = widget.messageData["fileExtension"];
  //                                         String fileName = widget.messageData["fileName"];
  //                                         int fileSize = widget.messageData["fileSize"];
  //
  //                                         Map<String, dynamic> chatMessageMapLocal = {'idFrom': _user.uid, 'idTo': snapshot.data.docs[index].data()["uid"], 'timestamp': DateTime.now().millisecondsSinceEpoch.toString(), 'content': message.trim(), 'type': type,"isForwarded":true};
  //
  //                                         if (fileExtension!=null) {
  //                                           chatMessageMapLocal['fileExtension'] = fileExtension;
  //                                         }
  //                                         if (fileName!=null) {
  //                                           chatMessageMapLocal['fileName'] = fileName;
  //                                         }
  //                                         if (fileSize!=null) {
  //                                           chatMessageMapLocal['fileSize'] = fileSize;
  //                                         }
  //
  //                                         print(personChatIdLocal);
  //                                         print(chatMessageMapLocal);
  //                                         _showSendAlertDialogPersonalMessage(messageData: chatMessageMapLocal,personChatId: personChatIdLocal);
  //                                         },
  //                                       // onTap: () => Get.to(() => Chat(
  //                                       //   peerUuid: snapshot.data.docs[index].data()["uuid"],
  //                                       //   currentUserId: _user.uid,
  //                                       //   peerId: snapshot.data.docs[index].data()["uid"],
  //                                       //   peerName: snapshot.data.docs[index].data()["displayName"],
  //                                       //   peerAvatar: snapshot.data.docs[index].data()["photoURL"],
  //                                       // )),
  //                                       leading: CircleAvatar(
  //                                         radius: 24,
  //                                         backgroundColor: MateColors.activeIcons,
  //                                         backgroundImage: NetworkImage(snapshot.data.docs[index].data()["photoURL"]),
  //                                       ),
  //                                       title: Text(
  //                                         snapshot.data.docs[index].data()["displayName"],
  //                                         style: TextStyle(
  //                                           fontFamily: "Poppins",
  //                                           fontSize: 15.0,
  //                                           fontWeight: FontWeight.w500,
  //                                           letterSpacing: 0.1,
  //                                           color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
  //                                         ),
  //                                       ),
  //                                       // Text(
  //                                       //     chatProvider.personalChatModelData.data[index1].unreadMessages < 1 ?
  //                                       //     "" :
  //                                       //     chatProvider.personalChatModelData.data[index1].unreadMessages.toString(),
  //                                       //     style: TextStyle(
  //                                       //         fontSize: 11.7.sp,
  //                                       //         fontWeight:
  //                                       //         FontWeight.w700,
  //                                       //         color: MateColors.activeIcons,
  //                                       //     ),
  //                                       // ),
  //                                       subtitle: StreamBuilder(
  //                                           stream: FirebaseFirestore.instance.collection('messages').doc(personChatId).collection(personChatId).orderBy('timestamp', descending: true).limit(1).snapshots(),
  //                                           // stream: DatabaseService().getLastPersonalChatMessage(personChatId),
  //                                           builder: (context, snapshot) {
  //                                             if (snapshot.hasData) {
  //                                               print(snapshot.data.docs);
  //                                               if (snapshot.data.docs.length > 0) {
  //                                                 return Text(
  //                                                   snapshot.data.docs[0].data()['type'] == 4?
  //                                                   "Audio" :
  //                                                   snapshot.data.docs[0].data()['type'] == 0 ?
  //                                                   "${snapshot.data.docs[0].data()['content']}" : snapshot.data.docs[0].data()['type'] == 1 ?
  //                                                   "🖼️ Image" :
  //                                                   snapshot.data.docs[0].data()['fileName'],
  //                                                   style: TextStyle(
  //                                                     fontFamily: "Poppins",
  //                                                     fontSize: 14.0,
  //                                                     letterSpacing: 0.1,
  //                                                     fontWeight: FontWeight.w400,
  //                                                     color: themeController.isDarkMode?
  //                                                     chatProvider.personalChatModelData.data[index1].unreadMessages >0?
  //                                                     Colors.white: MateColors.subTitleTextDark:
  //                                                     chatProvider.personalChatModelData.data[index1].unreadMessages >0?
  //                                                     MateColors.blackTextColor:
  //                                                     MateColors.subTitleTextLight,
  //                                                   ),
  //                                                   overflow: TextOverflow.ellipsis,
  //                                                 );
  //                                               } else
  //                                                 return Text(
  //                                                   "Tap to send message",
  //                                                   style: TextStyle(letterSpacing: 0.1,fontFamily: "Poppins",fontSize: 14.0, fontWeight: FontWeight.w400, color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight),
  //                                                   overflow: TextOverflow.ellipsis,
  //                                                 );
  //                                             } else
  //                                               return Text(
  //                                                 "Tap to send message",
  //                                                 style: TextStyle(letterSpacing: 0.1,fontFamily: "Poppins",fontSize: 14.0, fontWeight: FontWeight.w400, color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight),
  //                                                 overflow: TextOverflow.ellipsis,
  //                                               );
  //                                           }),
  //                                       trailing: chatProvider.personalChatModelData.data[index1].unreadMessages >0?
  //                                       Container(
  //                                         height: 20,
  //                                         width: 20,
  //                                         margin: EdgeInsets.only(right: 10),
  //                                         decoration: BoxDecoration(
  //                                           shape: BoxShape.circle,
  //                                           color: MateColors.activeIcons,
  //                                         ),
  //                                         child: Center(
  //                                           child: Text(
  //                                             chatProvider.personalChatModelData.data[index1].unreadMessages.toString(),
  //                                             style: TextStyle(fontFamily: "Poppins",
  //                                               fontSize: 12.0,
  //                                               fontWeight: FontWeight.w400,
  //                                               color: themeController.isDarkMode?MateColors.blackTextColor:Colors.white,
  //                                             ),
  //                                           ),
  //                                         ),
  //                                       ):Offstage(),
  //                                     ),
  //                                   );
  //                                 });
  //                           } else {
  //                             return Container();
  //                             //   Center(
  //                             //   child: CircularProgressIndicator(
  //                             //     backgroundColor: MateColors.activeIcons,
  //                             //   ),
  //                             // );
  //                           }
  //                         });
  //                   }),
  //             ],
  //           ),
  //         );
  //       }else{
  //         return Container();
  //       }
  //     },
  //   );
  // }

  Future<void> _showSendAlertDialog({@required Map messageData, @required String groupId,@required userImage}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: new Text("Are you sure?"),
          content: new Text("You want to send this message?"),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                DatabaseService().sendMessageForwarded(groupId, messageData,userImage);
              },
            ),
            CupertinoDialogAction(
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showSendAlertDialogPersonalMessage({@required Map messageData, @required String personChatId}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: new Text("Are you sure?"),
          content: new Text("You want to send this message?"),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text("Yes"),
              onPressed: ()async{
                Navigator.of(context).pop();
                var documentReference = FirebaseFirestore.instance.collection('messages').doc(personChatId).collection(personChatId).doc(DateTime.now().millisecondsSinceEpoch.toString());
                messageData["messageId"] = documentReference.id;
                FirebaseFirestore.instance.runTransaction((transaction) async {
                  await transaction.set(
                    documentReference,
                    messageData,
                  );
                });
                QuerySnapshot data = await FirebaseFirestore.instance.collection('messages').doc(personChatId).collection(personChatId).orderBy('timestamp', descending: true).get();
                Map<String, dynamic> body1={
                  "room_id": personChatId,
                  "read_by": _user.uid,
                  "messages_read": data.docs.length+1
                };
                Map<String, dynamic> body2={
                  "room_id": personChatId,
                  "receiver_uid": messageData["idTo"],
                  "total_messages": data.docs.length+1
                };

                Future.delayed(Duration.zero,(){
                  ChatService().personalChatMessageReadUpdate(body1);
                  ChatService().personalChatDataUpdate(body2);
                });
              },
            ),
            CupertinoDialogAction(
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}
