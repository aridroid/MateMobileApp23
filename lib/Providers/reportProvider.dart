import 'package:mate_app/Exceptions/Custom_Exception.dart';
import 'package:mate_app/Services/reportService.dart';
import 'package:flutter/cupertino.dart';

import '../Model/appUpdateModel.dart';

class ReportProvider extends ChangeNotifier{


  /// initialization

  ReportService _reportService = ReportService();
  String _apiError = "";
  Map<String, dynamic> _validationErrors = Map();


  /// initializing loader status
  bool _postReportLoader = false;
  bool _userBlockLoader = false;
  bool _appUpdateLoader = false;

  AppUpdateModel? _appUpdateModelData;


  ///constructor
  // ReportProvider() {
  //   _reportService = ReportService();
  // }


  ///getters

  bool get postReportLoader => _postReportLoader;

  bool get userBlockLoader => _userBlockLoader;

  bool get appUpdateLoader => _appUpdateLoader;

  AppUpdateModel? get appUpdateModelData => _appUpdateModelData;

  String get error => _apiError;

  Map<String, dynamic> get validationErrors => _validationErrors;


  ///setters
  set error(String val) {
    _apiError = val;
    notifyListeners();
  }

  set validationErrors(Map<String, dynamic> error) {
    _validationErrors = error;
    notifyListeners();
  }

  set reportPostLoaderStatus(bool val) {
    if (_postReportLoader != val) {
      _postReportLoader = val;
      notifyListeners();
    }
  }

  void _setError(err) {
    print('error of type (${err.runtimeType}) in Report provider $err');
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


  /// methods

  Future<bool> reportPost(Map<String,dynamic> body) async {
    error = '';
    _postReportLoader=true;
    var data;
    try {
      data = await _reportService.reportPost(body);
    } catch (err) {
      _setError(err);
      return false;
    } finally {
      _postReportLoader=false;
    }
    return true;
  }

  Future<bool> blockUser(Map<String,dynamic> body) async {
    error = '';
    _userBlockLoader=true;
    var data;
    try {
      data = await _reportService.blockUser(body);
    } catch (err) {
      _setError(err);
      return false;
    } finally {
      _userBlockLoader=false;
    }
    return true;
  }

  Future<void> appUpdate() async {
    error = '';
    _appUpdateLoader=true;
    try {
      _appUpdateModelData = await _reportService.appUpdate();
    } catch (err) {
      _setError(err);
    } finally {
      _appUpdateLoader=false;
      notifyListeners();
    }
  }




}