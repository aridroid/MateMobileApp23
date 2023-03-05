import 'package:get/get.dart';
import 'package:mate_app/Providers/AuthUserProvider.dart';
import 'package:mate_app/Screen/Home/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:mate_app/Screen/Login/signup_with_email.dart';
import 'package:mate_app/Screen/Profile/updateProfile.dart';
import 'package:mate_app/Widget/loader.dart';
import 'package:provider/provider.dart';
import 'package:mate_app/asset/Colors/MateColors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controller/theme_controller.dart';
import 'login_with_email.dart';

class GoogleLogin extends StatefulWidget {
  static final String loginScreenRoute = '/login';
  @override
  _GoogleLoginState createState() => _GoogleLoginState();
}

class _GoogleLoginState extends State<GoogleLogin> {
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
            decoration: BoxDecoration(
              color: themeController.isDarkMode?Color(0xFF000000):Colors.white,
              image: DecorationImage(
                image: AssetImage(themeController.isDarkMode?'lib/asset/Background.png':'lib/asset/BackgroundLight.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: scH*0.3,
                ),
                SizedBox(
                  width: scW,
                  height: scH*0.7,
                  child: Stack(
                    children: [
                      Positioned(
                        top: scH*0.075,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: scH*0.55,
                          margin: EdgeInsets.only(left: scW*0.035,right: scW*0.035,bottom: scH*0.06),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            image: DecorationImage(
                              image: AssetImage(themeController.isDarkMode?'lib/asset/Rectangle.png':'lib/asset/RectangleLight.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              SizedBox(height: scH*0.1,),
                              Text("Unlock Your Potential",
                                style: TextStyle(
                                  fontSize: 27,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  color: themeController.isDarkMode?Colors.white:Colors.black,
                                ),
                              ),
                              SizedBox(height: scH*0.005,),
                              Text("with Mate - Your Virtual Campus!",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 15,
                                  letterSpacing: 0.5,
                                  color: themeController.isDarkMode?Colors.white.withOpacity(0.6):Colors.black.withOpacity(0.6),
                                ),
                              ),
                              SizedBox(height: scH*0.06,),
                              GestureDetector(
                                onTap: (){
                                  Navigator.of(context).pushNamed(SignupWithEmail.routeName);
                                },
                                child: Container(
                                  height: 56,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.symmetric(horizontal: scW*0.05),
                                  width: scW,
                                  decoration: BoxDecoration(
                                    color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Text("Join our community",
                                    style: TextStyle(
                                      color: themeController.isDarkMode?Colors.white:Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Poppins',
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: scW*0.05,vertical: scH*0.04),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: ()async{
                                        SharedPreferences prefs = await SharedPreferences.getInstance();
                                        Provider.of<AuthUserProvider>(context, listen: false).login().then((loginSuccess) {
                                          if(loginSuccess){
                                            prefs.setBool('login_app', true);
                                            if(Provider.of<AuthUserProvider>(context, listen: false).authUser.universityId==null){
                                              Get.off(UpdateProfile(
                                                fullName: Provider.of<AuthUserProvider>(context, listen: false).authUser.displayName,
                                                about: "",
                                                uuid: Provider.of<AuthUserProvider>(context, listen: false).authUser.id,
                                                universityId: Provider.of<AuthUserProvider>(context, listen: false).authUser.universityId,
                                                photoUrl: Provider.of<AuthUserProvider>(context, listen: false).authUser.photoUrl,
                                                coverPhotoUrl: Provider.of<AuthUserProvider>(context, listen: false).authUser.coverPhotoUrl,
                                                isGoToHome: true,
                                              ));
                                            }else{
                                              Navigator.of(context).pushReplacementNamed(HomeScreen.homeScreenRoute);
                                            }
                                          }
                                        });
                                      },
                                      child: Container(
                                        height: 56,
                                        width: MediaQuery.of(context).size.width/1.21,
                                        decoration: BoxDecoration(
                                          color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                                          borderRadius: BorderRadius.circular(14),
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
                                                color: themeController.isDarkMode?Colors.white:Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // Container(
                                    //   height: 56,
                                    //   width: 147,
                                    //   decoration: BoxDecoration(
                                    //     borderRadius: BorderRadius.circular(28),
                                    //     color: themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightButtonBackground,
                                    //   ),
                                    //   child: Row(
                                    //     mainAxisAlignment: MainAxisAlignment.center,
                                    //     children: [
                                    //       Image.asset("lib/asset/appleLogo.png",width: 20,
                                    //         color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                                    //       ),
                                    //       SizedBox(width: 5,),
                                    //       Text("Apple",
                                    //         style: TextStyle(
                                    //           fontSize: 17,
                                    //           fontWeight: FontWeight.w700,
                                    //           color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                                    //         ),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: (){
                                  Provider.of<AuthUserProvider>(context, listen: false).error = "";
                                  Navigator.of(context).pushNamed(LoginWithEmail.routeName);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Already have an account? ",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                        color: themeController.isDarkMode?MateColors.containerLight:Colors.black,
                                      ),
                                    ),
                                    Text(
                                      "Log In",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                        color: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: scW/3,
                        child: Image.asset(
                          "lib/asset/activeLogo.png",
                          height: 131,
                          width: 131,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        _signInError(),
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
          return Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.red,
              margin: EdgeInsets.symmetric(horizontal: 16,vertical: 16),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "$error",
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }

}


// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// import 'package:mate_app/Providers/AuthUserProvider.dart';
// import 'package:mate_app/Screen/Home/HomeScreen.dart';
// import 'package:flutter/material.dart';
// import 'package:mate_app/Screen/Login/login.dart';
// import 'package:mate_app/Screen/Login/signup_with_email.dart';
// import 'package:mate_app/Screen/Profile/updateProfile.dart';
// import 'package:mate_app/Widget/loader.dart';
// import 'package:provider/provider.dart';
// import 'package:mate_app/asset/Colors/MateColors.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../controller/theme_controller.dart';
// import 'create_profile.dart';
// import 'login_with_email.dart';
//
// class GoogleLogin extends StatefulWidget {
//   static final String loginScreenRoute = '/login';
//   @override
//   _GoogleLoginState createState() => _GoogleLoginState();
// }
//
// class _GoogleLoginState extends State<GoogleLogin> {
//   ThemeController themeController = Get.find<ThemeController>();
//   SharedPreferences prefs;
//
//   @override
//   Widget build(BuildContext context) {
//     final scH = MediaQuery.of(context).size.height;
//     final scW = MediaQuery.of(context).size.width;
//     return Stack(
//       children: [
//         Scaffold(
//           body: Container(
//             height: scH,
//             width: scW,
//             child: Column(
//               children: <Widget>[
//                 Container(
//                   margin: EdgeInsets.only(top: scH*0.13),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(35.0),
//                     child: Image.asset(
//                       "lib/asset/icons/logoSquare.png",
//                       height: 120,
//                       width: 120,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20,),
//                 Text("Welcome to",
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.w400,
//                     color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
//                   ),
//                 ),
//                 Text("Mate - Your Virtual Campus!",
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.w600,
//                     color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
//                   ),
//                 ),
//                 Expanded(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       InkWell(
//                         onTap: (){
//                           Provider.of<AuthUserProvider>(context, listen: false).error = "";
//                           Navigator.of(context).pushNamed(LoginWithEmail.routeName);
//                           //Navigator.of(context).pushNamed(LoginMain.route);
//                         },
//                         child: Text(
//                           "Already a member? Log In",
//                           style: TextStyle(
//                             fontSize: 15,
//                             fontWeight: FontWeight.w500,
//                             color: MateColors.activeIcons,
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 35,),
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: scW*0.03),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             InkWell(
//                               onTap: ()async{
//                                 SharedPreferences prefs = await SharedPreferences.getInstance();
//                                 Provider.of<AuthUserProvider>(context, listen: false).login().then((loginSuccess) {
//                                   if(loginSuccess){
//                                     prefs.setBool('login_app', true);
//                                     if(Provider.of<AuthUserProvider>(context, listen: false).authUser.universityId==null){
//                                       Get.off(UpdateProfile(
//                                         fullName: Provider.of<AuthUserProvider>(context, listen: false).authUser.displayName,
//                                         about: "",
//                                         uuid: Provider.of<AuthUserProvider>(context, listen: false).authUser.id,
//                                         universityId: Provider.of<AuthUserProvider>(context, listen: false).authUser.universityId,
//                                         photoUrl: Provider.of<AuthUserProvider>(context, listen: false).authUser.photoUrl,
//                                         coverPhotoUrl: Provider.of<AuthUserProvider>(context, listen: false).authUser.coverPhotoUrl,
//                                         isGoToHome: true,
//                                       ));
//                                     }else{
//                                       Navigator.of(context).pushReplacementNamed(HomeScreen.homeScreenRoute);
//                                     }
//                                   }
//                                   // if (loginSuccess[0] == "success") {
//                                   //   prefs.setBool('login_app', true);
//                                   //   Navigator.of(context).pushReplacementNamed(HomeScreen.homeScreenRoute);
//                                   // }else if(loginSuccess[0] == "updateProfile"){
//                                   //   //Get.to(CreateProfile(loginSuccess[1]??"", loginSuccess[2]??"", loginSuccess[3]??""));
//                                   //   Fluttertoast.showToast(msg: "Please update profile first", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
//                                   // }
//                                 });
//                               },
//                               child: Container(
//                                 height: 56,
//                                 //width: 147,
//                                 width: MediaQuery.of(context).size.width/1.07,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(28),
//                                   color: themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightButtonBackground,
//                                 ),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Image.asset("lib/asset/glogo.png",width: 20,),
//                                     SizedBox(width: 5,),
//                                     Text("Google",
//                                       style: TextStyle(
//                                         fontSize: 17,
//                                         fontWeight: FontWeight.w700,
//                                         color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             // Container(
//                             //   height: 56,
//                             //   width: 147,
//                             //   decoration: BoxDecoration(
//                             //     borderRadius: BorderRadius.circular(28),
//                             //     color: themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightButtonBackground,
//                             //   ),
//                             //   child: Row(
//                             //     mainAxisAlignment: MainAxisAlignment.center,
//                             //     children: [
//                             //       Image.asset("lib/asset/appleLogo.png",width: 20,
//                             //         color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
//                             //       ),
//                             //       SizedBox(width: 5,),
//                             //       Text("Apple",
//                             //         style: TextStyle(
//                             //           fontSize: 17,
//                             //           fontWeight: FontWeight.w700,
//                             //           color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
//                             //         ),
//                             //       ),
//                             //     ],
//                             //   ),
//                             // ),
//                           ],
//                         ),
//                       ),
//                       Container(
//                         height: 56,
//                         margin: EdgeInsets.only(top: 15,left: 16,right: 16,bottom: 20),
//                         width: scW,
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             primary: MateColors.activeIcons,
//                             onPrimary: Colors.white,
//                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
//                           ),
//                           onPressed: (){
//                             Navigator.of(context).pushNamed(SignupWithEmail.routeName);
//                           },
//                           child: Text("Sign Up with Email",
//                             style: TextStyle(
//                               color: themeController.isDarkMode?MateColors.blackTextColor:Colors.white,
//                               fontWeight: FontWeight.w700,
//                               fontSize: 17.0,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 _signInError(),
//               ],
//             ),
//           ),
//         ),
//         Visibility(
//           visible: Provider.of<AuthUserProvider>(context, listen: true).loggingInLoaderStatus,
//           child: Loader(),
//         ),
//       ],
//     );
//   }
//
//   Widget _signInError() {
//     return Selector<AuthUserProvider, String>(
//       selector: (ctx, authUserProvider) => authUserProvider.error,
//       builder: (ctx, error, _) {
//         if (error.length > 0) {
//           return Container(
//             color: Colors.red,
//             margin: EdgeInsets.all(8),
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 "$error",
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           );
//         }
//         return SizedBox.shrink();
//       },
//     );
//   }
//
//   Widget _signInLoader() {
//     return Selector<AuthUserProvider, bool>(
//       selector: (ctx, authUserProvider) => authUserProvider.loggingInLoaderStatus,
//       builder: (ctx, loggingInLoaderStatus, _) {
//         if (loggingInLoaderStatus) {
//           return CircularProgressIndicator();
//         }
//         return SizedBox.shrink();
//       },
//     );
//   }
//
// // Widget _signInButton() {
// //   return ElevatedButton(
// //     //splashColor: Colors.grey,
// //     onPressed: () async {
// //       SharedPreferences prefs = await SharedPreferences.getInstance();
// //       Provider.of<AuthUserProvider>(context, listen: false).login().then((loginSuccess) {
// //         if (loginSuccess) {
// //           prefs.setBool('login_app', true);
// //           Navigator.of(context).pushReplacementNamed(HomeScreen.homeScreenRoute);
// //         }
// //       });
// //
// //       //Navigator.of(context).pushReplacementNamed(HomeScreen.homeScreenRoute);
// //       // signInWithGoogle().then((result) {
// //       //   if (result != null) {
// //       //     Navigator.of(context).push(
// //       //       MaterialPageRoute(
// //       //         builder: (context) {
// //       //           return HomeScreen();
// //       //         },
// //       //       ),
// //       //     );
// //       //   }
// //       // });
// //     },
// //     //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
// //     //highlightElevation: 0,
// //     //borderSide: BorderSide(color: Colors.grey),
// //     child: Padding(
// //       padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
// //       child: Row(
// //         mainAxisSize: MainAxisSize.min,
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: <Widget>[
// //           Image(image: AssetImage("lib/asset/glogo.png"), height: 35.0),
// //           Padding(
// //             padding: const EdgeInsets.only(left: 10),
// //             child: Text(
// //               'Sign in with Google',
// //               style: TextStyle(
// //                 fontSize: 20,
// //                 color: Colors.grey,
// //               ),
// //             ),
// //           )
// //         ],
// //       ),
// //     ),
// //   );
// // }
// }


