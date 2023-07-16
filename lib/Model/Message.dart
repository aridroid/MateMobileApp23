import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String? senderId;
  String? senderName;
  String? senderAvatar;
  String? textMessage;
  Timestamp? timestamp;
  int? messageType;
  String? id;

  Message(this.senderId, this.senderName, this.senderAvatar, this.textMessage,
      this.timestamp, this.messageType);

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["senderId"] = senderId;
    map["senderName"] = senderName;
    map["senderAvatar"] = senderAvatar;
    map["textMessage"] = textMessage;
    map["timestamp"] = timestamp;
    map["messageType"] = messageType;
    return map;
  }

  Message.fromMap(Map<String, dynamic> map) {
    senderId = map["senderId"];
    senderName = map["senderName"];
    senderAvatar = map["senderAvatar"];
    textMessage = map["textMessage"];
    timestamp = map["timestamp"];
    messageType = map["messageType"];
  }
}
