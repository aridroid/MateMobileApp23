import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:mate_app/Exceptions/Custom_Exception.dart';
import 'package:mate_app/Model/findAMatePostActiveModel.dart';
import 'package:mate_app/Model/findAMatePostsModel.dart';
import 'package:dio/dio.dart';

import 'APIService.dart';
import 'BackEndAPIRoutes.dart';

import 'package:http/http.dart'as http;

class FindAMateService {
  late APIService _apiService;
  late BackEndAPIRoutes _backEndAPIRoutes;

  FindAMateService() {
    _apiService = APIService();
    _backEndAPIRoutes = BackEndAPIRoutes();
  }


  Future<dynamic> fetchFindAMatePostList(Map<String, dynamic> queryParams) async {
    Uri uri = _backEndAPIRoutes.findAMatePosts();

    try {
      final response = await _apiService.get(uri: uri);

      print(response.body);
      //print('amr type: ${json.decode(response.body)['data']['feeds'].toString()} and url is: ${uri.toString()}');

      return FindAMatePostsModel.fromJson(json.decode(response.body));
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } catch (error) {
      print('error occurred fetching from ${uri.toString()} :: $error');
      throw Exception('$error');
    }
  }

  Future<dynamic> fetchFindAMatePostBookmarkedList() async {
    Uri uri = _backEndAPIRoutes.findAMateBookmarkPosts();
    //
    // try {
    //   final response = await _apiService.post(uri: uri);
    //
    //   print(response.body);
    //   //print('amr type: ${json.decode(response.body)['data']['feeds'].toString()} and url is: ${uri.toString()}');
    //
    //   return FindAMatePostsModel.fromJson(json.decode(response.body));
    // } on SocketException catch (error) {
    //   throw Exception('NO INTERNET :: $error');
    // } catch (error) {
    //   print('error occurred fetching from ${uri.toString()} :: $error');
    //   throw Exception('$error');
    // }
  }

  Future<dynamic> fetchFindAMatePostByAuthUser(String uuid) async {
    Uri uri = _backEndAPIRoutes.fetchFindAMatePostByAuthUser(uuid);
    //
    // try {
    //   final response = await _apiService.get(uri: uri);
    //
    //   print(response.body);
    //   //print('amr type: ${json.decode(response.body)['data']['feeds'].toString()} and url is: ${uri.toString()}');
    //
    //   return FindAMatePostsModel.fromJson(json.decode(response.body));
    // } on SocketException catch (error) {
    //   throw Exception('NO INTERNET :: $error');
    // } catch (error) {
    //   print('error occurred fetching from ${uri.toString()} :: $error');
    //   throw Exception('$error');
    // }
  }



  Future postFindAMate(Map<String, dynamic> body) async {
    try {
      final response = await _apiService.post(
          uri: _backEndAPIRoutes.postFindAMate(), data: body);
      print(response);
      return response.body.toString();
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } on ValidationFailureException catch (error) {
      throw error;
    } catch (error) {
      print(
          'error occurred fetching from ${_backEndAPIRoutes.postFindAMate().toString()} :: $error');
      throw Exception('$error');
    }
  }


  Future<dynamic> activeFindAMatePost(int postId, Map<String, dynamic> body) async {
    try {
      final response = await _apiService.post(
          uri: _backEndAPIRoutes.activeFindAMatePost(postId),data: body);

      return FindAMatePostActiveModel.fromJson(json.decode(response.body));
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

  Future<dynamic> bookmarkFindAMatePost(int postId) async {
    // try {
    //   final response = await _apiService.post(
    //       uri: _backEndAPIRoutes.bookmarkFindAMatePost(postId));
    //
    //   return FindAMatePostBookmarkModel.fromJson(json.decode(response.body));
    // } on SocketException catch (error) {
    //   throw Exception('NO INTERNET :: $error');
    // } on ValidationFailureException catch (error) {
    //   throw error;
    // } catch (error) {
    //   print(
    //       'error occurred fetching from ${_backEndAPIRoutes.likeAPost(postId).toString()} :: $error');
    //   throw Exception('$error');
    // }
  }

  Future<dynamic> fetchCommentsOfFindAMatePostById(int commentId) async {
    Uri uri = _backEndAPIRoutes.fetchCommentsOfFindAMatePostById(commentId);
    //
    // try {
    //   final response = await _apiService.get(uri: uri);
    //
    //   //print('amr type: ${json.decode(response.body)['data']['feeds'].toString()} and url is: ${uri.toString()}');
    //
    //   return FindAMateCommentFetchModel.fromJson(json.decode(response.body));
    // } on SocketException catch (error) {
    //   throw Exception('NO INTERNET :: $error');
    // } catch (error) {
    //   print('error occurred fetching from ${uri.toString()} :: $error');
    //   throw Exception('$error');
    // }
  }

  Future<dynamic> fetchCommentsOfFindAMatePost(int postId) async {
    Uri uri = _backEndAPIRoutes.fetchCommentsOfFindAMatePost(postId);

    // try {
    //   final response = await _apiService.get(uri: uri);
    //
    //   //print('amr type: ${json.decode(response.body)['data']['feeds'].toString()} and url is: ${uri.toString()}');
    //
    //   return FindAMateCommentFetchModel.fromJson(json.decode(response.body));
    // } on SocketException catch (error) {
    //   throw Exception('NO INTERNET :: $error');
    // } catch (error) {
    //   print('error occurred fetching from ${uri.toString()} :: $error');
    //   throw Exception('$error');
    // }
  }





  Future commentFindAMatePost(FormData data, int postId) async {
    // try {
    //   final response = await _apiService.postWithFormData(
    //       uri: _backEndAPIRoutes.commentFindAMatePost(postId), formData: data);
    //   print(response);
    //   return response.data.toString();
    // } on SocketException catch (error) {
    //   throw Exception('NO INTERNET :: $error');
    // } on ValidationFailureException catch (error) {
    //   throw error;
    // } catch (error) {
    //   print(
    //       'error occurred fetching from ${_backEndAPIRoutes.commentFindAMatePost(postId).toString()} :: $error');
    //   throw Exception('$error');
    // }
  }


  Future shareFindAMatePost(Map<String, dynamic> body,int postId) async {
    // try {
    final response = await _apiService.post(
        uri: _backEndAPIRoutes.shareFindAMatePost(postId), data: body);
    //
    //   return json.decode(response.body);
    // } on SocketException catch (error) {
    //   throw Exception('NO INTERNET :: $error');
    // } on ValidationFailureException catch (error) {
    //   throw error;
    // } catch (error) {
    //   print(
    //       'error occurred fetching from ${_backEndAPIRoutes.shareAPost(postId).toString()} :: $error');
    //   throw Exception('$error');
    // }
  }

  Future deleteCommentsOfFindAMatePost(int commentId) async {
    Uri uri = _backEndAPIRoutes.deleteCommentsOfFindAMatePost(commentId);

    // try {
    //   final response = await _apiService.post(uri: uri);
    //
    //   //print('amr type: ${json.decode(response.body)['data']['feeds'].toString()} and url is: ${uri.toString()}');
    //
    //   return json.decode(response.body);
    // } on SocketException catch (error) {
    //   throw Exception('NO INTERNET :: $error');
    // } catch (error) {
    //   print('error occurred fetching from ${uri.toString()} :: $error');
    //   throw Exception('$error');
    // }
  }

  Future deleteFindAMatePost(int postId) async {
    Uri uri = _backEndAPIRoutes.deleteFindAMatePost(postId);

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




  Future<FindAMatePostsModel?> searchFindAMate({required String token,required int page,required String text})async{
    FindAMatePostsModel? findAMatePostsModel;
    debugPrint("https://api.mateapp.us/api/findmate/posts?findmate_name=$text&page=$page");
    debugPrint(token);
    try {
      final response = await http.get(
        Uri.parse("https://api.mateapp.us/api/findmate/posts?findmate_name=$text&page=$page"),
        headers: {"Authorization": "Bearer" +token},);
      if (response.statusCode == 200) {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
        findAMatePostsModel = FindAMatePostsModel.fromJson(parsed);
      }else {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
      }
    }catch (e) {
      log(e.toString());
    }
    return findAMatePostsModel;
  }


}
