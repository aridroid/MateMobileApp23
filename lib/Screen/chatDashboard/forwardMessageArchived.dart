import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../Providers/chatProvider.dart';
import '../../Services/chatService.dart';
import '../../asset/Colors/MateColors.dart';
import '../../controller/theme_controller.dart';
import '../../groupChat/services/database_service.dart';

class ForwardMessageArchiveView extends StatefulWidget {
  final Map messageData;
  const ForwardMessageArchiveView({Key key, this.messageData}) : super(key: key);

  @override
  State<ForwardMessageArchiveView> createState() => _ForwardMessageArchiveViewState();
}

class _ForwardMessageArchiveViewState extends State<ForwardMessageArchiveView> {
  ThemeController themeController = Get.find<ThemeController>();
  User _user = FirebaseAuth.instance.currentUser;
  String personChatId;

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
                    Container(
                      padding: EdgeInsets.only(top: 0),
                      child: StreamBuilder<DocumentSnapshot>(
                          stream: DatabaseService().getLastChatMessage(chatProvider.archiveList[indexMain].roomId),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return InkWell(
                                onTap: (){
                                  _showSendAlertDialog(
                                    groupId: chatProvider.archiveList[indexMain].roomId,
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
                                              chatProvider.archiveList[indexMain].unreadMessages >0?
                                              Colors.white: MateColors.subTitleTextDark:
                                              chatProvider.archiveList[indexMain].unreadMessages >0?
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
                                              chatProvider.archiveList[indexMain].unreadMessages >0?
                                              Colors.white: MateColors.subTitleTextDark:
                                              chatProvider.archiveList[indexMain].unreadMessages >0?
                                              MateColors.blackTextColor:
                                              MateColors.subTitleTextLight,
                                            ),
                                            overflow: TextOverflow.clip,
                                          ),
                                        ],
                                      ),
                                    ),
                                    trailing: chatProvider.archiveList[indexMain].unreadMessages >0?
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
                            } else
                              return Container();
                          }),
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
                                  if (_user.uid.hashCode <= {
                                    snapshot.data.docs[index].data()["uid"]
                                  }.hashCode) {
                                    personChatId = '${_user.uid}-${snapshot.data.docs[index].data()["uid"]}';
                                  } else {
                                    personChatId = '${snapshot.data.docs[index].data()["uid"]}-${_user.uid}';
                                  }
                                  return Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                                    child: ListTile(
                                      onTap: (){
                                        String personChatIdLocal;

                                        personChatIdLocal = chatProvider.archiveList[indexMain].roomId;


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
