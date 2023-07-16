class CampusLiveUploadModel {
  bool? success;
  Data? data;
  String? message;

  CampusLiveUploadModel({this.success, this.data, this.message});

  CampusLiveUploadModel.fromJson(Map<String, dynamic> json) {
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
  int? userId;
  Null audioId;
  String? url;
  String? subject;
  String? createdAt;
  String? updatedAt;
  Null thumbnailUrl;
  String? featured;
  Null viewCount;

  Data(
      {this.id,
        this.userId,
        this.audioId,
        this.url,
        this.subject,
        this.createdAt,
        this.updatedAt,
        this.thumbnailUrl,
        this.featured,
        this.viewCount});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    audioId = json['audio_id'];
    url = json['url'];
    subject = json['subject'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    thumbnailUrl = json['thumbnail_url'];
    featured = json['featured'];
    viewCount = json['view_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['audio_id'] = this.audioId;
    data['url'] = this.url;
    data['subject'] = this.subject;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['thumbnail_url'] = this.thumbnailUrl;
    data['featured'] = this.featured;
    data['view_count'] = this.viewCount;
    return data;
  }
}
