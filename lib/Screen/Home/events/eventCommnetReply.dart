import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mate_app/Model/eventCommentListingModel.dart';
import 'package:mate_app/Services/eventService.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Providers/AuthUserProvider.dart';
import '../../../asset/Colors/MateColors.dart';
import '../../../constant.dart';
import '../../../controller/theme_controller.dart';
import '../../Profile/ProfileScreen.dart';
import '../../Profile/UserProfileScreen.dart';


class EventCommentReply extends StatefulWidget {
  final Result result;
  final int commentId;
  final int eventId;
  Function(bool increment) changeCommentCount;
  EventCommentReply({Key key, this.commentId, this.eventId, this.result,this.changeCommentCount}) : super(key: key);

  @override
  _EventCommentReplyState createState() => _EventCommentReplyState();
}

class _EventCommentReplyState extends State<EventCommentReply> {
  FocusNode focusNode= FocusNode();
  TextEditingController messageEditingController = new TextEditingController();
  ThemeController themeController = Get.find<ThemeController>();
  EventService _eventService = EventService();

  @override
  void initState() {
    getStoredValue();
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  String token = "";
  getStoredValue()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token");
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
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height*0.07,
                  left: 16,
                  right: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Get.back();
                      },
                      child: Icon(Icons.arrow_back_ios,
                        size: 20,
                        color: themeController.isDarkMode ? Colors.white : MateColors.blackTextColor,
                      ),
                    ),
                    Text(
                      "Reply",
                      style: TextStyle(
                        color: themeController.isDarkMode ? Colors.white : MateColors.blackTextColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 17.0,
                      ),
                    ),
                    SizedBox(),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: EdgeInsets.only(top: 30),
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(0.0),
                        border: Border.all(
                          color: themeController.isDarkMode?MateColors.dividerDark:MateColors.dividerLight,
                          width: 1,
                        ),
                      ),
                      padding: EdgeInsets.fromLTRB(16, 15, 16, 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: GestureDetector(
                              onTap: (){
                                if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == widget.result.user.uuid) {
                                  Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                                } else {
                                  Navigator.of(context).pushNamed(UserProfileScreen.routeName, arguments: {
                                    "id": widget.result.user.uuid,
                                    "name": widget.result.user.displayName,
                                    "photoUrl": widget.result.user.profilePhoto,
                                    "firebaseUid": widget.result.user.firebaseUid,
                                  });
                                }
                              },
                              child: ListTile(
                                horizontalTitleGap: 1,
                                dense: true,
                                leading: widget.result.user.profilePhoto != null?
                                ClipOval(
                                  child: Image.network(
                                    widget.result.user.profilePhoto,
                                    height: 28,
                                    width: 28,
                                    fit: BoxFit.cover,
                                  ),
                                ):CircleAvatar(
                                  radius: 14,
                                  child: Text(widget.result.user.displayName[0]),
                                ),
                                title: Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: buildEmojiAndText(
                                    content: widget.result.content,
                                    textStyle: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0.1,
                                      color: themeController.isDarkMode?Colors.white:Colors.black,
                                    ),
                                    normalFontSize: 14,
                                    emojiFontSize: 24,
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text(
                                    DateFormat.yMMMEd().format(DateFormat("yyyy-MM-dd").parse(widget.result.createdAt.toString(), true)),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: themeController.isDarkMode?MateColors.helpingTextDark:Colors.black.withOpacity(0.72),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 58,top: 5),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: ()=> focusNode.requestFocus(),
                                  child: Text("Reply",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0.1,
                                      color: themeController.isDarkMode?Colors.white:Colors.black,
                                    ),
                                  ),
                                ),
                                Text(widget.result.replies.isEmpty?"":widget.result.replies.length>1?
                                "   •   ${widget.result.replies.length} Replies":
                                "   •   ${widget.result.replies.length} Reply",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 0.1,
                                    color: themeController.isDarkMode?Colors.white:Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          widget.result.replies.isNotEmpty?
                          ListView.builder(
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemCount: widget.result.replies.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.fromLTRB(40, 0, 0, 5),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == widget.result.replies[index].user.uuid) {
                                            Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                                          } else {
                                            Navigator.of(context).pushNamed(UserProfileScreen.routeName, arguments: {
                                              "id": widget.result.replies[index].user.uuid,
                                              "name": widget.result.replies[index].user.displayName,
                                              "photoUrl": widget.result.replies[index].user.profilePhoto,
                                              "firebaseUid": widget.result.replies[index].user.firebaseUid
                                            });
                                          }
                                        },
                                        child: ListTile(
                                          horizontalTitleGap: 1,
                                          dense: true,
                                          leading: widget.result.replies[index].user.profilePhoto != null?
                                          ClipOval(
                                            child: Image.network(
                                              widget.result.replies[index].user.profilePhoto,
                                              height: 28,
                                              width: 28,
                                              fit: BoxFit.cover,
                                            ),
                                          ):CircleAvatar(
                                            radius: 14,
                                            child: Text(widget.result.replies[index].user.displayName[0],),
                                          ),
                                          title: Padding(
                                            padding: const EdgeInsets.only(top: 10),
                                            child: buildEmojiAndText(
                                              content:  widget.result.replies[index].content,
                                              textStyle: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w400,
                                                letterSpacing: 0.1,
                                                color: themeController.isDarkMode?Colors.white:Colors.black,
                                              ),
                                              normalFontSize: 14,
                                              emojiFontSize: 24,
                                            ),
                                          ),
                                          subtitle: Padding(
                                            padding: const EdgeInsets.only(top: 5),
                                            child: Text(
                                              DateFormat.yMMMEd().format(DateFormat("yyyy-MM-dd").parse(widget.result.replies[index].createdAt.toString(), true)),
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: themeController.isDarkMode?MateColors.helpingTextDark:Colors.black.withOpacity(0.72),
                                              ),
                                            ),
                                          ),
                                          trailing: Visibility(
                                            visible:  Provider.of<AuthUserProvider>(context, listen: false).authUser.id == widget.result.replies[index].user.uuid,
                                            child: widget.result.replies[index].isDeleting?
                                            SizedBox(
                                              height: 14,
                                              width: 14,
                                              child: CircularProgressIndicator(
                                                color: themeController.isDarkMode?Colors.white:Colors.black,
                                                strokeWidth: 1.2,
                                              ),
                                            ):
                                            InkWell(
                                              onTap: () async{
                                                setState(() {
                                                  widget.result.replies[index].isDeleting = true;
                                                });
                                                await _eventService.deleteComment(id: widget.result.replies[index].id,token: token);
                                                setState(() {
                                                  widget.result.replies[index].isDeleting = false;
                                                });
                                                widget.result.replies.removeAt(index);
                                                setState(() {});
                                                widget.changeCommentCount(false);
                                              },
                                              child: Icon(
                                                Icons.delete_outline,
                                                size: 18,
                                                color: themeController.isDarkMode?Colors.white:Colors.black,
                                              ),
                                            ),
                                          )
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ):SizedBox(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              _messageSendWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _messageSendWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.fromLTRB(16,15, 16, 10),
            child: TextField(
              focusNode: focusNode,
              controller: messageEditingController,
              cursorColor: themeController.isDarkMode?MateColors.helpingTextDark:MateColors.helpingTextLight,
              style:  TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.1,
                color: themeController.isDarkMode?Colors.white:Colors.black,
              ),
              textInputAction: TextInputAction.done,
              minLines: 1,
              maxLines: 4,
              decoration: InputDecoration(
                hintStyle: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  color: themeController.isDarkMode?MateColors.helpingTextDark:MateColors.helpingTextLight,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.send,
                    size: 20,
                    color: themeController.isDarkMode?MateColors.helpingTextDark:MateColors.helpingTextLight,
                  ),
                  onPressed: ()async {
                    if (messageEditingController.text.trim().isNotEmpty) {
                      var res = await _eventService.commentReply(
                        id: widget.eventId,
                        token: token,
                        content: messageEditingController.text.trim(),
                        parentId: widget.commentId
                      );
                      if(res != false){
                        //Get.back();
                        widget.result.replies.add(
                          Result(
                            id: res["data"]["id"],
                            parentId: res["data"]["parent_id"],
                            eventId: res["data"]["event_id"],
                            userId: res["data"]["user_id"],
                            content: res["data"]["content"],
                            status: res["data"]["status"],
                            createdAt: DateTime.tryParse(res["data"]["created_at"]),
                            updatedAt: DateTime.tryParse(res["data"]["updated_at"]),
                            replies: [],
                            repliesCount: 0,
                            user: User(
                              uuid: Provider.of<AuthUserProvider>(context,listen: false).authUser.id,
                              displayName: res["data"]["user"]["display_name"],
                              firstName: res["data"]["user"]["first_name"],
                              lastName: res["data"]["user"]["last_name"],
                              firebaseUid: res["data"]["user"]["firebase_uid"],
                              profilePhoto: Provider.of<AuthUserProvider>(context,listen: false).authUser.photoUrl,
                            ),
                          )
                        );
                        messageEditingController.clear();
                        widget.changeCommentCount(true);
                        setState(() {

                        });
                        Fluttertoast.showToast(msg: "Reply added successfully", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
                      }else{
                        Fluttertoast.showToast(msg: "Something went wrong", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
                      }
                    }
                  },
                ),
                hintText: "Add a comment...",
                fillColor: themeController.isDarkMode ? MateColors.containerDark : MateColors.containerLight,
                filled: true,
                focusedBorder: commonBorderCircular,
                enabledBorder: commonBorderCircular,
                disabledBorder: commonBorderCircular,
                errorBorder: commonBorderCircular,
                focusedErrorBorder: commonBorderCircular,
              ),
            ),
          ),
        ),
      ],
    );
  }


}
