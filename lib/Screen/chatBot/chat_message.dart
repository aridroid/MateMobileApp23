import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Utility/Utility.dart';
import '../../asset/Colors/MateColors.dart';
import '../../controller/theme_controller.dart';


class ChatMessage extends StatelessWidget {
  const ChatMessage({required this.text, required this.sender, this.isImage = false});

  final String text;
  final String sender;
  final bool isImage;

  @override
  Widget build(BuildContext context) {
    ThemeController themeController = Get.find<ThemeController>();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: isImage ?
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              text,
              loadingBuilder: (context, child, loadingProgress) =>
              loadingProgress == null ?
              child : const CircularProgressIndicator.adaptive(),
            ),
          ):
          Container(
            padding: EdgeInsets.only(top: 5, bottom: 5, left:  10, right:  10),
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.only(top: 15, bottom: 15, left: 20, right:20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
                color:  themeController.isDarkMode? chatGreyColor: Colors.white.withOpacity(0.4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(sender,
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: themeController.isDarkMode? MateColors.appThemeDark : MateColors.appThemeLight,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    text,
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.1,
                      color: themeController.isDarkMode? Colors.white : MateColors.blackTextColor,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}