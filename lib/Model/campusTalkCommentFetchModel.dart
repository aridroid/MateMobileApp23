class CampusTalkCommentFetchModel {
  bool success;
  Data data;
  String message;

  CampusTalkCommentFetchModel({this.success, this.data, this.message});

  CampusTalkCommentFetchModel.fromJson(Map<String, dynamic> json) {
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
  int commentsCount;

  Data({this.result, this.pagination, this.commentsCount});

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
    commentsCount = json['comments_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination.toJson();
    }
    data['comments_count'] = this.commentsCount;
    return data;
  }
}

class Result {
  int id;
  int parentId;
  int discussionPostId;
  int userId;
  String content;
  String url;
  int isAnonymous;
  String createdAt;
  String updatedAt;
  int repliesCount;
  int likesCount;
  User user;
  IsLiked isLiked;
  List<Replies> replies;
  bool isDeleting=false;
  bool upVoteLoader=false;

  Result(
      {this.id,
        this.parentId,
        this.discussionPostId,
        this.userId,
        this.content,
        this.url,
        this.isAnonymous,
        this.createdAt,
        this.updatedAt,
        this.repliesCount,
        this.likesCount,
        this.user,
        this.isLiked,
        this.replies,
        this.isDeleting,
        this.upVoteLoader,
      });

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentId = json['parent_id'];
    discussionPostId = json['discussion_post_id'];
    userId = json['user_id'];
    content = json['content'];
    url = json['url'];
    isAnonymous = json['is_anonymous'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    repliesCount = json['replies_count'];
    likesCount = json['likes_count'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    isLiked = json['is_liked'] != null
        ? new IsLiked.fromJson(json['is_liked'])
        : null;
    if (json['replies'] != null) {
      replies = new List<Replies>();
      json['replies'].forEach((v) {
        replies.add(new Replies.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['parent_id'] = this.parentId;
    data['discussion_post_id'] = this.discussionPostId;
    data['user_id'] = this.userId;
    data['content'] = this.content;
    data['url'] = this.url;
    data['is_anonymous'] = this.isAnonymous;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['replies_count'] = this.repliesCount;
    data['likes_count'] = this.likesCount;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    if (this.isLiked != null) {
      data['is_liked'] = this.isLiked.toJson();
    }
    if (this.replies != null) {
      data['replies'] = this.replies.map((v) => v.toJson()).toList();
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

class IsLiked {
  int id;
  int commentId;
  int userId;
  String createdAt;
  String updatedAt;

  IsLiked(
      {this.id, this.commentId, this.userId, this.createdAt, this.updatedAt});

  IsLiked.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    commentId = json['comment_id'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['comment_id'] = this.commentId;
    data['user_id'] = this.userId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}


class Replies {
  int id;
  int parentId;
  int discussionPostId;
  int userId;
  String content;
  String url;
  int isAnonymous;
  String createdAt;
  String updatedAt;
  int likesCount;
  IsLiked isLiked;
  User user;
  bool isDeleting= false;
  bool upVoteLoader=false;

  Replies(
      {this.id,
        this.parentId,
        this.discussionPostId,
        this.userId,
        this.content,
        this.url,
        this.isAnonymous,
        this.createdAt,
        this.updatedAt,
        this.likesCount,
        this.isLiked,
        this.user,
        this.isDeleting,
        this.upVoteLoader,
      });

  Replies.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentId = json['parent_id'];
    discussionPostId = json['discussion_post_id'];
    userId = json['user_id'];
    content = json['content'];
    url = json['url'];
    isAnonymous = json['is_anonymous'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    likesCount = json['likes_count'];
    isLiked = json['is_liked'] != null
        ? new IsLiked.fromJson(json['is_liked'])
        : null;
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['parent_id'] = this.parentId;
    data['discussion_post_id'] = this.discussionPostId;
    data['user_id'] = this.userId;
    data['content'] = this.content;
    data['url'] = this.url;
    data['is_anonymous'] = this.isAnonymous;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['likes_count'] = this.likesCount;
    if (this.isLiked != null) {
      data['is_liked'] = this.isLiked.toJson();
    }
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
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
