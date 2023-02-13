import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:mate_app/Exceptions/Custom_Exception.dart';
import 'package:mate_app/Model/FeedItem.dart';
import 'package:mate_app/Model/bookmarkByUserModel.dart';
import 'package:mate_app/Model/feedItemsBookmarkModel.dart';
import 'package:mate_app/Model/feedItemsLikeModel.dart';
import 'package:mate_app/Model/feedLikesDetailsModel.dart';
import 'package:mate_app/Model/feedsCommentFetchModel.dart';
import 'package:mate_app/Model/getStoryModel.dart' as story;

import '../Services/APIService.dart';
import '../Services/BackEndAPIRoutes.dart';

class FeedService {
  APIService _apiService;
  BackEndAPIRoutes _backEndAPIRoutes;

  FeedService() {
    _apiService = APIService();
    _backEndAPIRoutes = BackEndAPIRoutes();
  }

  Future fetchFeedTypes() async {
    try {
      final response =
      await _apiService.get(uri: _backEndAPIRoutes.feedTypes());

      return json.decode(response.body)['data']['types'];
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } catch (error) {
      print(
          'error occurred fetching from ${_backEndAPIRoutes.feedTypes().toString()} :: $error');
      throw Exception('$error');
    }
  }

  Future fetchFeedList(Map<String, dynamic> queryParams, {bool isFollowingFeeds, String userId}) async {
    Uri uri;
    print(queryParams);
    if(isFollowingFeeds!=null){
      if(isFollowingFeeds){
        uri = _backEndAPIRoutes.fetchFollowerFeeds(queryParams);
      }
    }else if(userId!=null){
      uri = _backEndAPIRoutes.fetchUsersFeeds(queryParams, userId);
    }else{
      uri = _backEndAPIRoutes.feeds(queryParams);
    }

    print(uri);
    try {
      var response;
      if(isFollowingFeeds??false){
        response = await _apiService.post(uri: uri);
      }else{
        response = await _apiService.get(uri: uri);
      }

      //print('amr type: ${json.decode(response.body)['data']['feeds'].toString()} and url is: ${uri.toString()}');

      return json.decode(response.body)['data']['feeds'];
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } catch (error) {
      print('error occurred fetching from ${uri.toString()} :: $error');
      throw Exception('$error');
    }
  }


  Future fetchFeedListMyCampus(Map<String, dynamic> queryParams, {bool isFollowingFeeds, String userId}) async {
    Uri uri;
    print(queryParams);
    if(isFollowingFeeds!=null){
      if(isFollowingFeeds){
        uri = _backEndAPIRoutes.fetchFollowerFeeds(queryParams);
      }
    }else if(userId!=null){
      uri = _backEndAPIRoutes.fetchUsersFeeds(queryParams, userId);
    }else{
      uri = _backEndAPIRoutes.feedsMyCampus(queryParams);
    }

    print(uri);
    try {
      var response;
      if(isFollowingFeeds??false){
        response = await _apiService.post(uri: uri);
      }else{
        response = await _apiService.get(uri: uri);
      }

      //print('amr type: ${json.decode(response.body)['data']['feeds'].toString()} and url is: ${uri.toString()}');

      return json.decode(response.body)['data']['feeds'];
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } catch (error) {
      print('error occurred fetching from ${uri.toString()} :: $error');
      throw Exception('$error');
    }
  }

  Future fetchFeedDetails(int feedId) async {
    Uri uri = _backEndAPIRoutes.feedDetails(feedId);

    print(uri);
    try {
      final response = await _apiService.get(uri: uri);

      //print('amr type: ${json.decode(response.body)['data']['feeds'].toString()} and url is: ${uri.toString()}');

      return FeedItem.fromJson(json.decode(response.body)['data']['feeds'][0]);
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } catch (error) {
      print('error occurred fetching from ${uri.toString()} :: $error');
      throw Exception('$error');
    }
  }

  Future<FeedItemsLikeModel> likeAFeed(int feedId,  int emojiValue) async {
    try {
      final response = await _apiService.post(
          uri: _backEndAPIRoutes.likeAFeed(feedId),data: {"emoji_value": emojiValue});

      return FeedItemsLikeModel.fromJson(json.decode(response.body));
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } on ValidationFailureException catch (error) {
      throw error;
    } catch (error) {
      print(
          'error occurred fetching from ${_backEndAPIRoutes.likeAFeed(feedId).toString()} :: $error');
      throw Exception('$error');
    }
  }

  Future<String> likeFeed(int feedId,int emojiValue,String token)async{
    String result = "";
    debugPrint("https://api.mateapp.us/api/feed/$feedId/like");
    log(token);
    Map data = {"emoji_value": emojiValue};
    try {
      final response = await http.post(
        Uri.parse("https://api.mateapp.us/api/feed/$feedId/like"),
        headers: {"Authorization": "Bearer" +token,"Content-type" : "application/json"},
        body: jsonEncode(data),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
        result = parsed["message"];
      }else {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
      }
    }catch (e) {
      log(e.toString());
    }
    return result;
  }

  Future<FeedItemsBookmarkModel> bookmarkAFeed(int feedId) async {
    try {
      final response = await _apiService.post(
          uri: _backEndAPIRoutes.bookmarkAFeed(feedId));

      return FeedItemsBookmarkModel.fromJson(json.decode(response.body));
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } on ValidationFailureException catch (error) {
      throw error;
    } catch (error) {
      print(
          'error occurred fetching from ${_backEndAPIRoutes.bookmarkAFeed(feedId).toString()} :: $error');
      throw Exception('$error');
    }
  }

  Future<BookmarkByUserModel> allBookmarkedFeed() async {
    try {
      final response = await _apiService.post(
          uri: _backEndAPIRoutes.allBookmarkedFeed());

      return BookmarkByUserModel.fromJson(json.decode(response.body));
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } on ValidationFailureException catch (error) {
      throw error;
    } catch (error) {
      print(
          'error occurred fetching from ${_backEndAPIRoutes.allBookmarkedFeed().toString()} :: $error');
      throw Exception('$error');
    }
  }





  Future postAFeed(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.post(
          uri: _backEndAPIRoutes.postAFeed(), data: data);

      return json.decode(response.body)['message'];
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } on ValidationFailureException catch (error) {
      throw error;
    } catch (error) {
      print(
          'error occurred fetching from ${_backEndAPIRoutes.postAFeed().toString()} :: $error');
      throw Exception('$error');
    }
  }
  Future updateAFeed(Map<String, dynamic> data,int id) async {
    try {
      final response = await _apiService.post(
          uri: _backEndAPIRoutes.updateAFeed(id), data: data);

      return json.decode(response.body)['message'];
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } on ValidationFailureException catch (error) {
      throw error;
    } catch (error) {
      print(
          'error occurred fetching from ${_backEndAPIRoutes.postAFeed().toString()} :: $error');
      throw Exception('$error');
    }
  }
  Future postAStory(FormData data) async {
    try {
      final response = await _apiService.postWithFormData(
          uri: _backEndAPIRoutes.postAStory(), formData: data);

      return response.data.toString();
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } on ValidationFailureException catch (error) {
      throw error;
    } catch (error) {
      print(
          'error occurred fetching from ${_backEndAPIRoutes.postAStory().toString()} :: $error');
      throw Exception('$error');
    }
  }

  Future<FeedsCommentFetchModel> fetchCommentsOfAFeed(int feedId) async {
    Uri uri = _backEndAPIRoutes.fetchCommentsOfAFeed(feedId);

    try {
      final response = await _apiService.get(uri: uri);

      return FeedsCommentFetchModel.fromJson(json.decode(response.body));
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } catch (error) {
      print('error occurred fetching from ${uri.toString()} :: $error');
      throw Exception('$error');
    }
  }

  Future<List<story.Result>> getStories(int page) async {
    //Uri uri = _backEndAPIRoutes.getStories();
    Uri uri = Uri.parse("https://api.mateapp.us/api/stories?page=$page");
    List<story.Result> dataList = [];
    try {
      final response = await _apiService.get(uri: uri);
      var data = story.GetStoryModel.fromJson(json.decode(response.body));
      dataList = data.data.result;
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } catch (error) {
      print('error occurred fetching from ${uri.toString()} :: $error');
      throw Exception('$error');
    }
    return dataList;
  }


  Future<List<story.Result>> getStoriesPagination(int page) async {
    Uri uri = Uri.parse("https://api.mateapp.us/api/stories?page=$page");
    List<story.Result> dataList = [];
    try {
      final response = await _apiService.get(uri: uri);
      var data = story.GetStoryModel.fromJson(json.decode(response.body));
      dataList = data.data.result;
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } catch (error) {
      print('error occurred fetching from ${uri.toString()} :: $error');
      throw Exception('$error');
    }
    return dataList;
  }


  Future<bool> deleteStory({String token,int id})async{
    bool result = false;
    debugPrint("https://api.mateapp.us/api/story/$id/delete");
    debugPrint(token);
    try {
      final response = await http.post(
        Uri.parse("https://api.mateapp.us/api/story/$id/delete"),
        headers: {"Authorization": "Bearer" +token},);
      if (response.statusCode == 200) {
        var parsed = json.decode(response.body);
        debugPrint(parsed.toString());
        result = true;
      }else {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
      }
    }catch (e) {
      log(e.toString());
    }
    return result;
  }

  Future commentAFeed(Map<String, dynamic> data, int feedId) async {
    try {
      final response = await _apiService.post(
          uri: _backEndAPIRoutes.commentAFeed(feedId), data: data);

      return json.decode(response.body);
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } on ValidationFailureException catch (error) {
      throw error;
    } catch (error) {
      print(
          'error occurred fetching from ${_backEndAPIRoutes.commentAFeed(feedId).toString()} :: $error');
      throw Exception('$error');
    }
  }

  Future deleteCommentsOfAFeed(int commentId) async {
    Uri uri = _backEndAPIRoutes.deleteCommentsOfAFeed(commentId);

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

  Future deleteAFeed(int feedId) async {
    Uri uri = _backEndAPIRoutes.deleteAFeed(feedId);

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

  Future shareAFeed(Map<String, dynamic> body,int feedId) async {
    try {
      final response = await _apiService.post(
          uri: _backEndAPIRoutes.shareAFeed(feedId), data: body);

      return json.decode(response.body);
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } on ValidationFailureException catch (error) {
      throw error;
    } catch (error) {
      print(
          'error occurred fetching from ${_backEndAPIRoutes.shareAFeed(feedId).toString()} :: $error');
      throw Exception('$error');
    }
  }

  Future followAFeed(Map<String, dynamic> body,int feedId) async {
    try {
      final response = await _apiService.post(
          uri: _backEndAPIRoutes.followAFeed(feedId), data: body);

      return json.decode(response.body);
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } on ValidationFailureException catch (error) {
      throw error;
    } catch (error) {
      print(
          'error occurred fetching from ${_backEndAPIRoutes.followAFeed(feedId).toString()} :: $error');
      throw Exception('$error');
    }
  }

  Future unFollowAFeed(Map<String, dynamic> body,int feedId) async {
    try {
      final response = await _apiService.post(uri: _backEndAPIRoutes.unFollowAFeed(feedId), data: body);

      return json.decode(response.body);
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } on ValidationFailureException catch (error) {
      throw error;
    } catch (error) {
      print(
          'error occurred fetching from ${_backEndAPIRoutes.unFollowAFeed(feedId).toString()} :: $error');
      throw Exception('$error');
    }
  }





  Future<FeedLikesDetailsModel> fetchLikeDetailsOfAFeed(int feedId) async {
    Uri uri = _backEndAPIRoutes.fetchLikeDetailsOfAFeed(feedId);

    try {
      final response = await _apiService.get(uri: uri);

      return FeedLikesDetailsModel.fromJson(json.decode(response.body));
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } catch (error) {
      print('error occurred fetching from ${uri.toString()} :: $error');
      throw Exception('$error');
    }
  }



  Future<List<FeedItem>> searchFeed({String token,int page,String text})async{
    List<FeedItem> list = [];
    debugPrint("https://api.mateapp.us/api/feeds?page=$page&feed_type_name=$text");
    debugPrint(token);
    try {
      final response = await http.get(
        Uri.parse("https://api.mateapp.us/api/feeds?page=$page&feed_type_name=$text"),
        headers: {"Authorization": "Bearer" +token},);
      if (response.statusCode == 200) {
        var parsed = json.decode(response.body);
        debugPrint(parsed.toString());
        var data =  parsed['data']['feeds'];
        List<FeedItem> rawFeedList = [];
        for (int i = 0; i < data.length; i++) {
          rawFeedList.add(FeedItem.fromJson(data[i]));
        }
        list = rawFeedList;
      }else {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
      }
    }catch (e) {
      log(e.toString());
    }
    return list;
  }


  Future<List<FeedItem>> searchFeedForTextField({String token,int page,String text})async{
    List<FeedItem> list = [];
    debugPrint("https://api.mateapp.us/api/feeds?page=$page&feed_name=$text");
    debugPrint(token);
    try {
      final response = await http.get(
        Uri.parse("https://api.mateapp.us/api/feeds?page=$page&feed_name=$text"),
        headers: {"Authorization": "Bearer" +token},);
      if (response.statusCode == 200) {
        var parsed = json.decode(response.body);
        debugPrint(parsed.toString());
        var data =  parsed['data']['feeds'];
        List<FeedItem> rawFeedList = [];
        for (int i = 0; i < data.length; i++) {
          rawFeedList.add(FeedItem.fromJson(data[i]));
        }
        list = rawFeedList;
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
