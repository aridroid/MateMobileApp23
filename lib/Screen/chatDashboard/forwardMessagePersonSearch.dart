import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mate_app/Services/chatService.dart';
import 'package:provider/provider.dart';

import '../../Providers/chatProvider.dart';
import '../../asset/Colors/MateColors.dart';
import '../../controller/theme_controller.dart';
import '../../groupChat/pages/groupMembersPage.dart';
import '../../groupChat/services/database_service.dart';

class ForwardMessagePersonSearch extends StatefulWidget {
  final Map messageData;
  const ForwardMessagePersonSearch({Key? key, required this.messageData}) : super(key: key);

  @override
  _ForwardMessagePersonSearchState createState() => _ForwardMessagePersonSearchState();
}

class _ForwardMessagePersonSearchState extends State<ForwardMessagePersonSearch> {
  ThemeController themeController = Get.find<ThemeController>();
  late QuerySnapshot searchResultSnapshot;
  bool isLoading = true;
  bool hasUserSearched = false;
  User _user = FirebaseAuth.instance.currentUser!;
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
    return ListView(
      shrinkWrap: true,
      children: [
        ListView.builder(
            shrinkWrap: true,
            itemCount: userList.length,
            physics: ScrollPhysics(),
            addAutomaticKeepAlives: true,
            itemBuilder: (context, index) {
              return StreamBuilder<QuerySnapshot>(
                stream: DatabaseService().getPeerChatUserDetail(userList[index].uid),
                builder: (context, snapshot) {
                  if(snapshot.hasData) {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        physics: ScrollPhysics(),
                        itemBuilder: (context, index1) {
                          return Visibility(
                            //searchedName==""?true:
                            visible: searchedName!="" && userList[index].displayName.toString().toLowerCase().contains(searchedName.toLowerCase()),
                            child: InkWell(
                              onTap: (){
                                String personChatIdLocal;

                                if (_user.uid.hashCode <= snapshot.data!.docs[index1].get('uid').hashCode) {
                                  personChatIdLocal = '${_user.uid}-${snapshot.data!.docs[index1].get('uid')}';
                                } else {
                                  personChatIdLocal = '${snapshot.data!.docs[index1].get('uid')}-${_user.uid}';
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

                                Map<String, dynamic> chatMessageMapLocal = {'idFrom': _user.uid, 'idTo': snapshot.data!.docs[index1].get('uid'), 'timestamp': DateTime.now().millisecondsSinceEpoch.toString(), 'content': message.trim(), 'type': type,"isForwarded":true};

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
                              child: groupTile(
                                userList[index].uuid,
                                userList[index].uid,
                                userList[index].displayName,
                                userList[index].photoURL,
                                userList[index].email,
                                index==0? true: userList[index].displayName[0].toLowerCase() != userList[index-1].displayName[0].toLowerCase()? true : false,
                              ),
                            ),
                          );
                        });
                  }else{
                    return Container();
                  }
                });
            }),
      ],
    );
  }

  Widget groupTile(String peerUuid,String peerId, String peerName, String peerAvatar,String email,bool showOrNot) {
    return Column(
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
    );
  }

  Future<void> _showSendAlertDialogPersonalMessage({required Map messageData, required String personChatId}) async {
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
                FirebaseFirestore.instance.runTransaction((transaction) async {
                  await transaction.set(
                    documentReference,
                    messageData,
                  );
                });
                FirebaseFirestore.instance.collection('chat-users').doc(_user.uid).update({
                  'chattingWith': FieldValue.arrayUnion([messageData["idTo"]])
                });
                FirebaseFirestore.instance.collection('chat-users').doc(messageData["idTo"]).update({
                  'chattingWith': FieldValue.arrayUnion([_user.uid])
                });

                QuerySnapshot data = await FirebaseFirestore.instance.collection('messages').doc(personChatId).collection(personChatId).orderBy('timestamp', descending: true).get();
                Map<String, dynamic> body1={
                  "room_id": personChatId,
                  "read_by": _user.uid,
                  "messages_read": data.docs.length+1//listMessage.length+1
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
