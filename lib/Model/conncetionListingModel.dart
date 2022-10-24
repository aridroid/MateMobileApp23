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
