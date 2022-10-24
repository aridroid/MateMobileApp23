class CommunityTabModel {
  bool success;
  List<Data> data;
  String message;

  CommunityTabModel({this.success, this.data, this.message});

  CommunityTabModel.fromJson(Map<String, dynamic> json) {
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
  String groupId;
  int totalMessages;
  String category;
  String group;


  Data({this.groupId, this.totalMessages,this.category,this.group});

  Data.fromJson(Map<String, dynamic> json) {
    groupId = json['group_id'];
    totalMessages = json['total_messages'];
    category = json['category'];
    group = json['group'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['group_id'] = this.groupId;
    data['total_messages'] = this.totalMessages;
    data['category'] = this.category;
    data['group'] = this.group;
    return data;
  }
}
