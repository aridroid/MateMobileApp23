import 'package:mate_app/Providers/campusLiveProvider.dart';
import 'package:mate_app/Utility/Utility.dart';
import 'package:mate_app/Widget/Home/Community/campusLiveRow.dart';
import 'package:mate_app/Widget/Loaders/Shimmer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class CampusLiveByAuthUser extends StatefulWidget {
  final String uuid;

  const CampusLiveByAuthUser({Key key, this.uuid}) : super(key: key);

  @override
  _CampusLiveByAuthUserState createState() => _CampusLiveByAuthUserState();
}

class _CampusLiveByAuthUserState extends State<CampusLiveByAuthUser> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 600), () {
      Provider.of<CampusLiveProvider>(context, listen: false)
          .fetchCampusLiveByAuthUser(widget.uuid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: myHexColor,
        body: Consumer<CampusLiveProvider>(

          builder: (ctx, campusLiveProvider, _) {
            print("timline consumer is called");

            if (!campusLiveProvider.livePostBookmarkLoader && campusLiveProvider.campusLiveByAuthUserData!=null) {
              return PageView.builder(
                // shrinkWrap: true,
                  onPageChanged: (page) {
                    print('PageChanged $page');
                  },
                  scrollDirection: Axis.vertical,
                  itemCount: campusLiveProvider.campusLiveByAuthUserData.data.result.length,
                  // padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                  itemBuilder: (context, index)
                  {
                    String videoUrl;
                    if (campusLiveProvider.campusLiveByAuthUserData.data.result[index].isShared != null) {
                      videoUrl=campusLiveProvider.campusLiveByAuthUserData.data.result[index].isShared.superCharge!=null?
                      "$videoBaseUrl${campusLiveProvider.campusLiveByAuthUserData.data.result[index].isShared.superCharge.url}":
                      "$videoBaseUrl${campusLiveProvider.campusLiveByAuthUserData.data.result[index].isShared.url}";
                    } else {
                      videoUrl="$videoBaseUrl${campusLiveProvider.campusLiveByAuthUserData.data.result[index].url}";
                    }
                    return CampusLiveRow(
                      description: campusLiveProvider.campusLiveByAuthUserData.data.result[index].credit != null
                          ? campusLiveProvider.campusLiveByAuthUserData.data.result[index].description ?? campusLiveProvider.campusLiveByAuthUserData.data.result[index].subject
                          : campusLiveProvider.campusLiveByAuthUserData.data.result[index].subject,
                      created: "${DateFormat.yMMMMEEEEd().format(DateFormat("yyyy-MM-dd").parse(campusLiveProvider.campusLiveByAuthUserData.data.result[index].createdAt, true))}",
                      videoURL: videoUrl,
                      user: campusLiveProvider.campusLiveByAuthUserData.data.result[index].user,
                      postId: campusLiveProvider.campusLiveByAuthUserData.data.result[index].id,
                      isLiked: campusLiveProvider.campusLiveByAuthUserData.data.result[index].isLiked,
                      isBookmarked: campusLiveProvider.campusLiveByAuthUserData.data.result[index].isBookmarked,
                      credit: campusLiveProvider.campusLiveByAuthUserData.data.result[index].credit,
                      creditUrl: '$videoBaseUrl${campusLiveProvider.campusLiveByAuthUserData.data.result[index].creditUrl}',
                      videoPlayerController: VideoPlayerController.network('$videoBaseUrl${campusLiveProvider.campusLiveByAuthUserData.data.result[index].url}')..initialize(),
                      indexVal: index,
                      likeCount: campusLiveProvider.campusLiveByAuthUserData.data.result[index].likesCount,
                      commentCount: campusLiveProvider.campusLiveByAuthUserData.data.result[index].commentsCount,
                      isUsersPostsPage: true,
                      isShared: campusLiveProvider.campusLiveByAuthUserData.data.result[index].isShared,

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
