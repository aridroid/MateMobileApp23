import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mate_app/Screen/Home/Mate/findAMate.dart';
import 'package:mate_app/asset/Colors/MateColors.dart';
import 'package:mate_app/controller/theme_controller.dart';
import 'package:provider/provider.dart';

import '../../Providers/FeedProvider.dart';
import '../Home/Mate/beAMate.dart';
import '../Home/Mate/createBeAMatePost.dart';
import '../Home/Mate/createFindAMatePost.dart';
import '../Home/Mate/searchBeAMate.dart';
import '../Home/Mate/searchFindAMate.dart';

class JobBoard extends StatefulWidget {
  static final String routeName = '/jobBoard';
  @override
  _JobBoardState createState() => _JobBoardState();
}

class _JobBoardState extends State<JobBoard> with TickerProviderStateMixin{
  ThemeController themeController = Get.find<ThemeController>();
  TabController _tabController;
  void initState() {
    super.initState();
    _tabController = new TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: MateColors.activeIcons,
        ),
        actions: [
          InkWell(
            onTap: (){
              if(_tabController.index==0){
                Get.to(SearchFindAMate());
              }else{
                Get.to(SearchBeAMate());
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 20,left: 20),
              child: Image.asset(
                "lib/asset/homePageIcons/searchPurple@3x.png",
                height: 23.7,
                width: 23.7,
                color: MateColors.activeIcons,
              ),
            ),
          ),
        ],
        title: Text(
          "Job Board",
          style: TextStyle(
            color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
            fontWeight: FontWeight.w700,
            fontSize: 17.0,
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: InkWell(
        onTap: () {
          if(_tabController.index==0){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateFindAMatePost()));
          }else{
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateBeAMatePost()));
          }
        },
        child: Container(
          height: 56,
          width: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: MateColors.activeIcons,
          ),
          child: Icon(Icons.add,color: themeController.isDarkMode?Colors.black:Colors.white,size: 28),
        ),
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.0),
              border: Border(bottom: BorderSide(color: Color(0xFF65656B).withOpacity(0.2), width: 0.8)),
            ),
            child: TabBar(
              controller: _tabController,
              unselectedLabelColor: Color(0xFF656568),
              indicatorColor: MateColors.activeIcons,
              indicatorPadding: EdgeInsets.symmetric(horizontal: 20),
              labelColor: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
              labelStyle: TextStyle(fontSize: 15.0,fontFamily: "Poppins",fontWeight: FontWeight.w500),
              onTap: (value){
                value == 0?
                Provider.of<FeedProvider>(context, listen: false).isFindAMate = true:
                Provider.of<FeedProvider>(context, listen: false).isFindAMate = false;
              },
              tabs: [
                Tab(
                  text: "Find a Mate",
                ),
                Tab(
                  text: "Be a Mate",
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(controller: _tabController, children: [FindAMateScreen(), BeAMateScreen()]),
          ),
        ],
      ),
      // ListView(
      //   scrollDirection: Axis.vertical,
      //   shrinkWrap: true,
      //   physics: ScrollPhysics(),
      //   children: [
      //     ListView.builder(
      //       scrollDirection: Axis.vertical,
      //       shrinkWrap: true,
      //       physics: ScrollPhysics(),
      //       itemCount: 3,
      //       itemBuilder: (context,index){
      //         return Container(
      //           height: 336,
      //           margin: EdgeInsets.symmetric(horizontal: 16,vertical: 10),
      //           decoration: BoxDecoration(
      //             color: themeController.isDarkMode?MateColors.drawerTileColor:Colors.white,
      //             borderRadius: BorderRadius.circular(16),
      //             boxShadow: [
      //               BoxShadow(
      //                 color: Colors.black.withOpacity(0.05),
      //                 spreadRadius: 5,
      //                 blurRadius: 7,
      //                 offset: Offset(0, 3),
      //               ),
      //             ],
      //           ),
      //           child: Column(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               ListTile(
      //                 leading: CircleAvatar(
      //                   radius: 16,
      //                   backgroundColor: MateColors.activeIcons,
      //                   backgroundImage: NetworkImage("https://thumbs.dreamstime.com/z/purple-flower-2212075.jpg"),
      //                 ),
      //                 title: Text(
      //                   "Mary Kirkbride",
      //                   style: TextStyle(
      //                     fontSize: 14,
      //                     fontWeight: FontWeight.w500,
      //                     letterSpacing: 0.1,
      //                     color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
      //                   ),
      //                 ),
      //                 subtitle: Text(
      //                   "2 weeks ago",
      //                   style: TextStyle(
      //                     fontSize: 12,
      //                     color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
      //                   ),
      //                 ),
      //                 trailing: Padding(
      //                   padding: const EdgeInsets.only(right: 10),
      //                   child: Image.asset(
      //                     "lib/asset/icons/menu@3x.png",
      //                      height: 18,
      //                   ),
      //                 ),
      //               ),
      //               Container(
      //                 margin: EdgeInsets.only(left: 16,top: 6),
      //                 height: 28.0,
      //                 width: 92.0,
      //                 decoration: BoxDecoration(
      //                   borderRadius: BorderRadius.circular(16),
      //                   color: themeController.isDarkMode?MateColors.darkDivider:MateColors.lightDivider,
      //                 ),
      //                 child: Center(
      //                   child: Text("Be a Mate",style: TextStyle(fontFamily: "Poppins",fontSize: 12,color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor),),
      //                 ),
      //               ),
      //               Padding(
      //                 padding: EdgeInsets.only(left: 16,top: 10),
      //                 child: Text(
      //                   "Lorem Ipsum Dolor Sit Amet",
      //                   style: TextStyle(
      //                     fontSize: 17,
      //                     fontWeight: FontWeight.w700,
      //                     color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
      //                   ),
      //                 ),
      //               ),
      //               Padding(
      //                 padding: EdgeInsets.only(left: 16,top: 10,right: 10),
      //                 child: Text(
      //                   "Diam diam diam vitae quis. Donec tincidunt cursus tristique gravida quis platea blandit risus in. Vulputate leo sit nisl interdum.",
      //                   style: TextStyle(
      //                     fontSize: 14,
      //                     fontWeight: FontWeight.w400,
      //                     letterSpacing: 0.1,
      //                     color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
      //                   ),
      //                 ),
      //               ),
      //               Padding(
      //                 padding: EdgeInsets.only(left: 16,top: 10,right: 10),
      //                 child: Text(
      //                   "Portfolio Link",
      //                   style: TextStyle(
      //                     fontSize: 14,
      //                     fontWeight: FontWeight.w500,
      //                     letterSpacing: 0.1,
      //                     color: MateColors.activeIcons,
      //                   ),
      //                 ),
      //               ),
      //               Padding(
      //                 padding: const EdgeInsets.only(left: 16,right: 16,top: 25),
      //                 child: Row(
      //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                   children: [
      //                     Row(
      //                       children: [
      //                         Container(
      //                           height: 32,
      //                           width: 64,
      //                           decoration: BoxDecoration(
      //                             borderRadius: BorderRadius.circular(16),
      //                             border: Border.all(color: themeController.isDarkMode?MateColors.darkDivider:MateColors.lightDivider,width: 1)
      //                           ),
      //                           child: Row(
      //                             mainAxisAlignment: MainAxisAlignment.center,
      //                             children: [
      //                               Image.asset("lib/asset/icons/clap@3x.png",height: 20,width: 13,),
      //                               SizedBox(width: 5,),
      //                               Text("2",
      //                                 style: TextStyle(
      //                                   fontWeight: FontWeight.w500,
      //                                   fontSize: 13,
      //                                   color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
      //                                 ),
      //                               ),
      //                             ],
      //                           ),
      //                         ),
      //                         SizedBox(width: 10,),
      //                         Container(
      //                           height: 32,
      //                           width: 64,
      //                           decoration: BoxDecoration(
      //                               borderRadius: BorderRadius.circular(16),
      //                               border: Border.all(color: themeController.isDarkMode?MateColors.darkDivider:MateColors.lightDivider,width: 1)
      //                           ),
      //                           child: Row(
      //                             mainAxisAlignment: MainAxisAlignment.center,
      //                             children: [
      //                               Image.asset("lib/asset/icons/heart.png",height: 20,width: 13,),
      //                               SizedBox(width: 5,),
      //                               Text("2",
      //                                 style: TextStyle(
      //                                   fontWeight: FontWeight.w500,
      //                                   fontSize: 13,
      //                                   color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
      //                                 ),
      //                               ),
      //                             ],
      //                           ),
      //                         ),
      //                       ],
      //                     ),
      //                     Row(
      //                       children: [
      //                         Image.asset("lib/asset/icons/message@3x.png",height: 20,color: themeController.isDarkMode?MateColors.iconDark:MateColors.iconLight,),
      //                         SizedBox(width: 20,),
      //                         Image.asset("lib/asset/homePageIcons/drawerBookmark@3x.png",height: 20,color: themeController.isDarkMode?MateColors.iconDark:MateColors.iconLight,),
      //                       ],
      //                     ),
      //                   ],
      //                 ),
      //               ),
      //             ],
      //           ),
      //         );
      //       },
      //     ),
      //   ],
      // ),
    );
  }
}



