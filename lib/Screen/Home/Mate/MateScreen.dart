import 'package:mate_app/asset/Colors/MateColors.dart';
import 'package:mate_app/Screen/Home/Mate/beAMate.dart';
import 'package:mate_app/Screen/Home/Mate/findAMate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Providers/FeedProvider.dart';
import '../../../Widget/Loaders/Shimmer.dart';

class MateScreen extends StatefulWidget {
  static var mateScreenRoute = '/mateScreen';
  @override
  _MateScreenState createState() => _MateScreenState();
}

class _MateScreenState extends State<MateScreen> with TickerProviderStateMixin {
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
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 10,bottom: 10,left: 10,right: 10),
          decoration: BoxDecoration(
            color: themeController.isDarkMode?MateColors.darkDivider:MateColors.lightDivider,
            borderRadius: BorderRadius.circular(
              25.0,
            ),
          ),
          child: TabBar(
             controller: _tabController,
            // unselectedLabelColor: Colors.grey,
            // indicatorColor: MateColors.activeIcons,
            // labelColor: MateColors.activeIcons,
            // labelStyle: TextStyle(fontSize: 16.0),
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(
                25.0,
              ),
              color: themeController.isDarkMode?MateColors.lightDivider:MateColors.darkDivider,
             //color: themeController.isDarkMode?_tabController.index==0?Colors.white:MateColors.darkDivider:_tabController.index==1?MateColors.blackTextColor:MateColors.lightDivider,
            ),
            labelColor: themeController.isDarkMode?Colors.black:Colors.white,
            labelStyle: TextStyle(fontSize: 15.0,fontFamily: "Poppins",
                fontWeight: FontWeight.w500,
              color: themeController.isDarkMode?Colors.black:Colors.white,
            ),
            unselectedLabelColor: themeController.isDarkMode?Colors.white:Colors.black,
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
    );
  }
}
