class PersonalChatDataModel {
  bool success;
  List<Data> data;
  String message;

  PersonalChatDataModel({this.success, this.data, this.message});

  PersonalChatDataModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  String roomId;
  int totalMessages;
  String updatedAt;
  String receiverUid;
  int unreadMessages;

  Data(
      {this.roomId,
        this.totalMessages,
        this.updatedAt,
        this.receiverUid,
        this.unreadMessages});

  Data.fromJson(Map<String, dynamic> json) {
    roomId = json['room_id'];
    totalMessages = json['total_messages'];
    updatedAt = json['updated_at'];
    receiverUid = json['receiver_uid'];
    unreadMessages = json['unread_messages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['room_id'] = this.roomId;
    data['total_messages'] = this.totalMessages;
    data['updated_at'] = this.updatedAt;
    data['receiver_uid'] = this.receiverUid;
    data['unread_messages'] = this.unreadMessages;
    return data;
  }
}
