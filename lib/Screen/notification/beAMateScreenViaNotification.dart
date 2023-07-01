import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Model/beAMatePostsModel.dart';
import '../../Services/notificationService.dart';
import '../../Widget/Home/Mate/beAMateRow.dart';
import '../../Widget/Loaders/Shimmer.dart';
import '../../asset/Colors/MateColors.dart';
import '../../controller/theme_controller.dart';

class BeAMateScreenViaNotification extends StatefulWidget {
  final int id;
  const BeAMateScreenViaNotification({Key key,this.id}) : super(key: key);

  @override
  State<BeAMateScreenViaNotification> createState() => _BeAMateScreenViaNotificationState();
}

class _BeAMateScreenViaNotificationState extends State<BeAMateScreenViaNotification> {
  ThemeController themeController = Get.find<ThemeController>();
  bool isLoading = true;
  Result beAMateData;
  String token = "";
  NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    getStoredValue();
    super.initState();
  }

  getStoredValue()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token");
    beAMateData = await _notificationService.getBeAMateDetails(token: token,id: widget.id);
    setState(() {
      isLoading = false;
    });
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
                      color: themeController.isDarkMode ? Colors.white : MateColors.blackTextColor,
                    ),
                  ),
                  Text(
                    "",
                    style: TextStyle(
                      color: themeController.isDarkMode ? Colors.white : MateColors.blackTextColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 17.0,
                    ),
                  ),
                  SizedBox(),
                ],
              ),
            ),
            Expanded(
              child: isLoading?
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: timelineLoader(),
              ):
              beAMateData!=null?
              BeAMateRow(
                beAMateId: beAMateData.id,
                description: beAMateData.description,
                title: beAMateData.title,
                portfolioLink: beAMateData.portfolioLink,
                fromDate: beAMateData.fromDate,
                toDate: beAMateData.toDate,
                fromTime: beAMateData.timeFrom,
                toTime: beAMateData.timeTo,
                user: beAMateData.user,
                hyperlinkText: beAMateData.hyperLinkText,
                hyperlink: beAMateData.hyperLink,
                createdAt: "${DateFormat.yMMMEd().format(DateFormat("yyyy-MM-dd").parse(beAMateData.createdAt, true))}",
                //rowIndex: index,
                isActive: beAMateData.isActive,
              ):
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height/1.5,
                child: Text("Something went wrong! or post deleted",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: themeController.isDarkMode?Colors.white:Colors.black,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                    fontSize: 15,
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
