import 'dart:convert';
import 'dart:io';

import 'package:mate_app/Exceptions/Custom_Exception.dart';
import 'package:mate_app/Model/groupChatDataModel.dart';
import '../Model/profileChatDataModel.dart';
import 'APIService.dart';
import 'BackEndAPIRoutes.dart';

class ChatService {
  APIService _apiService;
  BackEndAPIRoutes _backEndAPIRoutes;

  ChatService() {
    _apiService = APIService();
    _backEndAPIRoutes = BackEndAPIRoutes();
  }

  Future personalChatDataFetch(String uid) async {
    try {
      final response = await _apiService.get(uri: _backEndAPIRoutes.personalChatDataFetch(uid));

      return PersonalChatDataModel.fromJson(json.decode(response.body));
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } on ValidationFailureException catch (error) {
      throw error;
    } catch (error) {
      print('error occurred fetching from ${_backEndAPIRoutes.personalChatDataFetch(uid).toString()} :: $error');
      throw Exception('$error');
    }
  }

  Future groupChatDataFetch(String uid) async {
    try {
      final response = await _apiService.get(uri: _backEndAPIRoutes.groupChatDataFetch(uid));

      return GroupChatDataModel.fromJson(json.decode(response.body));
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } on ValidationFailureException catch (error) {
      throw error;
    } catch (error) {
      print('error occurred fetching from ${_backEndAPIRoutes.groupChatDataFetch(uid).toString()} :: $error');
      throw Exception('$error');
    }
  }

  Future personalChatDataUpdate(Map<String,dynamic> body) async {
    try {
      final response = await _apiService.post(uri: _backEndAPIRoutes.personalChatDataUpdate(), data: body);

      return json.decode(response.body);
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } on ValidationFailureException catch (error) {
      throw error;
    } catch (error) {
      print('error occurred fetching from ${_backEndAPIRoutes.personalChatDataUpdate().toString()} :: $error');
      throw Exception('$error');
    }
  }

  Future groupChatDataUpdate(Map<String,dynamic> body) async {
    try {
      final response = await _apiService.post(uri: _backEndAPIRoutes.groupChatDataUpdate(), data: body);

      return json.decode(response.body);
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } on ValidationFailureException catch (error) {
      throw error;
    } catch (error) {
      print('error occurred fetching from ${_backEndAPIRoutes.groupChatDataUpdate().toString()} :: $error');
      throw Exception('$error');
    }
  }

  Future personalChatMessageReadUpdate(Map<String,dynamic> body) async {
    try {
      final response = await _apiService.post(uri: _backEndAPIRoutes.personalChatMessageReadUpdate(), data: body);

      return json.decode(response.body);
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } on ValidationFailureException catch (error) {
      throw error;
    } catch (error) {
      print('error occurred fetching from ${_backEndAPIRoutes.personalChatMessageReadUpdate().toString()} :: $error');
      throw Exception('$error');
    }
  }

  Future groupChatMessageReadUpdate(Map<String,dynamic> body) async {
    try {
      final response = await _apiService.post(uri: _backEndAPIRoutes.groupChatMessageReadUpdate(), data: body);

      return json.decode(response.body);
    } on SocketException catch (error) {
      throw Exception('NO INTERNET :: $error');
    } on ValidationFailureException catch (error) {
      throw error;
    } catch (error) {
      print('error occurred fetching from ${_backEndAPIRoutes.groupChatMessageReadUpdate().toString()} :: $error');
      throw Exception('$error');
    }
  }











}