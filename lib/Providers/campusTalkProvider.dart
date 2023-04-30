import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:mate_app/Exceptions/Custom_Exception.dart';
import 'package:mate_app/Model/CampusTalkPostCommentUpVoteModel.dart';
import 'package:mate_app/Model/campusTalkCommentFetchModel.dart';
import 'package:mate_app/Model/campusTalkPostBookmarkModel.dart';
import 'package:mate_app/Model/campusTalkPostsModel.dart' as ctpm;
import 'package:mate_app/Model/campusTalkPostsUpVoteModel.dart';
import 'package:mate_app/Services/campusTalkService.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';

class CampusTalkProvider extends ChangeNotifier{


  /// initialization

  CampusTalkService _campusTalkService;
  String _apiError = "";
  Map<String, dynamic> _validationErrors = Map();
  ctpm.CampusTalkPostsModel _campusTalkPostsModelDataTrending;
  ctpm.CampusTalkPostsModel _campusTalkPostsModelDataLatest;
  ctpm.CampusTalkPostsModel _campusTalkPostsModelDataForums;
  ctpm.CampusTalkPostsModel _campusTalkPostsModelDataYourCampus;
  ctpm.CampusTalkPostsModel _campusTalkPostsModelDataSearch;
  ctpm.CampusTalkPostsModel _campusTalkPostsModelDataCard;
  List<ctpm.Result> _campusTalkPostsResultsTrendingList = [];
  List<ctpm.Result> _campusTalkPostsResultsLatestList = [];
  List<ctpm.Result> _campusTalkPostsResultsForumsList = [];
  List<ctpm.Result> _campusTalkPostsResultsYourCampusList = [];
  List<ctpm.Result> _campusTalkPostsResultsListCard = [];
  List<ctpm.Result> _campusTalkByUserPostsResultsList = [];
  List<ctpm.Result> _campusTalkBySearchList = [];
  ctpm.CampusTalkPostsModel campusTalkPostsBookmarkData;
  //CampusTalkPostsModel campusTalkByAuthUserData;
  CampusTalkPostsUpVoteModel _upVotePostData;
  CampusTalkPostCommentUpVoteModel _upVotePostCommentData;
  CampusTalkPostBookmarkModel _bookmarkPostData;
  CampusTalkCommentFetchModel _commentFetchData;

  /// initializing loader status
  bool _talkPostTrendingLoader = false;
  bool _talkPostLatestLoader = false;
  bool _talkPostForumsLoader = false;
  bool _talkPostYourCampusLoader = false;
  bool _talkPostBookmarkLoader = false;
  bool _talkPostByUserLoader = false;
  bool _searchLoader = false;
  bool _uploadPostLoader = false;
  bool _likeAPostLoader = false;
  bool _bookmarkAPostLoader = false;
  bool _fetchCommentsLoader = false;
  bool _postCommentsLoader = false;
  bool _postShareLoader = false;
  bool _postReportLoader = false;


  ///constructor
  CampusTalkProvider() {
    _campusTalkService = CampusTalkService();
  }


  ///getters

  bool get talkPostTrendingLoader => _talkPostTrendingLoader;
  bool get talkPostLatestLoader => _talkPostLatestLoader;
  bool get talkPostForumsLoader => _talkPostForumsLoader;
  bool get talkPostYourCampusLoader => _talkPostYourCampusLoader;
  bool get talkPostBookmarkLoader => _talkPostBookmarkLoader;
  bool get talkPostByUserLoader => _talkPostByUserLoader;
  bool get searchLoader => _searchLoader;
  bool get uploadPostLoader => _uploadPostLoader;
  bool get likeAPostLoader => _likeAPostLoader;
  bool get bookmarkAPostLoader => _bookmarkAPostLoader;
  bool get fetchCommentsLoader => _fetchCommentsLoader;
  bool get postCommentsLoader => _postCommentsLoader;
  bool get postShareLoader => _postShareLoader;
  bool get postReportLoader => _postReportLoader;
  List<ctpm.Result> get campusTalkPostsResultsTrendingList => _campusTalkPostsResultsTrendingList;
  List<ctpm.Result> get campusTalkPostsResultsLatestList => _campusTalkPostsResultsLatestList;
  List<ctpm.Result> get campusTalkPostsResultsForumsList => _campusTalkPostsResultsForumsList;
  List<ctpm.Result> get campusTalkPostsResultsYourCampusList => _campusTalkPostsResultsYourCampusList;
  List<ctpm.Result> get campusTalkPostsResultsListCard => _campusTalkPostsResultsListCard;
  List<ctpm.Result> get campusTalkByUserPostsResultsList => _campusTalkByUserPostsResultsList;
  List<ctpm.Result> get campusTalkBySearchResultsList => _campusTalkBySearchList;
  ctpm.CampusTalkPostsModel get campusTalkPostsModelDataTrending => _campusTalkPostsModelDataTrending;
  ctpm.CampusTalkPostsModel get campusTalkPostsModelDataLatest => _campusTalkPostsModelDataLatest;
  ctpm.CampusTalkPostsModel get campusTalkPostsModelDataForums => _campusTalkPostsModelDataForums;
  ctpm.CampusTalkPostsModel get campusTalkPostsModelDataYourCampus => _campusTalkPostsModelDataYourCampus;
  ctpm.CampusTalkPostsModel get campusTalkPostsModelDataSearch => _campusTalkPostsModelDataSearch;
  CampusTalkPostsUpVoteModel get upVotePostData => _upVotePostData;
  CampusTalkPostCommentUpVoteModel get upVotePostCommentData => _upVotePostCommentData;
  CampusTalkPostBookmarkModel get bookmarkPostData => _bookmarkPostData;
  CampusTalkCommentFetchModel get commentFetchData => _commentFetchData;

  String get error => _apiError;

  Map<String, dynamic> get validationErrors => _validationErrors;


  ///setters
  set error(String val) {
    _apiError = val;
    notifyListeners();
  }

  set validationErrors(Map<String, dynamic> error) {
    _validationErrors = error;
    notifyListeners();
  }

  set campusTalkPostLoaderStatusTrending(bool val) {
    if (_talkPostTrendingLoader != val) {
      _talkPostTrendingLoader = val;
      notifyListeners();
    }
  }

  set campusTalkPostLoaderStatusLatest(bool val) {
    if (_talkPostLatestLoader != val) {
      _talkPostLatestLoader = val;
      notifyListeners();
    }
  }

  set campusTalkPostLoaderStatusForums(bool val) {
    if (_talkPostForumsLoader != val) {
      _talkPostForumsLoader = val;
      notifyListeners();
    }
  }

  set campusTalkPostLoaderStatusYourCampus(bool val) {
    if (_talkPostYourCampusLoader != val) {
      _talkPostYourCampusLoader = val;
      notifyListeners();
    }
  }

  set campusTalkPostLoaderStatusSearch(bool val) {
    if (_searchLoader != val) {
      _searchLoader = val;
      notifyListeners();
    }
  }

  void _setError(err) {
    print('error of type (${err.runtimeType}) in Campus Talk provider $err');
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


  /// methods

  Future<void> fetchCampusTalkPostTendingList({int page, bool paginationCheck=false,}) async {
    error = '';
    _talkPostTrendingLoader = true;

    if (page == 1) {
      _campusTalkPostsResultsTrendingList.clear();
    }
    print('fetching $page');

    try {
      Map<String, dynamic> queryParams = {"page": page.toString(),"type":"trending"};

      var data = await _campusTalkService.fetchCampusTalkPostList(queryParams);
      _campusTalkPostsModelDataTrending = data;

      List<ctpm.Result> rawFeedList = [];
      for (int i = 0; i < _campusTalkPostsModelDataTrending.data.result.length; i++) {
        rawFeedList.add(_campusTalkPostsModelDataTrending.data.result[i]);
      }


      if(paginationCheck){
        _campusTalkPostsResultsTrendingList.addAll(rawFeedList);
        notifyListeners();
      }else if(_campusTalkPostsResultsTrendingList.isEmpty){
        _campusTalkPostsResultsTrendingList.addAll(rawFeedList);
        notifyListeners();
      }
      print("campusTalkPostsResultsList length ${_campusTalkPostsResultsTrendingList.length}");

    } catch (err) {
      _setError(err);
    } finally {
      _talkPostTrendingLoader = false;
      notifyListeners();

    }
  }

  Future<void> fetchCampusTalkPostTLatestList({int page, bool paginationCheck=false,}) async {
    error = '';
    _talkPostLatestLoader = true;

    if (page == 1) {
      _campusTalkPostsResultsLatestList.clear();
    }
    print('fetching $page');

    try {
      Map<String, dynamic> queryParams = {"page": page.toString(),"type":"latest"};

      var data = await _campusTalkService.fetchCampusTalkPostList(queryParams);
      _campusTalkPostsModelDataLatest = data;

      List<ctpm.Result> rawFeedList = [];
      for (int i = 0; i < _campusTalkPostsModelDataLatest.data.result.length; i++) {
        rawFeedList.add(_campusTalkPostsModelDataLatest.data.result[i]);
      }


      if(paginationCheck){
        _campusTalkPostsResultsLatestList.addAll(rawFeedList);
        notifyListeners();
      }else if(_campusTalkPostsResultsLatestList.isEmpty){
        _campusTalkPostsResultsLatestList.addAll(rawFeedList);
        notifyListeners();
      }
      print("campusTalkPostsResultsList length ${_campusTalkPostsResultsLatestList.length}");

    } catch (err) {
      _setError(err);
    } finally {
      _talkPostLatestLoader = false;
      notifyListeners();

    }
  }

  Future<void> fetchCampusTalkPostForumsList({int page, bool paginationCheck=false,String typeKey}) async {
    error = '';
    _talkPostForumsLoader = true;

    if (page == 1) {
      _campusTalkPostsResultsForumsList.clear();
    }
    print('fetching $page');

    try {
      Map<String, dynamic> queryParams = {
        "page": page.toString(),
        if(typeKey!="")
          "type_name":typeKey,
      };

      var data = await _campusTalkService.fetchCampusTalkPostList(queryParams);
      _campusTalkPostsModelDataForums = data;

      List<ctpm.Result> rawFeedList = [];
      for (int i = 0; i < _campusTalkPostsModelDataForums.data.result.length; i++) {
        rawFeedList.add(_campusTalkPostsModelDataForums.data.result[i]);
      }


      if(paginationCheck){
        _campusTalkPostsResultsForumsList.addAll(rawFeedList);
        notifyListeners();
      }else if(_campusTalkPostsResultsForumsList.isEmpty){
        _campusTalkPostsResultsForumsList.addAll(rawFeedList);
        notifyListeners();
      }
      print("campusTalkPostsResultsList length ${_campusTalkPostsResultsForumsList.length}");

    } catch (err) {
      _setError(err);
    } finally {
      _talkPostForumsLoader = false;
      notifyListeners();

    }
  }

  Future<void> fetchCampusTalkPostYourCampusList({int page, bool paginationCheck=false,}) async {
    error = '';
    _talkPostYourCampusLoader = true;

    if (page == 1) {
      _campusTalkPostsResultsYourCampusList.clear();
    }
    print('fetching $page');

    try {
      Map<String, dynamic> queryParams = {"page": page.toString(),"type":"my_campus"};

      var data = await _campusTalkService.fetchCampusTalkPostList(queryParams);
      _campusTalkPostsModelDataYourCampus = data;

      List<ctpm.Result> rawFeedList = [];
      for (int i = 0; i < _campusTalkPostsModelDataYourCampus.data.result.length; i++) {
        rawFeedList.add(_campusTalkPostsModelDataYourCampus.data.result[i]);
      }


      if(paginationCheck){
        _campusTalkPostsResultsYourCampusList.addAll(rawFeedList);
        notifyListeners();
      }else if(_campusTalkPostsResultsYourCampusList.isEmpty){
        _campusTalkPostsResultsYourCampusList.addAll(rawFeedList);
        notifyListeners();
      }
      print("campusTalkPostsResultsList length ${_campusTalkPostsResultsYourCampusList.length}");

    } catch (err) {
      _setError(err);
    } finally {
      _talkPostYourCampusLoader = false;
      notifyListeners();

    }
  }

  Future<void> fetchCampusTalkPostSearchList({
    int page,
    bool paginationCheck=false,
    String searchType,
    String text,
    String typeKey,
  }) async {
    error = '';
    _searchLoader = true;

    if (page == 1) {
      _campusTalkBySearchList.clear();
    }
    print('fetching $page');
    Map<String, dynamic> queryParams;

    try {
      if(searchType=="Global"){
        queryParams = {
          "page": page.toString(),
          "search_text":text,
          if(typeKey!="")
            "type_name":typeKey,
        };
      }else{
        queryParams = {
          "page": page.toString(),
          "type": searchType,
          "search_text":text,
          if(typeKey!="")
            "type_name":typeKey,
        };
      }


      var data = await _campusTalkService.fetchCampusTalkPostList(queryParams);
      _campusTalkPostsModelDataSearch = data;

      List<ctpm.Result> rawFeedList = [];
      for (int i = 0; i < _campusTalkPostsModelDataSearch.data.result.length; i++) {
        rawFeedList.add(_campusTalkPostsModelDataSearch.data.result[i]);
      }


      if(paginationCheck){
        _campusTalkBySearchList.addAll(rawFeedList);
        notifyListeners();
      }else if(_campusTalkBySearchList.isEmpty){
        _campusTalkBySearchList.addAll(rawFeedList);
        notifyListeners();
      }
      print("campusTalkPostsResultsList length ${_campusTalkBySearchList.length}");

    } catch (err) {
      _setError(err);
    } finally {
      _searchLoader = false;
      notifyListeners();
    }
  }

  bool cardLoader = false;
  Future<void> fetchCampusTalkPostListCard() async {
    print('Fetching card list');
    cardLoader = true;
    try {
      Map<String, dynamic> queryParams = {"page": "1"};
      var data = await _campusTalkService.fetchCampusTalkPostList(queryParams);
      _campusTalkPostsModelDataCard = data;
      List<ctpm.Result> rawFeedList = [];
      for (int i = 0; i < _campusTalkPostsModelDataCard.data.result.length; i++) {
        rawFeedList.add(_campusTalkPostsModelDataCard.data.result[i]);
      }
      _campusTalkPostsResultsListCard.addAll(rawFeedList);
      print(_campusTalkPostsResultsListCard);
      notifyListeners();
    }catch (err) {
      print(err);
    }finally {
      cardLoader = false;
      notifyListeners();
    }
  }


  // Future<void> fetchCampusTalkPostDetails(int talkId) async {
  //   error = '';
  //   _talkPostTrendingLoader = true;
  //
  //   try {
  //
  //     var data = await _campusTalkService.fetchCampusTalkPostDetails(talkId);
  //     _campusTalkPostsModelDataTrending = data;
  //
  //   } catch (err) {
  //     _setError(err);
  //   } finally {
  //     _talkPostTrendingLoader = false;
  //     notifyListeners();
  //
  //   }
  // }

  Future<void> fetchCampusTalkPostBookmarkedList() async {
    error = '';
    _talkPostBookmarkLoader = true;

    try {
      var data = await _campusTalkService.fetchCampusTalkPostBookmarkedList();
      campusTalkPostsBookmarkData = data;

    } catch (err) {
      _setError(err);
    } finally {
      _talkPostBookmarkLoader = false;
      notifyListeners();

    }
  }

  Future<void> fetchCampusTalkByAuthUser(String uuid, {int page, bool paginationCheck=false,}) async {
    error = '';
    _talkPostByUserLoader = true;


    if (page == 1) {
      _campusTalkByUserPostsResultsList.clear();

    }
    print('fetching $page');

    try {
      // campusTalkByAuthUserData = data;



        Map<String, dynamic> queryParams = {"page": page.toString()};

        var data = await _campusTalkService.fetchCampusTalkByAuthUser(uuid, queryParams);

        _campusTalkPostsModelDataTrending = data;

        List<ctpm.Result> rawFeedList = [];
        for (int i = 0; i < _campusTalkPostsModelDataTrending.data.result.length; i++) {
          rawFeedList.add(_campusTalkPostsModelDataTrending.data.result[i]);
        }


        if(paginationCheck){
          _campusTalkByUserPostsResultsList.addAll(rawFeedList);
          notifyListeners();
        }else if(_campusTalkByUserPostsResultsList.isEmpty){
          _campusTalkByUserPostsResultsList.addAll(rawFeedList);
          notifyListeners();
        }
        print("campusTalkByUserPostsResultsList length ${_campusTalkByUserPostsResultsList.length}");


    } catch (err) {
      _setError(err);
    } finally {
      _talkPostByUserLoader = false;
      notifyListeners();

    }
  }





  Future<bool> uploadACampusTalkPost(String title, String description, bool isAnonymous,List<String> uuid,String photo,String video,String audio) async {
    error = '';
    _uploadPostLoader = true;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token =  prefs.getString('token');

    Map<String, String> headers = { "Authorization": "Bearer " + token,'Content-Type': 'application/json','accept': 'application/json'};
    final request = new http.MultipartRequest('POST', Uri.parse("https://api.mateapp.us/api/discussion/post"));
    request.headers.addAll(headers);

    String uuidAsString = "";
    for(int i=0;i<uuid.length;i++){
      if(i==0){
        uuidAsString = uuid[0];
      }else{
        uuidAsString = uuidAsString + "," + uuid[i];
      }
    }

    request.fields['title'] = title;
    request.fields['description'] = description;
    request.fields['is_anonymous'] = isAnonymous?"1":"0";
    if(uuid.isNotEmpty)
      request.fields['campus_talk_type_id'] = uuidAsString;

    if(photo!=null){
      request.files.add(await http.MultipartFile.fromPath('photo',photo));
    }
    if(video!=null){
      request.files.add(await http.MultipartFile.fromPath('video',video));
    }
    if(audio!=null){
      request.files.add(await http.MultipartFile.fromPath('audio',audio));
    }

    try {
      // var data = await _campusTalkService.postACampusTalk({
      //   "title":title,
      //   "description": description,
      //   "is_anonymous":isAnonymous,
      //   if(uuid.isNotEmpty)
      //     "campus_talk_type_id":uuid,
      // });
      var response = await request.send();
      response.stream.transform(utf8.decoder).listen((value) {
        log(value);
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }else{
        return false;
      }
    } catch (err) {
      _setError(err);
      return false;
    } finally {
      _uploadPostLoader = false;
    }
  }

  Future<bool> updateACampusTalkPost(
      int id,String title, String description,
      bool isAnonymous,String anonymousUser,List<String> uuid,
      String photo,String video,String audio,
      bool isImageDeleted, bool isVideoDeleted, bool isAudioDeleted,
      ) async {
    error = '';
    _uploadPostLoader = true;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token =  prefs.getString('token');

    Map<String, String> headers = { "Authorization": "Bearer " + token,'Content-Type': 'application/json','accept': 'application/json'};
    final request = new http.MultipartRequest('POST', Uri.parse("https://api.mateapp.us/api/discussion/post/$id/update"));
    request.headers.addAll(headers);

    String uuidAsString = "";
    for(int i=0;i<uuid.length;i++){
      if(i==0){
        uuidAsString = uuid[0];
      }else{
        uuidAsString = uuidAsString + "," + uuid[i];
      }
    }

    request.fields['title'] = title;
    request.fields['description'] = description;
    request.fields['is_anonymous'] = isAnonymous?"1":"0";
    if(uuid.isNotEmpty)
      request.fields['campus_talk_type_id'] = uuidAsString;
    if(anonymousUser!=null)
      request.fields['anonymous_user'] = anonymousUser;
    if(isImageDeleted)
      request.fields['delete_photo'] = "1";
    if(isVideoDeleted)
      request.fields['delete_video'] = "1";
    if(isAudioDeleted)
      request.fields['delete_audio'] = "1";


    if(photo!=null){
      request.files.add(await http.MultipartFile.fromPath('photo',photo));
    }
    if(video!=null){
      request.files.add(await http.MultipartFile.fromPath('video',video));
    }
    if(audio!=null){
      request.files.add(await http.MultipartFile.fromPath('audio',audio));
    }


    try {
      // var data = await _campusTalkService.updateACampusTalk(
      //     {
      //       "title":title,
      //       "description": description,
      //       "is_anonymous":isAnonymous,
      //       if(anonymousUser!=null)
      //         "anonymous_user":anonymousUser,
      //       if(uuid.isNotEmpty)
      //         "campus_talk_type_id":uuid,
      //
      //     },
      //   id,
      // );
      var response = await request.send();
      response.stream.transform(utf8.decoder).listen((value) {
        log(value);
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }else{
        return false;
      }
    } catch (err) {
      _setError(err);
      return false;
    } finally {
      _uploadPostLoader = false;
    }
  }


  Future<bool> upVoteAPost(
      int postId,
      int index,
      {bool isBookmarkedPage=false,
        bool isUserProfile=false,
        bool isTrending = false,
        bool isLatest = false,
        bool isForums = false,
        bool isYourCampus = false,
        bool isListCard = false,
        bool isSearch = false,
      }
      ) async {
    error = '';
    _likeAPostLoader = true;
    isUserProfile?_campusTalkByUserPostsResultsList[index].upVoteLoader=true:
    isBookmarkedPage?campusTalkPostsBookmarkData.data.result[index].upVoteLoader=true:
    isTrending? _campusTalkPostsResultsTrendingList[index].upVoteLoader=true:
    isLatest? _campusTalkPostsResultsLatestList[index].upVoteLoader=true:
    isForums? _campusTalkPostsResultsForumsList[index].upVoteLoader=true:
    isYourCampus? _campusTalkPostsResultsYourCampusList[index].upVoteLoader=true:
    isListCard? _campusTalkPostsResultsListCard[index].upVoteLoader=true:
    isSearch? _campusTalkBySearchList[index].upVoteLoader=true:
        null;
    var data;
    try {
      data = await _campusTalkService.upVoteAPost(postId);
      _upVotePostData = data;
    } catch (err) {
      _setError(err);
      return false;
    } finally {
      _likeAPostLoader = false;
      isUserProfile?_campusTalkByUserPostsResultsList[index].upVoteLoader=false:
      isBookmarkedPage?campusTalkPostsBookmarkData.data.result[index].upVoteLoader=false :
      isTrending? _campusTalkPostsResultsTrendingList[index].upVoteLoader=false:
      isLatest? _campusTalkPostsResultsLatestList[index].upVoteLoader=false:
      isForums? _campusTalkPostsResultsForumsList[index].upVoteLoader=false:
      isYourCampus? _campusTalkPostsResultsYourCampusList[index].upVoteLoader=false:
      isListCard? _campusTalkPostsResultsListCard[index].upVoteLoader=false:
      isSearch? _campusTalkBySearchList[index].upVoteLoader=false:
      null;

    }
    notifyListeners();
    return true;
  }

  Future<bool> downVoteAPost(
      int postId,
      int index,
      {bool isBookmarkedPage=false,
        bool isUserProfile=false,
        bool isTrending = false,
        bool isLatest = false,
        bool isForums = false,
        bool isYourCampus = false,
        bool isListCard = false,
        bool isSearch = false,
      }
      ) async {
    error = '';
    _likeAPostLoader = true;
    isUserProfile?_campusTalkByUserPostsResultsList[index].upVoteLoader=true:
    isBookmarkedPage?campusTalkPostsBookmarkData.data.result[index].upVoteLoader=true:
    isTrending? _campusTalkPostsResultsTrendingList[index].upVoteLoader=true:
    isLatest? _campusTalkPostsResultsLatestList[index].upVoteLoader=true:
    isForums? _campusTalkPostsResultsForumsList[index].upVoteLoader=true:
    isYourCampus? _campusTalkPostsResultsYourCampusList[index].upVoteLoader=true:
    isListCard? _campusTalkPostsResultsListCard[index].upVoteLoader=true:
    isSearch? _campusTalkBySearchList[index].upVoteLoader=true:
    null;
    var data;
    try {
      data = await _campusTalkService.downVoteAPost(postId);
      _upVotePostData = data;
    } catch (err) {
      _setError(err);
      return false;
    } finally {
      _likeAPostLoader = false;
      isUserProfile?_campusTalkByUserPostsResultsList[index].upVoteLoader=false:
      isBookmarkedPage?campusTalkPostsBookmarkData.data.result[index].upVoteLoader=false :
      isTrending? _campusTalkPostsResultsTrendingList[index].upVoteLoader=false:
      isLatest? _campusTalkPostsResultsLatestList[index].upVoteLoader=false:
      isForums? _campusTalkPostsResultsForumsList[index].upVoteLoader=false:
      isYourCampus? _campusTalkPostsResultsYourCampusList[index].upVoteLoader=false:
      isListCard? _campusTalkPostsResultsListCard[index].upVoteLoader=false:
      isSearch? _campusTalkBySearchList[index].upVoteLoader=false:
      null;
    }
    notifyListeners();
    return true;
  }


  Future<bool> upVoteAPostComment({int commentId, int index, bool isReply=false, int replyIndex}) async {
    error = '';
    _likeAPostLoader = true;
    !isReply?
    commentFetchData.data.result[index].upVoteLoader=true:
    commentFetchData.data.result[index].replies[replyIndex].upVoteLoader=true;
    var data;
    try {
      data = await _campusTalkService.upVoteAPostComment(commentId);
      _upVotePostCommentData = data;
    } catch (err) {
      _setError(err);
      return false;
    } finally {
      _likeAPostLoader = false;
      !isReply?
      commentFetchData.data.result[index].upVoteLoader=false:
      commentFetchData.data.result[index].replies[replyIndex].upVoteLoader=false;
    }
    notifyListeners();
    return true;
  }


  Future<bool> bookmarkAPost(int postId, int index,
      {bool isBookmarkedPage=false,
        bool isUserProfile=false,
        bool isTrending = false,
        bool isLatest = false,
        bool isForums = false,
        bool isYourCampus = false,
        bool isListCard = false,
        bool isSearch = false,
      }) async {
    error = '';
    _bookmarkAPostLoader = true;
    isUserProfile?_campusTalkByUserPostsResultsList[index].bookmarkLoader=true:
    isBookmarkedPage?campusTalkPostsBookmarkData.data.result[index].bookmarkLoader=true :
    isTrending? _campusTalkPostsResultsTrendingList[index].bookmarkLoader=true:
    isLatest? _campusTalkPostsResultsLatestList[index].bookmarkLoader=true:
    isForums? _campusTalkPostsResultsForumsList[index].bookmarkLoader=true:
    isYourCampus? _campusTalkPostsResultsYourCampusList[index].bookmarkLoader=true:
    isListCard? _campusTalkPostsResultsListCard[index].bookmarkLoader=true:
    isSearch? _campusTalkBySearchList[index].bookmarkLoader=true:
    null;
    var data;
    try {
      data = await _campusTalkService.bookmarkAPost(postId);
      _bookmarkPostData = data;
    } catch (err) {
      _setError(err);
      return false;
    } finally {
      _bookmarkAPostLoader = false;

      isUserProfile?_campusTalkByUserPostsResultsList[index].bookmarkLoader=false:
      isBookmarkedPage?campusTalkPostsBookmarkData.data.result[index].bookmarkLoader=false :
      isTrending? _campusTalkPostsResultsTrendingList[index].bookmarkLoader=false:
      isLatest? _campusTalkPostsResultsLatestList[index].bookmarkLoader=false:
      isForums? _campusTalkPostsResultsForumsList[index].bookmarkLoader=false:
      isYourCampus? _campusTalkPostsResultsYourCampusList[index].bookmarkLoader=false:
      isListCard? _campusTalkPostsResultsListCard[index].bookmarkLoader=false:
      isSearch? _campusTalkBySearchList[index].bookmarkLoader=false:
      null;
    }
    notifyListeners();
    return true;
  }


  Future fetchCommentsOfACampusTalkById(int commentId) async {
    error = '';
    _fetchCommentsLoader = true;
    var data;
    try {
      data = await _campusTalkService.fetchCommentsOfACampusTalkById(commentId);
      // _commentFetchData=data;
    } catch (err) {
      _setError(err);
    } finally {
      _fetchCommentsLoader = false;
    }
    notifyListeners();
  }

  Future fetchCommentsOfACampusTalk(int postId) async {
    error = '';
    _fetchCommentsLoader = true;
    var data;
    try {
      data = await _campusTalkService.fetchCommentsOfACampusTalk(postId);
      _commentFetchData=data;
    } catch (err) {
      _setError(err);
    } finally {
      _fetchCommentsLoader = false;
    }
    notifyListeners();
  }



  Future<bool> commentACampusTalk({int postId, XFile imageFile, String content, String isAnonymous, int parentId}) async {
    error = '';
    _postCommentsLoader = true;
    var data;
    try {

      FormData formData;
      Map<String, dynamic> body ={"is_anonymous": isAnonymous};
      if(parentId!=null){
        body["parent_id"]=parentId;
      }
      if(content.isNotEmpty){
        body["content"]=content;
      }

      if(imageFile!=null){
        var filenames = await MultipartFile.fromFile(File(imageFile.path).path,
            filename: imageFile.path);

        body["filename"]=filenames;
        formData = FormData.fromMap(body);
      }
      formData = FormData.fromMap(body);
      print(body);
      data = await _campusTalkService.commentACampusTalk(formData,postId);
    } catch (err) {
      _setError(err);
    } finally {
      _postCommentsLoader = false;
    }
    // notifyListeners();
    return (data !=null)? true:false;
  }


  Future<bool> shareACampusTalk(Map<String,dynamic> body,int postId) async {
    error = '';
    _postShareLoader=true;
    var data;
    try {
      data = await _campusTalkService.shareACampusTalk(body,postId);
    } catch (err) {
      _setError(err);
      return false;
    } finally {
      _postShareLoader=false;
    }
    return true;

  }

  Future<bool> reportACampusTalk(Map<String,dynamic> body,int postId) async {
    error = '';
    _postReportLoader=true;
    var data;
    try {
      data = await _campusTalkService.shareACampusTalk(body,postId);
    } catch (err) {
      _setError(err);
      return false;
    } finally {
      _postReportLoader=false;
    }
    return true;

  }



  Future deleteCommentsOfACampusTalk(int commentId, int index, {bool isReply=false, int replyIndex}) async {
    error = '';
    if(isReply){
      _commentFetchData.data.result[index].replies[replyIndex].isDeleting=true;
    }else{
      _commentFetchData.data.result[index].isDeleting=true;
    }
    var data;
    try {
      data = await _campusTalkService.deleteCommentsOfACampusTalk(commentId);
    } catch (err) {
      _setError(err);
      return false;
    } finally {
      if(isReply){
        _commentFetchData.data.result[index].replies[replyIndex].isDeleting=true;
      }else{
        _commentFetchData.data.result[index].isDeleting=true;
      }
    }
    return true;
    // notifyListeners();
  }

  Future<bool> deleteACampusTalk(int postId, int index) async {
    error = '';
    //campusTalkPostsResultsTrendingList[index].deleteLoader=true;
    //campusTalkPostsModelData.data.result[index].deleteLoader=true;
    var data;
    try {
      data = await _campusTalkService.deleteACampusTalk(postId);
    } catch (err) {
      _setError(err);
      return false;
    } finally {
      //campusTalkPostsResultsTrendingList[index].deleteLoader=false;
      //campusTalkPostsModelData.data.result[index].deleteLoader=false;
    }
    return true;
    // notifyListeners();
  }

  Future<bool> hideACampusTalk(int postId, int index) async {
    error = '';
    //campusTalkPostsResultsTrendingList[index].deleteLoader=true;
    //campusTalkPostsModelData.data.result[index].deleteLoader=true;
    var data;
    try {
      data = await _campusTalkService.hideACampusTalk(postId);
    } catch (err) {
      _setError(err);
      return false;
    } finally {
      //campusTalkPostsResultsTrendingList[index].deleteLoader=false;
      //campusTalkPostsModelData.data.result[index].deleteLoader=false;
    }
    return true;
    // notifyListeners();
  }

}