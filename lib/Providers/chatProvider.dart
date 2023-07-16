import 'package:mate_app/Exceptions/Custom_Exception.dart';
import 'package:flutter/cupertino.dart';

import '../Model/chatMergedModel.dart';
import '../Model/groupChatDataModel.dart';
import '../Model/profileChatDataModel.dart';
import '../Services/chatService.dart';

class ChatProvider extends ChangeNotifier{

  /// initialization

  ChatService _chatService = ChatService();
  String _apiError = "";
  Map<String, dynamic> _validationErrors = Map();


  /// initializing loader status
  bool _personalChatDataFetchLoader = false;
  bool _groupChatDataFetchLoader = false;
  bool _mergedChatDataFetchLoader = false;

  PersonalChatDataModel? _personalChatModelData;
  GroupChatDataModel? _groupChatModelData;
  ChatMergedModel? _mergedChatModelData;

  ///constructor
  // ChatProvider() {
  //   _chatService = ChatService();
  // }


  ///getters

  bool get personalChatDataFetchLoader => _personalChatDataFetchLoader;

  bool get groupChatDataFetchLoader => _groupChatDataFetchLoader;

  bool get mergedChatDataFetchLoader => _mergedChatDataFetchLoader;

  PersonalChatDataModel? get personalChatModelData => _personalChatModelData;

  GroupChatDataModel? get groupChatModelData => _groupChatModelData;

  ChatMergedModel? get mergedChatModelData => _mergedChatModelData;

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

  List<CustomDataForChatList> messageList = [];
  List<CustomDataForChatList> archiveList = [];
  bool mergedChatApiError = false;
  Future<void> mergedChatDataFetch(String uid,bool shouldLoad) async {
    mergedChatApiError = false;
    if(shouldLoad){
      _mergedChatDataFetchLoader=true;
    }
    notifyListeners();
    try {
      _mergedChatModelData = await _chatService.mergedChatDataFetch(uid);
      messageList.clear();
      archiveList.clear();
      for(int i=0;i<_mergedChatModelData!.data!.length;i++){
        messageList.add(CustomDataForChatList(
          name: "",
          author: "",
          roomId: _mergedChatModelData!.data![i].roomId,
          receiverUid: _mergedChatModelData!.data![i].receiverUid,
          updatedAt: _mergedChatModelData!.data![i].updatedAt,
          createdAt: _mergedChatModelData!.data![i].createdAt,
          isMuted: _mergedChatModelData!.data![i].isMuted,
          isPinned: _mergedChatModelData!.data![i].isPinned,
          totalMessages: _mergedChatModelData!.data![i].totalMessages,
          type: _mergedChatModelData!.data![i].type,
          unreadMessages: _mergedChatModelData!.data![i].unreadMessages,
        ));
      }
      print(messageList);
      for(int i=0;i<_mergedChatModelData!.archived!.length;i++){
        archiveList.add(CustomDataForChatList(
          name: "",
          author: "",
          roomId: _mergedChatModelData!.archived![i].roomId,
          receiverUid: _mergedChatModelData!.archived![i].receiverUid,
          updatedAt: _mergedChatModelData!.archived![i].updatedAt,
          createdAt: _mergedChatModelData!.archived![i].createdAt,
          isMuted: _mergedChatModelData!.archived![i].isMuted,
          isPinned: _mergedChatModelData!.archived![i].isPinned,
          totalMessages: _mergedChatModelData!.archived![i].totalMessages,
          type: _mergedChatModelData!.archived![i].type,
          unreadMessages: _mergedChatModelData!.archived![i].unreadMessages,
        ));
      }
      print(archiveList);
    } catch (err) {
      mergedChatApiError = true;
      notifyListeners();
    } finally {
      _mergedChatDataFetchLoader=false;
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