import 'package:mate_app/Screen/Profile/feedsBookmark.dart';
import 'package:mate_app/Widget/Loaders/Shimmer.dart';
import 'package:mate_app/asset/Colors/MateColors.dart';
import 'package:flutter/material.dart';
import 'campusTalkBookmark.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({Key key}) : super(key: key);
  @override
  _BookmarkScreenState createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> with TickerProviderStateMixin{
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: MateColors.activeIcons,
        ),
        title: Text(
          "Bookmarks",
          style: TextStyle(
            color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
            fontWeight: FontWeight.w700,
            fontSize: 17.0,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(AppBar().preferredSize.height-10),
          child: DecoratedBox(
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
              tabs: [
                Tab(
                  text: "Posts",
                ),
                // Tab(
                //   text: "CampusLive",
                // ),
                Tab(
                  text: "CampusTalk",
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          FeedsBookmark(),
          // CampusLiveBookmark(),
          CampusTalkBookmark(),
        ],
      ),
    );
  }
}
