// // To parse this JSON data, do
// //
// //     final eventCommentListingModel = eventCommentListingModelFromJson(jsonString);
//
// import 'dart:convert';
//
// EventCommentListingModel eventCommentListingModelFromJson(String str) => EventCommentListingModel.fromJson(json.decode(str));
//
// String eventCommentListingModelToJson(EventCommentListingModel data) => json.encode(data.toJson());
//
// class EventCommentListingModel {
//   EventCommentListingModel({
//     this.success,
//     this.data,
//     this.message,
//   });
//
//   bool success;
//   Data data;
//   String message;
//
//   factory EventCommentListingModel.fromJson(Map<String, dynamic> json) => EventCommentListingModel(
//     success: json["success"],
//     data: Data.fromJson(json["data"]),
//     message: json["message"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "success": success,
//     "data": data.toJson(),
//     "message": message,
//   };
// }
//
// class Data {
//   Data({
//     this.result,
//     this.pagination,
//     this.commentsCount,
//   });
//
//   List<Result> result;
//   Pagination pagination;
//   int commentsCount;
//
//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//     result: List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
//     pagination: Pagination.fromJson(json["pagination"]),
//     commentsCount: json["comments_count"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "result": List<dynamic>.from(result.map((x) => x.toJson())),
//     "pagination": pagination.toJson(),
//     "comments_count": commentsCount,
//   };
// }
//
// class Pagination {
//   Pagination({
//     this.total,
//     this.count,
//     this.perPage,
//     this.currentPage,
//     this.totalPages,
//     this.morePages,
//   });
//
//   int total;
//   int count;
//   int perPage;
//   int currentPage;
//   int totalPages;
//   bool morePages;
//
//   factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
//     total: json["total"],
//     count: json["count"],
//     perPage: json["per_page"],
//     currentPage: json["current_page"],
//     totalPages: json["total_pages"],
//     morePages: json["more_pages"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "total": total,
//     "count": count,
//     "per_page": perPage,
//     "current_page": currentPage,
//     "total_pages": totalPages,
//     "more_pages": morePages,
//   };
// }
//
// class Result {
//   Result({
//     this.id,
//     this.parentId,
//     this.eventId,
//     this.userId,
//     this.content,
//     this.status,
//     this.createdAt,
//     this.updatedAt,
//     this.repliesCount,
//     this.user,
//     this.replies,
//   });
//
//   int id;
//   dynamic parentId;
//   int eventId;
//   int userId;
//   String content;
//   String status;
//   DateTime createdAt;
//   DateTime updatedAt;
//   int repliesCount;
//   User user;
//   List<dynamic> replies;
//
//   factory Result.fromJson(Map<String, dynamic> json) => Result(
//     id: json["id"],
//     parentId: json["parent_id"],
//     eventId: json["event_id"],
//     userId: json["user_id"],
//     content: json["content"],
//     status: json["status"],
//     createdAt: DateTime.parse(json["created_at"]),
//     updatedAt: DateTime.parse(json["updated_at"]),
//     repliesCount: json["replies_count"],
//     user: User.fromJson(json["user"]),
//     replies: List<dynamic>.from(json["replies"].map((x) => x)),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "parent_id": parentId,
//     "event_id": eventId,
//     "user_id": userId,
//     "content": content,
//     "status": status,
//     "created_at": createdAt.toIso8601String(),
//     "updated_at": updatedAt.toIso8601String(),
//     "replies_count": repliesCount,
//     "user": user.toJson(),
//     "replies": List<dynamic>.from(replies.map((x) => x)),
//   };
// }
//
// class User {
//   User({
//     this.uuid,
//     this.firstName,
//     this.lastName,
//     this.displayName,
//     this.firebaseUid,
//     this.profilePhoto,
//   });
//
//   String uuid;
//   dynamic firstName;
//   dynamic lastName;
//   String displayName;
//   String firebaseUid;
//   String profilePhoto;
//
//   factory User.fromJson(Map<String, dynamic> json) => User(
//     uuid: json["uuid"],
//     firstName: json["first_name"],
//     lastName: json["last_name"],
//     displayName: json["display_name"],
//     firebaseUid: json["firebase_uid"],
//     profilePhoto: json["profile_photo"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "uuid": uuid,
//     "first_name": firstName,
//     "last_name": lastName,
//     "display_name": displayName,
//     "firebase_uid": firebaseUid,
//     "profile_photo": profilePhoto,
//   };
// }



// To parse this JSON data, do
//
//     final eventCommentListingModel = eventCommentListingModelFromJson(jsonString);

import 'dart:convert';

EventCommentListingModel eventCommentListingModelFromJson(String str) => EventCommentListingModel.fromJson(json.decode(str));

String eventCommentListingModelToJson(EventCommentListingModel data) => json.encode(data.toJson());

class EventCommentListingModel {
  EventCommentListingModel({
    this.success,
    this.data,
    this.message,
  });

  bool? success;
  Data? data;
  String? message;

  factory EventCommentListingModel.fromJson(Map<String, dynamic> json) => EventCommentListingModel(
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
    this.commentsCount,
  });

  List<Result>? result;
  Pagination? pagination;
  int? commentsCount;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    result: List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
    pagination: Pagination.fromJson(json["pagination"]),
    commentsCount: json["comments_count"],
  );

  Map<String, dynamic> toJson() => {
    "result": List<dynamic>.from(result!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
    "comments_count": commentsCount,
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
  Result({
    this.id,
    this.parentId,
    this.eventId,
    this.userId,
    this.content,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.repliesCount,
    this.user,
    this.replies,
    this.isDeleting = false
  });

  int? id;
  int? parentId;
  int? eventId;
  int? userId;
  String? content;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? repliesCount;
  User? user;
  List<Result>? replies;
  bool? isDeleting;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    parentId: json["parent_id"] == null ? null : json["parent_id"],
    eventId: json["event_id"],
    userId: json["user_id"],
    content: json["content"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    repliesCount: json["replies_count"] == null ? null : json["replies_count"],
    user: User.fromJson(json["user"]),
    replies: json["replies"] == null ? null : List<Result>.from(json["replies"].map((x) => Result.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "parent_id": parentId == null ? null : parentId,
    "event_id": eventId,
    "user_id": userId,
    "content": content,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "replies_count": repliesCount == null ? null : repliesCount,
    "user": user?.toJson(),
    "replies": replies == null ? null : List<dynamic>.from(replies!.map((x) => x.toJson())),
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
  dynamic firstName;
  dynamic lastName;
  String? displayName;
  String? firebaseUid;
  String? profilePhoto;

  factory User.fromJson(Map<String, dynamic> json) => User(
    uuid: json["uuid"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    displayName: json["display_name"],
    firebaseUid: json["firebase_uid"],
    profilePhoto: json["profile_photo"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "first_name": firstName,
    "last_name": lastName,
    "display_name": displayName,
    "firebase_uid": firebaseUid,
    "profile_photo": profilePhoto,
  };
}
