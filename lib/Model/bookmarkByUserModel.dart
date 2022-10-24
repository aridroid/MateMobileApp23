import 'package:mate_app/Model/FeedItem.dart' as feedItem;

class BookmarkByUserModel {
  bool success;
  String message;
  Data data;

  BookmarkByUserModel({this.success, this.message, this.data});

  BookmarkByUserModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  List<Feeds> feeds;

  Data({this.feeds});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['feeds'] != null) {
      feeds = new List<Feeds>();
      json['feeds'].forEach((v) {
        feeds.add(new Feeds.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.feeds != null) {
      data['feeds'] = this.feeds.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Feeds {
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
  feedItem.IsLiked isLiked;
  bool isBookmarked;
  bool isFollowed;
  List<feedItem.LikeCount> likeCount;
  int bookmarkCount;
  String feedCreatedAt;
  String feedUpdatedAt;
  int shareCount;
  int commentCount;
  feedItem.IsShared isShared;


  Feeds(
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
        this.isLiked,
        this.isBookmarked,
        this.isFollowed,
        this.likeCount,
        this.bookmarkCount,
        this.feedCreatedAt,
        this.feedUpdatedAt,
        this.shareCount,
        this.commentCount,
        this.isShared,
      });

  Feeds.fromJson(Map<String, dynamic> json) {
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
    if (json['media'] != null) {
      media = new List<Media>();
      json['media'].forEach((v) {
        media.add(new Media.fromJson(v));
      });
    }
    isLiked = json['is_liked'] != null
        ? new feedItem.IsLiked.fromJson(json['is_liked'])
        : null;
    isBookmarked = json['is_bookmarked'];
    isFollowed = json['is_followed'];
    if (json['like_count'] != null) {
      likeCount = new List<feedItem.LikeCount>();
      json['like_count'].forEach((v) {
        likeCount.add(new feedItem.LikeCount.fromJson(v));
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
    isShared = json['is_shared'] != null
        ? new feedItem.IsShared.fromJson(json['is_shared'])
        : null;
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
    data['share_count'] = this.shareCount;
    data['comment_count'] = this.commentCount;
    if (this.isShared != null) {
      data['is_shared'] = this.isShared.toJson();
    }
    return data;
  }
}

// class IsShared {
//   String id;
//   int feedId;
//   String title;
//   String description;
//   String location;
//   dynamic start;
//   dynamic end;
//   String created;
//   List<FeedTypes> feedTypes;
//   User user;
//   List<Media> media;
//   bool isLiked;
//   bool isBookmarked;
//   int likeCount;
//   int bookmarkCount;
//   String feedCreatedAt;
//   String feedUpdatedAt;
//   // dynamic isShared;
//   int shareCount;
//   int commentCount;
//
//   IsShared(
//       {this.id,
//         this.feedId,
//         this.title,
//         this.description,
//         this.location,
//         this.start,
//         this.end,
//         this.created,
//         this.feedTypes,
//         this.user,
//         this.media,
//         this.isLiked,
//         this.isBookmarked,
//         this.likeCount,
//         this.bookmarkCount,
//         this.feedCreatedAt,
//         this.feedUpdatedAt,
//         // this.isShared,
//         this.shareCount,
//         this.commentCount});
//
//   IsShared.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     feedId = json['feed_id'];
//     title = json['title'];
//     description = json['description'];
//     location = json['location'];
//     start = json['start'];
//     end = json['end'];
//     created = json['created'];
//     if (json['feed_types'] != null) {
//       feedTypes = new List<FeedTypes>();
//       json['feed_types'].forEach((v) {
//         feedTypes.add(new FeedTypes.fromJson(v));
//       });
//     }
//     user = json['user'] != null ? new User.fromJson(json['user']) : null;
//     if (json['media'] != null) {
//       media = new List<Media>();
//       json['media'].forEach((v) {
//         media.add(new Media.fromJson(v));
//       });
//     }
//     isLiked = json['is_liked'];
//     isBookmarked = json['is_bookmarked'];
//     likeCount = json['like_count'];
//     bookmarkCount = json['bookmark_count'];
//     feedCreatedAt = json['feed_created_at'];
//     feedUpdatedAt = json['feed_updated_at'];
//     // isShared = json['is_shared'];
//     shareCount = json['share_count'];
//     commentCount = json['comment_count'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['feed_id'] = this.feedId;
//     data['title'] = this.title;
//     data['description'] = this.description;
//     data['location'] = this.location;
//     data['start'] = this.start;
//     data['end'] = this.end;
//     data['created'] = this.created;
//     if (this.feedTypes != null) {
//       data['feed_types'] = this.feedTypes.map((v) => v.toJson()).toList();
//     }
//     if (this.user != null) {
//       data['user'] = this.user.toJson();
//     }
//     if (this.media != null) {
//       data['media'] = this.media.map((v) => v.toJson()).toList();
//     }
//     data['is_liked'] = this.isLiked;
//     data['is_bookmarked'] = this.isBookmarked;
//     data['like_count'] = this.likeCount;
//     data['bookmark_count'] = this.bookmarkCount;
//     data['feed_created_at'] = this.feedCreatedAt;
//     data['feed_updated_at'] = this.feedUpdatedAt;
//     // data['is_shared'] = this.isShared;
//     data['share_count'] = this.shareCount;
//     data['comment_count'] = this.commentCount;
//     return data;
//   }
// }

class User {
  String id;
  String name;
  String photoUrl;
  String firebaseUid;

  User({this.id, this.name, this.photoUrl, this.firebaseUid});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    photoUrl = json['photo_url'];
    firebaseUid = json['firebase_uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['photo_url'] = this.photoUrl;
    data['firebase_uid'] = this.firebaseUid;
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
  String deletedAt;
  int status;

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
