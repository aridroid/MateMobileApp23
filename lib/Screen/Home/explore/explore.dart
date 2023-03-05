import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../asset/Colors/MateColors.dart';
import '../../../controller/theme_controller.dart';

class Explore extends StatefulWidget {
  const Explore({Key key}) : super(key: key);

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
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
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.07,),
              child: Center(
                child: Text(
                  "Explore",
                  style: TextStyle(
                      color: themeController.isDarkMode ? Colors.white : MateColors.drawerTileColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 18.0,
                      fontFamily: 'Poppins'
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        margin: EdgeInsets.only(left: 16),
                        height: 60,
                        decoration: BoxDecoration(
                          color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.only(left: 16,right: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Search here...",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                color: themeController.isDarkMode?MateColors.helpingTextDark:Colors.black.withOpacity(0.72),
                              ),
                            ),
                            Container(
                              height: 36,
                              width: 36,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: themeController.isDarkMode?MateColors.textFieldSearchDark:MateColors.textFieldSearchLight,
                              ),
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  "lib/asset/homePageIcons/searchPurple@3x.png",
                                  color: themeController.isDarkMode?Colors.white:MateColors.blackText,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16,),
                  InkWell(
                    onTap: () async {},
                    child: Container(
                      height: 60,
                      width: 60,
                      margin: EdgeInsets.only(right: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                      ),
                      child: Icon(Icons.add, color: MateColors.blackTextColor, size: 28),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 25,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Recommended',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w600,
                              overflow: TextOverflow.ellipsis,
                              color: themeController.isDarkMode?Colors.white:Colors.black,
                            ),
                          ),
                          Text('See more',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w300,
                              color: themeController.isDarkMode?Colors.white:Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height*0.27,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        physics: ScrollPhysics(),
                        padding: EdgeInsets.only(left: 16,right: 16,top: 16),
                        itemCount: 3,
                        itemBuilder: (context,index){
                          return Padding(
                            padding: EdgeInsets.only(
                              left: index==0?0:16,
                            ),
                            child: Image.asset('lib/asset/iconsNewDesign/testSlider2.png'),
                          );
                        },
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height*0.135,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        physics: ScrollPhysics(),
                        padding: EdgeInsets.only(left: 16,right: 16,),
                        itemCount: 3,
                        itemBuilder: (context,index){
                          return Padding(
                            padding: EdgeInsets.only(
                              left: index==0?0:16,
                            ),
                            child: customContainerRow(image[index], text[index]),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 16,
                        //bottom: 16,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Popular',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w600,
                              overflow: TextOverflow.ellipsis,
                              color: themeController.isDarkMode?Colors.white:Colors.black,
                            ),
                          ),
                          Text('See more',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w300,
                              color: themeController.isDarkMode?Colors.white:Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height*0.25,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        physics: ScrollPhysics(),
                        padding: EdgeInsets.only(left: 16,right: 16),
                        itemCount: 3,
                        itemBuilder: (context,index){
                          return Padding(
                            padding: EdgeInsets.only(
                              left: index==0?0:16,
                            ),
                            child: customContainer(image[index], text[index]),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 40,
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
  Widget customContainerRow(String image,String text){
    return Container(
      height: 48,
      width: MediaQuery.of(context).size.width*0.5,
      margin: EdgeInsets.only(right: 0,bottom: 30,top: 30),
      decoration: BoxDecoration(
        color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10),
            padding: EdgeInsets.all(text=="Network"?13.0:8),
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: themeController.isDarkMode?MateColors.textFieldSearchDark:MateColors.textFieldSearchLight,
            ),
            child: Image.asset(image,color: themeController.isDarkMode?Colors.white:Colors.black,),
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
          SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }
}
