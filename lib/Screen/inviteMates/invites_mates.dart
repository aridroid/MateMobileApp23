import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share/share.dart';


import '../../asset/Colors/MateColors.dart';
import '../../controller/theme_controller.dart';

class InviteMates extends StatefulWidget {
  static final String routeName = '/inviteMates';

  @override
  _InviteMatesState createState() => _InviteMatesState();
}

class _InviteMatesState extends State<InviteMates> {
  ThemeController themeController = Get.find<ThemeController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: MateColors.activeIcons,
        ),
        title: Text(
          "Referral Program",
          style: TextStyle(
            color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
            fontWeight: FontWeight.w700,
            fontSize: 17.0,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        children: [
          Container(
            color: themeController.isDarkMode?MateColors.drawerTileColor:Colors.white,
            padding: EdgeInsets.only(bottom: 30),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20,left: 16,right: 16),
                  child: Text(
                    "Refer your mates to your virtual campus and unlock rewards like exclusive community access, swag, and more!",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.1,
                      color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  height: 56,
                  margin: EdgeInsets.only(top: 25),
                  width: 160,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: MateColors.activeIcons,
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                    ),
                    onPressed: (){
                      String IOSLink="https://apps.apple.com/in/app/mate-your-virtual-campus/id1547466147";
                      Share.share("Follow this link to join MATE Virtual Campus $IOSLink");
                    },
                    child: Text("Share Link",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 17.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          GridView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: ScrollPhysics(),
            padding: EdgeInsets.only(right: 16,top: 16,left: 16),
            itemCount: 8,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.73,
            ),
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: themeController.isDarkMode?MateColors.drawerTileColor:Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: themeController.isDarkMode?MateColors.drawerTileColor.withOpacity(0.08):Colors.black.withOpacity(0.05),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15)),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.pink,Colors.purple],
                        ),
                      ),
                      child: Center(
                          child: Image.asset("lib/asset/icons/heartWhite.png",height: 70),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("1 of 1",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.1,
                              color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                            ),
                          ),
                          SizedBox(width: 10,),
                          Expanded(
                            child: Container(
                              height: 1.5,
                              color: MateColors.activeIcons,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
                      child: Text("rewards unlocking soon",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.1,
                          color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
