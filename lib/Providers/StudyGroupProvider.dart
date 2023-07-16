import 'package:mate_app/Exceptions/Custom_Exception.dart';
import 'package:mate_app/Model/StudyGroup.dart';
import 'package:mate_app/Services/StudyGroupService.dart';
import 'package:flutter/foundation.dart';

class StudyGroupProvider with ChangeNotifier {
  StudyGroupService _studyGroupService = StudyGroupService();
  List<StudyGroup> _studyGrops = [];
  String _errors = "";
  late Map<String, dynamic> _validationErrors;
  bool _studyGropsLoader = false;

  // StudyGroupProvider() {
  //   _studyGroupService = StudyGroupService();
  // }

  //getters
  bool get studyGropsLoader => _studyGropsLoader;
  List<StudyGroup> get studyGrops => _studyGrops;
  Map<String, dynamic> get validationErrors => _validationErrors;
  String get errors => _errors;

  //setters
  set validationErrors(Map<String, dynamic> error) {
    _validationErrors = error;
    notifyListeners();
  }

  set studyGropsLoaderStatus(bool val) {
    if (_studyGropsLoader != val) {
      _studyGropsLoader = val;
      notifyListeners();
    }
  }

  set studyGroupList(List<StudyGroup> sgl) {
    _studyGrops = sgl;
    notifyListeners();
  }

  set error(String val) {
    if (_errors != val) {
      _errors = val;
      notifyListeners();
    }
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

  Future<void> fetchStudyGrops({dynamic page, String? search}) async {
    studyGropsLoaderStatus = true;
    error = '';
    try {
      Map<String, dynamic> queryParams = Map();

      if (page != null) {
        queryParams["page"] = page;
      }

      if (search != null) {
        queryParams["search"] = search;
      }

      var data = await _studyGroupService.fetchStudyGroups(queryParams);

      List<StudyGroup> rawData = [];
      for (int i = 0; i < data.length; i++) {
        rawData.add(StudyGroup.fromJson(data[i]));
      }

      studyGroupList = rawData;
    } catch (err) {
      _setError(err);
    } finally {
      studyGropsLoaderStatus = false;
    }
  }
}
