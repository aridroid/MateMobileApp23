import 'package:get/get.dart';
import 'package:mate_app/Screen/Home/Mate/jobBoard.dart';
import 'package:mate_app/Screen/Home/Mate/job_borad_search_filter.dart';
import 'package:mate_app/Screen/Home/Mate/searchBeAMate.dart';
import 'package:mate_app/Screen/Home/Mate/searchFindAMate.dart';
import 'package:mate_app/asset/Colors/MateColors.dart';
import 'package:mate_app/Screen/Home/Mate/beAMate.dart';
import 'package:mate_app/Screen/Home/Mate/findAMate.dart';
import 'package:flutter/material.dart';

import '../../../Widget/Loaders/Shimmer.dart';
import '../../../controller/jobBoardController.dart';

class MateScreen extends StatefulWidget {
  static var mateScreenRoute = '/mateScreen';
  @override
  _MateScreenState createState() => _MateScreenState();
}

class _MateScreenState extends State<MateScreen> with TickerProviderStateMixin {
  late PageController _pageController;
  int _selectedIndex = 0;
  JobBoardController jobBoardController = Get.put(JobBoardController());

  void initState() {
    _pageController = PageController(initialPage: _selectedIndex);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

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
                    "Job Board",
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
            GestureDetector(
              onTap: () async{
                if(_selectedIndex==0)
                  Get.to(()=>SearchFindAMate());
                else if(_selectedIndex==1)
                  Get.to(()=>SearchBeAMate());
                else if(_selectedIndex==2){
                  await Get.to(()=>JobBoardSearchFilter());
                  jobBoardController.clearAllFilter();
                  jobBoardController.textEditingController.clear();
                  jobBoardController.fetchJobListing(true);
                }
              },
              child: Container(
                margin: EdgeInsets.only(left: 16,top: 16,right: 16,bottom: 10),
                height: 60,
                decoration: BoxDecoration(
                  color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.only(left: 16, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_selectedIndex==2?"Search or filter here...":"Search here...",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: themeController.isDarkMode?MateColors.helpingTextDark:Colors.black.withOpacity(0.72),
                      ),
                    ),
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: themeController.isDarkMode?MateColors.textFieldSearchDark:MateColors.textFieldSearchLight,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          "lib/asset/iconsNewDesign/search.png",
                          color: themeController.isDarkMode?Colors.white:MateColors.blackText,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16,right: 16,top: 10,bottom: 5),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: themeController.isDarkMode?Colors.white.withOpacity(0.12):Colors.white.withOpacity(0.2),
                ),
                padding: EdgeInsets.symmetric(horizontal: 7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _pageController.animateToPage(0, duration: Duration(milliseconds: 500), curve: Curves.ease);
                      },
                      child: Container(
                        height: 36,
                        width: MediaQuery.of(context).size.width*0.28,
                        decoration: BoxDecoration(
                          color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                          borderRadius: BorderRadius.circular(9),
                        ),
                        alignment: Alignment.center,
                        child: Text('Find a Mate',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w500,
                            overflow: TextOverflow.ellipsis,
                            color: _selectedIndex==0?
                            themeController.isDarkMode?Colors.white:Colors.black :
                            themeController.isDarkMode?Colors.white.withOpacity(0.5):Colors.black.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _pageController.animateToPage(1, duration: Duration(milliseconds: 500), curve: Curves.ease);
                      },
                      child: Container(
                        height: 36,
                        width: MediaQuery.of(context).size.width*0.28,
                        decoration: BoxDecoration(
                          color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                          borderRadius: BorderRadius.circular(9),
                        ),
                        alignment: Alignment.center,
                        child: Text('Be a Mate',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w500,
                            overflow: TextOverflow.ellipsis,
                            color: _selectedIndex==1?
                            themeController.isDarkMode?Colors.white:Colors.black :
                            themeController.isDarkMode?Colors.white.withOpacity(0.5):Colors.black.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _pageController.animateToPage(2, duration: Duration(milliseconds: 500), curve: Curves.ease);
                      },
                      child: Container(
                        height: 36,
                        width: MediaQuery.of(context).size.width*0.28,
                        decoration: BoxDecoration(
                          color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                          borderRadius: BorderRadius.circular(9),
                        ),
                        alignment: Alignment.center,
                        child: Text('Job Boards',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w500,
                            overflow: TextOverflow.ellipsis,
                            color: _selectedIndex==2?
                            themeController.isDarkMode?Colors.white:Colors.black :
                            themeController.isDarkMode?Colors.white.withOpacity(0.5):Colors.black.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (val){
                  setState(() {
                    _selectedIndex = val;
                  });
                },
                children: [
                  FindAMateScreen(),
                  BeAMateScreen(),
                  JobBoard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
