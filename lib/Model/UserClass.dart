class UserClass {
  int? id;
  String? identifier;
  String? title;

  UserClass({this.id, this.identifier, this.title});

  UserClass.fromJson(Map<String, dynamic> json) {
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
