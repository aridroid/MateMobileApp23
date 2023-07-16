class GroupChatDataModel {
  bool? success;
  List<Data>? data;
  String? message;

  GroupChatDataModel({this.success, this.data, this.message});

  GroupChatDataModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data?.add(new Data.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data?.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  String? groupId;
  int? totalMessages;
  String? updatedAt;
  int? unreadMessages;
  bool? isMuted;
  int? isPinned;

  Data({this.groupId, this.totalMessages, this.updatedAt, this.unreadMessages,this.isMuted,this.isPinned});

  Data.fromJson(Map<String, dynamic> json) {
    groupId = json['group_id'];
    totalMessages = json['total_messages'];
    updatedAt = json['updated_at'];
    unreadMessages = json['unread_messages'];
    isMuted = json['is_muted'];
    isPinned = json['is_pinned'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['group_id'] = this.groupId;
    data['total_messages'] = this.totalMessages;
    data['updated_at'] = this.updatedAt;
    data['unread_messages'] = this.unreadMessages;
    data['is_muted'] = this.isMuted;
    data['is_pinned'] = this.isPinned;
    return data;
  }
}
