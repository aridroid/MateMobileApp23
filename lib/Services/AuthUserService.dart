import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:mate_app/Model/userAboutDataModel.dart';
import 'package:mate_app/Providers/AuthUserProvider.dart';
import 'package:mate_app/groupChat/helper/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/universityListingModel.dart';
import '../Services/APIService.dart';
import '../Services/BackEndAPIRoutes.dart';
import '../Exceptions/Custom_Exception.dart';
import '../Model/AuthUser.dart';
import 'package:http/http.dart' as http;

import '../controller/signup_controller.dart';
import '../groupChat/services/database_service.dart';

class AuthUserService {
  late APIService _apiService;
  late BackEndAPIRoutes _backEndAPIRoutes;
  late GetStorage _storage;

  AuthUserService() {
    _apiService = APIService();
    _backEndAPIRoutes = BackEndAPIRoutes();
    _storage = GetStorage();
  }

  Future fetchUserProfile() async {
    try {
      final response =
      await _apiService.get(uri: _backEndAPIRoutes.showProfile());

      return json.decode(response.body)['data']['user'];
    } on SocketException catch (_) {
      throw Exception('No Internet. Could not connect to mate app network');
    } catch (error) {
      print(
          'error occurred fetching from ${_backEndAPIRoutes.showProfile()
              .toString()} :: $error');
      throw Exception('$error');
    }
  }

  Future updateProfile(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.post(
          uri: _backEndAPIRoutes.updateProfile(), data: data);

      return json.decode(response.body)['message'];
    } on SocketException catch (_) {
      throw Exception('No Internet. Could not connect to mate app network');
    } on ValidationFailureException catch (error) {
      throw error;
    } catch (error) {
      print(
          'error occurred posting to ${_backEndAPIRoutes.updateProfile()
              .toString()} :: $error');
      throw Exception('$error');
    }
  }

  Future updateAbout(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.post(
          uri: _backEndAPIRoutes.updateAbout(), data: data);

      return json.decode(response.body)['message'];
    } on SocketException catch (_) {
      throw Exception('No Internet. Could not connect to mate app network');
    } catch (error) {
      print(
          'error occurred posting to ${_backEndAPIRoutes.updateAbout()
              .toString()} :: $error');
      throw Exception('$error');
    }
  }

  Future updateSocieties(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.post(
          uri: _backEndAPIRoutes.updateSocieties(), data: data);

      return json.decode(response.body)['message'];
    } on SocketException catch (_) {
      throw Exception('No Internet. Could not connect to mate app network');
    } catch (error) {
      print(
          'error occurred posting to ${_backEndAPIRoutes.updateSocieties()
              .toString()} :: $error');
      throw Exception('$error');
    }
  }

  Future updateAchievements(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.post(
          uri: _backEndAPIRoutes.updateAchievements(), data: {});

      return json.decode(response.body)['message'];
    } on SocketException catch (_) {
      throw Exception('No Internet. Could not connect to mate app network');
    } on ValidationFailureException catch (error) {
      throw error;
    } catch (error) {
      print(
          'error occurred posting to ${_backEndAPIRoutes.updateAchievements()
              .toString()} :: $error');
      throw Exception('$error');
    }
  }

  Future fetchUserClasses() async {
    try {
      final response =
      await _apiService.get(uri: _backEndAPIRoutes.myClasses());

      return json.decode(response.body)['data']['classes'];
    } on SocketException catch (_) {
      throw Exception('No Internet. Could not connect to mate app network');
    } on ValidationFailureException catch (error) {
      throw error;
    } catch (error) {
      print(
          'error occurred posting to ${_backEndAPIRoutes.updateAchievements()
              .toString()} :: $error');
      throw Exception('$error');
    }
  }

  Future updatePhoto(String imageFile) async {
    try {
      final response = await _apiService.post(
          uri: _backEndAPIRoutes.updatePhoto(), data: {"photo": imageFile});

      return json.decode(response.body)['data']['photo_url'];
    } on SocketException catch (_) {
      throw Exception('No Internet. Could not connect to mate app network');
    } on ValidationFailureException catch (error) {
      throw error;
    } catch (error) {
      print(
          'error occurred posting to ${_backEndAPIRoutes.updatePhoto()
              .toString()} :: $error');
      throw Exception('$error');
    }
  }

  Future updateCoverPhoto(String imageFile) async {
    try {
      final response = await _apiService.post(
          uri: _backEndAPIRoutes.updateCoverPhoto(), data: {"cover_photo": imageFile});

      return json.decode(response.body)['data']['cover_photo_url'];
    } on SocketException catch (_) {
      throw Exception('No Internet. Could not connect to mate app network');
    } on ValidationFailureException catch (error) {
      throw error;
    } catch (error) {
      print(
          'error occurred posting to ${_backEndAPIRoutes.updateCoverPhoto()
              .toString()} :: $error');
      throw Exception('$error');
    }
  }

  // ignore: todo
  //TODO::work with expire timeouts
  Future login({required String googleToken, required String deviceId}) async {
    try {
      log({"access_token": googleToken, "device_id":deviceId}.toString());
      final response = await _apiService.post(
          uri: _backEndAPIRoutes.loginUri(),
          data: {"access_token": googleToken, "device_id":deviceId});

      var extractedData = json.decode(response.body);
      log(extractedData.toString());

      var authUser = AuthUser.fromJson(extractedData['data']['user']);

      SignupController signupController = Get.put(SignupController());
      signupController.token = extractedData["data"]["access_token"];
      print(signupController.token);

      //DatabaseService(uid: user.uid).updateUserData(user, authUser.id, authUser.displayName);

      var sp = await SharedPreferences.getInstance();
      sp.setString('googleToken', googleToken);
      sp.setString('tokenApp', extractedData['data']['access_token']); //backend token
      sp.setString('authUserId', extractedData['data']['user']['id']);
      sp.setString('authUser', json.encode(authUser.toJson()));

      await HelperFunctions.saveUserNameSharedPreference(
          extractedData['data']['user']['display_name']
      );

      _storage.write("self_user", json.encode(authUser.toJson()));
      return authUser;
    } on SocketException catch (_) {
      throw Exception('No Internet. Could not connect to mate app network');
    } on ValidationFailureException catch (error) {
      throw error;
    } catch (error) {
      print(
          'error occurred posting to ${_backEndAPIRoutes.loginUri()
              .toString()} :: $error');
      throw Exception('$error');
    }
  }

  Future<String> getGoogleTokenFromSharedPreference() async {
    var sp = await SharedPreferences.getInstance();
    return sp.getString('googleToken')!;
  }

  Future getAuthUserFromSharedPreference() async {
    var sp = await SharedPreferences.getInstance();
    return sp.getString('authUser');
  }

  Future clearAuthUserDataFromSharedPreference() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.remove('googleToken');
    prefs.remove('token'); //backend token
    prefs.remove('authUser');
  }

  Future<void> storeAuthUserToSharedPreference(AuthUser authUser) async {
    print('updating authUser in sharedPreference');
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('authUser', json.encode(authUser.toJson()));

    _storage.write("self_user", json.encode(authUser.toJson()));
  }

  Future<UserAboutDataModel> getUserInfo(String userId) async {
    Uri uri = _backEndAPIRoutes.getUserInfo(userId);

    try {
      final response = await _apiService.get(uri: uri);

      print(response.body);

      return UserAboutDataModel.fromJson(json.decode(response.body));
      // return json.decode(response.body);
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } catch (error) {
      print('error occurred fetching from ${uri.toString()} :: $error');
      throw Exception('$error');
    }
  }

  Future<dynamic> updateUserInfo(Map<String, dynamic> body) async {
    Uri uri = _backEndAPIRoutes.updateUserInfo();
    print(body);

    try {
      final response = await _apiService.post(uri: uri, data: body);

      print(response.body);
      return json.decode(response.body);
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } catch (error) {
      print('error occurred fetching from ${uri.toString()} :: $error');
      throw Exception('$error');
    }
  }

  Future<dynamic> updateNotification() async {
    Uri uri = _backEndAPIRoutes.updateNotification();

    try {
      final response = await _apiService.post(uri: uri);

      print(response.body);
      return json.decode(response.body);
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } catch (error) {
      print('error occurred fetching from ${uri.toString()} :: $error');
      throw Exception('$error');
    }
  }


  Future<String> signupWithEmail({required String email,required String password,required String category})async{
    SignupController signupController = Get.find<SignupController>();
    String result = "";
    Map data = {
      "email": email,
      "password": password,
      "category": category
    };
    debugPrint("https://api.mateapp.us/api/signupwithemail");
    debugPrint(json.encode(data));
    try {
      final response = await http.post(Uri.parse("https://api.mateapp.us/api/signupwithemail"), body: data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
        result = parsed["message"];
        signupController.token = parsed["data"]["access_token"];
        print("---------------------Token---------------------------");
        print(signupController.token);
      }else if(response.statusCode==400){
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
        if(parsed["data"]["email"]!=null){
          result = parsed["data"]["email"][0];
        }
      }
    } catch (e) {
      log(e.toString());
    }
    return result;
  }




  Future<dynamic> signInWithEmail({required String email,required String password,required String deviceId})async{
    dynamic result = "result";
    Map data = {
      "email": email,
      "password": password,
      "device_id": deviceId
    };
    debugPrint("https://api.mateapp.us/api/login");
    debugPrint(json.encode(data));
    try {
      final response = await http.post(Uri.parse("https://api.mateapp.us/api/login"), body: data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        var extractedData = json.decode(response.body);
        print(extractedData);

        SignupController signupController = Get.put(SignupController());
        signupController.token = extractedData["data"]["access_token"];
        print(signupController.token);

        var authUser = AuthUser.fromJson(extractedData['data']['user']);

        final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email,
            password: password
        );

        print("////////////////////////////////////////////////////////");
        print(credential);


        var _user = await FirebaseAuth.instance.currentUser;
        await _user!.updateProfile(displayName: authUser.displayName,photoURL: authUser.photoUrl);

        // var authUser = AuthUser.fromJson(extractedData['data']['user']);
        await DatabaseService().updateUserDataLoginWithEmail(authUser);

        var sp = await SharedPreferences.getInstance();
        //sp.setString('googleToken', googleToken);
        sp.setString('tokenApp', extractedData['data']['access_token']); //backend token
        sp.setString('authUserId', extractedData['data']['user']['id']);
        sp.setString('authUser', json.encode(authUser.toJson()));

        await HelperFunctions.saveUserNameSharedPreference(
            extractedData['data']['user']['display_name']
        );

        _storage.write("self_user", json.encode(authUser.toJson()));
        result = authUser;

      }else if(response.statusCode==400){
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
        result = parsed["message"];
      }
    } catch (e) {
      log(e.toString());
    }
    return result;
  }



  Future<String> createProfile({required String firstName,required String lastName,required String displayName,required String universityId})async{
    SignupController signupController = Get.find<SignupController>();
    String result = "";
    Map data = {
      "first_name": firstName,
      "last_name": lastName,
      "display_name": displayName,
      "university_id": universityId
    };
    log(signupController.token);
    debugPrint("https://api.mateapp.us/api/me");
    debugPrint(json.encode(data));
    try {
      final response = await http.post(
        Uri.parse("https://api.mateapp.us/api/me"),
        body: data,
        headers: {"Authorization": "Bearer ${signupController.token}"},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
        result = parsed["message"];
      }else if(response.statusCode==422){
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
      }
    } catch (e) {
      log(e.toString());
    }
    return result;
  }


  Future<String> updateUserProfile({required String firstName,required String lastName,required String displayName,required String universityId,required String token})async{
    String result = "";
    Map data = {
      "first_name": firstName,
      "last_name": lastName,
      "display_name": displayName,
      "university_id": universityId
    };
    debugPrint("https://api.mateapp.us/api/me");
    debugPrint(json.encode(data));
    try {
      final response = await http.post(
        Uri.parse("https://api.mateapp.us/api/me"),
        body: data,
        headers: {"Authorization": "Bearer $token"},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
        result = parsed["message"];
      }else if(response.statusCode==422){
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
      }
    } catch (e) {
      log(e.toString());
    }
    return result;
  }


  void updatePhotoWhileSignup({required String imageFile})async{
    SignupController signupController = Get.find<SignupController>();
    Map data = {"photo": imageFile};
    debugPrint("https://api.mateapp.us/api/me/photo");
    try {
      final response = await http.post(
        Uri.parse("https://api.mateapp.us/api/me/photo"),
        body: json.encode(data),
        headers: {"Authorization": "Bearer ${signupController.token}",
          'accept': 'application/json',
          'content-type': 'application/json'
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
      }else if(response.statusCode==400){
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
      }
    } catch (e) {
      log(e.toString());
    }
  }

  void updateCoverPhotoWhileSignup({required String imageFile})async{
    SignupController signupController = Get.find<SignupController>();
    Map data = {"cover_photo": imageFile};
    debugPrint("https://api.mateapp.us/api/me/coverphoto");
    try {
      final response = await http.post(
        Uri.parse("https://api.mateapp.us/api/me/coverphoto"),
        body: json.encode(data),
        headers: {"Authorization": "Bearer ${signupController.token}",
          'accept': 'application/json',
          'content-type': 'application/json'
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
      }else if(response.statusCode==400){
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<List<Datum>> getUniversityList({required String token})async{
    List<Datum> universityList = [];
    debugPrint("https://api.mateapp.us/api/university/list");
    try {
      final response = await http.get(
        Uri.parse("https://api.mateapp.us/api/university/list"),
        headers: {
          "Authorization": "Bearer $token",
          'accept': 'application/json',
          'content-type': 'application/json'
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
        UniversityListingModel universityListingModel = UniversityListingModel.fromJson(parsed);
        universityList.addAll(universityListingModel.data!);
      }else if(response.statusCode==400){
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
      }
    } catch (e) {
      log(e.toString());
    }
    return universityList;
  }



  Future<bool> deleteUser({required String token,required String uuid})async{
    bool result = false;
    debugPrint("https://api.mateapp.us/api/users/$uuid/disable");
    try {
      final response = await http.post(
        Uri.parse("https://api.mateapp.us/api/users/$uuid/disable"),
        headers: {
          "Authorization": "Bearer $token",
          'accept': 'application/json',
          'content-type': 'application/json'
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
        result = true;
      }else if(response.statusCode==400){
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
      }else{
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
      }
    } catch (e) {
      log(e.toString());
    }
    return result;
  }

}