class AppUpdateModel {
  bool success;
  Data data;
  String message;

  AppUpdateModel({this.success, this.data, this.message});

  AppUpdateModel.fromJson(Map<String, dynamic> json) {
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
  String androidVersion;
  String iosVersion;
  String generalVersion;

  Data({this.androidVersion, this.iosVersion, this.generalVersion});

  Data.fromJson(Map<String, dynamic> json) {
    androidVersion = json['android_version'];
    iosVersion = json['ios_version'];
    generalVersion = json['general_version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['android_version'] = this.androidVersion;
    data['ios_version'] = this.iosVersion;
    data['general_version'] = this.generalVersion;
    return data;
  }
}
