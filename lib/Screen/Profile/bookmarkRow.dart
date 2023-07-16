import 'package:mate_app/Model/bookmarkByUserModel.dart';
import 'package:mate_app/Screen/Profile/ProfileScreen.dart';
import 'package:mate_app/Screen/Profile/UserProfileScreen.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

import '../../Providers/AuthUserProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mate_app/asset/Colors/MateColors.dart';

// ignore: must_be_immutable

class BookmarkRow extends StatefulWidget {
  String id;
  String feedId;
  String title;
  String description;
  String created;
  User user;
  String location;
  List<Media> media;


  BookmarkRow({required this.id, required this.feedId, required this.title, required this.description, required this.created, required this.user, required this.location, required this.media});

  @override
  _HomeRowState createState() => _HomeRowState(this.id, this.feedId, this.title,this.description, this.created, this.user, this.location, this.media);
}

class _HomeRowState extends State<BookmarkRow> {

  final String id;
  final String feedId;
  final String title;
  final String description;
  final String created;
  final User user;
  final String location;
  final List<Media> media;

  auth.User _currentUser = auth.FirebaseAuth.instance.currentUser!;

  _HomeRowState(this.id, this.feedId, this.title, this.description, this.created, this.user, this.location, this.media);


  @override
  void initState() {
    super.initState();

  }

  List _buildMedia(BuildContext context) {
    List mda = [];

    for (int i = 0; i < media.length; i++) {
      mda.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Image.network(
              media[i].url!,
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }

    return mda;
  }

  @override
  Widget build(BuildContext context) {
    //print('media is::${media.toString()}');

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        InkWell(
          child: ListTile(
            leading: user.photoUrl!.length == 0
                ? CircleAvatar(
              child: Text(
                user.name![0],
              ),
            )
                : CircleAvatar(
              backgroundImage: NetworkImage(
                user.photoUrl!,
              ),
            ),
            title: Text(user.name!, style: TextStyle(fontFamily: 'Quicksand', color: MateColors.activeIcons)),
            subtitle: Text(
              '$created from $location',
              style: TextStyle(color: Colors.white54),
            ),
          ),
          onTap: () {
            // Navigator.push(context, MaterialPageRoute(
            //   builder: (context) => UserProfileScreen(user: this.user,)
            // ));

            if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == user.id) {
              Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
            } else {
              Navigator.of(context).pushNamed(UserProfileScreen.routeName, arguments: {"id": user.id, "name": user.name, "photoUrl": user.photoUrl, "firebaseUid": user.firebaseUid});
            }
          },
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Text(title, textAlign: TextAlign.left, style: TextStyle(fontSize: 18.0, fontFamily: 'Quicksand', fontWeight: FontWeight.w700, color: MateColors.activeIcons)),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Text(
            description,
            style: TextStyle(
              color: Colors.white,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        ..._buildMedia(context),


        /*Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                icon: Icon(
                  Icons.chat_bubble_outline,
                  color: Colors.grey[50],
                  size: 18,
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Chat(currentUserId: _currentUser.uid, peerId: user.firebaseUid, peerAvatar: user.photoUrl, peerName: user.name)));
                }),
            Consumer<FeedProvider>(
              builder: (context, value, child) {
                if (value.feedItemsLikeData != null) {
                  liked = (value.feedItemsLikeData.message == "Feed Liked successfully" && value.feedItemsLikeData.data.feedId == feedId.toString())
                      ? true
                      : (value.feedItemsLikeData.message == "Feed Unliked successfully" && value.feedItemsLikeData.data.feedId == feedId.toString())
                      ? false
                      : liked;
                }
                return IconButton(
                    icon: Icon(
                      Icons.favorite_border,
                      color: liked? Colors.red : Colors.grey[50],
                      size: 18,
                    ),
                    onPressed: () {
                      Provider.of<FeedProvider>(context, listen: false).likeAFeed(feedId);
                    });
              },
            ),
            Consumer<FeedProvider>(
              builder: (context, value, child) {
                if (value.feedItemsBookmarkData != null) {
                  bookMarked = (value.feedItemsBookmarkData.message == "Feed Bookmarked successfully" && value.feedItemsBookmarkData.data.feedId == feedId.toString())
                      ? true
                      : (value.feedItemsBookmarkData.message == "Feed Un-Bookmarked successfully" && value.feedItemsBookmarkData.data.feedId == feedId.toString())
                      ? false
                      : bookMarked;
                }
                return IconButton(
                    icon: Icon(
                      Icons.bookmark_border,
                      color: bookMarked? Colors.red : Colors.grey[50],
                      size: 18,
                    ),
                    onPressed: () {
                      Provider.of<FeedProvider>(context, listen: false).bookmarkAFeed(feedId);
                    });
              },
            ),
            IconButton(
                icon: Icon(
                  Icons.share,
                  color: Colors.grey[50],
                  size: 18,
                ),
                onPressed: () {}),
          ],
        ),*/

      ],
    );
  }
}
