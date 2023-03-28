import 'package:mate_app/Model/campusTalkPostsModel.dart';
import 'package:mate_app/Providers/campusTalkProvider.dart';
import 'package:mate_app/Widget/Home/Community/campusTalkRow.dart';
import 'package:mate_app/Widget/Loaders/Shimmer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mate_app/asset/Colors/MateColors.dart';
import 'package:provider/provider.dart';

class CampusTalkByUser extends StatefulWidget {

  final String uuid;

  const CampusTalkByUser({Key key, @required this.uuid}) : super(key: key);
  
  @override
  _CampusTalkByUserState createState() => _CampusTalkByUserState();
}

class _CampusTalkByUserState extends State<CampusTalkByUser> {
  ScrollController _scrollController;
  int _page;

  void _scrollListener() {
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels != 0) {
        Future.delayed(Duration.zero, () {
          _page += 1;
          print('scrolled to bottom page is now $_page');
          Provider.of<CampusTalkProvider>(context, listen: false).fetchCampusTalkByAuthUser(widget.uuid, page: _page);
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 0), () {
      Provider.of<CampusTalkProvider>(context, listen: false).fetchCampusTalkByAuthUser(widget.uuid, page: 1);
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

        if (campusTalkProvider.talkPostByUserLoader && campusTalkProvider.campusTalkByUserPostsResultsList.length == 0) {
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

        return campusTalkProvider.campusTalkByUserPostsResultsList.length == 0
            ? Center(
          child: Text(
            'Nothing new',
            style: TextStyle(color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor),
          ),
        )
            : RefreshIndicator(
          onRefresh: () {
            _page = 1;
            return campusTalkProvider.fetchCampusTalkByAuthUser(widget.uuid, page: 1);
          },
          child: ListView.builder(
            controller: _scrollController,
            shrinkWrap: true,
            itemCount: campusTalkProvider.campusTalkByUserPostsResultsList.length,
            itemBuilder: (context, index) {
              Result campusTalkData = campusTalkProvider.campusTalkByUserPostsResultsList[index];
              return Visibility(
                visible: true,
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
                  isUserProfile: true,
                  campusTalkType: campusTalkData.campusTalkTypes,
                  isDisLiked: campusTalkData.isDisliked,
                  disLikeCount: campusTalkData.dislikesCount,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
