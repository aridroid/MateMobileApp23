import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mate_app/Providers/AuthUserProvider.dart';
import 'package:mate_app/Screen/Home/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:mate_app/Screen/Login/login_with_email.dart';
import 'package:provider/provider.dart';
import 'package:mate_app/asset/Colors/MateColors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Widget/loader.dart';
import '../../controller/theme_controller.dart';
import 'create_profile.dart';


class LoginMain extends StatefulWidget {
  static final String route = '/loginMain';

  @override
  _LoginMainState createState() => _LoginMainState();
}

class _LoginMainState extends State<LoginMain> {
  ThemeController themeController = Get.find<ThemeController>();
  SharedPreferences prefs;
  @override
  Widget build(BuildContext context) {
    final scH = MediaQuery.of(context).size.height;
    final scW = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Scaffold(
          body: Container(
            height: scH,
            width: scW,
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: scH*0.13),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(35.0),
                    child: Image.asset(
                      "lib/asset/icons/logoSquare.png",
                      height: 120,
                      width: 120,
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Text("Welcome back to",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                  ),
                ),
                Text("Mate-Your Virtual campus!",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: (){
                          Provider.of<AuthUserProvider>(context, listen: false).error = "";
                          Get.back();
                        },
                        child: Text(
                          "Don’t have an account? Sign Up",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: MateColors.activeIcons,
                          ),
                        ),
                      ),
                      SizedBox(height: 35,),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: scW*0.07),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: ()async{
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                Provider.of<AuthUserProvider>(context, listen: false).login().then((loginSuccess) {
                                  if(loginSuccess){
                                    prefs.setBool('login_app', true);
                                    Navigator.of(context).pushReplacementNamed(HomeScreen.homeScreenRoute);
                                  }
                                  // if (loginSuccess[0] == "success") {
                                  //   prefs.setBool('login_app', true);
                                  //   Navigator.of(context).pushReplacementNamed(HomeScreen.homeScreenRoute);
                                  // }else if(loginSuccess[0] == "updateProfile"){
                                  //   //Get.to(CreateProfile(loginSuccess[1]??"", loginSuccess[2]??"", loginSuccess[3]??""));
                                  //   Fluttertoast.showToast(msg: "Please update profile first", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
                                  // }
                                });
                              },

                              child: Container(
                                height: 56,
                                width: 147,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(28),
                                  color: themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightButtonBackground,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset("lib/asset/glogo.png",width: 20,),
                                    SizedBox(width: 5,),
                                    Text("Google",
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                        color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: 56,
                              width: 147,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(28),
                                color: themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightButtonBackground,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset("lib/asset/appleLogo.png",width: 20,
                                    color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                                  ),
                                  SizedBox(width: 5,),
                                  Text("Apple",
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                      color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 56,
                        margin: EdgeInsets.only(top: 15,left: 16,right: 16,bottom: 20),
                        width: scW,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: MateColors.activeIcons,
                            onPrimary: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                          ),
                          onPressed: (){
                            Navigator.of(context).pushNamed(LoginWithEmail.routeName);
                          },
                          child: Text("Log In with Email",
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
                ),
                _signInError(),
              ],
            ),
          ),
        ),
        Visibility(
          visible: Provider.of<AuthUserProvider>(context, listen: true).loggingInLoaderStatus,
          child: Loader(),
        ),
      ],
    );
  }

  Widget _signInError() {
    return Selector<AuthUserProvider, String>(
      selector: (ctx, authUserProvider) => authUserProvider.error,
      builder: (ctx, error, _) {
        if (error.length > 0) {
          return Container(
            color: Colors.red,
            margin: EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "$error",
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }

}
