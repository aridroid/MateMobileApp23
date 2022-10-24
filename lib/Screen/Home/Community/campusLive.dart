import 'package:mate_app/Providers/campusLiveProvider.dart';
import 'package:mate_app/Screen/Home/Community/createCampusLivePost.dart';
import 'package:mate_app/Utility/Utility.dart';
import 'package:mate_app/Widget/Home/Community/campusLiveRow.dart';
import 'package:mate_app/Widget/Loaders/Shimmer.dart';
import 'package:mate_app/asset/Colors/MateColors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:sizer/sizer.dart';

class CampusLive extends StatefulWidget {
  const CampusLive({Key key}) : super(key: key);

  @override
  _CampusLiveState createState() => _CampusLiveState();
}

class _CampusLiveState extends State<CampusLive> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 0), () {
      Provider.of<CampusLiveProvider>(context, listen: false).fetchCampusLivePostList();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        backgroundColor: myHexColor,
        body: Consumer<CampusLiveProvider>(
          builder: (ctx, campusLiveProvider, _) {
            print("timline consumer is called");

            if (!campusLiveProvider.livePostLoader && campusLiveProvider.campusLivePostsModelData != null) {
              return campusLiveProvider.campusLivePostsModelData.data.result.length>0? PageView.builder(
                  // shrinkWrap: true,
                  onPageChanged: (page) {
                    print('PageChanged $page');
                  },
                  scrollDirection: Axis.vertical,
                  itemCount: campusLiveProvider.campusLivePostsModelData.data.result.length,
                  // padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                  itemBuilder: (context, index) {
                    String videoUrl;
                    if (campusLiveProvider.campusLivePostsModelData.data.result[index].isShared != null) {
                      videoUrl=campusLiveProvider.campusLivePostsModelData.data.result[index].isShared.superCharge!=null?
                      "$videoBaseUrl${campusLiveProvider.campusLivePostsModelData.data.result[index].isShared.superCharge.url}":
                      "$videoBaseUrl${campusLiveProvider.campusLivePostsModelData.data.result[index].isShared.url}";
                    } else {
                      videoUrl="$videoBaseUrl${campusLiveProvider.campusLivePostsModelData.data.result[index].url}";
                    }
                    print(videoUrl);
                    return CampusLiveRow(
                      description: campusLiveProvider.campusLivePostsModelData.data.result[index].credit != null
                          ? campusLiveProvider.campusLivePostsModelData.data.result[index].description ?? campusLiveProvider.campusLivePostsModelData.data.result[index].subject
                          : campusLiveProvider.campusLivePostsModelData.data.result[index].subject,
                      created: "${DateFormat.yMMMMEEEEd().format(DateFormat("yyyy-MM-dd").parse(campusLiveProvider.campusLivePostsModelData.data.result[index].createdAt, true))}",
                      videoURL: videoUrl,
                      user: campusLiveProvider.campusLivePostsModelData.data.result[index].user,
                      postId: campusLiveProvider.campusLivePostsModelData.data.result[index].id,
                      isLiked: campusLiveProvider.campusLivePostsModelData.data.result[index].isLiked,
                      isBookmarked: campusLiveProvider.campusLivePostsModelData.data.result[index].isBookmarked,
                      credit: campusLiveProvider.campusLivePostsModelData.data.result[index].credit,
                      creditUrl: campusLiveProvider.campusLivePostsModelData.data.result[index].creditUrl != null
                          ? '$videoBaseUrl${campusLiveProvider.campusLivePostsModelData.data.result[index].creditUrl}'
                          : null,
                      videoPlayerController: VideoPlayerController.network('$videoBaseUrl${campusLiveProvider.campusLivePostsModelData.data.result[index].url}')..initialize(),
                      indexVal: index,
                      likeCount: campusLiveProvider.campusLivePostsModelData.data.result[index].likesCount,
                      commentCount: campusLiveProvider.campusLivePostsModelData.data.result[index].commentsCount,
                      isShared: campusLiveProvider.campusLivePostsModelData.data.result[index].isShared,
                      isFollowed: campusLiveProvider.campusLivePostsModelData.data.result[index].isFollowed??false,
                    );
                  })
              :Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateCampusLivePost()));
                        },
                        icon: Icon(Icons.add_circle, color: Colors.grey[700], size: 55.0)),
                    SizedBox(height: 30.0),
                    Text("Tap on the 'add' icon to upload a CampusLive.",style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600, color: Colors.grey[700])),
                  ],
                ),
              );
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
            if (campusLiveProvider.livePostLoader) {
              return timelineLoader();
            }
            return Container();
          },
        ));
  }
}
