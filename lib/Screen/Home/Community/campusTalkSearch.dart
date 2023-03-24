import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mate_app/Providers/campusTalkProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mate_app/Model/campusTalkPostsModel.dart';

import '../../../Widget/Home/Community/campusTalkRow.dart';
import '../../../Widget/Loaders/Shimmer.dart';
import '../../../asset/Colors/MateColors.dart';
import '../../../constant.dart';
import '../../../controller/theme_controller.dart';

class CampusTalkSearch extends StatefulWidget {
  final String searchType;
  const CampusTalkSearch({Key key, this.searchType}) : super(key: key);

  @override
  State<CampusTalkSearch> createState() => _CampusTalkSearchState();
}

class _CampusTalkSearchState extends State<CampusTalkSearch> {
  TextEditingController _textEditingController = TextEditingController();
  ThemeController themeController = Get.find<ThemeController>();
  String token = "";
  int page = 1;
  bool enterFutureBuilder = false;
  bool doingPagination = false;
  ScrollController _scrollController;
  CampusTalkProvider campusTalkProvider;

  Timer _throttle;
  _onSearchChanged() {
    if (_throttle?.isActive??false) _throttle?.cancel();
    _throttle = Timer(const Duration(milliseconds: 200), () {
      if(_textEditingController.text.length>2){
        fetchData();
      }
    });
  }

  fetchData()async{
    page = 1;
    campusTalkProvider.campusTalkBySearchResultsList.clear();
    await campusTalkProvider.fetchCampusTalkPostSearchList(
      page: page,
      text: _textEditingController.text,
      searchType: widget.searchType,
      paginationCheck: false,
    );
  }

  void _scrollListener(){
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels != 0) {
        Future.delayed(Duration.zero,()async{
          page += 1;
          print('scrolled to bottom page is now $page');
          await campusTalkProvider.fetchCampusTalkPostSearchList(
            page: page,
            text: _textEditingController.text,
            searchType: widget.searchType,
            paginationCheck: true,
          );
        });
      }
    }
  }

  @override
  void initState() {
    campusTalkProvider = Provider.of<CampusTalkProvider>(context, listen: false);
    campusTalkProvider.campusTalkBySearchResultsList.clear();
    getStoredValue();
    _textEditingController.addListener(_onSearchChanged);
    _scrollController = new ScrollController()..addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.removeListener(_onSearchChanged);
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  getStoredValue()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token");
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
                    if(value.length>2){
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
              Expanded(
                child: Consumer<CampusTalkProvider>(
                  builder: (context,campusTalk,_){
                    return ListView(
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                      controller: _scrollController,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      padding: EdgeInsets.only(top: 15),
                      children: [
                        campusTalkProvider.campusTalkBySearchResultsList.length!=0?
                        ListView.builder(
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount: campusTalkProvider.campusTalkBySearchResultsList.length,
                          itemBuilder: (context,index){
                            Result campusTalkData = campusTalkProvider.campusTalkBySearchResultsList[index];
                            return CampusTalkRow(
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
                              isSearch: true,
                              campusTalkType: campusTalkData.campusTalkTypes,
                            );
                          },
                        ):
                        campusTalkProvider.searchLoader?
                        timelineLoader():
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
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
