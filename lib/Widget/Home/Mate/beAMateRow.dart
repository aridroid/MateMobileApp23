import 'package:fluttertoast/fluttertoast.dart';
import 'package:mate_app/Model/beAMatePostsModel.dart';
import 'package:mate_app/Providers/AuthUserProvider.dart';
import 'package:mate_app/Providers/beAMateProvider.dart';
import 'package:mate_app/Screen/Profile/ProfileScreen.dart';
import 'package:mate_app/Screen/Profile/UserProfileScreen.dart';
import 'package:mate_app/Screen/Report/reportPage.dart';
import 'package:mate_app/Utility/Utility.dart';
import 'package:mate_app/asset/Colors/MateColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sizer/sizer.dart';

import '../../Loaders/Shimmer.dart';

class BeAMateRow extends StatefulWidget {
  final User user;
  final int beAMateId;
  final String title;
  final String description;
  final String portfolioLink;
  final String fromDate;
  final String toDate;
  final String fromTime;
  final String toTime;
  final String hyperlinkText;
  final String hyperlink;
  final String createdAt;
  final int rowIndex;
  final bool isActive;

  const BeAMateRow(
      {Key key, this.user, this.beAMateId, this.title, this.description, this.portfolioLink, this.fromDate, this.toDate, this.fromTime, this.toTime, this.createdAt, this.rowIndex, this.isActive, this.hyperlinkText, this.hyperlink})
      : super(key: key);

  @override
  _BeAMateRowState createState() => _BeAMateRowState(
      this.user, this.beAMateId, this.title, this.description, this.portfolioLink, this.fromDate, this.toDate, this.fromTime, this.toTime, this.createdAt, this.rowIndex, this.isActive, this.hyperlinkText, this.hyperlink);
}

class _BeAMateRowState extends State<BeAMateRow> {
  final User user;
  final int beAMateId;
  final String title;
  final String description;
  final String portfolioLink;
  final String fromDate;
  final String toDate;
  final String fromTime;
  final String toTime;
  final String hyperlinkText;
  final String hyperlink;
  final String createdAt;
  final int rowIndex;
  bool isActive;

  _BeAMateRowState(this.user, this.beAMateId, this.title, this.description, this.portfolioLink, this.fromDate, this.toDate, this.fromTime, this.toTime, this.createdAt, this.rowIndex, this.isActive, this.hyperlinkText, this.hyperlink);


  BeAMateProvider beAMateProvider;
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
    beAMateProvider = Provider.of<BeAMateProvider>(context,listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
      padding: EdgeInsets.only(top: 5,bottom: 16),
      decoration: BoxDecoration(
        color: themeController.isDarkMode?MateColors.drawerTileColor:Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
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
              child: user.profilePhoto != null
                  ? ClipOval(
                      child: Image.network(
                        user.profilePhoto,
                        height: 32,
                        width: 32,
                        fit: BoxFit.cover,
                      ),
                    )
                  : ClipOval(
                      child: Image.asset(
                        "lib/asset/logo.png",
                        height: 32,
                        width: 32,
                        fit: BoxFit.fitWidth,
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
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.1,
                  color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                ),
              ),
            ),
            trailing: PopupMenuButton<int>(
              padding: EdgeInsets.only(bottom: 0, top: 0, left: 0, right: 0),
              color: themeController.isDarkMode?backgroundColor:Colors.white,
              icon: Image.asset(
                "lib/asset/icons/menu@3x.png",
                height: 18,
                color: themeController.isDarkMode?MateColors.iconDark:MateColors.iconLight,
              ),
              onSelected: (index) async{
                if(index==0){

                }else if(index==1){
                  _showDeleteAlertDialog(beAMateId: widget.beAMateId, rowIndex: widget.rowIndex);
                }else if(index==2){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ReportPage(moduleId: widget.beAMateId,moduleType: "beMate",),));
                }
              },
              itemBuilder: (context) => [
                (widget.user.uuid != null && (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == widget.user.uuid))
                    ? PopupMenuItem(
                  value: 1,
                  height: 40,
                  child: Text(
                    "Delete Post",
                    textAlign: TextAlign.start,
                    style: TextStyle(color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor, fontWeight: FontWeight.w500, fontSize: 12.6.sp),
                  ),
                )
                    : PopupMenuItem(
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
                    style: TextStyle(color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor, fontWeight: FontWeight.w500, fontSize: 12.6.sp),
                  ),
                ),
              ],
            ),
            subtitle: Text(
              createdAt,
              style: TextStyle(
                fontSize: 12,
                color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
              ),
            ),
          ),
          // Container(
          //   height: 28.0,
          //   width: 90,
          //   margin: EdgeInsets.only(left: 16,top: 10,bottom: 16),
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(16),
          //     color: themeController.isDarkMode?MateColors.darkDivider:MateColors.lightDivider,
          //   ),
          //   child: Padding(
          //     padding: const EdgeInsets.only(left: 15,right: 15),
          //     child: Center(child: Text("Be a Mate",style: TextStyle(fontFamily: "Poppins",fontSize: 12,color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor),)),
          //   ),
          // ),
          Padding(
            padding: EdgeInsets.only(left: 16,top: 0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(15, 10, 14, 0),
            child: Text(
              description,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.1,
                color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
              ),
              overflow: TextOverflow.visible,
            ),
          ),
          portfolioLink != null ?
          Padding(
            padding: EdgeInsets.fromLTRB(15, 10, 14, 0),
            child: InkWell(
              onTap: ()async{
                if (await canLaunch(portfolioLink)) {
                  await launch(portfolioLink);
                } else {
                  throw 'Could not launch $portfolioLink';
                }
              },
              child: Text("Portfolio Link",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.1,
                  color: MateColors.activeIcons,
                ),
              ),
            ),
          ):
          // Padding(
          //         padding: EdgeInsets.fromLTRB(15, 10, 14, 0),
          //         child: Linkify(
          //           onOpen: (link) async {
          //             print("Clicked ${link.url}!");
          //             if (await canLaunch(portfolioLink))
          //               await launch(portfolioLink);
          //             else
          //               // can't launch url, there is some error
          //               throw "Could not launch ${portfolioLink}";
          //           },
          //           text: "Portfolio Link",
          //           style: TextStyle(
          //             fontSize: 14,
          //             fontWeight: FontWeight.w500,
          //             letterSpacing: 0.1,
          //             color: MateColors.activeIcons,
          //             //color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
          //           ),
          //           overflow: TextOverflow.visible,
          //           linkStyle: TextStyle(color: MateColors.activeIcons, fontSize: 11.0.sp),
          //         ),
          //       )
          SizedBox(),

          hyperlinkText!=null && hyperlink!=null ?
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () async{
              if (await canLaunch(hyperlink))
                await launch(hyperlink);
              else
                Fluttertoast.showToast(msg: " Could not launch given URL '${hyperlink}'", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
              throw "Could not launch ${hyperlink}";
            },
            child: Padding(
              padding: EdgeInsets.only(left: 16,top: 10,right: 10),
              child: Text(
                hyperlinkText,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.1,
                  color: MateColors.activeIcons,
                ),
              ),
            ),
          ):SizedBox(),

          fromDate != null
              ? Padding(
                  padding: EdgeInsets.fromLTRB(15, 10, 14, 0),
                  child: Row(
                    children: [
                      Text(
                        "Available Dates : $fromDate",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.1,
                          color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                        ),
                        overflow: TextOverflow.visible,
                      ),
                      toDate != null
                          ? Text(
                              "  -  $toDate",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.1,
                          color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                        ),
                              overflow: TextOverflow.visible,
                            )
                          : SizedBox(),
                    ],
                  ),
                )
              : SizedBox(),
          fromTime != null
              ? Padding(
                  padding: EdgeInsets.fromLTRB(15, 10, 14, 0),
                  child: Row(
                    children: [
                      Text(
                        "Available times : ${fromTimeLocal[0]}:${fromTimeLocal[1]}",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.1,
                          color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                        ),
                        overflow: TextOverflow.visible,
                      ),
                      toTime != null
                          ? Text(
                              "  -  ${toTimeLocal[0]}:${toTimeLocal[1]}",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.1,
                          color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                        ),
                              overflow: TextOverflow.visible,
                            )
                          : SizedBox(),
                    ],
                  ),
                )
              : SizedBox(),
          Padding(
            padding: const EdgeInsets.only(left: 16,top: 16),
            child: Row(
              children: [
                //Expanded(child: Text(title, textAlign: TextAlign.left, style: TextStyle(fontFamily: 'Quicksand', color: MateColors.activeIcons, fontSize: 12.0.sp, fontWeight: FontWeight.w600))),
                Visibility(
                    visible: (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == user.uuid),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 7.0),
                      child: Text(isActive ? "Active" : "Inactive", textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
                        ),
                      ),
                    )),
                Visibility(
                  visible: (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == user.uuid),
                  child: Consumer<BeAMateProvider>(
                    builder: (context, value, child) {
                      return /*!(value.beAMatePostsDataList[widget.rowIndex].toggleLoader)?*/
                        FlutterSwitch(
                          width: 48,
                          height: 24,
                          valueFontSize: 25.0,
                          toggleSize: 20.0,
                          activeText: "",
                          inactiveText: "",
                          toggleColor: themeController.isDarkMode?Color(0xFF0B0B0D):Colors.white,
                          inactiveColor: themeController.isDarkMode?Color(0xFF414147):Color(0xFFB4B4C2),
                          activeColor: MateColors.activeIcons,
                          value: isActive,
                          borderRadius: 14.0,
                          showOnOff: true,
                          onToggle: (val) async {
                            bool updated = await Provider.of<BeAMateProvider>(context, listen: false).activeBeAMatePost(widget.beAMateId, widget.rowIndex, val);
                            if (updated) {
                              if (value.beAMateActiveData != null) {
                                // IsBookmarked
                                if (value.beAMateActiveData.message == "Post activated successfully" && value.beAMateActiveData.data.id == beAMateId) {
                                  value.beAMatePostsDataList[widget.rowIndex].isActive = true;
                                  isActive = true;
                                } else if (value.beAMateActiveData.message == "Post de-activated successfully" && value.beAMateActiveData.data.id == beAMateId) {
                                  value.beAMatePostsDataList[widget.rowIndex].isActive = false;
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
          // Padding(
          //   padding: EdgeInsets.fromLTRB(15, 10, 14, 0),
          //   child: Text(
          //     "Posted: $createdAt",
          //     style: TextStyle(fontFamily: 'Quicksand', color: Colors.white70, fontSize: 9.2.sp),
          //     overflow: TextOverflow.visible,
          //   ),
          // ),
          // Divider(
          //   thickness: 1.5,
          //   color: MateColors.line,
          // ),
        ],
      ),
    );
  }

  _showDeleteAlertDialog({@required int beAMateId, @required int rowIndex,}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: new Text("Are you sure?"),
          content: new Text("You want to delete your Be a Mate Post"),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text("Yes"),
              onPressed: () async{
                bool isDeleted=await beAMateProvider.deleteBeAMatePost(beAMateId, rowIndex);

                if (isDeleted) {
                  Future.delayed(Duration(seconds: 0), () {
                    beAMateProvider.fetchBeAMatePostList(page: 1);
                    Navigator.pop(context);
                  });
                }
              },
            ),
            CupertinoDialogAction(
                child: Text("No"),
                onPressed: () {
                  Navigator.of(context).pop();
                })
          ],
        );
      },
    );
  }

}
