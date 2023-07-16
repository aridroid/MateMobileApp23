class Course {
  int? id;
  String? identifier;
  String? title;

  Course({this.id, this.identifier, this.title});

  Course.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    identifier = json['identifier'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['identifier'] = this.identifier;
    data['title'] = this.title;
    return data;
  }
}
