import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:mate_app/Exceptions/Custom_Exception.dart';
import 'package:mate_app/Model/beAMatePostActiveModel.dart';
import 'package:mate_app/Model/beAMatePostsModel.dart';
import 'package:dio/dio.dart';

import 'APIService.dart';
import 'BackEndAPIRoutes.dart';
import 'package:http/http.dart'as http;

class BeAMateService {
  APIService _apiService;
  BackEndAPIRoutes _backEndAPIRoutes;

  BeAMateService() {
    _apiService = APIService();
    _backEndAPIRoutes = BackEndAPIRoutes();
  }


  Future<dynamic> fetchBeAMatePostList(Map<String, dynamic> queryParams) async {
    Uri uri = _backEndAPIRoutes.beAMatePosts();

    try {
      final response = await _apiService.get(uri: uri);

      print(response.body);
      //print('amr type: ${json.decode(response.body)['data']['feeds'].toString()} and url is: ${uri.toString()}');

      return BeAMatePostsModel.fromJson(json.decode(response.body));
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } catch (error) {
      print('error occurred fetching from ${uri.toString()} :: $error');
      throw Exception('$error');
    }
  }

  Future<dynamic> fetchBeAMatePostBookmarkedList() async {
    Uri uri = _backEndAPIRoutes.beAMateBookmarkPosts();
    //
    // try {
    //   final response = await _apiService.post(uri: uri);
    //
    //   print(response.body);
    //   //print('amr type: ${json.decode(response.body)['data']['feeds'].toString()} and url is: ${uri.toString()}');
    //
    //   return BeAMatePostsModel.fromJson(json.decode(response.body));
    // } on SocketException catch (error) {
    //   throw Exception('NO INTERNET :: $error');
    // } catch (error) {
    //   print('error occurred fetching from ${uri.toString()} :: $error');
    //   throw Exception('$error');
    // }
  }

  Future<dynamic> fetchBeAMatePostByAuthUser(String uuid) async {
    Uri uri = _backEndAPIRoutes.fetchBeAMatePostByAuthUser(uuid);
    //
    // try {
    //   final response = await _apiService.get(uri: uri);
    //
    //   print(response.body);
    //   //print('amr type: ${json.decode(response.body)['data']['feeds'].toString()} and url is: ${uri.toString()}');
    //
    //   return BeAMatePostsModel.fromJson(json.decode(response.body));
    // } on SocketException catch (error) {
    //   throw Exception('NO INTERNET :: $error');
    // } catch (error) {
    //   print('error occurred fetching from ${uri.toString()} :: $error');
    //   throw Exception('$error');
    // }
  }



  Future postBeAMate(Map<String, dynamic> body) async {
    try {
      final response = await _apiService.post(
          uri: _backEndAPIRoutes.postBeAMate(), data: body);
      print(response);
      return response.body.toString();
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } on ValidationFailureException catch (error) {
      throw error;
    } catch (error) {
      print(
          'error occurred fetching from ${_backEndAPIRoutes.postBeAMate().toString()} :: $error');
      throw Exception('$error');
    }
  }


  Future<dynamic> activeBeAMatePost(int postId,Map<String, dynamic> body) async {
    try {
      final response = await _apiService.post(
          uri: _backEndAPIRoutes.activeBeAMatePost(postId), data: body);

      return BeAMatePostActiveModel.fromJson(json.decode(response.body));
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

  Future<dynamic> bookmarkBeAMatePost(int postId) async {
    // try {
    //   final response = await _apiService.post(
    //       uri: _backEndAPIRoutes.bookmarkBeAMatePost(postId));
    //
    //   return BeAMatePostBookmarkModel.fromJson(json.decode(response.body));
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

  Future<dynamic> fetchCommentsOfBeAMatePostById(int commentId) async {
    Uri uri = _backEndAPIRoutes.fetchCommentsOfBeAMatePostById(commentId);
    //
    // try {
    //   final response = await _apiService.get(uri: uri);
    //
    //   //print('amr type: ${json.decode(response.body)['data']['feeds'].toString()} and url is: ${uri.toString()}');
    //
    //   return BeAMateCommentFetchModel.fromJson(json.decode(response.body));
    // } on SocketException catch (error) {
    //   throw Exception('NO INTERNET :: $error');
    // } catch (error) {
    //   print('error occurred fetching from ${uri.toString()} :: $error');
    //   throw Exception('$error');
    // }
  }

  Future<dynamic> fetchCommentsOfBeAMatePost(int postId) async {
    Uri uri = _backEndAPIRoutes.fetchCommentsOfBeAMatePost(postId);

    // try {
    //   final response = await _apiService.get(uri: uri);
    //
    //   //print('amr type: ${json.decode(response.body)['data']['feeds'].toString()} and url is: ${uri.toString()}');
    //
    //   return BeAMateCommentFetchModel.fromJson(json.decode(response.body));
    // } on SocketException catch (error) {
    //   throw Exception('NO INTERNET :: $error');
    // } catch (error) {
    //   print('error occurred fetching from ${uri.toString()} :: $error');
    //   throw Exception('$error');
    // }
  }





  Future commentBeAMatePost(FormData data, int postId) async {
    // try {
    //   final response = await _apiService.postWithFormData(
    //       uri: _backEndAPIRoutes.commentBeAMatePost(postId), formData: data);
    //   print(response);
    //   return response.data.toString();
    // } on SocketException catch (error) {
    //   throw Exception('NO INTERNET :: $error');
    // } on ValidationFailureException catch (error) {
    //   throw error;
    // } catch (error) {
    //   print(
    //       'error occurred fetching from ${_backEndAPIRoutes.commentBeAMatePost(postId).toString()} :: $error');
    //   throw Exception('$error');
    // }
  }


  Future shareBeAMatePost(Map<String, dynamic> body,int postId) async {
    // try {
    final response = await _apiService.post(
        uri: _backEndAPIRoutes.shareBeAMatePost(postId), data: body);
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

  Future deleteCommentsOfBeAMatePost(int commentId) async {
    Uri uri = _backEndAPIRoutes.deleteCommentsOfBeAMatePost(commentId);

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

  Future deleteBeAMatePost(int postId) async {
    Uri uri = _backEndAPIRoutes.deleteBeAMatePost(postId);

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

  Future<BeAMatePostsModel> searchBeAMate({String token,int page,String text})async{
    BeAMatePostsModel beAMatePostsModel;
    debugPrint("https://api.mateapp.us/api/bemate/posts?bemate_name=$text&page=$page");
    debugPrint(token);
    try {
      final response = await http.get(
        Uri.parse("https://api.mateapp.us/api/bemate/posts?bemate_name=$text&page=$page"),
        headers: {"Authorization": "Bearer" +token},);
      if (response.statusCode == 200) {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
        beAMatePostsModel = BeAMatePostsModel.fromJson(parsed);
      }else {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
      }
    }catch (e) {
      log(e.toString());
    }
    return beAMatePostsModel;
  }









}
