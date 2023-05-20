import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mate_app/Screen/chatDashboard/forwardMessagePage.dart';
import 'package:mate_app/Services/community_tab_services.dart';
import 'package:mate_app/Utility/Utility.dart';
import 'package:mate_app/Widget/mediaViewer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mate_app/groupChat/services/database_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibration/vibration.dart';

import '../../Model/emojiModel.dart';
import '../../Providers/AuthUserProvider.dart';
import '../../Screen/Profile/ProfileScreen.dart';
import '../../Screen/Profile/UserProfileScreen.dart';
import '../../Widget/Loaders/Shimmer.dart';
import '../../Widget/custom_swipe_to.dart';
import '../../Widget/focused_menu/focused_menu.dart';
import '../../Widget/focused_menu/modals.dart';
import '../../asset/Colors/MateColors.dart';
import '../../constant.dart';

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
  bool isUserMember;
  Function() onEmojiKeyboardToggle;
  Function(String messageId,List<dynamic> messageReaction) onPlusIconCall;
  MessageTile({this.isUserMember,this.showDateToggle,this.editMessage,this.currentDuration,this.duration,this.startAudio,this.pauseAudio,this.senderId,this.isForwarded=false,this.fileSizeFull,this.time,this.date,this.index,this.senderImage,this.displayName,this.photo,this.messageReaction,this.groupId,this.userId,this.messageId,this.message, this.sender, this.sentByMe, this.messageTime,
    this.isImage = false, this.isFile = false, this.isGif = false, this.fileExtension, this.fileName, this.fileSize, this.fileSizeUnit ,this.selectMessage, this.previousMessage, this.previousSender, this.isAudio, this.isPlaying, this.isPaused, this.isLoadingAudio, this.showDate,this.onEmojiKeyboardToggle,this.onPlusIconCall});

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {

  @override
  Widget build(BuildContext context) {

    List<EmojiModel> emojiList = [];
    for(int i=0;i<widget.messageReaction.length;i++){
      List<String> split = widget.messageReaction[i].toString().split("_____");
      if(i==0){
        emojiList.add(EmojiModel(emoji: split[3],length: 1,id: [split[0]],name: [split[1]],image: [split[2]]));
      }else{
        int ind = emojiList.indexWhere((element) => element.emoji == split[3]);
        if(ind>-1){
          emojiList[ind].length++;
          emojiList[ind].id.add(split[0]);
          emojiList[ind].name.add(split[1]);
          emojiList[ind].image.add(split[2]);
        }else{
          emojiList.add(EmojiModel(emoji: split[3],length: 1,id: [split[0]],name: [split[1]],image: [split[2]]));
        }
      }
    }

    return Column(
      crossAxisAlignment: widget.sentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        widget.index == 0?
        Padding(
          padding: const EdgeInsets.only(left: 35,right: 35,top: 20,bottom: 5),
          child: Align(
            alignment: widget.message.contains("This is missed call@#%")?Alignment.center:widget.sentByMe? Alignment.topRight: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20,right: 20),
              child: Text(
                widget.date[widget.index],
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: "Poppins",
                  color: themeController.isDarkMode?
                  Colors.white.withOpacity(0.5):
                  Colors.black.withOpacity(0.5),
                ),
              ),
            ),
          ),
        ):
        widget.date[widget.index] != widget.date[widget.index-1]?
        Padding(
          padding: const EdgeInsets.only(left: 35,right: 35,top: 20,bottom: 5),
          child: Align(
            alignment: widget.message.contains("This is missed call@#%")?Alignment.center:widget.sentByMe? Alignment.topRight: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20,right: 20),
              child: Text(
                widget.date[widget.index],
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: "Poppins",
                  color: themeController.isDarkMode?
                  Colors.white.withOpacity(0.5):
                  Colors.black.withOpacity(0.5),
                ),
              ),
            ),
          ),
        ):Offstage(),
        widget.message.contains("This is missed call@#%")?
        Container(
          margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.22,right: MediaQuery.of(context).size.width*0.22,top: 20),
          decoration: BoxDecoration(
            color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.call_missed,color: Colors.red,),
              SizedBox(width: 5,),
              Text(
                widget.message.split("___").last,
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: "Poppins",
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ):Offstage(),
        if(!widget.message.contains("This is missed call@#%"))
        CustomSwipeTo(
          onRightSwipe: (){
            if(widget.showDate){
              widget.showDateToggle();
            }else{
              Vibration.vibrate(
                  pattern: [1, 150, 1, 150], intensities: [100, 100]
              );
              widget.selectMessage(widget.message.trim(),widget.sender,true);
            }
          },
          showDateToggle: widget.showDateToggle,
          showDate: widget.showDate,
          child: Padding(
            padding: EdgeInsets.only(top: 4, bottom: 4, left: widget.sentByMe ? 0 : 14, right: widget.sentByMe ? 14 : 0),
            child: FocusedMenuHolder(
              menuWidth: MediaQuery.of(context).size.width*0.94,
              blurSize: 5.0,
              menuItemExtent: 45,
              isChatPage: true,
              isLeftPadding: !widget.sentByMe,
              isRightPadding: widget.sentByMe,
              menuBoxDecoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              duration: Duration(milliseconds: 100),
              animateMenuItems: true,
              isUserMember: widget.isUserMember,
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
                                await DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, '❤',widget.displayName,widget.photo);
                                break;
                              }
                            }
                            if(add){
                              DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, '❤',widget.displayName,widget.photo);
                            }
                          }
                        },
                        child: Text('❤',
                          style: TextStyle(
                            fontSize: 28,
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
                                  await DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, '😂',widget.displayName,widget.photo);
                                  break;
                                }
                              }
                              if(add){
                                DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, '😂',widget.displayName,widget.photo);
                              }
                            }
                          },
                          child: Text('😂',
                            style: TextStyle(
                              fontSize: 28,
                            ),
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
                                    await DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, '😯',widget.displayName,widget.photo);
                                    break;
                                  }
                                }
                                if(add){
                                  DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, '😯',widget.displayName,widget.photo);
                                }
                              }
                            },
                          child: Text('😯',
                            style: TextStyle(
                              fontSize: 28,
                            ),
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
                                  await DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, '😢',widget.displayName,widget.photo);
                                  break;
                                }
                              }
                              if(add){
                                DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, '😢',widget.displayName,widget.photo);
                              }
                            }
                          },
                          child: Text('😢',
                            style: TextStyle(
                              fontSize: 28,
                            ),
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
                                  await DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, '😡',widget.displayName,widget.photo);
                                  break;
                                }
                              }
                              if(add){
                                DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, '😡',widget.displayName,widget.photo);
                              }
                            }
                          },
                          child: Text('😡',
                            style: TextStyle(
                              fontSize: 28,
                            ),
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
                                  await DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, '👍',widget.displayName,widget.photo);
                                  break;
                                }
                              }
                              if(add){
                                DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, '👍',widget.displayName,widget.photo);
                              }
                            }
                          },
                          child: Text('👍',
                            style: TextStyle(
                              fontSize: 28,
                            ),
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
                                  await DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, '👎',widget.displayName,widget.photo);
                                  break;
                                }
                              }
                              if(add){
                                DatabaseService(uid: widget.userId).setMessageReaction(widget.groupId, widget.messageId, '👎',widget.displayName,widget.photo);
                              }
                            }
                          },
                          child: Text('👎',
                            style: TextStyle(
                              fontSize: 28,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          Get.back();
                          widget.onEmojiKeyboardToggle();
                          widget.onPlusIconCall(widget.messageId,widget.messageReaction);
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          margin: EdgeInsets.only(left: 12),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: themeController.isDarkMode?Colors.white.withOpacity(0.3):Colors.white.withOpacity(0.7),
                          ),
                          child: Center(child: Icon(Icons.add,color: themeController.isDarkMode?Colors.white:Colors.black,size: 30,)),
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: Colors.white.withOpacity(0.15),
                  onPressed: (){},
                ),
                FocusedMenuItem(
                  onPressed: (){},
                  backgroundColor: Colors.transparent,
                  title: Text("This item will not display"),
                  trailingIcon: Icon(Icons.add),
                ),
                if(widget.sentByMe)
                FocusedMenuItem(
                  title: Row(
                    children: [
                      Image.asset(
                        "lib/asset/iconsNewDesign/delete.png",
                        color: themeController.isDarkMode?MateColors.iconLight:Colors.white,
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
                            fontWeight: FontWeight.w600,
                            color: themeController.isDarkMode?Colors.white: MateColors.blackText,
                          ),
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: Colors.white.withOpacity(0.15),
                  onPressed: ()async{
                    await DatabaseService().deleteMessage(widget.groupId,widget.messageId);
                  },
                ),
                FocusedMenuItem(
                  title: Row(
                    children: [
                      Image.asset(
                        "lib/asset/iconsNewDesign/forward.png",
                        color: Colors.red,
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
                            fontWeight: FontWeight.w600,
                            color: themeController.isDarkMode?Colors.white: MateColors.blackText,
                          ),
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: Colors.white.withOpacity(0.15),
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
                        "lib/asset/iconsNewDesign/reply.png",
                        color: themeController.isDarkMode?MateColors.iconLight:Colors.white,
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
                            fontWeight: FontWeight.w600,
                            color: themeController.isDarkMode?Colors.white: MateColors.blackText,
                          ),
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: Colors.white.withOpacity(0.15),
                  onPressed: (){
                    widget.selectMessage(widget.message.trim(),widget.sender,true);
                  },
                ),
                FocusedMenuItem(
                  title: Row(
                    children: [
                      Image.asset(
                        "lib/asset/iconsNewDesign/copy.png",
                        color: themeController.isDarkMode?MateColors.iconLight:Colors.white,
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
                            fontWeight: FontWeight.w600,
                            color: themeController.isDarkMode?Colors.white: MateColors.blackText,
                          ),
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: Colors.white.withOpacity(0.15),
                  onPressed: (){
                    Clipboard.setData(ClipboardData(text: widget.message));
                  },
                ),
                if(!widget.sentByMe)
                FocusedMenuItem(
                  title: Row(
                    children: [
                      Image.asset(
                        "lib/asset/iconsNewDesign/report.png",
                        height: 20,
                        width: 20,
                        color: Colors.red,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Text(
                          "Report",
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w600,
                            color: themeController.isDarkMode?Colors.white: MateColors.blackText,
                          ),
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: Colors.white.withOpacity(0.15),
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
                        color: themeController.isDarkMode?MateColors.iconLight:Colors.white,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Text(
                          "Edit",
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w600,
                            color: themeController.isDarkMode?Colors.white: MateColors.blackText,
                          ),
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: Colors.white.withOpacity(0.15),
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
                              alignment: widget.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
                              child: Container(
                                margin: widget.sentByMe ? EdgeInsets.only(left: MediaQuery.of(context).size.width*0.2,top: 10) : EdgeInsets.only(right: !widget.sentByMe && (widget.isImage || widget.isGif)?0:MediaQuery.of(context).size.width*0.2,top: 10),
                                decoration: BoxDecoration(
                                  borderRadius: widget.sentByMe
                                      ? BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20), bottomLeft: Radius.circular(20))
                                      : BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
                                  color: widget.sentByMe ? chatTealColor : themeController.isDarkMode? chatGreyColor: Colors.white.withOpacity(0.4),
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
                                                themeController.isDarkMode? MateColors.blackTextColor: Colors.black:
                                                themeController.isDarkMode? Colors.white : MateColors.blackTextColor,
                                              ),
                                              borderRadius: BorderRadius.circular(5),
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
                                                    themeController.isDarkMode? MateColors.blackTextColor: Colors.black:
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
                                                    themeController.isDarkMode? MateColors.blackTextColor: Colors.black:
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
                                          themeController.isDarkMode? MateColors.blackTextColor: Colors.black:
                                          themeController.isDarkMode? Colors.white : MateColors.blackTextColor,
                                        ),
                                        textAlign: TextAlign.start,
                                        linkStyle: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontSize: 14.0,letterSpacing: 0.1),
                                      ),
                                    ],
                                  ),
                                ),
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
                  Padding(
                    padding: EdgeInsets.only(left: 0,right: !widget.sentByMe?10:0),
                    child: AnimatedContainer(
                      curve: Curves.easeInOut,
                      width: widget.showDate?60:0,
                      height: 15,
                      duration: const Duration(milliseconds: 300),
                      child: Text(
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
                backgroundColor: themeController.isDarkMode?MateColors.bottomSheetBackgroundDark:MateColors.bottomSheetBackgroundLight,
                builder: (context) {
                  return DefaultTabController(
                    initialIndex: 0,
                    length: emojiList.length + 1,
                    child: Column(
                      children: [
                        TabBar(
                          unselectedLabelColor: Color(0xFF656568),
                          indicatorColor: MateColors.activeIcons,
                          labelColor: themeController.isDarkMode ? Colors.white : MateColors.blackTextColor,
                          labelPadding: EdgeInsets.only(left: 10,right: 10),
                          isScrollable: emojiList.length>5?true:false,
                          tabs: <Widget>[
                            Tab(
                              text: "All",
                            ),
                            for(int i=0;i<emojiList.length;i++)
                              Tab(
                                text: emojiList[i].emoji,
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
                                                Text(split[3],
                                                  style: TextStyle(
                                                    fontSize: 25,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }),
                              for(int i=0;i<emojiList.length;i++)
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  padding: EdgeInsets.only(left: 10, right: 20,top: 0,bottom: 30),
                                  itemCount: emojiList[i].length,
                                  itemBuilder: (context, index) {
                                    return FutureBuilder(
                                      future: DatabaseService().getUsersDetails(emojiList[i].id[index]),
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
                                                      backgroundImage: NetworkImage(emojiList[i].image[index]),
                                                    ),
                                                    SizedBox(width: 20,),
                                                    Text(emojiList[i].name[index],
                                                      style: TextStyle(color: themeController.isDarkMode?Colors.white:Colors.black, fontSize: 12.5.sp, fontWeight: FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                                Text(emojiList[i].emoji,
                                                  style: TextStyle(
                                                    fontSize: 25,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
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
            alignment:  widget.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
            margin: EdgeInsets.only(left: widget.sentByMe ? 0 : 54, right: widget.sentByMe ? widget.showDate?114:54 : 0,top: 4),
            child: Wrap(
              runSpacing: 3,
              children: [
                for(int i=0;i<emojiList.length;i++)
                  reactionContainer(emojiList[i].length.toString(),emojiList[i].emoji),
              ],
            ),
          ),
        ),
        widget.isFile?
        Padding(
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
              SizedBox(width: 10,),
              Text(
                widget.date[widget.index] == "Today" || widget.date[widget.index] == "Yesterday"?
                widget.date[widget.index] + " at " + widget.time[widget.index]:
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

            ],
          ),
        ) :SizedBox(),
      ],
    );
  }

  Widget reactionContainer(String length,String emoji){
    return Container(
      height: 28,
      width: 47,
      margin: EdgeInsets.only(left: 6),
      padding: EdgeInsets.only(top: 0,bottom: 0,left: 6,right: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: themeController.isDarkMode?MateColors.dividerDark:MateColors.dividerLight,),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji,
            style: TextStyle(
              fontSize: 17,
              color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(length,
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.1,
                color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
              ),
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
              themeController.isDarkMode? MateColors.blackTextColor: Colors.black:
              themeController.isDarkMode? Colors.white : MateColors.blackTextColor,
            ),
          ):
          Icon(
            widget.isPlaying ? Icons.pause: Icons.play_arrow,
            size: 30,
            color: widget.sentByMe?
            themeController.isDarkMode? MateColors.blackTextColor: Colors.black:
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
                themeController.isDarkMode? MateColors.blackTextColor: Colors.black:
                themeController.isDarkMode? Colors.white : MateColors.blackTextColor,),
                Icon(Icons.multitrack_audio_sharp,color: widget.sentByMe?
                themeController.isDarkMode? MateColors.blackTextColor: Colors.black:
                themeController.isDarkMode? Colors.white : MateColors.blackTextColor,),
                Icon(Icons.multitrack_audio_sharp,color: widget.sentByMe?
                themeController.isDarkMode? MateColors.blackTextColor: Colors.black:
                themeController.isDarkMode? Colors.white : MateColors.blackTextColor,),
                widget.showDate?SizedBox():
                Icon(Icons.multitrack_audio_sharp,color: widget.sentByMe?
                themeController.isDarkMode? MateColors.blackTextColor: Colors.black:
                themeController.isDarkMode? Colors.white : MateColors.blackTextColor,),
                widget.showDate?SizedBox():
                Icon(Icons.multitrack_audio_sharp,color: widget.sentByMe?
                themeController.isDarkMode? MateColors.blackTextColor: Colors.black:
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
                      themeController.isDarkMode? MateColors.blackTextColor: Colors.black:
                      themeController.isDarkMode? Colors.white : MateColors.blackTextColor,
                    ),
                  ):Offstage(),
                  SizedBox(width: MediaQuery.of(context).size.width*0.13,),
                  widget.duration!=null?
                  Text(widget.duration.inMinutes.toString().padLeft(2,'0') +":"+ widget.duration.inSeconds.toString().padLeft(2,"0"),
                    style: TextStyle(
                      color: widget.sentByMe?
                      themeController.isDarkMode? MateColors.blackTextColor: Colors.black:
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
      onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>MediaViewer(url: chatContent,))),
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
      onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=>MediaViewer(url: chatContent,))),
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

  Widget _widgetShowImages(String imageUrl,) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      height: 150,
      width: 200,
      placeholder: (context, url) => Center(child: SizedBox(width: 30,height: 30,child: CircularProgressIndicator())),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }

}

