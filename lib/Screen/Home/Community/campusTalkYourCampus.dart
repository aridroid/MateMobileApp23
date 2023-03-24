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

import '../../../controller/theme_controller.dart';
import 'campusTalkSearch.dart';

class CampusTalkScreenYourCampus extends StatefulWidget {
  const CampusTalkScreenYourCampus({Key key}) : super(key: key);

  @override
  _CampusTalkScreenYourCampusState createState() => _CampusTalkScreenYourCampusState();
}

class _CampusTalkScreenYourCampusState extends State<CampusTalkScreenYourCampus> with TickerProviderStateMixin {
  ThemeController themeController = Get.find<ThemeController>();
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final scH = MediaQuery.of(context).size.height;
    final scW = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _key,
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
                    "Your Campus",
                    style: TextStyle(
                      color: themeController.isDarkMode ? Colors.white : MateColors.blackTextColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 17.0,
                    ),
                  ),
                  SizedBox(),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.to(()=>CampusTalkSearch(searchType: 'my_campus',));
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 16),
                        height: 60,
                        decoration: BoxDecoration(
                          color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.only(left: 16, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Search here...",
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
                                color: themeController.isDarkMode?MateColors.textFieldSearchDark:MateColors.textFieldSearchLight,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
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
                  ),
                  SizedBox(width: 16,),
                  InkWell(
                    onTap: () async {
                      Get.to(CreateCampusTalkPost());
                    },
                    child: Container(
                      height: 60,
                      width: 60,
                      margin: EdgeInsets.only(right: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                      ),
                      child: Icon(Icons.add, color: MateColors.blackTextColor, size: 28),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
            Expanded(
              child: CampusTalk(),
            ),
          ],
        ),
      ),
    );
  }
}

class CampusTalk extends StatefulWidget {
  const CampusTalk({Key key}) : super(key: key);

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
          Provider.of<CampusTalkProvider>(context, listen: false).fetchCampusTalkPostYourCampusList(page: _page,paginationCheck: true);
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 0), () {
      Provider.of<CampusTalkProvider>(context, listen: false).fetchCampusTalkPostYourCampusList(page: 1);
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
        if (campusTalkProvider.talkPostYourCampusLoader && campusTalkProvider.campusTalkPostsResultsYourCampusList.length == 0) {
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
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
          );
        }
        return campusTalkProvider.campusTalkPostsResultsYourCampusList.length == 0 ?
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
            _page = 1;
            return campusTalkProvider.fetchCampusTalkPostYourCampusList(page: 1);
          },
          child: ListView.builder(
            padding: EdgeInsets.zero,
            controller: _scrollController,
            shrinkWrap: true,
            physics: ScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: campusTalkProvider.campusTalkPostsResultsYourCampusList.length,
            itemBuilder: (context, index) {
              Result campusTalkData = campusTalkProvider.campusTalkPostsResultsYourCampusList[index];
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
                isYourCampus: true,
                campusTalkType: campusTalkData.campusTalkTypes,
              );
            },
          ),
        );
      },
    );
  }
}
