// To parse this JSON data, do
//
//     final eventListingModel = eventListingModelFromJson(jsonString);

import 'dart:convert';

EventListingModel eventListingModelFromJson(String str) => EventListingModel.fromJson(json.decode(str));

String eventListingModelToJson(EventListingModel data) => json.encode(data.toJson());

class EventListingModel {
  EventListingModel({
    this.success,
    this.data,
    this.message,
  });

  bool? success;
  Data? data;
  String? message;

  factory EventListingModel.fromJson(Map<String, dynamic> json) => EventListingModel(
    success: json["success"],
    data: Data.fromJson(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data?.toJson(),
    "message": message,
  };
}

class Data {
  Data({
    this.result,
    this.pagination,
  });

  List<Result>? result;
  Pagination? pagination;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    result: List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
    pagination: Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "result": List<dynamic>.from(result!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}

class Pagination {
  Pagination({
    this.total,
    this.count,
    this.perPage,
    this.currentPage,
    this.totalPages,
    this.morePages,
  });

  int? total;
  int? count;
  int? perPage;
  int? currentPage;
  int? totalPages;
  bool? morePages;

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    total: json["total"],
    count: json["count"],
    perPage: json["per_page"],
    currentPage: json["current_page"],
    totalPages: json["total_pages"],
    morePages: json["more_pages"],
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "count": count,
    "per_page": perPage,
    "current_page": currentPage,
    "total_pages": totalPages,
    "more_pages": morePages,
  };
}

class Result {
  Result( {
    this.id,
    this.uuid,
    this.userId,
    this.title,
    this.description,
    this.locationOpt,
    this.typeId,
    this.location,
    this.hyperLinkText,
    this.hyperLink,
    this.date,
    this.time,
    this.endTime,
    this.photoUrl,
    this.videoUrl,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.bookmarksCount,
    this.commentsCount,
    this.goingList,
    this.user,
    this.isBookmarked,
    this.isReacted,
    this.isFollowed,
  });

  int? id;
  String? uuid;
  int? userId;
  String? title;
  String? description;
  String? locationOpt;
  int? typeId;
  String? location;
  String? hyperLinkText;
  String? hyperLink;
  DateTime? date;
  String? time;
  String? endTime;
  String? photoUrl;
  String? videoUrl;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? bookmarksCount;
  int? commentsCount;
  List<GoingList>? goingList;
  User? user;
  dynamic isBookmarked;
  IsReacted? isReacted;
  bool? isFollowed;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    uuid: json["uuid"],
    userId: json["user_id"],
    title: json["title"],
    description: json["description"],
    locationOpt: json["location_opt"]??"On Campus",
    typeId: json["type_id"]??1,
    location: json["location"],
    hyperLinkText: json["hyperlinkText"],
    hyperLink: json["hyperlink"],
    date: DateTime.parse(json["date"]),
    time: json["time"],
    endTime:  json["end_time"],
    photoUrl: json["photo_url"] == null ? null : json["photo_url"],
    videoUrl: json["video_url"] == null ? null : json["video_url"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    bookmarksCount: json["bookmarks_count"],
    commentsCount: json["comments_count"],
    goingList: json.containsKey('going_list')?List<GoingList>.from(json["going_list"].map((x) => GoingList.fromJson(x))):[],
    user: User.fromJson(json["user"]),
    isBookmarked: json["is_bookmarked"],
    isReacted: json["is_reacted"] == null ? null : IsReacted.fromJson(json["is_reacted"]),
    isFollowed: json["is_followed"] == null ? false : true,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "uuid": uuid,
    "user_id": userId,
    "title": title,
    "description": description,
    "location_opt": locationOpt,
    "type_id": typeId,
    "location": location,
    "hyperlinkText": hyperLinkText,
    "hyperlink": hyperLink,
    "date": "${date?.year.toString().padLeft(4, '0')}-${date?.month.toString().padLeft(2, '0')}-${date?.day.toString().padLeft(2, '0')}",
    "time": time,
    "end_time" : endTime,
    "photo_url": photoUrl == null ? null : photoUrl,
    "video_url": videoUrl == null ? null : videoUrl,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "bookmarks_count": bookmarksCount,
    "comments_count": commentsCount,
    "going_list" : List<dynamic>.from(goingList!.map((x) => x.toJson())),
    "user": user?.toJson(),
    "is_bookmarked": isBookmarked,
    "is_reacted": isReacted == null ? null : isReacted?.toJson(),
    "is_followed": isFollowed,
  };
}


class GoingList {
  GoingList({
    this.id,
    this.firstName,
    this.lastName,
    this.displayName,
    this.firebaseUid,
    this.profilePhoto,
  });
  int? id;
  String? firstName;
  String? lastName;
  String? displayName;
  String? firebaseUid;
  String? profilePhoto;

  factory GoingList.fromJson(Map<String, dynamic> json) => GoingList(
    id : json['id'],
    firstName : json["first_name"] == null ? null : json["first_name"],
    lastName : json["last_name"] == null ? null : json["last_name"],
    displayName : json['display_name'],
    firebaseUid : json['firebase_uid'],
    profilePhoto : json['profile_photo'],
  );

  Map<String, dynamic> toJson() => {
    "id" : id,
    'first_name' : firstName,
    'last_name' : lastName,
    'display_name' : displayName,
    'firebase_uid' : firebaseUid,
    'profile_photo' : profilePhoto,
  };
}


class IsReacted {
  IsReacted({
    this.id,
    this.eventId,
    this.userId,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? eventId;
  int? userId;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory IsReacted.fromJson(Map<String, dynamic> json) => IsReacted(
    id: json["id"],
    eventId: json["event_id"],
    userId: json["user_id"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "event_id": eventId,
    "user_id": userId,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class User {
  User({
    this.uuid,
    this.firstName,
    this.lastName,
    this.displayName,
    this.firebaseUid,
    this.profilePhoto,
  });

  String? uuid;
  String? firstName;
  String? lastName;
  String? displayName;
  String? firebaseUid;
  String? profilePhoto;

  factory User.fromJson(Map<String, dynamic> json) => User(
    uuid: json["uuid"],
    firstName: json["first_name"] == null ? null : json["first_name"],
    lastName: json["last_name"] == null ? null : json["last_name"],
    displayName: json["display_name"],
    firebaseUid: json["firebase_uid"],
    profilePhoto: json["profile_photo"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "first_name": firstName == null ? null : firstName,
    "last_name": lastName == null ? null : lastName,
    "display_name": displayName,
    "firebase_uid": firebaseUid,
    "profile_photo": profilePhoto,
  };
}
