import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:mate_app/Model/communityTabModel.dart';
import 'package:http/http.dart'as http;

class CommunityTabService{

  Future<CommunityTabModel> getChat({required String token,required String category,required String uid})async{
    late CommunityTabModel communityTabModel;
    debugPrint("https://api.mateapp.us/api/chat/get-all-group-chat-rooms/$uid?category=${category}");
    debugPrint(token);
    try {
      final response = await http.get(
        Uri.parse("https://api.mateapp.us/api/chat/get-all-group-chat-rooms/$uid?category=${category}"),
        headers: {"Authorization": "Bearer" +token},
      );
      if (response.statusCode == 200) {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
        communityTabModel = CommunityTabModel.fromJson(parsed);
      }else {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
      }
    }catch (e) {
      log(e.toString());
    }
    return communityTabModel;
  }


  Future<void> createGroup({required String token,required String category,required String type,required String groupId})async{
    debugPrint("https://api.mateapp.us/api/chat/save-group-chat-data");
    debugPrint(token);
    Map data = {
    "group_id": groupId,
    "category": category,
    "group": type
    };
    debugPrint(jsonEncode(data));
    try {
      final response = await http.post(
        Uri.parse("https://api.mateapp.us/api/chat/save-group-chat-data"),
        headers: {"Authorization": "Bearer" +token},
        body: data,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
      }else {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
      }
    }catch (e) {
      log(e.toString());
    }
  }


  Future<void> exitGroup({required String token,required String uid,required String groupId})async{
    debugPrint("https://api.mateapp.us/api/chat/leave-user-from-group");
    debugPrint(token);
    Map data = {
      "group_id": groupId,
      "uid": uid
    };
    debugPrint(jsonEncode(data));
    try {
      final response = await http.post(
        Uri.parse("https://api.mateapp.us/api/chat/leave-user-from-group"),
        headers: {"Authorization": "Bearer" +token},
        body: data,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
      }else {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
      }
    }catch (e) {
      log(e.toString());
    }
  }


  Future<void> joinGroup({required String token,required String uid,required String groupId})async{
    debugPrint("https://api.mateapp.us/api/chat/join-user-to-group");
    debugPrint(token);
    Map data = {
      "group_id": groupId,
      "uid": uid
    };
    debugPrint(jsonEncode(data));
    try {
      final response = await http.post(
        Uri.parse("https://api.mateapp.us/api/chat/join-user-to-group"),
        headers: {"Authorization": "Bearer" +token},
        body: data,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
      }else {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
      }
    }catch (e) {
      log(e.toString());
    }
  }


  Future<void> toggleMute({required String token,required String uid,required String groupId})async{
    debugPrint("https://api.mateapp.us/api/chat/mute-group-notification");
    debugPrint(token);
    Map data = {
      "group_id": groupId,
      "uid": uid
    };
    debugPrint(jsonEncode(data));
    try {
      final response = await http.post(
        Uri.parse("https://api.mateapp.us/api/chat/mute-group-notification"),
        headers: {"Authorization": "Bearer" +token},
        body: data,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
      }else {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
      }
    }catch (e) {
      log(e.toString());
    }
  }


  Future<void> toggleTopToPin({required String token,required String uid,required String groupId})async{
    debugPrint("https://api.mateapp.us/api/chat/pin-group-to-top");
    debugPrint(token);
    Map data = {
      "group_id": groupId,
      "uid": uid
    };
    debugPrint(jsonEncode(data));
    try {
      final response = await http.post(
        Uri.parse("https://api.mateapp.us/api/chat/pin-group-to-top"),
        headers: {"Authorization": "Bearer" +token},
        body: data,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
      }else {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
      }
    }catch (e) {
      log(e.toString());
    }
  }


  Future<bool> reportGroupMessage({required String token,required String uid,required String groupId,required String messageId})async{
    bool result = false;
    debugPrint("https://api.mateapp.us/api/chat/report-group-message");
    debugPrint(token);
    Map data = {
      "group_id": groupId,
      "message_id": messageId,
      "uid": uid
    };
    debugPrint(jsonEncode(data));
    try {
      final response = await http.post(
        Uri.parse("https://api.mateapp.us/api/chat/report-group-message"),
        headers: {"Authorization": "Bearer" +token},
        body: data,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
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

  Future<void> toggleMutePersonalChat({required String token,required String uid,required String roomId})async{
    debugPrint("https://api.mateapp.us/api/chat/mute-personal-chat-notification");
    debugPrint(token);
    Map data = {
      "room_id": roomId,
      "uid": uid
    };
    debugPrint(jsonEncode(data));
    try {
      final response = await http.post(
        Uri.parse("https://api.mateapp.us/api/chat/mute-personal-chat-notification"),
        headers: {"Authorization": "Bearer" +token},
        body: data,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
      }else {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
      }
    }catch (e) {
      log(e.toString());
    }
  }

  Future<bool> reportPersonalMessage({required String token,required String uid,required String roomId,required String messageId})async{
    bool result = false;
    debugPrint("https://api.mateapp.us/api/chat/report-personal-message");
    debugPrint(token);
    Map data = {
      "room_id": roomId,
      "message_id": messageId,
      "uid": uid
    };
    debugPrint(jsonEncode(data));
    try {
      final response = await http.post(
        Uri.parse("https://api.mateapp.us/api/chat/report-personal-message"),
        headers: {"Authorization": "Bearer" +token},
        body: data,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
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


  Future<void> toggleArchive({required String token,required String uid,required String roomId})async{
    debugPrint("https://api.mateapp.us/api/chat/archive-chat-room");
    debugPrint(token);
    Map data = {
      "room_id": roomId,
      "uid": uid
    };
    debugPrint(jsonEncode(data));
    try {
      final response = await http.post(
        Uri.parse("https://api.mateapp.us/api/chat/archive-chat-room"),
        headers: {"Authorization": "Bearer" +token},
        body: data,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
      }else {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
      }
    }catch (e) {
      log(e.toString());
    }
  }


}