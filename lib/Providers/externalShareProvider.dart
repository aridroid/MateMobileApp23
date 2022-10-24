

import 'package:mate_app/Exceptions/Custom_Exception.dart';
import 'package:mate_app/Services/externalShareService.dart';
import 'package:flutter/cupertino.dart';

class ExternalShareProvider extends ChangeNotifier{


  /// initialization

  ExternalShareService _externalShareService;
  String _apiError = "";
  Map<String, dynamic> _validationErrors = Map();


  /// initializing loader status
  bool _postExternalShareLoader = false;


  ///constructor
  ExternalShareProvider() {
    _externalShareService = ExternalShareService();
  }


  ///getters

  bool get postExternalShareLoader => _postExternalShareLoader;

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

  set externalSharePostLoaderStatus(bool val) {
    if (_postExternalShareLoader != val) {
      _postExternalShareLoader = val;
      notifyListeners();
    }
  }

  void _setError(err) {
    print('error of type (${err.runtimeType}) in Campus Talk provider $err');
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

  Future<bool> externalSharePost(Map<String,dynamic> body) async {
    error = '';
    _postExternalShareLoader=true;
    var data;
    try {
      data = await _externalShareService.externalSharePost(body);
    } catch (err) {
      _setError(err);
      return false;
    } finally {
      _postExternalShareLoader=false;
    }
    return true;
  }
}