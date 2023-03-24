

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:mate_app/Exceptions/Custom_Exception.dart';
import 'package:mate_app/Model/CampusTalkPostCommentUpVoteModel.dart';
import 'package:mate_app/Model/campusTalkCommentFetchModel.dart';
import 'package:mate_app/Model/campusTalkPostBookmarkModel.dart';
import 'package:mate_app/Model/campusTalkPostsModel.dart';
import 'package:mate_app/Model/campusTalkPostsUpVoteModel.dart';
import 'package:mate_app/Services/APIService.dart';
import 'package:mate_app/Services/BackEndAPIRoutes.dart';
import 'package:dio/dio.dart';
import 'package:mate_app/Model/campusTalkTypeModel.dart' as campusTalkTypeModel;
import 'package:http/http.dart'as http;
class CampusTalkService {
  APIService _apiService;
  BackEndAPIRoutes _backEndAPIRoutes;

  CampusTalkService() {
    _apiService = APIService();
    _backEndAPIRoutes = BackEndAPIRoutes();
  }


  Future<dynamic> fetchCampusTalkPostList(Map<String, dynamic> queryParams) async {
    Uri uri = _backEndAPIRoutes.campusTalkPosts(queryParams);

    try {
      final response = await _apiService.get(uri: uri);

      print(response.body);
      //print('amr type: ${json.decode(response.body)['data']['feeds'].toString()} and url is: ${uri.toString()}');

      return CampusTalkPostsModel.fromJson(json.decode(response.body));
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } catch (error) {
      print('error occurred fetching from ${uri.toString()} :: $error');
      throw Exception('$error');
    }
  }

  Future<dynamic> fetchCampusTalkPostDetails(int talkId) async {
    Uri uri = _backEndAPIRoutes.campusTalkPostDetails(talkId);

    try {
      final response = await _apiService.get(uri: uri);

      print(response.body);
      //print('amr type: ${json.decode(response.body)['data']['feeds'].toString()} and url is: ${uri.toString()}');

      return CampusTalkPostsModel.fromJson(json.decode(response.body));
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } catch (error) {
      print('error occurred fetching from ${uri.toString()} :: $error');
      throw Exception('$error');
    }
  }

  Future<dynamic> fetchCampusTalkPostBookmarkedList() async {
    Uri uri = _backEndAPIRoutes.campusTalkBookmarkPosts();

    try {
      final response = await _apiService.get(uri: uri);

      print(response.body);
      print('-------');
      log(response.body);
      //print('amr type: ${json.decode(response.body)['data']['feeds'].toString()} and url is: ${uri.toString()}');

      return CampusTalkPostsModel.fromJson(json.decode(response.body));
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } catch (error) {
      print('error occurred fetching from ${uri.toString()} :: $error');
      throw Exception('$error');
    }
  }

  Future<dynamic> fetchCampusTalkByAuthUser(String uuid, Map<String, dynamic> queryParams) async {
    Uri uri = _backEndAPIRoutes.fetchCampusTalkByAuthUser(uuid, queryParams);

    try {
      final response = await _apiService.get(uri: uri);

      print(response.body);
      //print('amr type: ${json.decode(response.body)['data']['feeds'].toString()} and url is: ${uri.toString()}');

      return CampusTalkPostsModel.fromJson(json.decode(response.body));
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } catch (error) {
      print('error occurred fetching from ${uri.toString()} :: $error');
      throw Exception('$error');
    }
  }



  Future postACampusTalk(Map<String, dynamic> body) async {
    try {
      final response = await _apiService.post(
          uri: _backEndAPIRoutes.postACampusTalk(), data: body);
      print(response);
      return response.body.toString();
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } on ValidationFailureException catch (error) {
      throw error;
    } catch (error) {
      print(
          'error occurred fetching from ${_backEndAPIRoutes.postACampusTalk().toString()} :: $error');
      throw Exception('$error');
    }
  }

  Future updateACampusTalk(Map<String, dynamic> body,int id) async {
    try {
      final response = await _apiService.post(
          uri: _backEndAPIRoutes.updateACampusTalk(id), data: body);
      print(response);
      return response.body.toString();
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } on ValidationFailureException catch (error) {
      throw error;
    } catch (error) {
      print(
          'error occurred fetching from ${_backEndAPIRoutes.postACampusTalk().toString()} :: $error');
      throw Exception('$error');
    }
  }


  Future<dynamic> upVoteAPost(int postId) async {
    try {
      final response = await _apiService.post(
          uri: _backEndAPIRoutes.upVoteACampusTalk(postId));

      return CampusTalkPostsUpVoteModel.fromJson(json.decode(response.body));
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } on ValidationFailureException catch (error) {
      throw error;
    } catch (error) {
      print(
          'error occurred fetching from ${_backEndAPIRoutes.upVoteACampusTalk(postId).toString()} :: $error');
      throw Exception('$error');
    }
  }

  Future<dynamic> upVoteAPostComment(int commentId) async {
    try {
      final response = await _apiService.post(
          uri: _backEndAPIRoutes.upVoteACampusTalkComment(commentId));

      return CampusTalkPostCommentUpVoteModel.fromJson(json.decode(response.body));
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } on ValidationFailureException catch (error) {
      throw error;
    } catch (error) {
      print(
          'error occurred fetching from ${_backEndAPIRoutes.upVoteACampusTalkComment(commentId).toString()} :: $error');
      throw Exception('$error');
    }
  }



  Future<dynamic> bookmarkAPost(int postId) async {
    try {
      final response = await _apiService.post(
          uri: _backEndAPIRoutes.bookmarkACampusTalk(postId));

      return CampusTalkPostBookmarkModel.fromJson(json.decode(response.body));
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

  Future<dynamic> fetchCommentsOfACampusTalkById(int commentId) async {
    Uri uri = _backEndAPIRoutes.fetchCommentsOfACampusTalkById(commentId);
    //
    // try {
    //   final response = await _apiService.get(uri: uri);
    //
    //   //print('amr type: ${json.decode(response.body)['data']['feeds'].toString()} and url is: ${uri.toString()}');
    //
    //   return CampusTalkCommentFetchModel.fromJson(json.decode(response.body));
    // } on SocketException catch (error) {
    //   throw Exception('NO INTERNET :: $error');
    // } catch (error) {
    //   print('error occurred fetching from ${uri.toString()} :: $error');
    //   throw Exception('$error');
    // }
  }

  Future<dynamic> fetchCommentsOfACampusTalk(int postId) async {
    Uri uri = _backEndAPIRoutes.fetchCommentsOfACampusTalk(postId);

    try {
      final response = await _apiService.get(uri: uri);

      //print('amr type: ${json.decode(response.body)['data']['feeds'].toString()} and url is: ${uri.toString()}');

      return CampusTalkCommentFetchModel.fromJson(json.decode(response.body));
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } catch (error) {
      print('error occurred fetching from ${uri.toString()} :: $error');
      throw Exception('$error');
    }
  }





  Future commentACampusTalk(FormData data, int postId) async {
    try {
      final response = await _apiService.postWithFormData(
          uri: _backEndAPIRoutes.commentACampusTalk(postId), formData: data);
      print(response);
      return response.data.toString();
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } on ValidationFailureException catch (error) {
      throw error;
    } catch (error) {
      print(
          'error occurred fetching from ${_backEndAPIRoutes.commentACampusTalk(postId).toString()} :: $error');
      throw Exception('$error');
    }
  }


  Future shareACampusTalk(Map<String, dynamic> body,int postId) async {
    // try {
      final response = await _apiService.post(
          uri: _backEndAPIRoutes.shareACampusTalk(postId), data: body);
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

  Future reportACampusTalk(Map<String, dynamic> body,int postId) async {
    try {
      final response = await _apiService.post(
          uri: _backEndAPIRoutes.shareACampusTalk(postId), data: body);

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



  Future deleteCommentsOfACampusTalk(int commentId) async {
    Uri uri = _backEndAPIRoutes.deleteCommentsOfACampusTalk(commentId);

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

  Future deleteACampusTalk(int postId) async {
    Uri uri = _backEndAPIRoutes.deleteACampusTalk(postId);

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

  Future<List<campusTalkTypeModel.Data>> getType({String token})async{
    List<campusTalkTypeModel.Data> list = [];
    debugPrint("https://api.mateapp.us/api/discussion/posts/types");
    debugPrint(token);
    try {
      final response = await http.get(
        Uri.parse("https://api.mateapp.us/api/discussion/posts/types"),
        headers: {"Authorization": "Bearer" +token},);
      if (response.statusCode == 200) {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
        campusTalkTypeModel.CampusTalkTypeModel data = campusTalkTypeModel.CampusTalkTypeModel.fromJson(parsed);
        list = data.data;
      }else {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
      }
    }catch (e) {
      log(e.toString());
    }
    return list;
  }







}
