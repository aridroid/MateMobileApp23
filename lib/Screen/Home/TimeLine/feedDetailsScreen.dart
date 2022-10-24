import 'package:mate_app/Providers/FeedProvider.dart';
import 'package:mate_app/Utility/Utility.dart';
import 'package:mate_app/Widget/Home/HomeRow.dart';
import 'package:mate_app/Widget/Loaders/Shimmer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../HomeScreen.dart';

class FeedDetailsScreen extends StatefulWidget {
  final int feedId;

  const FeedDetailsScreen({Key key, this.feedId}) : super(key: key);

  @override
  _FeedDetailsScreenState createState() => _FeedDetailsScreenState();
}

class _FeedDetailsScreenState extends State<FeedDetailsScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 0), () {
      Provider.of<FeedProvider>(context, listen: false).fetchFeedDetails(widget.feedId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myHexColor,
      appBar: AppBar(
        backgroundColor: myHexColor,
        title: Text("Post Details", style: TextStyle(fontSize: 16.0.sp)),
        leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.white,size: 24,),
        onPressed: ()=>Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen(index: 0,))),),
      ),
      body: Consumer<FeedProvider>(
        builder: (ctx, feedProvider, _) {
          print("timline consumer is called");

          if (feedProvider.feedDetailsLoader && feedProvider.feedList.length == 0) {
            return timelineLoader();
          }

          if (feedProvider.error != '') {
            return Center(
                child: Container(
                    color: Colors.red,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${feedProvider.error}',
                        style: TextStyle(color: Colors.white),
                      ),
                    )));
          }

          return feedProvider.feedList.length == 0
              ? Center(
                  child: Text(
                    'Nothing new',
                    style: TextStyle(color: themeController.isDarkMode?Colors.white:Colors.black),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: 1,
                  itemBuilder: (_, index) {
                    return HomeRow(
                      isFeedDetailsPage: true,
                      id: feedProvider.feedList[0].id,
                      feedId: feedProvider.feedList[0].feedId,
                      title: feedProvider.feedList[0].title,
                      feedType: feedProvider.feedList[0].feedTypes,
                      start: feedProvider.feedList[0].start,
                      end: feedProvider.feedList[0].end,
                      calenderDate: feedProvider.feedList[0].feedCreatedAt,
                      description: feedProvider.feedList[0].description,
                      created: feedProvider.feedList[0].created,
                      user: feedProvider.feedList[0].user,
                      location: feedProvider.feedList[0].location,
                      hyperlinkText: feedProvider.feedList[0].hyperlinkText,
                      hyperlink: feedProvider.feedList[0].hyperlink,
                      media: feedProvider.feedList[0].media,
                      isLiked: feedProvider.feedList[0].isLiked,
                      liked: feedProvider.feedList[0].isLiked != null ? true : false,
                      bookMarked: feedProvider.feedList[0].isBookmarked,
                      likeCount: feedProvider.feedList[0].likeCount,
                      bookmarkCount: feedProvider.feedList[0].bookmarkCount,
                      shareCount: feedProvider.feedList[0].shareCount,
                      commentCount: feedProvider.feedList[0].commentCount,
                      isShared: feedProvider.feedList[0].isShared,
                      indexVal: 0,
                    );
                  },
                );
        },
      ),
    );
  }
}
