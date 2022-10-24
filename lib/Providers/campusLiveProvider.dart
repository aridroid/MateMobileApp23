import 'dart:developer';
import 'dart:io';

import 'package:mate_app/Exceptions/Custom_Exception.dart';
import 'package:mate_app/Model/campusLiveCommentFetchModel.dart';
import 'package:mate_app/Model/campusLivePostBookmark.dart';
import 'package:mate_app/Model/campusLivePostLike.dart';
import 'package:mate_app/Model/campusLivePostsModel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_compress/video_compress.dart';
import '../Services/campusLiveService.dart';

class CampusLiveProvider extends ChangeNotifier{


  /// initialization

  // String campusLivePostData;
  CampusLiveService _campusLiveService;
  String _apiError = "";
  Map<String, dynamic> _validationErrors = Map();
  CampusLivePostsModel campusLivePostsModelData;
  CampusLivePostsModel campusLivePostsBookmarkData;
  CampusLivePostsModel campusLiveByAuthUserData;
  CampusLivePostLikeModel _likePostData;
  CampusLivePostBookmarkModel _bookmarkPostData;
  CampusLiveCommentFetchModel _commentFetchData;

  /// initializing loader status
  bool _livePostLoader = false;
  bool _livePostBookmarkLoader = false;
  bool _uploadPostLoader = false;
  bool _likeAPostLoader = false;
  bool _bookmarkAPostLoader = false;
  bool _fetchCommentsLoader = false;
  bool _postCommentsLoader = false;
  bool _postShareLoader = false;
  bool _postFollowLoader = false;


  ///constructor
  CampusLiveProvider() {
    _campusLiveService = CampusLiveService();
  }


  ///getters

  bool get livePostLoader => _livePostLoader;
  bool get livePostBookmarkLoader => _livePostBookmarkLoader;
  bool get uploadPostLoader => _uploadPostLoader;
  bool get likeAPostLoader => _likeAPostLoader;
  bool get bookmarkAPostLoader => _bookmarkAPostLoader;
  bool get fetchCommentsLoader => _fetchCommentsLoader;
  bool get postCommentsLoader => _postCommentsLoader;
  bool get postShareLoader => _postShareLoader;
  bool get postFollowLoader => _postFollowLoader;
  CampusLivePostLikeModel get likePostData => _likePostData;
  CampusLivePostBookmarkModel get bookmarkPostData => _bookmarkPostData;
  CampusLiveCommentFetchModel get commentFetchData => _commentFetchData;

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

  set campusLivePostLoaderStatus(bool val) {
    if (_livePostLoader != val) {
      _livePostLoader = val;
      notifyListeners();
    }
  }

  void _setError(err) {
    print('error of type (${err.runtimeType}) in Campus Live provider $err');
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

  Future<void> fetchCampusLivePostList() async {
    error = '';
    _livePostLoader = true;

    try {
      var data = await _campusLiveService.fetchCampusLivePostList();
      campusLivePostsModelData = data;

    } catch (err) {
      _setError(err);
    } finally {
      _livePostLoader = false;
      notifyListeners();

    }
  }

  Future<void> fetchCampusLivePostDetails(int postId) async {
    error = '';
    _livePostLoader = true;

    try {
      var data = await _campusLiveService.fetchCampusLivePostDetails(postId);
      campusLivePostsModelData = data;

    } catch (err) {
      _setError(err);
    } finally {
      _livePostLoader = false;
      notifyListeners();

    }
  }

  Future<void> fetchCampusLivePostBookmarkedList() async {
    error = '';
    _livePostBookmarkLoader = true;

    try {
      var data = await _campusLiveService.fetchCampusLivePostBookmarkedList();
      campusLivePostsBookmarkData = data;

    } catch (err) {
      _setError(err);
    } finally {
      _livePostBookmarkLoader = false;
      notifyListeners();

    }
  }

  Future<void> fetchCampusLiveByAuthUser(String uuid) async {
    error = '';
    _livePostBookmarkLoader = true;

    try {
      var data = await _campusLiveService.fetchCampusLiveByAuthUser(uuid);
      campusLiveByAuthUserData = data;

    } catch (err) {
      _setError(err);
    } finally {
      _livePostBookmarkLoader = false;
      notifyListeners();

    }
  }





  Future<bool> uploadACampusLivePost(String subject, File videoFile) async {
    error = '';
    _uploadPostLoader = true;


    try {

      if(videoFile!=null){
        print(videoFile.path);
        /// compress
        await VideoCompress.compressVideo(
          videoFile.path,
          quality: VideoQuality.Res960x540Quality,
          deleteOrigin: false,
          includeAudio: true,
          // duration: 30,
        ).then((value) async{
          var filenames = await MultipartFile.fromFile(File(value.path).path,
              filename: videoFile.path);

          FormData formData =
          FormData.fromMap({"filename": filenames, "subject": subject});

          print(formData);

          var data = await _campusLiveService.postACampusLive(formData);
        });

      }

    } catch (err) {
      _setError(err);
      return false;
    } finally {
      _uploadPostLoader = false;
    }

    return true;
  }


  Future<bool> likeAPost(int postId, int index) async {
    error = '';
    _likeAPostLoader = true;
    campusLivePostsModelData.data.result[index].likeLoader=true;
    var data;
    try {
        data = await _campusLiveService.likeAPost(postId);
        _likePostData = data;
    } catch (err) {
      _setError(err);
      return false;
    } finally {
      _likeAPostLoader = false;
      campusLivePostsModelData.data.result[index].likeLoader=false;

    }
    notifyListeners();
    return true;
  }

  Future bookmarkAPost(int postId, int index) async {
    error = '';
    _bookmarkAPostLoader = true;
    campusLivePostsModelData.data.result[index].bookmarkLoader=true;
    var data;
    try {
        data = await _campusLiveService.bookmarkAPost(postId);
        _bookmarkPostData = data;
    } catch (err) {
      _setError(err);
    } finally {
      _bookmarkAPostLoader = false;
      campusLivePostsModelData.data.result[index].bookmarkLoader=false;

    }
    notifyListeners();
  }


  Future fetchCommentsOfAPostById(int commentId) async {
    error = '';
    _fetchCommentsLoader = true;
    var data;
    try {
        data = await _campusLiveService.fetchCommentsOfAPostById(commentId);
        // _commentFetchData=data;
    } catch (err) {
      _setError(err);
    } finally {
      _fetchCommentsLoader = false;
    }
    notifyListeners();
  }

  Future fetchCommentsOfAPost(int postId) async {
    error = '';
    _fetchCommentsLoader = true;
    var data;
    try {
        data = await _campusLiveService.fetchCommentsOfAPost(postId);
        _commentFetchData=data;
    } catch (err) {
      _setError(err);
    } finally {
      _fetchCommentsLoader = false;
    }
    notifyListeners();
  }



  Future<bool> commentAPost(Map<String, dynamic> body,int postId) async {
    error = '';
    _postCommentsLoader = true;
    var data;
    try {
        data = await _campusLiveService.commentAPost(body,postId);
    } catch (err) {
      _setError(err);
    } finally {
      _postCommentsLoader = false;
    }
    // notifyListeners();
    return (data !=null)? true:false;
  }

  Future<bool> superchargeAPost(int postId,String desc, File videoFile) async {
    error = '';
    _uploadPostLoader=true;
    var data;
    try {

      if(videoFile!=null){
        print(videoFile.path);
        /// compress
        await VideoCompress.compressVideo(
          videoFile.path,
          quality: VideoQuality.Res960x540Quality,
          deleteOrigin: false,
          includeAudio: true,
          // duration: 30,
        ).then((value) async{
          var filenames = await MultipartFile.fromFile(File(value.path).path,
              filename: videoFile.path);

          FormData formData =
          FormData.fromMap({"filename": filenames, "description": desc});

          print(formData.fields);
          print("formData.fields");

          var data = await _campusLiveService.superchargeAPost(postId, formData);
          print(data);
        });

      }
    } catch (err) {
      _setError(err);
      return false;
    } finally {
      _uploadPostLoader=false;
    }
    return true;

  }

  Future<bool> shareAPost(Map<String,dynamic> body,int postId) async {
    error = '';
    _postShareLoader=true;
    var data;
    try {
      data = await _campusLiveService.shareAPost(body,postId);
    } catch (err) {
      _setError(err);
      return false;
    } finally {
      _postShareLoader=false;
    }
    return true;

  }

  Future<bool> followAPost(Map<String,dynamic> body) async {
    error = '';
    _postFollowLoader=true;
    var data;
    try {
      data = await _campusLiveService.followAPost(body);
    } catch (err) {
      _setError(err);
      return false;
    } finally {
      _postFollowLoader=false;
    }
    return true;

  }

  Future<bool> unFollowAPost(Map<String,dynamic> body) async {
    error = '';
    _postFollowLoader=true;
    var data;
    try {
      data = await _campusLiveService.unFollowAPost(body);
    } catch (err) {
      _setError(err);
      return false;
    } finally {
      _postFollowLoader=false;
    }
    return true;

  }



  Future deleteCommentsOfAPost(int commentId, int index, {bool isReply=false, int replyIndex}) async {
    error = '';
    if(isReply){
    _commentFetchData.data.result[index].replies[replyIndex].isDeleting=true;
    }else{
      _commentFetchData.data.result[index].isDeleting=true;
    }
    var data;
    try {
      data = await _campusLiveService.deleteCommentsOfAPost(commentId);
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

  Future<bool> deleteAPost(int postId, int index) async {
    error = '';
    campusLivePostsModelData.data.result[index].deleteLoader=true;
    var data;
    try {
      data = await _campusLiveService.deleteAPost(postId);
    } catch (err) {
      _setError(err);
      return false;
    } finally {
      campusLivePostsModelData.data.result[index].deleteLoader=false;
    }
    return true;
    // notifyListeners();
  }

  Future<bool> deleteASuperchargePost(int postId) async {
    error = '';
    var data;
    try {
      data = await _campusLiveService.deleteASuperchargePost(postId);
    } catch (err) {
      _setError(err);
      return false;
    } finally {
    }
    return true;
  }











}