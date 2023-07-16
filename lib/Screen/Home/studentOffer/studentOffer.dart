import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Widget/crousel_slider.dart';
import '../../../asset/Colors/MateColors.dart';
import '../../../controller/theme_controller.dart';

class StudentOffer extends StatefulWidget {
  const StudentOffer({Key? key}) : super(key: key);

  @override
  State<StudentOffer> createState() => _StudentOfferState();
}

class _StudentOfferState extends State<StudentOffer> {
  ThemeController themeController = Get.find<ThemeController>();
  List<String> image = [
    'lib/asset/iconsNewDesign/bulb.png',
    'lib/asset/iconsNewDesign/hat.png',
    'lib/asset/iconsNewDesign/networking.png',
  ];
  List<String> text = [
    'Opportunities',
    'Campus Forum',
    'Network',
  ];

  @override
  Widget build(BuildContext context) {
    final scH = MediaQuery.of(context).size.height;
    final scW = MediaQuery.of(context).size.width;
    final _imageList = [
      Image.asset('lib/asset/iconsNewDesign/testSlider2.png',
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.fill,
      ),
      Image.asset('lib/asset/iconsNewDesign/testSlider2.png',
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.fill,
      ),
      Image.asset('lib/asset/iconsNewDesign/testSlider2.png',
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.fill,
      ),
      Image.asset('lib/asset/iconsNewDesign/testSlider2.png',
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.fill,
      ),
      Image.asset('lib/asset/iconsNewDesign/testSlider2.png',
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.fill,
      ),
    ];
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
                      color: themeController.isDarkMode ? Colors.white : MateColors.blackTextColor,
                    ),
                  ),
                  Text(
                    "Student Offers",
                    style: TextStyle(
                      color: themeController.isDarkMode ? Colors.white : MateColors.drawerTileColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 18.0,
                      fontFamily: 'Poppins'
                    ),
                  ),
                  SizedBox(),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  "Coming soon",
                  style: TextStyle(
                    color: themeController.isDarkMode ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.only(
            //       left: 16,
            //       right: 16,
            //       top: 26,
            //   ),
            //   child: ImageSliderWithIndicator(
            //     list: _imageList,
            //   ),
            // ),
            // Padding(
            //   padding: EdgeInsets.only(
            //     left: 16,
            //     right: 16,
            //     top: 16,
            //   ),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Text('Popular',
            //         style: TextStyle(
            //             fontSize: 18,
            //             fontFamily: "Poppins",
            //             fontWeight: FontWeight.w600,
            //             overflow: TextOverflow.ellipsis,
            //             color: themeController.isDarkMode?Colors.white:Colors.black,
            //         ),
            //       ),
            //       Text('See more',
            //         style: TextStyle(
            //           fontSize: 14,
            //           fontFamily: "Poppins",
            //           fontWeight: FontWeight.w300,
            //           color: themeController.isDarkMode?Colors.white:Colors.black,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // Container(
            //   height: MediaQuery.of(context).size.height*0.25,
            //   child: ListView.builder(
            //     shrinkWrap: true,
            //     scrollDirection: Axis.horizontal,
            //     physics: ScrollPhysics(),
            //     padding: EdgeInsets.only(left: 16,right: 16),
            //     itemCount: 3,
            //     itemBuilder: (context,index){
            //       return Padding(
            //         padding: EdgeInsets.only(
            //           left: index==0?0:16,
            //         ),
            //         child: customContainer(image[index], text[index]),
            //       );
            //     },
            //   ),
            // ),
            // SizedBox(
            //   height: 40,
            // ),
          ],
        ),
      ),
    );
  }
  Widget customContainer(String image,String text){
    return Container(
      height: 136,
      width: 150,
      margin: EdgeInsets.only(bottom: 30,top: 20),
      decoration: BoxDecoration(
        color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(text=="Network"?13.0:8),
            height: 54,
            width: 54,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: themeController.isDarkMode?MateColors.textFieldSearchDark:MateColors.textFieldSearchLight,
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Image.asset(image,color: themeController.isDarkMode?Colors.white:Colors.black,),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Text(text,
            style: TextStyle(
                fontSize: 13,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w500,
                overflow: TextOverflow.ellipsis,
                color: themeController.isDarkMode?Colors.white:Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
