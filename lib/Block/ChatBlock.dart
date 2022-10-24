import 'package:mate_app/Model/ChatModel.dart';
import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatBlock with ChangeNotifier {
  List<ChatModel> ourChats = List<ChatModel>();
  Future<void> sendMessage(String msg, String user, String date) async {
    try {
      const url = 'https://mate-app-b5fe6.firebaseio.com/chats.json';
      await http.post(Uri.parse(url),
          body: json.encode({'msg': msg, 'user': user, 'date': date}));
      // fetchMessage();
      notifyListeners();
    } catch (ex) {
      print(ex.toString());
    }
  }

  Future<void> fetchMessage() async {
    try {
      const url = 'https://mate-app-b5fe6.firebaseio.com/chats.json';
      var response = await http.get(
        Uri.parse(url),
      );
      final List<ChatModel> chatModelList = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      if (extractedData == null) {
        return;
      }
      extractedData.forEach((key, value) {
        chatModelList.add(ChatModel(
            msg: value["msg"], user: value["user"], date: value["date"]));
      });
      print(response.body.toString());
      ourChats = chatModelList;
      notifyListeners();
    } catch (ex) {
      print(ex.toString());
    }
  }

  List<ChatModel> get msgList {
    if (ourChats == null) {
      return [];
    }
    return ourChats;
  }
}
