// class studyGroupModel {
//   bool success;
//   String message;
//   Data data;
//
//   studyGroupModel({this.success, this.message, this.data});
//
//   studyGroupModel.fromJson(Map<String, dynamic> json) {
//     success = json['success'];
//     message = json['message'];
//     data = json['data'] != null ? new Data.fromJson(json['data']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['success'] = this.success;
//     data['message'] = this.message;
//     if (this.data != null) {
//       data['data'] = this.data.toJson();
//     }
//     return data;
//   }
// }
//
// class Data {
//   List<StudyGroups> studyGroups;
//   Links links;
//   Meta meta;
//
//   Data({this.studyGroups, this.links, this.meta});
//
//   Data.fromJson(Map<String, dynamic> json) {
//     if (json['study_groups'] != null) {
//       studyGroups = new List<StudyGroups>();
//       json['study_groups'].forEach((v) {
//         studyGroups.add(new StudyGroups.fromJson(v));
//       });
//     }
//     links = json['links'] != null ? new Links.fromJson(json['links']) : null;
//     meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.studyGroups != null) {
//       data['study_groups'] = this.studyGroups.map((v) => v.toJson()).toList();
//     }
//     if (this.links != null) {
//       data['links'] = this.links.toJson();
//     }
//     if (this.meta != null) {
//       data['meta'] = this.meta.toJson();
//     }
//     return data;
//   }
// }
//
// class StudyGroups {
//   String id;
//   String name;
//   List<Members> members;
//
//   StudyGroups({this.id, this.name, this.members});
//
//   StudyGroups.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     if (json['members'] != null) {
//       members = new List<Members>();
//       json['members'].forEach((v) {
//         members.add(new Members.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['name'] = this.name;
//     if (this.members != null) {
//       data['members'] = this.members.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Members {
//   String id;
//   String name;
//   String photoUrl;
//
//   Members({this.id, this.name, this.photoUrl});
//
//   Members.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     photoUrl = json['photo_url'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['name'] = this.name;
//     data['photo_url'] = this.photoUrl;
//     return data;
//   }
// }
//
// class Links {
//   String first;
//   String last;
//   Null prev;
//   Null next;
//
//   Links({this.first, this.last, this.prev, this.next});
//
//   Links.fromJson(Map<String, dynamic> json) {
//     first = json['first'];
//     last = json['last'];
//     prev = json['prev'];
//     next = json['next'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['first'] = this.first;
//     data['last'] = this.last;
//     data['prev'] = this.prev;
//     data['next'] = this.next;
//     return data;
//   }
// }
//
// class Meta {
//   int currentPage;
//   int from;
//   int lastPage;
//   List<Links2> links;
//   String path;
//   int perPage;
//   int to;
//   int total;
//
//   Meta(
//       {this.currentPage,
//       this.from,
//       this.lastPage,
//       this.links,
//       this.path,
//       this.perPage,
//       this.to,
//       this.total});
//
//   Meta.fromJson(Map<String, dynamic> json) {
//     currentPage = json['current_page'];
//     from = json['from'];
//     lastPage = json['last_page'];
//     if (json['links'] != null) {
//       links = new List<Links2>();
//       json['links'].forEach((v) {
//         links.add(new Links2.fromJson(v));
//       });
//     }
//     path = json['path'];
//     perPage = json['per_page'];
//     to = json['to'];
//     total = json['total'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['current_page'] = this.currentPage;
//     data['from'] = this.from;
//     data['last_page'] = this.lastPage;
//     if (this.links != null) {
//       data['links'] = this.links.map((v) => v.toJson()).toList();
//     }
//     data['path'] = this.path;
//     data['per_page'] = this.perPage;
//     data['to'] = this.to;
//     data['total'] = this.total;
//     return data;
//   }
// }
//
// class Links2 {
//   String url;
//   String label;
//   bool active;
//
//   Links2({this.url, this.label, this.active});
//
//   Links2.fromJson(Map<String, dynamic> json) {
//     url = json['url'];
//     label = json['label'];
//     active = json['active'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['url'] = this.url;
//     data['label'] = this.label;
//     data['active'] = this.active;
//     return data;
//   }
// }
