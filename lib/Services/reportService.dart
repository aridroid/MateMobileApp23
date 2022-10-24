import 'dart:convert';
import 'dart:io';

import 'package:mate_app/Exceptions/Custom_Exception.dart';

import '../Model/appUpdateModel.dart';
import 'APIService.dart';
import 'BackEndAPIRoutes.dart';

class ReportService {
  APIService _apiService;
  BackEndAPIRoutes _backEndAPIRoutes;

  ReportService() {
    _apiService = APIService();
    _backEndAPIRoutes = BackEndAPIRoutes();
  }

  Future reportPost(Map<String, dynamic> body) async {
    try {
      final response = await _apiService.post(uri: _backEndAPIRoutes.reportPost(), data: body);

      return json.decode(response.body);
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } on ValidationFailureException catch (error) {
      throw error;
    } catch (error) {
      print('error occurred fetching from ${_backEndAPIRoutes.reportPost().toString()} :: $error');
      throw Exception('$error');
    }
  }

  Future blockUser(Map<String, dynamic> body) async {
    try {
      final response = await _apiService.post(uri: _backEndAPIRoutes.blockUser(), data: body);

      return json.decode(response.body);
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } on ValidationFailureException catch (error) {
      throw error;
    } catch (error) {
      print('error occurred fetching from ${_backEndAPIRoutes.blockUser().toString()} :: $error');
      throw Exception('$error');
    }
  }

  Future appUpdate() async {
    try {
      final response = await _apiService.get(uri: _backEndAPIRoutes.appUpdate());

      return AppUpdateModel.fromJson(json.decode(response.body));
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } on ValidationFailureException catch (error) {
      throw error;
    } catch (error) {
      print('error occurred fetching from ${_backEndAPIRoutes.appUpdate().toString()} :: $error');
      throw Exception('$error');
    }
  }

}