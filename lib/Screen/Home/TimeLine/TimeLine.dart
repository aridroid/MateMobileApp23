// import 'dart:async';
//
// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:mate_app/Providers/AuthUserProvider.dart';
// import 'package:mate_app/Providers/FeedProvider.dart';
// import 'package:mate_app/Screen/Home/TimeLine/StorySection.dart';
// import 'package:mate_app/Screen/Home/TimeLine/postAStory.dart';
// import 'package:mate_app/Screen/Login/GoogleLogin.dart';
// import 'package:mate_app/Widget/Loaders/Shimmer.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:provider/provider.dart';
// import 'package:sizer/sizer.dart';
// import '../../../Utility/Utility.dart';
// import '../../../Widget/Home/HomeRow.dart';
// import '../../../asset/Colors/MateColors.dart';
// import '../../../textStyles.dart';
// import '../../chat1/personalChatPage.dart';
// import 'CreateFeedPost.dart';
//
//
// // ignore: must_be_immutable
// class TimeLine extends StatefulWidget {
//   static final String timeLineScreenRoute = '/timeline';
//
//   String id;
//   String searchKeyword;
//   bool isFollowingFeeds;
//   String userId;
//
//
//   TimeLine({this.searchKeyword, this.id, this.isFollowingFeeds, this.userId});
//
//   @override
//   _TimeLineState createState() => _TimeLineState();
// }
//
// class _TimeLineState extends State<TimeLine> {
//   ScrollController _scrollController;
//   int _page;
//
//   void _scrollListener() {
//
//     if (_scrollController.position.atEdge) {
//       if (_scrollController.position.pixels != 0) {
//         Future.delayed(Duration.zero,(){
//           _page += 1;
//           print('scrolled to bottom page is now $_page');
//           Provider.of<FeedProvider>(context, listen: false).fetchFeedList(page: _page, feedId: widget.id, paginationCheck: true, isFollowingFeeds: widget.isFollowingFeeds, userId: widget.userId );
//         });
//       }
//     }
//
//   }
//   Widget _appBarLeading(BuildContext context) {
//     return Selector<AuthUserProvider, String>(
//         selector: (ctx, authUserProvider) => authUserProvider.authUserPhoto,
//         builder: (ctx, data, _) {
//           return Padding(
//             padding:  EdgeInsets.only(left: 12.0.sp),
//             child: InkWell(
//                 onTap: () {
//                   Scaffold.of(ctx).openDrawer();
//                 },
//                 child: CircleAvatar(
//                   backgroundColor: MateColors.activeIcons,
//                   child: CircleAvatar(
//                     backgroundColor: Colors.transparent,
//                     child: ClipOval(
//                         child: Image.network(
//                           data,
//                         )
//                     ),
//                   ),
//                 )
//             ),
//           );
//         });
//   }
//
//
//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(Duration(milliseconds: 600), (){
//       if (widget.id == null) {
//         Provider.of<FeedProvider>(context, listen: false).fetchFeedList(page: 1, isFollowingFeeds: widget.isFollowingFeeds, userId: widget.userId);
//       } else {
//         Provider.of<FeedProvider>(context, listen: false).fetchFeedList(page: 1, feedId: widget.id);
//       }
//     });
//     _page = 1;
//     _scrollController = new ScrollController()..addListener(_scrollListener);
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _scrollController.removeListener(_scrollListener);
//     _scrollController.dispose();
//   }
//   int segmentedControlValue = 0;
//   bool isGlobalFeed=true;
//   @override
//   Widget build(BuildContext context) {
//     print('Timline build method called');
//
//     return Consumer<FeedProvider>(
//       builder: (ctx, feedProvider, _) {
//         print("timline consumer is called");
//
//         if (feedProvider.feedLoader && feedProvider.feedList.length == 0) {
//           return timelineLoader();
//         }
//
//         if (feedProvider.error != '') {
//           if(feedProvider.error.contains("Your session has expired")){
//             Future.delayed(Duration.zero,(){
//               Provider.of<AuthUserProvider>(context, listen: false)
//                   .logout();
//               feedProvider.error='';
//               Navigator.of(context).pushNamedAndRemoveUntil(
//                   GoogleLogin.loginScreenRoute,
//                       (Route<dynamic> route) => false);
//             });
//             Fluttertoast.showToast(msg: " ${feedProvider.error} ", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
//           }
//           return Center(
//               child: Container(
//                   color: Colors.red,
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(
//                       '${feedProvider.error}',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   )));
//
//         }
//
//         return feedProvider.feedList.length == 0
//             ? Center(
//                 child: Text(
//                   'Nothing new',
//                   style: TextStyle(color: Colors.white60),
//                 ),
//               )
//             : RefreshIndicator(
//                 onRefresh: () {
//                   if (widget.id == null) {
//                     _page=1;
//                     return feedProvider.fetchFeedList(page: 1, isFollowingFeeds: widget.isFollowingFeeds, userId: widget.userId);
//                   }
//                   _page=1;
//                   return feedProvider.fetchFeedList(page: 1, feedId: widget.id);
//                 },
//                 child: Column(
//                   children: [
//                     Container(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           Expanded(child: Align(
//                               alignment: Alignment.centerLeft,
//                               child: _appBarLeading(context)),),
//                           Padding(
//                             padding: const EdgeInsets.only(right: 25.0),
//                             child: InkWell(onTap: (){
//                               Navigator.of(context).pushNamed(CreateFeedPost.routeName);
//                             },
//                                 child: Image.asset("lib/asset/homePageIcons/create_post@3x.png",width: 30,fit: BoxFit.fitWidth,)),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(right: 16.0),
//                             child: InkWell(onTap: ()=>Get.to(() => PersonalChatScreen()),
//                                 child: Image.asset("lib/asset/homePageIcons/messenger@3x.png",width: 30,fit: BoxFit.fitWidth,)),
//                           ),
//                         ],
//                       ),
//                     ),
//                     StorySection(),
//
//                     Container(
//                       height: 40.0.sp,
//                       margin: const EdgeInsets.only(bottom:10.0,left: 20,right: 20,top: 10),
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.all(Radius.circular(50.0)),
//                           border: Border.all( color: Colors.grey)
//                       ),
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: InkWell(
//                               onTap: (){
//                                 isGlobalFeed=true;
//                                 setState(() {
//
//                                 });
//                               },
//                               child: Container(
//                                 height: 40.0.sp,
//                                 alignment: Alignment.center,
//                                 decoration: isGlobalFeed==true?BoxDecoration(
//                                     borderRadius: BorderRadius.all(Radius.circular(50.0)),
//                                     color: MateColors.activeIcons
//                                 ):BoxDecoration(
//                                   borderRadius: BorderRadius.all(Radius.circular(50.0)),
//                                   border: Border(),
//                                 ),
//                                 child: Text('Global Campus Feed',style: isGlobalFeed==true?ActiveSlidingButtonStyle:deActiveSlidingButtonStyle,),
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                             child: InkWell(
//                               onTap: (){
//                                 isGlobalFeed=false;
//                                 setState(() {
//
//                                 });
//                               },
//                               child: Container(
//                                 alignment: Alignment.center,
//                                 height: 40.0.sp,
//                                 decoration: isGlobalFeed==false?BoxDecoration(
//                                     borderRadius: BorderRadius.all(Radius.circular(50.0)),
//                                     color: MateColors.activeIcons
//                                 ):BoxDecoration(
//                                   borderRadius: BorderRadius.all(Radius.circular(50.0)),
//                                   border: Border(),
//                                 ),
//                                 child: Text('My Campus Feed',style: isGlobalFeed==false?ActiveSlidingButtonStyle:deActiveSlidingButtonStyle,),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Expanded(
//                       child: ListView.builder(
//                         controller: _scrollController,
//                         shrinkWrap: true,
//                         itemCount: widget.userId!=null?feedProvider.feedItemListOfUser.length:feedProvider.feedList.length,
//                         itemBuilder: (_, index) {
//                           var feedItem = widget.userId!=null?feedProvider.feedItemListOfUser[index]:feedProvider.feedList[index];
//
//                           return Visibility(
//                             visible: widget.searchKeyword!=null? widget.searchKeyword!=""? feedItem.title.toLowerCase().contains(widget.searchKeyword.toLowerCase()):false : true,
//                             child: Padding(
//                               padding: const EdgeInsets.only(left: 0.0, right: 0.0),
//                               child: HomeRow(
//                                 previousPageUserId:widget.userId,
//                                   id: feedItem.id,
//                                   feedId: feedItem.feedId,
//                                   title: feedItem.title,
//                                   feedType: feedItem.feedTypes,
//                                   start: feedItem.start,
//                                   end: feedItem.end,
//                                   calenderDate: feedItem.feedCreatedAt,
//                                   description: feedItem.description,
//                                   created: feedItem.created,
//                                   user: feedItem.user,
//                                   location: feedItem.location,
//                                   hyperlinkText: feedItem.hyperlinkText,
//                                   hyperlink: feedItem.hyperlink,
//                                   media: feedItem.media,
//                                   isLiked: feedItem.isLiked,
//                                   liked: feedItem.isLiked!=null?true:false,
//                                   bookMarked: feedItem.isBookmarked,
//                                   isFollowed: feedItem.isFollowed??false,
//                                   likeCount: feedItem.likeCount,
//                                   bookmarkCount: feedItem.bookmarkCount,
//                                   shareCount: feedItem.shareCount,
//                                   commentCount: feedItem.commentCount,
//                                   isShared: feedItem.isShared,
//                                   indexVal: index,
//
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//       },
//     );
//   }
// }


import 'dart:async';
import 'package:get/get.dart';
import 'package:mate_app/Providers/AuthUserProvider.dart';
import 'package:mate_app/Providers/FeedProvider.dart';
import 'package:mate_app/Screen/Home/Mate/MateScreen.dart';
import 'package:mate_app/Screen/Home/Mate/searchBeAMate.dart';
import 'package:mate_app/Screen/Home/Mate/searchFindAMate.dart';
import 'package:mate_app/Screen/Home/TimeLine/StorySection.dart';
import 'package:mate_app/Screen/Home/TimeLine/createFeedSelectType.dart';
import 'package:mate_app/Screen/Home/TimeLine/feed_search.dart';
import 'package:mate_app/Screen/Login/GoogleLogin.dart';
import 'package:mate_app/Widget/Loaders/Shimmer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mate_app/controller/theme_controller.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../Utility/Utility.dart';
import '../../../Widget/Drawer/DrawerWidget.dart';
import '../../../Widget/Home/HomeRow.dart';
import '../../../asset/Colors/MateColors.dart';

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
  int _page;
  int _pageMyCampus;
  TabController _tabController;
  ThemeController themeController = Get.find<ThemeController>();
  int universityId = 0;

  void _scrollListener() {
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels != 0) {
        if(_tabController.index==0 && universityId!=0 && universityId!=1){
          Future.delayed(Duration.zero,(){
            _pageMyCampus += 1;
            print('scrolled to bottom page is now $_pageMyCampus');
            Provider.of<FeedProvider>(context, listen: false).fetchFeedListMyCampus(page: _pageMyCampus, feedId: widget.id, paginationCheck: true, isFollowingFeeds: widget.isFollowingFeeds, userId: widget.userId );
          });
        }else{
          Future.delayed(Duration.zero,(){
            _page += 1;
            print('scrolled to bottom page is now $_page');
            Provider.of<FeedProvider>(context, listen: false).fetchFeedList(page: _page, feedId: widget.id, paginationCheck: true, isFollowingFeeds: widget.isFollowingFeeds, userId: widget.userId );
          });
        }
      }
    }
  }

  Widget _appBarLeading(BuildContext context) {
    return Selector<AuthUserProvider, String>(
        selector: (ctx, authUserProvider) => authUserProvider.authUserPhoto,
        builder: (ctx, data, _) {
          return Padding(
            padding:  EdgeInsets.only(left: 12.0.sp),
            child: InkWell(
                onTap: () {
                  //Scaffold.of(ctx).openDrawer();
                  _key.currentState.openDrawer();
                },
                child: CircleAvatar(
                  backgroundColor: MateColors.activeIcons,
                  radius: 16,
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 16,
                    backgroundImage: NetworkImage(data),
                    // child: ClipOval(
                    //     child: Image.network(
                    //       data,
                    //     )
                    // ),
                  ),
                )
            ),
          );
        });
  }


  @override
  void initState() {
    super.initState();
    print(Provider.of<AuthUserProvider>(context, listen: false).authUser.universityId);
    universityId = Provider.of<AuthUserProvider>(context, listen: false).authUser.universityId??0;
    _tabController = new TabController(length: universityId==0||universityId==1?2:3, vsync: this)..addListener(() {
      if(_tabController.index == 0 && universityId!=0 && universityId!=1){
        _pageMyCampus=1;
        Provider.of<FeedProvider>(context, listen: false).fetchFeedListMyCampus(page: 1, feedId: widget.id);
      }else{//if(_tabController.index == 1)
        _page = 1;
        Provider.of<FeedProvider>(context, listen: false).fetchFeedList(page: 1, feedId: widget.id);
      }
    });
    Future.delayed(Duration(milliseconds: 600), (){
      if (widget.id == null) {
        Provider.of<FeedProvider>(context, listen: false).fetchFeedListMyCampus(page: 1, feedId: widget.id);
        Provider.of<FeedProvider>(context, listen: false).fetchFeedList(page: 1, isFollowingFeeds: widget.isFollowingFeeds, userId: widget.userId);
      }else {
        Provider.of<FeedProvider>(context, listen: false).fetchFeedList(page: 1, feedId: widget.id);
      }
    });
    _page = 1;
    _pageMyCampus =1;
    _scrollController = new ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
  }

  int segmentedControlValue = 0;
  bool isGlobalFeed=false;
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    print('Timline build method called');

    return Scaffold(
      key: _key,
      drawer: DrawerWidget(),
      floatingActionButton: InkWell(
        onTap: () {
          Get.to(CreateFeedSelectType());
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
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(right: 10,top: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _appBarLeading(context),
                Text("Home", style: TextStyle(fontSize: 17, fontFamily: "Poppins",fontWeight: FontWeight.w700, color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor)),
                IconButton(
                    icon: Image.asset("lib/asset/homePageIcons/searchPurple@3x.png",height: 23.7,width: 23.7,color: MateColors.activeIcons,),
                    onPressed: () {
                      //SearchScreen(feedTypeName: widget.feedTypeName,),
                      //Get.to(SearchScreen(feedTypeName: "",));
                      if(_tabController.index == 2){
                        if(Provider.of<FeedProvider>(context, listen: false).isFindAMate){
                          print("find a mate");
                          Get.to(SearchFindAMate());
                        }else{
                          print("be a mate");
                          Get.to(SearchBeAMate());
                        }
                      }else{
                        final page = FeedSearch(text: "",);
                        Navigator.push(context,MaterialPageRoute(builder: (context) => page ));
                      }
                      //Get.toNamed(FeedSearch.routes);
                    }
                  //Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchPage())),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(right: 25.0),
                //   child: InkWell(onTap: (){
                //     Navigator.of(context).pushNamed(CreateFeedPost.routeName);
                //   },
                //       child: Image.asset("lib/asset/homePageIcons/create_post@3x.png",width: 30,fit: BoxFit.fitWidth,)),
                // ),
                // Padding(
                //   padding: const EdgeInsets.only(right: 16.0),
                //   child: InkWell(onTap: ()=>Get.to(() => PersonalChatScreen()),
                //       child: Image.asset("lib/asset/homePageIcons/messenger@3x.png",width: 30,fit: BoxFit.fitWidth,)),
                // ),
              ],
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.0),
              border: Border(bottom: BorderSide(color: Color(0xFF65656B).withOpacity(0.2), width: 0.8)),
            ),
            child: TabBar(
              onTap: (value){
                print(value);
                if(value == 0 && universityId!=0 && universityId!=1){
                  isGlobalFeed=false;
                  _pageMyCampus=1;
                  Provider.of<FeedProvider>(context, listen: false).fetchFeedListMyCampus(page: 1, feedId: widget.id);
                  setState(() {});
                }else{
                  isGlobalFeed=true;
                  _page = 1;
                  Provider.of<FeedProvider>(context, listen: false).fetchFeedList(page: 1, feedId: widget.id);
                  setState(() {});
                }
              },
              controller: _tabController,
              unselectedLabelColor: Color(0xFF656568),
              indicatorColor: MateColors.activeIcons,
              indicatorPadding: EdgeInsets.symmetric(horizontal: 20),
              labelColor: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
              labelStyle: TextStyle(fontSize: 15.0,fontFamily: "Poppins",fontWeight: FontWeight.w500),
              tabs: [
                if(universityId!=1 && universityId!=0)
                Tab(
                  text: "My Campus",
                ),
                Tab(
                  text: "Global",
                ),
                Tab(
                  text: "Job Board",
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<FeedProvider>(
              builder: (ctx, feedProvider, _) {
                print("timline consumer is called");

                if (feedProvider.feedLoader && feedProvider.feedList.length == 0) {
                  return timelineLoader();
                }

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
                          )));

                }

                return feedProvider.feedListMyCampus.length == 0
                    ? Center(
                  child: Text(
                    'Nothing new',
                    style: TextStyle(color: themeController.isDarkMode?Colors.white:Colors.black),
                  ),
                ) :
                RefreshIndicator(
                  onRefresh: () {
                    if (widget.id == null) {
                      print("///////");
                      if(_tabController.index==0 && universityId!=0 && universityId!=1){
                        _pageMyCampus=1;
                        return feedProvider.fetchFeedListMyCampus(page: 1, feedId: widget.id);
                      }else{
                        _page=1;
                        return feedProvider.fetchFeedList(page: 1, feedId: widget.id);
                      }
                    }else{
                      print("-------");
                      _page=1;
                      return feedProvider.fetchFeedList(page: 1, isFollowingFeeds: widget.isFollowingFeeds, userId: widget.userId);
                    }
                  },
                  child: Container(
                    color: themeController.isDarkMode?backgroundColor:Colors.white,
                    //padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        // Container(
                        //   margin: EdgeInsets.only(right: 10),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       _appBarLeading(context),
                        //       Text("Home", style: TextStyle(fontSize: 17, fontFamily: "Poppins",fontWeight: FontWeight.w700, color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor)),
                        //       IconButton(
                        //           icon: Image.asset("lib/asset/homePageIcons/searchPurple@3x.png",height: 23.7,width: 23.7,color: MateColors.activeIcons,),
                        //           onPressed: () {
                        //             //SearchScreen(feedTypeName: widget.feedTypeName,),
                        //             //Get.to(SearchScreen(feedTypeName: "",));
                        //             final page = FeedSearch();
                        //             Navigator.push(context,MaterialPageRoute(builder: (context) => page ));
                        //             //Get.toNamed(FeedSearch.routes);
                        //           }
                        //         //Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchPage())),
                        //       ),
                        //       // Padding(
                        //       //   padding: const EdgeInsets.only(right: 25.0),
                        //       //   child: InkWell(onTap: (){
                        //       //     Navigator.of(context).pushNamed(CreateFeedPost.routeName);
                        //       //   },
                        //       //       child: Image.asset("lib/asset/homePageIcons/create_post@3x.png",width: 30,fit: BoxFit.fitWidth,)),
                        //       // ),
                        //       // Padding(
                        //       //   padding: const EdgeInsets.only(right: 16.0),
                        //       //   child: InkWell(onTap: ()=>Get.to(() => PersonalChatScreen()),
                        //       //       child: Image.asset("lib/asset/homePageIcons/messenger@3x.png",width: 30,fit: BoxFit.fitWidth,)),
                        //       // ),
                        //     ],
                        //   ),
                        // ),
                        Expanded(
                          child: Container(
                            child: Column(
                              children: [
                                // DecoratedBox(
                                //   decoration: BoxDecoration(
                                //     color: Colors.white.withOpacity(0.0),
                                //     border: Border(bottom: BorderSide(color: Color(0xFF65656B).withOpacity(0.2), width: 0.8)),
                                //   ),
                                //   child: TabBar(
                                //     onTap: (value){
                                //       print(value);
                                //       if(value == 0){
                                //         isGlobalFeed=false;
                                //         setState(() {});
                                //       }else{
                                //         isGlobalFeed=true;
                                //         setState(() {});
                                //       }
                                //     },
                                //     controller: _tabController,
                                //     unselectedLabelColor: Color(0xFF656568),
                                //     indicatorColor: MateColors.activeIcons,
                                //     indicatorPadding: EdgeInsets.symmetric(horizontal: 20),
                                //     labelColor: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                                //     labelStyle: TextStyle(fontSize: 15.0,fontFamily: "Poppins",fontWeight: FontWeight.w500),
                                //     tabs: [
                                //       Tab(
                                //         text: "My Campus",
                                //       ),
                                //       Tab(
                                //         text: "Global",
                                //       ),
                                //       Tab(
                                //         text: "Job Board",
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                Expanded(
                                  child: TabBarView(
                                      controller: _tabController,
                                      children: [
                                        if(universityId!=1 && universityId!=0)
                                        Column(
                                          children: [
                                            StorySection(),
                                            Expanded(
                                              child: Provider.of<AuthUserProvider>(context, listen: false).authUser.universityId==null?
                                              Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                                  child: Text("Please update your university in profile section to see My Campus feed",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(color: themeController.isDarkMode?Colors.white:Colors.black),
                                                  ),
                                                ),
                                              ):
                                              feedProvider.feedListMyCampus.length>0?
                                              RefreshIndicator(
                                                onRefresh: () {
                                                  _pageMyCampus=1;
                                                  return feedProvider.fetchFeedListMyCampus(page: 1, feedId: widget.id);
                                                },
                                                child: ListView.builder(
                                                  controller: _scrollController,
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
                                                          pageType : "TimeLineMyCampus"
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ):Center(
                                                child: Text("Nothing new",
                                                  style: TextStyle(color: themeController.isDarkMode?Colors.white:Colors.black),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            StorySection(),
                                            Expanded(
                                              child: RefreshIndicator(
                                                onRefresh: (){
                                                  _page=1;
                                                  return feedProvider.fetchFeedList(page: 1, feedId: widget.id);
                                                },
                                                child: ListView.builder(
                                                  controller: _scrollController,
                                                  shrinkWrap: true,
                                                  itemCount: widget.userId!=null?feedProvider.feedItemListOfUser.length:feedProvider.feedList.length,
                                                  itemBuilder: (_, index) {
                                                    var feedItem = widget.userId!=null?feedProvider.feedItemListOfUser[index]:feedProvider.feedList[index];

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
                                                          pageType : "TimeLineGlobal",
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        MateScreen(),
                                      ]
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
