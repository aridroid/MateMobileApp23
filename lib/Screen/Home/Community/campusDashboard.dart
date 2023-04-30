import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mate_app/Screen/Home/Community/campusTalkForums.dart';
import 'package:mate_app/Screen/Home/Community/campusTalkLatest.dart';
import 'package:mate_app/Screen/Home/Community/campusTalkYourCampus.dart';
import 'package:mate_app/constant.dart';
import 'package:provider/provider.dart';

import '../../../Model/campusTalkPostsModel.dart';
import '../../../Providers/campusTalkProvider.dart';
import '../../../asset/Colors/MateColors.dart';
import '../../../controller/theme_controller.dart';
import 'campusTalkSearch.dart';
import 'campusTalkTrending.dart';
import 'campusTalkDetailsFullScreen.dart';
import 'createCampusTalkPost.dart';

class CampusDashboard extends StatefulWidget {
  const CampusDashboard({Key key}) : super(key: key);

  @override
  State<CampusDashboard> createState() => _CampusDashboardState();
}

class _CampusDashboardState extends State<CampusDashboard> {
  ThemeController themeController = Get.find<ThemeController>();
  List<Widget> swipeWidget = [];

  Widget cardItem(String title,String subTitle,Result list){
    return GestureDetector(
      onTap: () {
        _navigateToDetailsPage(list);
      },
      child: Container(
        decoration: BoxDecoration(
          color: themeController.isDarkMode?Colors.transparent:Colors.white,
          borderRadius: BorderRadius.circular(themeController.isDarkMode?0:14),
          image: themeController.isDarkMode?DecorationImage(
            image: AssetImage(themeController.isDarkMode?'lib/asset/iconsNewDesign/rectangle_swipe_dark.png':'lib/asset/iconsNewDesign/rectangle_swipe_light.png'),
            fit: BoxFit.fill,
          ):null,
        ),
        padding: EdgeInsets.only(top: 16,bottom: 5,left: 16,right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildEmojiAndText(
              content: title,
              textStyle: TextStyle(
                fontWeight: FontWeight.w700,
                color: themeController.isDarkMode?Colors.white:Colors.black,
              ),
              normalFontSize: 16,
              emojiFontSize: 26,
            ),
            SizedBox(height: 10,),
            Expanded(
              child: buildEmojiAndText(
                content: subTitle,
                textStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: themeController.isDarkMode?Colors.white:Colors.black,
                ),
                normalFontSize: 14,
                emojiFontSize: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void buildCardItem(){
    swipeWidget.clear();
    var list = Provider.of<CampusTalkProvider>(context, listen: false).campusTalkPostsResultsListCard;
    for(int i=0;i<list.length;i++){
      swipeWidget.add(cardItem(list[i].title, list[i].description, list[i]));
    }
  }

  _navigateToDetailsPage(Result list) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CampusTalkDetailsScreen(
            talkId: list.id,
            description: list.description,
            title: list.title,
            user: list.user,
            isAnonymous: list.isAnonymous,
            anonymousUser: list.anonymousUser,
            url: list.url,
            createdAt: "${DateFormat.yMMMEd().format(DateFormat("yyyy-MM-dd").parse(list.createdAt, true))}",
            rowIndex: 0,
            isBookmarked: list.isBookmarked,
            isLiked: list.isLiked,
            likesCount: list.likesCount,
            commentsCount: list.commentsCount,
            isListCard: true,
            disLikeCount: list.dislikesCount,
            isDisLiked: list.isDisliked,
            image: list.photoUrl,
            video: list.videoUrl,
            audio: list.audioUrl,
          ),
        ));
  }

  @override
  void initState() {
    Provider.of<CampusTalkProvider>(context, listen: false).fetchCampusTalkPostListCard();
    super.initState();
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
        child: Consumer<CampusTalkProvider>(
          builder: (ctx, campusTalkProvider, _) {
            if(!campusTalkProvider.cardLoader && campusTalkProvider.campusTalkPostsResultsListCard.isNotEmpty){
              buildCardItem();
            }
           return Column(
             children: [
               SizedBox(
                 height: scH*0.07,
               ),
               Center(
                 child: Text(
                   "Campus",
                   style: TextStyle(
                     fontFamily: 'Poppins',
                     color: themeController.isDarkMode ? MateColors.whiteText : MateColors.blackText,
                     fontWeight: FontWeight.w600,
                     fontSize: 18,
                   ),
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
                           Get.to(()=>CampusTalkSearch(searchType: 'Global',));
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
               Expanded(
                 child: SingleChildScrollView(
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Padding(
                         padding: const EdgeInsets.only(left: 16,top: 25),
                         child: Text(
                           "Most Popular",
                           style: TextStyle(
                             fontFamily: 'Poppins',
                             color: themeController.isDarkMode ? Colors.white : Colors.black,
                             fontWeight: FontWeight.w500,
                             fontSize: 16.0,
                           ),
                         ),
                       ),
                       Padding(
                         padding: const EdgeInsets.only(left: 16,top: 16,right: 16),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             GestureDetector(
                               onTap: () {
                                 Get.to(()=>CampusTalkScreenTrending());
                               },
                               child: Container(
                                 height: 140,
                                 width: MediaQuery.of(context).size.width*0.44,
                                 decoration: BoxDecoration(
                                   color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                                   borderRadius: BorderRadius.circular(12),
                                 ),
                                 padding: EdgeInsets.only(top: 30,bottom: 30),
                                 child: Column(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     Container(
                                       padding: const EdgeInsets.all(12.0),
                                       height: 46,
                                       width: 46,
                                       decoration: BoxDecoration(
                                         shape: BoxShape.circle,
                                         color: themeController.isDarkMode?MateColors.textFieldSearchDark:MateColors.textFieldSearchLight,
                                       ),
                                       child: Image.asset('lib/asset/iconsNewDesign/trending.png',
                                         width: 16,
                                         height: 16,
                                         color: themeController.isDarkMode?Colors.white:MateColors.blackText,
                                       ),
                                     ),
                                     Text('Trending',
                                       style: TextStyle(
                                           fontSize: 13,
                                           fontFamily: "Poppins",
                                           fontWeight: FontWeight.w600,
                                           overflow: TextOverflow.ellipsis,
                                           color: themeController.isDarkMode?Colors.white:MateColors.blackText
                                       ),
                                     ),
                                   ],
                                 ),
                               ),
                             ),
                             GestureDetector(
                               onTap: () {
                                 Get.to(()=>CampusTalkScreenLatest());
                               },
                               child: Container(
                                 height: 140,
                                 width: MediaQuery.of(context).size.width*0.44,
                                 decoration: BoxDecoration(
                                   color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                                   borderRadius: BorderRadius.circular(12),
                                 ),
                                 padding: EdgeInsets.only(top: 30,bottom: 30),
                                 child: Column(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     Container(
                                       padding: const EdgeInsets.all(12.0),
                                       height: 46,
                                       width: 46,
                                       decoration: BoxDecoration(
                                         shape: BoxShape.circle,
                                         color: themeController.isDarkMode?MateColors.textFieldSearchDark:MateColors.textFieldSearchLight,
                                       ),
                                       child: Image.asset('lib/asset/iconsNewDesign/topRated.png',
                                         width: 16,
                                         height: 16,
                                         color: themeController.isDarkMode?Colors.white:MateColors.blackText,
                                       ),
                                     ),
                                     Text('Latest',
                                       style: TextStyle(
                                           fontSize: 13,
                                           fontFamily: "Poppins",
                                           fontWeight: FontWeight.w600,
                                           overflow: TextOverflow.ellipsis,
                                           color: themeController.isDarkMode?Colors.white:MateColors.blackText
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
                         padding: const EdgeInsets.only(left: 16,top: 16,right: 16),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             GestureDetector(
                               onTap: () {
                                 Get.to(()=>CampusTalkScreenForums());
                               },
                               child: Container(
                                 height: 140,
                                 width: MediaQuery.of(context).size.width*0.44,
                                 decoration: BoxDecoration(
                                   color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                                   borderRadius: BorderRadius.circular(12),
                                 ),
                                 padding: EdgeInsets.only(top: 30,bottom: 30),
                                 child: Column(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     Container(
                                       padding: const EdgeInsets.all(12.0),
                                       height: 46,
                                       width: 46,
                                       decoration: BoxDecoration(
                                         shape: BoxShape.circle,
                                         color: themeController.isDarkMode?MateColors.textFieldSearchDark:MateColors.textFieldSearchLight,
                                       ),
                                       child: Image.asset('lib/asset/iconsNewDesign/forum.png',
                                         width: 16,
                                         height: 16,
                                         color: themeController.isDarkMode?Colors.white:MateColors.blackText,
                                       ),
                                     ),
                                     Text('Forums',
                                       style: TextStyle(
                                           fontSize: 13,
                                           fontFamily: "Poppins",
                                           fontWeight: FontWeight.w600,
                                           overflow: TextOverflow.ellipsis,
                                           color: themeController.isDarkMode?Colors.white:MateColors.blackText
                                       ),
                                     ),
                                   ],
                                 ),
                               ),
                             ),
                             GestureDetector(
                               onTap: () {
                                 Get.to(()=>CampusTalkScreenYourCampus());
                               },
                               child: Container(
                                 height: 140,
                                 width: MediaQuery.of(context).size.width*0.44,
                                 decoration: BoxDecoration(
                                   color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                                   borderRadius: BorderRadius.circular(12),
                                 ),
                                 padding: EdgeInsets.only(top: 30,bottom: 30),
                                 child: Column(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     Container(
                                       padding: const EdgeInsets.all(12.0),
                                       height: 46,
                                       width: 46,
                                       decoration: BoxDecoration(
                                         shape: BoxShape.circle,
                                         color: themeController.isDarkMode?MateColors.textFieldSearchDark:MateColors.textFieldSearchLight,
                                       ),
                                       child: Image.asset('lib/asset/iconsNewDesign/yourCampus.png',
                                         width: 16,
                                         height: 16,
                                         color: themeController.isDarkMode?Colors.white:MateColors.blackText,
                                       ),
                                     ),
                                     Text('Your Campus',
                                       style: TextStyle(
                                           fontSize: 13,
                                           fontFamily: "Poppins",
                                           fontWeight: FontWeight.w600,
                                           overflow: TextOverflow.ellipsis,
                                           color: themeController.isDarkMode?Colors.white:MateColors.blackText
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
                         padding: const EdgeInsets.only(left: 16,top: 16,bottom: 16),
                         child: Text(
                           "Most Popular",
                           style: TextStyle(
                             fontFamily: 'Poppins',
                             color: themeController.isDarkMode ? Colors.white : Colors.black,
                             fontWeight: FontWeight.w500,
                             fontSize: 16.0,
                           ),
                         ),
                       ),
                       Swiper(
                         itemBuilder: (BuildContext context, int index) {
                           return swipeWidget[index];
                         },
                         itemCount: swipeWidget.length,
                         itemWidth: 800.0,
                         itemHeight: 150.0,
                         layout: SwiperLayout.TINDER,
                       ),
                       SizedBox(height: 150,),
                     ],
                   ),
                 ),
               ),
             ],
           );
          },
        ),
      ),
    );
  }
}
