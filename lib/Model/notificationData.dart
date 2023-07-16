class NotificationData {
  int? id;
  Sender? sender;
  String? title;
  Null description;
  String? postType;
  int? postId;
  Null commentId;
  bool? isRead;
  String? created;
  String? updatedAt;

  NotificationData(
      {this.id,
        this.sender,
        this.title,
        this.description,
        this.postType,
        this.postId,
        this.commentId,
        this.isRead,
        this.created,
        this.updatedAt});

  NotificationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sender =
    json['sender'] != null ? new Sender.fromJson(json['sender']) : null;
    title = json['title'];
    description = json['description'];
    postType = json['post_type'];
    postId = json['post_id'];
    commentId = json['comment_id'];
    isRead = json['is_read'];
    created = json['created'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.sender != null) {
      data['sender'] = this.sender?.toJson();
    }
    data['title'] = this.title;
    data['description'] = this.description;
    data['post_type'] = this.postType;
    data['post_id'] = this.postId;
    data['comment_id'] = this.commentId;
    data['is_read'] = this.isRead;
    data['created'] = this.created;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Sender {
  String? id;
  String? name;
  String? photoUrl;
  String? firebaseUid;
  String? university;

  Sender(
      {this.id, this.name, this.photoUrl, this.firebaseUid, this.university});

  Sender.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    photoUrl = json['photo_url'];
    firebaseUid = json['firebase_uid'];
    university = json['university'];
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
