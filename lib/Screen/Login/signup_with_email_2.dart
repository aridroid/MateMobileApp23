import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mate_app/Services/AuthUserService.dart';
import 'package:mate_app/Widget/loader.dart';

import '../../asset/Colors/MateColors.dart';
import '../../controller/signup_controller.dart';
import '../../controller/theme_controller.dart';
import 'create_profile.dart';

class SignupWithEmail2 extends StatefulWidget {
  static final String routeName = '/signupWithEmail2';

  @override
  _SignupWithEmail2State createState() => _SignupWithEmail2State();
}

class _SignupWithEmail2State extends State<SignupWithEmail2> {
  SignupController signupController = Get.find<SignupController>();
  ThemeController themeController = Get.find<ThemeController>();
  bool isLoadingSignup = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool indicator = true;
  final formKey = GlobalKey<FormState>();
  AuthUserService authUserService = AuthUserService();


  @override
  Widget build(BuildContext context) {
    final scH = MediaQuery.of(context).size.height;
    final scW = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Scaffold(
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
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30,),
                  Padding(
                    padding: const EdgeInsets.only(left: 2),
                    child: Text(
                      "Email",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.1,
                        color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.text,
                    autofocus: false,
                    maxLines: 1,
                    style:  TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.1,
                      color: themeController.isDarkMode?Colors.white:Colors.black,
                    ),
                    validator: validateEmail,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.1,
                        color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
                      ),
                      hintText: "Your email",
                      fillColor: themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightButtonBackground,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderSide:  BorderSide(
                          color: themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightButtonBackground,
                        ),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:  BorderSide(
                          color:  themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightButtonBackground,
                        ),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide:  BorderSide(
                          color: themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightButtonBackground,
                        ),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide:  BorderSide(
                          color:  themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightButtonBackground,
                        ),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide:  BorderSide(
                          color: themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightButtonBackground,
                        ),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 2,top: 12),
                    child: Text(
                      "If you are student, your email must be located on .edu domain.",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.1,
                        color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 2,top: 30),
                    child: Text(
                      "Password",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.1,
                        color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    controller: passwordController,
                    keyboardType: TextInputType.text,
                    autofocus: false,
                    maxLines: 1,
                    style:  TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.1,
                      color: themeController.isDarkMode?Colors.white:Colors.black,
                    ),
                    validator: validatePassword,
                    obscureText: indicator,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.1,
                        color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          indicator ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
                        ),
                        onPressed: () {
                          setState(() {
                            indicator = !indicator;
                          });
                        },
                      ),
                      hintText: "Password",
                      fillColor: themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightButtonBackground,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderSide:  BorderSide(
                          color: themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightButtonBackground,
                        ),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:  BorderSide(
                          color:  themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightButtonBackground,
                        ),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide:  BorderSide(
                          color: themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightButtonBackground,
                        ),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide:  BorderSide(
                          color: themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightButtonBackground,
                        ),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide:  BorderSide(
                          color: themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightButtonBackground,
                        ),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 56,
                        margin: EdgeInsets.only(top: 50,left: scW*0.25,right: scW*0.25,bottom: 15),
                        width: 160,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: MateColors.activeIcons,
                            onPrimary: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                          ),
                          onPressed: ()async{
                            if(formKey.currentState.validate()){
                              setState(() {
                                isLoadingSignup = true;
                              });
                              String response = await authUserService.signupWithEmail(
                                email: emailController.text,
                                password: passwordController.text,
                                category: signupController.category,
                              );
                              if(response=="User created successfully"){
                                setState(() {
                                  isLoadingSignup = false;
                                });
                                Get.to(CreateProfile(fullName: "",photoUrl: "",coverPhotoUrl: "",email: emailController.text,password: passwordController.text,));
                              }else if(response == "The email has already been taken."){
                                setState(() {
                                  isLoadingSignup = false;
                                });
                                Fluttertoast.showToast(msg: "The email has already been taken", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
                              }else{
                                setState(() {
                                  isLoadingSignup = false;
                                });
                                Fluttertoast.showToast(msg: "Something went wrong", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
                              }
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
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Visibility(
          visible: isLoadingSignup,
          child: Loader(),
        ),
      ],
    );
  }
  String validateEmail(String value) {
    if (value.isEmpty) {
      return "Email Is Required";
    } else if (!GetUtils.isEmail(value)) {
      return "Invalid Email Id";
    } else {
      return null;
    }
  }

  String validatePassword(String value) {
    if(value.isEmpty){
      return "Password is Required";
    }else if(value.length <6){
      return "Password must contain minimum six digit";
    }
    return null;
  }
}
