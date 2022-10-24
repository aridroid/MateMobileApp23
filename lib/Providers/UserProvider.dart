import 'package:flutter/material.dart';

import '../Model/FeedItem.dart';
import '../Exceptions/Custom_Exception.dart';
import '../Services/UserService.dart';
import '../Model/User.dart' as FullUser;

class UserProvider with ChangeNotifier {
  UserService _userService;

  UserProvider() {
    _userService = UserService();
  }

  List<User> _users = [];
  bool _userSearchLoader = false;
  String _error = "";
  Map<String, dynamic> _validationError;
  bool _followUserLoader = false;
  bool _unFollowUserLoader = false;

  FullUser.User _user; //aliased
  bool _userDetailLoader = false;

  get users => _users;
  get userSearchLoaderStatus => _userSearchLoader;
  get error => _error;
  get validationErrors => _validationError;
  FullUser.User get fullUserDetail => _user;
  bool get userDetailLoader => _userDetailLoader;
  get followUserLoaderStatus => _followUserLoader;
  get unFollowUserLoaderStatus => _unFollowUserLoader;

  set error(String val) {
    _error = val;
    notifyListeners();
  }

  set fullUserDetail(FullUser.User user) {
    _user = user;
    notifyListeners();
  }

  set userDetailLoader(bool val) {
    if (_userDetailLoader != val) {
      _userDetailLoader = val;
      notifyListeners();
    }
  }

  set followUserLoaderStatus(bool val) {
    if (_followUserLoader != val) {
      _followUserLoader = val;
      notifyListeners();
    }
  }

  set unFollowUserLoaderStatus(bool val) {
    if (_unFollowUserLoader != val) {
      _unFollowUserLoader = val;
      notifyListeners();
    }
  }

  set userSearchLoaderStatus(bool val) {
    if (_userSearchLoader != val) {
      _userSearchLoader = val;
      notifyListeners();
    }
  }

  set users(List<User> users) {
    _users = users;
    notifyListeners();
  }

  set validationErrors(Map<String, dynamic> error) {
    _validationError = error;
    notifyListeners();
  }

  void _setError(err) {
    print('error of type (${err.runtimeType}) in provider $err');
    try {
      if (err is ValidationFailureException) {
        validationErrors = err.validationErrors;
      }

      error = err.message.toString();
    } catch (e) {
      error = "Something Went Wrong";
    }
  }

  Future<void> findUserById({@required String id}) async {
    error = "";
    userDetailLoader = true;

    try {
      var data = await _userService.findUserById(id);

      print(data);
      fullUserDetail = FullUser.User.fromJson(data);

    } catch (err) {
      _setError(err);
    } finally {
      userDetailLoader = false;
    }
  }

  Future followUser({@required String followingId}) async {
    error = '';
    followUserLoaderStatus = true;

    try {
      var data = await _userService.followUser({"following_id": followingId});

      fullUserDetail = FullUser.User.fromJson(data);
    } catch (err) {
      _setError(err);
    } finally {
      followUserLoaderStatus = false;
    }
  }

  Future unFollowUser({@required String followingId}) async {
    error = '';
    unFollowUserLoaderStatus = true;

    try {
      var data = await _userService.unFollowUser({"following_id": followingId});

      fullUserDetail = FullUser.User.fromJson(data);
    } catch (err) {
      _setError(err);
    } finally {
      unFollowUserLoaderStatus = false;
    }
  }

  Future<void> searchUser([String search = "", int perPage = 0]) async {
    //per_page = numeric/all
    print('pr method started');
    error = '';
    userSearchLoaderStatus = true;

    try {
      Map<String, dynamic> queryParams = Map();

      if (search != "") {
        queryParams["search"] = search;
      }

      if (perPage > 0) {
        queryParams["per_page"] = perPage;
      }

      var data = await _userService.searchUser(queryParams);

      List<User> rawList = [];
      for (int i = 0; i < data.length; i++) {
        rawList.add(User.fromJson(data[i]));
      }

      users = rawList;

      for (int i = 0; i < _users.length; i++) {
        print('user phones are ${_users[i].photoUrl}');
      }
    } catch (err) {
      _setError(err);
    } finally {
      userSearchLoaderStatus = false;
    }
  }
}
