import 'package:flutter/material.dart';

class BackEndAPIRoutes {
  final String _scheme = 'https';
  final String _host = 'api.mateapp.us';
  final String _path = 'api';

  /// call example: loginUri().toString()

  /// auth routes
  Uri loginUri() =>
      Uri(scheme: _scheme, host: _host, path: '$_path/login'); // method POST
  Uri refreshToken() =>
      Uri(scheme: _scheme, host: _host, path: '$_path/token'); // method POST

  /// Profile Routes
  Uri showProfile() =>
      Uri(scheme: _scheme, host: _host, path: '$_path/me'); // method GET
  Uri updateProfile() =>
      Uri(scheme: _scheme, host: _host, path: '$_path/me'); // method POST
  Uri updatePhoto() =>
      Uri(scheme: _scheme, host: _host, path: '$_path/me/photo'); // method POST

  Uri updateCoverPhoto() =>
      Uri(scheme: _scheme, host: _host, path: '$_path/me/coverphoto'); // method POST

  Uri updateAbout() =>
      Uri(scheme: _scheme, host: _host, path: '$_path/me/about'); // method POST
  Uri updateSocieties() => Uri(
      scheme: _scheme, host: _host, path: '$_path/me/societies'); // method POST
  Uri updateAchievements() => Uri(
      scheme: _scheme,
      host: _host,
      path: '$_path/me/achievements'); // method POST
  Uri myClasses() =>
      Uri(scheme: _scheme, host: _host, path: '$_path/me/classes'); //method GET

  Uri getUserInfo(String userId) =>
      Uri(scheme: _scheme, host: _host, path: '$_path/user/getinfo/$userId'); //method GET
  Uri updateUserInfo() =>
      Uri(scheme: _scheme, host: _host, path: '$_path/user/addinfo'); //method POST
  Uri updateNotification() =>
      Uri(scheme: _scheme, host: _host, path: '$_path/notification/toggle-status'); //method POST



  /// Followers Routes
  Uri followUser() =>
      Uri(scheme: _scheme, host: _host, path: '$_path/follow'); // method POST
  Uri unFollowUser() =>
      Uri(scheme: _scheme, host: _host, path: '$_path/unfollow'); // method POST
  Uri followings() => Uri(
      scheme: _scheme, host: _host, path: '$_path/followings'); // method GET
  Uri followers() =>
      Uri(scheme: _scheme, host: _host, path: '$_path/followers'); // method GET

  /// Feeds Routes
  Uri feedTypes() => Uri(
      scheme: _scheme, host: _host, path: '$_path/feeds/types'); // method GET
  Uri feeds([Map<String, dynamic> queryParams]) => Uri(
      scheme: _scheme,
      host: _host,
      path: '$_path/feeds',
      queryParameters: queryParams); // method GET, query params: [feed_type_id]

  Uri feedsMyCampus([Map<String, dynamic> queryParams]) => Uri(
      scheme: _scheme,
      host: _host,
      path: '$_path/feeds',
      queryParameters: queryParams);

  Uri feedDetails(int feedId) => Uri(
      scheme: _scheme,
      host: _host,
      path: '$_path/feed/$feedId');

  Uri likeAFeed(int feedId) =>
      Uri(scheme: _scheme, host: _host, path: '$_path/feed/$feedId/like');

  Uri bookmarkAFeed(int feedId) =>
      Uri(scheme: _scheme, host: _host, path: '$_path/feed/$feedId/bookmark');

  Uri allBookmarkedFeed() =>
      Uri(scheme: _scheme, host: _host, path: '$_path/feed/bookmarkbyuser');

  Uri postAFeed() =>
      Uri(scheme: _scheme, host: _host, path: '$_path/feeds'); // method POST

  Uri postAStory() =>
      Uri(scheme: _scheme, host: _host, path: '$_path/stories'); // method POST

  Uri getStories() =>
      Uri(scheme: _scheme, host: _host, path: '$_path/stories'); //

  Uri fetchCommentsOfAFeed(int feedId) => Uri(
      scheme: _scheme,
      host: _host,
      path: '$_path/feed/$feedId/comment');

  Uri commentAFeed(int feedId) =>
      Uri(scheme: _scheme, host: _host, path: '$_path/feed/$feedId/comment');

  Uri deleteCommentsOfAFeed(int commentId) => Uri(
      scheme: _scheme,
      host: _host,
      path: '$_path/feed/comment/$commentId/delete');

  Uri deleteAFeed(int feedId) => Uri(
      scheme: _scheme,
      host: _host,
      path: '$_path/feed/$feedId/delete');

  Uri shareAFeed(int feedId) =>
      Uri(scheme: _scheme, host: _host, path: '$_path/feed/share/$feedId');

  Uri followAFeed(int feedId) =>
      Uri(scheme: _scheme, host: _host, path: '$_path/follow/post');

  Uri unFollowAFeed(int feedId) =>
      Uri(scheme: _scheme, host: _host, path: '$_path/unfollow/post');




  Uri fetchFollowerFeeds([Map<String, dynamic> queryParams]) => Uri(
      scheme: _scheme,
      host: _host,
      path: '$_path/feed/followers',
      queryParameters: queryParams);

  Uri fetchUsersFeeds(Map<String, dynamic> queryParams, String userId) => Uri(
      scheme: _scheme,
      host: _host,
      path: '$_path/feeds/user/$userId',
      queryParameters: queryParams);

  Uri fetchLikeDetailsOfAFeed(int feedId) => Uri(
      scheme: _scheme,
      host: _host,
      path: '$_path/feed/$feedId/like');



  /// CampusLive Routes
  Uri campusLivePosts() => Uri(
      scheme: _scheme,
      host: _host,
      path: '$_path/posts');

  Uri campusLivePostDetails(int postId) => Uri(
      scheme: _scheme,
      host: _host,
      path: '$_path/post/$postId');



  Uri campusLiveBookmarkPosts() => Uri(
      scheme: _scheme,
      host: _host,
      path: '$_path/post/bookmarkbyuser');

  Uri fetchCampusLiveByAuthUser(String uuid) => Uri(
      scheme: _scheme,
      host: _host,
      path: '$_path/posts/user/$uuid');

  Uri postACampusLive() => Uri(scheme: _scheme, host: _host, path: '$_path/post');

  Uri fetchLikesOfAPost(int postId) => Uri(
      scheme: _scheme,
      host: _host,
      path: '$_path/post/$postId/like/count');

  Uri likeAPost(int postId) =>
      Uri(scheme: _scheme, host: _host, path: '$_path/post/$postId/like');

  Uri bookmarkAPost(int postId) =>
      Uri(scheme: _scheme, host: _host, path: '$_path/post/$postId/bookmark');

  Uri fetchCommentsOfAPostById(int commentId) => Uri(
      scheme: _scheme,
      host: _host,
      path: '$_path/post/$commentId/comment');

  Uri fetchCommentsOfAPost(int postId) => Uri(
      scheme: _scheme,
      host: _host,
      path: '$_path/post/$postId/comment');


  Uri commentAPost(int postId) =>
      Uri(scheme: _scheme, host: _host, path: '$_path/post/$postId/comment');

  Uri superchargeAPost(int postId) =>
      Uri(scheme: _scheme, host: _host, path: '$_path/post/supercharge/$postId');

  Uri shareAPost(int postId) =>
      Uri(scheme: _scheme, host: _host, path: '$_path/post/share/$postId');

  Uri followAPost() =>
      Uri(scheme: _scheme, host: _host, path: '$_path/follow/post');

  Uri unFollowAPost() =>
      Uri(scheme: _scheme, host: _host, path: '$_path/unfollow/post');

  Uri deleteCommentsOfAPost(int commentId) => Uri(
      scheme: _scheme,
      host: _host,
      path: '$_path/commentdelete/$commentId');

  Uri deleteAPost(int postId) => Uri(
      scheme: _scheme,
      host: _host,
      path: '$_path/postdelete/$postId');

  Uri deleteASuperchargePost(int postId) => Uri(
      scheme: _scheme,
      host: _host,
      path: '$_path/post/supercharge/$postId/delete');




  /// CampusTalk Routes
  Uri campusTalkPosts([Map<String, dynamic> queryParams]) => Uri(
      scheme: _scheme,
      host: _host,
      path: '$_path/discussion/posts',
      queryParameters: queryParams);

  Uri campusTalkPostDetails(int talkId) => Uri(
      scheme: _scheme,
      host: _host,
      path: '$_path/discussion/post/$talkId');



  Uri campusTalkBookmarkPosts() => Uri(
      scheme: _scheme,
      host: _host,
      path: '$_path/discussion/post/bookmarkbyuser');

  Uri fetchCampusTalkByAuthUser(String uuid, [Map<String, dynamic> queryParams]) => Uri(
      scheme: _scheme,
      host: _host,
      path: '$_path/discussion/posts/user/$uuid',
      queryParameters: queryParams
  );

  Uri postACampusTalk() => Uri(scheme: _scheme, host: _host, path: '$_path/discussion/post');

  Uri fetchLikesOfACampusTalk(int postId) => Uri(
      scheme: _scheme,
      host: _host,
      path: '$_path/post/$postId/like/count');

  Uri upVoteACampusTalk(int postId) =>
      Uri(scheme: _scheme, host: _host, path: '$_path/discussion/post/$postId/like');

  Uri upVoteACampusTalkComment(int commentId) =>
      Uri(scheme: _scheme, host: _host, path: '$_path/discussion/comment/$commentId/like');



  Uri bookmarkACampusTalk(int postId) =>
      Uri(scheme: _scheme, host: _host, path: '$_path/discussion/post/$postId/bookmark');

  Uri fetchCommentsOfACampusTalkById(int commentId) => Uri(
      scheme: _scheme,
      host: _host,
      path: '$_path/post/$commentId/comment');

  Uri fetchCommentsOfACampusTalk(int postId) => Uri(
      scheme: _scheme,
      host: _host,
      path: '$_path/discussion/post/$postId/comment');


  Uri commentACampusTalk(int postId) =>
      Uri(scheme: _scheme, host: _host, path: '$_path/discussion/post/$postId/comment');

  Uri shareACampusTalk(int postId) =>
      Uri(scheme: _scheme, host: _host, path: '$_path/post/share/$postId');

  Uri reportACampusTalk(int postId) =>
      Uri(scheme: _scheme, host: _host, path: '$_path/post/share/$postId');



  Uri deleteCommentsOfACampusTalk(int commentId) => Uri(
      scheme: _scheme,
      host: _host,
      path: '$_path/discussion/commentdelete/$commentId');

  Uri deleteACampusTalk(int postId) => Uri(
      scheme: _scheme,
      host: _host,
      path: '$_path/discussion/postdelete/$postId');





  /// BeAMate Routes
  Uri beAMatePosts([Map<String, dynamic> queryParams]) => Uri(
      scheme: _scheme,
      host: _host,
      path: '$_path/bemate/posts',
      queryParameters: queryParams);

  Uri beAMateBookmarkPosts() => Uri(
      scheme: _scheme,
      host: _host,
      path: '$_path/post/bookmarkbyuser');

  Uri fetchBeAMatePostByAuthUser(String uuid) => Uri(
      scheme: _scheme,
      host: _host,
      path: '$_path/posts/user/$uuid');

  Uri postBeAMate() => Uri(scheme: _scheme, host: _host, path: '$_path/bemate/post');

  Uri fetchLikesOfBeAMatePost(int postId) => Uri(
      scheme: _scheme,
      host: _host,
      path: '$_path/post/$postId/like/count');

  Uri activeBeAMatePost(int postId) =>
      Uri(scheme: _scheme, host: _host, path: '$_path/bemate/post/$postId/setaction');

  Uri bookmarkBeAMatePost(int postId) =>
      Uri(scheme: _scheme, host: _host, path: '$_path/post/$postId/bookmark');

  Uri fetchCommentsOfBeAMatePostById(int commentId) => Uri(
      scheme: _scheme,
      host: _host,
      path: '$_path/post/$commentId/comment');

  Uri fetchCommentsOfBeAMatePost(int postId) => Uri(
      scheme: _scheme,
      host: _host,
      path: '$_path/discussion/post/$postId/comment');


  Uri commentBeAMatePost(int postId) =>
      Uri(scheme: _scheme, host: _host, path: '$_path/discussion/post/$postId/comment');

  Uri shareBeAMatePost(int postId) =>
      Uri(scheme: _scheme, host: _host, path: '$_path/post/share/$postId');

  Uri deleteCommentsOfBeAMatePost(int commentId) => Uri(
      scheme: _scheme,
      host: _host,
      path: '$_path/discussion/commentdelete/$commentId');

  Uri deleteBeAMatePost(int postId) => Uri(
      scheme: _scheme,
      host: _host,
      path: '$_path/bemate/post/$postId/delete');





  /// FindAMate Routes
  Uri findAMatePosts() => Uri(
      scheme: _scheme,
      host: _host,
      path: '$_path/findmate/posts');

  Uri findAMateBookmarkPosts() => Uri(
      scheme: _scheme,
      host: _host,
      path: '$_path/post/bookmarkbyuser');

  Uri fetchFindAMatePostByAuthUser(String uuid) => Uri(
      scheme: _scheme,
      host: _host,
      path: '$_path/posts/user/$uuid');

  Uri postFindAMate() => Uri(scheme: _scheme, host: _host, path: '$_path/findmate/post');

  Uri fetchLikesOfFindAMatePost(int postId) => Uri(
      scheme: _scheme,
      host: _host,
      path: '$_path/post/$postId/like/count');

  Uri activeFindAMatePost(int postId) =>
      Uri(scheme: _scheme, host: _host, path: '$_path/findmate/post/$postId/setaction');

  Uri bookmarkFindAMatePost(int postId) =>
      Uri(scheme: _scheme, host: _host, path: '$_path/post/$postId/bookmark');

  Uri fetchCommentsOfFindAMatePostById(int commentId) => Uri(
      scheme: _scheme,
      host: _host,
      path: '$_path/post/$commentId/comment');

  Uri fetchCommentsOfFindAMatePost(int postId) => Uri(
      scheme: _scheme,
      host: _host,
      path: '$_path/discussion/post/$postId/comment');


  Uri commentFindAMatePost(int postId) =>
      Uri(scheme: _scheme, host: _host, path: '$_path/discussion/post/$postId/comment');

  Uri shareFindAMatePost(int postId) =>
      Uri(scheme: _scheme, host: _host, path: '$_path/post/share/$postId');

  Uri deleteCommentsOfFindAMatePost(int commentId) => Uri(
      scheme: _scheme,
      host: _host,
      path: '$_path/discussion/commentdelete/$commentId');

  Uri deleteFindAMatePost(int postId) => Uri(
      scheme: _scheme,
      host: _host,
      path: '$_path/findmate/post/$postId/delete');



  /// PostsReports Routes
  Uri reportPost() =>
      Uri(scheme: _scheme, host: _host, path: '$_path/report');

  Uri blockUser() =>
      Uri(scheme: _scheme, host: _host, path: '$_path/user/report');

  Uri appUpdate() =>
      Uri(scheme: _scheme, host: _host, path: '$_path/getappversion');



  /// chatData Routes

  Uri personalChatDataFetch(String uid) =>
      Uri(scheme: _scheme, host: _host, path: '$_path/chat/get-personal-chat-rooms/$uid');

  Uri groupChatDataFetch(String uid) =>
      Uri(scheme: _scheme, host: _host, path: '$_path/chat/get-group-chat-rooms/$uid');

  Uri personalChatDataUpdate() =>
      Uri(scheme: _scheme, host: _host, path: '$_path/chat/update-personal-chat-data');

  Uri groupChatDataUpdate() =>
      Uri(scheme: _scheme, host: _host, path: '$_path/chat/update-group-chat-data');

  Uri personalChatMessageReadUpdate() =>
      Uri(scheme: _scheme, host: _host, path: '$_path/chat/update-personal-chat-message-read-status');

  Uri groupChatMessageReadUpdate() =>
      Uri(scheme: _scheme, host: _host, path: '$_path/chat/update-group-chat-message-read-status');










  /// ExternalSharePost Routes
  Uri externalSharePost() =>
      Uri(scheme: _scheme, host: _host, path: '$_path/share');







  ///---------------------------------------------------------------------------------------------------
  ///---------------------------------------------------------------------------------------------------

  /// Users Routes
  Uri findUserById({@required String id}) =>
      Uri(scheme: _scheme, host: _host, path: '$_path/users/' + id);
  Uri userSearch([Map<String, dynamic> queryParams]) => Uri(
      scheme: _scheme,
      host: _host,
      path: '$_path/users',
      queryParameters:
          queryParams); //method GET, query params: [search, per_page=numeric/all]

  ///Classes Routes
  Uri classSearch([Map<String, dynamic> queryParams]) => Uri(
      scheme: _scheme,
      host: _host,
      path: '$_path/courses/',
      queryParameters:
          queryParams); //method GET, query params: [search, per_page=numeric/all]

  Uri joinClass() =>
      Uri(scheme: _scheme, host: _host, path: '$_path/classes'); //method POST

  Uri classAssgnMents({@required String id}) => Uri(
        scheme: _scheme,
        host: _host,
        path: '$_path/classes/$id/',
      ); //Method GET

  Uri addAssignMents({@required String id}) => Uri(
        scheme: _scheme,
        host: _host,
        path: '$_path/classes/$id/assignments',
      ); //Method POST

  ///study groups routes
  Uri studyGroups([Map<String, dynamic> queryParams]) => Uri(
      scheme: _scheme,
      host: _host,
      path: '$_path/study-groups',
      queryParameters:
          queryParams); //method GET, query params: [search, per_page=numeric/all]
  Uri createStudyGroup() => Uri(
      scheme: _scheme, host: _host, path: '$_path/study-groups'); //method POST
}
