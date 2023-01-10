// To parse this JSON data, do
//
//     final conncetionLIstingModel = conncetionLIstingModelFromJson(jsonString);

import 'dart:convert';

ConncetionLIstingModel conncetionLIstingModelFromJson(String str) => ConncetionLIstingModel.fromJson(json.decode(str));

String conncetionLIstingModelToJson(ConncetionLIstingModel data) => json.encode(data.toJson());

class ConncetionLIstingModel {
  ConncetionLIstingModel({
    this.success,
    this.data,
    this.message,
  });

  bool success;
  List<Datum> data;
  String message;

  factory ConncetionLIstingModel.fromJson(Map<String, dynamic> json) => ConncetionLIstingModel(
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
    this.id,
    this.uid,
    this.name,
    this.userId,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String uid;
  String name;
  int userId;
  String status;
  DateTime createdAt;
  DateTime updatedAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    uid: json["uid"],
    name: json["name"],
    userId: json["user_id"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "uid": uid,
    "name": name,
    "user_id": userId,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}


class ConnectionGetSentData {
  int id;
  int connUserId;
  String connUid;
  String connName;
  int senderUserId;
  String senderUid;
  String senderName;
  Null status;
  String createdAt;
  String updatedAt;

  ConnectionGetSentData(
      {this.id,
        this.connUserId,
        this.connUid,
        this.connName,
        this.senderUserId,
        this.senderUid,
        this.senderName,
        this.status,
        this.createdAt,
        this.updatedAt});

  ConnectionGetSentData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    connUserId = json['conn_user_id'];
    connUid = json['conn_uid'];
    connName = json['conn_name'];
    senderUserId = json['sender_user_id'];
    senderUid = json['sender_uid'];
    senderName = json['sender_name'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['conn_user_id'] = this.connUserId;
    data['conn_uid'] = this.connUid;
    data['conn_name'] = this.connName;
    data['sender_user_id'] = this.senderUserId;
    data['sender_uid'] = this.senderUid;
    data['sender_name'] = this.senderName;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

