// import 'package:flutter/material.dart';
// import 'package:intro_slider/intro_slider.dart';
// import 'package:intro_slider/slide_object.dart';
// import 'package:flutter/cupertino.dart';
//
// import '../main.dart';
//
//
// class IntroScreen extends StatefulWidget {
//   IntroScreen({Key key}) : super(key: key);
//
//   @override
//   IntroScreenState createState() => new IntroScreenState();
// }
//
// class IntroScreenState extends State<IntroScreen> {
//   List<Slide> slides = new List();
//
//   @override
//   void initState() {
//     super.initState();
//     slides.add(
//       new Slide(
//           description: "",
//           marginDescription: EdgeInsets.fromLTRB(50, 350, 50, 50),
//           backgroundImage: "lib/asset/introAssets/Design-Introduction 1@3x.png",
//           backgroundBlendMode: BlendMode.colorDodge
//         // backgroundColor: Color(0xfff5a623),
//       ),
//     );
//     slides.add(
//       new Slide(
//         //title: "",
//           description: "",
//           marginDescription: EdgeInsets.fromLTRB(50, 350, 50, 50),
//           backgroundImage: "lib/asset/introAssets/Design-Introduction 2@3x.png",
//           backgroundBlendMode: BlendMode.colorDodge
//         // backgroundColor: Color(0xff203152),
//       ),
//     );
//     slides.add(
//       new Slide(
//         //title: "",
//           description: "",
//           marginDescription: EdgeInsets.fromLTRB(50, 350, 50, 50),
//           backgroundImage: "lib/asset/introAssets/Design-Introduction 3@3x.png",
//           backgroundBlendMode: BlendMode.colorDodge
//         // backgroundColor: Color(0xff203152),
//       ),
//     );
//     slides.add(
//       new Slide(
//           title: "",
//           description: "",
//           marginDescription: EdgeInsets.fromLTRB(50, 350, 50, 50),
//           backgroundImage: "lib/asset/introAssets/Design-Introduction 4@3x.png",
//           backgroundBlendMode: BlendMode.colorDodge
//
//         //  backgroundColor: Color(0xff9932CC),
//       ),
//     );
//   }
//
//   void onDonePress() {
//     print("done");
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => MyApp()),
//     );
//   }
//
//   void onSkipPress() {
//     print("skipped");
//   }
//
//   Widget renderNextBtn() {
//     return Icon(
//       Icons.navigate_next,
//       color: Color(0xffFFFFFF),
//       size: 35.0,
//     );
//   }
//
//   Widget renderDoneBtn() {
//     return Icon(
//       Icons.done,
//       color: Color(0xffFFFFFF),
//     );
//   }
//
//   Widget renderSkipBtn() {
//     return Icon(
//       Icons.skip_next,
//       color: Color(0xffFFFFFF),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return new IntroSlider(
//       // List slides
//       slides: this.slides,
//
//       // Skip button
//       renderSkipBtn: this.renderSkipBtn(),
//       colorSkipBtn: Color(0x33000000),
//       highlightColorSkipBtn: Color(0xff000000),
//
//       // Next button
//       renderNextBtn: this.renderNextBtn(),
//
//       // Done button
//       renderDoneBtn: this.renderDoneBtn(),
//       onDonePress: onDonePress,
//
//       colorDoneBtn: Color(0x3399ccff),
//       highlightColorDoneBtn: Color(0xffFFFFFF),
//
//       // Dot indicator
//       colorDot: Color(0x3399ccff),
//       colorActiveDot: Color(0xffFFFFFF),
//       sizeDot: 13.0,
//
//       // Show or hide status bar
//       hideStatusBar: false,
//       backgroundColorAllSlides: Colors.transparent,
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../Utility/Utility.dart';
import '../asset/Colors/MateColors.dart';
import '../main.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  late PageController controller;
  int page = 0;

  @override
  void initState() {
    controller = PageController(initialPage: page);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scH = MediaQuery.of(context).size.height;
    final scW= MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Column(
          children: [
            Expanded(
              child: PageView(
                controller: controller,
                scrollDirection: Axis.horizontal,
                onPageChanged: (int page1) {
                  setState(() {
                    page = page1;
                  });
                },
                children: [
                  Column(
                    children: [
                      Image.asset("lib/asset/introAssets/intro1.png",height: scH*0.7,),
                      Padding(
                        padding: EdgeInsets.only(left: 16,right: 16,top: scH*0.025,),
                        child: Text("Your personalized college social network",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.white, fontWeight: FontWeight.w400,fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Image.asset("lib/asset/introAssets/intro2.png",height: scH*0.7,),
                      Padding(
                        padding: EdgeInsets.only(left: 16,right: 16,top: scH*0.025,),
                        child: Text("Find opportunities and monetize your skills",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.white, fontWeight: FontWeight.w400,fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Image.asset("lib/asset/introAssets/intro3.png",height: scH*0.7,),
                      Padding(
                        padding: EdgeInsets.only(left: 16,right: 16,top: scH*0.025,),
                        child: Text("Stay in the loop",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.white, fontWeight: FontWeight.w400,fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Image.asset("lib/asset/introAssets/intro4.png",height: scH*0.7,),
                      Padding(
                        padding: EdgeInsets.only(left: 16,right: 16,top: scH*0.025,),
                        child: Text("Connect anonymously",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.white, fontWeight: FontWeight.w400,fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Image.asset("lib/asset/introAssets/intro5.png",height: scH*0.7,),
                      Padding(
                        padding: EdgeInsets.only(left: 16,right: 16,top: scH*0.025,),
                        child: Text("Join or form communities for your classes and interests",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.white, fontWeight: FontWeight.w400,fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Image.asset("lib/asset/introAssets/intro6.png",height: scH*0.7,),
                      Padding(
                        padding: EdgeInsets.only(left: 16,right: 16,top: scH*0.025,),
                        child: Text("A community to support you",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.white, fontWeight: FontWeight.w400,fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: scH*0.07,
              width: scW*0.35,
              margin: EdgeInsets.only(bottom: scH*0.015,top: scH*0.025),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: MateColors.activeIcons,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                ),
                onPressed: (){
                  if(page==5){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyApp()),);
                  }else{
                    controller.animateToPage(++page, duration: Duration(milliseconds: 500), curve: Curves.easeInOut,);
                  }
                },
                child: Text("Next",
                  style: TextStyle(
                    color: MateColors.blackTextColor,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
                    fontSize: 17.0,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: SmoothPageIndicator(
                  controller: controller,  // PageController
                  count:  6,
                  effect: WormEffect(
                    activeDotColor: MateColors.activeIcons,
                    dotHeight: 12,
                    dotWidth: 12,
                  ),
                  onDotClicked: (index){
                    controller.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.easeInOut,);
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
