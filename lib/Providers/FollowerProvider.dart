import 'package:mate_app/Exceptions/Custom_Exception.dart';
import 'package:mate_app/Model/FeedItem.dart';
import 'package:mate_app/Services/FollowerService.dart';
import 'package:flutter/material.dart';

class FollowerProvider with ChangeNotifier {
  FollowerService _followerService = FollowerService();
  late Map<String, dynamic> _validationError;
  List<User> _followers = [];
  List<User> _followings = [];

  // FollowerProvider() {
  //   _followerService = FollowerService();
  // }

  String _error = "";
  bool _followingLoader = false;
  bool _followerLoader = false;

  ///getters
  bool get followingLoaderStatus => _followingLoader;
  bool get followerLoaderStatus => _followerLoader;

  get error => _error;
  Map<String, dynamic> get validationErrors => _validationError;
  List<User> get followers => _followers;
  List<User> get followings => _followings;

  set followers(List<User> f) {
    _followers = f;
    notifyListeners();
  }

  set followings(List<User> f) {
    _followings = f;
    notifyListeners();
  }

  set followingLoaderStatus(bool val) {
    if (_followingLoader != val) {
      _followingLoader = val;
      notifyListeners();
    }
  }

  set followerLoaderStatus(bool val) {
    if (_followerLoader != val) {
      _followerLoader = val;
      notifyListeners();
    }
  }

  set validationErrors(Map<String, dynamic> error) {
    _validationError = error;
    notifyListeners();
  }

  set error(val) {
    _error = val;
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

  Future<void> fetchFollowings() async {
    error = '';
    followingLoaderStatus = true;

    try {
      var data = await _followerService.fetchFollowings();

      List<User> rawFollowings = [];
      for (int i = 0; i < data.length; i++) {
        rawFollowings.add(User.fromJson(data[i]));
      }

      followings = rawFollowings;
    } catch (err) {
      _setError(err);
    } finally {
      followingLoaderStatus = false;
    }
  }

  Future fetchFollowers() async {
    error = '';
    followerLoaderStatus = true;

    try {
      var data = await _followerService.fetchFollowers();

      List<User> rawFollowers = [];
      for (int i = 0; i < data.length; i++) {
        rawFollowers.add(User.fromJson(data[i]));
      }

      followers = rawFollowers;
    } catch (err) {
      _setError(err);
    } finally {
      followerLoaderStatus = false;
    }
  }
}
