import 'package:mate_app/Providers/campusLiveProvider.dart';
import 'package:mate_app/Utility/Utility.dart';
import 'package:mate_app/Widget/Home/Community/campusLiveRow.dart';
import 'package:mate_app/Widget/Loaders/Shimmer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class CampusLiveBookmark extends StatefulWidget {
  const CampusLiveBookmark({Key key}) : super(key: key);

  @override
  _CampusLiveBookmarkState createState() => _CampusLiveBookmarkState();
}

class _CampusLiveBookmarkState extends State<CampusLiveBookmark> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 600), () {
      Provider.of<CampusLiveProvider>(context, listen: false)
          .fetchCampusLivePostBookmarkedList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: myHexColor,
        body: Consumer<CampusLiveProvider>(

          builder: (ctx, campusLiveProvider, _) {
            print("timline consumer is called");

            if (!campusLiveProvider.livePostBookmarkLoader && campusLiveProvider.campusLivePostsBookmarkData!=null) {
              return PageView.builder(
                // shrinkWrap: true,
                onPageChanged: (page) {
                  print('PageChanged $page');
                },
                scrollDirection: Axis.vertical,
                itemCount: campusLiveProvider.campusLivePostsBookmarkData.data.result.length,
                // padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                itemBuilder: (context, index)
                {
                  String videoUrl;
                  if (campusLiveProvider.campusLivePostsBookmarkData.data.result[index].isShared != null) {
                    videoUrl=campusLiveProvider.campusLivePostsBookmarkData.data.result[index].isShared.superCharge!=null?
                    "$videoBaseUrl${campusLiveProvider.campusLivePostsBookmarkData.data.result[index].isShared.superCharge.url}":
                    "$videoBaseUrl${campusLiveProvider.campusLivePostsBookmarkData.data.result[index].isShared.url}";
                  } else {
                    videoUrl="$videoBaseUrl${campusLiveProvider.campusLivePostsBookmarkData.data.result[index].url}";
                  }
                        return CampusLiveRow(
                          description: campusLiveProvider.campusLivePostsBookmarkData.data.result[index].credit != null
                              ? campusLiveProvider.campusLivePostsBookmarkData.data.result[index].description ?? campusLiveProvider.campusLivePostsBookmarkData.data.result[index].subject
                              : campusLiveProvider.campusLivePostsBookmarkData.data.result[index].subject,
                          created: "${DateFormat.yMMMMEEEEd().format(DateFormat("yyyy-MM-dd").parse(campusLiveProvider.campusLivePostsBookmarkData.data.result[index].createdAt, true))}",
                          videoURL: videoUrl,
                          user: campusLiveProvider.campusLivePostsBookmarkData.data.result[index].user,
                          postId: campusLiveProvider.campusLivePostsBookmarkData.data.result[index].id,
                          isLiked: campusLiveProvider.campusLivePostsBookmarkData.data.result[index].isLiked,
                          isBookmarked: campusLiveProvider.campusLivePostsBookmarkData.data.result[index].isBookmarked,
                          credit: campusLiveProvider.campusLivePostsBookmarkData.data.result[index].credit,
                          creditUrl: '$videoBaseUrl${campusLiveProvider.campusLivePostsBookmarkData.data.result[index].creditUrl}',
                          videoPlayerController: VideoPlayerController.network('$videoBaseUrl${campusLiveProvider.campusLivePostsBookmarkData.data.result[index].url}')..initialize(),
                          indexVal: index,
                          likeCount: campusLiveProvider.campusLivePostsBookmarkData.data.result[index].likesCount,
                          commentCount: campusLiveProvider.campusLivePostsBookmarkData.data.result[index].commentsCount,
                          isBookmarkPage: true,
                          isShared: campusLiveProvider.campusLivePostsBookmarkData.data.result[index].isShared,
                          isFollowed: campusLiveProvider.campusLivePostsBookmarkData.data.result[index].isFollowed??false,
                        );
                      });
            }
            if (campusLiveProvider.error != '') {
              return Center(
                  child: Container(
                      color: Colors.red,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${campusLiveProvider.error}',
                          style: TextStyle(color: Colors.white),
                        ),
                      )));
            }
            if(campusLiveProvider.livePostLoader) {
              return timelineLoader();
            }
            return Container();
          },
        ));
  }
}
