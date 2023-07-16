import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mate_app/Providers/AuthUserProvider.dart';
import 'package:mate_app/Screen/Login/create_profile.dart';
import 'package:mate_app/Widget/loader.dart';
import 'package:mate_app/constant.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Services/AuthUserService.dart';
import '../../asset/Colors/MateColors.dart';
import '../../controller/theme_controller.dart';
import '../Home/HomeScreen.dart';


class LoginWithEmail extends StatefulWidget {
  static final String routeName = '/loginWithEmail';

  @override
  _LoginWithEmailState createState() => _LoginWithEmailState();
}

class _LoginWithEmailState extends State<LoginWithEmail> {
  ThemeController themeController = Get.find<ThemeController>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool indicator = true;
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  AuthUserService authUserService = AuthUserService();
  late FirebaseMessaging _firebaseMessaging;

  @override
  void initState() {
    _firebaseMessaging = FirebaseMessaging.instance;
    _firebaseMessaging.requestPermission();
    super.initState();
  }

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
                          "Login",
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
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            if(formKey.currentState!.validate()){
                              setState(() {
                                isLoading = true;
                              });
                              String? deviceId = await _firebaseMessaging.getToken();
                              print(deviceId);
                              dynamic response = await authUserService.signInWithEmail(
                                email: emailController.text,
                                password: passwordController.text,
                                deviceId: deviceId!,
                              );
                             if(response == "Invalid user credentials."){
                                setState(() {
                                  isLoading = false;
                                });
                                Fluttertoast.showToast(msg: "Invalid user credentials", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
                              }else if(response == "User is de-activated."){
                               setState(() {
                                 isLoading = false;
                               });
                               Fluttertoast.showToast(msg: "Your account is deleted", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
                             }
                             else if(response !="result"){
                                setState(() {
                                  isLoading = false;
                                });
                                if(response.universityId!=null){
                                  prefs.setBool('login_app', true);
                                  Provider.of<AuthUserProvider>(context,listen: false).authUser = response;
                                  Navigator.of(context).pushNamedAndRemoveUntil(HomeScreen.homeScreenRoute, (route) => false);
                                }else{
                                  var prefs = await SharedPreferences.getInstance();
                                  prefs.remove('googleToken');
                                  prefs.remove('authUser');
                                  Get.to(CreateProfile(photoUrl: response.photoUrl??"",coverPhotoUrl: response.coverPhotoUrl??"",fullName: response.displayName??"",email: emailController.text,password: passwordController.text,));
                                  Fluttertoast.showToast(msg: "Please update profile first", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
                                }
                              }else{
                                setState(() {
                                  isLoading = false;
                                });
                                Fluttertoast.showToast(msg: "Something went wrong", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
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
          visible: isLoading,
          child: Loader(),
        ),
      ],
    );
  }
  String? validateEmail(String? value) {
    if (value!.isEmpty) {
      return "Email Is Required";
    } else if (!GetUtils.isEmail(value)) {
      return "Invalid Email Id";
    } else {
      return null;
    }
  }

  String? validatePassword(String? value) {
    if(value!.isEmpty){
      return "Password is Required";
    }else if(value.length <6){
      return "Password must contain minimum six digit";
    }
    return null;
  }
}
