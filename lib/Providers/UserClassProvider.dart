import 'package:mate_app/Exceptions/Custom_Exception.dart';
import 'package:mate_app/Model/JoinedClass.dart';
import 'package:mate_app/Services/UserClassService.dart';
import 'package:flutter/material.dart';

class UserClassProvider with ChangeNotifier {
  UserClassService _userClassService;
  bool _joinClassLoader = false;
  Map<String, dynamic> _validationErrors = Map<String, dynamic>();
  String _apiError = "";
  bool _myClassLoader = false;
  bool _assignmentAddLoader = false;
  List<JoinedClass> _joinedClasses = [];

  bool get joinClassLoaderStatus => _joinClassLoader;
  bool get assignmentAddLoaderStatus => _assignmentAddLoader;
  Map<String, dynamic> get validationErrors => _validationErrors;
  String get error => _apiError;
  bool get myClassLoaderStatus => _myClassLoader;
  List<JoinedClass> get joinedClasses => _joinedClasses;

  set myClassLoader(bool val) {
    if (_myClassLoader != val) {
      _myClassLoader = val;
      notifyListeners();
    }
  }

  set joinedClasses(List<JoinedClass> jc) {
    _joinedClasses = jc;
    notifyListeners();
  }

  set validationErrors(Map<String, dynamic> error) {
    _validationErrors = error;
    notifyListeners();
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

  set joinClassLoaderStatus(bool val) {
    if (_joinClassLoader != val) {
      _joinClassLoader = val;
      notifyListeners();
    }
  }

  set assignmentAddLoaderStatus(bool val) {
    if (_assignmentAddLoader != val) {
      _assignmentAddLoader = val;
      notifyListeners();
    }
  }

  set error(String val) {
    _apiError = val;
    notifyListeners();
  }

  UserClassProvider() {
    _userClassService = UserClassService();
  }

  Future<void> userClasses() async {
    //auth user

    error = "";
    myClassLoader = true;

    try {
      var data = await _userClassService.myClasses();
      List<JoinedClass> rawClass = [];

      for (int i = 0; i < data.length; i++) {
        rawClass.add(JoinedClass.fromJson(data[i]));
      }

      _userClassService.saveMyClassesToSharedPreference(data);

      _joinedClasses = rawClass;
    } catch (error) {
      _setError(error);
    } finally {
      myClassLoader = false;
    }
  }

  Future<void> joinClass(
      {@required int courseId,
      @required String semester,
      @required int year}) async {
    error = "";
    joinClassLoaderStatus = true;
    validationErrors = Map();

    Map<String, dynamic> userInput = {
      "course_id": courseId,
      "semester": semester,
      "year": year,
    };

    try {
      await _userClassService.joinClass(data: userInput);

      await userClasses();
    } catch (error) {
      _setError(error);
    } finally {
      joinClassLoaderStatus = false;
    }
  }

  Future<bool> addAssignment(
      {@required String classId,
      @required String name,
      @required String dueDate}) async {
    error = "";
    assignmentAddLoaderStatus = true;
    try {
      await _userClassService.addAssignment(
          id: classId, data: {"name": name, "due_date": dueDate});

      await userClasses();
      return true;
    } catch (error) {
      _setError(error);
      return false;
    } finally {
      assignmentAddLoaderStatus = false;
    }
  }
}
