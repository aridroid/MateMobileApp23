import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/theme_controller.dart';

class JobBoard extends StatefulWidget {
  const JobBoard({Key? key}) : super(key: key);

  @override
  State<JobBoard> createState() => _JobBoardState();
}

class _JobBoardState extends State<JobBoard> {
  ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Coming soon",
          style: TextStyle(
            color: themeController.isDarkMode ? Colors.white : Colors.black,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            fontSize: 18.0,
          ),
        ),
      ],
    );
  }
}
