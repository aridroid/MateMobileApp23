// To parse this JSON data, do
//
//     final universityListingModel = universityListingModelFromJson(jsonString);

import 'dart:convert';

UniversityListingModel universityListingModelFromJson(String str) => UniversityListingModel.fromJson(json.decode(str));

String universityListingModelToJson(UniversityListingModel data) => json.encode(data.toJson());

class UniversityListingModel {
  UniversityListingModel({
    this.success,
    this.message,
    this.data,
  });

  bool? success;
  String? message;
  List<Datum>? data;

  factory UniversityListingModel.fromJson(Map<String, dynamic> json) => UniversityListingModel(
    success: json["success"],
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.id,
    this.uuid,
    this.name,
  });

  int? id;
  String? uuid;
  String? name;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    uuid: json["uuid"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "uuid": uuid,
    "name": name,
  };
}
