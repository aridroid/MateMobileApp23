import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mate_app/Providers/AuthUserProvider.dart';
import 'package:mate_app/Screen/Login/create_profile.dart';
import 'package:mate_app/Widget/loader.dart';
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
  FirebaseMessaging _firebaseMessaging;
  ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if(_scrollController.position.userScrollDirection == ScrollDirection.forward){
        print('--------');
      }
    });
    // _firebaseMessaging = FirebaseMessaging();
    // _firebaseMessaging.requestNotificationPermissions();
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
            appBar: AppBar(
              elevation: 0,
              iconTheme: IconThemeData(
                color: MateColors.activeIcons,
              ),
              title: Text(
                "Login",
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
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              if(formKey.currentState.validate()){
                                setState(() {
                                  isLoading = true;
                                });
                                String deviceId = await _firebaseMessaging.getToken();
                                print(deviceId);
                                dynamic response = await authUserService.signInWithEmail(
                                  email: emailController.text,
                                  password: passwordController.text,
                                  deviceId: deviceId,
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
        ),
        Visibility(
          visible: isLoading,
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
