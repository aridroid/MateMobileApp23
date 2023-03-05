import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../Providers/FeedProvider.dart';
import '../../../Widget/Home/HomeRow.dart';
import '../../../Widget/Loaders/Shimmer.dart';
import '../../../asset/Colors/MateColors.dart';
import '../../../controller/theme_controller.dart';
import 'feed_search.dart';

class GlobalFeed extends StatefulWidget {
  const GlobalFeed({Key key}) : super(key: key);

  @override
  State<GlobalFeed> createState() => _GlobalFeedState();
}

class _GlobalFeedState extends State<GlobalFeed> {
  ThemeController themeController = Get.find<ThemeController>();
  ScrollController _scrollController;
  int _pageGlobal;

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 600), (){
      Provider.of<FeedProvider>(context, listen: false).fetchFeedList(page: 1);
    });
    _pageGlobal = 1;
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
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels != 0) {
        Future.delayed(Duration.zero,(){
          _pageGlobal += 1;
          print('scrolled to bottom page is now $_pageGlobal');
          Provider.of<FeedProvider>(context, listen: false).fetchFeedList(page: _pageGlobal, paginationCheck: true,);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scH = MediaQuery.of(context).size.height;
    final scW = MediaQuery.of(context).size.width;
    return Scaffold(
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
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height*0.07,
                left: 16,
                right: 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: (){
                      Get.back();
                    },
                    child: Icon(Icons.arrow_back_ios,
                      size: 20,
                      color: themeController.isDarkMode ? Colors.white : MateColors.blackTextColor,
                    ),
                  ),
                  Text(
                    "Global Feed",
                    style: TextStyle(
                      color: themeController.isDarkMode ? Colors.white : MateColors.drawerTileColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 18.0,
                    ),
                  ),
                  SizedBox(),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.to(()=>FeedSearch(text: ''));
              },
              child: Container(
                margin: EdgeInsets.only(left: 16,right: 16,top: 20,bottom: 10),
                height: 60,
                decoration: BoxDecoration(
                  color: themeController.isDarkMode ? MateColors.containerDark : MateColors.containerLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Search posts, mates, communities",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: themeController.isDarkMode?MateColors.helpingTextDark:Colors.black.withOpacity(0.72),
                      ),
                    ),
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: themeController.isDarkMode?MateColors.bottomSheetItemBackgroundDark:MateColors.containerLight,
                      ),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          "lib/asset/iconsNewDesign/search.png",
                          color: themeController.isDarkMode?Colors.white:MateColors.blackText,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Consumer<FeedProvider>(
                builder: (ctx, feedProvider, _) {
                  if (feedProvider.feedLoader && feedProvider.feedList.length == 0) {
                    return timelineLoader();
                  }
                  if (feedProvider.error != '') {
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
                  return feedProvider.feedList.length == 0 ?
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
                      _pageGlobal = 1;
                      return feedProvider.fetchFeedList(page: 1);
                    },
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: feedProvider.feedList.length,
                      itemBuilder: (_, index) {
                        var feedItem = feedProvider.feedList[index];
                        return Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: HomeRow(
                            previousPageUserId: '',
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
