import 'dart:convert';
import 'dart:io';

import 'package:mate_app/Exceptions/Custom_Exception.dart';

import 'APIService.dart';
import 'BackEndAPIRoutes.dart';

class ExternalShareService {
  APIService _apiService;
  BackEndAPIRoutes _backEndAPIRoutes;

  ExternalShareService() {
    _apiService = APIService();
    _backEndAPIRoutes = BackEndAPIRoutes();
  }

  Future externalSharePost(Map<String, dynamic> body) async {
    try {
      final response = await _apiService.post(uri: _backEndAPIRoutes.externalSharePost(), data: body);

      return json.decode(response.body);
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } on ValidationFailureException catch (error) {
      throw error;
    } catch (error) {
      print('error occurred fetching from ${_backEndAPIRoutes.externalSharePost().toString()} :: $error');
      throw Exception('$error');
    }
  }
}
