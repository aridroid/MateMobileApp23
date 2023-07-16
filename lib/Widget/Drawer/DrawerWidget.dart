import 'package:mate_app/Providers/AuthUserProvider.dart';
import 'package:mate_app/Screen/Login/GoogleLogin.dart';
import 'package:mate_app/Screen/Profile/ProfileScreen.dart';
import 'package:mate_app/Screen/Profile/bookMarkScreen.dart';
import 'package:flutter/material.dart';
import 'package:mate_app/Screen/chatDashboard/callHistory.dart';
import 'package:mate_app/Screen/connection/connection_screen.dart';
import 'package:mate_app/Screen/inviteMates/invites_mates.dart';
import 'package:get/get.dart';
import 'package:mate_app/Screen/notification/notification_screen.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../asset/Colors/MateColors.dart';
import '../../controller/theme_controller.dart';

class DrawerWidget extends StatelessWidget {
  ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    final scH = MediaQuery.of(context).size.height;
    final scW = MediaQuery.of(context).size.width;
    return SizedBox(
      width: scW*0.88,
      child: Drawer(
        child: Container(
          height: scH,
          width: scW,
          decoration: BoxDecoration(
            color: themeController.isDarkMode?Colors.white.withOpacity(0.12):Colors.white.withOpacity(0.82),
            image: DecorationImage(
              image: AssetImage(themeController.isDarkMode?'lib/asset/iconsNewDesign/drawerDarkBackground.png':'lib/asset/iconsNewDesign/drawerLightBackground.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: scH*0.08,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16,right: 16),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                  },
                  child: Row(
                    children: [
                      Selector<AuthUserProvider, String>(
                        selector: (ctx, authUserProvider) =>
                        authUserProvider.authUserPhoto,
                        builder: (ctx, data, _) {
                          return CircleAvatar(
                            radius: 9.7.w,
                            backgroundColor: Colors.white.withOpacity(0.17),
                            child: CircleAvatar(
                              radius: 9.0.w,
                              backgroundImage: NetworkImage(data,),
                            ),
                          );
                        },
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Selector<AuthUserProvider, String>(
                                selector: (ctx, authUserProvider) =>
                                authUserProvider.authUser.displayName!,
                                builder: (ctx, data, _) {
                                  return Text(data, style: TextStyle(
                                      fontSize: 22,
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w500,
                                    overflow: TextOverflow.ellipsis,
                                    color: themeController.isDarkMode?Colors.white:Colors.black
                                  ));
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Text("See Profile",style: TextStyle(
                                fontSize: 14,
                                fontFamily: "Poppins",
                                color: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                              ),),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          ThemeController themeController = Get.put(ThemeController());
                          themeController.toggleDarkMode();
                        },
                        child: Icon(themeController.isDarkMode?Icons.light_mode:Icons.dark_mode,color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,size: 30,),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: scH*0.03,
              ),
              Divider(
                thickness: 1,
                color: themeController.isDarkMode?MateColors.dividerDark:MateColors.dividerLight,
              ),
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.only(top: 0,left: 16,right: 16),
                horizontalTitleGap: 10,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Image.asset(
                    "lib/asset/iconsNewDesign/connection.png",
                    height: 28,
                    width: 28,
                    color: themeController.isDarkMode?Colors.white.withOpacity(0.6):Colors.black,
                  ),
                ),
                title: Text(
                  'My connections',
                  style: TextStyle(
                      color: themeController.isDarkMode?Colors.white:Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Poppins"
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: themeController.isDarkMode?Colors.white.withOpacity(0.6):Colors.black.withOpacity(0.6),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed(ConnectionScreen.routeName);
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Divider(
                  thickness: 1,
                  color: themeController.isDarkMode?MateColors.dividerDark:MateColors.dividerLight,
                ),
              ),
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.only(top: 0,left: 16,right: 16),
                horizontalTitleGap: 10,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Image.asset(
                    "lib/asset/iconsNewDesign/bell.png",
                    height: 25,
                    width: 25,
                    color: themeController.isDarkMode?Colors.white.withOpacity(0.6):Colors.black,
                  ),
                ),
                title: Text(
                  'Notifications',
                  style: TextStyle(
                      color: themeController.isDarkMode?Colors.white:Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Poppins"
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: themeController.isDarkMode?Colors.white.withOpacity(0.6):Colors.black.withOpacity(0.6),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed(NotificationScreen.routeName);
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Divider(
                  thickness: 1,
                  color: themeController.isDarkMode?MateColors.dividerDark:MateColors.dividerLight,
                ),
              ),
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.only(top: 0,left: 16,right: 16),
                horizontalTitleGap: 10,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Image.asset(
                    "lib/asset/iconsNewDesign/bookmark.png",
                    height: 25,
                    width: 25,
                    color: themeController.isDarkMode?Colors.white.withOpacity(0.6):Colors.black,
                  ),
                ),
                title: Text(
                  'Bookmarks',
                  style: TextStyle(
                      color: themeController.isDarkMode?Colors.white:Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Poppins"
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: themeController.isDarkMode?Colors.white.withOpacity(0.6):Colors.black.withOpacity(0.6),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Get.to(()=>BookmarkScreen());
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Divider(
                  thickness: 1,
                  color: themeController.isDarkMode?MateColors.dividerDark:MateColors.dividerLight,
                ),
              ),
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.only(top: 0,left: 16,right: 16),
                horizontalTitleGap: 10,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Image.asset(
                    "lib/asset/iconsNewDesign/inviteMates.png",
                    height: 25,
                    width: 25,
                    color: themeController.isDarkMode?Colors.white.withOpacity(0.6):Colors.black,
                  ),
                ),
                title: Text(
                  'Invite Mates',
                  style: TextStyle(
                      color: themeController.isDarkMode?Colors.white:Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Poppins"
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: themeController.isDarkMode?Colors.white.withOpacity(0.6):Colors.black.withOpacity(0.6),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed(InviteMates.routeName);
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Divider(
                  thickness: 1,
                  color: themeController.isDarkMode?MateColors.dividerDark:MateColors.dividerLight,
                ),
              ),
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.only(top: 0,left: 16,right: 16),
                horizontalTitleGap: 10,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Image.asset(
                    "lib/asset/iconsNewDesign/callLogs.png",
                    height: 25,
                    width: 25,
                    color: themeController.isDarkMode?Colors.white.withOpacity(0.6):Colors.black,
                  ),
                ),
                title: Text(
                  'Call Log',
                  style: TextStyle(
                      color: themeController.isDarkMode?Colors.white:Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Poppins"
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: themeController.isDarkMode?Colors.white.withOpacity(0.6):Colors.black.withOpacity(0.6),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Get.to(()=>CallHistory());
                },
              ),
              // SizedBox(
              //   height: scH*0.05,
              // ),
              Divider(
                thickness: 1,
                color: themeController.isDarkMode?MateColors.dividerDark:MateColors.dividerLight,
              ),
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.only(top: 0,left: 16,right: 16),
                horizontalTitleGap: 10,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Image.asset(
                    "lib/asset/iconsNewDesign/logout.png",
                    height: 25,
                    width: 25,
                    color: themeController.isDarkMode?Colors.white.withOpacity(0.6):Colors.black,
                  ),
                ),
                title: Text(
                  'Log Out',
                  style: TextStyle(
                      color: themeController.isDarkMode?Colors.white:Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Poppins"
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: themeController.isDarkMode?Colors.white.withOpacity(0.6):Colors.black.withOpacity(0.6),
                ),
                onTap: () {
                  Provider.of<AuthUserProvider>(context, listen: false).logout();
                  Navigator.of(context).pushNamedAndRemoveUntil(GoogleLogin.loginScreenRoute, (Route<dynamic> route) => false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}








