import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:get/get.dart';
import 'package:mate_app/Utility/Utility.dart';
import 'package:mate_app/Widget/Loaders/Shimmer.dart';
import 'package:mate_app/groupChat/pages/customAlertDialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Providers/AuthUserProvider.dart';
import '../../../Services/community_tab_services.dart';
import '../../../asset/Colors/MateColors.dart';
import '../../../asset/Reactions/reactionsContants.dart';
import '../../../groupChat/services/database_service.dart';
import '../../Profile/ProfileScreen.dart';
import '../../Profile/UserProfileScreen.dart';
import '../../chatDashboard/forwardMessagePage.dart';

class PersonMessageTile extends StatefulWidget {
  final String message;
  final String sender;
  final bool sentByMe;
  final String messageTime;
  final bool isImage;
  final bool isFile;
  final String fileExtension;
  final String fileName;
  final String fileSize;
  final String fileSizeUnit;
  final int index;
  final List<String> date;
  final List<String> time;
  final bool isForwarded;
  List<dynamic> messageReaction;
  final String messageId;
  final String userId;
  final String displayName;
  final String photo;
  final String personChatId;
  final int fileSizeFull;
  Function(String message,String name,bool selected) selectMessage;
  final String previousMessage;
  final String previousSender;
  final String roomId;
  final bool isAudio;
  final bool isPlaying;
  final bool isPaused;
  final bool isLoadingAudio;
  Function(String url,int index) startAudio;
  Function(int index) pauseAudio;
  Duration duration;
  Duration currentDuration;
  PersonMessageTile({this.currentDuration,this.duration,this.pauseAudio,this.startAudio,this.isForwarded,this.message, this.sender, this.sentByMe, this.messageTime, this.isImage = false, this.isFile = false, this.fileExtension, this.fileName, this.fileSize, this.fileSizeUnit, this.index, this.date, this.time,this.messageReaction, this.messageId, this.userId, this.displayName, this.photo, this.personChatId, this.fileSizeFull, this.previousMessage, this.previousSender,this.selectMessage, this.roomId, this.isAudio, this.isPlaying, this.isPaused, this.isLoadingAudio});

  @override
  State<PersonMessageTile> createState() => _PersonMessageTileState();
}

class _PersonMessageTileState extends State<PersonMessageTile> {
  @override
  Widget build(BuildContext context) {

    int firstLength = 0;
    int secondLength = 0;
    int thirdLength = 0;
    int fourthLength = 0;
    int fifthLength = 0;
    int sixthLength = 0;
    int sevenLength = 0;

    for(int i=0;i<widget.messageReaction.length;i++){
      List<String> split = widget.messageReaction[i].toString().split("_____");
      if(int.parse(split[3]) == 0){
        firstLength = firstLength + 1;
      }else if(int.parse(split[3]) == 1){
        secondLength = secondLength +1;
      }else if(int.parse(split[3]) == 2){
        thirdLength = thirdLength +1;
      }else if(int.parse(split[3]) == 3){
        fourthLength = fourthLength +1;
      }else if(int.parse(split[3]) == 4){
        fifthLength = fifthLength +1;
      }else if(int.parse(split[3]) == 5){
        sixthLength = sixthLength +1;
      }else if(int.parse(split[3]) == 6){
        sevenLength = sevenLength +1;
      }
    }

    return Column(
      crossAxisAlignment: widget.sentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        widget.index == 0?
        Padding(
          padding: const EdgeInsets.only(left: 16,right: 16,top: 35,bottom: 16),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 1,
                  color: themeController.isDarkMode?MateColors.darkDivider:MateColors.lightDivider,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20,right: 20),
                child: Text(
                  widget.date[widget.index],
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: "Poppins",
                    color: widget.sentByMe?
                    themeController.isDarkMode? MateColors.subTitleTextDark: MateColors.subTitleTextLight:
                    themeController.isDarkMode? MateColors.subTitleTextDark: MateColors.subTitleTextLight,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 1,
                  color: themeController.isDarkMode?MateColors.darkDivider:MateColors.lightDivider,
                ),
              ),
            ],
          ),
        ):
        widget.date[widget.index] != widget.date[widget.index-1]?
        Padding(
          padding: const EdgeInsets.only(left: 16,right: 16,top: 35,bottom: 16),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 1,
                  color: themeController.isDarkMode?MateColors.darkDivider:MateColors.lightDivider,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20,right: 20),
                child: Text(
                  widget.date[widget.index],
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: "Poppins",
                    color: widget.sentByMe?
                    themeController.isDarkMode? MateColors.subTitleTextDark: MateColors.subTitleTextLight:
                    themeController.isDarkMode? MateColors.subTitleTextDark: MateColors.subTitleTextLight,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 1,
                  color: themeController.isDarkMode?MateColors.darkDivider:MateColors.lightDivider,
                ),
              ),
            ],
          ),
        ):Offstage(),
        SwipeTo(
          onRightSwipe: (){
            widget.selectMessage(widget.message.trim(),widget.sender,true);
          },
          child: FocusedMenuHolder(
            menuWidth: MediaQuery.of(context).size.width*0.78,
            blurSize: 5.0,
            menuItemExtent: 45,
            menuBoxDecoration: BoxDecoration(
              //color: Colors.red,
              //shape: BoxShape.rectangle,
              gradient: LinearGradient(colors: themeController.isDarkMode?[MateColors.drawerTileColor,MateColors.drawerTileColor]:[Colors.white,Colors.white]),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            duration: Duration(milliseconds: 100),
            animateMenuItems: true,
            blurBackgroundColor: Colors.black54,
            openWithTap: false, // Open Focused-Menu on Tap rather than Long Press
            menuOffset: 16.0, // Offset value to show menuItem from the selected item
            bottomOffsetHeight: 80.0, // Offset height to consider, for showing the menu item ( for example bottom navigation bar), so that the popup menu will be shown on top of selected item.
            menuItems: <FocusedMenuItem>[
              FocusedMenuItem(
                title: Row(
                  children: [
                    InkWell(
                      onTap: ()async{
                        Navigator.pop(context);
                        String previousValue = "";
                        bool add = true;
                        print(widget.messageId);
                        if(widget.messageId!=""){
                          for(int i=0; i< widget.messageReaction.length ;i++){
                            if(widget.messageReaction[i].contains(widget.userId)){
                              add = false;
                              previousValue = widget.messageReaction[i];
                              await DatabaseService(uid: widget.userId).updateMessageReactionOneToOne(widget.personChatId, widget.messageId,previousValue);
                              await DatabaseService(uid: widget.userId).setMessageReactionOneToOne(widget.personChatId, widget.messageId, 0.toString(),widget.displayName,widget.photo);
                              break;
                            }
                          }
                          if(add){
                            DatabaseService(uid: widget.userId).setMessageReactionOneToOne(widget.personChatId, widget.messageId, 0.toString(),widget.displayName,widget.photo);
                          }
                        }
                      },
                      child: Image.asset(chatReactionImages[0],
                        height: 30,
                        width: 30,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: InkWell(
                        onTap: ()async{
                          Navigator.pop(context);
                          String previousValue = "";
                          bool add = true;
                          print(widget.messageId);
                          if(widget.messageId!=""){
                            for(int i=0; i< widget.messageReaction.length ;i++){
                              if(widget.messageReaction[i].contains(widget.userId)){
                                add = false;
                                previousValue = widget.messageReaction[i];
                                await DatabaseService(uid: widget.userId).updateMessageReactionOneToOne(widget.personChatId, widget.messageId,previousValue);
                                await DatabaseService(uid: widget.userId).setMessageReactionOneToOne(widget.personChatId, widget.messageId, 1.toString(),widget.displayName,widget.photo);
                                break;
                              }
                            }
                            if(add){
                              DatabaseService(uid: widget.userId).setMessageReactionOneToOne(widget.personChatId, widget.messageId, 1.toString(),widget.displayName,widget.photo);
                            }
                          }
                        },
                        child: Image.asset(chatReactionImages[1],
                          height: 30,
                          width: 30,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: InkWell(
                        onTap: ()async{
                          Navigator.pop(context);
                          String previousValue = "";
                          bool add = true;
                          print(widget.messageId);
                          if(widget.messageId!=""){
                            for(int i=0; i< widget.messageReaction.length ;i++){
                              if(widget.messageReaction[i].contains(widget.userId)){
                                add = false;
                                previousValue = widget.messageReaction[i];
                                await DatabaseService(uid: widget.userId).updateMessageReactionOneToOne(widget.personChatId, widget.messageId,previousValue);
                                await DatabaseService(uid: widget.userId).setMessageReactionOneToOne(widget.personChatId, widget.messageId, 2.toString(),widget.displayName,widget.photo);
                                break;
                              }
                            }
                            if(add){
                              DatabaseService(uid: widget.userId).setMessageReactionOneToOne(widget.personChatId, widget.messageId, 2.toString(),widget.displayName,widget.photo);
                            }
                          }
                        },
                        child: Image.asset(chatReactionImages[2],
                          height: 30,
                          width: 30,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: InkWell(
                        onTap: ()async{
                          Navigator.pop(context);
                          String previousValue = "";
                          bool add = true;
                          print(widget.messageId);
                          if(widget.messageId!=""){
                            for(int i=0; i< widget.messageReaction.length ;i++){
                              if(widget.messageReaction[i].contains(widget.userId)){
                                add = false;
                                previousValue = widget.messageReaction[i];
                                await DatabaseService(uid: widget.userId).updateMessageReactionOneToOne(widget.personChatId, widget.messageId,previousValue);
                                await DatabaseService(uid: widget.userId).setMessageReactionOneToOne(widget.personChatId, widget.messageId, 3.toString(),widget.displayName,widget.photo);
                                break;
                              }
                            }
                            if(add){
                              DatabaseService(uid: widget.userId).setMessageReactionOneToOne(widget.personChatId, widget.messageId, 3.toString(),widget.displayName,widget.photo);
                            }
                          }
                        },
                        child: Image.asset(chatReactionImages[3],
                          height: 30,
                          width: 30,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: InkWell(
                        onTap: ()async{
                          Navigator.pop(context);
                          String previousValue = "";
                          bool add = true;
                          print(widget.messageId);
                          if(widget.messageId!=""){
                            for(int i=0; i< widget.messageReaction.length ;i++){
                              if(widget.messageReaction[i].contains(widget.userId)){
                                add = false;
                                previousValue = widget.messageReaction[i];
                                await DatabaseService(uid: widget.userId).updateMessageReactionOneToOne(widget.personChatId, widget.messageId,previousValue);
                                await DatabaseService(uid: widget.userId).setMessageReactionOneToOne(widget.personChatId, widget.messageId, 4.toString(),widget.displayName,widget.photo);
                                break;
                              }
                            }
                            if(add){
                              DatabaseService(uid: widget.userId).setMessageReactionOneToOne(widget.personChatId, widget.messageId, 4.toString(),widget.displayName,widget.photo);
                            }
                          }
                        },
                        child: Image.asset(chatReactionImages[4],
                          height: 30,
                          width: 30,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: InkWell(
                        onTap: ()async{
                          Navigator.pop(context);
                          String previousValue = "";
                          bool add = true;
                          print(widget.messageId);
                          if(widget.messageId!=""){
                            for(int i=0; i< widget.messageReaction.length ;i++){
                              if(widget.messageReaction[i].contains(widget.userId)){
                                add = false;
                                previousValue = widget.messageReaction[i];
                                await DatabaseService(uid: widget.userId).updateMessageReactionOneToOne(widget.personChatId, widget.messageId,previousValue);
                                await DatabaseService(uid: widget.userId).setMessageReactionOneToOne(widget.personChatId, widget.messageId, 5.toString(),widget.displayName,widget.photo);
                                break;
                              }
                            }
                            if(add){
                              DatabaseService(uid: widget.userId).setMessageReactionOneToOne(widget.personChatId, widget.messageId, 5.toString(),widget.displayName,widget.photo);
                            }
                          }
                        },
                        child: Image.asset(chatReactionImages[5],
                          height: 30,
                          width: 30,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: InkWell(
                        onTap: ()async{
                          Navigator.pop(context);
                          String previousValue = "";
                          bool add = true;
                          print(widget.messageId);
                          if(widget.messageId!=""){
                            for(int i=0; i< widget.messageReaction.length ;i++){
                              if(widget.messageReaction[i].contains(widget.userId)){
                                add = false;
                                previousValue = widget.messageReaction[i];
                                await DatabaseService(uid: widget.userId).updateMessageReactionOneToOne(widget.personChatId, widget.messageId,previousValue);
                                await DatabaseService(uid: widget.userId).setMessageReactionOneToOne(widget.personChatId, widget.messageId, 6.toString(),widget.displayName,widget.photo);
                                break;
                              }
                            }
                            if(add){
                              DatabaseService(uid: widget.userId).setMessageReactionOneToOne(widget.personChatId, widget.messageId, 6.toString(),widget.displayName,widget.photo);
                            }
                          }
                        },
                        child: Image.asset(chatReactionImages[6],
                          height: 30,
                          width: 30,
                        ),
                      ),
                    ),
                  ],
                ),
                backgroundColor: themeController.isDarkMode?MateColors.drawerTileColor:Colors.white,
                onPressed: (){},
              ),
              if(widget.sentByMe)
                FocusedMenuItem(
                  title: Row(
                    children: [
                      Image.asset(
                        "lib/asset/icons/delete.png",
                        color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
                        height: 20,
                        width: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Text(
                          "Delete",
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w500,
                            color: themeController.isDarkMode?Colors.white: MateColors.blackTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: themeController.isDarkMode?MateColors.drawerTileColor:Colors.white,
                  onPressed: ()async{
                    if(widget.messageId!="")
                     await DatabaseService().deleteMessageOneToOne(widget.personChatId,widget.messageId);
                  },
                ),
                FocusedMenuItem(
                title: Row(
                  children: [
                    Image.asset(
                      "lib/asset/icons/forward.png",
                      color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
                      height: 20,
                      width: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text(
                        "Forward",
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w500,
                          color: themeController.isDarkMode?Colors.white: MateColors.blackTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
                backgroundColor: themeController.isDarkMode?MateColors.drawerTileColor:Colors.white,
                onPressed: (){
                  Map<String, dynamic> chatMessageMap = {
                    "message": widget.message,
                    "sender": widget.displayName,
                    'senderId': widget.userId,
                    'time': DateTime.now().millisecondsSinceEpoch,
                    'isImage': widget.isImage,
                    'isFile': widget.isFile,
                    'isGif' : false,
                    'isAudio':widget.isAudio,
                  };
                  if (widget.fileExtension.isNotEmpty) {
                    chatMessageMap['fileExtension'] = widget.fileExtension;
                  }
                  if (widget.fileName.isNotEmpty) {
                    chatMessageMap['fileName'] = widget.fileName;
                  }
                  if (widget.fileSizeFull>0) {
                    chatMessageMap['fileSize'] = widget.fileSizeFull;
                  }

                  Get.to(ForwardMessagePage(messageData: chatMessageMap,));
                  //DatabaseService().sendMessage(widget.groupId, chatMessageMap,widget.photo);
                },
              ),
              FocusedMenuItem(
                title: Row(
                  children: [
                    Image.asset(
                      "lib/asset/icons/reply.png",
                      color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
                      height: 20,
                      width: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text(
                        "Reply",
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w500,
                          color: themeController.isDarkMode?Colors.white: MateColors.blackTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
                backgroundColor: themeController.isDarkMode?MateColors.drawerTileColor:Colors.white,
                onPressed: (){
                  widget.selectMessage(widget.message.trim(),widget.sender,true);
                },
              ),
              FocusedMenuItem(
                title: Row(
                  children: [
                    Image.asset(
                      "lib/asset/icons/copy.png",
                      color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
                      height: 20,
                      width: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text(
                        "Copy",
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w500,
                          color: themeController.isDarkMode?Colors.white: MateColors.blackTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
                backgroundColor: themeController.isDarkMode?MateColors.drawerTileColor:Colors.white,
                onPressed: (){
                  Clipboard.setData(ClipboardData(text: widget.message));
                },
              ),
              if(!widget.sentByMe)
                FocusedMenuItem(
                  title: Row(
                    children: [
                      Image.asset(
                        "lib/asset/icons/report.png",
                        height: 20,
                        width: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Text(
                          "Report",
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w500,
                            color: themeController.isDarkMode?Colors.white: MateColors.blackTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: themeController.isDarkMode?MateColors.drawerTileColor:Colors.white,
                  onPressed: ()async{
                    SharedPreferences preferences = await SharedPreferences.getInstance();
                    String token = preferences.getString("token");
                    bool response = await CommunityTabService().reportPersonalMessage(roomId: widget.roomId, messageId: widget.messageId, uid: widget.userId, token: token,);
                    if(response){
                      Fluttertoast.showToast(msg: "Your feedback added successfully", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
                    }else{
                      Fluttertoast.showToast(msg: "Something went wrong", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
                    }
                  },
                ),
            ],
            onPressed: (){},
            child: Container(
              padding: EdgeInsets.only(top: 4, bottom: 4, left: widget.sentByMe ? 0 : 24, right: widget.sentByMe ? 24 : 0),
              alignment: widget.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                margin: widget.sentByMe ? EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.2,top: 10) : EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.2,top: 10),
                padding: EdgeInsets.only(top: widget.isImage ? 15 : 15, bottom: 15, left: 20, right:20),
                decoration: BoxDecoration(
                  borderRadius: widget.sentByMe
                      ? BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20), bottomLeft: Radius.circular(20))
                      : BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
                  color: widget.sentByMe ? chatTealColor : themeController.isDarkMode? chatGreyColor: MateColors.lightDivider,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    widget.isForwarded?
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                        Image.asset(
                          "lib/asset/icons/forward.png",
                          color: themeController.isDarkMode?
                          widget.sentByMe?MateColors.blackTextColor : Colors.white:
                          widget.sentByMe?
                          Colors.white :MateColors.blackTextColor,
                          height: 18,
                          width: 18,
                        ),
                        SizedBox(width: 5,),
                        Text("Forwarded",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 12.0,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.1,
                            color: widget.sentByMe?
                            themeController.isDarkMode? MateColors.blackTextColor: Colors.white:
                            themeController.isDarkMode? Colors.white : MateColors.blackTextColor,
                          ),
                        ),
                      ]),
                    ):SizedBox(),

                    widget.previousMessage!=""?
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color:  widget.sentByMe?
                              themeController.isDarkMode? MateColors.blackTextColor: Colors.white:
                              themeController.isDarkMode? Colors.white : MateColors.blackTextColor,
                            ),
                            borderRadius: BorderRadius.circular(5),
                            //color: themeController.isDarkMode?MateColors.iconLight:MateColors.lightDivider,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.displayName==widget.previousSender?"You":
                                widget.previousSender,
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.1,
                                  color: widget.sentByMe?
                                  themeController.isDarkMode? MateColors.blackTextColor: Colors.white:
                                  themeController.isDarkMode? Colors.white : MateColors.blackTextColor,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                widget.previousMessage,
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.1,
                                  color: widget.sentByMe?
                                  themeController.isDarkMode? MateColors.blackTextColor: Colors.white:
                                  themeController.isDarkMode? Colors.white : MateColors.blackTextColor,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                      ],
                    ):Offstage(),


                    widget.isImage ? _chatImage(widget.message, context) :
                    widget.isFile ? _chatFile(widget.message, context) :
                    widget.isAudio?_chatAudio(widget.message, context):
                    Linkify(
                      onOpen: (link) async {
                        print("Clicked ${link.url}!");
                        if (await canLaunch(link.url))
                          await launch(link.url);
                        else
                          throw "Could not launch ${link.url}";
                      },
                      text: widget.message.trim(),
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.1,
                        color: widget.sentByMe?
                        themeController.isDarkMode? MateColors.blackTextColor: Colors.white:
                        themeController.isDarkMode? Colors.white : MateColors.blackTextColor,
                      ),
                      textAlign: TextAlign.start,
                      linkStyle: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontSize: 14.0,letterSpacing: 0.1),
                    ),
                    // Text(message.trim(),
                    //   textAlign: TextAlign.start,
                    //   style: TextStyle(
                    //     fontFamily: "Poppins",
                    //     fontSize: 14.0,
                    //     fontWeight: FontWeight.w400,
                    //     letterSpacing: 0.1,
                    //     color: sentByMe?
                    //     themeController.isDarkMode? MateColors.blackTextColor: Colors.white:
                    //     themeController.isDarkMode? Colors.white : MateColors.blackTextColor,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),

        InkWell(
          onTap: (){
            showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(25),
                    topLeft: Radius.circular(25),
                  ),
                ),
                backgroundColor: themeController.isDarkMode?backgroundColor:Colors.white,
                builder: (context) {
                  return DefaultTabController(
                    initialIndex: 0,
                    length: 8,
                    child: Column(
                      children: [
                        TabBar(
                          unselectedLabelColor: Color(0xFF656568),
                          indicatorColor: MateColors.activeIcons,
                          labelColor: themeController.isDarkMode ? Colors.white : MateColors.blackTextColor,
                          labelPadding: EdgeInsets.only(left: 10,right: 10),
                          tabs: <Widget>[
                            Tab(
                              text: "All",
                            ),
                            Tab(
                              icon: Image.asset(chatReactionImages[0]),
                              height: 20,
                            ),
                            Tab(
                              icon: Image.asset(chatReactionImages[1]),
                              height: 20,
                            ),
                            Tab(
                              icon: Image.asset(chatReactionImages[2]),
                              height: 20,
                            ),
                            Tab(
                              icon: Image.asset(chatReactionImages[3]),
                              height: 20,
                            ),
                            Tab(
                              icon: Image.asset(chatReactionImages[4]),
                              height: 20,
                            ),
                            Tab(
                              icon: Image.asset(chatReactionImages[5]),
                              height: 20,
                            ),
                            Tab(
                              icon: Image.asset(chatReactionImages[6]),
                              height: 20,
                            ),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            children: <Widget>[
                              ListView.builder(
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  padding: EdgeInsets.only(left: 10, right: 20,top: 0,bottom: 30),
                                  itemCount: widget.messageReaction.length,
                                  itemBuilder: (context, index) {
                                    List<String> split = widget.messageReaction[index].toString().split("_____");
                                    print(widget.messageReaction.length);
                                    return FutureBuilder(
                                      future: DatabaseService().getUsersDetails(widget.messageReaction[index].toString().split("_____")[0]),
                                      builder: (context, snapshot1) {
                                        return Padding(
                                          padding: const EdgeInsets.only(top: 10),
                                          child: InkWell(
                                            onTap: (){
                                              if (snapshot1.data.data()['uuid'] != null) {
                                                if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == snapshot1.data.data()['uuid']) {
                                                  Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                                                } else {
                                                  Navigator.of(context).pushNamed(UserProfileScreen.routeName, arguments: {
                                                    "id": snapshot1.data.data()['uuid'],
                                                    "name": snapshot1.data.data()['displayName'],
                                                    "photoUrl": snapshot1.data.data()['photoURL'],
                                                    "firebaseUid": snapshot1.data.data()['uid']
                                                  });
                                                }
                                              }
                                            },
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 20,
                                                      backgroundColor: MateColors.activeIcons,
                                                      backgroundImage: NetworkImage(split[2]),
                                                    ),
                                                    SizedBox(width: 20,),
                                                    Text(split[1],
                                                      style: TextStyle(color: themeController.isDarkMode?Colors.white:Colors.black, fontSize: 12.5.sp, fontWeight: FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                                Image.asset(chatReactionImages[int.parse(split[3])],height: 20,width: 20,),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }),
                              ListView.builder(
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  padding: EdgeInsets.only(left: 10, right: 20,top: 0,bottom: 30),
                                  itemCount: widget.messageReaction.length,
                                  itemBuilder: (context, index) {
                                    List<String> split = widget.messageReaction[index].toString().split("_____");
                                    print(widget.messageReaction.length);
                                    return int.parse(split[3])==0?
                                    FutureBuilder(
                                      future: DatabaseService().getUsersDetails(widget.messageReaction[index].toString().split("_____")[0]),
                                      builder: (context, snapshot1) {
                                        return Padding(
                                          padding: const EdgeInsets.only(top: 10),
                                          child: InkWell(
                                            onTap: (){
                                              if (snapshot1.data.data()['uuid'] != null) {
                                                if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == snapshot1.data.data()['uuid']) {
                                                  Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                                                } else {
                                                  Navigator.of(context).pushNamed(UserProfileScreen.routeName, arguments: {
                                                    "id": snapshot1.data.data()['uuid'],
                                                    "name": snapshot1.data.data()['displayName'],
                                                    "photoUrl": snapshot1.data.data()['photoURL'],
                                                    "firebaseUid": snapshot1.data.data()['uid']
                                                  });
                                                }
                                              }
                                            },
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 20,
                                                      backgroundColor: MateColors.activeIcons,
                                                      backgroundImage: NetworkImage(split[2]),
                                                    ),
                                                    SizedBox(width: 20,),
                                                    Text(split[1],
                                                      style: TextStyle(color: themeController.isDarkMode?Colors.white:Colors.black, fontSize: 12.5.sp, fontWeight: FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                                Image.asset(chatReactionImages[int.parse(split[3])],height: 20,width: 20,),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ):
                                    Offstage();
                                  }),
                              ListView.builder(
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  padding: EdgeInsets.only(left: 10, right: 20,top: 0,bottom: 30),
                                  itemCount: widget.messageReaction.length,
                                  itemBuilder: (context, index) {
                                    List<String> split = widget.messageReaction[index].toString().split("_____");
                                    print(widget.messageReaction.length);
                                    return int.parse(split[3])==1?
                                    FutureBuilder(
                                      future: DatabaseService().getUsersDetails(widget.messageReaction[index].toString().split("_____")[0]),
                                      builder: (context, snapshot1) {
                                        return Padding(
                                          padding: const EdgeInsets.only(top: 10),
                                          child: InkWell(
                                            onTap: (){
                                              if (snapshot1.data.data()['uuid'] != null) {
                                                if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == snapshot1.data.data()['uuid']) {
                                                  Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                                                } else {
                                                  Navigator.of(context).pushNamed(UserProfileScreen.routeName, arguments: {
                                                    "id": snapshot1.data.data()['uuid'],
                                                    "name": snapshot1.data.data()['displayName'],
                                                    "photoUrl": snapshot1.data.data()['photoURL'],
                                                    "firebaseUid": snapshot1.data.data()['uid']
                                                  });
                                                }
                                              }
                                            },
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 20,
                                                      backgroundColor: MateColors.activeIcons,
                                                      backgroundImage: NetworkImage(split[2]),
                                                    ),
                                                    SizedBox(width: 20,),
                                                    Text(split[1],
                                                      style: TextStyle(color: themeController.isDarkMode?Colors.white:Colors.black, fontSize: 12.5.sp, fontWeight: FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                                Image.asset(chatReactionImages[int.parse(split[3])],height: 20,width: 20,),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ):
                                    Offstage();
                                  }),
                              ListView.builder(
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  padding: EdgeInsets.only(left: 10, right: 20,top: 0,bottom: 30),
                                  itemCount: widget.messageReaction.length,
                                  itemBuilder: (context, index) {
                                    List<String> split = widget.messageReaction[index].toString().split("_____");
                                    print(widget.messageReaction.length);
                                    return int.parse(split[3])==2?
                                    FutureBuilder(
                                      future: DatabaseService().getUsersDetails(widget.messageReaction[index].toString().split("_____")[0]),
                                      builder: (context, snapshot1) {
                                        return Padding(
                                          padding: const EdgeInsets.only(top: 10),
                                          child: InkWell(
                                            onTap: (){
                                              if (snapshot1.data.data()['uuid'] != null) {
                                                if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == snapshot1.data.data()['uuid']) {
                                                  Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                                                } else {
                                                  Navigator.of(context).pushNamed(UserProfileScreen.routeName, arguments: {
                                                    "id": snapshot1.data.data()['uuid'],
                                                    "name": snapshot1.data.data()['displayName'],
                                                    "photoUrl": snapshot1.data.data()['photoURL'],
                                                    "firebaseUid": snapshot1.data.data()['uid']
                                                  });
                                                }
                                              }
                                            },
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 20,
                                                      backgroundColor: MateColors.activeIcons,
                                                      backgroundImage: NetworkImage(split[2]),
                                                    ),
                                                    SizedBox(width: 20,),
                                                    Text(split[1],
                                                      style: TextStyle(color: themeController.isDarkMode?Colors.white:Colors.black, fontSize: 12.5.sp, fontWeight: FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                                Image.asset(chatReactionImages[int.parse(split[3])],height: 20,width: 20,),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ):
                                    Offstage();
                                  }),
                              ListView.builder(
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  padding: EdgeInsets.only(left: 10, right: 20,top: 0,bottom: 30),
                                  itemCount: widget.messageReaction.length,
                                  itemBuilder: (context, index) {
                                    List<String> split = widget.messageReaction[index].toString().split("_____");
                                    print(widget.messageReaction.length);
                                    return int.parse(split[3])==3?
                                    FutureBuilder(
                                      future: DatabaseService().getUsersDetails(widget.messageReaction[index].toString().split("_____")[0]),
                                      builder: (context, snapshot1) {
                                        return Padding(
                                          padding: const EdgeInsets.only(top: 10),
                                          child: InkWell(
                                            onTap: (){
                                              if (snapshot1.data.data()['uuid'] != null) {
                                                if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == snapshot1.data.data()['uuid']) {
                                                  Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                                                } else {
                                                  Navigator.of(context).pushNamed(UserProfileScreen.routeName, arguments: {
                                                    "id": snapshot1.data.data()['uuid'],
                                                    "name": snapshot1.data.data()['displayName'],
                                                    "photoUrl": snapshot1.data.data()['photoURL'],
                                                    "firebaseUid": snapshot1.data.data()['uid']
                                                  });
                                                }
                                              }
                                            },
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 20,
                                                      backgroundColor: MateColors.activeIcons,
                                                      backgroundImage: NetworkImage(split[2]),
                                                    ),
                                                    SizedBox(width: 20,),
                                                    Text(split[1],
                                                      style: TextStyle(color: themeController.isDarkMode?Colors.white:Colors.black, fontSize: 12.5.sp, fontWeight: FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                                Image.asset(chatReactionImages[int.parse(split[3])],height: 20,width: 20,),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ):
                                    Offstage();
                                  }),
                              ListView.builder(
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  padding: EdgeInsets.only(left: 10, right: 20,top: 0,bottom: 30),
                                  itemCount: widget.messageReaction.length,
                                  itemBuilder: (context, index) {
                                    List<String> split = widget.messageReaction[index].toString().split("_____");
                                    print(widget.messageReaction.length);
                                    return int.parse(split[3])==4?
                                    FutureBuilder(
                                      future: DatabaseService().getUsersDetails(widget.messageReaction[index].toString().split("_____")[0]),
                                      builder: (context, snapshot1) {
                                        return Padding(
                                          padding: const EdgeInsets.only(top: 10),
                                          child: InkWell(
                                            onTap: (){
                                              if (snapshot1.data.data()['uuid'] != null) {
                                                if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == snapshot1.data.data()['uuid']) {
                                                  Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                                                } else {
                                                  Navigator.of(context).pushNamed(UserProfileScreen.routeName, arguments: {
                                                    "id": snapshot1.data.data()['uuid'],
                                                    "name": snapshot1.data.data()['displayName'],
                                                    "photoUrl": snapshot1.data.data()['photoURL'],
                                                    "firebaseUid": snapshot1.data.data()['uid']
                                                  });
                                                }
                                              }
                                            },
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 20,
                                                      backgroundColor: MateColors.activeIcons,
                                                      backgroundImage: NetworkImage(split[2]),
                                                    ),
                                                    SizedBox(width: 20,),
                                                    Text(split[1],
                                                      style: TextStyle(color: themeController.isDarkMode?Colors.white:Colors.black, fontSize: 12.5.sp, fontWeight: FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                                Image.asset(chatReactionImages[int.parse(split[3])],height: 20,width: 20,),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ):
                                    Offstage();
                                  }),
                              ListView.builder(
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  padding: EdgeInsets.only(left: 10, right: 20,top: 0,bottom: 30),
                                  itemCount: widget.messageReaction.length,
                                  itemBuilder: (context, index) {
                                    List<String> split = widget.messageReaction[index].toString().split("_____");
                                    print(widget.messageReaction.length);
                                    return int.parse(split[3])==5?
                                    FutureBuilder(
                                      future: DatabaseService().getUsersDetails(widget.messageReaction[index].toString().split("_____")[0]),
                                      builder: (context, snapshot1) {
                                        return Padding(
                                          padding: const EdgeInsets.only(top: 10),
                                          child: InkWell(
                                            onTap: (){
                                              if (snapshot1.data.data()['uuid'] != null) {
                                                if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == snapshot1.data.data()['uuid']) {
                                                  Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                                                } else {
                                                  Navigator.of(context).pushNamed(UserProfileScreen.routeName, arguments: {
                                                    "id": snapshot1.data.data()['uuid'],
                                                    "name": snapshot1.data.data()['displayName'],
                                                    "photoUrl": snapshot1.data.data()['photoURL'],
                                                    "firebaseUid": snapshot1.data.data()['uid']
                                                  });
                                                }
                                              }
                                            },
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 20,
                                                      backgroundColor: MateColors.activeIcons,
                                                      backgroundImage: NetworkImage(split[2]),
                                                    ),
                                                    SizedBox(width: 20,),
                                                    Text(split[1],
                                                      style: TextStyle(color: themeController.isDarkMode?Colors.white:Colors.black, fontSize: 12.5.sp, fontWeight: FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                                Image.asset(chatReactionImages[int.parse(split[3])],height: 20,width: 20,),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ):
                                    Offstage();
                                  }),
                              ListView.builder(
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  padding: EdgeInsets.only(left: 10, right: 20,top: 0,bottom: 30),
                                  itemCount: widget.messageReaction.length,
                                  itemBuilder: (context, index) {
                                    List<String> split = widget.messageReaction[index].toString().split("_____");
                                    print(widget.messageReaction.length);
                                    return int.parse(split[3])==6?
                                    FutureBuilder(
                                      future: DatabaseService().getUsersDetails(widget.messageReaction[index].toString().split("_____")[0]),
                                      builder: (context, snapshot1) {
                                        return Padding(
                                          padding: const EdgeInsets.only(top: 10),
                                          child: InkWell(
                                            onTap: (){
                                              if (snapshot1.data.data()['uuid'] != null) {
                                                if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == snapshot1.data.data()['uuid']) {
                                                  Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                                                } else {
                                                  Navigator.of(context).pushNamed(UserProfileScreen.routeName, arguments: {
                                                    "id": snapshot1.data.data()['uuid'],
                                                    "name": snapshot1.data.data()['displayName'],
                                                    "photoUrl": snapshot1.data.data()['photoURL'],
                                                    "firebaseUid": snapshot1.data.data()['uid']
                                                  });
                                                }
                                              }
                                            },
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 20,
                                                      backgroundColor: MateColors.activeIcons,
                                                      backgroundImage: NetworkImage(split[2]),
                                                    ),
                                                    SizedBox(width: 20,),
                                                    Text(split[1],
                                                      style: TextStyle(color: themeController.isDarkMode?Colors.white:Colors.black, fontSize: 12.5.sp, fontWeight: FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                                Image.asset(chatReactionImages[int.parse(split[3])],height: 20,width: 20,),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ):
                                    Offstage();
                                  }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                });
          },
          child: Container(
            //height: 38,
            alignment:  widget.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
            margin: EdgeInsets.only(left: widget.sentByMe ? 0 : 24, right: widget.sentByMe ? 24 : 0,top: 4),
            child: Wrap(
              runSpacing: 3,
              children: [
                Visibility(
                  visible: firstLength>0,
                  child: reactionContainer(firstLength.toString(), 0.toString()),
                ),
                Visibility(
                  visible: secondLength>0,
                  child: reactionContainer(secondLength.toString(), 1.toString()),
                ),
                Visibility(
                  visible: thirdLength>0,
                  child: reactionContainer(thirdLength.toString(), 2.toString()),
                ),
                Visibility(
                  visible: fourthLength>0,
                  child: reactionContainer(fourthLength.toString(), 3.toString()),
                ),
                Visibility(
                  visible: fifthLength>0,
                  child: reactionContainer(fifthLength.toString(), 4.toString()),
                ),
                Visibility(
                  visible: sixthLength>0,
                  child: reactionContainer(sixthLength.toString(), 5.toString()),
                ),
                Visibility(
                  visible: sevenLength>0,
                  child: reactionContainer(sevenLength.toString(), 6.toString()),
                ),
              ],
            ),
          ),
        ),

        widget.isFile ?
        Padding(
              //padding: EdgeInsets.only(right: sentByMe?24:0),
          padding: EdgeInsets.only(right: widget.sentByMe?24:0,left: widget.sentByMe?0:24,top: 5),
              child: Row(
                mainAxisAlignment: widget.sentByMe? MainAxisAlignment.end :MainAxisAlignment.start,
          children: [
              Text(widget.fileSize, textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: "Poppins",
                  color: widget.sentByMe?
                  themeController.isDarkMode? MateColors.subTitleTextDark: MateColors.subTitleTextDark:
                  themeController.isDarkMode? MateColors.subTitleTextDark: MateColors.subTitleTextDark,
                ),
              ),
              Text(" " + widget.fileSizeUnit, textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: "Poppins",
                  color: widget.sentByMe?
                  themeController.isDarkMode? MateColors.subTitleTextDark: MateColors.subTitleTextDark:
                  themeController.isDarkMode? MateColors.subTitleTextDark: MateColors.subTitleTextDark,
                ),
              ),
              Text("  •  " + widget.fileExtension.toUpperCase(),
                  textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: "Poppins",
                  color: widget.sentByMe?
                  themeController.isDarkMode? MateColors.subTitleTextDark: MateColors.subTitleTextDark:
                  themeController.isDarkMode? MateColors.subTitleTextDark: MateColors.subTitleTextDark,
                ),
              ),
              //Spacer(),
              SizedBox(width: 10,),
              Text(
                widget.date[widget.index] == "Today" || widget.date[widget.index] == "Yesterday"?
                widget.date[widget.index] + " at " + widget.time[widget.index]:
                widget.time[widget.index],
                //DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(int.parse(messageTime))),
                  textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: "Poppins",
                  color: widget.sentByMe?
                  themeController.isDarkMode? MateColors.subTitleTextDark: MateColors.subTitleTextDark:
                  themeController.isDarkMode? MateColors.subTitleTextDark: MateColors.subTitleTextDark,
                ),
              ),
          ],
        ),
            )
            : Padding(
              padding: EdgeInsets.only(right: widget.sentByMe?24:0,left: widget.sentByMe?0:24,top: 5),
              child: Align(
                alignment: widget.sentByMe? Alignment.centerRight :Alignment.centerLeft,
          child: Text(
            widget.date[widget.index] == "Today" || widget.date[widget.index] == "Yesterday"?
            widget.date[widget.index] + " at " + widget.time[widget.index]:
            widget.time[widget.index],
            //DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(int.parse(messageTime))),
                textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 12,
                fontFamily: "Poppins",
                color: widget.sentByMe?
                themeController.isDarkMode? MateColors.subTitleTextDark: MateColors.subTitleTextDark:
                themeController.isDarkMode? MateColors.subTitleTextDark: MateColors.subTitleTextDark,
              ),
          ),
        ),
            ),
      ],
    );
  }

  Widget _chatFile(String chatContent, BuildContext context) {
    return InkWell(
      onTap: () async {
        if (await canLaunch(chatContent)) {
          await launch(chatContent);
        } else {
          throw 'Could not launch $chatContent';
        }
        // OpenFile.open(chatContent);

      },
      child: Container(
        height: 50,
        // width: 200,
        clipBehavior: Clip.hardEdge,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.fromLTRB(9, 0, 9, 0),
        margin: EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          color: widget.sentByMe ? myHexColor.withOpacity(0.1) : myHexColor.withOpacity(0.3),
        ),
        child: Text(widget.fileName,
            maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.start, style: TextStyle(fontSize: 11.7.sp, color: widget.sentByMe ? Colors.black : Colors.white, fontWeight: FontWeight.w500)),
      ),
    );
  }

  Widget _chatAudio(String chatContent, BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: (){
            if(widget.isLoadingAudio==false){
              widget.isPlaying ? widget.pauseAudio(widget.index): widget.startAudio(chatContent,widget.index);
            }
          },
          child: widget.isLoadingAudio?
          Container(
            height: 30,
            width: 30,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: widget.sentByMe?
              themeController.isDarkMode? MateColors.blackTextColor: Colors.white:
              themeController.isDarkMode? Colors.white : MateColors.blackTextColor,
            ),
          ):
          Icon(
            widget.isPlaying ? Icons.pause: Icons.play_arrow,
            size: 30,
            color: widget.sentByMe?
            themeController.isDarkMode? MateColors.blackTextColor: Colors.white:
            themeController.isDarkMode? Colors.white : MateColors.blackTextColor,
          ),
        ),
        SizedBox(width: 10,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.multitrack_audio_sharp,color: widget.sentByMe?
                themeController.isDarkMode? MateColors.blackTextColor: Colors.white:
                themeController.isDarkMode? Colors.white : MateColors.blackTextColor,),
                Icon(Icons.multitrack_audio_sharp,color: widget.sentByMe?
                themeController.isDarkMode? MateColors.blackTextColor: Colors.white:
                themeController.isDarkMode? Colors.white : MateColors.blackTextColor,),
                Icon(Icons.multitrack_audio_sharp,color: widget.sentByMe?
                themeController.isDarkMode? MateColors.blackTextColor: Colors.white:
                themeController.isDarkMode? Colors.white : MateColors.blackTextColor,),
                Icon(Icons.multitrack_audio_sharp,color: widget.sentByMe?
                themeController.isDarkMode? MateColors.blackTextColor: Colors.white:
                themeController.isDarkMode? Colors.white : MateColors.blackTextColor,),
                Icon(Icons.multitrack_audio_sharp,color: widget.sentByMe?
                themeController.isDarkMode? MateColors.blackTextColor: Colors.white:
                themeController.isDarkMode? Colors.white : MateColors.blackTextColor,),
              ],
            ),
            if(widget.isPlaying)
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Row(
                  children: [
                    widget.currentDuration!=null?
                    Text(widget.currentDuration.inMinutes.toString().padLeft(2,'0') +":"+ widget.currentDuration.inSeconds.toString().padLeft(2,"0"),
                      style: TextStyle(
                        color: widget.sentByMe?
                        themeController.isDarkMode? MateColors.blackTextColor: Colors.white:
                        themeController.isDarkMode? Colors.white : MateColors.blackTextColor,
                      ),
                    ):Offstage(),
                    SizedBox(width: MediaQuery.of(context).size.width*0.13,),
                    widget.duration!=null?
                    Text(widget.duration.inMinutes.toString().padLeft(2,'0') +":"+ widget.duration.inSeconds.toString().padLeft(2,"0"),
                      style: TextStyle(
                        color: widget.sentByMe?
                        themeController.isDarkMode? MateColors.blackTextColor: Colors.white:
                        themeController.isDarkMode? Colors.white : MateColors.blackTextColor,
                      ),
                    ):Offstage(),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _chatImage(String chatContent, BuildContext context) {
    return InkWell(
      onTap: () => showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => CustomDialog(
          backgroundColor: Colors.transparent,
          clipBehavior: Clip.hardEdge,
          insetPadding: EdgeInsets.all(0),
          child: Padding(
            padding: const EdgeInsets.all(00.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.8,
              child: InteractiveViewer(
                panEnabled: true,
                // Set it to false to prevent panning.
                boundaryMargin: EdgeInsets.all(50),
                minScale: 0.5,
                maxScale: 4,
                child: CachedNetworkImage(
                    imageUrl: chatContent,
                    height: 150,
                    width: 200,
                    placeholder: (context, url) => Center(child: SizedBox(width: 30, height: 30, child: CircularProgressIndicator())),
                    errorWidget: (context, url, error) => Icon(Icons.error)),
              ),
            ),
          ),
        ),
      ),
      child: Container(
        height: 150,
        width: 200,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12.0)), color: myHexColor),
        child: _widgetShowImages(chatContent),
      ),
    );
  }

  Widget reactionContainer(String length,String indexValue){
    return Container(
      height: 28,
      width: 47,
      margin: EdgeInsets.only(left: 6),
      padding: EdgeInsets.only(top: 4,bottom: 4,left: 6,right: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: themeController.isDarkMode?MateColors.darkDivider:MateColors.lightDivider,),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(1.0),
            child: Image.asset(chatReactionImages[int.parse(indexValue)],height: 20,width: 20,),
          ),
          Text(length,
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.1,
              color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
            ),
          ),
        ],
      ),
    );
  }

  // Show Images from network
  Widget _widgetShowImages(
    String imageUrl,
  ) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      height: 150,
      width: 200,
      placeholder: (context, url) => Center(child: SizedBox(width: 30, height: 30, child: CircularProgressIndicator())),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
