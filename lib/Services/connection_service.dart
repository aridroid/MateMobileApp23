import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart'as http;
import 'package:flutter/cupertino.dart';
import 'package:mate_app/Model/conncetionListingModel.dart';

class ConnectionService{


  Future<String> addConnection({String uid,String name,String uuid,String token})async{
    String result = "";
    debugPrint("https://api.mateapp.us/api/connections/$uuid");
    log(token);
    Map data = {
      "uid": uid,
      "name": name,
    };
    try {
      final response = await http.post(
        Uri.parse("https://api.mateapp.us/api/connections/$uuid"),
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


  Future<List<Datum>> getConnection({String token})async{
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
        list = conncetionLIstingModel.data;
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