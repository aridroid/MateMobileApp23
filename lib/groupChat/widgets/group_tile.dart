import 'package:get/get.dart';
import 'package:mate_app/asset/Colors/MateColors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mate_app/groupChat/pages/chat_page.dart';
import 'package:mate_app/groupChat/services/database_service.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../Providers/chatProvider.dart';
import '../../Utility/Utility.dart';
import '../../controller/theme_controller.dart';

class GroupTile extends StatelessWidget {
  final String userName;
  final String groupId;

  // final String groupName;
  final String photoURL;
  final String currentUserUid;
  final int unreadMessages;
  final bool isMuted;
  final bool isPinned;
  final Function loadData;

  GroupTile({this.userName, this.groupId, /*this.groupName,*/ this.photoURL, this.currentUserUid, this.unreadMessages, this.isMuted, this.loadData, this.isPinned});
  ThemeController themeController = Get.find<ThemeController>();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 0),
      child: StreamBuilder<DocumentSnapshot>(
          stream: DatabaseService().getLastChatMessage(groupId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // Future.delayed(Duration.zero,(){
              //   Provider.of<ChatProvider>(context,listen: false).groupChatDataFetch(currentUserUid);
              // });
              return Container(
                //alignment: Alignment.center,
                margin: EdgeInsets.only(left: 10),
                //height: 70.0.sp,
                child: ListTile(
                  dense: true,
                  onTap: ()async{
                    await Navigator.push(context, MaterialPageRoute(
                            builder: (context) => ChatPage(
                              groupId: groupId,
                              userName: userName,
                              groupName: snapshot.data['groupName'],
                              photoURL: snapshot.data['groupIcon'],
                              totalParticipant: snapshot.data['members'].length.toString(),
                              memberList : snapshot.data['members'],
                            )));
                    loadData();
                  },
                  leading: snapshot.data['groupIcon'] != ""
                      ? CircleAvatar(
                         radius: 24,
                          backgroundColor: MateColors.activeIcons,
                          backgroundImage: NetworkImage(snapshot.data['groupIcon']),
                        )
                      : CircleAvatar(
                          radius: 24,
                          backgroundColor: MateColors.activeIcons,
                          child: Text(snapshot.data['groupName'].substring(0, 1).toUpperCase(),
                              textAlign: TextAlign.center,
                              style: TextStyle(color: themeController.isDarkMode?Colors.black:Colors.white, fontSize: 12.5.sp, fontWeight: FontWeight.bold)),
                        ),
                  title: Padding(
                    padding: EdgeInsets.only(top: snapshot.data['recentMessageSender'] != "" ? 0:10),
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(snapshot.data['groupName'],
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 15.0,
                              fontWeight: FontWeight.w500,
                              color: themeController.isDarkMode ? Colors.white : MateColors.blackTextColor,
                            ),
                          ),
                        ),
                        isPinned?
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Image.asset("lib/asset/icons/pinToTop.png",
                            color: Color(0xFFFF8740),
                            height: 14,
                            width: 19,
                          ),
                        ):Offstage(),
                        isMuted?
                        Padding(
                          padding: EdgeInsets.only(left: isPinned?5:10),
                          child: Image.asset("lib/asset/icons/mute.png",
                            color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
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
                          snapshot.data['recentMessageSender'] != "" ?
                          "${snapshot.data['recentMessageSender']}" :
                          "Send first message to this group",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 14.0,
                            letterSpacing: 0.1,
                            fontWeight: FontWeight.w400,
                            color: themeController.isDarkMode?
                            unreadMessages >0?
                            Colors.white: MateColors.subTitleTextDark:
                            unreadMessages >0?
                            MateColors.blackTextColor:
                            MateColors.subTitleTextLight,
                          ),
                          overflow: TextOverflow.clip,
                        ),
                        Text(
                          "${snapshot.data.data().toString().contains('isImage') ? snapshot.data['isImage'] ? " 🖼️ Image" : snapshot.data['isGif'] != null ? snapshot.data['isGif'] ? " 🖼️ GIF File" : snapshot.data['isFile'] ? "File" : snapshot.data['recentMessage'] : snapshot.data['recentMessage'] : snapshot.data['recentMessage']}",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 14.0,
                            letterSpacing: 0.1,
                            fontWeight: FontWeight.w400,
                            color: themeController.isDarkMode?
                            unreadMessages >0?
                            Colors.white: MateColors.subTitleTextDark:
                            unreadMessages >0?
                            MateColors.blackTextColor:
                            MateColors.subTitleTextLight,
                          ),
                          overflow: TextOverflow.clip,
                        ),
                        // Text(
                        //   snapshot.data.data()['recentMessageTime'].toString() != ""
                        //       ? "    ${DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(int.parse(snapshot.data.data()['recentMessageTime'].toString())))}"
                        //       : "",
                        //   style: TextStyle(fontSize: 8.4.sp, fontWeight: FontWeight.w100, color: Colors.grey[50]),
                        //   overflow: TextOverflow.ellipsis,
                        // ),
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
                      color: MateColors.activeIcons,
                    ),
                    child: Center(
                      child: Text(
                        unreadMessages.toString(),
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
            } else
              return Container();

                //Text("Loading groups...", style: TextStyle(fontSize: 10.0.sp));
          }),
    );
  }
}
