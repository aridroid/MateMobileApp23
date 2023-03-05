import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mate_app/asset/Colors/MateColors.dart';
import 'package:sizer/sizer.dart';

final Color backgroundColor = Color(0xFF0B0B0D);
final Color myHexColor = Color(0xff222831);
final Color myLightHexColor = Color(212832);
final Color myFontColor = Color(0xff061c24);
// final Color chatTealColor = Color.fromRGBO(101,202,195, 0.8);
// final Color chatGreyColor = Color.fromRGBO(57,62,70, 1);
// final Color chatTealColor = Color(0xFF75F3E7);
final Color chatTealColor = Color(0xFF67AE8C);
// final Color chatGreyColor = Color(0xFF1E1E21);
final Color chatGreyColor = Colors.white.withOpacity(0.05);
String userName = "";
String userEmail = "";
String userPhoto = "";
String userKey = "";
String authToken = "";
String baseUrl = "https://api.mate_app.us/";
String imageBaseUrl='https://api.mate_app.us/storage/';
// String imageBaseUrl='https://d2rgcl1a52ta8i.cloudfront.net/';
String videoBaseUrl='https://d2rgcl1a52ta8i.cloudfront.net/';
String loginEndPoint = "api/login";
String studyGroupEndPoint = "api/study-groups"; //endpoint for study group

Map<int, Color> color = {
  50: Color.fromRGBO(255, 6, 28, .36),
  100: Color.fromRGBO(255, 6, 28, .37),
  200: Color.fromRGBO(255, 6, 28, .38),
  300: Color.fromRGBO(255, 6, 28, .39),
  400: Color.fromRGBO(255, 6, 28, .40),
  500: Color.fromRGBO(255, 6, 28, .41),
  600: Color.fromRGBO(255, 6, 28, .42),
  700: Color.fromRGBO(255, 6, 28, .43),
  800: Color.fromRGBO(255, 6, 28, .44),
  900: Color.fromRGBO(255, 6, 28, .45),
};

MaterialColor colorCustom = MaterialColor(0xFF061c24, color);

TextStyle headerTextStyle() {
  return TextStyle(
      fontFamily: "Opensans",
      fontSize: 15.0.sp,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w700,
      color: MateColors.activeIcons
  );
}

const TEXT_MESSAGE = 1;
const IMAGE_MESSAGE = 2;