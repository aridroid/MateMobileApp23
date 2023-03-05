import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mate_app/Model/bookmarkByUserModel.dart';
import 'package:mate_app/Model/feedItemsBookmarkModel.dart';
import 'package:mate_app/Model/feedItemsLikeModel.dart';
import 'package:mate_app/Model/feedLikesDetailsModel.dart';
import 'package:mate_app/Model/feedsCommentFetchModel.dart';
import 'package:mate_app/Model/getStoryModel.dart' as storiesModel;

import '../Exceptions/Custom_Exception.dart';

import '../Model/FeedItem.dart';
import '../Model/FeedType.dart' as feedType;
import '../Services/FeedService.dart';
import 'package:flutter/material.dart';

class FeedProvider with ChangeNotifier {
  /// initialization
  FeedService _feedService;
  List<feedType.FeedType> _feedTypes = [];
  List<FeedItem> _feedItemList = [];
  List<FeedItem> _feedItemListMyCampus = [];
  List<FeedItem> _feedItemListOfUser = [];
  List<FeedItem> feedItem = [];

  // FeedItem _feedDetails;
  String _apiError = "";
  Map<String, dynamic> _validationErrors = Map();
  FeedItemsLikeModel _feedItemsLikeData;
  FeedItemsBookmarkModel _feedItemsBookmarkData;
  BookmarkByUserModel _bookmarkByUserData;
  FeedsCommentFetchModel _commentFetchData;
  List<storiesModel.Result> getStoryList = [];
  FeedLikesDetailsModel _likeDetailsFetchData;

  /// initializing loader status
  bool _feedTypeLoader = false;
  bool _feedLoader = false;
  bool _feedDetailsLoader = false;
  bool _feedPostLoader = false;
  bool _storyPostLoader = false;
  bool _likeAFeedLoader = false;
  bool _allBookmarkedFeedLoader = false;
  bool _fetchCommentsLoader = false;
  bool getStoriesLoader = false;
  bool _fetchLikeDetailsLoader = false;
  bool _feedCommentsLoader = false;
  bool _feedShareLoader = false;
  bool _feedFollowLoader = false;


  // bool isFindAMate = true;

  ///constructor
  FeedProvider() {
    _feedService = FeedService();
  }

  ///getters
  List<feedType.FeedType> get feedTypeList => _feedTypes;

  List<FeedItem> get feedList => _feedItemList;
  List<FeedItem> get feedListMyCampus => _feedItemListMyCampus;

  List<FeedItem> get feedItemListOfUser => _feedItemListOfUser;
  //List<FeedItem> get feedItem => _feedItemListSearch;

  // FeedItem get feedDetails => _feedDetails;

  FeedItemsLikeModel get feedItemsLikeData => _feedItemsLikeData;

  FeedItemsBookmarkModel get feedItemsBookmarkData => _feedItemsBookmarkData;

  BookmarkByUserModel get bookmarkByUserData => _bookmarkByUserData;

  FeedsCommentFetchModel get commentFetchData => _commentFetchData;

  FeedLikesDetailsModel get likeDetailsFetchData => _likeDetailsFetchData;

  bool get feedTypeLoader => _feedTypeLoader;

  bool get feedPostLoader => _feedPostLoader;

  bool get storyPostLoader => _storyPostLoader;

  bool get likeAFeedLoader => _likeAFeedLoader;

  bool get fetchCommentsLoader => _fetchCommentsLoader;

  bool get fetchLikeDetailsLoader => _fetchLikeDetailsLoader;

  bool get postCommentsLoader => _feedCommentsLoader;

  bool get feedShareLoader => _feedShareLoader;

  bool get feedFollowLoader => _feedFollowLoader;

  bool get allbookmarkedFeedLoader => _allBookmarkedFeedLoader;

  bool get feedLoader => _feedLoader;

  bool get feedDetailsLoader => _feedDetailsLoader;

  String get error => _apiError;

  List<storiesModel.Result> get getStoryModel => getStoryList;


  Map<String, dynamic> get validationErrors => _validationErrors;

  ///setters
  set error(String val) {
    _apiError = val;
    notifyListeners();
  }

  set feedTypeList(List<feedType.FeedType> ft) {
    if (_feedTypes != ft) {
      _feedTypes = ft;
      notifyListeners();
    }
  }

  // set feedList(List<FeedItem> fl) {
  //   _feedItemList = fl;
  //   // _feedItemList.addAll(fl);
  //   notifyListeners();
  // }

  set feedTypeLoaderStatus(bool val) {
    if (_feedTypeLoader != val) {
      _feedTypeLoader = val;
      notifyListeners();
    }
  }

  set feedLoaderStatus(bool val) {
    if (_feedLoader != val) {
      _feedLoader = val;
      notifyListeners();
    }
  }

  set feedPostLoaderStatus(bool val) {
    if (_feedPostLoader != val) {
      _feedPostLoader = val;
      notifyListeners();
    }
  }

  set storyPostLoaderStatus(bool val) {
    if (_storyPostLoader != val) {
      _storyPostLoader = val;
      notifyListeners();
    }
  }

  set validationErrors(Map<String, dynamic> error) {
    _validationErrors = error;
    notifyListeners();
  }

  void _setError(err) {
    print('error of type (${err.runtimeType}) in provider $err');
    try {
      if (err is ValidationFailureException) {
        validationErrors = err.validationErrors;
      } else {
        error = err.message.toString();
      }
    } catch (e) {
      error = "Something Went Wrong";
    }
  }

  ///methods
  Future<void> fetchFeedTypes() async {
    feedTypeLoaderStatus = true;
    error = '';
    try {
      var data = await _feedService.fetchFeedTypes();

      List<feedType.FeedType> rawFeedTypes = [];
      for (int i = 0; i < data.length; i++) {
        rawFeedTypes.add(feedType.FeedType.fromJson(data[i]));
      }

      feedTypeList = rawFeedTypes;
    } catch (err) {
      _setError(err);
    } finally {
      feedTypeLoaderStatus = false;
    }
  }

  Future<void> fetchFeedList({@required int page, String feedId, bool paginationCheck = false, bool isFollowingFeeds, String userId}) async {
    error = '';
    feedLoaderStatus = true;

    if (page == 1) {
      if (userId != null) {
        _feedItemListOfUser.clear();
      } else
        _feedItemList.clear();
      // feedList = [];

    }

    print('fetching $page and feedId $feedId');

    try {
      Map<String, dynamic> queryParams = {"page": page.toString()};

      if (feedId != null) {
        queryParams["feed_type_id"] = feedId;
      }

      var data = await _feedService.fetchFeedList(queryParams, isFollowingFeeds: isFollowingFeeds, userId: userId);

      List<FeedItem> rawFeedList = [];
      for (int i = 0; i < data.length; i++) {
        rawFeedList.add(FeedItem.fromJson(data[i]));
      }

      if (userId != null) {
        if (paginationCheck) {
          _feedItemListOfUser.addAll(rawFeedList);
          notifyListeners();
        } else if (_feedItemListOfUser.isEmpty) {
          _feedItemListOfUser.addAll(rawFeedList);
          notifyListeners();
        }
        print("feedList length ${_feedItemListOfUser.length}");
      } else {
        if (paginationCheck) {
          _feedItemList.addAll(rawFeedList);
          notifyListeners();
        } else if (_feedItemList.isEmpty) {
          _feedItemList.addAll(rawFeedList);
          notifyListeners();
        }
        print("feedList length ${_feedItemList.length}");
      }
    } catch (err) {
      // feedList = [];
      _setError(err);
    } finally {
      feedLoaderStatus = false;
    }
  }


  Future<void> fetchFeedListMyCampus({@required int page, String feedId, bool paginationCheck = false, bool isFollowingFeeds, String userId}) async {
    error = '';
    feedLoaderStatus = true;

    if (page == 1) {
      if (userId != null) {
        _feedItemListOfUser.clear();
      } else
        _feedItemListMyCampus.clear();
      // feedList = [];

    }

    print("//////////////////////////////");
    print("Fetching my campus list");
    print('fetching $page and feedId $feedId');

    try {
      Map<String, dynamic> queryParams = {"page": page.toString()};
      queryParams["my_campus"] = 1.toString();

      if (feedId != null) {
        queryParams["feed_type_id"] = feedId;
      }

      var data = await _feedService.fetchFeedListMyCampus(queryParams, isFollowingFeeds: isFollowingFeeds, userId: userId);

      List<FeedItem> rawFeedList = [];
      for (int i = 0; i < data.length; i++) {
        rawFeedList.add(FeedItem.fromJson(data[i]));
      }

      if (userId != null) {
        if (paginationCheck) {
          _feedItemListOfUser.addAll(rawFeedList);
          notifyListeners();
        } else if (_feedItemListOfUser.isEmpty) {
          _feedItemListOfUser.addAll(rawFeedList);
          notifyListeners();
        }
        print("feedList length ${_feedItemListOfUser.length}");
      } else {
        if (paginationCheck) {
          _feedItemListMyCampus.addAll(rawFeedList);
          notifyListeners();
        } else if (_feedItemListMyCampus.isEmpty) {
          _feedItemListMyCampus.addAll(rawFeedList);
          notifyListeners();
        }
        print("feedList length ${_feedItemList.length}");
      }
    } catch (err) {
      // feedList = [];
      _setError(err);
    } finally {
      feedLoaderStatus = false;
    }
  }

  Future<void> fetchFeedDetails(int feedId) async {
    error = '';
    _feedDetailsLoader = true;
    _feedItemList.clear();
    try {
      var data = await _feedService.fetchFeedDetails(feedId);
      print(data);
      _feedItemList.add(data);
    } catch (err) {
      _setError(err);
    } finally {
      _feedDetailsLoader = false;
      notifyListeners();
    }
  }

  Future<bool> likeAFeed(int feedId, int index, int emojiValue) async {
    error = '';
    // _feedItemsLikeData=null;
    // _likeAFeedLoader = true;
     //_feedItemList[index].likeLoader = true;
    var data;
    try {
      data = await _feedService.likeAFeed(feedId, emojiValue);
      //_feedItemsLikeData = data;
    } catch (err) {
      _setError(err);
      return false;
    } finally {
     // _likeAFeedLoader = false;
      //_feedItemList[index].likeLoader = false;
    }
    notifyListeners();
    return true;
  }

  Future bookmarkAFeed(int feedId, int index) async {
    error = '';
    _feedItemList[index].bookmarkLoader = true;
    var data;
    try {
      data = await _feedService.bookmarkAFeed(feedId);
      _feedItemsBookmarkData = data;
    } catch (err) {
      _setError(err);
    } finally {
      _feedItemList[index].bookmarkLoader = false;
    }
    notifyListeners();
  }

  Future allBookmarkedFeed() async {
    error = '';
    _allBookmarkedFeedLoader = true;
    var data;
    try {
      data = await _feedService.allBookmarkedFeed();
      _bookmarkByUserData = data;
    } catch (err) {
      _setError(err);
    } finally {
      _allBookmarkedFeedLoader = false;
    }
    notifyListeners();
  }

  Future<bool> postFeed(
      {@required List<String> id,
        @required String title,
        @required String description,
        @required location,
        String hyperlinkText,
        String hyperlink,
        String feedTypeOther,
        String startDate,
        String endDate,
        String image}) async {
    error = "";
    feedPostLoaderStatus = true;
    validationErrors = Map();

    Map<String, dynamic> userInput = {"title": title, "description": description, "location": location};

    if (id != null) {
      userInput["feed_type_id"] = id;
    }
    if (feedTypeOther != null) {
      userInput["custom_feed_type"] = feedTypeOther;
    }

    if (hyperlinkText!= null && hyperlink!= null) {
      userInput["hyperlinkText"] = hyperlinkText;
      userInput["hyperlink"] = hyperlink;
    }

    if (startDate != null) {
      userInput["start"] = startDate;
    }

    if (endDate != null) {
      userInput["end"] = endDate;
    }

    if (image != null) {
      print('image type is ${image.runtimeType}');
      List media = [];
      media.add(image);
      userInput["media"] = media;
    }

    try {
      print(userInput);
      await _feedService.postAFeed(userInput);
    } catch (err) {
      _setError(err);
      return false;
    } finally {
      feedPostLoaderStatus = false;
    }

    return true;
  }

  Future<bool> updateFeed(
      {@required List<String> id,
        @required String title,
        @required String description,
        @required location,
        @required int feedId,
        String hyperlinkText,
        String hyperlink,
        String feedTypeOther,
        String startDate,
        String endDate,
        String image,
        bool imageDeleted,
      }) async {
    error = "";
    feedPostLoaderStatus = true;
    validationErrors = Map();

    Map<String, dynamic> userInput = {"title": title, "description": description, "location": location};

    if (id != null) {
      userInput["feed_type_id"] = id;
    }
    if (feedTypeOther != null) {
      userInput["custom_feed_type"] = feedTypeOther;
    }

    if (hyperlinkText!= null && hyperlink!= null) {
      userInput["hyperlinkText"] = hyperlinkText;
      userInput["hyperlink"] = hyperlink;
    }

    if (startDate != null) {
      userInput["start"] = startDate;
    }

    if (endDate != null) {
      userInput["end"] = endDate;
    }

    if (imageDeleted) {
      userInput["delete_media"] = true;
    }

    if (image != null) {
      print('image type is ${image.runtimeType}');
      List media = [];
      media.add(image);
      userInput["media"] = media;
    }

    try {
      print(userInput);
      await _feedService.updateAFeed(userInput,feedId);
    } catch (err) {
      _setError(err);
      return false;
    } finally {
      feedPostLoaderStatus = false;
    }

    return true;
  }

  Future<bool> postStory({String text, File imageFile}) async {
    error = "";

    FormData formData;

    Map<String, dynamic> userInput = {};

    if (text != null) {
      userInput["text"] = text;
    }
    if (imageFile != null) {
      var filenames = await MultipartFile.fromFile(File(imageFile.path).path, filename: imageFile.path);
      userInput["media[]"] = filenames;
    }
    try {
      print(userInput);
      formData = FormData.fromMap(userInput);

      await _feedService.postAStory(formData);
    } catch (err) {
      _setError(err);
      return false;
    } finally {
      feedPostLoaderStatus = false;
    }

    return true;
  }

  Future fetchCommentsOfAFeed(int feedId) async {
    error = '';
    _fetchCommentsLoader = true;
    var data;
    try {
      data = await _feedService.fetchCommentsOfAFeed(feedId);
      _commentFetchData = data;
    } catch (err) {
      _setError(err);
    } finally {
      _fetchCommentsLoader = false;
    }
    notifyListeners();
  }


  Future getStories(int page,bool isPagination) async {
    error = '';
    getStoriesLoader = true;
    List<storiesModel.Result> data;
    try {
      data = await _feedService.getStories(page);
      if(isPagination){
        for(int i=0;i<data.length;i++){
          getStoryList.add(data[i]);
        }
      }else{
        getStoryList = data;
      }
    } catch (err) {
      _setError(err);
    } finally {
      getStoriesLoader = false;
    }
    notifyListeners();
  }

  Future<bool> commentAFeed(Map<String, dynamic> body, int feedId) async {
    error = '';
    _feedCommentsLoader = true;
    var data;
    try {
      data = await _feedService.commentAFeed(body, feedId);
    } catch (err) {
      _setError(err);
    } finally {
      _feedCommentsLoader = false;
    }
    // notifyListeners();
    return (data != null) ? true : false;
  }

  Future deleteCommentsOfAFeed(int commentId, int index, {bool isReply = false, int replyIndex}) async {
    error = '';
    if (isReply) {
      _commentFetchData.data.result[index].replies[replyIndex].isDeleting = true;
    } else {
      _commentFetchData.data.result[index].isDeleting = true;
    }
    var data;
    try {
      data = await _feedService.deleteCommentsOfAFeed(commentId);
    } catch (err) {
      _setError(err);
      return false;
    } finally {
      if (isReply) {
        _commentFetchData.data.result[index].replies[replyIndex].isDeleting = true;
      } else {
        _commentFetchData.data.result[index].isDeleting = true;
        _commentFetchData.data.result.any;
      }
    }
    return true;
    // notifyListeners();
  }

  Future<bool> deleteAFeed(
      int feedId,
      /* int index*/
      ) async {
    error = '';
    // campusLivePostsModelData.data.result[index].deleteLoader=true;
    var data;
    try {
      data = await _feedService.deleteAFeed(feedId);
    } catch (err) {
      _setError(err);
      return false;
    } finally {
      // campusLivePostsModelData.data.result[index].deleteLoader=false;
    }
    return true;
    // notifyListeners();
  }

  Future<bool> shareAFeed(Map<String, dynamic> body, int feedId) async {
    error = '';
    _feedShareLoader = true;
    var data;
    try {
      data = await _feedService.shareAFeed(body, feedId);
    } catch (err) {
      _setError(err);
      return false;
    } finally {
      _feedShareLoader = false;
    }
    return true;
  }

  Future<bool> followAFeed(Map<String, dynamic> body, int feedId) async {
    error = '';
    _feedFollowLoader = true;
    var data;
    try {
      data = await _feedService.followAFeed(body, feedId);
    } catch (err) {
      _setError(err);
      return false;
    } finally {
      _feedFollowLoader = false;
    }
    return true;
  }

  Future<bool> unFollowAFeed(Map<String, dynamic> body, int feedId) async {
    error = '';
    _feedFollowLoader = true;
    var data;
    try {
      data = await _feedService.unFollowAFeed(body, feedId);
    } catch (err) {
      _setError(err);
      return false;
    } finally {
      _feedFollowLoader = false;
    }
    return true;
  }

  Future fetchLikeDetailsOfAFeed(int feedId) async {
    error = '';
    _fetchLikeDetailsLoader = true;
    var data;
    try {
      data = await _feedService.fetchLikeDetailsOfAFeed(feedId);
      _likeDetailsFetchData = data;
    } catch (err) {
      _setError(err);
    } finally {
      _fetchLikeDetailsLoader = false;
    }
    notifyListeners();
  }
}
