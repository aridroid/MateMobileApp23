import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mate_app/Screen/Home/Mate/job_board_tile.dart';
import 'package:mate_app/controller/jobBoardController.dart';

import '../../../Widget/Loaders/Shimmer.dart';
import '../../../controller/theme_controller.dart';

class JobBoard extends StatefulWidget {
  JobBoard({Key? key}) : super(key: key);

  @override
  State<JobBoard> createState() => _JobBoardState();
}

class _JobBoardState extends State<JobBoard> {
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<JobBoardController>(
      builder: (jobBoardController){
        return jobBoardController.isLoading?
        timelineLoader() :
        ListView.builder(
          controller: jobBoardController.scrollControllerDashBoard,
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: ScrollPhysics(),
          itemCount: jobBoardController.jobList.length,
          itemBuilder: (context,index){
            return JobBoardTile(jobs: jobBoardController.jobList[index]);
          },
        );
      },
    );
  }
}
