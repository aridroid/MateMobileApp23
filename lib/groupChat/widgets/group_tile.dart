import 'package:get/get.dart';
import 'package:mate_app/asset/Colors/MateColors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mate_app/constant.dart';
import 'package:mate_app/groupChat/pages/chat_page.dart';
import 'package:mate_app/groupChat/services/database_service.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../Providers/chatProvider.dart';
import '../../controller/theme_controller.dart';

class GroupTile extends StatelessWidget {
  final String userName;
  final String groupId;
  final String? photoURL;
  final String currentUserUid;
  final int unreadMessages;
  final bool isMuted;
  final bool isPinned;
  final Function loadData;
  final int index;
  final bool showColor;
  GroupTile({required this.userName, required this.groupId, this.photoURL, required this.currentUserUid, required this.unreadMessages, required this.isMuted, required this.loadData, required this.isPinned, required this.index,this.showColor=false});

  ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 0),
      child: StreamBuilder<DocumentSnapshot>(
          stream: DatabaseService().getLastChatMessage(groupId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Provider.of<ChatProvider>(context,listen: false).messageList[index].name = snapshot.data!['groupName'];
              Provider.of<ChatProvider>(context,listen: false).messageList[index].author = snapshot.data!["admin"];
              return Container(
                margin: EdgeInsets.only(left: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: showColor?themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight:Colors.transparent,
                ),
                child: ListTile(
                  onTap: ()async{
                    await Navigator.push(context, MaterialPageRoute(
                            builder: (context) => ChatPage(
                              groupId: groupId,
                              userName: userName,
                              groupName: snapshot.data!['groupName'],
                              photoURL: snapshot.data!['groupIcon'],
                              totalParticipant: snapshot.data!['members'].length.toString(),
                              memberList : snapshot.data!['members'],
                            )));
                    loadData();
                  },
                  leading: snapshot.data!['groupIcon'] != "" ?
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                    backgroundImage: NetworkImage(snapshot.data!['groupIcon']),
                  ):
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                    child: Text(snapshot.data!['groupName'].substring(0, 1).toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontSize: 12.5.sp, fontWeight: FontWeight.bold)),
                  ),
                  title: Padding(
                    padding: EdgeInsets.only(top: snapshot.data!['recentMessageSender'] != "" ? 0:10),
                    child: Row(
                      children: [
                        Flexible(
                          child: buildEmojiAndText(
                            content: snapshot.data!['groupName'],
                            textStyle: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w600,
                              color: themeController.isDarkMode?Colors.white: MateColors.blackTextColor,
                            ),
                            normalFontSize: 15,
                            emojiFontSize: 18,
                          ),
                        ),
                        isPinned?
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Image.asset("lib/asset/icons/pinToTop.png",
                            color: themeController.isDarkMode?MateColors.helpingTextLight:MateColors.iconPopupLight,
                            height: 14,
                            width: 19,
                          ),
                        ):Offstage(),
                        isMuted?
                        Padding(
                          padding: EdgeInsets.only(left: isPinned?5:10),
                          child: Image.asset("lib/asset/icons/mute.png",
                            color: themeController.isDarkMode?MateColors.helpingTextLight:MateColors.iconPopupLight,
                            height: 14,
                            width: 19,
                          ),
                        ):Offstage(),
                      ],
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.data!['recentMessageSender'] != "" ?
                          "${snapshot.data!['recentMessageSender']}" :
                          "Send first message to this group",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400,
                            color: themeController.isDarkMode?
                            unreadMessages >0?
                            Colors.white: Colors.white.withOpacity(0.5):
                            unreadMessages >0?
                            Colors.black: Colors.black.withOpacity(0.5),
                          ),
                          overflow: TextOverflow.clip,
                        ),
                        Text(
                            snapshot.data!.data().toString().contains('isAudio') && snapshot.data!['isAudio']? "Audio" :
                          "${snapshot.data!.data().toString().contains('isImage') ?
                          snapshot.data!['isImage'] ? " 🖼️ Image" :
                          snapshot.data!['isGif'] != null ? snapshot.data!['isGif'] ? " 🖼️ GIF File" :
                          snapshot.data!['isFile'] ? "File" :

                          snapshot.data!['recentMessage'].toString().contains('This is missed call@#%')?
                          snapshot.data!['recentMessage'].toString().split('___').last:snapshot.data!['recentMessage'] :
                          snapshot.data!['recentMessage'].toString().contains('This is missed call@#%')?
                          snapshot.data!['recentMessage'].toString().split('___').last:snapshot.data!['recentMessage'] :

                          snapshot.data!['recentMessage'].toString().contains('This is missed call@#%')?
                          snapshot.data!['recentMessage'].toString().split('___').last:snapshot.data!['recentMessage']

                          }",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400,
                            color: themeController.isDarkMode?
                            unreadMessages >0?
                            Colors.white: Colors.white.withOpacity(0.5):
                            unreadMessages >0?
                            Colors.black:
                            Colors.black.withOpacity(0.5),
                          ),
                          overflow: TextOverflow.clip,
                        ),
                      ],
                    ),
                  ),
                  trailing: unreadMessages >0 && isMuted==false?
                  Container(
                    height: 20,
                    width: 20,
                    margin: EdgeInsets.only(right: 10,top: 15),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                    ),
                    child: Center(
                      child: Text(
                        unreadMessages.toString(),
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
            } else
              return Container();
          }),
    );
  }
}
