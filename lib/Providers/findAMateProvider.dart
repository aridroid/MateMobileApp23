import 'dart:io';

import 'package:mate_app/Exceptions/Custom_Exception.dart';
import 'package:mate_app/Model/findAMatePostActiveModel.dart';
import 'package:mate_app/Model/findAMatePostsModel.dart' as fampm;
import 'package:mate_app/Services/findAMateService.dart';
import 'package:flutter/cupertino.dart';

class FindAMateProvider extends ChangeNotifier{


  /// initialization

  FindAMateService _findAMateService;
  String _apiError = "";
  Map<String, dynamic> _validationErrors = Map();
  fampm.FindAMatePostsModel _findAMatePostsModelData;
  List<fampm.Result> _findAMatePostsDataList = [];
  fampm.FindAMatePostsModel findAMatePostsBookmarkData;
  // FindAMatePostsModel findAMateByAuthUserData;
  FindAMatePostActiveModel _findAMateActiveData;
  // FindAMatePostBookmarkModel _bookmarkPostData;
  // FindAMateCommentFetchModel _commentFetchData;

  /// initializing loader status
  bool _findAMatePostLoader = false;
  bool _findAMatePostBookmarkLoader = false;
  bool _uploadPostLoader = false;
  bool _likeAPostLoader = false;
  bool _bookmarkAPostLoader = false;
  bool _fetchCommentsLoader = false;
  bool _postCommentsLoader = false;
  bool _postShareLoader = false;


  ///constructor
  FindAMateProvider() {
    _findAMateService = FindAMateService();
  }


  ///getters

  bool get findAMatePostLoader => _findAMatePostLoader;
  bool get findAMatePostBookmarkLoader => _findAMatePostBookmarkLoader;
  bool get uploadPostLoader => _uploadPostLoader;
  bool get likeAPostLoader => _likeAPostLoader;
  bool get bookmarkAPostLoader => _bookmarkAPostLoader;
  bool get fetchCommentsLoader => _fetchCommentsLoader;
  bool get postCommentsLoader => _postCommentsLoader;
  bool get postShareLoader => _postShareLoader;
  List<fampm.Result> get findAMatePostsDataList => _findAMatePostsDataList;
  fampm.FindAMatePostsModel get findAMatePostsModelData => _findAMatePostsModelData;
  FindAMatePostActiveModel get findAMateActiveData => _findAMateActiveData;
  // FindAMatePostBookmarkModel get bookmarkPostData => _bookmarkPostData;
  // FindAMateCommentFetchModel get commentFetchData => _commentFetchData;

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

  set findAMatePostLoaderStatus(bool val) {
    if (_findAMatePostLoader != val) {
      _findAMatePostLoader = val;
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

  Future<void> fetchFindAMatePostList({int page, bool paginationCheck=false,}) async {
    error = '';
    _findAMatePostLoader = true;

    if (page == 1) {
      _findAMatePostsDataList.clear();

    }
    print('fetching $page');

    try {
        Map<String, dynamic> queryParams = {"page": page.toString()};

        var data = await _findAMateService.fetchFindAMatePostList(queryParams);
        _findAMatePostsModelData = data;

        List<fampm.Result> rawFeedList = [];
        for (int i = 0; i < _findAMatePostsModelData.data.result.length; i++) {
          rawFeedList.add(_findAMatePostsModelData.data.result[i]);
        }


        if(paginationCheck){
          _findAMatePostsDataList.addAll(rawFeedList);
          notifyListeners();
        }else if(_findAMatePostsDataList.isEmpty){
          _findAMatePostsDataList.addAll(rawFeedList);
          notifyListeners();
        }
        print("findAMatePostsDataList length ${_findAMatePostsDataList.length}");

    } catch (err) {
      _setError(err);
    } finally {
      _findAMatePostLoader = false;
      notifyListeners();

    }
  }

  Future<void> fetchFindAMatePostBookmarkedList() async {
    error = '';
    _findAMatePostBookmarkLoader = true;

    try {
      var data = await _findAMateService.fetchFindAMatePostBookmarkedList();
      // findAMatePostsBookmarkData = data;

    } catch (err) {
      _setError(err);
    } finally {
      _findAMatePostBookmarkLoader = false;
      notifyListeners();

    }
  }

  Future<void> fetchFindAMatePostByAuthUser(String uuid) async {
    error = '';
    _findAMatePostBookmarkLoader = true;

    try {
      var data = await _findAMateService.fetchFindAMatePostByAuthUser(uuid);
      // findAMateByAuthUserData = data;

    } catch (err) {
      _setError(err);
    } finally {
      _findAMatePostBookmarkLoader = false;
      notifyListeners();

    }
  }





  Future<bool> uploadFindAMatePost(Map<String, dynamic> body) async {
    error = '';
    _uploadPostLoader = true;
    try {
      var data = await _findAMateService.postFindAMate(body);
    } catch (err) {
      _setError(err);
      return false;
    } finally {
      _uploadPostLoader = false;
    }
    return true;
  }


  Future<bool> activeFindAMatePost(int postId, int index, bool isActive) async {
    error = '';
    _likeAPostLoader = true;
    findAMatePostsModelData.data.result[index].toggleLoader=true;
    var data;
    try {
      data = await _findAMateService.activeFindAMatePost(postId, {"is_active": isActive});
      _findAMateActiveData = data;
    } catch (err) {
      _setError(err);
      return false;
    } finally {
      _likeAPostLoader = false;
      findAMatePostsModelData.data.result[index].toggleLoader=false;

    }
    notifyListeners();
    return true;
  }

  Future bookmarkFindAMatePost(int postId, int index) async {
    error = '';
    _bookmarkAPostLoader = true;
    // findAMatePostsModelData.data.result[index].bookmarkLoader=true;
    var data;
    try {
      data = await _findAMateService.bookmarkFindAMatePost(postId);
      // _bookmarkPostData = data;
    } catch (err) {
      _setError(err);
    } finally {
      _bookmarkAPostLoader = false;
      // findAMatePostsModelData.data.result[index].bookmarkLoader=false;

    }
    notifyListeners();
  }


  Future fetchCommentsOfFindAMatePostById(int commentId) async {
    error = '';
    _fetchCommentsLoader = true;
    var data;
    try {
      data = await _findAMateService.fetchCommentsOfFindAMatePostById(commentId);
      // _commentFetchData=data;
    } catch (err) {
      _setError(err);
    } finally {
      _fetchCommentsLoader = false;
    }
    notifyListeners();
  }

  Future fetchCommentsOfAFindAMatePost(int postId) async {
    error = '';
    _fetchCommentsLoader = true;
    var data;
    try {
      data = await _findAMateService.fetchCommentsOfFindAMatePost(postId);
      // _commentFetchData=data;
    } catch (err) {
      _setError(err);
    } finally {
      _fetchCommentsLoader = false;
    }
    notifyListeners();
  }



  Future<bool> commentFindAMatePost({int postId, File imageFile, String content, String isAnonymous, int parentId}) async {
    error = '';
    _postCommentsLoader = true;
    var data;
    try {

      // FormData formData;
      // Map<String, dynamic> body ={"content": content, "is_anonymous": isAnonymous};
      // if(parentId!=null){
      //   body["parent_id"]=parentId;
      // }
      //
      // if(imageFile!=null){
      //   var filenames = await MultipartFile.fromFile(File(imageFile.path).path,
      //       filename: imageFile.path);
      //
      //   body["filename"]=filenames;
      //   formData = FormData.fromMap(body);
      // }
      // formData = FormData.fromMap(body);
      //
      // data = await _findAMateService.commentFindAMatePost(formData,postId);
    } catch (err) {
      _setError(err);
    } finally {
      _postCommentsLoader = false;
    }
    // notifyListeners();
    return (data !=null)? true:false;
  }


  Future<bool> shareFindAMatePost(Map<String,dynamic> body,int postId) async {
    error = '';
    _postShareLoader=true;
    var data;
    try {
      data = await _findAMateService.shareFindAMatePost(body,postId);
    } catch (err) {
      _setError(err);
      return false;
    } finally {
      _postShareLoader=false;
    }
    return true;

  }

  Future deleteCommentsOfFindAMatePost(int commentId, int index, {bool isReply=false, int replyIndex}) async {
    error = '';
    if(isReply){
      // _commentFetchData.data.result[index].replies[replyIndex].isDeleting=true;
    }else{
      // _commentFetchData.data.result[index].isDeleting=true;
    }
    var data;
    try {
      data = await _findAMateService.deleteCommentsOfFindAMatePost(commentId);
    } catch (err) {
      _setError(err);
      return false;
    } finally {
      if(isReply){
        // _commentFetchData.data.result[index].replies[replyIndex].isDeleting=true;
      }else{
        // _commentFetchData.data.result[index].isDeleting=true;
      }
    }
    return true;
    // notifyListeners();
  }

  Future<bool> deleteFindAMatePost(int postId, int index) async {
    error = '';
    // findAMatePostsModelData.data.result[index].deleteLoader=true;
    var data;
    try {
      data = await _findAMateService.deleteFindAMatePost(postId);
    } catch (err) {
      _setError(err);
      return false;
    } finally {
      // findAMatePostsModelData.data.result[index].deleteLoader=false;
    }
    return true;
    // notifyListeners();
  }

}