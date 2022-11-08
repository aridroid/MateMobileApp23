import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mate_app/audioAndVideoCalling/calling.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../asset/Colors/MateColors.dart';
import '../controller/theme_controller.dart';

class AcceptRejectScreen extends StatefulWidget {
  final String channelName;
  final String token;
  final String callType;
  final String callerImage;
  final String callerName;
  const AcceptRejectScreen({Key key, this.channelName, this.token, this.callType, this.callerImage, this.callerName}) : super(key: key);

  @override
  State<AcceptRejectScreen> createState() => _AcceptRejectScreenState();
}

class _AcceptRejectScreenState extends State<AcceptRejectScreen> {
  ThemeController themeController = Get.find<ThemeController>();


  @override
  Widget build(BuildContext context) {
    final scH = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: scH*0.05),
                child: Text(
                  widget.callType,
                  style: TextStyle(
                    color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 17.0,
                  ),
                ),
              ),
              SizedBox(
                height: scH*0.15,
              ),
              CachedNetworkImage(
                imageUrl: widget.callerImage,
                progressIndicatorBuilder: (context, url, downloadProgress){
                  return CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage("lib/asset/profile.png"),
                  );
                },
                errorWidget: (context, url, error){
                  return CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage("lib/asset/profile.png"),
                  );
                },
                imageBuilder: (context,url){
                  return CircleAvatar(
                    radius: 60,
                    backgroundImage: url,
                  );
                }
              ),
              Padding(
                padding: EdgeInsets.only(top: scH*0.03),
                child: Text(
                  widget.callerName,
                  style: TextStyle(
                    color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 17.0,
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: ()async{
                        SharedPreferences preferences = await SharedPreferences.getInstance();
                        preferences.setBool("isCallOngoing",false);
                        print("========================");
                        print(preferences.getBool("isCallOngoing"));
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.call,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: ()async{
                        await [Permission.microphone, Permission.camera].request();
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Calling(
                          channelName: widget.channelName,
                          token: widget.token,
                          callType: widget.callType,
                        )));
                      },
                      child: Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.call,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: scH*0.08,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
