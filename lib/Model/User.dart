class User {
  String? id;
  String? email;
  String? firstName;
  String? lastName;
  String? displayName;
  int? universityId;
  String? university;
  String? phoneNumber;
  String? photoUrl;
  String? coverPhotoUrl;
  String? about;
  String? societies;
  String? achievements;
  int? totalFollowers;
  int? totalFollowings;
  bool? isFollowing;
  String? firebaseUid;
  int? totalFeeds;
  int? totalFeedComments;

  User(
      {this.id,
      this.email,
      this.firstName,
      this.lastName,
      this.displayName,
        this.universityId,
        this.university,
      this.phoneNumber,
      this.photoUrl,
      this.coverPhotoUrl,
      this.about,
      this.societies,
      this.achievements,
      this.totalFollowers,
      this.totalFollowings,
      this.isFollowing,
      this.firebaseUid,
        this.totalFeeds,
        this.totalFeedComments,});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    displayName = json['display_name'];
    universityId = json['university_id'];
    university = json['university'];
    phoneNumber = json['phone_number'];
    photoUrl = json['photo_url'];
    coverPhotoUrl = json['cover_photo_url'];
    about = json['about'];
    societies = json['societies'];
    achievements = json['achievements'];
    totalFollowers = json['total_followers'];
    totalFollowings = json['total_followings'];
    isFollowing = json['is_following'];
    firebaseUid = json['firebase_uid'];
    totalFeeds = json['feed_count'];
    totalFeedComments = json['feed_comment_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['display_name'] = this.displayName;
    data['university_id'] = this.universityId;
    data['university'] = this.university;
    data['phone_number'] = this.phoneNumber;
    data['photo_url'] = this.photoUrl;
    data['cover_photo_url'] = this.coverPhotoUrl;
    data['about'] = this.about;
    data['societies'] = this.societies;
    data['achievements'] = this.achievements;
    data['total_followers'] = this.totalFollowers;
    data['total_followings'] = this.totalFollowings;
    data['is_following'] = this.isFollowing;
    data['firebase_uid'] = this.firebaseUid;
    data['feed_count'] = this.totalFeeds;
    data['feed_comment_count'] = this.totalFeedComments;
    return data;
  }
}
