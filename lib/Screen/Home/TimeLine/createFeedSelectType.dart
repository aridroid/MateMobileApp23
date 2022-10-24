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
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: MateColors.activeIcons,
        ),
        title: Text(
          "Create Post",
          style: TextStyle(
            color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
            fontWeight: FontWeight.w700,
            fontSize: 17.0,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: scH*0.2,
            ),
            Text(
              "What do you want to post about?",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.1,
                color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
              ),
            ),
            SizedBox(height: 30,),
            GestureDetector(
              onTap: (){
                setState(() {
                  selected = 1;
                });
              },
              child: Container(
                height: 64,
                width: scW,
                decoration: BoxDecoration(
                  color: selected==1? MateColors.activeIcons:themeController.isDarkMode?MateColors.drawerTileColor:Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: ListTile(
                    horizontalTitleGap: 13,
                    leading: Container(
                      height: 32,
                      width: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: themeController.isDarkMode?MateColors.drawerTileColor:Colors.white,
                        border: Border.all(
                          width: 2,
                          color: themeController.isDarkMode?MateColors.darkDivider:
                          selected==1? Colors.white: MateColors.lightDivider,
                        ),
                      ),
                      child: Center(
                        child: selected==1?Icon(Icons.check,color: MateColors.activeIcons,):Offstage(),
                      ),
                    ),
                    title: Text("Regular post",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.1,
                        color:
                        themeController.isDarkMode?
                        selected==1?MateColors.blackTextColor:Colors.white:
                        selected==1?
                        Colors.white:MateColors.blackTextColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            GestureDetector(
              onTap: (){
                setState(() {
                  selected = 2;
                });
              },
              child: Container(
                height: 64,
                width: scW,
                decoration: BoxDecoration(
                  color: selected==2? MateColors.activeIcons:themeController.isDarkMode?MateColors.drawerTileColor:Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: ListTile(
                    horizontalTitleGap: 13,
                    leading: Container(
                      height: 32,
                      width: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: themeController.isDarkMode?MateColors.drawerTileColor:Colors.white,
                        border: Border.all(
                          width: 2,
                          color: themeController.isDarkMode?MateColors.darkDivider:
                          selected==2? Colors.white: MateColors.lightDivider,
                        ),
                      ),
                      child: Center(
                        child: selected==2?Icon(Icons.check,color: MateColors.activeIcons,):Offstage(),
                      ),
                    ),
                    title: Text("Find a mate",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.1,
                        color:
                        themeController.isDarkMode?
                        selected==2?MateColors.blackTextColor:Colors.white:
                        selected==2?
                        Colors.white:MateColors.blackTextColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            GestureDetector(
              onTap: (){
                setState(() {
                  selected = 3;
                });
              },
              child: Container(
                height: 64,
                width: scW,
                decoration: BoxDecoration(
                  color: selected==3? MateColors.activeIcons:themeController.isDarkMode?MateColors.drawerTileColor:Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: ListTile(
                    horizontalTitleGap: 13,
                    leading: Container(
                      height: 32,
                      width: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: themeController.isDarkMode?MateColors.drawerTileColor:Colors.white,
                        border: Border.all(
                          width: 2,
                          color: themeController.isDarkMode?MateColors.darkDivider:
                          selected==3? Colors.white: MateColors.lightDivider,
                        ),
                      ),
                      child: Center(
                        child: selected==3?Icon(Icons.check,color: MateColors.activeIcons,):Offstage(),
                      ),
                    ),
                    title: Text("Be a mate",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.1,
                        color:
                        themeController.isDarkMode?
                        selected==3?MateColors.blackTextColor:Colors.white:
                        selected==3?
                        Colors.white:MateColors.blackTextColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 56,
                  margin: EdgeInsets.only(top: 50,left: scW*0.25,right: scW*0.25,bottom: 20),
                  width: 160,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: MateColors.activeIcons,
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                    ),
                    onPressed: (){
                      if(selected==1){
                        Navigator.of(context).pushNamed(CreateFeedPost.routeName);
                      }else if(selected==2){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateFindAMatePost()));
                      }else if(selected==3){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateBeAMatePost()));
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
    );
  }
}
