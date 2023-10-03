import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'package:mate_app/Model/course_listing_model.dart';


class StudentOfferService{

  Future<List<String>> getCourseListing({required List<String> skill})async{
    List<String> course = [];
    try {
      Map<String, dynamic> body = {
        "skills" : skill,
      };
      
      Uri url = Uri.parse('http://18.144.15.163:8900/get_course_recommendations/');
      debugPrint(url.toString());
      debugPrint(jsonEncode(body));

      final response = await http.post(
        url,
        body: utf8.encode(json.encode(body)),
      );

      if (response.statusCode == 200) {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
        CourseListingModel courseListingModel = CourseListingModel.fromJson(parsed);
        course = courseListingModel.response??[];
      }else {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
      }
    }catch (e) {
      log(e.toString());
    }
    return course;
  }

  Future<List<String>> getJobListing({required List<String> skill})async{
    List<String> course = [];
    try {
      Map<String, dynamic> body = {
        "skills" : skill,
      };

      Uri url = Uri.parse('http://18.144.15.163:8900/get_job_recommendations/');
      debugPrint(url.toString());
      debugPrint(jsonEncode(body));

      final response = await http.post(
        url,
        body: utf8.encode(json.encode(body)),
      );

      if (response.statusCode == 200) {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
        CourseListingModel courseListingModel = CourseListingModel.fromJson(parsed);
        course = courseListingModel.response??[];
      }else {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
      }
    }catch (e) {
      log(e.toString());
    }
    return course;
  }

}