import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../asset/Colors/MateColors.dart';
import '../../controller/theme_controller.dart';

class MarketPlaceDashboard extends StatefulWidget {
  const MarketPlaceDashboard({Key key}) : super(key: key);

  @override
  State<MarketPlaceDashboard> createState() => _MarketPlaceDashboardState();
}

class _MarketPlaceDashboardState extends State<MarketPlaceDashboard> {
  ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    final scH = MediaQuery.of(context).size.height;
    final scW = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: scH,
        width: scW,
        decoration: BoxDecoration(
          color: themeController.isDarkMode?Color(0xFF000000):Colors.white,
          image: DecorationImage(
            image: AssetImage(themeController.isDarkMode?'lib/asset/Background.png':'lib/asset/BackgroundLight.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height*0.07,
                left: 16,
                right: 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: (){
                      Get.back();
                    },
                    child: Icon(Icons.arrow_back_ios,
                      size: 20,
                      color: themeController.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  Text(
                    "Market Place",
                    style: TextStyle(
                      color: themeController.isDarkMode ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                      fontSize: 18.0,
                    ),
                  ),
                  SizedBox(),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  "Coming soon",
                  style: TextStyle(
                    color: themeController.isDarkMode ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
