import 'package:mate_app/Model/bookmarkByUserModel.dart';
import 'package:mate_app/Providers/FeedProvider.dart';
import 'package:mate_app/Utility/Utility.dart';
import 'package:mate_app/Widget/Home/HomeRow.dart';
import 'package:mate_app/Widget/Loaders/Shimmer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedsBookmark extends StatefulWidget {
  const FeedsBookmark({Key key}) : super(key: key);

  @override
  _FeedsBookmarkState createState() => _FeedsBookmarkState();
}

class _FeedsBookmarkState extends State<FeedsBookmark> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 600),()=>Provider.of<FeedProvider>(context, listen: false).allBookmarkedFeed());

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: myHexColor,
      body: Consumer<FeedProvider>(

        builder: (context, value, child) {

          if(!value.allbookmarkedFeedLoader && value.bookmarkByUserData!=null && value.bookmarkByUserData.data.feeds!=null){
            return ListView.builder(
              itemCount: value.bookmarkByUserData.data.feeds.length,
              padding: EdgeInsets.only(top: 10,left: 16,right: 16,bottom: 16),
              // padding: EdgeInsets.fromLTRB(16, 5, 16, 5),
              itemBuilder: (context, index) {
                Feeds feeds= value.bookmarkByUserData.data.feeds[index];
                // return BookmarkRow(id: feeds.user.id.toString(), feedId: feeds.id, title: feeds.title, description: feeds.description, created: feeds.created, user: feeds.user, location: feeds.location,
                //     media: feeds.media);
                return HomeRow(
                  id: feeds.id,
                  feedId: feeds.feedId,
                  title: feeds.title,
                  feedType: feeds.feedTypes,
                  start: feeds.start,
                  end: feeds.end,
                  calenderDate: feeds.feedCreatedAt,
                  description: feeds.description,
                  created: feeds.created,
                  user: feeds.user,
                  location: feeds.location,
                  hyperlinkText: feeds.hyperlinkText,
                  hyperlink: feeds.hyperlink,
                  media: feeds.media,
                  liked: feeds.isLiked!=null?true:false,
                  isLiked: feeds.isLiked,
                  bookMarked: feeds.isBookmarked,
                  isFollowed: feeds.isFollowed,
                  isBookmarkedPage: true,
                  likeCount: feeds.likeCount,
                  bookmarkCount: feeds.bookmarkCount,
                  shareCount: feeds.shareCount,
                  commentCount: feeds.commentCount,
                  isShared: feeds.isShared,
                  indexVal: index,
                  pageType: "Bookmark",
                );
              },
            );
          }
          if (value.error != '') {
            return Center(
                child: Container(
                    color: Colors.red,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${value.error}',
                        style: TextStyle(color: Colors.white),
                      ),
                    )));
          }
          if(value.allbookmarkedFeedLoader) {
            return timelineLoader();
          }
          return Container();

        },
      ),
    );
  }
}
