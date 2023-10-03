import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart'as http;
import 'package:mate_app/Model/job_listing_model.dart';
import 'package:mate_app/controller/jobBoardController.dart';


class JobBoardService{

  Future<List<Jobs>> getJobListing({
    required String token,
    required int page,
    required String searchKeyword,
    required List<String> areas,
    required List<String> country,
    required List<String> city,
    required List<String> company,
    required List<String> experience,
    required List<String> education,
    required List<String> skills,
    required List<String> role_types,
  })async{
    List<Jobs> jobs = [];
    JobBoardController jobBoardController = Get.find<JobBoardController>();;

    try {
      final String _scheme = 'https';
      final String _host = 'api.mateapp.us';
      final String _path = 'api';

      Map<String, dynamic> queryParams = {"page": page.toString()};

      Map<String, dynamic> body = {};

      if (searchKeyword != "") {
        body["keywords"] = searchKeyword;
      }
      if (areas.isNotEmpty) {
        body["areas"] = areas;
      }
      if (country.isNotEmpty) {
        body["country"] = country;
      }
      if (city.isNotEmpty) {
        body["city"] = city;
      }
      if (company.isNotEmpty) {
        body["company"] = company;
      }
      if (experience.isNotEmpty) {
        body["experience"] = experience;
      }
      if (education.isNotEmpty) {
        body["education"] = education;
      }
      if (skills.isNotEmpty) {
        body["skills"] = skills;
      }
      if (role_types.isNotEmpty) {
        body["role_types"] = role_types;
      }

      Uri url = Uri(
        scheme: _scheme,
        host: _host,
        path: '$_path/jobs',
        queryParameters: queryParams,
      );

      debugPrint(url.toString());
      debugPrint(jsonEncode(body));

      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer" +token,
          'Content-type' : 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
        var jobListingModel = JobListingModel.fromJson(parsed);
        jobs = jobListingModel.data.jobs;
        // if(jobListingModel.data.meta.lastPage == jobBoardController.page){
        //   jobBoardController.setIsPaginationApplicable = false;
        // }
      }else {
        var parsed = json.decode(utf8.decode(response.bodyBytes));
        debugPrint(parsed.toString());
      }
    }catch (e) {
      log(e.toString());
    }
    return jobs;
  }

}