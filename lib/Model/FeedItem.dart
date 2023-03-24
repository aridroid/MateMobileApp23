class FeedItem {
  String id;
  int feedId;
  int feedTypeId;
  String title;
  String description;
  String location;
  String hyperlinkText;
  String hyperlink;
  String start;
  String end;
  String created;
  String type;
  List<FeedTypes> feedTypes;
  User user;
  List<Media> media;
  List<Media> mediaOther;
  IsLiked isLiked;
  bool isBookmarked;
  bool isFollowed;
  List<LikeCount> likeCount;
  int bookmarkCount;
  String feedCreatedAt;
  String feedUpdatedAt;
  IsShared isShared;
  int shareCount;
  int commentCount;
  bool likeLoader=false;
  bool bookmarkLoader=false;
  bool isPlaying = false;
  bool isPaused = false;
  bool isLoadingAudio = false;

  FeedItem(
      {this.id,
        this.feedId,
        this.feedTypeId,
        this.title,
        this.description,
        this.location,
        this.hyperlinkText,
        this.hyperlink,
        this.start,
        this.end,
        this.created,
        this.type,
        this.feedTypes,
        this.user,
        this.media,
        this.mediaOther,
        this.isLiked,
        this.isBookmarked,
        this.isFollowed,
        this.likeCount,
        this.bookmarkCount,
        this.feedCreatedAt,
        this.feedUpdatedAt,
        this.isShared,
        this.shareCount,
        this.commentCount,
        this.likeLoader,
        this.bookmarkLoader,
        this.isLoadingAudio,
        this.isPlaying,
        this.isPaused,
      });

  FeedItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    feedId = json['feed_id'];
    feedTypeId = json['feed_type_id'];
    title = json['title'];
    description = json['description'];
    location = json['location'];
    hyperlinkText = json['hyperlinkText'];
    hyperlink = json['hyperlink'];
    start = json['start'];
    end = json['end'];
    created = json['created'];
    type = json['type'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    isShared = json['is_shared'] != null
        ? new IsShared.fromJson(json['is_shared'])
        : null;
    if (json['media'] != null) {
      media = new List<Media>();
      json['media'].forEach((v) {
        media.add(new Media.fromJson(v));
      });
    }
    if (json['media_other'] != null) {
      mediaOther = new List<Media>();
      json['media_other'].forEach((v) {
        mediaOther.add(new Media.fromJson(v));
      });
    }
    isLiked = json['is_liked'] != null
        ? new IsLiked.fromJson(json['is_liked'])
        : null;
    isBookmarked = json['is_bookmarked'];
    isFollowed = json['is_followed'];

    if (json['like_count'] != null) {
      likeCount = new List<LikeCount>();
      json['like_count'].forEach((v) {
        likeCount.add(new LikeCount.fromJson(v));
      });
    }
    bookmarkCount = json['bookmark_count'];
    if (json['feed_types'] != null) {
      feedTypes = new List<FeedTypes>();
      json['feed_types'].forEach((v) {
        feedTypes.add(new FeedTypes.fromJson(v));
      });
    }
    feedCreatedAt = json['feed_created_at'];
    feedUpdatedAt = json['feed_updated_at'];
    shareCount = json['share_count'];
    commentCount = json['comment_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['feed_id'] = this.feedId;
    data['feed_type_id'] = this.feedTypeId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['location'] = this.location;
    data['start'] = this.start;
    data['end'] = this.end;
    data['created'] = this.created;
    data['type'] = this.type;
    if (this.feedTypes != null) {
      data['feed_types'] = this.feedTypes.map((v) => v.toJson()).toList();
    }
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    if (this.media != null) {
      data['media'] = this.media.map((v) => v.toJson()).toList();
    }
    if (this.mediaOther != null) {
      data['media_other'] = this.mediaOther.map((v) => v.toJson()).toList();
    }

    if (this.isLiked != null) {
      data['is_liked'] = this.isLiked.toJson();
    }
    data['is_bookmarked'] = this.isBookmarked;
    data['is_followed'] = this.isFollowed;
    if (this.likeCount != null) {
      data['like_count'] = this.likeCount.map((v) => v.toJson()).toList();
    }
    data['bookmark_count'] = this.bookmarkCount;
    data['feed_created_at'] = this.feedCreatedAt;
    data['feed_updated_at'] = this.feedUpdatedAt;
    if (this.isShared != null) {
      data['is_shared'] = this.isShared.toJson();
    }


    data['share_count'] = this.shareCount;
    data['comment_count'] = this.commentCount;
    return data;
  }
}

class IsLiked {
  int id;
  int feedId;
  int userId;
  int emojiValue;
  String createdAt;
  String updatedAt;

  IsLiked(
      {this.id,
        this.feedId,
        this.userId,
        this.emojiValue,
        this.createdAt,
        this.updatedAt});

  IsLiked.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    feedId = json['feed_id'];
    userId = json['user_id'];
    emojiValue = json['emoji_value'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['feed_id'] = this.feedId;
    data['user_id'] = this.userId;
    data['emoji_value'] = this.emojiValue;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}


class LikeCount {
  int emojiValue;
  int count;

  LikeCount({this.emojiValue, this.count});

  LikeCount.fromJson(Map<String, dynamic> json) {
    emojiValue = json['emoji_value'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['emoji_value'] = this.emojiValue;
    data['count'] = this.count;
    return data;
  }
}


class IsShared {
  String id;
  int feedId;
  String title;
  String description;
  String location;
  dynamic start;
  dynamic end;
  String created;
  List<FeedTypes> feedTypes;
  User user;
  List<Media> media;
  // IsLiked isLiked;
  bool isBookmarked;
  // int likeCount;
  int bookmarkCount;
  String feedCreatedAt;
  String feedUpdatedAt;
  // dynamic isShared;
  int shareCount;
  int commentCount;

  IsShared(
      {this.id,
        this.feedId,
        this.title,
        this.description,
        this.location,
        this.start,
        this.end,
        this.created,
        this.feedTypes,
        this.user,
        this.media,
        // this.isLiked,
        this.isBookmarked,
        // this.likeCount,
        this.bookmarkCount,
        this.feedCreatedAt,
        this.feedUpdatedAt,
        // this.isShared,
        this.shareCount,
        this.commentCount});

  IsShared.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    feedId = json['feed_id'];
    title = json['title'];
    description = json['description'];
    location = json['location'];
    start = json['start'];
    end = json['end'];
    created = json['created'];
    if (json['feed_types'] != null) {
      feedTypes = new List<FeedTypes>();
      json['feed_types'].forEach((v) {
        feedTypes.add(new FeedTypes.fromJson(v));
      });
    }
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    if (json['media'] != null) {
      media = new List<Media>();
      json['media'].forEach((v) {
        media.add(new Media.fromJson(v));
      });
    }
    // isLiked = json['is_liked'];
    isBookmarked = json['is_bookmarked'];
    // likeCount = json['like_count'];
    bookmarkCount = json['bookmark_count'];
    feedCreatedAt = json['feed_created_at'];
    feedUpdatedAt = json['feed_updated_at'];
    // isShared = json['is_shared'];
    shareCount = json['share_count'];
    commentCount = json['comment_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['feed_id'] = this.feedId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['location'] = this.location;
    data['start'] = this.start;
    data['end'] = this.end;
    data['created'] = this.created;
    if (this.feedTypes != null) {
      data['feed_types'] = this.feedTypes.map((v) => v.toJson()).toList();
    }
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    if (this.media != null) {
      data['media'] = this.media.map((v) => v.toJson()).toList();
    }
    // data['is_liked'] = this.isLiked;
    data['is_bookmarked'] = this.isBookmarked;
    // data['like_count'] = this.likeCount;
    data['bookmark_count'] = this.bookmarkCount;
    data['feed_created_at'] = this.feedCreatedAt;
    data['feed_updated_at'] = this.feedUpdatedAt;
    // data['is_shared'] = this.isShared;
    data['share_count'] = this.shareCount;
    data['comment_count'] = this.commentCount;
    return data;
  }
}

class User {
  String id;
  String name;
  String photoUrl;
  String firebaseUid;
  String university;

  User({this.id, this.name, this.photoUrl, this.firebaseUid,this.university});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    photoUrl = json['photo_url'];
    firebaseUid = json['firebase_uid'];
    university = json["university"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['photo_url'] = this.photoUrl;
    data['firebase_uid'] = this.firebaseUid;
    data['university'] = this.university;
    return data;
  }
}

class Media {
  String url;

  Media({this.url});

  Media.fromJson(Map<String, dynamic> json) {
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    return data;
  }
}

/*class FeedType {
  int id;
  String uuid;
  String name;
  dynamic deletedAt;

  FeedType({this.id, this.uuid, this.name, this.deletedAt});

  FeedType.fromJson(Map<String, dynamic> json) {
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
}*/

class FeedTypes {
  int id;
  int feedId;
  int feedTypeId;
  String createdAt;
  String updatedAt;
  Type type;

  FeedTypes(
      {this.id,
        this.feedId,
        this.feedTypeId,
        this.createdAt,
        this.updatedAt,
        this.type});

  FeedTypes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    feedId = json['feed_id'];
    feedTypeId = json['feed_type_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    type = json['type'] != null ? new Type.fromJson(json['type']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['feed_id'] = this.feedId;
    data['feed_type_id'] = this.feedTypeId;
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
  int status;
  String deletedAt;

  Type({this.id, this.uuid, this.name, this.deletedAt, this.status});

  Type.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    name = json['name'];
    status = json['status'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uuid'] = this.uuid;
    data['name'] = this.name;
    data['status'] = this.status;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}

class Links {
  String first;
  String last;
  Null prev;
  String next;

  Links({this.first, this.last, this.prev, this.next});

  Links.fromJson(Map<String, dynamic> json) {
    first = json['first'];
    last = json['last'];
    prev = json['prev'];
    next = json['next'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first'] = this.first;
    data['last'] = this.last;
    data['prev'] = this.prev;
    data['next'] = this.next;
    return data;
  }
}

class Meta {
  int currentPage;
  int from;
  int lastPage;
  List<Links> links;
  String path;
  int perPage;
  int to;
  int total;

  Meta(
      {this.currentPage,
        this.from,
        this.lastPage,
        this.links,
        this.path,
        this.perPage,
        this.to,
        this.total});

  Meta.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    from = json['from'];
    lastPage = json['last_page'];
    if (json['links'] != null) {
      links = new List<Links>();
      json['links'].forEach((v) {
        links.add(new Links.fromJson(v));
      });
    }
    path = json['path'];
    perPage = json['per_page'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    if (this.links != null) {
      data['links'] = this.links.map((v) => v.toJson()).toList();
    }
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}