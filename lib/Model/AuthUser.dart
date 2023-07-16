class AuthUser {
  String? id;
  String? email;
  String? firstName;
  String? lastName;
  String? displayName;
  String? phoneNumber;
  String? photoUrl;
  String? coverPhotoUrl;
  int? universityId;
  String? university;
  String? about;
  String? societies;
  String? achievements;
  int? totalFollowers;
  int? totalFollowings;
  String? firebaseUid;
  int? totalFeeds;
  int? totalFeedComments;
  bool? isNotify;

  AuthUser(
      {this.id,
        this.email,
        this.firstName,
        this.lastName,
        this.displayName,
        this.phoneNumber,
        this.photoUrl,
        this.coverPhotoUrl,
        this.universityId,
        this.university,
        this.about,
        this.societies,
        this.achievements,
        this.totalFollowers,
        this.totalFollowings,
        this.firebaseUid,
        this.totalFeeds,
        this.totalFeedComments,
        this.isNotify,

      });

  AuthUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    displayName = json['display_name'];
    phoneNumber = json['phone_number'];
    photoUrl = json['photo_url'];
    coverPhotoUrl = json['cover_photo_url'];
    universityId = json['university_id'];
    university = json['university'];
    about = json['about'];
    societies = json['societies'];
    achievements = json['achievements'];
    totalFollowers = json['total_followers'];
    totalFollowings = json['total_followings'];
    firebaseUid = json['firebase_uid'];
    totalFeeds = json['feed_count'];
    totalFeedComments = json['feed_comment_count'];
    isNotify = json['is_notify'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['display_name'] = this.displayName;
    data['phone_number'] = this.phoneNumber;
    data['photo_url'] = this.photoUrl;
    data['cover_photo_url'] = this.coverPhotoUrl;
    data['university_id'] = this.universityId;
    data['university'] = this.university;
    data['about'] = this.about;
    data['societies'] = this.societies;
    data['achievements'] = this.achievements;
    data['total_followers'] = this.totalFollowers;
    data['total_followings'] = this.totalFollowings;
    data['firebase_uid'] = this.firebaseUid;
    data['feed_count'] = this.totalFeeds;
    data['feed_comment_count'] = this.totalFeedComments;
    data['is_notify'] = this.isNotify;
    return data;
  }
}
