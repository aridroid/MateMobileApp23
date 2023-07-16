import 'dart:convert';
import 'dart:io';

import '../Services/APIService.dart';
import '../Services/BackEndAPIRoutes.dart';

class FollowerService {
  late APIService _apiService;
  late BackEndAPIRoutes _backEndAPIRoutes;

  FollowerService() {
    _apiService = APIService();
    _backEndAPIRoutes = BackEndAPIRoutes();
  }

  Future fetchFollowings() async {
    try {
      final response =
          await _apiService.get(uri: _backEndAPIRoutes.followings());

      return json.decode(response.body)['data']['followings'];
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } catch (error) {
      print(
          'error occurred fetching from ${_backEndAPIRoutes.followings().toString()} :: $error');
      throw Exception('$error');
    }
  }

  Future fetchFollowers() async {
    try {
      final response =
          await _apiService.get(uri: _backEndAPIRoutes.followers());

      return json.decode(response.body)['data']['followers'];
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } catch (error) {
      print(
          'error occurred fetching from ${_backEndAPIRoutes.followers().toString()} :: $error');
      throw Exception('$error');
    }
  }
}
