class FindAMatePostActiveModel {
  bool success;
  Data data;
  String message;

  FindAMatePostActiveModel({this.success, this.data, this.message});

  FindAMatePostActiveModel.fromJson(Map<String, dynamic> json) {
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
  int id;
  int userId;
  String title;
  String description;
  String fromDate;
  String toDate;
  String timeFrom;
  String timeTo;
  String status;
  String createdAt;
  String updatedAt;

  Data(
      {this.id,
        this.userId,
        this.title,
        this.description,
        this.fromDate,
        this.toDate,
        this.timeFrom,
        this.timeTo,
        this.status,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    title = json['title'];
    description = json['description'];
    fromDate = json['from_date'];
    toDate = json['to_date'];
    timeFrom = json['time_from'];
    timeTo = json['time_to'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['from_date'] = this.fromDate;
    data['to_date'] = this.toDate;
    data['time_from'] = this.timeFrom;
    data['time_to'] = this.timeTo;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
