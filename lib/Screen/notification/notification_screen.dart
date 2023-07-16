import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mate_app/Screen/notification/feedDetailsScreenViaNotification.dart';
import 'package:mate_app/Services/notificationService.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Model/notificationData.dart';
import '../../asset/Colors/MateColors.dart';
import '../../controller/theme_controller.dart';
import '../Profile/UserProfileScreen.dart';
import 'beAMateScreenViaNotification.dart';
import 'campusTalkDetailsScreenViaNotification.dart';
import 'eventDetailsScreenViaNotification.dart';
import 'findAMateScreenViaNotification.dart';

class NotificationScreen extends StatefulWidget {
  static final String routeName = '/notificationScreen';

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  ThemeController themeController = Get.find<ThemeController>();
  NotificationService _notificationService = NotificationService();
  String token = "";
  List<NotificationData> notificationData = [];
  List<NotificationData> notificationDataUnread = [];
  List<NotificationData> notificationDataRead = [];
  bool isLoading = true;

  @override
  void initState() {
    getStoredValue();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getStoredValue() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("tokenApp")!;
    notificationData = await _notificationService.getNotificationListing(token: token);
    notificationDataUnread = notificationData.where((element) => !element.isRead!).toList();
    notificationDataRead = notificationData.where((element) => element.isRead!).toList();
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
                    "Notifications",
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
              Container(
                child: Center(
                  child: CircularProgressIndicator(
                    color: MateColors.activeIcons,
                  ),
                ),
              ):
              notificationData.isEmpty?
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height/1.5,
                child: Text("You don't have any notification",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: themeController.isDarkMode?Colors.white:Colors.black,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                    fontSize: 15,
                  ),
                ),
              ):
              ListView(
                padding: EdgeInsets.only(top: 10),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16,right: 16,top: 16),
                    child: Row(
                      children: [
                        Text("New",
                          style: TextStyle(
                            color: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                            fontSize: 12,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 1,
                            margin: EdgeInsets.only(left: 16,right: 16),
                            color: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: notificationDataUnread.length,
                    itemBuilder: (context,index){
                      NotificationData notification = notificationDataUnread[index];
                      return GestureDetector(
                        onTap: ()async{
                          if(notification.postType == "Feed"){
                            Get.to(()=>FeedDetailsViaNotification(feedId: notification.postId!,));
                          }else if(notification.postType == "Event"){
                            Get.to(()=> EventDetailsScreenViaNotification(
                              eventId: notification.postId!,
                            ));
                          }else if(notification.postType == "CampusTalk"){
                            Get.to(()=> CampusTalkDetailsScreenViaNotification(
                              campusId: notification.postId!,//notification.postId,
                            ));
                          }else if(notification.postType == "BeMate"){
                            Get.to(()=> BeAMateScreenViaNotification(
                              id: notification.postId!,
                            ));
                          }else if(notification.postType == "FindMate"){
                            Get.to(()=> FindAMateViaNotification(
                              id: notification.postId!,//notification.postId,
                            ));
                          }else if(notification.postType == "Connection"){
                            Navigator.of(context).pushNamed(UserProfileScreen.routeName,
                                arguments: {
                                  "id": notification.sender!.id,
                                  "name": notification.sender!.name,
                                  "photoUrl": notification.sender!.photoUrl,
                                  "firebaseUid": notification.sender!.firebaseUid,
                                });
                          }
                          bool res = await _notificationService.changeStatus(token: token,id: notification.id!);
                          if(res){
                            setState(() {
                              notificationDataUnread.removeAt(index);
                              notificationDataRead.add(notification);
                            });
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 16,vertical: 16),
                          padding: EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: themeController.isDarkMode?Color(0xFF75F3E7):Color(0xFF17F3DE),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                horizontalTitleGap: 15,
                                leading: Container(
                                  height: 45,
                                  width: 45,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: MateColors.activeIcons,
                                    image: DecorationImage(
                                      image: NetworkImage(notification.sender!.photoUrl!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                title: Text(notification.sender!.name!,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w600,
                                    color: MateColors.blackTextColor,
                                  ),
                                ),
                                subtitle: Text(notification.created!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black.withOpacity(0.72),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10,left: 16),
                                child: Text(
                                  notification.title!,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 16,top: 10,right: 10),
                                child: Text(
                                  notification.description??"",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 0.1,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16,right: 16,top: 16),
                    child: Row(
                      children: [
                        Text("Read",
                          style: TextStyle(
                            color: themeController.isDarkMode?Colors.white.withOpacity(0.5):Colors.black.withOpacity(0.5),
                            fontSize: 12,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 1,
                            margin: EdgeInsets.only(left: 16,right: 16),
                            color: themeController.isDarkMode?MateColors.dividerDark:MateColors.dividerLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: notificationDataRead.length,
                    itemBuilder: (context,index){
                      NotificationData notification = notificationDataRead[index];
                      return GestureDetector(
                        onTap: (){
                          if(notification.postType == "Feed"){
                            Get.to(()=>FeedDetailsViaNotification(feedId: notification.postId!,));
                          }else if(notification.postType == "Event"){
                            Get.to(()=> EventDetailsScreenViaNotification(
                              eventId: notification.postId!,
                            ));
                          }else if(notification.postType == "CampusTalk"){
                            Get.to(()=> CampusTalkDetailsScreenViaNotification(
                              campusId: notification.postId!,//notification.postId,
                            ));
                          }else if(notification.postType == "BeMate"){
                            Get.to(()=> BeAMateScreenViaNotification(
                              id: notification.postId!,
                            ));
                          }else if(notification.postType == "FindMate"){
                            Get.to(()=> FindAMateViaNotification(
                              id: notification.postId!,//notification.postId,
                            ));
                          }else if(notification.postType == "Connection"){
                            Navigator.of(context).pushNamed(UserProfileScreen.routeName,
                                arguments: {
                                  "id": notification.sender!.id,
                                  "name": notification.sender!.name,
                                  "photoUrl": notification.sender!.photoUrl,
                                  "firebaseUid": notification.sender!.firebaseUid,
                                });
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 16,vertical: 16),
                          padding: EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                horizontalTitleGap: 15,
                                leading: Container(
                                  height: 45,
                                  width: 45,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: MateColors.activeIcons,
                                    image: DecorationImage(
                                      image: NetworkImage(notification.sender!.photoUrl!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                title: Text(notification.sender!.name!,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w600,
                                    color: themeController.isDarkMode?Colors.white: MateColors.blackTextColor,
                                  ),
                                ),
                                subtitle: Text(notification.created!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: themeController.isDarkMode?MateColors.helpingTextDark:Colors.black.withOpacity(0.72),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10,left: 16),
                                child: Text(
                                  notification.title!,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w700,
                                    color: themeController.isDarkMode?Colors.white:Colors.black,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 16,top: 10,right: 10),
                                child: Text(
                                  notification.description??"",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 0.1,
                                    color: themeController.isDarkMode?Colors.white:Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
