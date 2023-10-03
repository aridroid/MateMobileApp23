class CourseListingModel {
  List<String>? response;

  CourseListingModel({this.response});

  CourseListingModel.fromJson(Map<String, dynamic> json) {
    response = json['response'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response'] = this.response;
    return data;
  }
}
