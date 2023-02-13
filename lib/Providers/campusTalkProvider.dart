
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

class CampusTalkProvider extends ChangeNotifier{


  /// initialization

  CampusTalkService _campusTalkService;
  String _apiError = "";
  Map<String, dynamic> _validationErrors = Map();
  ctpm.CampusTalkPostsModel _campusTalkPostsModelData;
  List<ctpm.Result> _campusTalkPostsResultsList = [];
  List<ctpm.Result> _campusTalkByUserPostsResultsList = [];
  ctpm.CampusTalkPostsModel campusTalkPostsBookmarkData;
  // CampusTalkPostsModel campusTalkByAuthUserData;
  CampusTalkPostsUpVoteModel _upVotePostData;
  CampusTalkPostCommentUpVoteModel _upVotePostCommentData;
  CampusTalkPostBookmarkModel _bookmarkPostData;
  CampusTalkCommentFetchModel _commentFetchData;

  /// initializing loader status
  bool _talkPostLoader = false;
  bool _talkPostBookmarkLoader = false;
  bool _talkPostByUserLoader = false;
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

  bool get talkPostLoader => _talkPostLoader;
  bool get talkPostBookmarkLoader => _talkPostBookmarkLoader;
  bool get talkPostByUserLoader => _talkPostByUserLoader;
  bool get uploadPostLoader => _uploadPostLoader;
  bool get likeAPostLoader => _likeAPostLoader;
  bool get bookmarkAPostLoader => _bookmarkAPostLoader;
  bool get fetchCommentsLoader => _fetchCommentsLoader;
  bool get postCommentsLoader => _postCommentsLoader;
  bool get postShareLoader => _postShareLoader;
  bool get postReportLoader => _postReportLoader;
  List<ctpm.Result> get campusTalkPostsResultsList => _campusTalkPostsResultsList;
  List<ctpm.Result> get campusTalkByUserPostsResultsList => _campusTalkByUserPostsResultsList;
  ctpm.CampusTalkPostsModel get campusTalkPostsModelData => _campusTalkPostsModelData;
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

  set campusTalkPostLoaderStatus(bool val) {
    if (_talkPostLoader != val) {
      _talkPostLoader = val;
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

  Future<void> fetchCampusTalkPostList({int page, bool paginationCheck=false,}) async {
    error = '';
    _talkPostLoader = true;

    if (page == 1) {
      _campusTalkPostsResultsList.clear();

    }
    print('fetching $page');

    try {
      Map<String, dynamic> queryParams = {"page": page.toString()};

      var data = await _campusTalkService.fetchCampusTalkPostList(queryParams);
      _campusTalkPostsModelData = data;

      List<ctpm.Result> rawFeedList = [];
      for (int i = 0; i < _campusTalkPostsModelData.data.result.length; i++) {
        rawFeedList.add(_campusTalkPostsModelData.data.result[i]);
      }


      if(paginationCheck){
        _campusTalkPostsResultsList.addAll(rawFeedList);
        notifyListeners();
      }else if(_campusTalkPostsResultsList.isEmpty){
        _campusTalkPostsResultsList.addAll(rawFeedList);
        notifyListeners();
      }
      print("campusTalkPostsResultsList length ${_campusTalkPostsResultsList.length}");

    } catch (err) {
      _setError(err);
    } finally {
      _talkPostLoader = false;
      notifyListeners();

    }
  }

  Future<void> fetchCampusTalkPostDetails(int talkId) async {
    error = '';
    _talkPostLoader = true;

    try {

      var data = await _campusTalkService.fetchCampusTalkPostDetails(talkId);
      _campusTalkPostsModelData = data;

    } catch (err) {
      _setError(err);
    } finally {
      _talkPostLoader = false;
      notifyListeners();

    }
  }

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

        _campusTalkPostsModelData = data;

        List<ctpm.Result> rawFeedList = [];
        for (int i = 0; i < _campusTalkPostsModelData.data.result.length; i++) {
          rawFeedList.add(_campusTalkPostsModelData.data.result[i]);
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





  Future<bool> uploadACampusTalkPost(String title, String description, bool isAnonymous) async {
    error = '';
    _uploadPostLoader = true;
    try {
      var data = await _campusTalkService.postACampusTalk({"title":title, "description": description, "is_anonymous":isAnonymous});
    } catch (err) {
      _setError(err);
      return false;
    } finally {
      _uploadPostLoader = false;
    }
    return true;
  }

  Future<bool> updateACampusTalkPost(int id,String title, String description, bool isAnonymous,String anonymousUser) async {
    error = '';
    _uploadPostLoader = true;
    try {
      var data = await _campusTalkService.updateACampusTalk(
          {
            "title":title,
            "description": description,
            "is_anonymous":isAnonymous,
            if(anonymousUser!=null)
              "anonymous_user":anonymousUser,

          },
        id,
      );
    } catch (err) {
      _setError(err);
      return false;
    } finally {
      _uploadPostLoader = false;
    }
    return true;
  }


  Future<bool> upVoteAPost(int postId, int index, {bool isBookmarkedPage=false, bool isUserProfile=false}) async {
    error = '';
    _likeAPostLoader = true;
    isUserProfile?_campusTalkByUserPostsResultsList[index].upVoteLoader=true:
    isBookmarkedPage?campusTalkPostsBookmarkData.data.result[index].upVoteLoader=true:
    _campusTalkPostsResultsList[index].upVoteLoader=true;
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
      isBookmarkedPage?campusTalkPostsBookmarkData.data.result[index].upVoteLoader=false
          :_campusTalkPostsResultsList[index].upVoteLoader=false;

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




  Future<bool> bookmarkAPost(int postId, int index, {bool isBookmarkedPage=false, bool isUserProfile=false}) async {
    error = '';
    _bookmarkAPostLoader = true;
    isUserProfile?_campusTalkByUserPostsResultsList[index].bookmarkLoader=true:
    isBookmarkedPage?campusTalkPostsBookmarkData.data.result[index].bookmarkLoader=true
        :_campusTalkPostsResultsList[index].bookmarkLoader=true;
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
      isBookmarkedPage?campusTalkPostsBookmarkData.data.result[index].bookmarkLoader=false
          :_campusTalkPostsResultsList[index].bookmarkLoader=false;
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
    campusTalkPostsResultsList[index].deleteLoader=true;
    //campusTalkPostsModelData.data.result[index].deleteLoader=true;
    var data;
    try {
      data = await _campusTalkService.deleteACampusTalk(postId);
    } catch (err) {
      _setError(err);
      return false;
    } finally {
      campusTalkPostsResultsList[index].deleteLoader=false;
      //campusTalkPostsModelData.data.result[index].deleteLoader=false;
    }
    return true;
    // notifyListeners();
  }

}