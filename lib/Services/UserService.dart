import 'dart:convert';
import 'dart:io';

import 'package:mate_app/Services/APIService.dart';
import 'package:mate_app/Services/BackEndAPIRoutes.dart';

class UserService {
  APIService _apiService;
  BackEndAPIRoutes _backEndAPIRoutes;

  UserService() {
    _apiService = APIService();
    _backEndAPIRoutes = BackEndAPIRoutes();
  }

  Future searchUser(Map<String, dynamic> queryParams) async {
    Uri uri = _backEndAPIRoutes.userSearch(queryParams);

    try {
      final response = await _apiService.get(uri: uri);

      return json.decode(response.body)['data']['users'];
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } catch (error) {
      print(
          'error occurred fetching from ${_backEndAPIRoutes.userSearch(queryParams).toString()} :: $error');
      throw Exception('$error');
    }
  }

  Future findUserById(String id) async {
    Uri uri = _backEndAPIRoutes.findUserById(id: id);

    try {
      final response = await _apiService.get(uri: uri);

      return json.decode(response.body)['data'];
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } catch (error) {
      print('error occurred fetching from ${uri.toString()} :: $error');
      throw Exception('$error');
    }
  }

  Future followUser(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.post(
          uri: _backEndAPIRoutes.followUser(), data: data);

      return json.decode(response.body)['data']['user'];
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } catch (error) {
      print(
          'error occurred fetching from ${_backEndAPIRoutes.followUser().toString()} :: $error');
      throw Exception('$error');
    }
  }

  Future unFollowUser(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.post(
          uri: _backEndAPIRoutes.unFollowUser(), data: data);

      return json.decode(response.body)['data']['user'];
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } catch (error) {
      print(
          'error occurred fetching from ${_backEndAPIRoutes.unFollowUser().toString()} :: $error');
      throw Exception('$error');
    }
  }
}
