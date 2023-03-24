// import 'package:get/get.dart';
// import 'package:mate_app/Screen/Home/Community/campusTalkTrending.dart';
// import 'package:mate_app/Widget/Home/Community/CommunityRow.dart';
// import 'package:flutter/material.dart';
// import 'package:mate_app/asset/Colors/MateColors.dart';
// import 'package:provider/provider.dart';
// import 'package:sizer/sizer.dart';
//
// import '../../../Providers/AuthUserProvider.dart';
// import '../../../Widget/Drawer/DrawerWidget.dart';
// import '../../../controller/theme_controller.dart';
//
// class CommunityScreen extends StatefulWidget {
//   static final String communityScreenRoute = '/community';
//   @override
//   _CommunityScreenState createState() => _CommunityScreenState();
// }
//
// class _CommunityScreenState extends State<CommunityScreen> with TickerProviderStateMixin {
//   bool isCampusLive=true;
//   TabController _tabController;
//   List<Widget> containers = List<Widget>.generate(2, (index) => CommunityRow());
//   void initState() {
//     super.initState();
//     _tabController = new TabController(length: 2, vsync: this);
//   }
//   Widget _appBarLeading(BuildContext context) {
//     return Selector<AuthUserProvider, String>(
//         selector: (ctx, authUserProvider) => authUserProvider.authUserPhoto,
//         builder: (ctx, data, _) {
//           return Padding(
//             padding:  EdgeInsets.only(left: 0.0.sp),
//             child: InkWell(
//                 onTap: () {
//                   Scaffold.of(ctx).openDrawer();
//                 },
//                 child: CircleAvatar(
//                   backgroundColor: Colors.transparent,
//                   radius: 16,
//                   child: CircleAvatar(
//                     radius: 16,
//                     backgroundColor: Colors.transparent,
//                     backgroundImage: NetworkImage(data),
//                     // child: Image.network(
//                     //   data,
//                     // ),
//                   ),
//                 )
//             ),
//           );
//         });
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   ThemeController themeController = Get.find<ThemeController>();
//   final GlobalKey<ScaffoldState> _key = GlobalKey();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _key,
//       drawer: DrawerWidget(),
//       appBar: AppBar(
//         elevation: 0,
//         iconTheme: IconThemeData(
//           color: MateColors.activeIcons,
//         ),
//         leading: _appBarLeading(context),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 20),
//             child: Image.asset(
//               "lib/asset/homePageIcons/searchPurple@3x.png",
//               height: 23.7,
//               width: 23.7,
//               color: MateColors.activeIcons,
//             ),
//           ),
//         ],
//         title: Text(
//           "CampusTalk",
//           style: TextStyle(
//             color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
//             fontWeight: FontWeight.w700,
//             fontSize: 17.0,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: Container(
//         child: Column(
//           children: [
//             // Container(
//             //   child: Row(
//             //     mainAxisAlignment: MainAxisAlignment.start,
//             //     children: [
//             //       Expanded(child: Align(
//             //           alignment: Alignment.centerLeft,
//             //           child: _appBarLeading(context)),),
//             //       Padding(
//             //         padding: const EdgeInsets.only(right: 25.0),
//             //         child: InkWell(onTap: (){
//             //               if(isCampusLive){
//             //
//             //                 Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateCampusLivePost()));
//             //
//             //               }else{          Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateCampusTalkPost()));
//             //               }
//             //         },
//             //             child: Image.asset("lib/asset/homePageIcons/create_post@3x.png",width: 30,fit: BoxFit.fitWidth,)),
//             //       ),
//             //       Padding(
//             //         padding: const EdgeInsets.only(right: 16.0),
//             //         child: InkWell(onTap: ()=>Get.to(() => PersonalChatScreen()),
//             //             child: Image.asset("lib/asset/homePageIcons/messenger@3x.png",width: 30,fit: BoxFit.fitWidth,)),
//             //       ),
//             //     ],
//             //   ),
//             // ),
//             Expanded(
//               child: CampusTalkScreen(),
//
//               // Stack(
//               // children: [
//               //   isCampusLive==true?CampusLive():CampusTalkScreen(),
//               //   Container(
//               //     height: 30.0.sp,
//               //     margin: const EdgeInsets.only(bottom:10.0,left: 40,right: 40,top: 30),
//               //     decoration: BoxDecoration(
//               //       color: Colors.grey.withOpacity(0.4),
//               //         borderRadius: BorderRadius.all(Radius.circular(50.0)),
//               //         border: Border.all( color: Colors.grey.withOpacity(0.4))
//               //     ),
//               //     child: Row(
//               //       children: [
//               //         Expanded(
//               //           child: InkWell(
//               //             onTap: (){
//               //               isCampusLive=true;
//               //               setState(() {
//               //
//               //               });
//               //             },
//               //             child: Container(
//               //               height: 40.0.sp,
//               //               alignment: Alignment.center,
//               //               decoration: isCampusLive==true?BoxDecoration(
//               //                   borderRadius: BorderRadius.all(Radius.circular(50.0)),
//               //                   color: MateColors.activeIcons
//               //               ):BoxDecoration(
//               //                 borderRadius: BorderRadius.all(Radius.circular(50.0)),
//               //                 border: Border(),
//               //               ),
//               //               child: Text('CampusLive',style: isCampusLive==true?ActiveSlidingButtonStyle:deActiveSlidingButtonStyle,),
//               //             ),
//               //           ),
//               //         ),
//               //         Expanded(
//               //           child: InkWell(
//               //             onTap: (){
//               //               isCampusLive=false;
//               //               setState(() {
//               //
//               //               });
//               //             },
//               //             child: Container(
//               //               alignment: Alignment.center,
//               //               height: 40.0.sp,
//               //               decoration: isCampusLive==false?BoxDecoration(
//               //                   borderRadius: BorderRadius.all(Radius.circular(50.0)),
//               //                   color: MateColors.activeIcons
//               //               ):BoxDecoration(
//               //                 borderRadius: BorderRadius.all(Radius.circular(50.0)),
//               //                 border: Border(),
//               //               ),
//               //               child: Text('CampusTalk',style: isCampusLive==false?ActiveSlidingButtonStyle:deActiveSlidingButtonStyle,),
//               //             ),
//               //           ),
//               //         ),
//               //       ],
//               //     ),
//               //   )
//               // ],
//               // ),
//             ),
//
//             /*TabBar(
//               controller: _tabController,
//               unselectedLabelColor: Colors.grey,
//               indicatorColor: MateColors.activeIcons,
//               labelColor: MateColors.activeIcons,
//               labelStyle: TextStyle(fontSize: 16.0),
//               tabs: [
//                 Tab(
//                   text: "CampusLive",
//                   // text: "My Communities",
//                 ),
//                 Tab(
//                   text: "CampusTalk",
//                 ),
//               ],
//             ),
//             Expanded(
//               child: TabBarView(controller: _tabController, children: [CampusLive(),CampusTalkScreen()]),
//             ),*/
//           ],
//         ),
//       ),
//     );
//   }
// }
