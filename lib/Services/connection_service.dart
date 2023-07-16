import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart'as http;
import 'package:flutter/cupertino.dart';
import 'package:mate_app/Model/conncetionListingModel.dart';

class ConnectionService{


  Future<String> addConnection({required String uid,required String name,required String uuid,required String token})async{
    String result = "";
    debugPrint("https://api.mateapp.us/api/connection/requests/$uuid");
    log(token);
    Map data = {
      "uid": uid,
      "name": name,
    };
    try {
      final response = await http.post(
        Uri.parse("https://api.mateapp.us/api/connection/requests/$uuid"),
        headers: {"Authorization": "Bearer" +token},
        body: data,
      );
      if (response.statusCode == 200 || response.statusCode==201) {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
        result = parsed["message"];
        print(result);
      }else {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
      }
    }catch (e) {
      log(e.toString());
    }
    return result;
  }


  Future<List<Datum>> getConnection({required String token})async{
    List<Datum> list = [];
    debugPrint("https://api.mateapp.us/api/connections");
    debugPrint(token);
    try {
      final response = await http.get(
        Uri.parse("https://api.mateapp.us/api/connections"),
        headers: {"Authorization": "Bearer" +token},);
      if (response.statusCode == 200) {
        log(response.body);
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
        ConncetionLIstingModel conncetionLIstingModel = ConncetionLIstingModel.fromJson(parsed);
        list = conncetionLIstingModel.data!;
      }else {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
      }
    }catch (e) {
      log(e.toString());
    }
    return list;
  }

  Future<List<ConnectionGetSentData>> getConnectionRequestsSent({required String token})async{
    List<ConnectionGetSentData> list = [];
    debugPrint("https://api.mateapp.us/api/connection/requests");
    debugPrint(token);
    try {
      final response = await http.get(
        Uri.parse("https://api.mateapp.us/api/connection/requests"),
        headers: {"Authorization": "Bearer" +token},);
      if (response.statusCode == 200) {
        log(response.body);
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
        for(int i=0;i<parsed["data"].length;i++){
          list.add(ConnectionGetSentData.fromJson(parsed["data"][i]));
        }
        // ConncetionLIstingModel conncetionLIstingModel = ConncetionLIstingModel.fromJson(parsed);
        // list = conncetionLIstingModel.data;
      }else {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
      }
    }catch (e) {
      log(e.toString());
    }
    return list;
  }

  Future<List<ConnectionGetSentData>> getConnectionRequestsGet({required String token})async{
    List<ConnectionGetSentData> list = [];
    debugPrint("https://api.mateapp.us/api/connection/requests?reverse=1");
    debugPrint(token);
    try {
      final response = await http.get(
        Uri.parse("https://api.mateapp.us/api/connection/requests?reverse=1"),
        headers: {"Authorization": "Bearer" +token},);
      if (response.statusCode == 200) {
        log(response.body);
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
        for(int i=0;i<parsed["data"].length;i++){
          list.add(ConnectionGetSentData.fromJson(parsed["data"][i]));
        }
        // ConncetionLIstingModel conncetionLIstingModel = ConncetionLIstingModel.fromJson(parsed);
        // list = conncetionLIstingModel.data;
      }else {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
      }
    }catch (e) {
      log(e.toString());
    }
    return list;
  }

  Future<bool> connectionAcceptReject({required int connectionRequestId,required String status,required String token})async{
    bool result = false;
    debugPrint("https://api.mateapp.us/api/connection/requests/$connectionRequestId/update");
    log(token);
    Map data = {
      "status": status,
    };
    try {
      final response = await http.post(
        Uri.parse("https://api.mateapp.us/api/connection/requests/$connectionRequestId/update"),
        headers: {"Authorization": "Bearer" +token},
        body: data,
      );
      if (response.statusCode == 200 || response.statusCode==201) {
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



  Future<String> removeConnection({required int connId,required String token})async{
    String result = "";
    debugPrint("https://api.mateapp.us/api/connections/$connId/delete");
    log(token);
    try {
      final response = await http.post(
        Uri.parse("https://api.mateapp.us/api/connections/$connId/delete"),
        headers: {"Authorization": "Bearer" +token},
      );
      if (response.statusCode == 200 || response.statusCode==201) {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
        result = parsed["message"];
        print(result);
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