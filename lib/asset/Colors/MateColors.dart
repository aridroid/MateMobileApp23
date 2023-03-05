import 'package:flutter/material.dart';

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

  ///New Design Color
  static const Color whiteText = Colors.white;
  static const Color blackText = Color(0xFF101012);
  static Color containerDark = Colors.white.withOpacity(0.12);
  static Color containerLight = Colors.white.withOpacity(0.50);
  static Color textFieldSearchDark = Colors.white.withOpacity(0.07);
  static Color textFieldSearchLight = Colors.white.withOpacity(0.20);
  static Color helpingTextDark = Colors.white.withOpacity(0.5);
  static const Color helpingTextLight = Color(0xFFB4B4C2);
  static const Color appThemeDark = Color(0xFF75F3E7);
  static const Color appThemeLight = Color(0xFF32C981);
  static const Color greyButtonText = Color(0xFFB0B0B0);
  static const Color disableButtonColor = Color(0xFF3D3F45);
  static Color bottomSheetBackgroundDark = Color(0xFF424345);
  static Color bottomSheetItemBackgroundDark = Colors.white.withOpacity(0.15);
  static Color bottomSheetBackgroundLight = Color(0xFFA1A7A7);
  static Color bottomSheetItemBackgroundLight = Colors.white.withOpacity(0.23);
  static Color dividerDark = Color(0xFFDDE8E8).withOpacity(0.1);
  static Color dividerLight = Colors.black.withOpacity(0.1);
  static Color smallContainerDark = Color(0xFF595E6E).withOpacity(0.35);
  static Color smallContainerLight = Colors.white.withOpacity(0.50);
  static Color popupDark = Colors.white.withOpacity(0.12);
  static Color popupLight = Colors.white.withOpacity(0.7);
  static Color iconPopupLight = Color(0xFF8A8A99);










}
