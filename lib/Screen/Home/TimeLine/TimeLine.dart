import 'dart:async';
import 'package:get/get.dart';
import 'package:mate_app/Providers/AuthUserProvider.dart';
import 'package:mate_app/Providers/FeedProvider.dart';
import 'package:mate_app/Screen/Home/TimeLine/createFeedSelectType.dart';
import 'package:mate_app/Screen/Home/TimeLine/globalFeed.dart';
import 'package:mate_app/Screen/Home/studentOffer/studentOffer.dart';
import 'package:mate_app/Screen/JobBoard/jobBoard.dart';
import 'package:mate_app/Screen/Login/GoogleLogin.dart';
import 'package:mate_app/Widget/Loaders/Shimmer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mate_app/controller/theme_controller.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../Widget/Drawer/DrawerWidget.dart';
import '../../../Widget/Home/HomeRow.dart';
import '../../../asset/Colors/MateColors.dart';
import '../Mate/MateScreen.dart';

class TimeLine extends StatefulWidget {
  static final String timeLineScreenRoute = '/timeline';
  String id;
  String searchKeyword;
  bool isFollowingFeeds;
  String userId;
  TimeLine({this.searchKeyword, this.id, this.isFollowingFeeds, this.userId});

  @override
  _TimeLineState createState() => _TimeLineState();
}

class _TimeLineState extends State<TimeLine> with TickerProviderStateMixin{
  ScrollController _scrollController;
  int _pageMyCampus;
  ThemeController themeController = Get.find<ThemeController>();
  int universityId = 0;
  int _selectedIndex = 0;
  int segmentedControlValue = 0;
  bool isGlobalFeed=false;
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    print(Provider.of<AuthUserProvider>(context, listen: false).authUser.universityId);
    universityId = Provider.of<AuthUserProvider>(context, listen: false).authUser.universityId??0;
    Future.delayed(Duration(milliseconds: 600), (){
      if (widget.id == null) {
        Provider.of<FeedProvider>(context, listen: false).fetchFeedListMyCampus(page: 1, feedId: widget.id);
      }else {
        Provider.of<FeedProvider>(context, listen: false).fetchFeedList(page: 1, feedId: widget.id);
      }
    });
    _pageMyCampus =1;
    _scrollController = new ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels != 0) {
        Future.delayed(Duration.zero,(){
          _pageMyCampus += 1;
          print('scrolled to bottom page is now $_pageMyCampus');
          Provider.of<FeedProvider>(context, listen: false).fetchFeedListMyCampus(page: _pageMyCampus, feedId: widget.id, paginationCheck: true, isFollowingFeeds: widget.isFollowingFeeds, userId: widget.userId );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scH = MediaQuery.of(context).size.height;
    final scW = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _key,
      endDrawer: DrawerWidget(),
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
            SizedBox(
              height: scH*0.06,
            ),
            Container(
              margin: EdgeInsets.only(right: 16,top: 5,left: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_sharp,
                        size: 25,
                        color: themeController.isDarkMode?Colors.white:Colors.black,
                      ),
                      SizedBox(width: 5,),
                      SizedBox(
                        width: MediaQuery.of(context).size.width*0.4,
                        child: Selector<AuthUserProvider, String>(
                          selector: (ctx, authUserProvider) =>
                          authUserProvider.authUser.university,
                          builder: (ctx, data, _) {
                            return Text(data,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                color: themeController.isDarkMode?Colors.white.withOpacity(0.7):Colors.black.withOpacity(0.7),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Get.to(CreateFeedSelectType());
                        },
                        child: Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                          ),
                          child: Icon(Icons.add,color: MateColors.blackTextColor,size: 28),
                        ),
                      ),
                      Selector<AuthUserProvider, String>(
                          selector: (ctx, authUserProvider) => authUserProvider.authUserPhoto,
                          builder: (ctx, data, _) {
                            return Padding(
                              padding:  EdgeInsets.only(left: 12.0.sp),
                              child: InkWell(
                                  onTap: () {
                                    _key.currentState.openEndDrawer();
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: MateColors.activeIcons,
                                    radius: 20,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      radius: 20,
                                      backgroundImage: NetworkImage(data),
                                    ),
                                  )
                              ),
                            );
                          }),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16,top: 12),
              child: Row(
                children: [
                  Selector<AuthUserProvider, String>(
                    selector: (ctx, authUserProvider) =>
                    authUserProvider.authUser.displayName,
                    builder: (ctx, data, _) {
                      return Text(
                          "Hello $data! ☺️",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                          fontSize: 28,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600,
                          overflow: TextOverflow.ellipsis,
                          color: themeController.isDarkMode?Colors.white:Colors.black,
                      ));
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16,right: 16,top: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Selector<AuthUserProvider, String>(
                    selector: (ctx, authUserProvider) => authUserProvider.authUserPhoto,
                    builder: (ctx, data, _) {
                      return Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(data),
                          ),
                        ),
                      );
                    },
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 16),
                      height: 60,
                      width: MediaQuery.of(context).size.width*0.7,
                      decoration: BoxDecoration(
                        color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.only(left: 16,right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Share what you want",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              color: themeController.isDarkMode?MateColors.helpingTextDark:Colors.black.withOpacity(0.72),
                            ),
                          ),
                          SizedBox(),
                          Container(
                            height: 36,
                            width: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: themeController.isDarkMode?MateColors.bottomSheetItemBackgroundDark:MateColors.containerLight,
                            ),
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                "lib/asset/iconsNewDesign/gallery.png",
                                color: themeController.isDarkMode?Colors.white:MateColors.blackText,
                              ),
                            ),
                          ),
                          Container(
                            height: 36,
                            width: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: themeController.isDarkMode?MateColors.bottomSheetItemBackgroundDark:MateColors.containerLight,
                            ),
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                "lib/asset/iconsNewDesign/mic.png",
                                color: themeController.isDarkMode?Colors.white:MateColors.blackText,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16,right: 16,top: 20,bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(()=>GlobalFeed());
                    },
                    child: Container(
                      height: 92,
                      width: MediaQuery.of(context).size.width*0.21,
                      decoration: BoxDecoration(
                        color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.only(top: 12,bottom: 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: themeController.isDarkMode?MateColors.textFieldSearchDark:Color(0xFF049571),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Image.asset('lib/asset/iconsNewDesign/global.png'),
                            ),
                          ),
                          Text('Global Feed',
                            style: TextStyle(
                              fontSize: 11,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                              overflow: TextOverflow.ellipsis,
                              color: themeController.isDarkMode?Colors.white:Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(()=>MateScreen());
                    },
                    child: Container(
                      height: 92,
                      width: MediaQuery.of(context).size.width*0.21,
                      decoration: BoxDecoration(
                        color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.only(top: 12,bottom: 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: themeController.isDarkMode?MateColors.textFieldSearchDark:Color(0xFF64ADF0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Image.asset('lib/asset/iconsNewDesign/jobBoard.png'),
                            ),
                          ),
                          Text('Job Board',
                            style: TextStyle(
                              fontSize: 11,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                              overflow: TextOverflow.ellipsis,
                              color: themeController.isDarkMode?Colors.white:Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {

                    },
                    child: Container(
                      height: 92,
                      width: MediaQuery.of(context).size.width*0.21,
                      decoration: BoxDecoration(
                        color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.only(top: 12,bottom: 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: themeController.isDarkMode?MateColors.textFieldSearchDark:Color(0xFFFFA6A6),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Image.asset('lib/asset/iconsNewDesign/marketPlace.png',color: Colors.white,),
                            ),
                          ),
                          Text('Marketplace',
                            style: TextStyle(
                              fontSize: 11,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                              overflow: TextOverflow.ellipsis,
                              color: themeController.isDarkMode?Colors.white:Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(()=>StudentOffer());
                    },
                    child: Container(
                      height: 92,
                      width: MediaQuery.of(context).size.width*0.21,
                      decoration: BoxDecoration(
                        color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.only(top: 12,bottom: 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: themeController.isDarkMode?MateColors.textFieldSearchDark:Color(0xFFCB89FF),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Image.asset('lib/asset/iconsNewDesign/studentOffer.png'),
                            ),
                          ),
                          Text('Student Offers',
                            style: TextStyle(
                              fontSize: 11,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                              overflow: TextOverflow.ellipsis,
                              color: themeController.isDarkMode?Colors.white:Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Consumer<FeedProvider>(
                builder: (ctx, feedProvider, _) {
                  if (feedProvider.feedLoader && feedProvider.feedListMyCampus.length == 0) {
                    return timelineLoader();
                  }
                  if (feedProvider.error != '') {
                    if(feedProvider.error.contains("Your session has expired")){
                      Future.delayed(Duration.zero,(){
                        Provider.of<AuthUserProvider>(context, listen: false).logout();
                        feedProvider.error='';
                        Navigator.of(context).pushNamedAndRemoveUntil(GoogleLogin.loginScreenRoute, (Route<dynamic> route) => false);
                      });
                      Fluttertoast.showToast(msg: " ${feedProvider.error} ", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
                    }
                    return Center(
                      child: Container(
                        color: Colors.red,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${feedProvider.error}',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  }
                  return feedProvider.feedListMyCampus.length == 0 ?
                  Center(
                    child: Text(
                      'Nothing new',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                        letterSpacing: 0.1,
                        color: themeController.isDarkMode?Colors.white:Colors.black,
                      ),
                    ),
                  ):
                  RefreshIndicator(
                    onRefresh: () {
                      if (widget.id == null) {
                        _pageMyCampus=1;
                        return feedProvider.fetchFeedListMyCampus(page: 1, feedId: widget.id);
                      }else{
                        _pageMyCampus=1;
                        return feedProvider.fetchFeedList(page: 1, isFollowingFeeds: widget.isFollowingFeeds, userId: widget.userId);
                      }
                    },
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: widget.userId!=null?feedProvider.feedItemListOfUser.length:feedProvider.feedListMyCampus.length,
                      itemBuilder: (_, index) {
                        var feedItem = widget.userId!=null?feedProvider.feedItemListOfUser[index]:feedProvider.feedListMyCampus[index];
                        return Visibility(
                          visible: widget.searchKeyword!=null? widget.searchKeyword!=""? feedItem.title.toLowerCase().contains(widget.searchKeyword.toLowerCase()):false : true,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: HomeRow(
                              previousPageUserId:widget.userId,
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
                              pageType : "TimeLineMyCampus",
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}