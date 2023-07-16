import 'dart:async';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Exceptions/Custom_Exception.dart';
import 'dart:convert';

class APIService {

  final Dio _dio = Dio();

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('tokenApp');
  }

  Future<http.Response> get({required Uri uri}) async {
    String? token = await _getToken();

    print('bakend_token = $token');

    final response = await http.get(uri, headers: {
      'content-type': 'application/json',
      'accept': 'application/json',
      'Authorization': 'Bearer $token'
    },).timeout(Duration(seconds: 30), onTimeout: () {
      throw TimeoutException('Request Timeout');
    });

    print("$uri API HTTP Status::  ${response.statusCode}, data:: ${json.decode(response.body).toString()}");

    return _response(response);
  }

  Future<http.Response> post(
      {required Uri uri, Map<String, dynamic>? data}) async {
    Map<String, String> headers = {
      'accept': 'application/json',
      'content-type': 'application/json'
    };

    String? token = await _getToken();
    if (token != null) {
      headers["Authorization"] = "Bearer $token";
    }

    final response = await http
        .post(uri, body: json.encode(data), headers: headers)
        .timeout(Duration(seconds: 30), onTimeout: () {
      throw TimeoutException('Request Timeout');
    });

    print(
        "$uri API HTTP Status::  ${response.statusCode}, data:: ${json.decode(response.body).toString()}");

    return _response(response);
  }


  Future<Response> postWithFormData(
      {required Uri uri, FormData? formData}) async {
    Map<String, String> headers = {
      'accept': 'application/json',
      'content-type': 'application/json'
    };

    String? token = await _getToken();
    if (token != null) {
      headers["Authorization"] = "Bearer $token";
    }

    // final response = await http
    //     .post(uri, body: formData, headers: headers)
    //     .timeout(Duration(seconds: 60), onTimeout: () {
    //   throw TimeoutException('Request Timeout');
    // });

    print(uri.toString());
    Response response = await _dio.post(uri.toString(),
        data: formData,
        options: Options(headers: {"Authorization": "Bearer " + token!}));
    print(response.data);
    // print(
    //     "$uri API HTTP Status::  ${response.statusCode}, data:: ${json.decode(response.data).toString()}");

    return _formDataResponse(response);
  }




  // Future uploadFile({@required Uri uri, @required String file}) async {
  //   String token = await _getToken();

  //   var request = http.MultipartRequest('POST', uri);
  //   //..fields['photo'] = 'something';
  //   request.headers.addAll({
  //     'accept': 'application/json',
  //     'access_token': 'Bearer $token',
  //   });

  //   //photo is key name
  //   request.files.add(await http.MultipartFile.fromPath('photo', file.path,
  //       filename: file.path.split('/').last));
  //   print('request headers: ${request.headers.toString()}');
  //   var response = await request.send();
  //   print(
  //       "$uri API HTTP Status::  ${response.statusCode}, data:: ${response.stream}");
  //   return response;

  //   print('sending');

  // var request =  http.MultipartRequest('POST', uri);
  //               //..fields['photo'] = 'something';
  // request.files.add(
  //                   http.MultipartFile.fromBytes(
  //                       'picture',
  //                       File(file).readAsBytes(),
  //                       filename: fileName
  //                   ));
  //
  // StreamedResponse response = await request.send();
  //
  // print("$uri API HTTP Status::  ${response.statusCode}, data:: ${json.decode(response.body).toString()}");
  //
  // return _response(response);
  // }

  dynamic _response(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
      case 204:
        return response;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(
            json.decode(response.body)['data']['message'].toString());
      case 404:
        throw NotFoundException(
            json.decode(response.body)['message'].toString());
      case 422:
        var error = json.decode(response.body) as Map<String, dynamic>;

        throw ValidationFailureException(error['message'], error['data']);
      case 500:

      default:
        throw FetchDataException(
            'Error occurred while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }


  dynamic _formDataResponse(Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
      case 204:
        return response;
      case 400:
        throw BadRequestException(response.data['data'].toString());
      case 401:
      case 403:
        throw UnauthorisedException(
            json.decode(response.data['data']['message']).toString());
      case 404:
        throw NotFoundException(
            json.decode(response.data['data']['message']).toString());
      case 422:
        var error = json.decode(response.data) as Map<String, dynamic>;

        throw ValidationFailureException(error['message'], error['data']);
      case 500:

      default:
        throw FetchDataException(
            'Error occurred while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
