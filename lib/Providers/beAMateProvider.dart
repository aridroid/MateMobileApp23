import 'dart:io';

import 'package:mate_app/Exceptions/Custom_Exception.dart';
import 'package:mate_app/Model/beAMatePostActiveModel.dart';
import 'package:mate_app/Model/beAMatePostsModel.dart' as bmpm;
import 'package:mate_app/Services/beAMateService.dart';
import 'package:flutter/cupertino.dart';

class BeAMateProvider extends ChangeNotifier{


  /// initialization

  BeAMateService _beAMateService;
  String _apiError = "";
  Map<String, dynamic> _validationErrors = Map();
  bmpm.BeAMatePostsModel _beAMatePostsModelData;
  List<bmpm.Result> _beAMatePostsDataList = [];
  // BeAMatePostsModel beAMatePostsBookmarkData;
  // BeAMatePostsModel beAMateByAuthUserData;
  BeAMatePostActiveModel _beAMateActiveData;
  // BeAMatePostBookmarkModel _bookmarkPostData;
  // BeAMateCommentFetchModel _commentFetchData;

  /// initializing loader status
  bool _beAMatePostLoader = false;
  bool _beAMatePostBookmarkLoader = false;
  bool _uploadPostLoader = false;
  bool _likeAPostLoader = false;
  bool _bookmarkAPostLoader = false;
  bool _fetchCommentsLoader = false;
  bool _postCommentsLoader = false;
  bool _postShareLoader = false;


  ///constructor
  BeAMateProvider() {
    _beAMateService = BeAMateService();
  }


  ///getters

  bool get beAMatePostLoader => _beAMatePostLoader;
  bool get beAMatePostBookmarkLoader => _beAMatePostBookmarkLoader;
  bool get uploadPostLoader => _uploadPostLoader;
  bool get likeAPostLoader => _likeAPostLoader;
  bool get bookmarkAPostLoader => _bookmarkAPostLoader;
  bool get fetchCommentsLoader => _fetchCommentsLoader;
  bool get postCommentsLoader => _postCommentsLoader;
  bool get postShareLoader => _postShareLoader;
  List<bmpm.Result> get beAMatePostsDataList => _beAMatePostsDataList;
  bmpm.BeAMatePostsModel get beAMatePostsModelData => _beAMatePostsModelData;
  BeAMatePostActiveModel get beAMateActiveData => _beAMateActiveData;
  // BeAMatePostBookmarkModel get bookmarkPostData => _bookmarkPostData;
  // BeAMateCommentFetchModel get commentFetchData => _commentFetchData;

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

  set beAMatePostLoaderStatus(bool val) {
    if (_beAMatePostLoader != val) {
      _beAMatePostLoader = val;
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

  Future<void> fetchBeAMatePostList({int page, bool paginationCheck=false,}) async {
    error = '';
    _beAMatePostLoader = true;

    if (page == 1) {
      _beAMatePostsDataList.clear();

    }
    print('fetching $page');

    try {
      Map<String, dynamic> queryParams = {"page": page.toString()};

      var data = await _beAMateService.fetchBeAMatePostList(queryParams);
      _beAMatePostsModelData = data;

      List<bmpm.Result> rawFeedList = [];
      for (int i = 0; i < _beAMatePostsModelData.data.result.length; i++) {
        rawFeedList.add(_beAMatePostsModelData.data.result[i]);
      }


      if(paginationCheck){
        _beAMatePostsDataList.addAll(rawFeedList);
        notifyListeners();
      }else if(_beAMatePostsDataList.isEmpty){
        _beAMatePostsDataList.addAll(rawFeedList);
        notifyListeners();
      }
      print("beAMatePostsDataList length ${_beAMatePostsDataList.length}");

    } catch (err) {
      _setError(err);
    } finally {
      _beAMatePostLoader = false;
      notifyListeners();

    }
  }

  Future<void> fetchBeAMatePostBookmarkedList() async {
    error = '';
    _beAMatePostBookmarkLoader = true;

    try {
      var data = await _beAMateService.fetchBeAMatePostBookmarkedList();
      // beAMatePostsBookmarkData = data;

    } catch (err) {
      _setError(err);
    } finally {
      _beAMatePostBookmarkLoader = false;
      notifyListeners();

    }
  }

  Future<void> fetchBeAMatePostByAuthUser(String uuid) async {
    error = '';
    _beAMatePostBookmarkLoader = true;

    try {
      var data = await _beAMateService.fetchBeAMatePostByAuthUser(uuid);
      // beAMateByAuthUserData = data;

    } catch (err) {
      _setError(err);
    } finally {
      _beAMatePostBookmarkLoader = false;
      notifyListeners();

    }
  }





  Future<bool> uploadBeAMatePost(Map<String, dynamic> body) async {
    error = '';
    _uploadPostLoader = true;
    try {
      var data = await _beAMateService.postBeAMate(body);
    } catch (err) {
      _setError(err);
      return false;
    } finally {
      _uploadPostLoader = false;
    }
    return true;
  }

  Future<bool> activeBeAMatePost(int postId, int index, bool isActive) async {
    error = '';
    _likeAPostLoader = true;
    beAMatePostsModelData.data.result[index].toggleLoader=true;
    var data;
    try {
      data = await _beAMateService.activeBeAMatePost(postId, {"is_active": isActive});
      _beAMateActiveData = data;
    } catch (err) {
      _setError(err);
      return false;
    } finally {
      _likeAPostLoader = false;
      beAMatePostsModelData.data.result[index].toggleLoader=false;

    }
    notifyListeners();
    return true;
  }

  Future bookmarkBeAMatePost(int postId, int index) async {
    error = '';
    _bookmarkAPostLoader = true;
    // beAMatePostsModelData.data.result[index].bookmarkLoader=true;
    var data;
    try {
      data = await _beAMateService.bookmarkBeAMatePost(postId);
      // _bookmarkPostData = data;
    } catch (err) {
      _setError(err);
    } finally {
      _bookmarkAPostLoader = false;
      // beAMatePostsModelData.data.result[index].bookmarkLoader=false;

    }
    notifyListeners();
  }


  Future fetchCommentsOfBeAMatePostById(int commentId) async {
    error = '';
    _fetchCommentsLoader = true;
    var data;
    try {
      data = await _beAMateService.fetchCommentsOfBeAMatePostById(commentId);
      // _commentFetchData=data;
    } catch (err) {
      _setError(err);
    } finally {
      _fetchCommentsLoader = false;
    }
    notifyListeners();
  }

  Future fetchCommentsOfABeAMatePost(int postId) async {
    error = '';
    _fetchCommentsLoader = true;
    var data;
    try {
      data = await _beAMateService.fetchCommentsOfBeAMatePost(postId);
      // _commentFetchData=data;
    } catch (err) {
      _setError(err);
    } finally {
      _fetchCommentsLoader = false;
    }
    notifyListeners();
  }



  Future<bool> commentBeAMatePost({int postId, File imageFile, String content, String isAnonymous, int parentId}) async {
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
      // data = await _beAMateService.commentBeAMatePost(formData,postId);
    } catch (err) {
      _setError(err);
    } finally {
      _postCommentsLoader = false;
    }
    // notifyListeners();
    return (data !=null)? true:false;
  }


  Future<bool> shareBeAMatePost(Map<String,dynamic> body,int postId) async {
    error = '';
    _postShareLoader=true;
    var data;
    try {
      data = await _beAMateService.shareBeAMatePost(body,postId);
    } catch (err) {
      _setError(err);
      return false;
    } finally {
      _postShareLoader=false;
    }
    return true;

  }

  Future deleteCommentsOfBeAMatePost(int commentId, int index, {bool isReply=false, int replyIndex}) async {
    error = '';
    if(isReply){
      // _commentFetchData.data.result[index].replies[replyIndex].isDeleting=true;
    }else{
      // _commentFetchData.data.result[index].isDeleting=true;
    }
    var data;
    try {
      data = await _beAMateService.deleteCommentsOfBeAMatePost(commentId);
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

  Future<bool> deleteBeAMatePost(int postId, int index) async {
    error = '';
    // beAMatePostsModelData.data.result[index].deleteLoader=true;
    var data;
    try {
      data = await _beAMateService.deleteBeAMatePost(postId);
    } catch (err) {
      _setError(err);
      return false;
    } finally {
      // beAMatePostsModelData.data.result[index].deleteLoader=false;
    }
    return true;
    // notifyListeners();
  }

}