class CampusLivePostsModel {
  bool? success;
  Data? data;
  String? message;

  CampusLivePostsModel({this.success, this.data, this.message});

  CampusLivePostsModel.fromJson(Map<String, dynamic> json) {
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

  Data({this.result, this.pagination});

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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result?.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination?.toJson();
    }
    return data;
  }
}

class Result {
  int? id;
  int? userId;
  int? audioId;
  String? url;
  String? subject;
  String? description;
  String? createdAt;
  String? updatedAt;
  String? thumbnailUrl;
  String? featured;
  int? viewCount;
  int? commentsCount;
  late int likesCount;
  int? sharesCount;
  Credit? credit;
  User? user;
  String? creditUrl;
  IsLiked? isLiked;
  IsBookmarked? isBookmarked;
  bool? isFollowed;
  bool? likeLoader=false;
  bool? bookmarkLoader=false;
  bool? deleteLoader=false;
  IsShared? isShared;

  Result(
      {this.id,
        this.userId,
        this.audioId,
        this.url,
        this.subject,
        this.description,
        this.createdAt,
        this.updatedAt,
        this.thumbnailUrl,
        this.featured,
        this.viewCount,
        this.commentsCount,
        required this.likesCount,
        this.sharesCount,
        this.user,
        this.creditUrl,
        this.isLiked,
        this.isBookmarked,
        this.isFollowed,
        this.likeLoader,
        this.bookmarkLoader,
        this.deleteLoader,
        this.isShared,
      });

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    audioId = json['audio_id'];
    url = json['url'];
    subject = json['subject'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    thumbnailUrl = json['thumbnail_url'];
    featured = json['featured'];
    viewCount = json['view_count'];
    commentsCount = json['comments_count'];
    likesCount = json['likes_count'];
    sharesCount = json['shares_count'];
    isFollowed = json['is_followed'];
    credit = json['credit'] != null ? new Credit.fromJson(json['credit']) : null;
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    creditUrl = json['credit_url'];
    isLiked = json['is_liked'] != null
        ? new IsLiked.fromJson(json['is_liked'])
        : null;
    isBookmarked = json['is_bookmarked'] != null
        ? new IsBookmarked.fromJson(json['is_bookmarked'])
        : null;
    isShared = json['is_shared'] != null
        ? new IsShared.fromJson(json['is_shared'])
        : null;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['audio_id'] = this.audioId;
    data['url'] = this.url;
    data['subject'] = this.subject;
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['thumbnail_url'] = this.thumbnailUrl;
    data['featured'] = this.featured;
    data['view_count'] = this.viewCount;
    data['comments_count'] = this.commentsCount;
    data['likes_count'] = this.likesCount;
    data['shares_count'] = this.sharesCount;
    data['is_followed'] = this.isFollowed;
    if (this.credit != null) {
      data['credit'] = this.credit?.toJson();
    }
    if (this.user != null) {
      data['user'] = this.user?.toJson();
    }
    data['credit_url'] = this.creditUrl;
    if (this.isLiked != null) {
      data['is_liked'] = this.isLiked?.toJson();
    }
    if (this.isBookmarked != null) {
      data['is_bookmarked'] = this.isBookmarked?.toJson();
    }
    if (this.isShared != null) {
      data['is_shared'] = this.isShared?.toJson();
    }

    return data;
  }
}

class IsShared {
  int? id;
  int? userId;
  String? audioId;
  String? url;
  String? subject;
  String? description;
  String? createdAt;
  String? updatedAt;
  String? thumbnailUrl;
  String? featured;
  int? viewCount;
  int? parentId;
  int? commentsCount;
  int? likesCount;
  int? sharesCount;
  User? user;
  SuperCharge? superCharge;

  IsShared(
      {this.id,
        this.userId,
        this.audioId,
        this.url,
        this.subject,
        this.description,
        this.createdAt,
        this.updatedAt,
        this.thumbnailUrl,
        this.featured,
        this.viewCount,
        this.parentId,
        this.commentsCount,
        this.likesCount,
        this.sharesCount,
        this.user,
        this.superCharge,
      });

  IsShared.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    audioId = json['audio_id'];
    url = json['url'];
    subject = json['subject'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    thumbnailUrl = json['thumbnail_url'];
    featured = json['featured'];
    viewCount = json['view_count'];
    parentId = json['parent_id'];
    commentsCount = json['comments_count'];
    likesCount = json['likes_count'];
    sharesCount = json['shares_count'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    superCharge = json['super_charge'] != null
        ? new SuperCharge.fromJson(json['super_charge'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['audio_id'] = this.audioId;
    data['url'] = this.url;
    data['subject'] = this.subject;
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['thumbnail_url'] = this.thumbnailUrl;
    data['featured'] = this.featured;
    data['view_count'] = this.viewCount;
    data['parent_id'] = this.parentId;
    data['comments_count'] = this.commentsCount;
    data['likes_count'] = this.likesCount;
    data['shares_count'] = this.sharesCount;
    if (this.user != null) {
      data['user'] = this.user?.toJson();
    }
    if (this.superCharge != null) {
      data['super_charge'] = this.superCharge?.toJson();
    }

    return data;
  }
}

class SuperCharge {
  int? id;
  int? userId;
  int? audioId;
  String? url;
  String? subject;
  String? description;
  String? createdAt;
  String? updatedAt;
  String? thumbnailUrl;
  String? featured;
  int? viewCount;
  int? parentId;

  SuperCharge(
      {this.id,
        this.userId,
        this.audioId,
        this.url,
        this.subject,
        this.description,
        this.createdAt,
        this.updatedAt,
        this.thumbnailUrl,
        this.featured,
        this.viewCount,
        this.parentId});

  SuperCharge.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    audioId = json['audio_id'];
    url = json['url'];
    subject = json['subject'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    thumbnailUrl = json['thumbnail_url'];
    featured = json['featured'];
    viewCount = json['view_count'];
    parentId = json['parent_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['audio_id'] = this.audioId;
    data['url'] = this.url;
    data['subject'] = this.subject;
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['thumbnail_url'] = this.thumbnailUrl;
    data['featured'] = this.featured;
    data['view_count'] = this.viewCount;
    data['parent_id'] = this.parentId;
    return data;
  }
}


class Credit {
  String? firstName;
  String? lastName;
  String? displayName;
  String? username;

  Credit({this.firstName, this.lastName, this.displayName, this.username});

  Credit.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    displayName = json['display_name'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['display_name'] = this.displayName;
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

  User({this.uuid, this.firstName, this.lastName, this.displayName, this.firebaseUid, this.profilePhoto});

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

class IsLiked {
  int? id;
  int? postId;
  int? userId;
  String? createdAt;
  String? updatedAt;

  IsLiked({this.id, this.postId, this.userId, this.createdAt, this.updatedAt});

  IsLiked.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    postId = json['post_id'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['post_id'] = this.postId;
    data['user_id'] = this.userId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class IsBookmarked {
  int? id;
  int? postId;
  int? userId;
  String? createdAt;
  String? updatedAt;

  IsBookmarked({this.id, this.postId, this.userId, this.createdAt, this.updatedAt});

  IsBookmarked.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    postId = json['post_id'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['post_id'] = this.postId;
    data['user_id'] = this.userId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
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
