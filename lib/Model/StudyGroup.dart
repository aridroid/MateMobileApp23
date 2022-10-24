class StudyGroup {
  String id;
  String name;
  List<Members> members;

  StudyGroup({this.id, this.name, this.members});

  StudyGroup.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['members'] != null) {
      members = new List<Members>();
      json['members'].forEach((v) {
        members.add(new Members.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.members != null) {
      data['members'] = this.members.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Members {
  String id;
  String name;
  String photoUrl;

  Members({this.id, this.name, this.photoUrl});

  Members.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    photoUrl = json['photo_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['photo_url'] = this.photoUrl;
    return data;
  }
}
