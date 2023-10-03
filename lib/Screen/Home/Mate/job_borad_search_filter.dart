import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mate_app/Screen/Home/Mate/job_board_filter_drawer.dart';
import 'package:mate_app/controller/jobBoardController.dart';

import '../../../asset/Colors/MateColors.dart';
import '../../../constant.dart';
import '../../../controller/theme_controller.dart';
import 'job_board_tile.dart';

class JobBoardSearchFilter extends StatelessWidget {
  JobBoardSearchFilter({Key? key}) : super(key: key);

  final ThemeController themeController = Get.find<ThemeController>();
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final scH = MediaQuery.of(context).size.height;
    final scW = MediaQuery.of(context).size.width;

    return GetBuilder<JobBoardController>(
      builder: (jobBoardController){
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: null,
          onPanUpdate: (details) {
            if (details.delta.dy > 0){
              FocusScope.of(context).requestFocus(FocusNode());
              print("Dragging in +Y direction");
            }
          },
          child: Scaffold(
            key: _key,
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
                  SizedBox(
                    height: scH*0.07,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: jobBoardController.textEditingController,
                      onChanged: (value){
                        if(value.isEmpty){
                          jobBoardController.fetchJobListing(true);
                        }else if(value.length>2){
                          jobBoardController.onSearchChanged();
                        }
                      },
                      cursorColor: themeController.isDarkMode?
                      MateColors.helpingTextDark:
                      MateColors.helpingTextLight,
                      style:  TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.1,
                        color: themeController.isDarkMode?Colors.white:Colors.black,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: themeController.isDarkMode ?
                        MateColors.containerDark :
                        MateColors.containerLight,
                        hintStyle: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          color: themeController.isDarkMode?
                          MateColors.helpingTextDark:
                          MateColors.helpingTextLight,
                        ),
                        hintText: "Search",
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 15,top: 15,bottom: 15),
                          child: Image.asset(
                            "lib/asset/homePageIcons/searchPurple@3x.png",
                            height: 10,
                            width: 10,
                            color: themeController.isDarkMode?Colors.white:Colors.black,
                          ),
                        ),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: (){
                                Get.back();
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(top: 16,right: 15),
                                child: Text(
                                  "Close",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w700,
                                    color: themeController.isDarkMode?
                                    MateColors.appThemeDark:
                                    MateColors.appThemeLight,
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: (){
                                _key.currentState!.openEndDrawer();
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(top: 16,right: 15),
                                child: Icon(
                                  Icons.filter_list,
                                  color: themeController.isDarkMode?
                                  MateColors.appThemeDark:
                                  MateColors.appThemeLight,
                                ),
                              ),
                            ),
                          ],
                        ),
                        enabledBorder: commonBorder,
                        focusedBorder: commonBorder,
                      ),
                    ),
                  ),
                  Expanded(
                    child:
                    jobBoardController.noDataFound?
                    Center(
                      child: Text("No data found",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppins',
                          letterSpacing: 0.1,
                          color: themeController.isDarkMode?Colors.white:Colors.black,
                        ),
                      ),
                    ):
                    ListView.builder(
                      controller: jobBoardController.scrollController,
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: ScrollPhysics(),
                      itemCount: jobBoardController.jobList.length,
                      itemBuilder: (context,index){
                        return JobBoardTile(jobs: jobBoardController.jobList[index]);
                      },
                    ),
                  ),
                ],
              ),
            ),
            endDrawer: JobBoardFilterDrawer(),
            onEndDrawerChanged: (isOpen) {
              if(isOpen){
                jobBoardController.setPreviousCountAndValue();
              }
              if(!isOpen && jobBoardController.applyFilter){
                jobBoardController.fetchJobListing(true);
              }
            },
          ),
        );
      },
    );
  }
}
