import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mate_app/Screen/chatDashboard/forwardMessagePage.dart';
import 'package:mate_app/Services/community_tab_services.dart';
import 'package:mate_app/Utility/Utility.dart';
import 'package:mate_app/groupChat/pages/customAlertDialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mate_app/groupChat/services/database_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibration/vibration.dart';

import '../../Providers/AuthUserProvider.dart';
import '../../Screen/Profile/ProfileScreen.dart';
import '../../Screen/Profile/UserProfileScreen.dart';
import '../../Widget/Loaders/Shimmer.dart';
import '../../Widget/custom_swipe_to.dart';
import '../../asset/Colors/MateColors.dart';
import '../../asset/Reactions/reactionsContants.dart';

class MessageTile extends StatefulWidget {
  final String messageId;
  final String groupId;
  final String message;
  final String sender;
  final bool sentByMe;
  final String messageTime;
  final bool isImage;
  final bool isFile;
  final bool isGif;
  final String fileExtension;
  final String fileName;
  final String fileSize;
  final String fileSizeUnit;
  final String userId;
  List<dynamic> messageReaction;
  final String displayName;
  final String photo;
  final String senderImage;
  final int index;
  final List<String> date;
  final List<String> time;
  final int fileSizeFull;
  final bool isForwarded;
  final String senderId;
  Function(String message,String name,bool selected) selectMessage;
  final String previousMessage;
  final String previousSender;
  final bool isAudio;
  final bool isPlaying;
  final bool isPaused;
  final bool isLoadingAudio;
  Function(String url,int index) startAudio;
  Function(int index) pauseAudio;
  Duration duration;
  Duration currentDuration;
  Function(String groupId,String messageId,String previousMessage) editMessage;
  final bool showDate;
  Function() showDateToggle;
  MessageTile({this.showDateToggle,this.editMessage,this.currentDuration,this.duration,this.startAudio,this.pauseAudio,this.senderId,this.isForwarded=false,this.fileSizeFull,this.time,this.date,this.index,this.senderImage,this.displayName,this.photo,this.messageReaction,this.groupId,this.userId,this.messageId,this.message, this.sender, this.sentByMe, this.messageTime,
    this.isImage = false, this.isFile = false, this.isGif = false, this.fileExtension, this.fileName, this.fileSize, this.fileSizeUnit ,this.selectMessage, this.previousMessage, this.previousSender, this.isAudio, this.isPlaying, this.isPaused, this.isLoadingAudio, this.showDate});

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  //bool show = false;
  //bool showDate = false;
  @override
  Widget build(BuildContext context) {

    int firstLength = 0;
    int secondLength = 0;
    int thirdLength = 0;
    int fourthLength = 0;
    int fifthLength = 0;
    int sixthLength = 0;
    int sevenLength = 0;
    int eightLength = 0;
    int nineLength = 0;
    int tenLength = 0;
    int elevenLength = 0;
    int twelveLength = 0;
    int thirteenLength = 0;
    int fourteenLength = 0;
    int fifteenLength = 0;
    int sixteenLength = 0;
    int seventeenLength = 0;
    int eighteenLength = 0;
    int nineteenLength = 0;
    int twentyLength = 0;
    int twentyOneLength = 0;
    int twentyTwoLength = 0;
    int twentyThreeLength = 0;
    int twentyFourLength = 0;
    int twentyFiveLength = 0;
    int twentySixLength = 0;
    int twentySevenLength = 0;
    int twentyEightLength = 0;
    int twentyNineLength = 0;
    int thirtyLength = 0;
    int thirtyOneLength = 0;
    int thirtyTwoLength = 0;
    int thirtyThreeLength = 0;
    int thirtyFourLength = 0;
    int thirtyFiveLength = 0;

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
      }else if(int.parse(split[3]) == 7){
        eightLength = eightLength +1;
      }else if(int.parse(split[3]) == 8){
        nineLength = nineLength +1;
      }else if(int.parse(split[3]) == 9){
        tenLength = tenLength +1;
      }else if(int.parse(split[3]) == 10){
        elevenLength = elevenLength +1;
      }else if(int.parse(split[3]) == 11){
        twelveLength = twelveLength +1;
      }else if(int.parse(split[3]) == 12){
        thirteenLength = thirteenLength +1;
      }else if(int.parse(split[3]) == 13){
        fourteenLength = fourteenLength +1;
      }else if(int.parse(split[3]) == 14){
        fifteenLength = fifteenLength +1;
      }else if(int.parse(split[3]) == 15){
        sixteenLength = sixteenLength +1;
      }else if(int.parse(split[3]) == 16){
        seventeenLength = seventeenLength +1;
      }else if(int.parse(split[3]) == 17){
        eighteenLength = eighteenLength +1;
      }else if(int.parse(split[3]) == 18){
        nineteenLength = nineteenLength +1;
      }else if(int.parse(split[3]) == 19){
        twentyLength = twentyLength +1;
      }else if(int.parse(split[3]) == 20){
        twentyOneLength = twentyOneLength +1;
      }else if(int.parse(split[3]) == 21){
        twentyTwoLength = twentyTwoLength +1;
      }else if(int.parse(split[3]) == 22){
        twentyThreeLength = twentyThreeLength +1;
      }else if(int.parse(split[3]) == 23){
        twentyFourLength = twentyFourLength +1;
      }else if(int.parse(split[3]) == 24){
        twentyFiveLength = twentyFiveLength +1;
      }else if(int.parse(split[3]) == 25){
        twentySixLength = twentySixLength +1;
      }else if(int.parse(split[3]) == 26){
        twentySevenLength = twentySevenLength +1;
      }else if(int.parse(split[3]) == 27){
        twentyEightLength = twentyEightLength +1;
      }else if(int.parse(split[3]) == 28){
        twentyNineLength = twentyNineLength +1;
      }else if(int.parse(split[3]) == 29){
        thirtyLength = thirtyLength +1;
      }else if(int.parse(split[3]) == 30){
        thirtyOneLength = thirtyOneLength +1;
      }else if(int.parse(split[3]) == 31){
        thirtyTwoLength = thirtyTwoLength +1;
      }else if(int.parse(split[3]) == 32){
        thirtyThreeLength = thirtyThreeLength +1;
      }else if(int.parse(split[3]) == 33){
        thirtyFourLength = thirtyFourLength +1;
      }else if(int.parse(split[3]) == 34){
        thirtyFiveLength = thirtyFiveLength +1;
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
        CustomSwipeTo(
          onRightSwipe: (){
            if(widget.showDate){
              widget.showDateToggle();
            }else{
              // HapticFeedback.heavyImpact();
              Vibration.vibrate(
                  pattern: [1, 150, 1, 150], intensities: [100, 100]
              );
              widget.selectMessage(widget.message.trim(),widget.sender,true);
            }
          },
          showDateToggle: widget.showDateToggle,
          showDate: widget.showDate,

          // onLeftSwipe: (){
          //   print("------");
          //   widget.showDateToggle();
          // },
          child: Padding(
            padding: EdgeInsets.only(top: 4, bottom: 4, left: widget.sentByMe ? 0 : 14, right: widget.sentByMe ? 14 : 0),
            child: FocusedMenuHolder(
              menuWidth: MediaQuery.of(context).size.width*0.83,
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
                                await DatabaseService(uid: widget.userId).updateMessageReaction(widget.groupId, widget.messageId,previousValue);
                                await DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 0.toString(),widget.displayName,widget.photo);
                                break;
                              }
                            }
                            if(add){
                              DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 0.toString(),widget.displayName,widget.photo);
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
                                  await DatabaseService(uid: widget.userId).updateMessageReaction(widget.groupId, widget.messageId,previousValue);
                                  await DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 1.toString(),widget.displayName,widget.photo);
                                  break;
                                }
                              }
                              if(add){
                                DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 1.toString(),widget.displayName,widget.photo);
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
                                    await DatabaseService(uid: widget.userId).updateMessageReaction(widget.groupId, widget.messageId,previousValue);
                                    await DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 2.toString(),widget.displayName,widget.photo);
                                    break;
                                  }
                                }
                                if(add){
                                  DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 2.toString(),widget.displayName,widget.photo);
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
                                  await DatabaseService(uid: widget.userId).updateMessageReaction(widget.groupId, widget.messageId,previousValue);
                                  await DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 3.toString(),widget.displayName,widget.photo);
                                  break;
                                }
                              }
                              if(add){
                                DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 3.toString(),widget.displayName,widget.photo);
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
                                  await DatabaseService(uid: widget.userId).updateMessageReaction(widget.groupId, widget.messageId,previousValue);
                                  await DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 4.toString(),widget.displayName,widget.photo);
                                  break;
                                }
                              }
                              if(add){
                                DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 4.toString(),widget.displayName,widget.photo);
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
                                  await DatabaseService(uid: widget.userId).updateMessageReaction(widget.groupId, widget.messageId,previousValue);
                                  await DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 5.toString(),widget.displayName,widget.photo);
                                  break;
                                }
                              }
                              if(add){
                                DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 5.toString(),widget.displayName,widget.photo);
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
                                  await DatabaseService(uid: widget.userId).updateMessageReaction(widget.groupId, widget.messageId,previousValue);
                                  await DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 6.toString(),widget.displayName,widget.photo);
                                  break;
                                }
                              }
                              if(add){
                                DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 6.toString(),widget.displayName,widget.photo);
                              }
                            }
                          },
                          child: Image.asset(chatReactionImages[6],
                            height: 30,
                            width: 30,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          Get.back();
                          modalSheetGroupIconChange();
                        },
                        child: Container(
                          height: 30,
                          width: 30,
                          margin: EdgeInsets.only(left: 8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: themeController.isDarkMode?MateColors.subTitleTextLight:MateColors.subTitleTextDark,
                          ),
                          child: Center(child: Icon(Icons.add,color: themeController.isDarkMode?Colors.black:Colors.white,)),
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
                    await DatabaseService().deleteMessage(widget.groupId,widget.messageId);
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
                      'isGif' : widget.isGif,
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
                    // DatabaseService().sendMessage(widget.groupId, chatMessageMap,widget.photo);


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
                    bool response = await CommunityTabService().reportGroupMessage(groupId: widget.groupId, messageId: widget.messageId, uid: widget.userId, token: token,);
                    if(response){
                      Fluttertoast.showToast(msg: "Your feedback added successfully", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
                    }else{
                      Fluttertoast.showToast(msg: "Something went wrong", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
                    }
                  },
                ),
                if(widget.sentByMe && !widget.isImage && !widget.isGif && !widget.isFile && !widget.isAudio && widget.messageId !="")
                FocusedMenuItem(
                  title: Row(
                    children: [
                      Icon(Icons.mode_edit_outlined,
                        size: 20,
                        color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Text(
                          "Edit",
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
                    widget.editMessage(widget.groupId,widget.messageId,widget.message);
                  },
                ),
              ],
              onPressed: (){},
              child: Row(
                mainAxisAlignment: widget.sentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  !widget.sentByMe?
                  widget.senderImage!=""?
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: MateColors.activeIcons,
                    backgroundImage: NetworkImage(widget.senderImage),
                  ):CircleAvatar(
                    radius: 16,
                    backgroundColor: MateColors.activeIcons,
                    child: Text(widget.sender.substring(0, 1).toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: themeController.isDarkMode?Colors.black:Colors.white, fontSize: 13.0.sp, fontWeight: FontWeight.w400),
                    ),
                  ):SizedBox(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10,right: 10),
                      child: Row(
                        mainAxisAlignment: widget.sentByMe?MainAxisAlignment.end:MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Container(
                              /*constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width*0.7,
                                minWidth: 100
                              ),*/
                              //padding: EdgeInsets.only(right: widget.sentByMe ? 0 : 124),
                              alignment: widget.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
                              child: Container(
                                margin: widget.sentByMe ? EdgeInsets.only(left: MediaQuery.of(context).size.width*0.2,top: 10) : EdgeInsets.only(right: !widget.sentByMe && (widget.isImage || widget.isGif)?0:MediaQuery.of(context).size.width*0.2,top: 10),
                                // padding: EdgeInsets.only(top: widget.isImage ? 15 : 15, bottom: 15, left: 20, right:20),
                                decoration: BoxDecoration(
                                  borderRadius: widget.sentByMe
                                      ? BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20), bottomLeft: Radius.circular(20))
                                      : BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
                                  color: widget.sentByMe ? chatTealColor : themeController.isDarkMode? chatGreyColor: MateColors.lightDivider,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(top: widget.isImage ? 15 : 15, bottom: 15, left: 20, right:20),
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

                                      widget.sentByMe ?
                                      SizedBox() : SizedBox(),
                                      // Padding(
                                      //   padding: const EdgeInsets.only(bottom: 6),
                                      //   child: Text(
                                      //     widget.sender.toUpperCase(),
                                      //     textAlign: TextAlign.start,
                                      //     style: TextStyle(
                                      //       fontFamily: "Poppins",
                                      //       fontSize: 14.0,
                                      //       fontWeight: FontWeight.w500,
                                      //       letterSpacing: 0.1,
                                      //       color: MateColors.activeIcons,
                                      //       // sentByMe?
                                      //       // themeController.isDarkMode? MateColors.blackTextColor: Colors.white:
                                      //       // themeController.isDarkMode? Colors.white : MateColors.blackTextColor,
                                      //     ),
                                      //   ),
                                      // ),
                                      widget.isImage ? _chatImage(widget.message, context) :
                                      widget.isGif? _chatGif(widget.message, context) :
                                      widget.isFile? _chatFile(widget.message, context) :
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

                                      // Text(
                                      //   widget.message.trim(),
                                      //   textAlign: TextAlign.start,
                                      //   style: TextStyle(
                                      //     fontFamily: "Poppins",
                                      //     fontSize: 14.0,
                                      //     fontWeight: FontWeight.w400,
                                      //     letterSpacing: 0.1,
                                      //     color: widget.sentByMe?
                                      //     themeController.isDarkMode? MateColors.blackTextColor: Colors.white:
                                      //     themeController.isDarkMode? Colors.white : MateColors.blackTextColor,
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                                // ReactionButton<String>(
                                //   onReactionChanged: (value) async {
                                //     String previousValue = "";
                                //     bool add = true;
                                //     print(value);
                                //     print(widget.messageId);
                                //     if(widget.messageId!=""){
                                //       for(int i=0; i< widget.messageReaction.length ;i++){
                                //         if(widget.messageReaction[i].contains(widget.userId)){
                                //           add = false;
                                //           previousValue = widget.messageReaction[i];
                                //           await DatabaseService(uid: widget.userId).updateMessageReaction(widget.groupId, widget.messageId,previousValue);
                                //           await DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, value.toString(),widget.displayName,widget.photo);
                                //           break;
                                //         }
                                //       }
                                //       if(add){
                                //         DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, value.toString(),widget.displayName,widget.photo);
                                //       }
                                //     }
                                //   },
                                //   reactions: reactionClassList,
                                //   shouldChangeReaction: false,
                                //   //boxOffset: Offset(20,0),
                                //   boxHorizontalPosition: HorizontalPosition.CENTER,
                                //   boxPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                //   //isChecked: false,
                                //   initialReaction: Reaction<String>(
                                //       value: null,
                                //       icon:  Padding(
                                //         padding: EdgeInsets.only(top: widget.isImage ? 15 : 15, bottom: 15, left: 20, right:20),
                                //         child: Column(
                                //           crossAxisAlignment: CrossAxisAlignment.start,
                                //           children: <Widget>[
                                //             widget.sentByMe ?
                                //             SizedBox() : SizedBox(),
                                //             // Padding(
                                //             //   padding: const EdgeInsets.only(bottom: 6),
                                //             //   child: Text(
                                //             //     widget.sender.toUpperCase(),
                                //             //     textAlign: TextAlign.start,
                                //             //     style: TextStyle(
                                //             //       fontFamily: "Poppins",
                                //             //       fontSize: 14.0,
                                //             //       fontWeight: FontWeight.w500,
                                //             //       letterSpacing: 0.1,
                                //             //       color: MateColors.activeIcons,
                                //             //       // sentByMe?
                                //             //       // themeController.isDarkMode? MateColors.blackTextColor: Colors.white:
                                //             //       // themeController.isDarkMode? Colors.white : MateColors.blackTextColor,
                                //             //     ),
                                //             //   ),
                                //             // ),
                                //             widget.isImage ? _chatImage(widget.message, context) :
                                //             widget.isGif? _chatGif(widget.message, context) :
                                //             widget.isFile? _chatFile(widget.message, context) :
                                //             Text(widget.message.trim(), textAlign: TextAlign.start,
                                //               style: TextStyle(
                                //                 fontFamily: "Poppins",
                                //                 fontSize: 14.0,
                                //                 fontWeight: FontWeight.w400,
                                //                 letterSpacing: 0.1,
                                //                 color: widget.sentByMe?
                                //                 themeController.isDarkMode? MateColors.blackTextColor: Colors.white:
                                //                 themeController.isDarkMode? Colors.white : MateColors.blackTextColor,
                                //               ),
                                //             ),
                                //           ],
                                //         ),
                                //       ),
                                //   ),
                                //   boxElevation: 20,
                                //   boxColor: myHexColor,
                                //   // boxColor: MateColors.activeIcons.withOpacity(0.2),
                                //   //boxRadius: 500,
                                //   boxPosition: VerticalPosition.TOP,
                                //   boxDuration: Duration(milliseconds: 400),
                                //   itemScaleDuration: const Duration(milliseconds: 200),
                                // ),
                              ),
                            ),
                          ),
                          !widget.sentByMe && (widget.isImage || widget.isGif)?
                          InkWell(
                            onTap: (){
                              Map<String, dynamic> chatMessageMap = {
                                "message": widget.message,
                                "sender": widget.displayName,
                                'senderId': widget.userId,
                                'time': DateTime.now().millisecondsSinceEpoch,
                                'isImage': widget.isImage,
                                'isFile': widget.isFile,
                                'isGif' : widget.isGif,
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
                            },
                            child: Container(
                              margin: EdgeInsets.only(left: 10,right: MediaQuery.of(context).size.width*0.08),
                              height: 45,
                              width: 45,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
                              ),
                              child: Image.asset(
                                "lib/asset/icons/forward.png",
                                color: themeController.isDarkMode?MateColors.iconDark:MateColors.iconLight,
                                height: 20,
                                width: 20,
                              ),
                            ),
                          ):SizedBox(),
                        ],
                      ),
                    ),
                  ),
                  widget.sentByMe?
                  widget.senderImage!=""?
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: MateColors.activeIcons,
                    backgroundImage: NetworkImage(widget.senderImage),
                  ):CircleAvatar(
                    radius: 16,
                    backgroundColor: MateColors.activeIcons,
                    child: Text(widget.sender.substring(0, 1).toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: themeController.isDarkMode?Colors.black:Colors.white, fontSize: 13.0.sp, fontWeight: FontWeight.w400),
                    ),
                  ):SizedBox(),
                  //if(widget.showDate)
                  Padding(
                    padding: EdgeInsets.only(left: 0,right: !widget.sentByMe?10:0),
                    child: AnimatedContainer(
                      curve: Curves.easeInOut,
                      width: widget.showDate?60:0,
                      height: 15,
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        //DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(int.parse(widget.messageTime))),
                        // widget.date[widget.index] == "Today" || widget.date[widget.index] == "Yesterday"?
                        // widget.date[widget.index] + " at " + widget.time[widget.index]:
                        widget.time[widget.index],
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
                  ),
                ],
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
                    length: 36,
                    child: Column(
                      children: [
                        TabBar(
                          unselectedLabelColor: Color(0xFF656568),
                          indicatorColor: MateColors.activeIcons,
                          labelColor: themeController.isDarkMode ? Colors.white : MateColors.blackTextColor,
                          labelPadding: EdgeInsets.only(left: 10,right: 10),
                          isScrollable: true,
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
                            Tab(
                              icon: Image.asset(chatReactionImages[7]),
                              height: 20,
                            ),
                            Tab(
                              icon: Image.asset(chatReactionImages[8]),
                              height: 20,
                            ),
                            Tab(
                              icon: Image.asset(chatReactionImages[9]),
                              height: 20,
                            ),
                            Tab(
                              icon: Image.asset(chatReactionImages[10]),
                              height: 20,
                            ),
                            Tab(
                              icon: Image.asset(chatReactionImages[11]),
                              height: 20,
                            ),
                            Tab(
                              icon: Image.asset(chatReactionImages[12]),
                              height: 20,
                            ),
                            Tab(
                              icon: Image.asset(chatReactionImages[13]),
                              height: 20,
                            ),
                            Tab(
                              icon: Image.asset(chatReactionImages[14]),
                              height: 20,
                            ),
                            Tab(
                              icon: Image.asset(chatReactionImages[15]),
                              height: 20,
                            ),
                            Tab(
                              icon: Image.asset(chatReactionImages[16]),
                              height: 20,
                            ),
                            Tab(
                              icon: Image.asset(chatReactionImages[17]),
                              height: 20,
                            ),
                            Tab(
                              icon: Image.asset(chatReactionImages[18]),
                              height: 20,
                            ),
                            Tab(
                              icon: Image.asset(chatReactionImages[19]),
                              height: 20,
                            ),
                            Tab(
                              icon: Image.asset(chatReactionImages[20]),
                              height: 20,
                            ),
                            Tab(
                              icon: Image.asset(chatReactionImages[21]),
                              height: 20,
                            ),
                            Tab(
                              icon: Image.asset(chatReactionImages[22]),
                              height: 20,
                            ),
                            Tab(
                              icon: Image.asset(chatReactionImages[23]),
                              height: 20,
                            ),
                            Tab(
                              icon: Image.asset(chatReactionImages[24]),
                              height: 20,
                            ),
                            Tab(
                              icon: Image.asset(chatReactionImages[25]),
                              height: 20,
                            ),
                            Tab(
                              icon: Image.asset(chatReactionImages[26]),
                              height: 20,
                            ),
                            Tab(
                              icon: Image.asset(chatReactionImages[27]),
                              height: 20,
                            ),
                            Tab(
                              icon: Image.asset(chatReactionImages[28]),
                              height: 20,
                            ),
                            Tab(
                              icon: Image.asset(chatReactionImages[29]),
                              height: 20,
                            ),
                            Tab(
                              icon: Image.asset(chatReactionImages[30]),
                              height: 20,
                            ),
                            Tab(
                              icon: Image.asset(chatReactionImages[31]),
                              height: 20,
                            ),
                            Tab(
                              icon: Image.asset(chatReactionImages[32]),
                              height: 20,
                            ),
                            Tab(
                              icon: Image.asset(chatReactionImages[33]),
                              height: 20,
                            ),
                            Tab(
                              icon: Image.asset(chatReactionImages[34]),
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
                              ListView.builder(
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  padding: EdgeInsets.only(left: 10, right: 20,top: 0,bottom: 30),
                                  itemCount: widget.messageReaction.length,
                                  itemBuilder: (context, index) {
                                    List<String> split = widget.messageReaction[index].toString().split("_____");
                                    print(widget.messageReaction.length);
                                    return int.parse(split[3])==7?
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
                                    return int.parse(split[3])==8?
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
                                    return int.parse(split[3])==9?
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
                                    return int.parse(split[3])==10?
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
                                    return int.parse(split[3])==11?
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
                                    return int.parse(split[3])==12?
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
                                    return int.parse(split[3])==13?
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
                                    return int.parse(split[3])==14?
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
                                    return int.parse(split[3])==15?
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
                                    return int.parse(split[3])==16?
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
                                    return int.parse(split[3])==17?
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
                                    return int.parse(split[3])==18?
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
                                    return int.parse(split[3])==19?
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
                                    return int.parse(split[3])==20?
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
                                    return int.parse(split[3])==21?
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
                                    return int.parse(split[3])==22?
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
                                    return int.parse(split[3])==23?
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
                                    return int.parse(split[3])==24?
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
                                    return int.parse(split[3])==25?
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
                                    return int.parse(split[3])==26?
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
                                    return int.parse(split[3])==27?
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
                                    return int.parse(split[3])==28?
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
                                    return int.parse(split[3])==29?
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
                                    return int.parse(split[3])==30?
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
                                    return int.parse(split[3])==31?
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
                                    return int.parse(split[3])==32?
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
                                    return int.parse(split[3])==33?
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
                                    return int.parse(split[3])==34?
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
            margin: EdgeInsets.only(left: widget.sentByMe ? 0 : 54, right: widget.sentByMe ? widget.showDate?114:54 : 0,top: 4),
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
                Visibility(
                  visible: eightLength>0,
                  child: reactionContainer(eightLength.toString(), 7.toString()),
                ),
                Visibility(
                  visible: nineLength>0,
                  child: reactionContainer(nineLength.toString(), 8.toString()),
                ),
                Visibility(
                  visible: tenLength>0,
                  child: reactionContainer(tenLength.toString(), 9.toString()),
                ),
                Visibility(
                  visible: elevenLength>0,
                  child: reactionContainer(elevenLength.toString(), 10.toString()),
                ),
                Visibility(
                  visible: twelveLength>0,
                  child: reactionContainer(twelveLength.toString(), 11.toString()),
                ),
                Visibility(
                  visible: thirteenLength>0,
                  child: reactionContainer(thirteenLength.toString(), 12.toString()),
                ),
                Visibility(
                  visible: fourteenLength>0,
                  child: reactionContainer(fourteenLength.toString(), 13.toString()),
                ),
                Visibility(
                  visible: fifteenLength>0,
                  child: reactionContainer(fifteenLength.toString(), 14.toString()),
                ),
                Visibility(
                  visible: sixteenLength>0,
                  child: reactionContainer(sixteenLength.toString(), 15.toString()),
                ),
                Visibility(
                  visible: seventeenLength>0,
                  child: reactionContainer(seventeenLength.toString(), 16.toString()),
                ),
                Visibility(
                  visible: eighteenLength>0,
                  child: reactionContainer(eighteenLength.toString(), 17.toString()),
                ),
                Visibility(
                  visible: nineteenLength>0,
                  child: reactionContainer(nineteenLength.toString(), 18.toString()),
                ),
                Visibility(
                  visible: twentyLength>0,
                  child: reactionContainer(twentyLength.toString(), 19.toString()),
                ),
                Visibility(
                  visible: twentyOneLength>0,
                  child: reactionContainer(twentyOneLength.toString(), 20.toString()),
                ),
                Visibility(
                  visible: twentyTwoLength>0,
                  child: reactionContainer(twentyTwoLength.toString(), 21.toString()),
                ),
                Visibility(
                  visible: twentyThreeLength>0,
                  child: reactionContainer(twentyThreeLength.toString(), 22.toString()),
                ),
                Visibility(
                  visible: twentyFourLength>0,
                  child: reactionContainer(twentyFourLength.toString(), 23.toString()),
                ),
                Visibility(
                  visible: twentyFiveLength>0,
                  child: reactionContainer(twentyFiveLength.toString(), 24.toString()),
                ),
                Visibility(
                  visible: twentySixLength>0,
                  child: reactionContainer(twentySixLength.toString(), 25.toString()),
                ),
                Visibility(
                  visible: twentySevenLength>0,
                  child: reactionContainer(twentySevenLength.toString(), 26.toString()),
                ),
                Visibility(
                  visible: twentyEightLength>0,
                  child: reactionContainer(twentyEightLength.toString(), 27.toString()),
                ),
                Visibility(
                  visible: twentyNineLength>0,
                  child: reactionContainer(twentyNineLength.toString(), 28.toString()),
                ),
                Visibility(
                  visible: thirtyLength>0,
                  child: reactionContainer(thirtyLength.toString(), 29.toString()),
                ),
                Visibility(
                  visible: thirtyOneLength>0,
                  child: reactionContainer(thirtyOneLength.toString(), 30.toString()),
                ),
                Visibility(
                  visible: thirtyTwoLength>0,
                  child: reactionContainer(thirtyTwoLength.toString(), 31.toString()),
                ),
                Visibility(
                  visible: thirtyThreeLength>0,
                  child: reactionContainer(thirtyThreeLength.toString(), 32.toString()),
                ),
                Visibility(
                  visible: thirtyFourLength>0,
                  child: reactionContainer(thirtyFourLength.toString(), 33.toString()),
                ),
                Visibility(
                  visible: thirtyFiveLength>0,
                  child: reactionContainer(thirtyFiveLength.toString(), 34.toString()),
                ),
              ],
            ),
          ),
        ),
        widget.isFile?
        Padding(
          //padding: EdgeInsets.only(right: widget.sentByMe?24:24,left: 24),
          padding: EdgeInsets.only(right: widget.sentByMe?58:0,left: widget.sentByMe?0:58,top: 5),
          child: Row(
            mainAxisAlignment: widget.sentByMe? MainAxisAlignment.end :MainAxisAlignment.start,
            children: [
              Text(widget.fileSize,
                  textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: "Poppins",
                  color: widget.sentByMe?
                  themeController.isDarkMode? MateColors.subTitleTextDark: MateColors.subTitleTextLight:
                  themeController.isDarkMode? MateColors.subTitleTextDark: MateColors.subTitleTextLight,
                ),
              ),
              Text(" "+widget.fileSizeUnit,
                  textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: "Poppins",
                  color: widget.sentByMe?
                  themeController.isDarkMode? MateColors.subTitleTextDark: MateColors.subTitleTextLight:
                  themeController.isDarkMode? MateColors.subTitleTextDark: MateColors.subTitleTextLight,
                ),
              ),
              Text("  •  "+widget.fileExtension.toUpperCase(),
                  textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: "Poppins",
                  color: widget.sentByMe?
                  themeController.isDarkMode? MateColors.subTitleTextDark: MateColors.subTitleTextLight:
                  themeController.isDarkMode? MateColors.subTitleTextDark: MateColors.subTitleTextLight,
                ),
              ),

              //Spacer(),
              SizedBox(width: 10,),
              Text(
                widget.date[widget.index] == "Today" || widget.date[widget.index] == "Yesterday"?
                widget.date[widget.index] + " at " + widget.time[widget.index]:
                widget.time[widget.index],
                //DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(int.parse(widget.messageTime))),
                  textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: "Poppins",
                  color: widget.sentByMe?
                  themeController.isDarkMode? MateColors.subTitleTextDark: MateColors.subTitleTextLight:
                  themeController.isDarkMode? MateColors.subTitleTextDark: MateColors.subTitleTextLight,
                ),
              ),

            ],
          ),
        ) :SizedBox(),
        // Padding(
        //   padding: EdgeInsets.only(right: widget.sentByMe?58:0,left: widget.sentByMe?0:58,top: 5),
        //       child: Align(
        //   alignment: widget.sentByMe? Alignment.centerRight :Alignment.centerLeft,
        //   child: Text(
        //     //DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(int.parse(widget.messageTime))),
        //     widget.date[widget.index] == "Today" || widget.date[widget.index] == "Yesterday"?
        //     widget.date[widget.index] + " at " + widget.time[widget.index]:
        //     widget.time[widget.index],
        //     textAlign: TextAlign.end,
        //       style: TextStyle(
        //         fontSize: 12,
        //         fontFamily: "Poppins",
        //         color: widget.sentByMe?
        //         themeController.isDarkMode? MateColors.subTitleTextDark: MateColors.subTitleTextLight:
        //         themeController.isDarkMode? MateColors.subTitleTextDark: MateColors.subTitleTextLight,
        //       ),
        //   ),
        // ),
        //     ),
      ],
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
                widget.showDate?SizedBox():
                Icon(Icons.multitrack_audio_sharp,color: widget.sentByMe?
                themeController.isDarkMode? MateColors.blackTextColor: Colors.white:
                themeController.isDarkMode? Colors.white : MateColors.blackTextColor,),
                widget.showDate?SizedBox():
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


  Widget _chatFile(String chatContent, BuildContext context) {
    return InkWell(
      onTap: () async{
        if (await canLaunch(chatContent)) {
        await launch(chatContent);
        } else {
        throw 'Could not launch $chatContent';
        }
        // OpenFile.open(chatContent);
        // Navigator.push(context, MaterialPageRoute(builder: (context) => ChatWebViewPage(pageUrl: chatContent,),));
      },
      child: Container(
        height: 50,
        // width: 200,
        clipBehavior: Clip.hardEdge,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.fromLTRB(9,0,9,0),
        margin: EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          color: widget.sentByMe? myHexColor.withOpacity(0.1):myHexColor.withOpacity(0.3),
        ),
        child: Text(widget.fileName, maxLines: 2,overflow: TextOverflow.ellipsis,textAlign: TextAlign.start, style: TextStyle(fontSize: 11.7.sp, color: widget.sentByMe ? Colors.black : Colors.white, fontWeight: FontWeight.w500)),
      ),
    );
  }

  Widget _chatGif(String chatContent, BuildContext context) {
    return InkWell(
      onTap: ()=>
          showDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) =>
                 CustomDialog(
                  backgroundColor: Colors.transparent,
                  clipBehavior: Clip.hardEdge,
                  insetPadding: EdgeInsets.all(0),
                  child: Padding(
                    padding: const EdgeInsets.all(00.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width*0.9,
                      height: MediaQuery.of(context).size.height*0.8,
                      child: InteractiveViewer(
                        panEnabled: true, // Set it to false to prevent panning.
                        boundaryMargin: EdgeInsets.all(50),
                        minScale: 0.5,
                        maxScale: 4,
                        child: CachedNetworkImage(
                            imageUrl: chatContent,
                            height: 150,
                            width: 200,
                            placeholder: (context, url) => Center(child: SizedBox(width: 30,height: 30,child: CircularProgressIndicator())),
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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          color: myHexColor
        ),
        child: _widgetShowImages(chatContent),
      ),
    );
  }

  Widget _chatImage(String chatContent, BuildContext context) {
    return InkWell(
      onTap: ()=>
          showDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) =>
                 Dismissible(
                   direction: DismissDirection.vertical,
                   key: const Key('key'),
                   onDismissed: (_) => Navigator.of(context).pop(),
                   child: CustomDialog(
                    backgroundColor: Colors.transparent,
                    clipBehavior: Clip.hardEdge,
                    insetPadding: EdgeInsets.all(0),
                    child: Padding(
                      padding: const EdgeInsets.all(00.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width*0.9,
                        height: MediaQuery.of(context).size.height*0.8,
                        child: InteractiveViewer(
                          panEnabled: true, // Set it to false to prevent panning.
                          boundaryMargin: EdgeInsets.all(50),
                          minScale: 0.5,
                          maxScale: 4,
                          child: CachedNetworkImage(
                              imageUrl: chatContent,
                              height: 150,
                              width: 200,
                              placeholder: (context, url) => Center(child: SizedBox(width: 30,height: 30,child: CircularProgressIndicator())),
                              errorWidget: (context, url, error) => Icon(Icons.error)),
                        ),
                      ),
                    ),
                ),
                 ),
              ),
      child: Container(
        height: 150,
        width: 200,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          color: myHexColor
        ),
        child: _widgetShowImages(chatContent),
      ),
    );
  }

  // Show Images from network
  Widget _widgetShowImages(String imageUrl,) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      height: 150,
      width: 200,
      placeholder: (context, url) => Center(child: SizedBox(width: 30,height: 30,child: CircularProgressIndicator())),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }

  modalSheetGroupIconChange() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15.0),
        ),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: 10.0,
                  ),
                  Center(
                    child: Text(
                      "Select emoji",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                                  await DatabaseService(uid: widget.userId).updateMessageReaction(widget.groupId, widget.messageId,previousValue);
                                  await DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 0.toString(),widget.displayName,widget.photo);
                                  break;
                                }
                              }
                              if(add){
                                DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 0.toString(),widget.displayName,widget.photo);
                              }
                            }
                          },
                          child: Image.asset(chatReactionImages[0],
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
                                  await DatabaseService(uid: widget.userId).updateMessageReaction(widget.groupId, widget.messageId,previousValue);
                                  await DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 1.toString(),widget.displayName,widget.photo);
                                  break;
                                }
                              }
                              if(add){
                                DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 1.toString(),widget.displayName,widget.photo);
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
                                  await DatabaseService(uid: widget.userId).updateMessageReaction(widget.groupId, widget.messageId,previousValue);
                                  await DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 2.toString(),widget.displayName,widget.photo);
                                  break;
                                }
                              }
                              if(add){
                                DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 2.toString(),widget.displayName,widget.photo);
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
                                  await DatabaseService(uid: widget.userId).updateMessageReaction(widget.groupId, widget.messageId,previousValue);
                                  await DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 3.toString(),widget.displayName,widget.photo);
                                  break;
                                }
                              }
                              if(add){
                                DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 3.toString(),widget.displayName,widget.photo);
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
                                  await DatabaseService(uid: widget.userId).updateMessageReaction(widget.groupId, widget.messageId,previousValue);
                                  await DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 4.toString(),widget.displayName,widget.photo);
                                  break;
                                }
                              }
                              if(add){
                                DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 4.toString(),widget.displayName,widget.photo);
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
                                  await DatabaseService(uid: widget.userId).updateMessageReaction(widget.groupId, widget.messageId,previousValue);
                                  await DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 5.toString(),widget.displayName,widget.photo);
                                  break;
                                }
                              }
                              if(add){
                                DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 5.toString(),widget.displayName,widget.photo);
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
                                  await DatabaseService(uid: widget.userId).updateMessageReaction(widget.groupId, widget.messageId,previousValue);
                                  await DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 6.toString(),widget.displayName,widget.photo);
                                  break;
                                }
                              }
                              if(add){
                                DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 6.toString(),widget.displayName,widget.photo);
                              }
                            }
                          },
                          child: Image.asset(chatReactionImages[6],
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
                                  await DatabaseService(uid: widget.userId).updateMessageReaction(widget.groupId, widget.messageId,previousValue);
                                  await DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 7.toString(),widget.displayName,widget.photo);
                                  break;
                                }
                              }
                              if(add){
                                DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 7.toString(),widget.displayName,widget.photo);
                              }
                            }
                          },
                          child: Image.asset(chatReactionImages[7],
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
                                  await DatabaseService(uid: widget.userId).updateMessageReaction(widget.groupId, widget.messageId,previousValue);
                                  await DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 8.toString(),widget.displayName,widget.photo);
                                  break;
                                }
                              }
                              if(add){
                                DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 8.toString(),widget.displayName,widget.photo);
                              }
                            }
                          },
                          child: Image.asset(chatReactionImages[8],
                            height: 30,
                            width: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                                  await DatabaseService(uid: widget.userId).updateMessageReaction(widget.groupId, widget.messageId,previousValue);
                                  await DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 9.toString(),widget.displayName,widget.photo);
                                  break;
                                }
                              }
                              if(add){
                                DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 9.toString(),widget.displayName,widget.photo);
                              }
                            }
                          },
                          child: Image.asset(chatReactionImages[9],
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
                                  await DatabaseService(uid: widget.userId).updateMessageReaction(widget.groupId, widget.messageId,previousValue);
                                  await DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 10.toString(),widget.displayName,widget.photo);
                                  break;
                                }
                              }
                              if(add){
                                DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 10.toString(),widget.displayName,widget.photo);
                              }
                            }
                          },
                          child: Image.asset(chatReactionImages[10],
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
                                  await DatabaseService(uid: widget.userId).updateMessageReaction(widget.groupId, widget.messageId,previousValue);
                                  await DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 11.toString(),widget.displayName,widget.photo);
                                  break;
                                }
                              }
                              if(add){
                                DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 11.toString(),widget.displayName,widget.photo);
                              }
                            }
                          },
                          child: Image.asset(chatReactionImages[11],
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
                                  await DatabaseService(uid: widget.userId).updateMessageReaction(widget.groupId, widget.messageId,previousValue);
                                  await DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 12.toString(),widget.displayName,widget.photo);
                                  break;
                                }
                              }
                              if(add){
                                DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 12.toString(),widget.displayName,widget.photo);
                              }
                            }
                          },
                          child: Image.asset(chatReactionImages[12],
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
                                  await DatabaseService(uid: widget.userId).updateMessageReaction(widget.groupId, widget.messageId,previousValue);
                                  await DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 13.toString(),widget.displayName,widget.photo);
                                  break;
                                }
                              }
                              if(add){
                                DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 13.toString(),widget.displayName,widget.photo);
                              }
                            }
                          },
                          child: Image.asset(chatReactionImages[13],
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
                                  await DatabaseService(uid: widget.userId).updateMessageReaction(widget.groupId, widget.messageId,previousValue);
                                  await DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 14.toString(),widget.displayName,widget.photo);
                                  break;
                                }
                              }
                              if(add){
                                DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 14.toString(),widget.displayName,widget.photo);
                              }
                            }
                          },
                          child: Image.asset(chatReactionImages[14],
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
                                  await DatabaseService(uid: widget.userId).updateMessageReaction(widget.groupId, widget.messageId,previousValue);
                                  await DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 15.toString(),widget.displayName,widget.photo);
                                  break;
                                }
                              }
                              if(add){
                                DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 15.toString(),widget.displayName,widget.photo);
                              }
                            }
                          },
                          child: Image.asset(chatReactionImages[15],
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
                                  await DatabaseService(uid: widget.userId).updateMessageReaction(widget.groupId, widget.messageId,previousValue);
                                  await DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 16.toString(),widget.displayName,widget.photo);
                                  break;
                                }
                              }
                              if(add){
                                DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 16.toString(),widget.displayName,widget.photo);
                              }
                            }
                          },
                          child: Image.asset(chatReactionImages[16],
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
                                  await DatabaseService(uid: widget.userId).updateMessageReaction(widget.groupId, widget.messageId,previousValue);
                                  await DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 17.toString(),widget.displayName,widget.photo);
                                  break;
                                }
                              }
                              if(add){
                                DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 17.toString(),widget.displayName,widget.photo);
                              }
                            }
                          },
                          child: Image.asset(chatReactionImages[17],
                            height: 30,
                            width: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                                  await DatabaseService(uid: widget.userId).updateMessageReaction(widget.groupId, widget.messageId,previousValue);
                                  await DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 18.toString(),widget.displayName,widget.photo);
                                  break;
                                }
                              }
                              if(add){
                                DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 18.toString(),widget.displayName,widget.photo);
                              }
                            }
                          },
                          child: Image.asset(chatReactionImages[18],
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
                                  await DatabaseService(uid: widget.userId).updateMessageReaction(widget.groupId, widget.messageId,previousValue);
                                  await DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 19.toString(),widget.displayName,widget.photo);
                                  break;
                                }
                              }
                              if(add){
                                DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 19.toString(),widget.displayName,widget.photo);
                              }
                            }
                          },
                          child: Image.asset(chatReactionImages[19],
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
                                  await DatabaseService(uid: widget.userId).updateMessageReaction(widget.groupId, widget.messageId,previousValue);
                                  await DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 20.toString(),widget.displayName,widget.photo);
                                  break;
                                }
                              }
                              if(add){
                                DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 20.toString(),widget.displayName,widget.photo);
                              }
                            }
                          },
                          child: Image.asset(chatReactionImages[20],
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
                                  await DatabaseService(uid: widget.userId).updateMessageReaction(widget.groupId, widget.messageId,previousValue);
                                  await DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 21.toString(),widget.displayName,widget.photo);
                                  break;
                                }
                              }
                              if(add){
                                DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 21.toString(),widget.displayName,widget.photo);
                              }
                            }
                          },
                          child: Image.asset(chatReactionImages[21],
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
                                  await DatabaseService(uid: widget.userId).updateMessageReaction(widget.groupId, widget.messageId,previousValue);
                                  await DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 22.toString(),widget.displayName,widget.photo);
                                  break;
                                }
                              }
                              if(add){
                                DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 22.toString(),widget.displayName,widget.photo);
                              }
                            }
                          },
                          child: Image.asset(chatReactionImages[22],
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
                                  await DatabaseService(uid: widget.userId).updateMessageReaction(widget.groupId, widget.messageId,previousValue);
                                  await DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 23.toString(),widget.displayName,widget.photo);
                                  break;
                                }
                              }
                              if(add){
                                DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 23.toString(),widget.displayName,widget.photo);
                              }
                            }
                          },
                          child: Image.asset(chatReactionImages[23],
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
                                  await DatabaseService(uid: widget.userId).updateMessageReaction(widget.groupId, widget.messageId,previousValue);
                                  await DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 24.toString(),widget.displayName,widget.photo);
                                  break;
                                }
                              }
                              if(add){
                                DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 24.toString(),widget.displayName,widget.photo);
                              }
                            }
                          },
                          child: Image.asset(chatReactionImages[24],
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
                                  await DatabaseService(uid: widget.userId).updateMessageReaction(widget.groupId, widget.messageId,previousValue);
                                  await DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 25.toString(),widget.displayName,widget.photo);
                                  break;
                                }
                              }
                              if(add){
                                DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 25.toString(),widget.displayName,widget.photo);
                              }
                            }
                          },
                          child: Image.asset(chatReactionImages[25],
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
                                  await DatabaseService(uid: widget.userId).updateMessageReaction(widget.groupId, widget.messageId,previousValue);
                                  await DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 26.toString(),widget.displayName,widget.photo);
                                  break;
                                }
                              }
                              if(add){
                                DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 26.toString(),widget.displayName,widget.photo);
                              }
                            }
                          },
                          child: Image.asset(chatReactionImages[26],
                            height: 30,
                            width: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                                  await DatabaseService(uid: widget.userId).updateMessageReaction(widget.groupId, widget.messageId,previousValue);
                                  await DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 27.toString(),widget.displayName,widget.photo);
                                  break;
                                }
                              }
                              if(add){
                                DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 27.toString(),widget.displayName,widget.photo);
                              }
                            }
                          },
                          child: Image.asset(chatReactionImages[27],
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
                                  await DatabaseService(uid: widget.userId).updateMessageReaction(widget.groupId, widget.messageId,previousValue);
                                  await DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 28.toString(),widget.displayName,widget.photo);
                                  break;
                                }
                              }
                              if(add){
                                DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 28.toString(),widget.displayName,widget.photo);
                              }
                            }
                          },
                          child: Image.asset(chatReactionImages[28],
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
                                  await DatabaseService(uid: widget.userId).updateMessageReaction(widget.groupId, widget.messageId,previousValue);
                                  await DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 29.toString(),widget.displayName,widget.photo);
                                  break;
                                }
                              }
                              if(add){
                                DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 29.toString(),widget.displayName,widget.photo);
                              }
                            }
                          },
                          child: Image.asset(chatReactionImages[29],
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
                                  await DatabaseService(uid: widget.userId).updateMessageReaction(widget.groupId, widget.messageId,previousValue);
                                  await DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 30.toString(),widget.displayName,widget.photo);
                                  break;
                                }
                              }
                              if(add){
                                DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 30.toString(),widget.displayName,widget.photo);
                              }
                            }
                          },
                          child: Image.asset(chatReactionImages[30],
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
                                  await DatabaseService(uid: widget.userId).updateMessageReaction(widget.groupId, widget.messageId,previousValue);
                                  await DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 31.toString(),widget.displayName,widget.photo);
                                  break;
                                }
                              }
                              if(add){
                                DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 31.toString(),widget.displayName,widget.photo);
                              }
                            }
                          },
                          child: Image.asset(chatReactionImages[31],
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
                                  await DatabaseService(uid: widget.userId).updateMessageReaction(widget.groupId, widget.messageId,previousValue);
                                  await DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 32.toString(),widget.displayName,widget.photo);
                                  break;
                                }
                              }
                              if(add){
                                DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 32.toString(),widget.displayName,widget.photo);
                              }
                            }
                          },
                          child: Image.asset(chatReactionImages[32],
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
                                  await DatabaseService(uid: widget.userId).updateMessageReaction(widget.groupId, widget.messageId,previousValue);
                                  await DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 33.toString(),widget.displayName,widget.photo);
                                  break;
                                }
                              }
                              if(add){
                                DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 33.toString(),widget.displayName,widget.photo);
                              }
                            }
                          },
                          child: Image.asset(chatReactionImages[33],
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
                                  await DatabaseService(uid: widget.userId).updateMessageReaction(widget.groupId, widget.messageId,previousValue);
                                  await DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 34.toString(),widget.displayName,widget.photo);
                                  break;
                                }
                              }
                              if(add){
                                DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, 34.toString(),widget.displayName,widget.photo);
                              }
                            }
                          },
                          child: Image.asset(chatReactionImages[34],
                            height: 30,
                            width: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }


}

