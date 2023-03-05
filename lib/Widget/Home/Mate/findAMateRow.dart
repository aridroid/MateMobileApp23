import 'package:fluttertoast/fluttertoast.dart';
import 'package:mate_app/Providers/AuthUserProvider.dart';
import 'package:mate_app/Providers/findAMateProvider.dart';
import 'package:mate_app/Screen/Profile/ProfileScreen.dart';
import 'package:mate_app/Screen/Profile/UserProfileScreen.dart';
import 'package:mate_app/Screen/Report/reportPage.dart';
import 'package:mate_app/asset/Colors/MateColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mate_app/Model/findAMatePostsModel.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Loaders/Shimmer.dart';

class FindAMateRow extends StatefulWidget {
  final User user;
  final int findAMateId;
  final String title;
  final String description;
  final String fromDate;
  final String toDate;
  final String fromTime;
  final String toTime;
  final String hyperlinkText;
  final String hyperlink;
  final String createdAt;
  final int rowIndex;
  final bool isActive;
  const FindAMateRow({Key key, this.user, this.findAMateId, this.title, this.description, this.fromDate, this.toDate, this.fromTime, this.toTime, this.createdAt, this.rowIndex, this.isActive,this.hyperlinkText,this.hyperlink}) : super(key: key);

  @override
  _FindAMateRowState createState() => _FindAMateRowState(this.user, this.findAMateId, this.title, this.description, this.fromDate, this.toDate, this.fromTime, this.toTime, this.createdAt, this.rowIndex, this.isActive,this.hyperlinkText,this.hyperlink);
}

class _FindAMateRowState extends State<FindAMateRow> {
  final User user;
  final int findAMateId;
  final String title;
  final String description;
  final String fromDate;
  final String toDate;
  final String fromTime;
  final String toTime;
  final String hyperlinkText;
  final String hyperlink;
  final String createdAt;
  final int rowIndex;
  bool isActive;
  _FindAMateRowState(this.user, this.findAMateId, this.title, this.description, this.fromDate, this.toDate, this.fromTime, this.toTime, this.createdAt, this.rowIndex, this.isActive,this.hyperlinkText,this.hyperlink);

  FindAMateProvider findAMateProvider;
  List<String> fromTimeLocal;
  List<String> toTimeLocal;

  @override
  void initState() {
    if(fromTime!=null){
      fromTimeLocal = fromTime.split(":");
    }
    if(toTime!=null){
      toTimeLocal = toTime.split(":");
    }
    findAMateProvider = Provider.of<FindAMateProvider>(context,listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
      padding: EdgeInsets.only(top: 5,bottom: 16),
      decoration: BoxDecoration(
        color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: InkWell(
              onTap: () {
                if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == user.uuid) {
                  Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                } else {
                  Navigator.of(context).pushNamed(UserProfileScreen.routeName, arguments: {"id": user.uuid, "name": user.displayName, "photoUrl": user.profilePhoto, "firebaseUid": user.firebaseUid});
                }
              },
              child: user.profilePhoto != null ?
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                  user.profilePhoto,
                ),
              ):
              CircleAvatar(
                backgroundImage: AssetImage(
                  "lib/asset/logo.png",
                ),
              ),
            ),
            title: InkWell(
              onTap: () {
                if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == user.uuid) {
                  Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                } else {
                  Navigator.of(context).pushNamed(UserProfileScreen.routeName, arguments: {"id": user.uuid, "name": user.displayName, "photoUrl": user.profilePhoto, "firebaseUid": user.firebaseUid});
                }
              },
              child: Text(
                user.displayName,
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  color: themeController.isDarkMode?Colors.white:Colors.black,
                ),
              ),
            ),
            trailing: PopupMenuButton<int>(
              padding: EdgeInsets.zero,
              elevation: 0,
              color: themeController.isDarkMode?MateColors.popupDark:MateColors.popupLight,
              icon: Icon(
                Icons.more_vert,
                color: themeController.isDarkMode?Colors.white:MateColors.blackText,
              ),
              onSelected: (index) async{
                if(index==0){

                }else if(index==1){
                  _showDeleteAlertDialog(findAMateId: widget.findAMateId, rowIndex: widget.rowIndex);
                }else if(index==2){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ReportPage(moduleId: widget.findAMateId,moduleType: "findMate",),));
                }
              },
              itemBuilder: (context) => [
                (widget.user.uuid != null && (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == widget.user.uuid)) ?
                PopupMenuItem(
                  value: 1,
                  height: 40,
                  child: Text(
                    "Delete Post",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: themeController.isDarkMode?Colors.white:Colors.black,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                      fontSize: 14,
                    ),
                  ),
                ):
                PopupMenuItem(
                  value: 1,
                  enabled: false,
                  height: 0,
                  child: SizedBox(
                    height: 0,
                    width: 0,
                  ),
                ),
                PopupMenuItem(
                  value: 2,
                  height: 40,
                  child: Text(
                    "Report",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: themeController.isDarkMode?Colors.white:Colors.black,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            subtitle: Text(
              createdAt,
              style: TextStyle(
                fontSize: 14,
                color: themeController.isDarkMode?MateColors.helpingTextDark:Colors.black.withOpacity(0.72),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(
              thickness: 1,
              color: themeController.isDarkMode?MateColors.dividerDark:MateColors.dividerLight,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16,top: 6),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                color: themeController.isDarkMode?Colors.white:Colors.black,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(15, 10, 14, 0),
            child:  Linkify(
              onOpen: (link) async {
                print("Clicked ${link.url}!");
                if (await canLaunch(link.url))
                  await launch(link.url);
                else
                  throw "Could not launch ${link.url}";
              },
              text: description,
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                letterSpacing: 0.1,
                color: themeController.isDarkMode?Colors.white:Colors.black,
              ),
              overflow: TextOverflow.visible,
              linkStyle: TextStyle(
                fontSize: 14,
                fontFamily: 'Poppins',
                color: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
              ),
            ),
          ),
          hyperlinkText!=null && hyperlink!=null ?
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () async{
              if (await canLaunch(hyperlink))
                await launch(hyperlink);
              else
                Fluttertoast.showToast(msg: " Could not launch given URL '${hyperlink}'", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
              throw "Could not launch $hyperlink";
            },
            child: Padding(
              padding: EdgeInsets.only(left: 16,top: 10,right: 10),
              child: Text(
                hyperlinkText,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  color: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                ),
              ),
            ),
          ):SizedBox(),
          Padding(
            padding: EdgeInsets.fromLTRB(15, 10, 14, 0),
            child: Row(
              children: [
                fromDate != null ?
                Text("Available Dates : $fromDate",
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.1,
                    color: themeController.isDarkMode?Colors.white:Colors.black,
                  ),
                  overflow: TextOverflow.visible,
                ):
                SizedBox(),
                toDate != null ?
                Text("  -  $toDate",
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.1,
                    color: themeController.isDarkMode?Colors.white:Colors.black,
                  ),
                  overflow: TextOverflow.visible,
                ):
                SizedBox(),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(15, 10, 14, 0),
            child: Row(
              children: [
                fromTime != null ?
                Text(
                  "Available times : ${fromTimeLocal[0]}:${fromTimeLocal[1]}",
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.1,
                    color: themeController.isDarkMode?Colors.white:Colors.black,
                  ),
                  overflow: TextOverflow.visible,
                ):
                SizedBox(),
                toTime != null ?
                Text("  -  ${toTimeLocal[0]}:${toTimeLocal[1]}",
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.1,
                    color: themeController.isDarkMode?Colors.white:Colors.black,
                  ),
                  overflow: TextOverflow.visible,
                ):
                SizedBox(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16,top: 16),
            child: Row(
              children: [
                Visibility(
                    visible: (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == user.uuid),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 7.0),
                      child: Text(isActive ? "Active" : "Inactive", textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.1,
                          color: themeController.isDarkMode?Colors.white:Colors.black,
                        ),
                      ),
                    ),
                ),
                Visibility(
                  visible: (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == user.uuid),
                  child: Consumer<FindAMateProvider>(
                    builder: (context, value, child) {
                      return FlutterSwitch(
                          width: 48,
                          height: 24,
                          valueFontSize: 25.0,
                          toggleSize: 20.0,
                          activeText: "",
                          inactiveText: "",
                          toggleColor: isActive?Color(0xFF1E1E1E):Color(0xFF8A8A99),
                          inactiveColor: themeController.isDarkMode?Colors.white.withOpacity(0.12):Colors.black.withOpacity(0.1),
                          activeColor: themeController.isDarkMode?Color(0xFF67AE8C):Color(0xFF17F3DE),
                          value: isActive,
                          borderRadius: 14.0,
                          showOnOff: true,
                          onToggle: (val) async {
                            bool updated = await Provider.of<FindAMateProvider>(context, listen: false).activeFindAMatePost(widget.findAMateId, widget.rowIndex, val);
                            if (updated) {
                              if (value.findAMateActiveData != null) {
                                if (value.findAMateActiveData.message == "Post activated successfully" && value.findAMateActiveData.data.id == findAMateId) {
                                  value.findAMatePostsDataList[widget.rowIndex].isActive = true;
                                  isActive = true;
                                } else if (value.findAMateActiveData.message == "Post de-activated successfully" && value.findAMateActiveData.data.id == findAMateId) {
                                  value.findAMatePostsDataList[widget.rowIndex].isActive = false;
                                  isActive = false;
                                }
                              }
                            }
                          },
                        );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _showDeleteAlertDialog({@required int findAMateId, @required int rowIndex,}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: new Text("Are you sure?"),
          content: new Text("You want to delete your Find a Mate Post"),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text("Yes"),
              onPressed: () async {
                bool isDeleted = await findAMateProvider.deleteFindAMatePost(findAMateId, rowIndex);
                if (isDeleted) {
                  Future.delayed(Duration(seconds: 0), () {
                    findAMateProvider.fetchFindAMatePostList(page: 1);
                    Navigator.pop(context);
                  });
                }
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
