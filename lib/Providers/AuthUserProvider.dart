import 'dart:convert';
import 'dart:developer';

import 'package:mate_app/Model/userAboutDataModel.dart' as uadm;
import 'package:mate_app/Services/GoogleSignInService.dart';
import 'package:mate_app/groupChat/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/AuthUser.dart';
import '../Services/AuthUserService.dart';
import '../Exceptions/Custom_Exception.dart';
import '../Model/UserClass.dart';
import '../Services/appleSigninService.dart';

class AuthUserProvider with ChangeNotifier {
  ///initialization
  FirebaseMessaging _firebaseMessaging;
  GoogleSignInService _googleSignInService;
  AppleSignInService _appleSignInService;
  AuthUser _authUser;
  List<UserClass> _authUserClasses = [];
  AuthUserService _authUserService;
  Map<String, dynamic> _validationError = {};
  uadm.UserAboutDataModel _userAboutData;

  String _error = "";

  ///loaders
  bool _profileLoader = false;
  bool _photoUpdateLoader = false;
  bool _coverPhotoUpdateLoader = false;
  bool _aboutUpdateLoader = false;
  bool _societiesUpdateLoader = false;
  bool _achievementUpdateLoader = false;
  bool _loggingInLoader = false;
  bool _userClassListLoader = false;
  bool _autoLoginLoader = false;
  bool _profileUpdateLoader = false;
  bool _userAboutDataLoader = false;
  bool _userAboutDataUploadLoader = false;
  bool _updateNotificationLoader = false;

  ///constructor
  AuthUserProvider() {
    _authUserService = AuthUserService();
    _firebaseMessaging = FirebaseMessaging.instance;
    _googleSignInService = GoogleSignInService();
    _appleSignInService = AppleSignInService();
    // _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.requestPermission();
  }

  ///getters
  get error => _error;

  AuthUser get authUser => _authUser;

  get authUserClasses => _authUserClasses;

  uadm.UserAboutDataModel get userAboutData => _userAboutData;

  get profileUpdateLoaderStatus => _profileUpdateLoader;

  get loggingInLoaderStatus => _loggingInLoader;

  get autoLoginLoader => _autoLoginLoader;

  bool get userAboutDataLoader => _userAboutDataLoader;

  get userAboutDataUploadLoader => _userAboutDataUploadLoader;

  get updateNotificationLoader => _updateNotificationLoader;

  get profileLoaderStatus => _profileLoader;

  get userClassListLoaderStatus => _userClassListLoader;

  get photoUpdateLoaderStatus => _photoUpdateLoader;

  get coverPhotoUpdateLoader => _coverPhotoUpdateLoader;

  get aboutUpdateLoaderStatus => _aboutUpdateLoader;

  get societiesUpdateLoaderStatus => _societiesUpdateLoader;

  get achievementUpdateLoader => _achievementUpdateLoader;

  get authUserPhoto => _authUser.photoUrl.length > 0
      ? _authUser.photoUrl
      : 'https://cdn.pixabay.com/photo/2016/03/31/23/37/bird-1297727__340.png';

  get validationErrors => _validationError;

  set setAuthUserPhoto(String url) {
    _authUser.photoUrl = url;
    notifyListeners();
  }

  set setAuthUserCoverPhoto(String url) {
    _authUser.coverPhotoUrl = url;
    notifyListeners();
  }


  ///setters
  set profileLoaderStatus(bool val) {
    if (_profileLoader != val) {
      _profileLoader = val;
      notifyListeners();
    }
  }

  set profileUpdateLoaderStatus(bool val) {
    if (_profileUpdateLoader != val) {
      _profileUpdateLoader = val;
      notifyListeners();
    }
  }

  set userClassListLoaderStatus(bool val) {
    if (_userClassListLoader != val) {
      _userClassListLoader = val;
      notifyListeners();
    }
  }

  set autoLoginLoaderStatus(bool val) {
    if (_autoLoginLoader != val) {
      _autoLoginLoader = val;
      notifyListeners();
    }
  }

  set photoUpdateLoaderStatus(bool val) {
    if (_photoUpdateLoader != val) {
      _photoUpdateLoader = val;
      notifyListeners();
    }
  }

  set aboutUpdateLoaderStatus(bool val) {
    if (_aboutUpdateLoader != val) {
      _aboutUpdateLoader = val;
      notifyListeners();
    }
  }

  set societiesUpdateLoaderStatus(bool val) {
    if (_societiesUpdateLoader != val) {
      _societiesUpdateLoader = val;
      notifyListeners();
    }
  }

  set achievementsUpdateLoaderStatus(bool val) {
    if (_achievementUpdateLoader != val) {
      _achievementUpdateLoader = val;
      notifyListeners();
    }
  }

  set loggingInLoaderStatus(bool val) {
    if (_loggingInLoader != val) {
      _loggingInLoader = val;
      notifyListeners();
    }
  }

  set error(String val) {
    _error = val;
    notifyListeners();
  }

  set validationErrors(Map<String, dynamic> error) {
    _validationError = error;
    notifyListeners();
  }

  set authUser(AuthUser authUser) {
    _authUser = authUser;
    notifyListeners();
  }

  set updateAuthUserAbout(String val) {
    _authUser.about = val;
    notifyListeners();
  }

  set updateAuthUserSocieties(String val) {
    _authUser.societies = val;
    notifyListeners();
  }

  set updateAuthUserAchievements(String val) {
    _authUser.achievements = val;
    notifyListeners();
  }

  set updateAuthUserPhoto(String val) {
    _authUser.photoUrl = val;
    notifyListeners();
  }

  set authUserClasses(List<UserClass> uc) {
    _authUserClasses = uc;
    notifyListeners();
  }

  void _setError(err) {
    print('error of type (${err.runtimeType}) in provider $err');
    try {
      if (err is ValidationFailureException) {
        validationErrors = err.validationErrors;
      } else {
        error = err.message.toString();
      }
    } catch (e) {
      error = "Something Went Wrong";
    }
  }

  Future<bool> login() async {
    // loggingInLoaderStatus = true;
    // notifyListeners();
    error = '';
    //List<String> result = [];
    //result.add("");
    bool result = false;

    try {
      String deviceId= await _firebaseMessaging.getToken();
      await _authUserService.clearAuthUserDataFromSharedPreference();
      List<dynamic> data = await _googleSignInService.signInWithGoogle();
      loggingInLoaderStatus = true;
      String googleToken= data[0];
      User user= data[1];
      log(user.toString());
      print("deviceId : $deviceId");
      AuthUser userData = await _authUserService.login(googleToken: googleToken, deviceId: deviceId);
      if(userData != null){
        DatabaseService(uid: user.uid).updateUserData(user, userData.id, userData.displayName,userData.photoUrl);
        authUser = userData;
        result = true;
        var _user = FirebaseAuth.instance.currentUser;
        await _user.updateProfile(displayName: authUser.displayName,photoURL: authUser.photoUrl);
        // if(userData.universityId!=null){
        //   DatabaseService(uid: user.uid).updateUserData(user, userData.id, userData.displayName);
        //   authUser = userData;
        //   result.add("success");
        // }else{
        //   var prefs = await SharedPreferences.getInstance();
        //   prefs.remove('googleToken');
        //   prefs.remove('authUser');
        //   result.add("updateProfile");
        //   result.add(user.photoURL);
        //   result.add("");
        //   result.add(user.displayName);
        //   // result[0] = "updateProfile";
        //   // result[1] = user.photoURL;
        //   // result[2] = "";
        //   // result[3] = user.displayName;
        // }
      }

    } on PlatformException catch (err) {
      print('platform exception: ${err.toString()}');
      error = "Sign in failed. Check Your Internet Connection";
    } catch (err) {
      if(err.toString().contains("User is de-activated.")){
        error = "Your account is deleted";
      }else{
        _setError(err);
      }
    } finally {
      loggingInLoaderStatus = false;
    }

    // if (authUser != null) {
    //   error = '';
    //   return true;
    // }
    return result;
  }

  Future<bool> appleLogin() async {
    error = '';
    bool result = false;
    try {
      String deviceId= await _firebaseMessaging.getToken();
      await _authUserService.clearAuthUserDataFromSharedPreference();
      List<dynamic> data = await _appleSignInService.useAppleAuthentication();
      loggingInLoaderStatus = true;
      String googleToken= data[0];
      User user= data[1];
      log(user.toString());
      print("deviceId : $deviceId");
      AuthUser userData = await _authUserService.login(googleToken: googleToken, deviceId: deviceId);
      if(userData != null){
        DatabaseService(uid: user.uid).updateUserData(user, userData.id, userData.displayName,userData.photoUrl);
        authUser = userData;
        result = true;
        var _user = FirebaseAuth.instance.currentUser;
        await _user.updateProfile(displayName: authUser.displayName,photoURL: authUser.photoUrl);
      }
    } on PlatformException catch (err) {
      print('platform exception: ${err.toString()}');
      error = "Sign in failed. Check Your Internet Connection";
    } catch (err) {
      if(err.toString().contains("User is de-activated.")){
        error = "Your account is deleted";
      }else{
        _setError(err);
      }
    } finally {
      loggingInLoaderStatus = false;
    }
    return result;
  }

  /// we will try to check if user google token saved into the shared preference or not
  /// if google token is found then we will check if the authUser is there or not
  /// if authUser is there then we will set it as runtime variable and navigate use to the
  /// timeline screen. if not found we will send him to
  Future<bool> autoLogin() async {
    autoLoginLoaderStatus = true;

    try {
      // String googleToken = await _authUserService.getGoogleTokenFromSharedPreference();
      //
      // print('auto login googleToken retrieved::$googleToken');
      //
      // if (googleToken == null) {
      //   return false;
      // }

      var userDataFromSharedPreference = await _authUserService.getAuthUserFromSharedPreference();

      if (userDataFromSharedPreference == null) return false;

      print('user data from shared preference:: ${userDataFromSharedPreference.toString()}');

      AuthUser userData = AuthUser.fromJson(jsonDecode(userDataFromSharedPreference));

      authUser = userData;

      return true;
    } catch (err) {
      _setError(err);
      return false;
    }
  }

  Future<void> logout() async {
    await _googleSignInService.signOutGoogle();
    await _appleSignInService.signOutApple();
    await _authUserService.clearAuthUserDataFromSharedPreference();
  }

  Future<void> getUserProfileData({bool saveToSharedPref=false}) async {
    profileLoaderStatus = true;
    error = '';

    try {
      var userData = await _authUserService.fetchUserProfile();
      authUser = AuthUser.fromJson(userData);

      if (saveToSharedPref) {
        await _authUserService.storeAuthUserToSharedPreference(authUser);
        await DatabaseService().updateOldUserLoginWithEmail(authUser);
        var _user = FirebaseAuth.instance.currentUser;
        await _user.updateProfile(displayName: authUser.displayName,photoURL: authUser.photoUrl);
      }

      print(_authUser.firstName.toString());
    } catch (err) {
      _setError(err);
    } finally {
      profileLoaderStatus = false;
    }
  }

  Future<bool> updateUserProfile({
    @required String firstName,
    @required String lastName,
    @required String displayName,
    @required String phoneNumber,
    String about,
    String achievements,
    String societies,
  }) async {
    error = "";
    validationErrors = {};
    profileUpdateLoaderStatus = true;

    try {
      print(
          'in provider $firstName $lastName $phoneNumber $displayName $about $achievements $societies');

      Map<String, dynamic> formData = {
        "first_name": firstName,
        "last_name": lastName,
        "phone_number": phoneNumber,
        "display_name": displayName,
        "about": about,
        "achievements": achievements,
        "societies": societies
      };

      await _authUserService.updateProfile(formData);

      await getUserProfileData(saveToSharedPref: true);
    } catch (err) {
      _setError(err);
      return false;
    } finally {
      profileUpdateLoaderStatus = false;
    }

    return true;
  }

  Future<void> getUserClasses() async {
    error = "";
    userClassListLoaderStatus = true;

    try {
      var data = await _authUserService.fetchUserClasses();

      List<UserClass> rawList = [];
      for (int i = 0; i < data.length; i++) {
        rawList.add(UserClass.fromJson(data[i]));
      }

      authUserClasses = rawList;
    } catch (err) {
      _setError(err);
    } finally {
      userClassListLoaderStatus = false;
    }
  }

  Future<void> updateAbout({@required String about}) async {
    error = '';
    aboutUpdateLoaderStatus = true;
    try {
      await _authUserService.updateAbout({"about": about});

      updateAuthUserAbout = about;
    } catch (err) {
      _setError(err);
    } finally {
      aboutUpdateLoaderStatus = false;
    }
  }

  Future<void> updateSocieties({@required String societies}) async {
    error = '';
    societiesUpdateLoaderStatus = true;
    try {
      await _authUserService.updateSocieties({"societies": societies});

      updateAuthUserSocieties = societies;
    } catch (err) {
      _setError(err);
    } finally {
      societiesUpdateLoaderStatus = false;
    }
  }

  Future<void> updateAchievements({@required String achievements}) async {
    error = '';
    achievementsUpdateLoaderStatus = true;
    try {
      await _authUserService.updateAchievements({"achievements": achievements});

      updateAuthUserAchievements = achievements;
    } catch (err) {
      _setError(err);
    } finally {
      achievementsUpdateLoaderStatus = false;
    }
  }

  Future<void> updatePhoto({@required String imageFile}) async {
    error = '';
    photoUpdateLoaderStatus = true;
    try {
      var photoUrl = await _authUserService.updatePhoto(imageFile);
      print('authPhotoUrl: ${photoUrl.toString()}');

      setAuthUserPhoto = photoUrl;

      // ignore: todo
      //TODO::update inside the sharedPreference

    } catch (err) {
      _setError(err);
    } finally {
      photoUpdateLoaderStatus = false;
    }
  }

  Future<void> updateCoverPhoto({@required String imageFile}) async {
    error = '';
    _coverPhotoUpdateLoader = true;
    try {
      var photoUrl = await _authUserService.updateCoverPhoto(imageFile);
      print('authCoverPhotoUrl: ${photoUrl.toString()}');

      setAuthUserCoverPhoto = photoUrl;

      // ignore: todo
      //TODO::update inside the sharedPreference

    } catch (err) {
      _setError(err);
    } finally {
      _coverPhotoUpdateLoader = false;
    }
  }

  Future<void> getUserInfo(String userId) async {
    error = '';
    _userAboutDataLoader = true;

    try {
      var data = await _authUserService.getUserInfo(userId);
      // print(data);
      _userAboutData = data;


    } catch (err) {
      _setError(err);
    } finally {
      _userAboutDataLoader = false;
      notifyListeners();
    }
  }

  Future<bool> updateUserInfo(Map<String, dynamic> body) async {
    error = '';
    _userAboutDataUploadLoader = true;
    var data;
    try {
      data = await _authUserService.updateUserInfo(body);
    } catch (err) {
      _setError(err);
      return false;
    } finally {
      _userAboutDataUploadLoader = false;
    }
    notifyListeners();
    return true;
  }

  Future<bool> updateNotification() async {
    error = '';
    _updateNotificationLoader = true;
    var data;
    try {
      data = await _authUserService.updateNotification();
    } catch (err) {
      _setError(err);
      return false;
    } finally {
      _updateNotificationLoader = false;
    }
    notifyListeners();
    return true;
  }



}
