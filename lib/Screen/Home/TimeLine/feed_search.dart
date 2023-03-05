import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mate_app/Providers/AuthUserProvider.dart';
import 'package:mate_app/Services/FeedService.dart';
import 'package:mate_app/Widget/Home/HomeRow.dart';
import 'package:mate_app/asset/Colors/MateColors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../../Model/FeedItem.dart';
import '../../../Providers/FeedProvider.dart';
import '../../../Widget/Loaders/Shimmer.dart';
import '../../../Widget/searchShimmer.dart';
import '../../../constant.dart';
import '../../../controller/theme_controller.dart';


class FeedSearch extends StatefulWidget {
  static final String routes = '/feedSearch';
  final String text;
  FeedSearch({this.text});

  @override
  _FeedSearchState createState() => _FeedSearchState();
}

class _FeedSearchState extends State<FeedSearch> {
  ThemeController themeController = Get.find<ThemeController>();
  ScrollController _scrollController;
  int page = 1;
  bool enterFutureBuilder = false;
  String userId;
  FeedService _feedService = FeedService();
  TextEditingController _textEditingController;
  String token = "";
  List<bool> selected = [];
  bool isLoading = false;
  bool normalSearch = false;
  String valueController = "";
  FeedProvider feedProvider;

  @override
  void initState() {
    feedProvider = Provider.of<FeedProvider>(context, listen: false);
    _textEditingController = TextEditingController(text: widget.text);
    _scrollController = new ScrollController()..addListener(_scrollListener);
    userId = Provider.of<AuthUserProvider>(context, listen: false).authUser.id;
    Future.delayed(Duration.zero, (){
      Provider.of<FeedProvider>(context, listen: false).fetchFeedTypes().whenComplete(() {
        for(int i=0;i<Provider.of<FeedProvider>(context, listen: false).feedTypeList.length;i++){
          selected.add(false);
        }
      });
    });
    getStoredValue();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    feedProvider.feedItem.clear();
    super.dispose();
  }

  getStoredValue()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token");
    if(widget.text!=""){
      fetchData();
    }
  }

  void _scrollListener(){
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels != 0) {
        Future.delayed(Duration.zero,()async{
          page += 1;
          print('scrolled to bottom page is now $page');
          List<FeedItem> data;
          if(normalSearch){
            data = await _feedService.searchFeedForTextField(page: page, text: _textEditingController.text, token: token,);
          }else{
            data =  await _feedService.searchFeed(page: page, text: _textEditingController.text, token: token,);
          }
          for(int i=0;i<data.length;i++){
            feedProvider.feedItem.add(data[i]);
          }
          setState(() {});
        });
      }
    }
  }

  fetchData()async{
    page = 1;
    feedProvider.feedItem.clear();
    feedProvider.feedItem =  await _feedService.searchFeed(page: page, text: _textEditingController.text, token: token,);
    setState(() {
      isLoading = false;
    });
  }

  Timer _throttle;
  _onSearchChanged() {
    if (_throttle?.isActive??false) _throttle?.cancel();
    _throttle = Timer(const Duration(milliseconds: 200), () {
      if(_textEditingController.text.length>2){
        fetchDataForTextField();
      }
    });
  }

  fetchDataForTextField()async{
    valueController = _textEditingController.text;
    page = 1;
    normalSearch = true;
    feedProvider.feedItem.clear();
    isLoading = true;
    setState(() {});
    feedProvider.feedItem =  await _feedService.searchFeedForTextField(page: page, text: _textEditingController.text, token: token,);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final scH = MediaQuery.of(context).size.height;
    final scW = MediaQuery.of(context).size.width;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: null,
      onPanUpdate: (details) {
        if (details.delta.dy > 0){
          FocusScope.of(context).requestFocus(FocusNode());
          print("Dragging in +Y direction");
        }
      },
      child: Scaffold(
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
                height: scH*0.07,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _textEditingController,
                  onChanged: (value){
                    if(value.length>2 && _textEditingController.text != valueController){
                      _onSearchChanged();
                    }
                  },
                  cursorColor: themeController.isDarkMode?MateColors.helpingTextDark:MateColors.helpingTextLight,
                  style:  TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.1,
                    color: themeController.isDarkMode?Colors.white:Colors.black,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: themeController.isDarkMode ? MateColors.containerDark : MateColors.containerLight,
                    hintStyle: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      color: themeController.isDarkMode?MateColors.helpingTextDark:MateColors.helpingTextLight,
                    ),
                    hintText: "Search",
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 15,top: 15,bottom: 15),
                      child: Image.asset(
                        "lib/asset/homePageIcons/searchPurple@3x.png",
                        height: 10,
                        width: 10,
                        color: themeController.isDarkMode?Colors.white:Colors.black,
                      ),
                    ),
                    suffixIcon: InkWell(
                      onTap: (){
                        Get.back();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16,right: 15),
                        child: Text(
                          "Close",
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            color: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                          ),
                        ),
                      ),
                    ),
                    enabledBorder: commonBorder,
                    focusedBorder: commonBorder,
                  ),
                ),
              ),
              Container(
                height: 55,
                child: Consumer<FeedProvider>(
                  builder: (context,feedProvider,_){
                    return !feedProvider.feedTypeLoader?
                    ListView.builder(
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: feedProvider.feedTypeList.length,
                      itemBuilder: (context,index){
                        return Padding(
                          padding: EdgeInsets.only(left: 15,top: 15),
                          child: InkWell(
                            onTap: (){
                              for(int i=0;i<selected.length;i++){
                                if(i==index){
                                  selected[i] = true;
                                }else{
                                  selected[i] = false;
                                }
                              }
                              isLoading = true;
                              normalSearch = false;
                              setState(() {});
                              _textEditingController.text = feedProvider.feedTypeList[index].name;
                              fetchData();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: themeController.isDarkMode?MateColors.smallContainerDark:MateColors.smallContainerLight,
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 25),
                                  child: Text(feedProvider.feedTypeList[index].name,
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 15,
                                      color: themeController.isDarkMode?Colors.white:Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ):
                    Shimmer.fromColors(
                      baseColor: themeController.isDarkMode?Colors.white12:Colors.black12,
                      highlightColor: themeController.isDarkMode?Colors.white54:Colors.black54,
                      enabled: true,
                      child: SearchShimmer(),
                    );
                  },
                ),
              ),
              Expanded(
                child: ListView(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  controller: _scrollController,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  padding: EdgeInsets.only(left: 15,right: 15,top: 15),
                  children: [
                    feedProvider.feedItem.length!=0?
                    ListView.builder(
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: feedProvider.feedItem.length,
                      itemBuilder: (context,index){
                        return HomeRow(
                          previousPageUserId: userId,
                          id: feedProvider.feedItem[index].id,
                          feedId: feedProvider.feedItem[index].feedId,
                          title: feedProvider.feedItem[index].title,
                          feedType: feedProvider.feedItem[index].feedTypes,
                          start: feedProvider.feedItem[index].start,
                          end: feedProvider.feedItem[index].end,
                          calenderDate: feedProvider.feedItem[index].feedCreatedAt,
                          description: feedProvider.feedItem[index].description,
                          created: feedProvider.feedItem[index].created,
                          user: feedProvider.feedItem[index].user,
                          location: feedProvider.feedItem[index].location,
                          hyperlinkText: feedProvider.feedItem[index].hyperlinkText,
                          hyperlink: feedProvider.feedItem[index].hyperlink,
                          media: feedProvider.feedItem[index].media,
                          isLiked: feedProvider.feedItem[index].isLiked,
                          liked: feedProvider.feedItem[index].isLiked!=null?true:false,
                          bookMarked: feedProvider.feedItem[index].isBookmarked,
                          isFollowed: feedProvider.feedItem[index].isFollowed??false,
                          likeCount: feedProvider.feedItem[index].likeCount,
                          bookmarkCount: feedProvider.feedItem[index].bookmarkCount,
                          shareCount: feedProvider.feedItem[index].shareCount,
                          commentCount: feedProvider.feedItem[index].commentCount,
                          isShared: feedProvider.feedItem[index].isShared,
                          indexVal: index,
                          pageType: "Search",
                          showUniversityTag: true,
                        );
                      },
                    ):
                    isLoading?timelineLoader():
                    Container(
                      height: MediaQuery.of(context).size.height/1.2,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          child: Text(
                            "Try searching by post title, description, or author.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              color: themeController.isDarkMode?Colors.white.withOpacity(0.7):Colors.black.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
