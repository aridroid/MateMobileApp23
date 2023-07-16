import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mate_app/controller/theme_controller.dart';

import '../../asset/Colors/MateColors.dart';

class BioDetailsPage extends StatefulWidget {
  final String bio;
  const BioDetailsPage({Key? key, required this.bio}) : super(key: key);

  @override
  _BioDetailsPageState createState() => _BioDetailsPageState();
}

class _BioDetailsPageState extends State<BioDetailsPage> {
  ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        iconTheme: IconThemeData(
          color: MateColors.activeIcons,
        ),
        title: Text("About",
          style: TextStyle(
            color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
            fontWeight: FontWeight.w700,
            fontSize: 17.0,
          ),
        ),
      ),
      body: ListView(
        physics: ScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 16,vertical: 20),
        children: [
          Text(
            widget.bio,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.1,
              color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
