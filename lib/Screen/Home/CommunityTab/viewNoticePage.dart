import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../asset/Colors/MateColors.dart';
import '../../../controller/theme_controller.dart';
import 'addNoticePage.dart';

class ViewNoticePage extends StatefulWidget {
  final String groupId;
  final String notice;
  const ViewNoticePage({Key? key,required this.groupId,required this.notice}) : super(key: key);

  @override
  _ViewNoticePageState createState() => _ViewNoticePageState();
}

class _ViewNoticePageState extends State<ViewNoticePage> {
  ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(width: 1, color: themeController.isDarkMode?MateColors.darkDivider:MateColors.lightDivider),
          ),),
        width: double.infinity,
        height: 50,
        child: TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context)=>AddNoticePage(groupId: widget.groupId,notice: widget.notice,)));
          },
          child: Text("Update",
            style: TextStyle(
              color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
              fontWeight: FontWeight.w500,
              fontSize: 17.0,
            ),
          ),
        ),
      ),
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        iconTheme: IconThemeData(
          color: MateColors.activeIcons,
        ),
        title: Text("Group Notice",
          style: TextStyle(
            color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
            fontWeight: FontWeight.w700,
            fontSize: 17.0,
          ),
        ),
      ),
      body: ListView(
        physics: ScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 16,vertical: 16),
        children: [
          Linkify(
            onOpen: (link) async {
              if (await canLaunch(link.url)) {
                await launch(link.url);
              } else {
                throw 'Could not launch $link';
              }
            },
            options: LinkifyOptions(humanize: false),
            text: widget.notice,
            style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w500, color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor),
          )
        ],
      ),
    );
  }
}
