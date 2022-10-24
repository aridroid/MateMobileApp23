class UserAboutDataModel {
  bool success;
  String message;
  Data data;

  UserAboutDataModel({this.success, this.message, this.data});

  UserAboutDataModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  int userId;
  User user;
  String about;
  List<String> classes;
  List<String> iCanHelpWith;
  List<String> iNeedHelpWith;
  List<String> interests;
  List<String> skills;
  String createdAt;
  String updatedAt;

  Data(
      {this.userId,
        this.user,
        this.about,
        this.classes,
        this.iCanHelpWith,
        this.iNeedHelpWith,
        this.interests,
        this.skills,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    about = json['about'];
    classes = json['classes'] != null ? json['classes'].cast<String>() : null;
    iCanHelpWith = json['i_can_help_with'] != null ? json['i_can_help_with'].cast<String>() : null;
    iNeedHelpWith = json['i_need_help_with'] != null ? json['i_need_help_with'].cast<String>() : null;
    interests = json['interests'] != null ? json['interests'].cast<String>() : null;
    skills = json['skills'] != null ? json['skills'].cast<String>() : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    data['about'] = this.about;
    data['classes'] = this.classes;
    data['i_can_help_with'] = this.iCanHelpWith;
    data['i_need_help_with'] = this.iNeedHelpWith;
    data['interests'] = this.interests;
    data['skills'] = this.skills;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class User {
  String uuid;
  String email;
  String phoneNumber;
  String firstName;
  String lastName;
  String displayName;
  String photo;
  String about;
  String societies;
  String achievements;
  String firebaseUid;
  String emailVerifiedAt;
  String createdAt;
  String updatedAt;

  User(
      {this.uuid,
        this.email,
        this.phoneNumber,
        this.firstName,
        this.lastName,
        this.displayName,
        this.photo,
        this.about,
        this.societies,
        this.achievements,
        this.firebaseUid,
        this.emailVerifiedAt,
        this.createdAt,
        this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    displayName = json['display_name'];
    photo = json['photo'];
    about = json['about'];
    societies = json['societies'];
    achievements = json['achievements'];
    firebaseUid = json['firebase_uid'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    data['email'] = this.email;
    data['phone_number'] = this.phoneNumber;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['display_name'] = this.displayName;
    data['photo'] = this.photo;
    data['about'] = this.about;
    data['societies'] = this.societies;
    data['achievements'] = this.achievements;
    data['firebase_uid'] = this.firebaseUid;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
