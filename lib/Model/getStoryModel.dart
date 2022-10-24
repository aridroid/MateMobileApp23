class GetStoryModel {
  bool success;
  Data data;
  String message;

  GetStoryModel({this.success, this.data, this.message});

  GetStoryModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  List<Result> result;
  Pagination pagination;

  Data({this.result, this.pagination});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result.add(new Result.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination.toJson();
    }
    return data;
  }
}

class Result {
  int id;
  String uuid;
  int userId;
  String text;
  String status;
  String createdAt;
  String updatedAt;
  List<String> media;
  User user;

  Result(
      {this.id,
        this.uuid,
        this.userId,
        this.text,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.media,
        this.user});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    userId = json['user_id'];
    text = json['text'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    media = json['media'].cast<String>();
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uuid'] = this.uuid;
    data['user_id'] = this.userId;
    data['text'] = this.text;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['media'] = this.media;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

class User {
  String uuid;
  String firstName;
  String lastName;
  String displayName;
  String firebaseUid;
  String profilePhoto;

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

class Pagination {
  int total;
  int count;
  int perPage;
  int currentPage;
  int totalPages;
  bool morePages;

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
