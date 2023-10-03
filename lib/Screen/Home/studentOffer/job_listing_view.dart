import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Widget/Loaders/Shimmer.dart';
import '../../../asset/Colors/MateColors.dart';
import '../../../controller/student_offer_controller.dart';
import '../../../controller/theme_controller.dart';

class JobListingView extends StatelessWidget {
  JobListingView({Key? key}) : super(key: key);

  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StudentOfferController>(
      builder: (studentOfferController){
        return studentOfferController.isLoadingJob?
        timelineLoader() :
        studentOfferController.selectedSkillJob.isEmpty?
        Center(
          child: Text("Please update your profile to see job recommendation",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
              letterSpacing: 0.1,
              color: themeController.isDarkMode?Colors.white:Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ):
        ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: ScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: studentOfferController.jobList.length,
          itemBuilder: (context,index){
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: themeController.isDarkMode ? MateColors.containerDark : MateColors.containerLight,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Job Details : ",
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      color: themeController.isDarkMode?Colors.white:Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    studentOfferController.jobList[index],
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      color: themeController.isDarkMode?Colors.white:Colors.black,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
