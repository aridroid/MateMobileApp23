import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
//import 'package:googleapis/content/v2_1.dart';
import 'package:mate_app/Providers/AuthUserProvider.dart';
import 'package:mate_app/Screen/Home/HomeScreen.dart';
import 'package:mate_app/Screen/Login/GoogleLogin.dart';
import 'package:mate_app/groupChat/services/dynamicLinkService.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mate_app/Utility/Utility.dart' as config;
import 'package:provider/provider.dart';
import 'package:mate_app/asset/Colors/MateColors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../audioAndVideoCalling/acceptRejectScreen.dart';
import '../groupChat/pages/groupDetailsBeforeJoining.dart';
import '../main.dart';
import 'package:intl/intl.dart' as intl;

class SplashScreen extends StatefulWidget {
  static final String splashScreenRoute = "/splash";
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>{


  String groupId;

  // FirebaseMessaging _firebaseMessaging;
  @override
  void initState() {
    super.initState();
    // _firebaseMessaging = FirebaseMessaging();
    // _firebaseMessaging.requestNotificationPermissions(
    //     const IosNotificationSettings(sound: true, badge: true, alert: true)
    // );

    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    notificationData();
    initDynamicLinks();

    // WidgetsBinding.instance.addPostFrameCallback((_) => _attemptAutoLogin(context));
  }


  ///notification process
  void notificationData()async{
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async{
       //showSimpleNotification(Text(message.toString()),duration: Duration(seconds: 2),background: MateColors.activeIcons
      // ,autoDismiss: false,slideDismissDirection: DismissDirection.endToStart);
      print("------Remote message when app is open-------");
      print(message.data);
      if(message.data.isNotEmpty && message.data["title"].toString().contains("Incoming call")){
        SharedPreferences preferences = await SharedPreferences.getInstance();
        bool check = preferences.getBool("isCallOngoing")??false;
        print(check);
        if(check==false){
          showNotification(message);
          Get.to(
              AcceptRejectScreen(
                channelName: message.data["channelName"],
                token: message.data["token"],
                callType: message.data["callType"],
                callerName: message.data["callerName"],
                callerImage: message.data["callerImage"],
              )
          );
          preferences.setBool("isCallOngoing",true);
        }else{
          Get.snackbar('Missed call from ${message.data["callerName"]}', "",
            backgroundColor: MateColors.activeIcons,
          );
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          //   content: Text('Missed call from ${message.data["callerName"]}'),
          //   duration: Duration(seconds: 5),
          // ));
        }
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("------Remote message on message click-------");
      print(message.data);
      // if(message.data.isNotEmpty && message.data["title"].toString().contains("Incoming call")){
      //   Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
      //       AcceptRejectScreen(
      //         channelName: message.data["channelName"],
      //         token: message.data["token"],
      //         callType: message.data["callType"],
      //         callerName: message.data["callerName"],
      //         callerImage: message.data["callerImage"],
      //       )
      //   ));
      // }
    });

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage message){
    //   print("------Remote message when app open first time-------");
    //   //print(message.data);
    //   if(message.data.isNotEmpty && message.data["title"].toString().contains("Incoming call")){
    //     Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
    //         AcceptRejectScreen(
    //           channelName: message.data["channelName"],
    //           token: message.data["token"],
    //           callType: message.data["callType"],
    //           callerName: message.data["callerName"],
    //           callerImage: message.data["callerImage"],
    //         )
    //     ));
    //   }
    // });

    // FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage message){
    //   print("------Remote message when app open first time-------");
    //   //print(message.data);
    //   if(message.data.isNotEmpty && message.data["title"].toString().contains("Incoming call")){
    //     Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
    //         AcceptRejectScreen(
    //           channelName: message.data["channelName"],
    //           token: message.data["token"],
    //           callType: message.data["callType"],
    //           callerName: message.data["callerName"],
    //           callerImage: message.data["callerImage"],
    //         )
    //     ));
    //   }
    // });

    // _firebaseMessaging.configure(onMessage: (Map<dynamic, dynamic> message) async{
    //   print("notification $message");
    //   // showSimpleNotification(Text(message.toString()),duration: Duration(seconds: 2),background: MateColors.activeIcons
    //   // ,autoDismiss: false,slideDismiss: true);
    // }/*,onBackgroundMessage: myBackgroundMessageHandler*/,
    //     onLaunch: (Map<dynamic, dynamic> message) async{
    //   print("notification onLaunch $message");
    // },onResume: (Map<dynamic, dynamic> message) async{
    //   print("notification onResume $message");
    // });
  }

  ///Retreive dynamic link firebase.
  void initDynamicLinks() async {
    try{
      final PendingDynamicLinkData data =
      await FirebaseDynamicLinks.instance.getInitialLink();
      final Uri deepLink = data.link;

      if (deepLink != null) {
        handleDynamicLink(deepLink);
      }
    }catch(ex){
      print(ex);
      _attemptAutoLogin(context);
    }


    // FirebaseDynamicLinks.instance.onLink(
    //     onSuccess: (PendingDynamicLinkData dynamicLink) async {
    //       final Uri deepLink = dynamicLink.link;
    //
    //       if (deepLink != null) {
    //         handleDynamicLink(deepLink);
    //       }
    //     }, onError: (OnLinkErrorException e) async {
    //   print(e.message);
    //   _attemptAutoLogin(context);
    // });

    FirebaseDynamicLinks.instance.onLink.listen((dynamicLink) {
      final Uri deepLink = dynamicLink.link;
      if (deepLink != null) {
        handleDynamicLink(deepLink);
      }
    }).onError((error) {
      print('onLink error');
      print(error.message);
      _attemptAutoLogin(context);
    });
  }

  handleDynamicLink(Uri url) {
    List<String> separatedString = [];
    separatedString.addAll(url.path.split('/'));
    print("hello sibasis its ${url.path}");
    if (separatedString[1] == "group") {
    print("hello sibasis its0 ${url.path}");
      groupId=separatedString[2];
      isDynamicLinkHit=true;
      //from here changing
      //_attemptAutoLogin(context,pageIndex: 3);
      Provider.of<AuthUserProvider>(context, listen: false).autoLogin().then((value) async {
      if (value) {
        print('autologin attempt was fine');
        var res = await Get.to(GroupDetailsBeforeJoining(groupId: groupId,));
        //navigatorKey.currentState.push(MaterialPageRoute(builder: (context)=>GroupDetailsBeforeJoining(groupId: groupId,)));
        if(res!=null && ModalRoute.of(context).isCurrent){
          Timer(Duration(seconds: 1), () async {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen(groupId: groupId, index: 0,)));
          });
        }
      }else{
        print('autologin attempt false');
        Navigator.of(context).pushReplacementNamed(GoogleLogin.loginScreenRoute);
      }
    });
    }else if(separatedString[1] == "campus"){
      isDynamicLinkHit=true;
      Provider.of<AuthUserProvider>(context, listen: false).autoLogin().then((value) async {
        if (value) {
          print('autologin attempt was fine');
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen(index: 2,)));
          //var res = await Get.to(GroupDetailsBeforeJoining(groupId: groupId,));
          //navigatorKey.currentState.push(MaterialPageRoute(builder: (context)=>GroupDetailsBeforeJoining(groupId: groupId,)));
          // if(res!=null && ModalRoute.of(context).isCurrent){
          //   Timer(Duration(seconds: 1), () async {
          //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen(groupId: groupId, index: 0,)));
          //   });
          // }
        }else{
          print('autologin attempt false');
          Navigator.of(context).pushReplacementNamed(GoogleLogin.loginScreenRoute);
        }
      });
    }
  }

  void _attemptAutoLogin(BuildContext ctx,{pageIndex=0}) async {

    Provider.of<AuthUserProvider>(ctx, listen: false).autoLogin().then((value) {
      if (value) {
        print('autologin attempt was fine');
        Navigator.of(ctx).push(MaterialPageRoute(builder: (context) => HomeScreen(groupId: groupId, index: pageIndex,)));
        // Navigator.of(ctx).push(MaterialPageRoute(builder: (context) => FeedDetailsScreen(feedId: 111,)));
        // Navigator.of(ctx).push(MaterialPageRoute(builder: (context) => CampusLiveDetailsScreen(postId: 206,)));
        // Navigator.of(ctx).push(MaterialPageRoute(builder: (context) => CampusTalkDetailsPage(talkId: 5,)));
      } else {
        print('autologin attempt false');
        Navigator.of(ctx).pushReplacementNamed(GoogleLogin.loginScreenRoute);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //_attemptAutoLogin(context);

    // Future.delayed(Duration(seconds: 2), () {
    //   // 5s over, navigate to a new page
    //
    // ignore: todo
    //   //TODO::update following check
    //   var authUserProvider = Provider.of<AuthUserProvider>(context, listen: false);
    //
    //   if(authUserProvider.authUser != null){
    //     //Navigator.of(context).pushNamed(HomeScreen.HomeScreenRoute);
    //     Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
    //   }else{
    //     Navigator.of(context).pushNamed(GoogleLogin.LoginScreenRoute);
    //   }
    // });

    return Scaffold(
      body: Container(
        color: config.myHexColor,
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Image.asset(
                "lib/asset/logo.png",
                //color: Colors.white,
                width: 200,
                height: 200,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(28.0),
              child: Text(
                "MATE",
                style: TextStyle(
                    fontFamily: "Opensans",
                    fontSize: 45.0,
                    fontWeight: FontWeight.w500,
                    color: MateColors.activeIcons),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async{
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
    print("data");
    print(data);
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
    print("notification");
    print(notification);

  }

  // Or do other work.
}

