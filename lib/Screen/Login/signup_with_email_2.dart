import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mate_app/Services/AuthUserService.dart';
import 'package:mate_app/Widget/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../asset/Colors/MateColors.dart';
import '../../constant.dart';
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
  bool is18 = false;

  @override
  Widget build(BuildContext context) {
    final scH = MediaQuery.of(context).size.height;
    final scW = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        GestureDetector(
           behavior: HitTestBehavior.translucent,
          onTap: null,
          onPanUpdate: (details) {
            if (details.delta.dy > 0){
              FocusScope.of(context).requestFocus(FocusNode());
              print("Dragging in +Y direction");
            }
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
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
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          top: scH*0.08,
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
                      SizedBox(height: 20,),
                      Center(
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            fontSize: 30,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            color: themeController.isDarkMode?Colors.white:Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 30,),
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.text,
                        autofocus: false,
                        maxLines: 1,
                        cursorColor: themeController.isDarkMode?MateColors.helpingTextDark:MateColors.helpingTextLight,
                        style:  TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.1,
                          color: themeController.isDarkMode?Colors.white:Colors.black,
                        ),
                        validator: validateEmail,
                        decoration: InputDecoration(
                          hintStyle: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            color: themeController.isDarkMode?MateColors.helpingTextDark:MateColors.helpingTextLight,
                          ),
                          hintText: "Your email",
                          fillColor: themeController.isDarkMode ? MateColors.containerDark : MateColors.containerLight,
                          filled: true,
                          focusedBorder: commonBorder,
                          enabledBorder: commonBorder,
                          disabledBorder: commonBorder,
                          errorBorder: commonBorder,
                          focusedErrorBorder: commonBorder,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 2,top: 12),
                        child: Text(
                          "If you are student, your email must be located on .edu domain.",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Poppins',
                            letterSpacing: 0.1,
                            color: themeController.isDarkMode?Colors.white:Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 15,),
                      TextFormField(
                        controller: passwordController,
                        keyboardType: TextInputType.text,
                        autofocus: false,
                        maxLines: 1,
                        cursorColor: themeController.isDarkMode?MateColors.helpingTextDark:MateColors.helpingTextLight,
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
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            color: themeController.isDarkMode?MateColors.helpingTextDark:MateColors.helpingTextLight,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              indicator ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                              color: themeController.isDarkMode?MateColors.helpingTextDark:MateColors.helpingTextLight,
                            ),
                            onPressed: () {
                              setState(() {
                                indicator = !indicator;
                              });
                            },
                          ),
                          hintText: "Password",
                          fillColor: themeController.isDarkMode ? MateColors.containerDark : MateColors.containerLight,
                          filled: true,
                          focusedBorder: commonBorder,
                          enabledBorder: commonBorder,
                          disabledBorder: commonBorder,
                          errorBorder: commonBorder,
                          focusedErrorBorder: commonBorder,
                        ),
                      ),
                      SizedBox(height: 5,),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          width: 160,
                          child: CheckboxListTile(
                            dense: true,
                            side: BorderSide(color: themeController.isDarkMode?Colors.white:Colors.black),
                            activeColor: MateColors.activeIcons,
                            checkColor: Colors.black,
                            contentPadding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                            title: Text(
                              "Are you 17+ ?",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Poppins',
                                color: themeController.isDarkMode?Colors.white: Colors.black,
                              ),
                            ),
                            value: is18,
                            onChanged: (newValue) {
                              is18=newValue;
                              setState(() {});
                            },
                            controlAffinity: ListTileControlAffinity.trailing,
                          ),
                        ),
                      ),
                      Container(
                        height: 60,
                        width: scW,
                        margin: EdgeInsets.only(top: 30,),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            primary: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                            onPrimary: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          onPressed: ()async{
                            SharedPreferences preferences = await SharedPreferences.getInstance();
                            bool val = preferences.getBool('signupEula')??false;
                            if(val==false){
                              showEulaPopup(context,"signup");
                            }else{
                              if(formKey.currentState.validate()){
                                if(is18){
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
                                }else{
                                  Fluttertoast.showToast(msg: "Please agree that you are 17+", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
                                }
                              }
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Continue",
                                style: TextStyle(
                                  color: MateColors.blackTextColor,
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
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
