import 'dart:convert';
import 'dart:io';

import 'package:mate_app/Services/APIService.dart';
import 'package:mate_app/Services/BackEndAPIRoutes.dart';

class StudyGroupService {
  late APIService _apiService;
  late BackEndAPIRoutes _backEndAPIRoutes;

  StudyGroupService() {
    _apiService = APIService();
    _backEndAPIRoutes = BackEndAPIRoutes();
  }

  Future fetchStudyGroups([Map<String, dynamic>? queryParams]) async {
    try {
      final response = await _apiService.get(
          uri: _backEndAPIRoutes.studyGroups(queryParams));

      return json.decode(response.body)['data']['study_groups'];
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } catch (error) {
      print(
          'error occurred fetching from ${_backEndAPIRoutes.studyGroups().toString()} :: $error');
      throw Exception('$error');
    }
  }
}
