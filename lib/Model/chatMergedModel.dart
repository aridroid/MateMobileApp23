// To parse this JSON data, do
//
//     final chatMergedModel = chatMergedModelFromJson(jsonString);

import 'dart:convert';

ChatMergedModel chatMergedModelFromJson(String str) => ChatMergedModel.fromJson(json.decode(str));

String chatMergedModelToJson(ChatMergedModel data) => json.encode(data.toJson());

class ChatMergedModel {
  ChatMergedModel({
    this.success,
    this.data,
    this.message,
  });

  bool success;
  List<Datum> data;
  String message;

  factory ChatMergedModel.fromJson(Map<String, dynamic> json) => ChatMergedModel(
    success: json["success"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "message": message,
  };
}

class Datum {
  Datum({
    this.roomId,
    this.totalMessages,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.unreadMessages,
    this.isMuted,
    this.isPinned,
    this.receiverUid,
  });

  String roomId;
  int totalMessages;
  String type;
  DateTime createdAt;
  DateTime updatedAt;
  int unreadMessages;
  bool isMuted;
  int isPinned;
  String receiverUid;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    roomId: json["room_id"],
    totalMessages: json["total_messages"],
    type: json["type"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    unreadMessages: json["unread_messages"],
    isMuted: json["is_muted"],
    isPinned: json["is_pinned"],
    receiverUid: json["receiver_uid"] == null ? null : json["receiver_uid"],
  );

  Map<String, dynamic> toJson() => {
    "room_id": roomId,
    "total_messages": totalMessages,
    "type": type,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "unread_messages": unreadMessages,
    "is_muted": isMuted,
    "is_pinned": isPinned,
    "receiver_uid": receiverUid == null ? null : receiverUid,
  };
}


class CustomDataForChatList{
  CustomDataForChatList({
    this.name,
    this.roomId,
    this.totalMessages,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.unreadMessages,
    this.isMuted,
    this.isPinned,
    this.receiverUid,
  });

  String name;
  String roomId;
  int totalMessages;
  String type;
  DateTime createdAt;
  DateTime updatedAt;
  int unreadMessages;
  bool isMuted;
  int isPinned;
  String receiverUid;
}