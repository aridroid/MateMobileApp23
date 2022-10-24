import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mate_app/Screen/Login/signup_with_email_2.dart';
import 'package:mate_app/controller/signup_controller.dart';

import '../../asset/Colors/MateColors.dart';
import '../../controller/theme_controller.dart';


class SignupWithEmail extends StatefulWidget {
  static final String routeName = '/signupWithEmail';

  @override
  _SignupWithEmailState createState() => _SignupWithEmailState();
}

class _SignupWithEmailState extends State<SignupWithEmail> {
  SignupController signupController = Get.put(SignupController());
  ThemeController themeController = Get.find<ThemeController>();
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    final scH = MediaQuery.of(context).size.height;
    final scW = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: MateColors.activeIcons,
        ),
        title: Text(
          "Sign Up",
          style: TextStyle(
            color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
            fontWeight: FontWeight.w700,
            fontSize: 17.0,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20),
        children: [
          SizedBox(height: 30,),
          Text(
            "Who are you?",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.1,
              color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
            ),
          ),
          SizedBox(height: 30,),
          GestureDetector(
            onTap: (){
              setState(() {
                selected = 1;
              });
            },
            child: Container(
              height: 64,
              width: scW,
              decoration: BoxDecoration(
                color: selected==1? MateColors.activeIcons:themeController.isDarkMode?MateColors.drawerTileColor:Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: ListTile(
                  horizontalTitleGap: 13,
                  leading: Container(
                    height: 32,
                    width: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: themeController.isDarkMode?MateColors.drawerTileColor:Colors.white,
                      border: Border.all(
                        width: 2,
                        color: themeController.isDarkMode?MateColors.darkDivider:
                        selected==1? Colors.white: MateColors.lightDivider,
                      ),
                    ),
                    child: Center(
                      child: selected==1?Icon(Icons.check,color: MateColors.activeIcons,):Offstage(),
                    ),
                  ),
                  title: Text("Student",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.1,
                      color:
                      themeController.isDarkMode?
                      selected==1?MateColors.blackTextColor:Colors.white:
                      selected==1?
                      Colors.white:MateColors.blackTextColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20,),
          GestureDetector(
            onTap: (){
              setState(() {
                selected = 2;
              });
            },
            child: Container(
              height: 64,
              width: scW,
              decoration: BoxDecoration(
                color: selected==2? MateColors.activeIcons:themeController.isDarkMode?MateColors.drawerTileColor:Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: ListTile(
                  horizontalTitleGap: 13,
                  leading: Container(
                    height: 32,
                    width: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: themeController.isDarkMode?MateColors.drawerTileColor:Colors.white,
                      border: Border.all(
                        width: 2,
                        color: themeController.isDarkMode?MateColors.darkDivider:
                        selected==2? Colors.white: MateColors.lightDivider,
                      ),
                    ),
                    child: Center(
                      child: selected==2?Icon(Icons.check,color: MateColors.activeIcons,):Offstage(),
                    ),
                  ),
                  title: Text("Student organization",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.1,
                      color:
                      themeController.isDarkMode?
                      selected==2?MateColors.blackTextColor:Colors.white:
                      selected==2?
                      Colors.white:MateColors.blackTextColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20,),
          GestureDetector(
            onTap: (){
              setState(() {
                selected = 3;
              });
            },
            child: Container(
              height: 64,
              width: scW,
              decoration: BoxDecoration(
                color: selected==3? MateColors.activeIcons:themeController.isDarkMode?MateColors.drawerTileColor:Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: ListTile(
                  horizontalTitleGap: 13,
                  leading: Container(
                    height: 32,
                    width: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: themeController.isDarkMode?MateColors.drawerTileColor:Colors.white,
                      border: Border.all(
                        width: 2,
                        color: themeController.isDarkMode?MateColors.darkDivider:
                        selected==3? Colors.white: MateColors.lightDivider,
                      ),
                    ),
                    child: Center(
                      child: selected==3?Icon(Icons.check,color: MateColors.activeIcons,):Offstage(),
                    ),
                  ),
                  title: Text("University department",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.1,
                      color:
                      themeController.isDarkMode?
                      selected==3?MateColors.blackTextColor:Colors.white:
                      selected==3?
                      Colors.white:MateColors.blackTextColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20,),
          GestureDetector(
            onTap: (){
              setState(() {
                selected = 4;
              });
            },
            child: Container(
              height: 64,
              width: scW,
              decoration: BoxDecoration(
                color:  selected==4? MateColors.activeIcons:themeController.isDarkMode?MateColors.drawerTileColor:Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: ListTile(
                  horizontalTitleGap: 13,
                  leading: Container(
                    height: 32,
                    width: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: themeController.isDarkMode?MateColors.drawerTileColor:Colors.white,
                      border: Border.all(
                        width: 2,
                        color: themeController.isDarkMode?MateColors.darkDivider:
                        selected==4? Colors.white: MateColors.lightDivider,
                      ),
                    ),
                    child: Center(
                      child: selected==4?Icon(Icons.check,color: MateColors.activeIcons,):Offstage(),
                    ),
                  ),
                  title: Text("Business",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.1,
                      color:
                      themeController.isDarkMode?
                      selected==4?MateColors.blackTextColor:Colors.white:
                      selected==4?
                      Colors.white:MateColors.blackTextColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20,),
          GestureDetector(
            onTap: (){
              setState(() {
                selected = 5;
              });
            },
            child: Container(
              height: 64,
              width: scW,
              decoration: BoxDecoration(
                color:  selected==5? MateColors.activeIcons:themeController.isDarkMode?MateColors.drawerTileColor:Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: ListTile(
                  horizontalTitleGap: 13,
                  leading: Container(
                    height: 32,
                    width: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: themeController.isDarkMode?MateColors.drawerTileColor:Colors.white,
                      border: Border.all(
                        width: 2,
                        color: themeController.isDarkMode?MateColors.darkDivider:
                        selected==5? Colors.white: MateColors.lightDivider,
                      ),
                    ),
                    child: Center(
                      child: selected==5?Icon(Icons.check,color: MateColors.activeIcons,):Offstage(),
                    ),
                  ),
                  title: Text("Recruiter",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.1,
                      color:
                      themeController.isDarkMode?
                      selected==5?MateColors.blackTextColor:Colors.white:
                      selected==5?
                      Colors.white:MateColors.blackTextColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20,),
          GestureDetector(
            onTap: (){
              setState(() {
                selected = 6;
              });
            },
            child: Container(
              height: 64,
              width: scW,
              decoration: BoxDecoration(
                color: selected==6? MateColors.activeIcons:themeController.isDarkMode?MateColors.drawerTileColor:Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: ListTile(
                  horizontalTitleGap: 13,
                  leading: Container(
                    height: 32,
                    width: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: themeController.isDarkMode?MateColors.drawerTileColor:Colors.white,
                      border: Border.all(
                        width: 2,
                        color: themeController.isDarkMode?MateColors.darkDivider:
                        selected==6? Colors.white: MateColors.lightDivider,
                      ),
                    ),
                    child: Center(
                      child: selected==6?Icon(Icons.check,color: MateColors.activeIcons,):Offstage(),
                    ),
                  ),
                  title: Text("Other",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.1,
                      color:
                      themeController.isDarkMode?
                      selected==6?MateColors.blackTextColor:Colors.white:
                      selected==6?
                      Colors.white:MateColors.blackTextColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 56,
            margin: EdgeInsets.only(top: 50,left: scW*0.25,right: scW*0.25),
            width: 160,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: MateColors.activeIcons,
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
              ),
              onPressed: (){
                if(selected==0){
                  Fluttertoast.showToast(msg: "Please Select One Option", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
                }else{
                  if(selected == 1){
                    signupController.category = "Student";
                  }else if(selected == 2){
                    signupController.category = "Student Organization";
                  }else if(selected == 3){
                    signupController.category = "University Organization";
                  }else if(selected == 4){
                    signupController.category = "Business";
                  }else if(selected == 5){
                    signupController.category = "Recruiter";
                  }else if(selected == 6){
                    signupController.category = "Others";
                  }
                  print(signupController.category);
                  Navigator.of(context).pushNamed(SignupWithEmail2.routeName);
                }
              },
              child: Text("Continue",
                style: TextStyle(
                  color: themeController.isDarkMode?MateColors.blackTextColor:Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 17.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
