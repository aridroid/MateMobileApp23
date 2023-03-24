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
    final scH = MediaQuery.of(context).size.height;
    final scW = MediaQuery.of(context).size.width;
    return Scaffold(
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
                    "Notifications",
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
                padding: EdgeInsets.only(top: 10),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16,right: 16,top: 16),
                    child: Row(
                      children: [
                        Text("New",
                          style: TextStyle(
                            color: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                            fontSize: 12,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 1,
                            margin: EdgeInsets.only(left: 16,right: 16),
                            color: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: 1,
                    itemBuilder: (context,index){
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 16,vertical: 16),
                        padding: EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              horizontalTitleGap: 15,
                              leading: Container(
                                height: 45,
                                width: 45,
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
                                  fontSize: 15,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                  color: themeController.isDarkMode?Colors.white: MateColors.blackTextColor,
                                ),
                              ),
                              subtitle: Text("Yesterday",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: themeController.isDarkMode?MateColors.helpingTextDark:Colors.black.withOpacity(0.72),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10,left: 16),
                              child: Text(
                                "Lorem Ipsum Dolor Sit Amet",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                  color: themeController.isDarkMode?Colors.white:Colors.black,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 16,top: 10,right: 10),
                              child: Text(
                                "Diam diam diam vitae quis. Donec tincidunt cursus tristique gravida quis platea blandit risus in. Vulputate leo sit nisl interdum.",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.1,
                                  color: themeController.isDarkMode?Colors.white:Colors.black,
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
                        Text("Read",
                          style: TextStyle(
                            color: themeController.isDarkMode?Colors.white.withOpacity(0.5):Colors.black.withOpacity(0.5),
                            fontSize: 12,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 1,
                            margin: EdgeInsets.only(left: 16,right: 16),
                            color: themeController.isDarkMode?MateColors.dividerDark:MateColors.dividerLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: 2,
                    itemBuilder: (context,index){
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 16,vertical: 16),
                        padding: EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              horizontalTitleGap: 15,
                              leading: Container(
                                height: 45,
                                width: 45,
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
                                  fontSize: 15,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                  color: themeController.isDarkMode?Colors.white: MateColors.blackTextColor,
                                ),
                              ),
                              subtitle: Text("Yesterday",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: themeController.isDarkMode?MateColors.helpingTextDark:Colors.black.withOpacity(0.72),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10,left: 16),
                              child: Text(
                                "Lorem Ipsum Dolor Sit Amet",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                  color: themeController.isDarkMode?Colors.white:Colors.black,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 16,top: 10,right: 10),
                              child: Text(
                                "Diam diam diam vitae quis. Donec tincidunt cursus tristique gravida quis platea blandit risus in. Vulputate leo sit nisl interdum.",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.1,
                                  color: themeController.isDarkMode?Colors.white:Colors.black,
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
            ),
          ],
        ),
      ),
    );
  }
}
