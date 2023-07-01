import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'package:mate_app/Model/notificationData.dart';
import 'package:mate_app/Model/eventListingModel.dart' as listing;
import 'package:mate_app/Model/campusTalkPostsModel.dart' as campusTalk;
import '../../Model/beAMatePostsModel.dart' as beAMate;
import 'package:mate_app/Model/findAMatePostsModel.dart' as findAMate;

class NotificationService{

  Future<List<NotificationData>> getNotificationListing({String token})async{
    List<NotificationData> notificationData = [];
    debugPrint("https://api.mateapp.us/api/notification/history");
    debugPrint(token);
    try {
      final response = await http.get(
        Uri.parse("https://api.mateapp.us/api/notification/history"),
        headers: {"Authorization": "Bearer" +token},);
      if (response.statusCode == 200) {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
        for(int i=0;i<parsed['data']['notifications'].length;i++){
          notificationData.add(
            NotificationData.fromJson(parsed['data']['notifications'][i])
          );
        }
      }else {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
      }
    }catch (e) {
      log(e.toString());
    }
    return notificationData;
  }

  Future<listing.Result> getEventDetails({String token,int eventId})async{
    listing.Result result;
    debugPrint("https://api.mateapp.us/api/event/$eventId");
    debugPrint(token);
    try {
      final response = await http.get(
        Uri.parse("https://api.mateapp.us/api/event/$eventId"),
        headers: {"Authorization": "Bearer" +token},);
      if (response.statusCode == 200) {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
        result = listing.Result.fromJson(parsed['data']['result'][0]);
      }else {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
      }
    }catch (e) {
      log(e.toString());
    }
    return result;
  }

  Future<campusTalk.Result> getCampusDetails({String token,int id})async{
    campusTalk.Result result;
    debugPrint("https://api.mateapp.us/api/discussion/post/$id");
    debugPrint(token);
    try {
      final response = await http.get(
        Uri.parse("https://api.mateapp.us/api/discussion/post/$id"),
        headers: {"Authorization": "Bearer" +token},);
      if (response.statusCode == 200) {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
        result = campusTalk.Result.fromJson(parsed['data']['result'][0]);
      }else {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
      }
    }catch (e) {
      log(e.toString());
    }
    return result;
  }

  Future<beAMate.Result> getBeAMateDetails({String token,int id})async{
    beAMate.Result result;
    debugPrint("https://api.mateapp.us/api/bemate/$id");
    debugPrint(token);
    try {
      final response = await http.get(
        Uri.parse("https://api.mateapp.us/api/bemate/$id"),
        headers: {"Authorization": "Bearer" +token},);
      if (response.statusCode == 200) {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
        result = beAMate.Result.fromJson(parsed['data']['result'][0]);
      }else {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
      }
    }catch (e) {
      log(e.toString());
    }
    return result;
  }

  Future<findAMate.Result> getFindAMateDetails({String token,int id})async{
    findAMate.Result result;
    debugPrint("https://api.mateapp.us/api/findmate/$id");
    debugPrint(token);
    try {
      final response = await http.get(
        Uri.parse("https://api.mateapp.us/api/findmate/$id"),
        headers: {"Authorization": "Bearer" +token},);
      if (response.statusCode == 200) {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
        result = findAMate.Result.fromJson(parsed['data']['result'][0]);
      }else {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
      }
    }catch (e) {
      log(e.toString());
    }
    return result;
  }


  Future<bool> changeStatus({String token,int id})async{
    bool result = false;
    debugPrint("https://api.mateapp.us/api/notification/$id/update-status");
    debugPrint(token);
    try {
      final response = await http.post(
        Uri.parse("https://api.mateapp.us/api/notification/$id/update-status"),
        headers: {"Authorization": "Bearer" +token},);
      if (response.statusCode == 200) {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
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

}