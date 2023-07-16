class CampusLiveCommentResponseModel {
  bool? success;
  Data? data;
  String? message;

  CampusLiveCommentResponseModel({this.success, this.data, this.message});

  CampusLiveCommentResponseModel.fromJson(Map<String, dynamic> json) {
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
  int? id;
  Null parentId;
  int? postId;
  int? userId;
  String? content;
  String? createdAt;
  String? updatedAt;
  int? likesCount;
  bool? isLikedBool;
  User? user;
  Null isLiked;

  Data(
      {this.id,
        this.parentId,
        this.postId,
        this.userId,
        this.content,
        this.createdAt,
        this.updatedAt,
        this.likesCount,
        this.isLikedBool,
        this.user,
        this.isLiked});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentId = json['parent_id'];
    postId = json['post_id'];
    userId = json['user_id'];
    content = json['content'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    likesCount = json['likes_count'];
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
    data['likes_count'] = this.likesCount;
    data['is_liked_bool'] = this.isLikedBool;
    if (this.user != null) {
      data['user'] = this.user?.toJson();
    }
    data['is_liked'] = this.isLiked;
    return data;
  }
}

class User {
  Null firstName;
  Null lastName;
  String? displayName;
  String? firebaseUid;

  User({this.firstName, this.lastName, this.displayName, this.firebaseUid});

  User.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    displayName = json['display_name'];
    firebaseUid = json['firebase_uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['display_name'] = this.displayName;
    data['firebase_uid'] = this.firebaseUid;
    return data;
  }
}
