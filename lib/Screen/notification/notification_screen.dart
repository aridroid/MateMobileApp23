import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../asset/Colors/MateColors.dart';
import '../../controller/theme_controller.dart';

class NotificationScreen extends StatefulWidget {
  static final String routeName = '/notificationScreen';

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  ThemeController themeController = Get.find<ThemeController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: MateColors.activeIcons,
        ),
        title: Text(
          "Notifications",
          style: TextStyle(
            color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
            fontWeight: FontWeight.w700,
            fontSize: 17.0,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16,right: 16,top: 16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 1,
                    margin: EdgeInsets.only(right: 16),
                    color: MateColors.activeIcons,
                  ),
                ),
                Text("New",
                  style: TextStyle(
                    color: MateColors.activeIcons,
                    fontSize: 12,
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 1,
                    margin: EdgeInsets.only(left: 16),
                    color: MateColors.activeIcons,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: 1,
            itemBuilder: (context,index){
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 16,vertical: 16),
                padding: EdgeInsets.only(bottom: 16),
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
                      horizontalTitleGap: 5,
                      dense: true,
                      leading: Container(
                        height: 32,
                        width: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: MateColors.activeIcons,
                        ),
                        child: Center(
                          child: Image.asset("lib/asset/icons/crossIcon.png",height: 13,),
                        ),
                      ),
                      title: Text("Mate App",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.1,
                          color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                        ),
                      ),
                      subtitle: Text("Yesterday",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10,left: 16),
                      child: Text(
                        "Lorem Ipsum Dolor Sit Amet",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16,top: 10,right: 10),
                      child: Text(
                        "Diam diam diam vitae quis. Donec tincidunt cursus tristique gravida quis platea blandit risus in. Vulputate leo sit nisl interdum.",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.1,
                          color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16,right: 16,top: 16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 1,
                    margin: EdgeInsets.only(right: 16),
                    color: themeController.isDarkMode?MateColors.darkDivider:MateColors.lightDivider,
                  ),
                ),
                Text("Read",
                  style: TextStyle(
                    color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
                    fontSize: 12,
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 1,
                    margin: EdgeInsets.only(left: 16),
                    color: themeController.isDarkMode?MateColors.darkDivider:MateColors.lightDivider,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: 2,
            itemBuilder: (context,index){
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 16,vertical: 16),
                padding: EdgeInsets.only(bottom: 16),
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
                      horizontalTitleGap: 5,
                      dense: true,
                      leading: Container(
                        height: 32,
                        width: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: MateColors.activeIcons,
                        ),
                        child: Center(
                          child: Image.asset("lib/asset/icons/crossIcon.png",height: 13,),
                        ),
                      ),
                      title: Text("Mate App",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.1,
                          color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                        ),
                      ),
                      subtitle: Text("Yesterday",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10,left: 16),
                      child: Text(
                        "Lorem Ipsum Dolor Sit Amet",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16,top: 10,right: 10),
                      child: Text(
                        "Diam diam diam vitae quis. Donec tincidunt cursus tristique gravida quis platea blandit risus in. Vulputate leo sit nisl interdum.",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.1,
                          color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
