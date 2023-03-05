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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(
                top: scH*0.08,
                left: 20,
              ),
              width: 20,
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios,
                  size: 20,
                  color: themeController.isDarkMode ? Colors.white : MateColors.blackText,
                ),
                onPressed: (){
                  Get.back();
                },
              ),
            ),
            Expanded(
              child: ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20),
                children: [
                  SizedBox(height: 16,),
                  Center(
                    child: Text(
                      "Who are you?",
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        color: themeController.isDarkMode?Colors.white:Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 30,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: (){
                          setState(() {
                            selected = 1;
                          });
                        },
                        child: Container(
                          height: scH*0.18,
                          width: scW/2.35,
                          decoration: BoxDecoration(
                            color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              width: selected==1?2:0,
                              color: selected==1?themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight:
                              themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("lib/asset/iconsNewDesign/student.png",
                                color: themeController.isDarkMode?Colors.white:Colors.black,
                                height: 41,
                                width: 38,
                              ),
                              SizedBox(
                                height: scH*0.025,
                              ),
                              Text("Student",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Poppins',
                                  color: themeController.isDarkMode?Colors.white:Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          setState(() {
                            selected = 2;
                          });
                        },
                        child: Container(
                          height: scH*0.18,
                          width: scW/2.35,
                          decoration: BoxDecoration(
                            color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              width: selected==2?2:0,
                              color: selected==2?themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight:
                              themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("lib/asset/iconsNewDesign/organization.png",
                                color: themeController.isDarkMode?Colors.white:Colors.black,
                                height: 41,
                                width: 38,
                              ),
                              SizedBox(
                                height: scH*0.025,
                              ),
                              Text("Student organization",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Poppins',
                                  color: themeController.isDarkMode?Colors.white:Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: (){
                          setState(() {
                            selected = 3;
                          });
                        },
                        child: Container(
                          height: scH*0.18,
                          width: scW/2.35,
                          decoration: BoxDecoration(
                            color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              width: selected==3?2:0,
                              color: selected==3?themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight:
                              themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("lib/asset/iconsNewDesign/university.png",
                                color: themeController.isDarkMode?Colors.white:Colors.black,
                                height: 41,
                                width: 38,
                              ),
                              SizedBox(
                                height: scH*0.025,
                              ),
                              Text("University department",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Poppins',
                                  color: themeController.isDarkMode?Colors.white:Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          setState(() {
                            selected = 4;
                          });
                        },
                        child: Container(
                          height: scH*0.18,
                          width: scW/2.35,
                          decoration: BoxDecoration(
                            color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              width: selected==4?2:0,
                              color: selected==4?themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight:
                              themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("lib/asset/iconsNewDesign/bussiness.png",
                                color: themeController.isDarkMode?Colors.white:Colors.black,
                                height: 41,
                                width: 38,
                              ),
                              SizedBox(
                                height: scH*0.025,
                              ),
                              Text("Business",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Poppins',
                                  color: themeController.isDarkMode?Colors.white:Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: (){
                          setState(() {
                            selected = 5;
                          });
                        },
                        child: Container(
                          height: scH*0.18,
                          width: scW/2.35,
                          decoration: BoxDecoration(
                            color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              width: selected==5?2:0,
                              color: selected==5?themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight:
                              themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("lib/asset/iconsNewDesign/recuiter.png",
                                color: themeController.isDarkMode?Colors.white:Colors.black,
                                height: 41,
                                width: 38,
                              ),
                              SizedBox(
                                height: scH*0.025,
                              ),
                              Text("Recruiter",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Poppins',
                                  color: themeController.isDarkMode?Colors.white:Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          setState(() {
                            selected = 6;
                          });
                        },
                        child: Container(
                          height: scH*0.18,
                          width: scW/2.35,
                          decoration: BoxDecoration(
                            color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              width: selected==6?2:0,
                              color: selected==6?themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight:
                              themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("lib/asset/iconsNewDesign/others.png",
                                color: themeController.isDarkMode?Colors.white:Colors.black,
                                height: 41,
                                width: 38,
                              ),
                              SizedBox(
                                height: scH*0.025,
                              ),
                              Text("Other",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Poppins',
                                  color: themeController.isDarkMode?Colors.white:Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 60,
                    width: scW,
                    margin: EdgeInsets.only(top: 30,),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        primary: selected!=0?
                        themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight:
                        themeController.isDarkMode?MateColors.disableButtonColor:MateColors.whiteText,
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Continue",
                            style: TextStyle(
                              color: selected!=0? MateColors.blackTextColor:
                              MateColors.greyButtonText,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Poppins",
                              fontSize: 18.0,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Image.asset('lib/asset/iconsNewDesign/arrowRight.png',
                            width: 20,
                            color: selected!=0? MateColors.blackTextColor:
                            MateColors.greyButtonText,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
