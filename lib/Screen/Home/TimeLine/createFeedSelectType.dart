import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mate_app/Screen/Home/TimeLine/CreateFeedPost.dart';

import '../../../asset/Colors/MateColors.dart';
import '../../../controller/theme_controller.dart';
import '../Mate/createBeAMatePost.dart';
import '../Mate/createFindAMatePost.dart';

class CreateFeedSelectType extends StatefulWidget {
  static final String routeName = '/createFeedSelectType';

  @override
  _CreateFeedSelectTypeState createState() => _CreateFeedSelectTypeState();
}

class _CreateFeedSelectTypeState extends State<CreateFeedSelectType> {
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
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height*0.07,
                left: 16,
                right: 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: (){
                      Get.back();
                    },
                    child: Icon(Icons.arrow_back_ios,
                      size: 20,
                      color: themeController.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  Text(
                    "Create Post",
                    style: TextStyle(
                      color: themeController.isDarkMode ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                      fontSize: 18.0,
                    ),
                  ),
                  SizedBox(),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: scW*0.1,right: scW*0.1,top: scH*0.07),
              child: Text(
                "What do you want to post about?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  color: themeController.isDarkMode?Colors.white:Colors.black,
                ),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Positioned(
                    left: scW*0.07,
                    top: -scH*0.05,
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          selected = 1;
                        });
                      },
                      child: Container(
                        height: scH*0.4,
                        width: scW*0.4,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                          border: Border.all(
                            width: selected==1?1:0,
                            color: selected==1?
                            themeController.isDarkMode? MateColors.appThemeDark:MateColors.appThemeLight:
                            themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                          ),
                        ),
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(scW*0.06),
                        child: Text('Post on Home Feed',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            height: 1.2,
                            color: themeController.isDarkMode ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                            fontSize: 17.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: scW*0.5,
                    top: scH*0.04,
                    child: Container(
                      height: scH*0.09,
                      width: scW*0.09,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                      ),
                    ),
                  ),
                  Positioned(
                    right: scW*0.07,
                    top: scH*0.05,
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          selected = 2;
                        });
                      },
                      child: Container(
                        height: scH*0.4,
                        width: scW*0.4,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                          border: Border.all(
                            width: selected==2?1:0,
                            color: selected==2?
                            themeController.isDarkMode? MateColors.appThemeDark:MateColors.appThemeLight:
                            themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                          ),
                        ),
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(
                          left: scW*0.045,
                          right: scW*0.045,
                          top: scW*0.015,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Job Board: Be a Mate',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                height: 1.2,
                                color: themeController.isDarkMode ? Colors.white : Colors.black,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                                fontSize: 17.0,
                              ),
                            ),
                            SizedBox(height: scH*0.01,),
                            Text('Offer help &  monetize your skills',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                height: 1.2,
                                color: themeController.isDarkMode ? Colors.white : Colors.black,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins',
                                fontSize: 12.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: scW*0.12,
                    top: scH*0.23,
                    child: Container(
                      height: scH*0.05,
                      width: scW*0.05,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                      ),
                    ),
                  ),
                  Positioned(
                    left: scW*0.12,
                    top: scH*0.17,
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          selected = 3;
                        });
                      },
                      child: Container(
                        height: scH*0.4,
                        width: scW*0.4,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                          border: Border.all(
                            width: selected==3?1:0,
                            color: selected==3?
                            themeController.isDarkMode? MateColors.appThemeDark:MateColors.appThemeLight:
                            themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                          ),
                        ),
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(
                          left: scW*0.045,
                          right: scW*0.045,
                          top: scW*0.015,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Job Board: Find a Mate',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                height: 1.2,
                                color: themeController.isDarkMode ? Colors.white : Colors.black,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                                fontSize: 17.0,
                              ),
                            ),
                            SizedBox(height: scH*0.01,),
                            Text('Find help, jobs & mentors',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                height: 1.2,
                                color: themeController.isDarkMode ? Colors.white : Colors.black,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins',
                                fontSize: 12.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: scW*0.25,
                    top: scH*0.32,
                    child: Container(
                      height: scH*0.15,
                      width: scW*0.15,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                      ),
                    ),
                  ),
                  Positioned(
                    right: scW*0.12,
                    top: scH*0.34,
                    child: Container(
                      height: scH*0.04,
                      width: scW*0.04,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 60,
              width: scW,
              margin: EdgeInsets.only(left: scW*0.05,right: scW*0.05,bottom: scH*0.05),
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
                  if(selected==1){
                    Navigator.of(context).pushNamed(CreateFeedPost.routeName);
                  }else if(selected==2){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateBeAMatePost()));
                  }else if(selected==3){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateFindAMatePost()));
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
    );
  }
}
