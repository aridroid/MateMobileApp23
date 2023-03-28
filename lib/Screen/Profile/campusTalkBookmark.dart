import 'package:get/get.dart';
import 'package:mate_app/Model/campusTalkPostsModel.dart';
import 'package:mate_app/Providers/campusTalkProvider.dart';
import 'package:mate_app/Widget/Home/Community/campusTalkRow.dart';
import 'package:mate_app/Widget/Loaders/Shimmer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../asset/Colors/MateColors.dart';

class CampusTalkBookmark extends StatefulWidget {
  const CampusTalkBookmark({Key key}) : super(key: key);

  @override
  _CampusTalkBookmarkState createState() => _CampusTalkBookmarkState();
}

class _CampusTalkBookmarkState extends State<CampusTalkBookmark> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 600), () {Provider.of<CampusTalkProvider>(context, listen: false).fetchCampusTalkPostBookmarkedList();});
  }

  @override
  Widget build(BuildContext context) {
    final scH = MediaQuery.of(context).size.height;
    final scW = MediaQuery.of(context).size.width;
    return Consumer<CampusTalkProvider>(
      builder: (ctx, campusTalkProvider, _) {
        if (!campusTalkProvider.talkPostBookmarkLoader && campusTalkProvider.campusTalkPostsBookmarkData!=null) {
          return ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 10),
              itemCount: campusTalkProvider.campusTalkPostsBookmarkData.data.result.length,
              itemBuilder: (context, index) {
                Result campusTalkData = campusTalkProvider.campusTalkPostsBookmarkData.data.result[index];
                return CampusTalkRow(
                  isBookmarkedPage: true,
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
                  campusTalkType: campusTalkData.campusTalkTypes,
                  isDisLiked: campusTalkData.isDisliked,
                  disLikeCount: campusTalkData.dislikesCount,
                );
              });
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
              ),
            ),
          );
        }
        if(campusTalkProvider.talkPostBookmarkLoader) {
          return timelineLoader();
        }
        return Container();
      },
    );

    //   Scaffold(
    //   body: Container(
    //     height: scH,
    //     width: scW,
    //     decoration: BoxDecoration(
    //       color: themeController.isDarkMode?Color(0xFF000000):Colors.white,
    //       image: DecorationImage(
    //         image: AssetImage(themeController.isDarkMode?'lib/asset/Background.png':'lib/asset/BackgroundLight.png'),
    //         fit: BoxFit.cover,
    //       ),
    //     ),
    //     child: Column(
    //       children: [
    //         Padding(
    //           padding: EdgeInsets.only(
    //             top: MediaQuery.of(context).size.height*0.07,
    //             left: 16,
    //             right: 16,
    //             bottom: 10,
    //           ),
    //           child: Row(
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             children: [
    //               GestureDetector(
    //                 onTap: (){
    //                   Get.back();
    //                 },
    //                 child: Icon(Icons.arrow_back_ios,
    //                   size: 20,
    //                   color: themeController.isDarkMode ? Colors.white : MateColors.blackTextColor,
    //                 ),
    //               ),
    //               Text(
    //                 "Campus Forum",
    //                 style: TextStyle(
    //                   color: themeController.isDarkMode ? Colors.white : MateColors.blackTextColor,
    //                   fontWeight: FontWeight.w700,
    //                   fontSize: 17.0,
    //                 ),
    //               ),
    //               SizedBox(),
    //             ],
    //           ),
    //         ),
    //         Expanded(
    //           child: Consumer<CampusTalkProvider>(
    //               builder: (ctx, campusTalkProvider, _) {
    //                 if (!campusTalkProvider.talkPostBookmarkLoader && campusTalkProvider.campusTalkPostsBookmarkData!=null) {
    //                   return ListView.builder(
    //                       shrinkWrap: true,
    //                       padding: EdgeInsets.only(top: 10),
    //                       itemCount: campusTalkProvider.campusTalkPostsBookmarkData.data.result.length,
    //                       itemBuilder: (context, index) {
    //                         Result campusTalkData = campusTalkProvider.campusTalkPostsBookmarkData.data.result[index];
    //                         return CampusTalkRow(
    //                             isBookmarkedPage: true,
    //                             talkId: campusTalkData.id,
    //                             description: campusTalkData.description,
    //                             title: campusTalkData.title,
    //                             user: campusTalkData.user,
    //                             isAnonymous: campusTalkData.isAnonymous,
    //                             anonymousUser: campusTalkData.anonymousUser,
    //                             url: campusTalkData.url,
    //                             createdAt: "${DateFormat.yMMMEd().format(DateFormat("yyyy-MM-dd").parse(campusTalkData.createdAt, true))}",
    //                             rowIndex: index,
    //                             isBookmarked: campusTalkData.isBookmarked,
    //                             isLiked: campusTalkData.isLiked,
    //                             likesCount: campusTalkData.likesCount,
    //                             commentsCount: campusTalkData.commentsCount,
    //                         );
    //                       });
    //                 }
    //                 if (campusTalkProvider.error != '') {
    //                   return Center(
    //                     child: Container(
    //                       color: Colors.red,
    //                       child: Padding(
    //                         padding: const EdgeInsets.all(8.0),
    //                         child: Text(
    //                           '${campusTalkProvider.error}',
    //                           style: TextStyle(color: Colors.white),
    //                         ),
    //                       ),
    //                     ),
    //                   );
    //                 }
    //                 if(campusTalkProvider.talkPostBookmarkLoader) {
    //                   return timelineLoader();
    //                 }
    //                 return Container();
    //               },
    //             ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
