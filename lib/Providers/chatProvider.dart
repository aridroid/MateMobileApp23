import 'package:mate_app/Exceptions/Custom_Exception.dart';
import 'package:flutter/cupertino.dart';

import '../Model/groupChatDataModel.dart';
import '../Model/profileChatDataModel.dart';
import '../Services/chatService.dart';

class ChatProvider extends ChangeNotifier{

  /// initialization

  ChatService _chatService;
  String _apiError = "";
  Map<String, dynamic> _validationErrors = Map();


  /// initializing loader status
  bool _personalChatDataFetchLoader = false;
  bool _groupChatDataFetchLoader = false;

  PersonalChatDataModel _personalChatModelData;
  GroupChatDataModel _groupChatModelData;


  ///constructor
  ChatProvider() {
    _chatService = ChatService();
  }


  ///getters

  bool get personalChatDataFetchLoader => _personalChatDataFetchLoader;

  bool get groupChatDataFetchLoader => _groupChatDataFetchLoader;

  PersonalChatDataModel get personalChatModelData => _personalChatModelData;

  GroupChatDataModel get groupChatModelData => _groupChatModelData;

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

  set personalChatDataFetchLoaderStatus(bool val) {
    if (_personalChatDataFetchLoader != val) {
      _personalChatDataFetchLoader = val;
      notifyListeners();
    }
  }

  void _setError(err) {
    print('error of type (${err.runtimeType}) in Chat provider $err');
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

  Future<void> personalChatDataFetch(String uid) async {
    error = '';
    _personalChatDataFetchLoader=true;
    try {
      _personalChatModelData = await _chatService.personalChatDataFetch(uid);
    } catch (err) {
      _setError(err);
    } finally {
      _personalChatDataFetchLoader=false;
      notifyListeners();
    }
  }

  Future<void> groupChatDataFetch(String uid) async {
    error = '';
    _groupChatDataFetchLoader=true;
    try {
      _groupChatModelData = await _chatService.groupChatDataFetch(uid);
    } catch (err) {
      _setError(err);
    } finally {
      _groupChatDataFetchLoader=false;
      notifyListeners();
    }
  }

  Future<bool> personalChatDataUpdate(Map<String,dynamic> body) async {
    error = '';
    // _postReportLoader=true;
    var data;
    try {
      print("test1");
      print(body);
      data = await _chatService.personalChatDataUpdate(body);
    } catch (err) {
      _setError(err);
      return false;
    } finally {
      // _postReportLoader=false;
    }
    return true;
  }

  Future<bool> groupChatDataUpdate(Map<String,dynamic> body) async {
    error = '';
    var data;
    try {
      print("test11");
      print(body);
      data = await _chatService.groupChatDataUpdate(body);
    } catch (err) {
      _setError(err);
      return false;
    } finally {
    }
    return true;
  }

  Future<bool> personalChatMessageReadUpdate(Map<String,dynamic> body) async {
    error = '';
    var data;
    try {
      print("test2");
      print(body);
      data = await _chatService.personalChatMessageReadUpdate(body);
    } catch (err) {
      _setError(err);
      return false;
    } finally {
    }
    return true;
  }

  Future<bool> groupChatMessageReadUpdate(Map<String,dynamic> body) async {
    error = '';
    var data;
    try {
      print("test22");
      print(body);
      data = await _chatService.groupChatMessageReadUpdate(body);
    } catch (err) {
      _setError(err);
      return false;
    } finally {
    }
    return true;
  }












}