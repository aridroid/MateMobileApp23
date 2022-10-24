import 'dart:convert';
import 'dart:io';

import 'package:mate_app/Exceptions/Custom_Exception.dart';
import 'package:mate_app/Model/campusLiveCommentFetchModel.dart';
import 'package:mate_app/Model/campusLivePostBookmark.dart';
import 'package:mate_app/Model/campusLivePostLike.dart';
import 'package:mate_app/Model/campusLivePostsModel.dart';
import 'package:dio/dio.dart';

import '../Services/APIService.dart';
import '../Services/BackEndAPIRoutes.dart';

class CampusLiveService {
  APIService _apiService;
  BackEndAPIRoutes _backEndAPIRoutes;

  CampusLiveService() {
    _apiService = APIService();
    _backEndAPIRoutes = BackEndAPIRoutes();
  }


  Future<CampusLivePostsModel> fetchCampusLivePostList() async {
    Uri uri = _backEndAPIRoutes.campusLivePosts();

    try {
      final response = await _apiService.get(uri: uri);

      print(response.body);
      //print('amr type: ${json.decode(response.body)['data']['feeds'].toString()} and url is: ${uri.toString()}');

      return CampusLivePostsModel.fromJson(json.decode(response.body));
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } catch (error) {
      print('error occurred fetching from ${uri.toString()} :: $error');
      throw Exception('$error');
    }
  }

  Future<CampusLivePostsModel> fetchCampusLivePostDetails(int postId) async {
    Uri uri = _backEndAPIRoutes.campusLivePostDetails(postId);

    try {
      final response = await _apiService.get(uri: uri);

      print(response.body);
      //print('amr type: ${json.decode(response.body)['data']['feeds'].toString()} and url is: ${uri.toString()}');

      return CampusLivePostsModel.fromJson(json.decode(response.body));
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } catch (error) {
      print('error occurred fetching from ${uri.toString()} :: $error');
      throw Exception('$error');
    }
  }

  Future<CampusLivePostsModel> fetchCampusLivePostBookmarkedList() async {
    Uri uri = _backEndAPIRoutes.campusLiveBookmarkPosts();

    try {
      final response = await _apiService.post(uri: uri);

      print(response.body);
      //print('amr type: ${json.decode(response.body)['data']['feeds'].toString()} and url is: ${uri.toString()}');

      return CampusLivePostsModel.fromJson(json.decode(response.body));
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } catch (error) {
      print('error occurred fetching from ${uri.toString()} :: $error');
      throw Exception('$error');
    }
  }

  Future<CampusLivePostsModel> fetchCampusLiveByAuthUser(String uuid) async {
    Uri uri = _backEndAPIRoutes.fetchCampusLiveByAuthUser(uuid);

    try {
      final response = await _apiService.get(uri: uri);

      print(response.body);
      //print('amr type: ${json.decode(response.body)['data']['feeds'].toString()} and url is: ${uri.toString()}');

      return CampusLivePostsModel.fromJson(json.decode(response.body));
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } catch (error) {
      print('error occurred fetching from ${uri.toString()} :: $error');
      throw Exception('$error');
    }
  }



  Future postACampusLive(FormData data) async {
    try {
      final response = await _apiService.postWithFormData(
          uri: _backEndAPIRoutes.postACampusLive(), formData: data);
      print("video upload response");
      print(response);
      return response.data.toString();
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } on ValidationFailureException catch (error) {
      throw error;
    } catch (error) {
      print(
          'error occurred fetching from ${_backEndAPIRoutes.postACampusLive().toString()} :: $error');
      throw Exception('$error');
    }
  }

  Future fetchLikesOfAPost(int postId) async {
    Uri uri = _backEndAPIRoutes.fetchLikesOfAPost(postId);

    try {
      final response = await _apiService.get(uri: uri);

      //print('amr type: ${json.decode(response.body)['data']['feeds'].toString()} and url is: ${uri.toString()}');

      return json.decode(response.body);
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } catch (error) {
      print('error occurred fetching from ${uri.toString()} :: $error');
      throw Exception('$error');
    }
  }

  Future<CampusLivePostLikeModel> likeAPost(int postId) async {
    try {
      final response = await _apiService.post(
          uri: _backEndAPIRoutes.likeAPost(postId));

      return CampusLivePostLikeModel.fromJson(json.decode(response.body));
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } on ValidationFailureException catch (error) {
      throw error;
    } catch (error) {
      print(
          'error occurred fetching from ${_backEndAPIRoutes.likeAPost(postId).toString()} :: $error');
      throw Exception('$error');
    }
  }

  Future<CampusLivePostBookmarkModel> bookmarkAPost(int postId) async {
    try {
      final response = await _apiService.post(
          uri: _backEndAPIRoutes.bookmarkAPost(postId));

      return CampusLivePostBookmarkModel.fromJson(json.decode(response.body));
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } on ValidationFailureException catch (error) {
      throw error;
    } catch (error) {
      print(
          'error occurred fetching from ${_backEndAPIRoutes.likeAPost(postId).toString()} :: $error');
      throw Exception('$error');
    }
  }

  Future<CampusLiveCommentFetchModel> fetchCommentsOfAPostById(int commentId) async {
    Uri uri = _backEndAPIRoutes.fetchCommentsOfAPost(commentId);

    try {
      final response = await _apiService.get(uri: uri);

      //print('amr type: ${json.decode(response.body)['data']['feeds'].toString()} and url is: ${uri.toString()}');

      return CampusLiveCommentFetchModel.fromJson(json.decode(response.body));
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } catch (error) {
      print('error occurred fetching from ${uri.toString()} :: $error');
      throw Exception('$error');
    }
  }

  Future<CampusLiveCommentFetchModel> fetchCommentsOfAPost(int postId) async {
    Uri uri = _backEndAPIRoutes.fetchCommentsOfAPost(postId);

    try {
      final response = await _apiService.get(uri: uri);

      //print('amr type: ${json.decode(response.body)['data']['feeds'].toString()} and url is: ${uri.toString()}');

      return CampusLiveCommentFetchModel.fromJson(json.decode(response.body));
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } catch (error) {
      print('error occurred fetching from ${uri.toString()} :: $error');
      throw Exception('$error');
    }
  }





  Future commentAPost(Map<String, dynamic> data, int postId) async {
    try {
      final response = await _apiService.post(
          uri: _backEndAPIRoutes.commentAPost(postId), data: data);

      return json.decode(response.body);
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } on ValidationFailureException catch (error) {
      throw error;
    } catch (error) {
      print(
          'error occurred fetching from ${_backEndAPIRoutes.commentAPost(postId).toString()} :: $error');
      throw Exception('$error');
    }
  }

  Future superchargeAPost(int postId, FormData formData) async {
    try {
      final response = await _apiService.postWithFormData(
          uri: _backEndAPIRoutes.superchargeAPost(postId),formData: formData,);

      print("video upload response");
      print(response);
      return response.data.toString();
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } on ValidationFailureException catch (error) {
      throw error;
    } catch (error) {
      print(
          'error occurred fetching from ${_backEndAPIRoutes.superchargeAPost(postId).toString()} :: $error');
      throw Exception('$error');
    }
  }

  Future shareAPost(Map<String, dynamic> body,int postId) async {
    try {
      final response = await _apiService.post(
          uri: _backEndAPIRoutes.shareAPost(postId), data: body);

      return json.decode(response.body);
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } on ValidationFailureException catch (error) {
      throw error;
    } catch (error) {
      print(
          'error occurred fetching from ${_backEndAPIRoutes.shareAPost(postId).toString()} :: $error');
      throw Exception('$error');
    }
  }

  Future followAPost(Map<String, dynamic> body) async {
    try {
      final response = await _apiService.post(
          uri: _backEndAPIRoutes.followAPost(), data: body);

      return json.decode(response.body);
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } on ValidationFailureException catch (error) {
      throw error;
    } catch (error) {
      print(
          'error occurred fetching from ${_backEndAPIRoutes.followAPost().toString()} :: $error');
      throw Exception('$error');
    }
  }

  Future unFollowAPost(Map<String, dynamic> body) async {
    try {
      final response = await _apiService.post(
          uri: _backEndAPIRoutes.unFollowAPost(), data: body);

      return json.decode(response.body);
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } on ValidationFailureException catch (error) {
      throw error;
    } catch (error) {
      print(
          'error occurred fetching from ${_backEndAPIRoutes.unFollowAPost().toString()} :: $error');
      throw Exception('$error');
    }
  }



  Future deleteCommentsOfAPost(int commentId) async {
    Uri uri = _backEndAPIRoutes.deleteCommentsOfAPost(commentId);

    try {
      final response = await _apiService.post(uri: uri);

      //print('amr type: ${json.decode(response.body)['data']['feeds'].toString()} and url is: ${uri.toString()}');

      return json.decode(response.body);
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } catch (error) {
      print('error occurred fetching from ${uri.toString()} :: $error');
      throw Exception('$error');
    }
  }

  Future deleteAPost(int postId) async {
    Uri uri = _backEndAPIRoutes.deleteAPost(postId);

    try {
      final response = await _apiService.post(uri: uri);

      //print('amr type: ${json.decode(response.body)['data']['feeds'].toString()} and url is: ${uri.toString()}');

      return json.decode(response.body);
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } catch (error) {
      print('error occurred fetching from ${uri.toString()} :: $error');
      throw Exception('$error');
    }
  }

  Future deleteASuperchargePost(int postId) async {
    Uri uri = _backEndAPIRoutes.deleteASuperchargePost(postId);

    try {
      final response = await _apiService.post(uri: uri);

      return json.decode(response.body);
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } catch (error) {
      print('error occurred fetching from ${uri.toString()} :: $error');
      throw Exception('$error');
    }
  }









}
