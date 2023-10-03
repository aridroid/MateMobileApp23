import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Services/student_offer_service.dart';

class StudentOfferController extends GetxController{
  late PageController _pageController;
  PageController get pageController => _pageController;

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;
  void setSelectedIndex(int value){
    _selectedIndex = value;
    update();
  }

  bool isLoadingCourse = true;
  bool isLoadingJob = true;

  @override
  void onInit() {
    _pageController = PageController(initialPage: _selectedIndex);
    getStoredCourseValue();
    getStoredJobValue();
    super.onInit();
  }

  @override
  void onClose() {
    _pageController.dispose();
    super.onClose();
  }

  List<String> courseList = [];
  List<String> jobList = [];
  StudentOfferService studentOfferService = StudentOfferService();
  List<String> selectedSkillCourse = [];
  List<String> selectedSkillJob = [];

  void getStoredCourseValue()async{
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    selectedSkillCourse = preferences.getStringList('selectedCourseSkill')??[];
    if(selectedSkillCourse.isNotEmpty){
      courseList = await studentOfferService.getCourseListing(skill: selectedSkillCourse);
    }
    isLoadingCourse = false;
    update();
  }

  void getStoredJobValue()async{
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    selectedSkillJob = preferences.getStringList('selectedJobSkill')??[];
    if(selectedSkillJob.isNotEmpty){
      jobList = await studentOfferService.getJobListing(skill: selectedSkillJob);
    }
    isLoadingJob = false;
    update();
  }


}