import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart'as http;
import 'package:flutter/cupertino.dart';
import 'package:mate_app/Model/eventCommentListingModel.dart';
import 'package:mate_app/Model/eventListingModel.dart';

import '../Model/eventCateoryModel.dart';

class EventService{

  Future<String> createEvent({String title,String desc,String location,String date,String time,String token,String photo,String video,String linkText,String link,String endTime,String locationOption,int typeId})async{
    String result = "";
    Map data = {
      "title": title,
      "description": desc,
      "location": location,
      "date": date,
      "time": time,
      "location_opt": locationOption,
      "type_id": typeId.toString(),
      if(photo!=null)
        "photo":photo,
      if(video!=null)
        "video":video,
      if(linkText!=null)
        "hyperlinkText":linkText,
      if(link!=null)
        "hyperlink":link,
      if(endTime!=null)
        "end_time" : endTime,
    };
    debugPrint("https://api.mateapp.us/api/events");
    debugPrint(json.encode(data));
    log(token);


    Map<String, String> headers = { "Authorization": "Bearer " + token};
    final request = new http.MultipartRequest('POST', Uri.parse("https://api.mateapp.us/api/events"));
    request.headers.addAll(headers);

    request.fields['title'] = title;
    request.fields['description'] = desc;
    request.fields['location'] = location;
    request.fields['date'] = date;
    request.fields['time'] = time;
    request.fields['location_opt'] = locationOption;
    request.fields['type_id'] = typeId.toString();
    if(linkText!=null)
      request.fields['hyperlinkText'] = linkText;
    if(link!=null)
      request.fields['hyperlink'] = link;
    if(endTime!=null)
      request.fields['end_time'] = endTime;

    if(photo!=null){
      request.files.add(await http.MultipartFile.fromPath('photo',photo));
    }
    if(video!=null){
      request.files.add(await http.MultipartFile.fromPath('video',video));
    }

    try {
      var response = await request.send();
      response.stream.transform(utf8.decoder).listen((value) {
        log(value);
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        result = "Event created successfully";
      }
    } catch (e) {
      log(e.toString());
    }
    return result;
  }

  Future<String> updateEvent({int id,String title,String desc,String location,String date,String time,String token,String photo,String video,String linkText,String link,String endTime,bool isImageDeleted,bool isVideoDeleted,String locationOption,int typeId})async{
    String result = "";
    Map data = {
      "title": title,
      "description": desc,
      "location": location,
      "date": date,
      "time": time,
      "location_opt": locationOption,
      "type_id": typeId.toString(),
      if(photo!=null)
        "photo":photo,
      if(video!=null)
        "video":video,
      if(linkText!=null)
        "hyperlinkText":linkText,
      if(link!=null)
        "hyperlink":link,
      if(endTime!=null)
        "end_time" : endTime,
      if(isImageDeleted)
        "delete_photo":true,
      if(isVideoDeleted)
        "delete_video":true,
    };
    debugPrint("https://api.mateapp.us/api/event/$id/update");
    debugPrint(json.encode(data));
    log(token);


    Map<String, String> headers = { "Authorization": "Bearer " + token};
    final request = new http.MultipartRequest('POST', Uri.parse("https://api.mateapp.us/api/event/$id/update"));
    request.headers.addAll(headers);

    request.fields['title'] = title;
    request.fields['description'] = desc;
    request.fields['location'] = location;
    request.fields['date'] = date;
    request.fields['time'] = time;
    request.fields['location_opt'] = locationOption;
    request.fields['type_id'] = typeId.toString();
    if(linkText!=null)
      request.fields['hyperlinkText'] = linkText;
    if(link!=null)
      request.fields['hyperlink'] = link;
    if(endTime!=null)
      request.fields['end_time'] = endTime;
    if(isImageDeleted)
      request.fields['delete_photo'] = "true";
    if(isVideoDeleted)
      request.fields['delete_video'] = "true";

    if(photo!=null){
      request.files.add(await http.MultipartFile.fromPath('photo',photo));
    }
    if(video!=null){
      request.files.add(await http.MultipartFile.fromPath('video',video));
    }

    try {
      var response = await request.send();
      if (response.statusCode == 200 || response.statusCode == 201) {
        result = "Event updated successfully";
      }
    } catch (e) {
      log(e.toString());
    }
    return result;
  }



  Future<EventListingModel> getEventListing({String token,int page})async{
    EventListingModel eventListingModel;
    debugPrint("https://api.mateapp.us/api/events?page=$page");
    debugPrint(token);
    try {
      final response = await http.get(
        Uri.parse("https://api.mateapp.us/api/events?page=$page"),
        headers: {"Authorization": "Bearer" +token},);
      if (response.statusCode == 200) {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
        eventListingModel = EventListingModel.fromJson(parsed);
      }else {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
      }
    }catch (e) {
      log(e.toString());
    }
    return eventListingModel;
  }

  Future<EventListingModel> getEventListingBookmark({String token,int page})async{
    EventListingModel eventListingModel;
    debugPrint("https://api.mateapp.us/api/event/bookmarkbyuser?page=$page");
    debugPrint(token);
    try {
      final response = await http.get(
        Uri.parse("https://api.mateapp.us/api/event/bookmarkbyuser?page=$page"),
        headers: {"Authorization": "Bearer" +token},);
      if (response.statusCode == 200) {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
        eventListingModel = EventListingModel.fromJson(parsed);
      }else {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
      }
    }catch (e) {
      log(e.toString());
    }
    return eventListingModel;
  }

  Future<EventListingModel> getEventListingLocal({String token,int page})async{
    EventListingModel eventListingModel;
    debugPrint("https://api.mateapp.us/api/events?myevents=1&page=$page");
    debugPrint(token);
    try {
      final response = await http.get(
        Uri.parse("https://api.mateapp.us/api/events?myevents=1&page=$page"),
        headers: {"Authorization": "Bearer" +token},);
      if (response.statusCode == 200) {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
        eventListingModel = EventListingModel.fromJson(parsed);
      }else {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
      }
    }catch (e) {
      log(e.toString());
    }
    return eventListingModel;
  }


  Future<EventListingModel> getSearch({String token,int page,String text})async{
    EventListingModel eventListingModel;
    debugPrint("https://api.mateapp.us/api/events?event_name=$text&page=$page");
    debugPrint(token);
    try {
      final response = await http.get(
        Uri.parse("https://api.mateapp.us/api/events?event_name=$text&page=$page"),
        headers: {"Authorization": "Bearer" +token},);
      if (response.statusCode == 200) {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
        eventListingModel = EventListingModel.fromJson(parsed);
      }else {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
      }
    }catch (e) {
      log(e.toString());
    }
    return eventListingModel;
  }

  Future<EventListingModel> getSearchLocal({String token,int page,String text})async{
    EventListingModel eventListingModel;
    debugPrint("https://api.mateapp.us/api/events?myevents=1&event_name=$text&page=$page");
    debugPrint(token);
    try {
      final response = await http.get(
        Uri.parse("https://api.mateapp.us/api/events?event_name=$text&page=$page"),
        headers: {"Authorization": "Bearer" +token},);
      if (response.statusCode == 200) {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
        eventListingModel = EventListingModel.fromJson(parsed);
      }else {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
      }
    }catch (e) {
      log(e.toString());
    }
    return eventListingModel;
  }



  Future<bool> comment({String content,int id,String token})async{
    bool result = false;
    debugPrint("https://api.mateapp.us/api/event/$id/comment");
    log(token);
    Map data = {
      "content": content
    };
    try {
      final response = await http.post(
        Uri.parse("https://api.mateapp.us/api/event/$id/comment"),
        headers: {"Authorization": "Bearer" +token},
        body: data,
      );
      if (response.statusCode == 201) {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
        if(parsed["success"]==true){
          result = true;
        }
      }else {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
      }
    }catch (e) {
      log(e.toString());
    }
    return result;
  }

  Future<EventCommentListingModel> getComment({String token,int page,int id})async{
    EventCommentListingModel eventCommentListingModel;
    debugPrint("https://api.mateapp.us/api/event/$id/comment?page=$page");
    debugPrint(token);
    try {
      final response = await http.get(
        Uri.parse("https://api.mateapp.us/api/event/$id/comment?page=$page"),
        headers: {"Authorization": "Bearer" +token},
      );
      if (response.statusCode == 200) {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
        eventCommentListingModel = EventCommentListingModel.fromJson(parsed);
      }else {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
      }
    }catch (e) {
      log(e.toString());
    }
    return eventCommentListingModel;
  }


  Future<bool> bookMark({int id,String token})async{
    bool result = false;
    debugPrint("https://api.mateapp.us/api/event/$id/bookmark");
    log(token);
    try {
      final response = await http.post(
        Uri.parse("https://api.mateapp.us/api/event/$id/bookmark"),
        headers: {"Authorization": "Bearer" +token},
      );
      if (response.statusCode == 201) {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
        if(parsed["success"]==true){
          result = true;
        }
      }else {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
      }
    }catch (e) {
      log(e.toString());
    }
    return result;
  }

  Future<bool> reaction({int id,String reaction,String token})async{
    bool result = false;
    debugPrint("https://api.mateapp.us/api/event/$id/react");
    log(token);
    Map body = {
      "reaction": reaction
    };
    debugPrint(body.toString());
    try {
      final response = await http.post(
        Uri.parse("https://api.mateapp.us/api/event/$id/react"),
        headers: {"Authorization": "Bearer" +token},
        body: body,
      );
      if (response.statusCode == 200) {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
        if(parsed["success"]==true){
          result = true;
        }
      }else {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
      }
    }catch (e) {
      log(e.toString());
    }
    return result;
  }



  Future<dynamic> commentReply({String content,int id,String token,int parentId})async{
    dynamic result = false;
    debugPrint("https://api.mateapp.us/api/event/$id/comment");
    log(token);
    Map data = {
      "content": content,
      "parent_id": parentId
    };
    try {
      final response = await http.post(
        Uri.parse("https://api.mateapp.us/api/event/$id/comment"),
        headers: {"Authorization": "Bearer" +token,"Content-type":"application/json"},
        body: jsonEncode(data),
      );
      if (response.statusCode == 201) {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
        if(parsed["success"]==true){
          result = parsed;
          //result = true;
        }
      }else {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
      }
    }catch (e) {
      log(e.toString());
    }
    return result;
  }




  Future<bool> deleteComment({int id,String token})async{
    bool result = false;
    debugPrint("https://api.mateapp.us/api/event/comment/$id/delete");
    log(token);
    try {
      final response = await http.post(
        Uri.parse("https://api.mateapp.us/api/event/comment/$id/delete"),
        headers: {"Authorization": "Bearer" +token},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
        if(parsed["success"]==true){
          result = true;
        }
      }else {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
      }
    }catch (e) {
      log(e.toString());
    }
    return result;
  }



  Future<bool> deleteEvent({int id,String token})async{
    bool result = false;
    debugPrint("https://api.mateapp.us/api/event/$id/delete");
    log(token);
    try {
      final response = await http.post(
        Uri.parse("https://api.mateapp.us/api/event/$id/delete"),
        headers: {"Authorization": "Bearer" +token},
      );
      if (response.statusCode == 200) {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
        if(parsed["success"]==true){
          result = true;
        }
      }else {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
      }
    }catch (e) {
      log(e.toString());
    }
    return result;
  }

  Future<EventCategoryModel> getCategory({String token})async{
    EventCategoryModel eventCategoryModel = EventCategoryModel(data: [],success: false,message: "");
    debugPrint("https://api.mateapp.us/api/events/types");
    debugPrint(token);
    try {
      final response = await http.get(
        Uri.parse("https://api.mateapp.us/api/events/types"),
        headers: {"Authorization": "Bearer" +token},
      );
      if (response.statusCode == 200) {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
        eventCategoryModel = EventCategoryModel.fromJson(parsed);
      }else {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
      }
    }catch (e) {
      log(e.toString());
    }
    return eventCategoryModel;
  }
  

}