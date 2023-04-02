class CampusTalkPostsModel {
  bool success;
  Data data;
  String message;

  CampusTalkPostsModel({this.success, this.data, this.message});

  CampusTalkPostsModel.fromJson(Map<String, dynamic> json) {
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
      result = new List<Result>();
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
  int userId;
  String url;
  String photoUrl;
  String videoUrl;
  String audioUrl;
  String title;
  String description;
  String status;
  String createdAt;
  String updatedAt;
  int isAnonymous;
  String anonymousUser;
  int bookmarksCount;
  int likesCount;
  int dislikesCount;
  int commentsCount;
  User user;
  IsBookmarked isBookmarked;
  IsLiked isLiked;
  IsLiked isDisliked;
  bool bookmarkLoader=false;
  bool deleteLoader=false;
  bool upVoteLoader=false;
  List<CampusTalkTypes> campusTalkTypes;
  bool isPlaying = false;
  bool isPaused = false;
  bool isLoadingAudio = false;

  Result(
      {this.id,
        this.userId,
        this.url,
        this.photoUrl,
        this.videoUrl,
        this.audioUrl,
        this.title,
        this.description,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.isAnonymous,
        this.anonymousUser,
        this.bookmarksCount,
        this.likesCount,
        this.dislikesCount,
        this.commentsCount,
        this.user,
        this.isBookmarked,
        this.isLiked,
        this.isDisliked,
        this.bookmarkLoader,
        this.deleteLoader,
        this.upVoteLoader,
        this.campusTalkTypes,
        this.isPlaying,
        this.isPaused,
        this.isLoadingAudio,
      });

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    url = json['url'];
    photoUrl = json['photo_url'];
    videoUrl = json['video_url'];
    audioUrl = json['audio_url'];
    title = json['title'];
    description = json['description'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isAnonymous = json['is_anonymous'].runtimeType == int? json['is_anonymous']:int.parse(json['is_anonymous']);
    anonymousUser = json['anonymous_user'];
    bookmarksCount = json['bookmarks_count'];
    likesCount = json['likes_count'];
    dislikesCount = json['dislikes_count'];
    commentsCount = json['comments_count'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    isBookmarked = json['is_bookmarked'] != null
        ? new IsBookmarked.fromJson(json['is_bookmarked'])
        : null;
    isLiked = json['is_liked'] != null
        ? new IsLiked.fromJson(json['is_liked'])
        : null;
    isDisliked = json['is_disliked'] != null
        ? new IsLiked.fromJson(json['is_disliked'])
        : null;
    if (json['campus_talk_types'] != null) {
      campusTalkTypes = <CampusTalkTypes>[];
      json['campus_talk_types'].forEach((v) {
        campusTalkTypes.add(new CampusTalkTypes.fromJson(v));
      });
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['url'] = this.url;
    data['photo_url'] = this.photoUrl;
    data['video_url'] = this.videoUrl;
    data['audio_url'] = this.audioUrl;
    data['title'] = this.title;
    data['description'] = this.description;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['is_anonymous'] = this.isAnonymous;
    data['anonymous_user'] = this.anonymousUser;
    data['bookmarks_count'] = this.bookmarksCount;
    data['likes_count'] = this.likesCount;
    data['dislikes_count'] = this.dislikesCount;
    data['comments_count'] = this.commentsCount;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    if (this.isBookmarked != null) {
      data['is_bookmarked'] = this.isBookmarked.toJson();
    }
    if (this.isLiked != null) {
      data['is_liked'] = this.isLiked.toJson();
    }
    if (this.isDisliked != null) {
      data['is_disliked'] = this.isDisliked.toJson();
    }
    if (this.campusTalkTypes != null) {
      data['campus_talk_types'] =
          this.campusTalkTypes.map((v) => v.toJson()).toList();
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
  String university;

  User(
      {this.uuid,
        this.firstName,
        this.lastName,
        this.displayName,
        this.firebaseUid,
        this.university,
        this.profilePhoto});

  User.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    displayName = json['display_name'];
    firebaseUid = json['firebase_uid'];
    profilePhoto = json['profile_photo'];
    university = json['university'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['display_name'] = this.displayName;
    data['firebase_uid'] = this.firebaseUid;
    data['profile_photo'] = this.profilePhoto;
    data['university'] = this.university;
    return data;
  }
}

class IsBookmarked {
  int id;
  int postId;
  int userId;
  String createdAt;
  String updatedAt;

  IsBookmarked(
      {this.id, this.postId, this.userId, this.createdAt, this.updatedAt});

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

class IsLiked {
  int id;
  int postId;
  int userId;
  String createdAt;
  String updatedAt;

  IsLiked(
      {this.id, this.postId, this.userId, this.createdAt, this.updatedAt});

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

class CampusTalkTypes {
  int id;
  int campusTalkId;
  int campusTalkTypeId;
  String createdAt;
  String updatedAt;
  Type type;

  CampusTalkTypes(
      {this.id,
        this.campusTalkId,
        this.campusTalkTypeId,
        this.createdAt,
        this.updatedAt,
        this.type});

  CampusTalkTypes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    campusTalkId = json['campus_talk_id'];
    campusTalkTypeId = json['campus_talk_type_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    type = json['type'] != null ? new Type.fromJson(json['type']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['campus_talk_id'] = this.campusTalkId;
    data['campus_talk_type_id'] = this.campusTalkTypeId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.type != null) {
      data['type'] = this.type.toJson();
    }
    return data;
  }
}

class Type {
  int id;
  String uuid;
  String name;
  Null deletedAt;

  Type({this.id, this.uuid, this.name, this.deletedAt});

  Type.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    name = json['name'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uuid'] = this.uuid;
    data['name'] = this.name;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}