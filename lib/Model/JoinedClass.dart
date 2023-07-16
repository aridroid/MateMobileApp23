class JoinedClass {
  String? id;
  String? courseIdentifier;
  String? courseTitle;
  String? semester;
  int? year;
  List<Assignments>? assignments;

  JoinedClass(
      {this.id,
      this.courseIdentifier,
      this.courseTitle,
      this.semester,
      this.year,
      this.assignments});

  JoinedClass.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    courseIdentifier = json['course_identifier'];
    courseTitle = json['course_title'];
    semester = json['semester'];
    year = json['year'];
    if (json['assignments'] != null) {
      assignments = [];
      json['assignments'].forEach((v) {
        assignments?.add(new Assignments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['course_identifier'] = this.courseIdentifier;
    data['course_title'] = this.courseTitle;
    data['semester'] = this.semester;
    data['year'] = this.year;
    if (this.assignments != null) {
      data['assignments'] = this.assignments?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Assignments {
  String? id;
  String? name;
  String? dueDate;

  Assignments({this.id, this.name, this.dueDate});

  Assignments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    dueDate = json['due_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['due_date'] = this.dueDate;
    return data;
  }
}
