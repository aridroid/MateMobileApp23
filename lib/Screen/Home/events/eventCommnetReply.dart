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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: MateColors.activeIcons,
        ),
        title: Text(
          "Reply",
          style: TextStyle(
            color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
            fontWeight: FontWeight.w700,
            fontSize: 17.0,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(0.0), border: Border.all(color: themeController.isDarkMode?MateColors.darkDivider:MateColors.lightDivider, width: 1)),
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
                              child: Text(
                                widget.result.content,
                                style:  TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.1,
                                  color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                                ),
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                DateFormat.yMMMEd().format(DateFormat("yyyy-MM-dd").parse(widget.result.createdAt.toString(), true)),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.1,
                                  color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
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
                              child: Text("Reply", style: TextStyle(color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor, fontSize: 12.5, fontWeight: FontWeight.w400),),
                            ),
                            Text(widget.result.replies.isEmpty?"":widget.result.replies.length>1?
                            "   •   ${widget.result.replies.length} Replies":
                            "   •   ${widget.result.replies.length} Reply",
                              style: TextStyle(color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor, fontSize: 12.5, fontWeight: FontWeight.w400),),
                          ],
                        ),
                      ),
                      widget.result.replies.isNotEmpty?
                      ListView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
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
                                        child: Text(
                                          widget.result.replies[index].content,
                                          style:  TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.1,
                                            color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                                          ),
                                        ),
                                      ),
                                      subtitle: Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Text(
                                          DateFormat.yMMMEd().format(DateFormat("yyyy-MM-dd").parse(widget.result.replies[index].createdAt.toString(), true)),
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            letterSpacing: 0.1,
                                            color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
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
                                            color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
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
              cursorColor: Colors.cyanAccent,
              style: TextStyle(color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor),
              textInputAction: TextInputAction.done,
              minLines: 1,
              maxLines: 4,
              decoration: InputDecoration(
                hintStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.1,
                  color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.send,
                    size: 20,
                    color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
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
                fillColor: themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightButtonBackground,
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderSide:  BorderSide(
                    color: themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightButtonBackground,
                  ),
                  borderRadius: BorderRadius.circular(26.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:  BorderSide(
                    color:  themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightButtonBackground,
                  ),
                  borderRadius: BorderRadius.circular(26.0),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide:  BorderSide(
                    color: themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightButtonBackground,
                  ),
                  borderRadius: BorderRadius.circular(26.0),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide:  BorderSide(
                    color: themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightButtonBackground,
                  ),
                  borderRadius: BorderRadius.circular(26.0),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide:  BorderSide(
                    color: themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightButtonBackground,
                  ),
                  borderRadius: BorderRadius.circular(26.0),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }


}
