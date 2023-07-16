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
  final bool? isGroupCall;
  const AcceptRejectScreen({Key? key, required this.channelName, required this.token, required this.callType, required this.callerImage, required this.callerName, this.isGroupCall}) : super(key: key);

  @override
  State<AcceptRejectScreen> createState() => _AcceptRejectScreenState();
}

class _AcceptRejectScreenState extends State<AcceptRejectScreen> with SingleTickerProviderStateMixin{
  ThemeController themeController = Get.find<ThemeController>();
  late AnimationController _controller;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      lowerBound: 0.5,
      duration: Duration(seconds: 3),
    )..repeat();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final scH = MediaQuery.of(context).size.height;
    final scW = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
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
                padding: EdgeInsets.only(top: scH*0.13),
                child: Text(
                  widget.callType,
                  style: TextStyle(
                    color: themeController.isDarkMode?Colors.white:MateColors.blackText,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
                    fontSize: 17.0,
                  ),
                ),
              ),
              SizedBox(
                height: scH*0.15,
              ),
              Expanded(
                child: AnimatedBuilder(
                  animation: CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
                  builder: (context, child) {
                    return Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        _buildContainer(150 * _controller.value),
                        _buildContainer(200 * _controller.value),
                        _buildContainer(250 * _controller.value),
                        _buildContainer(300 * _controller.value),
                        Align(
                          child: CachedNetworkImage(
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
                        ),
                        //Align(child: Icon(Icons.phone_android, size: 44,)),
                      ],
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: scH*0.03),
                child: Text(
                  widget.callerName,
                  style: TextStyle(
                    color: themeController.isDarkMode?Colors.white:MateColors.blackText,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Poppins',
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
                          name: widget.callerName,
                          image: widget.callerImage,
                          isGroupCall: widget.isGroupCall!,
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
  Widget _buildContainer(double radius) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: themeController.isDarkMode?
        Colors.grey.withOpacity(1 - _controller.value):
        Colors.white30.withOpacity(1 - _controller.value),
      ),
    );
  }
}
