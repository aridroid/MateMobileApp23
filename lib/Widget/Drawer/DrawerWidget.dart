// import 'package:mate_app/Providers/AuthUserProvider.dart';
// import 'package:mate_app/Screen/Login/GoogleLogin.dart';
// import 'package:mate_app/Screen/Profile/FollowersScreen.dart';
// import 'package:mate_app/Screen/Profile/FollowingScreen.dart';
// import 'package:mate_app/Screen/Profile/ProfileScreen.dart';
// import 'package:mate_app/Screen/Profile/bookMarkScreen.dart';
// import 'package:flutter/material.dart';
// import 'package:mate_app/Utility/Utility.dart' as config;
// import 'package:get/get.dart';
// import 'package:provider/provider.dart';
// import 'package:share/share.dart';
// import 'package:sizer/sizer.dart';
//
// class DrawerWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: Container(
//         color: config.myHexColor,
//         height: double.infinity,
//         child: Column(
//           children: [
//             SizedBox(
//               height: 80,
//             ),
//             Selector<AuthUserProvider, String>(
//               selector: (ctx, authUserProvider) =>
//                   authUserProvider.authUserPhoto,
//               builder: (ctx, data, _) {
//                 return CircleAvatar(
//                   radius: 16.0.w,
//                   backgroundImage: NetworkImage(
//                     data,
//                   ),
//                 );
//               },
//             ),
//             Padding(
//               padding: const EdgeInsets.all(18.0),
//               child: Selector<AuthUserProvider, String>(
//                 selector: (ctx, authUserProvider) =>
//                     authUserProvider.authUser.displayName,
//                 builder: (ctx, data, _) {
//                   return Text(data, style: config.headerTextStyle());
//                 },
//               ),
//             ),
//             ListTile(
//               leading: Padding(
//                 padding: const EdgeInsets.only(left: 8.0),
//                 child: Icon(
//                   Icons.group_add,
//                   color: Colors.white,
//                   size: 20.0.sp,
//                 ),
//               ),
//               title: Text(
//                 'Following',
//                 style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 12.5.sp,
//                     fontWeight: FontWeight.w700),
//               ),
//               onTap: () {
//                 Navigator.of(context).pushNamed(FollowingScreen.routeName);
//               },
//             ),
//             // Divider(),
//             ListTile(
//               leading: Padding(
//                 padding: const EdgeInsets.only(left: 8.0),
//                 child: Icon(
//                   Icons.remove_red_eye,
//                   color: Colors.white,
//                   size: 20.0.sp,
//                 ),
//               ),
//               title: Text(
//                 'Followers',
//                 style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 12.5.sp,
//                     fontWeight: FontWeight.w700),
//               ),
//               onTap: () {
//                 Navigator.of(context).pushNamed(FollowersScreen.routeName);
//               },
//             ),
//             // Divider(),
//             ListTile(
//                 leading: Padding(
//                   padding: const EdgeInsets.only(left: 8.0),
//                   child: Icon(
//                     Icons.portrait,
//                     color: Colors.white,
//                     size: 20.0.sp,
//                   ),
//                 ),
//                 title: Text(
//                   'Profile',
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 12.5.sp,
//                       fontWeight: FontWeight.w700),
//                 ),
//                 onTap: () {
//                   Navigator.of(context).pop();
//                   Navigator.of(context)
//                       .pushNamed(ProfileScreen.profileScreenRoute);
//                 }),
//             // Divider(),
//             ListTile(
//               leading: Padding(
//                 padding: const EdgeInsets.only(left: 8.0),
//                 child: Icon(
//                   Icons.bookmark,
//                   color: Colors.white,
//                   size: 20.0.sp,
//                 ),
//               ),
//               title: Text(
//                 'Bookmarks',
//                 style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 12.5.sp,
//                     fontWeight: FontWeight.w700),
//               ),
//               onTap: () {
//                 Get.to(()=>BookmarkScreen());
//               },
//             ),
//             // Divider(),
//             ListTile(
//                 leading: Padding(
//                   padding: const EdgeInsets.only(left: 8.0),
//                   child: Icon(
//                     Icons.ios_share,
//                     color: Colors.white,
//                     size: 20.0.sp,
//                   ),
//                 ),
//                 title: Text(
//                   'Invite a Mate',
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 12.5.sp,
//                       fontWeight: FontWeight.w700),
//                 ),
//                 onTap: () {
//                   String IOSLink="https://apps.apple.com/in/app/mate-your-virtual-campus/id1547466147";
//                   Share.share("Follow this link to join MATE Virtual Campus $IOSLink");
//                 }),
//             ListTile(
//                 leading: Padding(
//                   padding: const EdgeInsets.only(left: 8.0),
//                   child: Icon(
//                     Icons.lock_outline,
//                     color: Colors.white,
//                     size: 20.0.sp,
//                   ),
//                 ),
//                 title: Text(
//                   'Log Out',
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 12.5.sp,
//                       fontWeight: FontWeight.w700),
//                 ),
//                 onTap: () {
//                   Provider.of<AuthUserProvider>(context, listen: false)
//                       .logout();
//                   Navigator.of(context).pushNamedAndRemoveUntil(
//                       GoogleLogin.loginScreenRoute,
//                       (Route<dynamic> route) => false);
//                 }),
//             // Divider(),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:mate_app/Providers/AuthUserProvider.dart';
import 'package:mate_app/Screen/JobBoard/jobBoard.dart';
import 'package:mate_app/Screen/Login/GoogleLogin.dart';
import 'package:mate_app/Screen/Profile/ProfileScreen.dart';
import 'package:mate_app/Screen/Profile/bookMarkScreen.dart';
import 'package:flutter/material.dart';
import 'package:mate_app/Screen/connection/connection_screen.dart';
import 'package:mate_app/Screen/inviteMates/invites_mates.dart';
import 'package:mate_app/Screen/notification/notification_screen.dart';
import 'package:mate_app/Utility/Utility.dart' as config;
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../asset/Colors/MateColors.dart';
import '../../controller/theme_controller.dart';

class DrawerWidget extends StatelessWidget {
  ThemeController themeController = Get.find<ThemeController>();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: themeController.isDarkMode?MateColors.blackTextColor:Colors.white,
        height: double.infinity,
        child: Column(
          children: [
            SizedBox(
              height: 80,
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
                          radius: 8.0.w,
                          backgroundImage: NetworkImage(data,),
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
                              authUserProvider.authUser.displayName,
                              builder: (ctx, data, _) {
                                return Text(data, style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w700,
                                  overflow: TextOverflow.ellipsis,
                                  color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor
                                ));
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text("See Profile",style: TextStyle(
                              fontSize: 15,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                              color: MateColors.activeIcons,
                              letterSpacing: 0.1,
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
              height: 30,
            ),
            // Container(
            //   height: 56,
            //   margin: EdgeInsets.symmetric(horizontal: 16),
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(16),
            //     border: Border.all(width: 1,color: themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightDivider),
            //     color: themeController.isDarkMode?MateColors.drawerTileColor:Colors.white,
            //   ),
            //   child: ListTile(
            //     horizontalTitleGap: 10,
            //     leading: Padding(
            //       padding: const EdgeInsets.only(left: 8.0),
            //       child: Image.asset("lib/asset/homePageIcons/drawerJob@3x.png",height: 20,width: 20,color: themeController.isDarkMode?Color(0xFF414147):Color(0xFFB4B4C2),),
            //     ),
            //     title: Text(
            //       'Job Board',
            //       style: TextStyle(
            //           color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
            //           fontSize: 11.5.sp,
            //           fontWeight: FontWeight.w500,
            //         fontFamily: "Poppins"
            //       ),
            //     ),
            //     onTap: () {
            //       Navigator.of(context).pop();
            //       Navigator.of(context).pushNamed(JobBoard.routeName);
            //     },
            //   ),
            // ),
            // SizedBox(
            //   height: 15,
            // ),
            Container(
              height: 56,
              margin: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(width: 1,color: themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightDivider),
                color: themeController.isDarkMode?MateColors.drawerTileColor:Colors.white,
              ),
              child: ListTile(
                horizontalTitleGap: 10,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Image.asset("lib/asset/homePageIcons/drawerConnection@3x.png",height: 20,width: 20,color: themeController.isDarkMode?Color(0xFF414147):Color(0xFFB4B4C2),),
                ),
                title: Text(
                  'Connections',
                  style: TextStyle(
                      color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Poppins"
                  ),
                ),
                onTap: () {
                  //Navigator.of(context).pushNamed(FollowingScreen.routeName);
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed(ConnectionScreen.routeName);
                },
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              height: 56,
              margin: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(width: 1,color: themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightDivider),
                color: themeController.isDarkMode?MateColors.drawerTileColor:Colors.white,
              ),
              child: ListTile(
                horizontalTitleGap: 10,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Image.asset("lib/asset/homePageIcons/drawerBookmark@3x.png",height: 20,width: 20,color: themeController.isDarkMode?Color(0xFF414147):Color(0xFFB4B4C2),),
                ),
                title: Text(
                  'Bookmarks',
                  style: TextStyle(
                      color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Poppins"
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Get.to(()=>BookmarkScreen());
                  //Navigator.of(context).pop();
                  //Navigator.of(context).pushNamed(BookMark.routeName);
                },
              ),
            ),
            // SizedBox(
            //   height: 15,
            // ),
            // Container(
            //   height: 56,
            //   margin: EdgeInsets.symmetric(horizontal: 16),
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(16),
            //     border: Border.all(width: 1,color: themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightDivider),
            //     color: themeController.isDarkMode?MateColors.drawerTileColor:Colors.white,
            //   ),
            //   child: ListTile(
            //     horizontalTitleGap: 10,
            //     leading: Padding(
            //       padding: const EdgeInsets.only(left: 8.0),
            //       child: Image.asset("lib/asset/homePageIcons/drawerNotification@3x.png",height: 20,width: 20,color: themeController.isDarkMode?Color(0xFF414147):Color(0xFFB4B4C2),),
            //     ),
            //     title: Text(
            //       'Notifications',
            //       style: TextStyle(
            //           color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
            //           fontSize: 11.5.sp,
            //           fontWeight: FontWeight.w500,
            //           fontFamily: "Poppins"
            //       ),
            //     ),
            //     onTap: () {
            //       //Get.to(()=>BookmarkScreen());
            //       Navigator.of(context).pop();
            //       Navigator.of(context).pushNamed(NotificationScreen.routeName);
            //     },
            //   ),
            // ),
            SizedBox(
              height: 15,
            ),
            Container(
              height: 56,
              margin: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(width: 1,color: themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightDivider),
                color: themeController.isDarkMode?MateColors.drawerTileColor:Colors.white,
              ),
              child: ListTile(
                horizontalTitleGap: 10,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Image.asset("lib/asset/homePageIcons/drawerProfile@3x.png",height: 20,width: 20,color: themeController.isDarkMode?Color(0xFF414147):Color(0xFFB4B4C2),),
                ),
                title: Text(
                  'Invite Mates',
                  style: TextStyle(
                      color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Poppins"
                  ),
                ),
                onTap: () {
                  // String IOSLink="https://apps.apple.com/in/app/mate-your-virtual-campus/id1547466147";
                  // Share.share("Follow this link to join MATE Virtual Campus $IOSLink");
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed(InviteMates.routeName);
                },
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              height: 56,
              margin: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(width: 1,color: themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightDivider),
                color: themeController.isDarkMode?MateColors.drawerTileColor:Colors.white,
              ),
              child: ListTile(
                horizontalTitleGap: 10,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Image.asset("lib/asset/homePageIcons/drawerLogout@3x.png",height: 20,width: 20,color: themeController.isDarkMode?Color(0xFF414147):Color(0xFFB4B4C2),),
                ),
                title: Text(
                  'Log Out',
                  style: TextStyle(
                      color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Poppins"
                  ),
                ),
                onTap: () {
                  Provider.of<AuthUserProvider>(context, listen: false).logout();
                  Navigator.of(context).pushNamedAndRemoveUntil(GoogleLogin.loginScreenRoute, (Route<dynamic> route) => false);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}








