class CampusLiveCommentFetchModel {
  bool? success;
  Data? data;
  String? message;

  CampusLiveCommentFetchModel({this.success, this.data, this.message});

  CampusLiveCommentFetchModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data?.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  List<Result>? result;
  Pagination? pagination;
  int? commentsCount;

  Data({this.result, this.pagination, this.commentsCount});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = [];
      json['result'].forEach((v) {
        result?.add(new Result.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
    commentsCount = json['comments_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result?.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination?.toJson();
    }
    data['comments_count'] = this.commentsCount;
    return data;
  }
}

class Result {
  int? id;
  int? parentId;
  int? postId;
  int? userId;
  String? content;
  String? createdAt;
  String? updatedAt;
  int? repliesCount;
  int? likesCount;
  bool? isLikedBool;
  User? user;
  List<Replies>? replies;
  dynamic isLiked;
  bool? isDeleting = false;

  Result(
      {this.id,
        this.parentId,
        this.postId,
        this.userId,
        this.content,
        this.createdAt,
        this.updatedAt,
        this.repliesCount,
        this.likesCount,
        this.isLikedBool,
        this.user,
        this.replies,
        this.isLiked,
      this.isDeleting});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentId = json['parent_id'];
    postId = json['post_id'];
    userId = json['user_id'];
    content = json['content'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    repliesCount = json['replies_count'];
    likesCount = json['likes_count'];
    isLikedBool = json['is_liked_bool'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    if (json['replies'] != null) {
      replies = [];
      json['replies'].forEach((v) {
        replies?.add(new Replies.fromJson(v));
      });
    }
    isLiked = json['is_liked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['parent_id'] = this.parentId;
    data['post_id'] = this.postId;
    data['user_id'] = this.userId;
    data['content'] = this.content;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['replies_count'] = this.repliesCount;
    data['likes_count'] = this.likesCount;
    data['is_liked_bool'] = this.isLikedBool;
    if (this.user != null) {
      data['user'] = this.user?.toJson();
    }
    if (this.replies != null) {
      data['replies'] = this.replies?.map((v) => v.toJson()).toList();
    }
    data['is_liked'] = this.isLiked;
    return data;
  }
}

class User {
  String? uuid;
  String? firstName;
  String? lastName;
  String? displayName;
  String? firebaseUid;
  String? profilePhoto;

  User(
      {this.uuid,
        this.firstName,
        this.lastName,
        this.displayName,
        this.firebaseUid,
        this.profilePhoto});

  User.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    displayName = json['display_name'];
    firebaseUid = json['firebase_uid'];
    profilePhoto = json['profile_photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['display_name'] = this.displayName;
    data['firebase_uid'] = this.firebaseUid;
    data['profile_photo'] = this.profilePhoto;
    return data;
  }
}

class Replies {
  int? id;
  int? parentId;
  int? postId;
  int? userId;
  String? content;
  String? createdAt;
  String? updatedAt;
  bool? isLikedBool;
  User? user;
  dynamic isLiked;
  bool? isDeleting = false;

  Replies(
      {this.id,
        this.parentId,
        this.postId,
        this.userId,
        this.content,
        this.createdAt,
        this.updatedAt,
        this.isLikedBool,
        this.user,
        this.isLiked,
        this.isDeleting
      });

  Replies.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentId = json['parent_id'];
    postId = json['post_id'];
    userId = json['user_id'];
    content = json['content'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isLikedBool = json['is_liked_bool'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    isLiked = json['is_liked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['parent_id'] = this.parentId;
    data['post_id'] = this.postId;
    data['user_id'] = this.userId;
    data['content'] = this.content;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['is_liked_bool'] = this.isLikedBool;
    if (this.user != null) {
      data['user'] = this.user?.toJson();
    }
    data['is_liked'] = this.isLiked;
    return data;
  }
}

class Pagination {
  int? total;
  int? count;
  int? perPage;
  int? currentPage;
  int? totalPages;
  bool? morePages;

  Pagination(
      {this.total,
        this.count,
        this.perPage,
        this.currentPage,
        this.totalPages,
        this.morePages});

  Pagination.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    count = json['count'];
    perPage = json['per_page'];
    currentPage = json['current_page'];
    totalPages = json['total_pages'];
    morePages = json['more_pages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['count'] = this.count;
    data['per_page'] = this.perPage;
    data['current_page'] = this.currentPage;
    data['total_pages'] = this.totalPages;
    data['more_pages'] = this.morePages;
    return data;
  }
}
