import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mate_app/controller/jobBoardController.dart';

import '../../../asset/Colors/MateColors.dart';
import '../../../controller/theme_controller.dart';

class JobBoardFilterDrawer extends StatelessWidget {
  JobBoardFilterDrawer({Key? key}) : super(key: key);
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    final scH = MediaQuery.of(context).size.height;
    final scW = MediaQuery.of(context).size.width;
    return GetBuilder<JobBoardController>(
      builder: (jobBoardController){
        return SizedBox(
          width: scW*0.88,
          child: Drawer(
            child: Container(
              height: scH,
              width: scW,
              decoration: BoxDecoration(
                color: themeController.isDarkMode?Colors.white.withOpacity(0.12):Colors.white.withOpacity(0.82),
                image: DecorationImage(
                  image: AssetImage(themeController.isDarkMode?'lib/asset/iconsNewDesign/drawerDarkBackground.png':'lib/asset/iconsNewDesign/drawerLightBackground.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: scH*0.08,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 50,
                          width: scW/2.9,
                          margin: EdgeInsets.only(
                            top: 10,
                            left: 16,
                            right: 5,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: themeController.isDarkMode?Colors.white:Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Theme(
                            data: ThemeData(
                              textTheme: TextTheme(
                                bodyLarge: TextStyle(
                                  color: themeController.isDarkMode?Colors.white:Colors.black,
                                ),
                              ),
                              checkboxTheme: CheckboxThemeData(
                                fillColor: MaterialStateProperty.resolveWith ((Set  states) {
                                  return MateColors.appThemeDark;
                                }),
                              ),
                              elevatedButtonTheme: ElevatedButtonThemeData(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: themeController.isDarkMode?
                                  MateColors.appThemeDark:
                                  MateColors.appThemeLight,
                                ),
                              ),
                            ),
                            child: DropdownSearch<String>.multiSelection(
                              maxHeight: 500,
                              mode: Mode.BOTTOM_SHEET,
                              showSelectedItems: false,
                              popupBackgroundColor: themeController.isDarkMode?Color(0xFF2a3b4b).withOpacity(0.9):Color(0xFFe8f8f5),
                              dropdownButtonProps: IconButtonProps(
                                icon: Icon(Icons.keyboard_arrow_down_sharp,size: 0),
                                color: themeController.isDarkMode?MateColors.iconDark:MateColors.iconLight,
                              ),
                              searchFieldProps: TextFieldProps(
                                cursorColor: themeController.isDarkMode?Colors.white:Colors.black,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: themeController.isDarkMode?Colors.white:Colors.black,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: themeController.isDarkMode?Colors.white:Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              dropdownBuilder: (context,data){
                                return Padding(
                                  padding: const EdgeInsets.only(left: 16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Areas",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'Poppins',
                                          color: themeController.isDarkMode?Colors.white.withOpacity(0.7):Colors.black.withOpacity(0.7),
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_drop_down,
                                        size: 20,
                                        color: themeController.isDarkMode?Colors.white.withOpacity(0.7):Colors.black.withOpacity(0.7),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              showSearchBox: true,
                              items: jobBoardController.areas,
                              dropdownSearchDecoration: InputDecoration(
                                hintText: "Search area",
                                hintStyle: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.1,
                                  color: themeController.isDarkMode?Colors.white:Colors.black,
                                ),
                                border: InputBorder.none,
                              ),
                              onChanged: (value){
                                jobBoardController.selectedAreas = value;
                                jobBoardController.update();
                              },
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          width: scW/2.3,
                          margin: EdgeInsets.only(
                            top: 10,
                            left: 5,
                            right: 16,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: themeController.isDarkMode?Colors.white:Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Theme(
                            data: ThemeData(
                              textTheme: TextTheme(
                                bodyLarge: TextStyle(
                                  color: themeController.isDarkMode?Colors.white:Colors.black,
                                ),
                              ),
                              checkboxTheme: CheckboxThemeData(
                                fillColor: MaterialStateProperty.resolveWith ((Set  states) {
                                  return MateColors.appThemeDark;
                                }),
                              ),
                              elevatedButtonTheme: ElevatedButtonThemeData(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: themeController.isDarkMode?
                                  MateColors.appThemeDark:
                                  MateColors.appThemeLight,
                                ),
                              ),
                            ),
                            child: DropdownSearch<String>.multiSelection(
                              maxHeight: 300,
                              mode: Mode.BOTTOM_SHEET,
                              showSelectedItems: false,
                              popupBackgroundColor: themeController.isDarkMode?Color(0xFF2a3b4b).withOpacity(0.9):Color(0xFFe8f8f5),
                              dropdownButtonProps: IconButtonProps(
                                icon: Icon(Icons.keyboard_arrow_down_sharp,size: 0),
                                color: themeController.isDarkMode?MateColors.iconDark:MateColors.iconLight,
                              ),
                              searchFieldProps: TextFieldProps(
                                cursorColor: themeController.isDarkMode?Colors.white:Colors.black,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: themeController.isDarkMode?Colors.white:Colors.black,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: themeController.isDarkMode?Colors.white:Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              dropdownBuilder: (context,data){
                                return Padding(
                                  padding: const EdgeInsets.only(left: 16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Country/Region",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'Poppins',
                                          color: themeController.isDarkMode?Colors.white.withOpacity(0.7):Colors.black.withOpacity(0.7),
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_drop_down,
                                        size: 20,
                                        color: themeController.isDarkMode?Colors.white.withOpacity(0.7):Colors.black.withOpacity(0.7),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              showSearchBox: true,
                              items: jobBoardController.countryRegion,
                              dropdownSearchDecoration: InputDecoration(
                                hintText: "Search country/region",
                                hintStyle: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.1,
                                  color: themeController.isDarkMode?Colors.white:Colors.black,
                                ),
                                border: InputBorder.none,
                              ),
                              onChanged: (value){
                                jobBoardController.selectedCountryRegion = value;
                                jobBoardController.update();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 50,
                          width: scW/2.9,
                          margin: EdgeInsets.only(
                            top: 10,
                            left: 16,
                            right: 5,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: themeController.isDarkMode?Colors.white:Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Theme(
                            data: ThemeData(
                              textTheme: TextTheme(
                                bodyLarge: TextStyle(
                                  color: themeController.isDarkMode?Colors.white:Colors.black,
                                ),
                              ),
                              checkboxTheme: CheckboxThemeData(
                                fillColor: MaterialStateProperty.resolveWith ((Set  states) {
                                  return MateColors.appThemeDark;
                                }),
                              ),
                              elevatedButtonTheme: ElevatedButtonThemeData(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: themeController.isDarkMode?
                                  MateColors.appThemeDark:
                                  MateColors.appThemeLight,
                                ),
                              ),
                            ),
                            child: DropdownSearch<String>.multiSelection(
                              maxHeight: 500,
                              mode: Mode.BOTTOM_SHEET,
                              showSelectedItems: false,
                              popupBackgroundColor: themeController.isDarkMode?Color(0xFF2a3b4b).withOpacity(0.9):Color(0xFFe8f8f5),
                              dropdownButtonProps: IconButtonProps(
                                icon: Icon(Icons.keyboard_arrow_down_sharp,size: 0),
                                color: themeController.isDarkMode?MateColors.iconDark:MateColors.iconLight,
                              ),
                              searchFieldProps: TextFieldProps(
                                cursorColor: themeController.isDarkMode?Colors.white:Colors.black,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: themeController.isDarkMode?Colors.white:Colors.black,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: themeController.isDarkMode?Colors.white:Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              dropdownBuilder: (context,data){
                                return Padding(
                                  padding: const EdgeInsets.only(left: 16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("City",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'Poppins',
                                          color: themeController.isDarkMode?Colors.white.withOpacity(0.7):Colors.black.withOpacity(0.7),
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_drop_down,
                                        size: 20,
                                        color: themeController.isDarkMode?Colors.white.withOpacity(0.7):Colors.black.withOpacity(0.7),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              showSearchBox: true,
                              items: jobBoardController.city,
                              dropdownSearchDecoration: InputDecoration(
                                hintText: "Search city",
                                hintStyle: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.1,
                                  color: themeController.isDarkMode?Colors.white:Colors.black,
                                ),
                                border: InputBorder.none,
                              ),
                              onChanged: (value){
                                jobBoardController.selectedCity = value;
                                jobBoardController.update();
                              },
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          width: scW/2.3,
                          margin: EdgeInsets.only(
                            top: 10,
                            left: 5,
                            right: 16,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: themeController.isDarkMode?Colors.white:Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Theme(
                            data: ThemeData(
                              textTheme: TextTheme(
                                bodyLarge: TextStyle(
                                  color: themeController.isDarkMode?Colors.white:Colors.black,
                                ),
                              ),
                              checkboxTheme: CheckboxThemeData(
                                fillColor: MaterialStateProperty.resolveWith ((Set  states) {
                                  return MateColors.appThemeDark;
                                }),
                              ),
                              elevatedButtonTheme: ElevatedButtonThemeData(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: themeController.isDarkMode?
                                  MateColors.appThemeDark:
                                  MateColors.appThemeLight,
                                ),
                              ),
                            ),
                            child: DropdownSearch<String>.multiSelection(
                              maxHeight: 500,
                              mode: Mode.BOTTOM_SHEET,
                              showSelectedItems: false,
                              popupBackgroundColor: themeController.isDarkMode?Color(0xFF2a3b4b).withOpacity(0.9):Color(0xFFe8f8f5),
                              dropdownButtonProps: IconButtonProps(
                                icon: Icon(Icons.keyboard_arrow_down_sharp,size: 0),
                                color: themeController.isDarkMode?MateColors.iconDark:MateColors.iconLight,
                              ),
                              searchFieldProps: TextFieldProps(
                                cursorColor: themeController.isDarkMode?Colors.white:Colors.black,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: themeController.isDarkMode?Colors.white:Colors.black,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: themeController.isDarkMode?Colors.white:Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              dropdownBuilder: (context,data){
                                return Padding(
                                  padding: const EdgeInsets.only(left: 16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Organisation",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'Poppins',
                                          color: themeController.isDarkMode?Colors.white.withOpacity(0.7):Colors.black.withOpacity(0.7),
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_drop_down,
                                        size: 20,
                                        color: themeController.isDarkMode?Colors.white.withOpacity(0.7):Colors.black.withOpacity(0.7),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              showSearchBox: true,
                              items: jobBoardController.organisation,
                              dropdownSearchDecoration: InputDecoration(
                                hintText: "Search organisation",
                                hintStyle: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.1,
                                  color: themeController.isDarkMode?Colors.white:Colors.black,
                                ),
                                border: InputBorder.none,
                              ),
                              onChanged: (value){
                                jobBoardController.selectedOrganisation = value;
                                jobBoardController.update();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 50,
                          width: scW/2.9,
                          margin: EdgeInsets.only(
                            top: 10,
                            left: 16,
                            right: 5,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: themeController.isDarkMode?Colors.white:Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Theme(
                            data: ThemeData(
                              textTheme: TextTheme(
                                bodyLarge: TextStyle(
                                  color: themeController.isDarkMode?Colors.white:Colors.black,
                                ),
                              ),
                              checkboxTheme: CheckboxThemeData(
                                fillColor: MaterialStateProperty.resolveWith ((Set  states) {
                                  return MateColors.appThemeDark;
                                }),
                              ),
                              elevatedButtonTheme: ElevatedButtonThemeData(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: themeController.isDarkMode?
                                  MateColors.appThemeDark:
                                  MateColors.appThemeLight,
                                ),
                              ),
                            ),
                            child: DropdownSearch<String>.multiSelection(
                              maxHeight: 300,
                              mode: Mode.BOTTOM_SHEET,
                              showSelectedItems: false,
                              popupBackgroundColor: themeController.isDarkMode?Color(0xFF2a3b4b).withOpacity(0.9):Color(0xFFe8f8f5),
                              dropdownButtonProps: IconButtonProps(
                                icon: Icon(Icons.keyboard_arrow_down_sharp,size: 0),
                                color: themeController.isDarkMode?MateColors.iconDark:MateColors.iconLight,
                              ),
                              searchFieldProps: TextFieldProps(
                                cursorColor: themeController.isDarkMode?Colors.white:Colors.black,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: themeController.isDarkMode?Colors.white:Colors.black,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: themeController.isDarkMode?Colors.white:Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              dropdownBuilder: (context,data){
                                return Padding(
                                  padding: const EdgeInsets.only(left: 16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Experience",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontFamily: 'Poppins',
                                          color: themeController.isDarkMode?Colors.white.withOpacity(0.7):Colors.black.withOpacity(0.7),
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_drop_down,
                                        size: 20,
                                        color: themeController.isDarkMode?Colors.white.withOpacity(0.7):Colors.black.withOpacity(0.7),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              showSearchBox: true,
                              items: jobBoardController.experience,
                              dropdownSearchDecoration: InputDecoration(
                                hintText: "Search experience",
                                hintStyle: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.1,
                                  color: themeController.isDarkMode?Colors.white:Colors.black,
                                ),
                                border: InputBorder.none,
                              ),
                              onChanged: (value){
                                jobBoardController.selectedExperience = value;
                                jobBoardController.update();
                              },
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          width: scW/2.3,
                          margin: EdgeInsets.only(
                            top: 10,
                            left: 5,
                            right: 16,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: themeController.isDarkMode?Colors.white:Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Theme(
                            data: ThemeData(
                              textTheme: TextTheme(
                                bodyLarge: TextStyle(
                                  color: themeController.isDarkMode?Colors.white:Colors.black,
                                ),
                              ),
                              checkboxTheme: CheckboxThemeData(
                                fillColor: MaterialStateProperty.resolveWith ((Set  states) {
                                  return MateColors.appThemeDark;
                                }),
                              ),
                              elevatedButtonTheme: ElevatedButtonThemeData(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: themeController.isDarkMode?
                                  MateColors.appThemeDark:
                                  MateColors.appThemeLight,
                                ),
                              ),
                            ),
                            child: DropdownSearch<String>.multiSelection(
                              maxHeight: 200,
                              mode: Mode.BOTTOM_SHEET,
                              showSelectedItems: false,
                              popupBackgroundColor: themeController.isDarkMode?Color(0xFF2a3b4b).withOpacity(0.9):Color(0xFFe8f8f5),
                              dropdownButtonProps: IconButtonProps(
                                icon: Icon(Icons.keyboard_arrow_down_sharp,size: 0),
                                color: themeController.isDarkMode?MateColors.iconDark:MateColors.iconLight,
                              ),
                              searchFieldProps: TextFieldProps(
                                cursorColor: themeController.isDarkMode?Colors.white:Colors.black,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: themeController.isDarkMode?Colors.white:Colors.black,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: themeController.isDarkMode?Colors.white:Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              dropdownBuilder: (context,data){
                                return Padding(
                                  padding: const EdgeInsets.only(left: 16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Education",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'Poppins',
                                          color: themeController.isDarkMode?Colors.white.withOpacity(0.7):Colors.black.withOpacity(0.7),
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_drop_down,
                                        size: 20,
                                        color: themeController.isDarkMode?Colors.white.withOpacity(0.7):Colors.black.withOpacity(0.7),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              showSearchBox: true,
                              items: jobBoardController.education,
                              dropdownSearchDecoration: InputDecoration(
                                hintText: "Search education",
                                hintStyle: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.1,
                                  color: themeController.isDarkMode?Colors.white:Colors.black,
                                ),
                                border: InputBorder.none,
                              ),
                              onChanged: (value){
                                jobBoardController.selectedEducation = value;
                                jobBoardController.update();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 50,
                          width: scW/2.9,
                          margin: EdgeInsets.only(
                            top: 10,
                            left: 16,
                            right: 5,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: themeController.isDarkMode?Colors.white:Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Theme(
                            data: ThemeData(
                              textTheme: TextTheme(
                                bodyLarge: TextStyle(
                                  color: themeController.isDarkMode?Colors.white:Colors.black,
                                ),
                              ),
                              checkboxTheme: CheckboxThemeData(
                                fillColor: MaterialStateProperty.resolveWith ((Set  states) {
                                  return MateColors.appThemeDark;
                                }),
                              ),
                              elevatedButtonTheme: ElevatedButtonThemeData(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: themeController.isDarkMode?
                                  MateColors.appThemeDark:
                                  MateColors.appThemeLight,
                                ),
                              ),
                            ),
                            child: DropdownSearch<String>.multiSelection(
                              maxHeight: 500,
                              mode: Mode.BOTTOM_SHEET,
                              showSelectedItems: false,
                              popupBackgroundColor: themeController.isDarkMode?Color(0xFF2a3b4b).withOpacity(0.9):Color(0xFFe8f8f5),
                              dropdownButtonProps: IconButtonProps(
                                icon: Icon(Icons.keyboard_arrow_down_sharp,size: 0),
                                color: themeController.isDarkMode?MateColors.iconDark:MateColors.iconLight,
                              ),
                              searchFieldProps: TextFieldProps(
                                cursorColor: themeController.isDarkMode?Colors.white:Colors.black,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: themeController.isDarkMode?Colors.white:Colors.black,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: themeController.isDarkMode?Colors.white:Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              dropdownBuilder: (context,data){
                                return Padding(
                                  padding: const EdgeInsets.only(left: 16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Skill set",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'Poppins',
                                          color: themeController.isDarkMode?Colors.white.withOpacity(0.7):Colors.black.withOpacity(0.7),
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_drop_down,
                                        size: 20,
                                        color: themeController.isDarkMode?Colors.white.withOpacity(0.7):Colors.black.withOpacity(0.7),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              showSearchBox: true,
                              items: jobBoardController.skillSet,
                              dropdownSearchDecoration: InputDecoration(
                                hintText: "Search skill set",
                                hintStyle: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.1,
                                  color: themeController.isDarkMode?Colors.white:Colors.black,
                                ),
                                border: InputBorder.none,
                              ),
                              onChanged: (value){
                                jobBoardController.selectedSkillSet = value;
                                jobBoardController.update();
                              },
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          width: scW/2.3,
                          margin: EdgeInsets.only(
                            top: 10,
                            left: 5,
                            right: 16,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: themeController.isDarkMode?Colors.white:Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Theme(
                            data: ThemeData(
                              textTheme: TextTheme(
                                bodyLarge: TextStyle(
                                  color: themeController.isDarkMode?Colors.white:Colors.black,
                                ),
                              ),
                              checkboxTheme: CheckboxThemeData(
                                fillColor: MaterialStateProperty.resolveWith ((Set  states) {
                                  return MateColors.appThemeDark;
                                }),
                              ),
                              elevatedButtonTheme: ElevatedButtonThemeData(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: themeController.isDarkMode?
                                  MateColors.appThemeDark:
                                  MateColors.appThemeLight,
                                ),
                              ),
                            ),
                            child: DropdownSearch<String>.multiSelection(
                              maxHeight: 500,
                              mode: Mode.BOTTOM_SHEET,
                              showSelectedItems: false,
                              popupBackgroundColor: themeController.isDarkMode?Color(0xFF2a3b4b).withOpacity(0.9):Color(0xFFe8f8f5),
                              dropdownButtonProps: IconButtonProps(
                                icon: Icon(Icons.keyboard_arrow_down_sharp,size: 0),
                                color: themeController.isDarkMode?MateColors.iconDark:MateColors.iconLight,
                              ),
                              searchFieldProps: TextFieldProps(
                                cursorColor: themeController.isDarkMode?Colors.white:Colors.black,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: themeController.isDarkMode?Colors.white:Colors.black,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: themeController.isDarkMode?Colors.white:Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              dropdownBuilder: (context,data){
                                return Padding(
                                  padding: const EdgeInsets.only(left: 16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Role type",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'Poppins',
                                          color: themeController.isDarkMode?Colors.white.withOpacity(0.7):Colors.black.withOpacity(0.7),
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_drop_down,
                                        size: 20,
                                        color: themeController.isDarkMode?Colors.white.withOpacity(0.7):Colors.black.withOpacity(0.7),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              showSearchBox: true,
                              items: jobBoardController.roleType,
                              dropdownSearchDecoration: InputDecoration(
                                hintText: "Search role type",
                                hintStyle: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.1,
                                  color: themeController.isDarkMode?Colors.white:Colors.black,
                                ),
                                border: InputBorder.none,
                              ),
                              onChanged: (value){
                                jobBoardController.selectedRoleType = value;
                                jobBoardController.update();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      child: Wrap(
                        runSpacing: 10,
                        children: [
                          Visibility(
                            visible: jobBoardController.showClearButton,
                            child: InkWell(
                              onTap: (){
                                jobBoardController.clearAllFilter();
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10,right: 15),
                                child: Text(
                                  "Clear Filter",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w700,
                                    color: themeController.isDarkMode?
                                    MateColors.appThemeDark:
                                    MateColors.appThemeLight,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          for(int i=0;i<jobBoardController.selectedAreas.length;i++)...{
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: themeController.isDarkMode?
                                MateColors.containerDark:
                                MateColors.appThemeLight.withOpacity(0.2),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      jobBoardController.selectedAreas[i],
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 15,
                                        color: themeController.isDarkMode?Colors.white:Colors.black,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.clear,
                                        size: 15,
                                        color: themeController.isDarkMode?Colors.white:Colors.black,
                                      ),
                                      onPressed: (){
                                        jobBoardController.selectedAreas.removeAt(i);
                                        jobBoardController.update();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          },
                          for(int i=0;i<jobBoardController.selectedCountryRegion.length;i++)...{
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: themeController.isDarkMode?
                                MateColors.containerDark:
                                MateColors.appThemeLight.withOpacity(0.2),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      jobBoardController.selectedCountryRegion[i],
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 15,
                                        color: themeController.isDarkMode?Colors.white:Colors.black,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.clear,
                                        size: 15,
                                        color: themeController.isDarkMode?Colors.white:Colors.black,
                                      ),
                                      onPressed: (){
                                        jobBoardController.selectedCountryRegion.removeAt(i);
                                        jobBoardController.update();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          },
                          for(int i=0;i<jobBoardController.selectedCity.length;i++)...{
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: themeController.isDarkMode?
                                MateColors.containerDark:
                                MateColors.appThemeLight.withOpacity(0.2),
                              ),
                              child: Padding(
                                padding:const EdgeInsets.only(left: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      jobBoardController.selectedCity[i],
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 15,
                                        color: themeController.isDarkMode?Colors.white:Colors.black,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.clear,
                                        size: 15,
                                        color: themeController.isDarkMode?Colors.white:Colors.black,
                                      ),
                                      onPressed: (){
                                        jobBoardController.selectedCity.removeAt(i);
                                        jobBoardController.update();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          },
                          for(int i=0;i<jobBoardController.selectedOrganisation.length;i++)...{
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: themeController.isDarkMode?
                                MateColors.containerDark:
                                MateColors.appThemeLight.withOpacity(0.2),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      jobBoardController.selectedOrganisation[i],
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 15,
                                        color: themeController.isDarkMode?Colors.white:Colors.black,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.clear,
                                        size: 15,
                                        color: themeController.isDarkMode?Colors.white:Colors.black,
                                      ),
                                      onPressed: (){
                                        jobBoardController.selectedOrganisation.removeAt(i);
                                        jobBoardController.update();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          },
                          for(int i=0;i<jobBoardController.selectedExperience.length;i++)...{
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: themeController.isDarkMode?
                                MateColors.containerDark:
                                MateColors.appThemeLight.withOpacity(0.2),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      jobBoardController.selectedExperience[i],
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 15,
                                        color: themeController.isDarkMode?Colors.white:Colors.black,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.clear,
                                        size: 15,
                                        color: themeController.isDarkMode?Colors.white:Colors.black,
                                      ),
                                      onPressed: (){
                                        jobBoardController.selectedExperience.removeAt(i);
                                        jobBoardController.update();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          },
                          for(int i=0;i<jobBoardController.selectedEducation.length;i++)...{
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: themeController.isDarkMode?
                                MateColors.containerDark:
                                MateColors.appThemeLight.withOpacity(0.2),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      jobBoardController.selectedEducation[i],
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 15,
                                        color: themeController.isDarkMode?Colors.white:Colors.black,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.clear,
                                        size: 15,
                                        color: themeController.isDarkMode?Colors.white:Colors.black,
                                      ),
                                      onPressed: (){
                                        jobBoardController.selectedEducation.removeAt(i);
                                        jobBoardController.update();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          },
                          for(int i=0;i<jobBoardController.selectedSkillSet.length;i++)...{
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: themeController.isDarkMode?
                                MateColors.containerDark:
                                MateColors.appThemeLight.withOpacity(0.2),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      jobBoardController.selectedSkillSet[i],
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 15,
                                        color: themeController.isDarkMode?Colors.white:Colors.black,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.clear,
                                        size: 15,
                                        color: themeController.isDarkMode?Colors.white:Colors.black,
                                      ),
                                      onPressed: (){
                                        jobBoardController.selectedSkillSet.removeAt(i);
                                        jobBoardController.update();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          },
                          for(int i=0;i<jobBoardController.selectedRoleType.length;i++)...{
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: themeController.isDarkMode?
                                MateColors.containerDark:
                                MateColors.appThemeLight.withOpacity(0.2),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      jobBoardController.selectedRoleType[i],
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 15,
                                        color: themeController.isDarkMode?Colors.white:Colors.black,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.clear,
                                        size: 15,
                                        color: themeController.isDarkMode?Colors.white:Colors.black,
                                      ),
                                      onPressed: (){
                                        jobBoardController.selectedRoleType.removeAt(i);
                                        jobBoardController.update();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          },
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
