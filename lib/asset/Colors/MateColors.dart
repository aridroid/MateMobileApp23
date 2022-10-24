import 'package:flutter/painting.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mate_app/controller/theme_controller.dart';


ThemeController themeController1 = Get.find<ThemeController>();

class MateColors extends ColorSwatch<int> {

  // MateColors._();
  const MateColors(int primary, this._mate) : super(primary, _mate);

  final Map<int, Color> _mate;

  // The Color for most of the lines in the app
  static const Color line = Color(0xff393e46);

  // The primary color for most of the active icons/buttons
  // static Color activeIcons = themeController1.isDarkMode? Color(0xff75f3e7) : Color(0xFF1DBFB0);
  static const Color activeIcons = Color(0xff75f3e7);
  // static Color activeIcons1 = MateColors.activeIcons;
  
  // The primary color for most of the active icons/buttons
  static const Color inActiveIcons = Color(0x8075f3e7);

  // The primary color for most of the active icons/buttons
  static const Color purpleColor = Color(0xFF8C6DF2);
// static Color activeIcons1 = MateColors.activeIcons;

  //static const Color greyContainerColor =  Color(0xFF8C6DF2);

  static const Color darkDivider = Color(0xFF1E1E21);
  static const Color blackTextColor = Color(0xFF0B0B0D);
  static const Color lightDivider = Color(0xFFF0F0F5);
  static const Color drawerTileColor = Color(0xFF101012);
  static const Color subTitleTextDark = Color(0xFF65656B);
  static const Color subTitleTextLight = Color(0xFF8A8A99);
  static const Color iconDark = Color(0xFF414147);
  static const Color iconLight = Color(0xFFB4B4C2);
  static const Color lightButtonBackground = Color(0xFFF5F5F7);











}
