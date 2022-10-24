import 'dart:convert';
import 'dart:io';

import 'package:mate_app/Services/APIService.dart';
import 'package:mate_app/Services/BackEndAPIRoutes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserClassService {
  APIService _apiService;
  BackEndAPIRoutes _backEndAPIRoutes;

  UserClassService() {
    _apiService = APIService();
    _backEndAPIRoutes = BackEndAPIRoutes();
  }

  Future joinClass({@required Map<String, dynamic> data}) async {
    try {
      final response = await _apiService.post(
          uri: _backEndAPIRoutes.joinClass(), data: data);

      return json.decode(response.body)['data'];
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } catch (error) {
      print(
          'error occurred fetching from ${_backEndAPIRoutes.joinClass().toString()} :: $error');
      throw Exception('$error');
    }
  }

  Future myClasses() async {
    try {
      final response =
          await _apiService.get(uri: _backEndAPIRoutes.myClasses());

      return json.decode(response.body)['data']['classes'];
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } catch (error) {
      print(
          'error occurred fetching from ${_backEndAPIRoutes.myClasses().toString()} :: $error');
      throw Exception('$error');
    }
  }

  void saveMyClassesToSharedPreference(data) async {
    print('updating joined class in sharedPreference ${data.runtimeType}');
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('joinedClasses', json.encode(data));
  }

  Future addAssignment(
      {@required Map<String, dynamic> data, @required String id}) async {
    try {
      final response = await _apiService.post(
          uri: _backEndAPIRoutes.addAssignMents(id: id), data: data);

      return json.decode(
          response.body)['data']; // returns data for the assignment model
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } catch (error) {
      print(
          'error occurred fetching from ${_backEndAPIRoutes.myClasses().toString()} :: $error');
      throw Exception('$error');
    }
  }
}
