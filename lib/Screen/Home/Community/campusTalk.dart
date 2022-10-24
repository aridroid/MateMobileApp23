import 'package:get/get.dart';
import 'package:mate_app/Model/campusTalkPostsModel.dart';
import 'package:mate_app/Providers/campusTalkProvider.dart';
import 'package:mate_app/Screen/Home/Community/createCampusTalkPost.dart';
import 'package:mate_app/Widget/Home/Community/campusTalkRow.dart';
import 'package:mate_app/Widget/Loaders/Shimmer.dart';
import 'package:mate_app/asset/Colors/MateColors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../Providers/AuthUserProvider.dart';
import '../../../Widget/Drawer/DrawerWidget.dart';
import '../../../controller/theme_controller.dart';

class CampusTalkScreen extends StatefulWidget {
  const CampusTalkScreen({Key key}) : super(key: key);

  @override
  _CampusTalkScreenState createState() => _CampusTalkScreenState();
}

class _CampusTalkScreenState extends State<CampusTalkScreen> with TickerProviderStateMixin {
  TabController _tabController;
  String searchText="";
  ThemeController themeController = Get.find<ThemeController>();
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 2, vsync: this);
  }

  Widget _appBarLeading(BuildContext context) {
    return Selector<AuthUserProvider, String>(
      selector: (ctx, authUserProvider) => authUserProvider.authUserPhoto,
      builder: (ctx, data, _) {
        return InkWell(
          onTap: () {
            _key.currentState.openDrawer();
          },
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 16,
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 16,
              backgroundImage: NetworkImage(data),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        elevation: 0,
        leading: _appBarLeading(context),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: InkWell(
              onTap: ()async{
              },
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
          "Campus Talk",
          style: TextStyle(
            color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
            fontWeight: FontWeight.w700,
            fontSize: 17.0,
          ),
        ),
        centerTitle: true,
      ),
      drawer: DrawerWidget(),
      body: Column(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.0),
              border: Border(bottom: BorderSide(color: Color(0xFF65656B).withOpacity(0.2), width: 0.8)),
            ),
            child: TabBar(
              onTap: (value){
                print(value);
              },
              controller: _tabController,
              unselectedLabelColor: Color(0xFF656568),
              indicatorColor: MateColors.activeIcons,
              indicatorPadding: EdgeInsets.symmetric(horizontal: 20),
              labelColor: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
              labelStyle: TextStyle(fontSize: 15.0,fontFamily: "Poppins",fontWeight: FontWeight.w500),
              tabs: [
                Tab(
                  text: "Trending",
                ),
                Tab(
                  text: "Latest",
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                CampusTalk(searchText: searchText,),
                CampusTalk(searchText: searchText,),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: InkWell(
        onTap: () {
          Get.to(CreateCampusTalkPost());
        },
        child: Container(
          height: 56,
          width: 56,
          margin: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: MateColors.activeIcons,
          ),
          child: Icon(Icons.add,color: themeController.isDarkMode?Colors.black:Colors.white,size: 28),
        ),
      ),
    );
  }
}

class CampusTalk extends StatefulWidget {

  final String searchText;

  const CampusTalk({Key key, this.searchText}) : super(key: key);

  @override
  _CampusTalkState createState() => _CampusTalkState();
}

class _CampusTalkState extends State<CampusTalk> {
  ScrollController _scrollController;
  int _page;

  void _scrollListener() {
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels != 0) {
        Future.delayed(Duration.zero, () {
          _page += 1;
          print('scrolled to bottom page is now $_page');
          Provider.of<CampusTalkProvider>(context, listen: false).fetchCampusTalkPostList(page: _page,paginationCheck: true);
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 0), () {
      Provider.of<CampusTalkProvider>(context, listen: false).fetchCampusTalkPostList(page: 1);
    });
    _page = 1;
    _scrollController = new ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CampusTalkProvider>(
      builder: (ctx, campusTalkProvider, _) {
        print("timline consumer is called");

        if (campusTalkProvider.talkPostLoader && campusTalkProvider.campusTalkPostsResultsList.length == 0) {
          return timelineLoader();
        }
        if (campusTalkProvider.error != '') {
          return Center(
              child: Container(
                  color: Colors.red,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${campusTalkProvider.error}',
                      style: TextStyle(color: Colors.white),
                    ),
                  )));
        }

        return campusTalkProvider.campusTalkPostsResultsList.length == 0
            ? Center(
                child: Text(
                  'Nothing new',
                  style: TextStyle(color: themeController.isDarkMode?Colors.white:Colors.black),
                ),
              )
            : RefreshIndicator(
                onRefresh: () {
                  _page = 1;
                  return campusTalkProvider.fetchCampusTalkPostList(page: 1);
                },
                child: ListView.builder(
                  controller: _scrollController,
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: campusTalkProvider.campusTalkPostsResultsList.length,
                  itemBuilder: (context, index) {
                    Result campusTalkData = campusTalkProvider.campusTalkPostsResultsList[index];
                    return Visibility(
                      visible: widget.searchText.isNotEmpty? campusTalkData.title.toLowerCase().contains(widget.searchText.trim().toLowerCase()): true,
                      child: CampusTalkRow(
                        talkId: campusTalkData.id,
                        description: campusTalkData.description,
                        title: campusTalkData.title,
                        user: campusTalkData.user,
                        isAnonymous: campusTalkData.isAnonymous,
                        anonymousUser: campusTalkData.anonymousUser,
                        url: campusTalkData.url,
                        createdAt: "${DateFormat.yMMMEd().format(DateFormat("yyyy-MM-dd").parse(campusTalkData.createdAt, true))}",
                        rowIndex: index,
                        isBookmarked: campusTalkData.isBookmarked,
                        isLiked: campusTalkData.isLiked,
                        likesCount: campusTalkData.likesCount,
                        commentsCount: campusTalkData.commentsCount,
                      ),
                    );
                  },
                ),
              );
      },
    );
  }
}
