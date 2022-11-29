// import 'package:mate_app/Providers/UserProvider.dart';
// import 'package:mate_app/Providers/reportProvider.dart';
// import 'package:mate_app/Screen/Home/HomeScreen.dart';
// import 'package:mate_app/Screen/Home/TimeLine/TimeLine.dart';
// import 'package:mate_app/Screen/Profile/CamousLiveByAuthUser.dart';
// import 'package:mate_app/Screen/Profile/communityTalkByUser.dart';
// import 'package:mate_app/Screen/Report/userReportPage.dart';
// import 'package:mate_app/Screen/chat1/screens/chat.dart';
// import 'package:mate_app/Utility/Utility.dart';
// import 'package:mate_app/Widget/Drawer/DrawerWidget.dart';
// import 'package:mate_app/Widget/Loaders/Shimmer.dart';
// import 'package:mate_app/groupChat/pages/customAlertDialog.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:mate_app/asset/Colors/MateColors.dart';
// import 'package:mate_app/Providers/AuthUserProvider.dart';
// import 'package:mate_app/Screen/chat1/personalChatPage.dart';
// import 'package:get/get.dart';
// import 'package:mate_app/Utility/Utility.dart' as config;
// import 'package:mate_app/Screen/Profile/AboutScreen.dart';
// import 'package:sizer/sizer.dart';
//
// class UserProfileScreen extends StatefulWidget {
//   static final String routeName = '/user-profile';
//
//   @override
//   _UserProfileScreenState createState() => _UserProfileScreenState();
// }
//
// class _UserProfileScreenState extends State<UserProfileScreen> with TickerProviderStateMixin  {
//
//   User _currentUser = FirebaseAuth.instance.currentUser;
//   TabController _tabController;
//
//   void initState() {
//     super.initState();
//     _tabController = new TabController(length: 3, vsync: this);
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
//
//     Future.delayed(Duration(seconds: 0), () {
//       Provider.of<UserProvider>(context, listen: false).findUserById(id: routeArgs["id"]);
//     });
//
//     return SafeArea(
//       child: Scaffold(
//           //backgroundColor: myHexColor,
//           // appBar: AppBar(
//           //     backgroundColor: myHexColor,
//           //     leading: _appBarLeading(context),
//           //     centerTitle: true,
//           //     elevation: 0,
//           //     actions: [
//           //       _messageIcon(),
//           //     ],
//           //     bottom: PreferredSize(preferredSize: Size.fromHeight(2), child: _bottomLine())
//           // ),
//          // drawer: DrawerWidget(),
//           body: _tabBarWidget(context, routeArgs)),
//     );
//   }
//
//   Future<void> _showFollowAlertDialog({@required String name, @required String id}) async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false, // user must tap button!
//       builder: (BuildContext context) {
//         return CupertinoAlertDialog(
//           title: new Text("Are you sure?"),
//           content: new Text("You want to follow $name?"),
//           actions: <Widget>[
//             CupertinoDialogAction(
//               isDefaultAction: true,
//               child: Text("Yes"),
//               onPressed: () {
//                 print('following user');
//                 Provider.of<UserProvider>(context, listen: false)
//                     .followUser(followingId: id)
//                     .then((value) => {Navigator.of(context).pop()});
//               },
//             ),
//             CupertinoDialogAction(
//                 child: Text("No"),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 })
//           ],
//         );
//       },
//     );
//   }
//
//   Future<void> _showUnFollowAlertDialog({@required String name, @required String id}) async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false, // user must tap button!
//       builder: (BuildContext context) {
//         return CupertinoAlertDialog(
//           title: new Text("Are you sure?"),
//           content: new Text("You want to unfollow $name?"),
//           actions: <Widget>[
//             CupertinoDialogAction(
//               isDefaultAction: true,
//               child: Text("Yes"),
//               onPressed: () {
//                 Provider.of<UserProvider>(context, listen: false)
//                     .unFollowUser(followingId: id)
//                     .then((value) => Navigator.of(context).pop());
//               },
//             ),
//             CupertinoDialogAction(
//                 child: Text("No"),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 })
//           ],
//         );
//       },
//     );
//   }
//
//   Padding _messageIcon() {
//     return Padding(
//       padding: const EdgeInsets.only(top: 4.0, right: 8.0),
//       child: Stack(
//         children: [
//           IconButton(
//             iconSize: 27,
//             icon: Image.asset("lib/asset/icons/message.png",width: 27,fit: BoxFit.fitWidth,),
//             onPressed: () {
//               Get.to(() => PersonalChatScreen());
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _appBarLeading(BuildContext context) {
//     return Selector<AuthUserProvider, String>(
//         selector: (ctx, authUserProvider) => authUserProvider.authUserPhoto,
//         builder: (ctx, data, _) {
//           return Padding(
//             padding: const EdgeInsets.only(left: 16.0),
//             child: InkWell(
//                 onTap: () {
//                   Scaffold.of(ctx).openDrawer();
//                 },
//                 child: SizedBox(
//                     height: 36,
//                     width: 36,
//                     child: CircleAvatar(
//                         backgroundColor: MateColors.activeIcons,
//                         child: SizedBox(
//                           height: 35,
//                           width: 35,
//                           child: CircleAvatar(
//                             backgroundColor: Colors.transparent,
//                             child: ClipOval(
//                                 child: Image.network(
//                               data,
//                               height: 35,
//                               width: 35,
//                             )),
//                           ),
//                         )))),
//           );
//         });
//   }
//
//   Widget _profileDisplay(BuildContext context) {
//     final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
//
//     return Consumer<UserProvider>(
//         builder: (ctx, provider, _) {
//           return Stack(
//             children: [
//               Container(
//                 height: 185,
//                 width: MediaQuery.of(context).size.width,
//                 decoration: BoxDecoration(
//                   image: DecorationImage(
//                     image: provider.fullUserDetail!=null?(provider.fullUserDetail.coverPhotoUrl!=null && provider.fullUserDetail.coverPhotoUrl!="")?
//                     NetworkImage(provider.fullUserDetail.coverPhotoUrl)
//                         :AssetImage("lib/asset/icons/profile-cover.png"):AssetImage("lib/asset/icons/profile-cover.png"),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 child: null /* add child content here */,
//               ),
//               Center(
//                   child: Column(
//                     children: [
//                       Padding(
//                           padding: const EdgeInsets.only(top: 50.0),
//                           child: InkWell(
//                             onTap: (){
//                               // Future.delayed(Duration.zero, () {
//                               showDialog(
//                                   context: context,
//                                   barrierDismissible: true,
//                                   builder: (context) {
//                                     return CustomDialog(
//                                       backgroundColor: Colors.transparent,
//                                       clipBehavior: Clip.hardEdge,
//                                       insetPadding: EdgeInsets.all(0),
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(00.0),
//                                         child: SizedBox(
//                                           width: MediaQuery.of(context).size.width*0.8,
//                                           height: MediaQuery.of(context).size.height*0.6,
//                                           child: InteractiveViewer(
//                                             panEnabled: true, // Set it to false to prevent panning.
//                                             boundaryMargin: EdgeInsets.all(50),
//                                             minScale: 0.5,
//                                             maxScale: 4,
//                                             child: provider.fullUserDetail!=null?(provider.fullUserDetail.photoUrl!=null && provider.fullUserDetail.photoUrl!="")?
//                                             Image.network(provider.fullUserDetail.photoUrl)
//                                                 :Image.network(routeArgs["photoUrl"]??""):Image.network(routeArgs["photoUrl"]??""),
//                                           ),
//                                         ),
//                                       ),
//                                     );
//                                   });
//                               // });
//                             },
//                             child: CircleAvatar(
//                                 backgroundColor: MateColors.activeIcons,
//                                 radius: 41.4,
//                                 child: CircleAvatar(
//                                   radius: 40,
//                                   backgroundImage: provider.fullUserDetail!=null?(provider.fullUserDetail.photoUrl!=null && provider.fullUserDetail.photoUrl!="")?
//                                   NetworkImage(provider.fullUserDetail.photoUrl)
//                                       :NetworkImage(routeArgs["photoUrl"]??""):NetworkImage(routeArgs["photoUrl"]??""),
//                                 )),
//                           )),
//                       // Row(
//                       //   mainAxisAlignment: MainAxisAlignment.center,
//                       //   children: <Widget>[
//                       //     Expanded(
//                       //         child: Text(
//                       //           provider.fullUserDetail.email,
//                       //           style: TextStyle(fontSize: 12, color: Colors.white),
//                       //           textAlign: TextAlign.center,
//                       //         )),
//                       //   ],
//                       // ),
//                       /*provider.fullUserDetail!=null?
//                       Padding(
//                         padding: const EdgeInsets.only(bottom: 8.0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: <Widget>[
//                             Column(
//                               children: <Widget>[
//                                 Center(
//                                     child: Text(
//                                         provider.fullUserDetail.totalFollowers
//                                             .toString(),
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                             color: Colors.white)
//                                     )
//                                 ),
//                                 Center(
//                                     child: Text(
//                                         provider.fullUserDetail.totalFollowers > 1
//                                             ? 'Followers'
//                                             : 'Follower',
//                                         style: TextStyle(color: Colors.white)
//                                     )
//                                 ),
//                               ],
//                             ),
//                             Column(
//                               children: <Widget>[
//                                 Text(
//                                   provider.fullUserDetail.totalFollowings.toString(),
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white
//                                   ),
//                                 ),
//                                 Text(
//                                     'Following',
//                                     style: TextStyle(color: Colors.white)
//                                 ),
//                               ],
//                             ),
//                             Column(
//                               children: <Widget>[
//                                 Text(
//                                   provider.fullUserDetail.totalFeeds.toString(),
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white
//                                   ),
//                                 ),
//                                 Text(
//                                     'Posts',
//                                     style: TextStyle(color: Colors.white)
//                                 ),
//                               ],
//                             ),
//                             Column(
//                               children: <Widget>[
//
//                                 Text(
//                                   provider.fullUserDetail.totalFeedComments.toString(),
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white
//                                   ),
//                                 ),
//                                 Text(
//                                     'Comments',
//                                     style: TextStyle(color: Colors.white)
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ):SizedBox(),*/
//                     ],
//                   )),
//               _backButton(context, routeArgs),
//               _threeButtons(context, routeArgs),
//             ],
//           );
//
//           // });
//         });
//
//   }
//
//   Widget _threeButtons(BuildContext context, Map<String, dynamic> routeArgs) {
//     return Positioned(
//       right: 5,
//       bottom: 0,
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: <Widget>[
//           Consumer<UserProvider>(
//             builder: (context, userProvider, child) {
//               if(userProvider.fullUserDetail!=null && !userProvider.userDetailLoader){
//                 return IconButton(
//                   padding: EdgeInsets.fromLTRB(8, 8, 0, 8),
//                   iconSize: 22,
//                   icon: !userProvider.fullUserDetail.isFollowing? Image.asset(
//                     "lib/asset/icons/Follow.png",
//                     width: 22,
//                     fit: BoxFit.fitWidth,
//                   ): Icon(Icons.person_remove_alt_1, color: Colors.grey[350],),
//                   onPressed: () {
//                     if(!userProvider.fullUserDetail.isFollowing){
//                       _showFollowAlertDialog(
//                           name: routeArgs['name'], id: routeArgs['id']);
//                     }else{
//                       _showUnFollowAlertDialog(
//                           name: routeArgs['name'], id: routeArgs['id']
//                       );
//                     }
//
//                   },
//                 );
//             }else
//                 return SizedBox();
//           },),
//         IconButton(
//           padding: EdgeInsets.fromLTRB(0, 8, 8, 8),
//           iconSize: 20,
//            icon: Image.asset(
//               "lib/asset/icons/message_white.png",
//               width: 20,
//               fit: BoxFit.fitWidth,
//             ),
//             onPressed: () {
//               if(routeArgs['firebaseUid']!=null){
//                 Get.to(() =>
//                     Chat(
//                       peerUuid: routeArgs['id'],
//                       currentUserId: _currentUser.uid,
//                       peerId: routeArgs['firebaseUid'],
//                       peerName: routeArgs['name'],
//                       peerAvatar: routeArgs['photoUrl'],
//                     ));
//               }else
//                 Get.to(() => PersonalChatScreen());
//
//             },
//           ),
//           IconButton(
//             padding: EdgeInsets.fromLTRB(0, 8, 8, 8),
//             iconSize: 20,
//             icon:Icon(Icons.block, color: Colors.white70) ,
//             onPressed: () {
//               Map<String, dynamic> body = {
//                 "user_uuid": routeArgs['id']
//               };
//
//               _showDeleteAlertDialog(body: body, name: routeArgs["name"].toString().trim());
//               // Navigator.push(context, MaterialPageRoute(builder: (context) => UserReportPage(uuid: routeArgs['id'],),));
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   _showDeleteAlertDialog({
//     @required Map<String, dynamic> body, String name
//   }) async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false, // user must tap button!
//       builder: (BuildContext context) {
//         return CupertinoAlertDialog(
//           title: new Text("Are you sure that you want to block $name"),
//           content: new Text("\n"+name + "  will no longer be able to : \n\n"
//               "See your Feeds, CampusLive, CampusTalk, BeAMate, FindAMate posts\n"
//               "See your profile\n"
//               "Start a conversation with you"),
//           actions: <Widget>[
//             CupertinoDialogAction(
//               isDefaultAction: true,
//               child: Consumer<ReportProvider>(
//                 builder: (ctx, reportProvider, _) {
//                   if (reportProvider.userBlockLoader) {
//                     return Center(
//                       child: CircularProgressIndicator(
//                         color: Colors.white,
//                       ),
//                     );
//                   }
//                   return Text("Block");
//                 },
//               ),
//
//               onPressed: () async {
//                 print(body);
//                 bool reportDone = await Provider.of<ReportProvider>(context, listen: false).blockUser(body);
//                 if (reportDone) {
//                   // Navigator.pop(context);
//                   // Navigator.pop(context);
//                   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeScreen(),), (route) => false);
//                 }
//               },
//             ),
//             CupertinoDialogAction(
//                 child: Text("No"),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 })
//           ],
//         );
//       },
//     );
//   }
//
//   Widget _backButton(BuildContext context, Map<String, dynamic> routeArgs) {
//     return Positioned(
//       left: 5,
//       top: 0,
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: <Widget>[
//           IconButton(
//             icon: Icon(Icons.arrow_back_ios),
//             iconSize: 22,
//             color: MateColors.activeIcons,
//             tooltip: 'Back to Home',
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           ),
//           Text(
//             routeArgs["name"].toString().trim(),
//             textAlign: TextAlign.left,
//             style: TextStyle(
//               color: MateColors.activeIcons,
//               fontSize: 15.0.sp,
//               fontFamily: "Rubik",
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Container _bottomLine() {
//     return Container(
//       color: themeController.isDarkMode?MateColors.darkDivider:MateColors.lightDivider,
//       height: 2.0,
//     );
//   }
//
//   Widget _tabBarWidget(BuildContext context, Map<String, dynamic> routeArgs) {
//     return NestedScrollView(
//       headerSliverBuilder: (context, value) {
//         return [
//           SliverToBoxAdapter(
//             child: Column(
//               mainAxisSize: MainAxisSize.max,
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: <Widget>[
//                 _profileDisplay(context),
//                 _bottomLine(),
//               ],
//             ),
//           ),
//           SliverToBoxAdapter(
//             child: TabBar(
//               controller: _tabController,
//               isScrollable: true,
//               unselectedLabelColor: MateColors.line,
//               indicatorColor: Colors.transparent,
//               labelColor: MateColors.activeIcons,
//               labelPadding: EdgeInsets.only(left: 40,right: 30),
//               labelStyle: TextStyle(
//                 color: MateColors.activeIcons,
//                 fontSize: 11.7.sp,
//                 fontFamily: "Rubik",
//                 fontWeight: FontWeight.w700,
//               ),
//               tabs: [
//                 Tab(
//                   text: "About",
//                 ),
//                 Tab(
//                   text: "Posts",
//                 ),
//                 // Tab(
//                 //   text: "CampusLive",
//                 // ),
//                 Tab(
//                   text: "CampusTalk",
//                 ),
//
//
//               ],
//             ),
//           ),
//         ];
//       },
//       body: Container(
//         decoration: BoxDecoration(border: Border(top: BorderSide(color: themeController.isDarkMode?MateColors.darkDivider:MateColors.lightDivider,width: 2))),
//         child: TabBarView(
//           controller: _tabController,
//           children: [
//             AboutScreen(uuid: routeArgs['id'],userName: routeArgs["name"],),
//             TimeLine(userId: routeArgs['id'],),
//             //CampusLiveByAuthUser(uuid: routeArgs['id'],),
//             CampusTalkByUser(uuid: routeArgs['id'],),
//           ],
//         ),
//       ),
//     );
//   }
//
//
//
//
// }



import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mate_app/constant.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Providers/AuthUserProvider.dart';
import '../../Providers/FeedProvider.dart';
import '../../Providers/UserProvider.dart';
import '../../Providers/reportProvider.dart';
import '../../Services/connection_service.dart';
import '../../Widget/Home/HomeRow.dart';
import '../../asset/Colors/MateColors.dart';
import '../../audioAndVideoCalling/connectingScreen.dart';
import '../../controller/theme_controller.dart';
import '../../groupChat/pages/customAlertDialog.dart';
import '../Home/HomeScreen.dart';
import '../chat1/personalChatPage.dart';
import '../chat1/screens/chat.dart';
import 'bio_details_page.dart';

class UserProfileScreen extends StatefulWidget {
  static final String routeName = '/user-profile';
  const UserProfileScreen({Key key}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  ThemeController themeController = Get.find<ThemeController>();
  ScrollController _scrollController;
  int _page;
  User _currentUser = FirebaseAuth.instance.currentUser;
  UserProvider userProvider;
  ReportProvider reportProvider;

  String token;

  getStoredValue()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token");
    log(token);
  }

  @override
  void initState() {
    getStoredValue();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    reportProvider = Provider.of<ReportProvider>(context, listen: false);
    Future.delayed(Duration(milliseconds: 600), (){
      final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      Provider.of<FeedProvider>(context, listen: false).fetchFeedList(page: 1,userId: routeArgs['id']);
    });
    _page = 1;
    _scrollController = new ScrollController()..addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
  }

  void _scrollListener() {
    final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels != 0) {
        Future.delayed(Duration.zero,(){
          _page += 1;
          print('scrolled to bottom page is now $_page');
          Provider.of<FeedProvider>(context, listen: false).fetchFeedList(page: _page, paginationCheck: true, userId: routeArgs['id']);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    Future.delayed(Duration(seconds: 0), () {
      Provider.of<UserProvider>(context, listen: false).findUserById(id: routeArgs["id"]);
      Provider.of<AuthUserProvider>(context, listen: false).getUserInfo(routeArgs["id"]);
    });
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              height: 360,
              decoration: BoxDecoration(
                color: themeController.isDarkMode?MateColors.drawerTileColor:Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Consumer<UserProvider>(builder: (ctx, provider, _) {
                return Stack(
                  children: [
                    Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: provider.fullUserDetail!=null?(provider.fullUserDetail.coverPhotoUrl!=null && provider.fullUserDetail.coverPhotoUrl!="")?
                          NetworkImage(provider.fullUserDetail.coverPhotoUrl)
                              :AssetImage("lib/asset/icons/profile-cover-new.png"):AssetImage("lib/asset/icons/profile-cover-new.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: InkWell(
                          onTap: (){
                            // Future.delayed(Duration.zero, () {
                            showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (context) {
                                  return CustomDialog(
                                    backgroundColor: Colors.transparent,
                                    clipBehavior: Clip.hardEdge,
                                    insetPadding: EdgeInsets.all(0),
                                    child: Padding(
                                      padding: const EdgeInsets.all(00.0),
                                      child: SizedBox(
                                        width: MediaQuery.of(context).size.width*0.8,
                                        height: MediaQuery.of(context).size.height*0.6,
                                        child: InteractiveViewer(
                                          panEnabled: true, // Set it to false to prevent panning.
                                          boundaryMargin: EdgeInsets.all(50),
                                          minScale: 0.5,
                                          maxScale: 4,
                                          child: provider.fullUserDetail!=null?(provider.fullUserDetail.photoUrl!=null && provider.fullUserDetail.photoUrl!="")?
                                          Image.network(provider.fullUserDetail.photoUrl)
                                              :Image.network(routeArgs["photoUrl"]??""):Image.network(routeArgs["photoUrl"]??""),
                                        ),
                                      ),
                                    ),
                                  );
                                });
                            // });
                          },
                          child: CircleAvatar(
                            backgroundColor: themeController.isDarkMode?MateColors.blackTextColor:Colors.white,
                            radius: 50,
                            child: CircleAvatar(
                              radius: 46,
                              backgroundImage: provider.fullUserDetail!=null?(provider.fullUserDetail.photoUrl!=null && provider.fullUserDetail.photoUrl!="")?
                              NetworkImage(provider.fullUserDetail.photoUrl) :NetworkImage(routeArgs["photoUrl"]??""):NetworkImage(routeArgs["photoUrl"]??""),
                              ),
                            ),
                        ),
                        ),
                      ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 170),
                        child: Text(routeArgs['name'],
                          style: TextStyle(
                            color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 17.0,
                          ),
                        ),
                      ),
                    ),
                    Consumer<AuthUserProvider>(
                      builder: (context, userProvider, _){
                        if(!userProvider.userAboutDataLoader && userProvider.userAboutData != null){
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 240,left: 25,right: 25),
                              child: InkWell(
                                onTap: (){
                                  Get.to(BioDetailsPage(bio: userProvider.userAboutData.data.about??"",));
                                },
                                child: Text(
                                  userProvider.userAboutData.data.about??"",
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 0.1,
                                    color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }else{
                          return Container();
                        }
                      },
                    ),
                    Positioned(
                      left: 16,
                      top: 20,
                      child: InkWell(
                        onTap: (){
                          Get.back();
                        },
                        child: Icon(Icons.arrow_back,
                          size: 23,
                          color: themeController.isDarkMode?Colors.black:Colors.white,
                        ),
                      ),
                    ),
                    _threeButtons(context, routeArgs),
                  ],
                );
              }),
            ),
            Container(
              height: 1,
              width: MediaQuery.of(context).size.width,
              color: themeController.isDarkMode?MateColors.darkDivider:Colors.white,
            ),
            Expanded(
              child: Consumer<FeedProvider>(
                builder: (ctx, feedProvider, _){
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    controller: _scrollController,
                    shrinkWrap: true,
                    padding: EdgeInsets.only(top: 10),
                    physics: ScrollPhysics(),
                    itemCount: feedProvider.feedItemListOfUser.length,//feedProvider.feedList.length,
                    itemBuilder: (context,index){
                      var feedItem = feedProvider.feedItemListOfUser[index];//feedProvider.feedList[index];
                      return Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: HomeRow(
                          previousPageUserId: routeArgs['id'],
                          id: feedItem.id,
                          feedId: feedItem.feedId,
                          title: feedItem.title,
                          feedType: feedItem.feedTypes,
                          start: feedItem.start,
                          end: feedItem.end,
                          calenderDate: feedItem.feedCreatedAt,
                          description: feedItem.description,
                          created: feedItem.created,
                          user: feedItem.user,
                          location: feedItem.location,
                          hyperlinkText: feedItem.hyperlinkText,
                          hyperlink: feedItem.hyperlink,
                          media: feedItem.media,
                          isLiked: feedItem.isLiked,
                          liked: feedItem.isLiked!=null?true:false,
                          bookMarked: feedItem.isBookmarked,
                          isFollowed: feedItem.isFollowed??false,
                          likeCount: feedItem.likeCount,
                          bookmarkCount: feedItem.bookmarkCount,
                          shareCount: feedItem.shareCount,
                          commentCount: feedItem.commentCount,
                          isShared: feedItem.isShared,
                          indexVal: index,
                          pageType: "User",
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _threeButtons(BuildContext context, Map<String, dynamic> routeArgs) {
    return Positioned(
      right: MediaQuery.of(context).size.width/5.5,
      bottom: -3,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          IconButton(
            onPressed: (){
              Get.to(()=>ConnectingScreen(
                callType: "Audio Calling",
                receiverImage: routeArgs["photoUrl"]??"",
                receiverName: routeArgs['name'],
                uid: [routeArgs['firebaseUid']],
                isGroupCalling: false,
              ));
            },
            icon: Icon(Icons.call,color: themeController.isDarkMode?MateColors.iconDark:MateColors.iconLight,),
          ),
          IconButton(
            onPressed: (){
              Get.to(()=>ConnectingScreen(
                callType: "Video Calling",
                receiverImage: routeArgs["photoUrl"]??"",
                receiverName: routeArgs['name'],
                uid: [routeArgs['firebaseUid']],
                isGroupCalling: false,
              ));
            },
            icon: Icon(Icons.video_call_rounded,color: themeController.isDarkMode?MateColors.iconDark:MateColors.iconLight,),
          ),



          IconButton(
            padding: EdgeInsets.fromLTRB(8, 8, 0, 8),
            iconSize: 22,
            onPressed: (){
              _showAddConnectionAlertDialog(uid: routeArgs['firebaseUid'], name: routeArgs['name'],uuid: routeArgs['id']);
            },
            icon: !connectionGlobalUidList.contains(routeArgs['firebaseUid'])?
            Image.asset(
              "lib/asset/icons/addPerson.png",
              width: 15,
              fit: BoxFit.fitWidth,
              color: themeController.isDarkMode?MateColors.iconDark:MateColors.iconLight,
            ):
            Icon(Icons.person_remove_alt_1, color: themeController.isDarkMode?MateColors.iconDark:MateColors.iconLight,),
          ),


          // Consumer<UserProvider>(
          //   builder: (context, userProvider, child) {
          //     if(userProvider.fullUserDetail!=null && !userProvider.userDetailLoader){
          //       return IconButton(
          //         padding: EdgeInsets.fromLTRB(8, 8, 0, 8),
          //         iconSize: 22,
          //         icon: !userProvider.fullUserDetail.isFollowing? Image.asset(
          //           "lib/asset/icons/Follow.png",
          //           width: 22,
          //           fit: BoxFit.fitWidth,
          //           color: themeController.isDarkMode?MateColors.iconDark:MateColors.iconLight,
          //         ): Icon(Icons.person_remove_alt_1, color: themeController.isDarkMode?MateColors.iconDark:MateColors.iconLight,),
          //         onPressed: () {
          //           if(!userProvider.fullUserDetail.isFollowing){
          //             _showFollowAlertDialog(name: routeArgs['name'], id: routeArgs['id']);
          //           }else{
          //             _showUnFollowAlertDialog(name: routeArgs['name'], id: routeArgs['id']
          //             );
          //           }
          //
          //         },
          //       );
          //   }else
          //       return SizedBox();
          // },),
        IconButton(
          padding: EdgeInsets.fromLTRB(0, 8, 8, 8),
          iconSize: 20,
           icon: Image.asset(
              //"lib/asset/icons/message_white.png",
             "lib/asset/homePageIcons/chat.png",
              width: 18,
              fit: BoxFit.fitWidth,
             color: themeController.isDarkMode?MateColors.iconDark:MateColors.iconLight,
            ),
            onPressed: () {
              if(routeArgs['firebaseUid']!=null){
                Get.to(() =>
                    Chat(
                      peerUuid: routeArgs['id'],
                      currentUserId: _currentUser.uid,
                      peerId: routeArgs['firebaseUid'],
                      peerName: routeArgs['name'],
                      peerAvatar: routeArgs['photoUrl'],
                    ));
              }else
                Get.to(() => PersonalChatScreen());

            },
          ),
          IconButton(
            padding: EdgeInsets.fromLTRB(0, 8, 8, 8),
            iconSize: 20,
            icon:Icon(Icons.block, color: themeController.isDarkMode?MateColors.iconDark:MateColors.iconLight,) ,
            onPressed: () {
              Map<String, dynamic> body = {
                "user_uuid": routeArgs['id']
              };
              _showDeleteAlertDialog(body: body, name: routeArgs["name"].toString().trim());
              // Navigator.push(context, MaterialPageRoute(builder: (context) => UserReportPage(uuid: routeArgs['id'],),));
            },
          ),
        ],
      ),
    );
  }


  _showDeleteAlertDialog({@required Map<String, dynamic> body, String name})async{
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: new Text("Are you sure that you want to block $name"),
          content: new Text("\n"+name + "  will no longer be able to : \n\n"
              "See your Feeds, CampusLive, CampusTalk, BeAMate, FindAMate posts\n"
              "See your profile\n"
              "Start a conversation with you"),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text("Block"),
              // Consumer<ReportProvider>(
              //   builder: (ctx, reportProvider, _) {
              //     if (reportProvider.userBlockLoader) {
              //       return Center(
              //         child: CircularProgressIndicator(
              //           color: Colors.white,
              //         ),
              //       );
              //     }
              //     return Text("Block");
              //   },
              // ),
              onPressed: () async {
                print(body);
                bool reportDone = await reportProvider.blockUser(body);
                if (reportDone) {
                  // Navigator.pop(context);
                  // Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeScreen(),), (route) => false);
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

  Future<void> _showFollowAlertDialog({@required String name, @required String id}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: new Text("Are you sure?"),
          content: new Text("You want to follow $name?"),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text("Yes"),
              onPressed: () {
                print('following user');
                userProvider.followUser(followingId: id).then((value) => {Navigator.of(context).pop()});
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


  _showAddConnectionAlertDialog({@required String uid, @required String name,@required String uuid})async{
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: new Text("Are you sure?"),
          content: new Text(
              !connectionGlobalUidList.contains(uid)?
              "You want to add ${name} to your connection":"You want to remove ${name} from your connection"
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text("Yes"),
              onPressed: ()async{
                String res = await ConnectionService().addConnection(uid: uid,name: name,uuid:uuid,token: token);
                //Connection saved successfully
                //Connection already exists
                Navigator.of(context).pop();
                await getConnection();
                setState(() {});
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


  Future<void> _showUnFollowAlertDialog({@required String name, @required String id}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: new Text("Are you sure?"),
          content: new Text("You want to unfollow $name?"),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text("Yes"),
              onPressed: () {
                userProvider.unFollowUser(followingId: id).then((value) => Navigator.of(context).pop());
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
