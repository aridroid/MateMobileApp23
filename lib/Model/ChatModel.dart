class ChatModel {
  String? msg;
  String? user;
  String? date;

  ChatModel({this.msg, this.user, this.date});

  ChatModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    user = json['user'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['user'] = this.user;
    data['date'] = this.date;
    return data;
  }
}
