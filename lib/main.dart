import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mate_app/Screen/Home/TimeLine/createFeedSelectType.dart';
import 'package:mate_app/Screen/Home/TimeLine/feed_search.dart';
import 'package:mate_app/Screen/Home/events/createEvent.dart';
import 'package:mate_app/Screen/Home/events/event_search.dart';
import 'package:mate_app/Screen/JobBoard/jobBoard.dart';
import 'package:mate_app/Screen/Login/create_profile.dart';
import 'package:mate_app/Screen/Login/login.dart';
import 'package:mate_app/Screen/Login/login_with_email.dart';
import 'package:mate_app/Screen/Login/signup_with_email.dart';
import 'package:mate_app/Screen/Login/signup_with_email_2.dart';
import 'package:mate_app/Screen/chatDashboard/new_message.dart';
import 'package:mate_app/Screen/connection/add_connection.dart';
import 'package:mate_app/Screen/connection/connection_screen.dart';
import 'package:mate_app/Screen/inviteMates/invites_mates.dart';
import 'package:mate_app/controller/theme_controller.dart';
import 'package:sizer/sizer.dart';
import 'package:mate_app/Block/ChatBlock.dart';
import 'package:mate_app/Providers/FeedProvider.dart';
import 'package:mate_app/Providers/FollowerProvider.dart';
import 'package:mate_app/Providers/StudyGroupProvider.dart';
import 'package:mate_app/Providers/UserClassProvider.dart';
import 'package:mate_app/Providers/UserProvider.dart';
import 'package:mate_app/Providers/campusTalkProvider.dart';
import 'package:mate_app/Providers/reportProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mate_app/Screen/Chat/StudyGroupsScreen.dart';
import 'package:mate_app/Screen/Class/AddAssignmentScreen.dart';
import 'package:mate_app/Screen/Class/MyClassDetailScreen.dart';
import 'package:mate_app/Screen/Class/SearchClassScreen.dart';
import 'package:mate_app/Screen/Home/Group/GroupScreen.dart';
import 'package:mate_app/Screen/Home/HomeScreen.dart';
import 'package:mate_app/Screen/Home/Seach/SearchScreen.dart';
import 'package:mate_app/Screen/Home/TimeLine/CreateFeedPost.dart';
import 'package:mate_app/Screen/Home/Mate/MateScreen.dart';
import 'package:mate_app/Screen/Login/GoogleLogin.dart';
import 'package:mate_app/Screen/Profile/FollowersScreen.dart';
import 'package:mate_app/Screen/Profile/FollowingScreen.dart';
import 'package:mate_app/Screen/Profile/ProfileEditScreen.dart';
import 'package:mate_app/Screen/Profile/ProfileScreen.dart';
import 'package:mate_app/Screen/Profile/UserProfileScreen.dart';
import 'package:mate_app/Screen/SplashScreen.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:mate_app/Utility/Utility.dart' as config;
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Providers/AuthUserProvider.dart';
import 'Providers/beAMateProvider.dart';
import 'Providers/campusLiveProvider.dart';
import 'Providers/chatProvider.dart';
import 'Providers/findAMateProvider.dart';
import 'package:overlay_support/overlay_support.dart';

import 'Screen/Home/events/eventDashboard.dart';
import 'Screen/notification/notification_screen.dart';
import 'audioAndVideoCalling/acceptRejectScreen.dart';
import 'introScreen/introScreen.dart';

///Declare global local notification instance
FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("------Remote message on background-------");
  if(message.data.isNotEmpty && message.data["title"].toString().contains("Incoming call")) {
    showNotification(message);
    await Firebase.initializeApp();
    User _user =  FirebaseAuth.instance.currentUser;
    print(_user.uid);
    var documentReference = FirebaseFirestore.instance.collection('calling').doc(_user.uid);
    Map<String, dynamic> map = {
      'channelName': message.data["channelName"],
      'token': message.data["token"],
      'callType': message.data["callType"],
      'callerName':message.data["callerName"],
      'callerImage': message.data["callerImage"],
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      'is_group' : message.data["is_group"],
    };
    FirebaseFirestore.instance.runTransaction((transaction) async {
       transaction.set(
        documentReference,
        map,
      );
    });
  }
}

void showNotification(RemoteMessage message)async{
  final sound = "push_ringtone.wav";
  ///Notification settings for android
  AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
    "notificationId",
    "notificationChannel",
    priority: Priority.max,
    importance: Importance.max,
    playSound: true,
    sound: RawResourceAndroidNotificationSound(sound.split(".").first),
    enableLights: true,
    enableVibration: true,
    fullScreenIntent: true,
  );
  ///Notification settings for ios
  DarwinNotificationDetails iosNotificationDetails = DarwinNotificationDetails(
    presentAlert: true,
    presentSound: true,
    presentBadge: true,
    sound: sound,
  );
  ///Combining both settings in one
  NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
    iOS: iosNotificationDetails,
  );
  ///Use global local notification instance and show notification
  await notificationsPlugin.show(
    message.hashCode,
    message.data["title"],
    "",
    notificationDetails,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Get.put(ThemeController());
  var loginState = prefs.getBool('login_app');
  print(loginState);

  ///Android initialization settings
  AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings("@mipmap/launcher_icon");
  ///Ios initialization settings
  DarwinInitializationSettings iosInitializationSettings = DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestCriticalPermission: true,
    requestSoundPermission: true,
  );
  ///Combining both settings in one settings
  InitializationSettings initializationSettings = InitializationSettings(
    android: androidInitializationSettings,
    iOS: iosInitializationSettings,
  );
  ///global local notification instance initialization
  bool initialized = await notificationsPlugin.initialize(initializationSettings);
  log("Notification : $initialized");

  runZonedGuarded(() {
    runApp(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          home: loginState != null ? MyApp() : IntroScreen(),)
        );
  }, (error, stackTrace) {
    print('runZonedGuarded: Caught error in my root zone.');
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
  // runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => StudyGroupProvider()),
        ChangeNotifierProvider(create: (ctx) => ChatBlock()),
        ChangeNotifierProvider(create: (ctx) => FeedProvider()),
        ChangeNotifierProvider(create: (ctx) => AuthUserProvider()),
        ChangeNotifierProvider(create: (ctx) => UserProvider()),
        ChangeNotifierProvider(create: (ctx) => FollowerProvider()),
        ChangeNotifierProvider(create: (ctx) => UserClassProvider()),
        ChangeNotifierProvider(create: (ctx) => CampusLiveProvider()),
        ChangeNotifierProvider(create: (ctx) => CampusTalkProvider()),
        ChangeNotifierProvider(create: (ctx) => FindAMateProvider()),
        ChangeNotifierProvider(create: (ctx) => BeAMateProvider()),
        ChangeNotifierProvider(create: (ctx) => ReportProvider()),
        ChangeNotifierProvider(create: (ctx) => ChatProvider()),
      ],
      child: OverlaySupport(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return OrientationBuilder(
              builder: (context, orientation) {
                SizerUtil().init(constraints, orientation);
                return GetBuilder<ThemeController>(
                  builder: (controller){
                    return GetMaterialApp(
                      navigatorKey: Get.key,
                      title: 'MATE',
                      debugShowCheckedModeBanner: false,
                      themeMode: controller.isDarkMode?ThemeMode.dark:ThemeMode.light,
                      theme: ThemeData(
                        fontFamily: 'Poppins',
                        primarySwatch: config.colorCustom,
                        accentColor: Colors.cyan,
                        visualDensity: VisualDensity.adaptivePlatformDensity,
                        scaffoldBackgroundColor: Colors.white,
                        backgroundColor: Colors.white,
                        primaryColor: Colors.white,
                        appBarTheme: AppBarTheme(
                          backgroundColor: Colors.white,
                        ),
                        bottomNavigationBarTheme: BottomNavigationBarThemeData(
                          backgroundColor: Colors.white,
                        ),
                        bottomSheetTheme: BottomSheetThemeData(
                          backgroundColor: Colors.white,
                        ),
                      ),
                      darkTheme: ThemeData(
                        fontFamily: 'Poppins',
                        primarySwatch: config.colorCustom,
                        accentColor: Colors.cyan,
                        visualDensity: VisualDensity.adaptivePlatformDensity,
                        scaffoldBackgroundColor: config.backgroundColor,
                        backgroundColor: config.backgroundColor,
                        primaryColor: config.backgroundColor,
                        appBarTheme: AppBarTheme(
                          backgroundColor: config.backgroundColor,
                        ),
                        bottomNavigationBarTheme: BottomNavigationBarThemeData(
                          backgroundColor: config.backgroundColor,
                        ),
                        bottomSheetTheme: BottomSheetThemeData(
                          backgroundColor: config.backgroundColor,
                        ),
                      ),
                      home: SplashScreen(),
                      routes: {
                        SplashScreen.splashScreenRoute: (context) => SplashScreen(),
                        HomeScreen.homeScreenRoute: (context) => HomeScreen(),
                        GoogleLogin.loginScreenRoute: (context) => GoogleLogin(),
                        StudyGroupsScreen.routeName: (context) => StudyGroupsScreen(),
                        //ChatScreen.chatScreenRoute: (context) => ChatScreen(),
                        //CommunityScreen.communityScreenRoute: (context) => CommunityScreen(),
                        GroupScreen.groupScreenRoute: (context) => GroupScreen(),
                        SearchScreen.searchScreenRoute: (context) => SearchScreen(),
                        MateScreen.mateScreenRoute: (context) => MateScreen(),
                        ProfileScreen.profileScreenRoute: (context) => ProfileScreen(),
                        ProfileEditScreen.profileEditRouteName: (context) => ProfileEditScreen(),
                        CreateFeedPost.routeName: (context) => CreateFeedPost(),
                        UserProfileScreen.routeName: (context) => UserProfileScreen(),
                        FollowersScreen.routeName: (context) => FollowersScreen(),
                        FollowingScreen.routeName: (context) => FollowingScreen(),
                        SearchClassScreen.routeName: (context) => SearchClassScreen(),
                        MyClassDetailScreen.routeName: (context) => MyClassDetailScreen(),
                        AddAssignmentScreen.routeName: (context) => AddAssignmentScreen(),
                        JobBoard.routeName: (context) => JobBoard(),
                        ConnectionScreen.routeName: (context) => ConnectionScreen(),
                        AddConnection.routeName: (context) => AddConnection(),
                        NotificationScreen.routeName: (context) => NotificationScreen(),
                        InviteMates.routeName: (context) => InviteMates(),
                        SignupWithEmail.routeName: (context) => SignupWithEmail(),
                        SignupWithEmail2.routeName: (context) => SignupWithEmail2(),
                        LoginMain.route: (context) => LoginMain(),
                        LoginWithEmail.routeName: (context) => LoginWithEmail(),
                        //CreateProfile.routeName: (context) => CreateProfile(),
                        CreateFeedSelectType.routeName: (context) => CreateFeedSelectType(),
                        EventDashBoard.routeName: (context) => EventDashBoard(),
                        CreateEvent.routeName: (context) => CreateEvent(),
                        EventSearch.routes: (context) => EventSearch(),
                        NewMessage.routeName: (context) => NewMessage(),
                        //FeedSearch.routes: (context) => FeedSearch(),
                      },
                    );
                  }
                );
              },
            );
          },
        ),
      ),
    );
  }
}

