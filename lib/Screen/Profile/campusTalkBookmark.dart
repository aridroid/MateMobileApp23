import 'package:mate_app/Model/campusTalkPostsModel.dart';
import 'package:mate_app/Providers/campusTalkProvider.dart';
import 'package:mate_app/Utility/Utility.dart';
import 'package:mate_app/Widget/Home/Community/campusTalkRow.dart';
import 'package:mate_app/Widget/Loaders/Shimmer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CampusTalkBookmark extends StatefulWidget {
  const CampusTalkBookmark({Key key}) : super(key: key);

  @override
  _CampusTalkBookmarkState createState() => _CampusTalkBookmarkState();
}

class _CampusTalkBookmarkState extends State<CampusTalkBookmark> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 600), () {
      Provider.of<CampusTalkProvider>(context, listen: false)
          .fetchCampusTalkPostBookmarkedList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: myHexColor,
        body: Consumer<CampusTalkProvider>(

          builder: (ctx, campusTalkProvider, _) {

            if (!campusTalkProvider.talkPostBookmarkLoader && campusTalkProvider.campusTalkPostsBookmarkData!=null) {
              return ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(top: 10),
                  itemCount: campusTalkProvider.campusTalkPostsBookmarkData.data.result.length,
                  // padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                  itemBuilder: (context, index)
                  {
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
                      likesCount: campusTalkData.likesCount
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
                      )));
            }
            if(campusTalkProvider.talkPostBookmarkLoader) {
              return timelineLoader();
            }
            return Container();
          },
        ));
  }
}
