import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mate_app/Screen/Home/TimeLine/TimeLine.dart';
import 'package:mate_app/Screen/Home/events/eventDashboard.dart';
import 'package:mate_app/Screen/Home/explore/explore.dart';
import 'package:mate_app/Widget/Drawer/DrawerWidget.dart';
import 'package:mate_app/asset/Colors/MateColors.dart';
import 'package:mate_app/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mate_app/Utility/Utility.dart' as config;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:sizer/sizer.dart';
import '../../Providers/FeedProvider.dart';
import '../../Providers/campusTalkProvider.dart';
import '../../Providers/reportProvider.dart';
import '../../Utility/Utility.dart';
import '../../audioAndVideoCalling/acceptRejectScreen.dart';
import '../chatDashboard/chatDashboard.dart';
import 'Community/campusDashboard.dart';

class HomeScreen extends StatefulWidget {
  static final String homeScreenRoute = "/home";
  final int index;
  final String feedTypeName;
  final String groupId;

  const HomeScreen({Key key, this.index = 0, this.feedTypeName="", this.groupId}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState(index);
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver{
  int _currentIndex;
  _HomeScreenState(this._currentIndex);
  String _projectVersion='';
  bool appCheckFirstTime=true;
  ReportProvider _reportProvider;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state)async{
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      print("Went to background");
    }
    if (state == AppLifecycleState.resumed){
      print("come back from  background");
      User _user =  FirebaseAuth.instance.currentUser;
      final CollectionReference collection = FirebaseFirestore.instance.collection('calling');
      DocumentSnapshot documentSnapshot = await collection.doc(_user.uid).get();
      print(documentSnapshot.data());
      if(documentSnapshot.data()!=null && documentSnapshot.data().toString().contains("callType")){
        DateTime dateTimeLocal = DateTime.now();
        DateTime dateFormatServer = new DateTime.fromMillisecondsSinceEpoch(int.parse(documentSnapshot["timestamp"].toString()));
        Duration diff = dateTimeLocal.difference(dateFormatServer);
        print(diff.inMinutes);

        SharedPreferences preferences = await SharedPreferences.getInstance();
        bool check = preferences.getBool("isCallOngoing")??false;
        print(check);
        if(diff.inMinutes<1 && check==false){
          Get.to(
              AcceptRejectScreen(
                channelName: documentSnapshot["channelName"],
                token: documentSnapshot["token"],
                callType: documentSnapshot["callType"],
                callerName: documentSnapshot["callerName"],
                callerImage: documentSnapshot["callerImage"],
              )
          );
          preferences.setBool("isCallOngoing",true);
          FirebaseFirestore.instance.collection("calling").doc(_user.uid).delete();
        }else{
          Get.snackbar('Missed call from ${documentSnapshot["callerName"]}', "",
            backgroundColor: MateColors.activeIcons,
          );
          FirebaseFirestore.instance.collection("calling").doc(_user.uid).delete();
        }
      }
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _reportProvider = Provider.of<ReportProvider>(context, listen: false);
    getConnection();
    getMateSupportGroupDetails();
    checkHasCall();
    super.initState();
    _vCode();
  }

  checkHasCall()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool("isCallOngoing",false);
    print("--------Checking call has or not----------------");
    User _user =  FirebaseAuth.instance.currentUser;
    final CollectionReference collection = FirebaseFirestore.instance.collection('calling');
    DocumentSnapshot documentSnapshot = await collection.doc(_user.uid).get();
    print(documentSnapshot.data());
    if(documentSnapshot.data()!=null && documentSnapshot.data().toString().contains("callType")){
      DateTime dateTimeLocal = DateTime.now();
      DateTime dateFormatServer = new DateTime.fromMillisecondsSinceEpoch(int.parse(documentSnapshot["timestamp"].toString()));
      Duration diff = dateTimeLocal.difference(dateFormatServer);
      print(diff.inMinutes);
      if(diff.inMinutes<1){
        Get.to(
            AcceptRejectScreen(
              channelName: documentSnapshot["channelName"],
              token: documentSnapshot["token"],
              callType: documentSnapshot["callType"],
              callerName: documentSnapshot["callerName"],
              callerImage: documentSnapshot["callerImage"],
              isGroupCall: documentSnapshot["is_group"]=="1"?true:false,
            )
        );
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setBool("isCallOngoing",true);
        FirebaseFirestore.instance.collection("calling").doc(_user.uid).delete();
      }
    }
  }

  void _vCode() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String projectVersion;
    try {
      projectVersion = packageInfo.version;
    } on PlatformException {
      projectVersion = 'Failed to get build number.';
    }
    _projectVersion = projectVersion;
    print("--------------------Version--------------------");
    print("version $_projectVersion");
    var platform = Theme.of(context).platform;
    if(platform == TargetPlatform.iOS){
      Provider.of<ReportProvider>(context, listen: false).appUpdate();
      setState(() {});
      print("check");
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _children = [
      TimeLine(),
      Explore(),
      EventDashBoard(),
      CampusDashboard(),
      ChatDashboard(),
    ];

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: config.myHexColor,statusBarBrightness: Brightness.light,
    ));

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        drawer: DrawerWidget(),
        body: Container(
          padding: EdgeInsets.only(top: 0.0.sp),
          color: myHexColor,
          child: Column(
            children: [
              Consumer<ReportProvider>(
                builder: (ctx, reportProvider, _) {
                  if (!reportProvider.appUpdateLoader && reportProvider.appUpdateModelData !=null) {
                    if(appCheckFirstTime){
                      bool willUpdate=false;
                      int storeVersion=0;
                      var platform = Theme.of(context).platform;
                      int appVersion=getExtendedVersionNumber(_projectVersion);
                      if(platform == TargetPlatform.android){
                        storeVersion=getExtendedVersionNumber(reportProvider.appUpdateModelData.data.androidVersion);
                      }else if(platform == TargetPlatform.iOS){
                        storeVersion=getExtendedVersionNumber(reportProvider.appUpdateModelData.data.iosVersion);
                      }
                      if(storeVersion>appVersion){
                        Future.delayed(Duration.zero, (){
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return WillPopScope(
                                    onWillPop: () async => false,
                                    child: CupertinoAlertDialog(
                                      title: new Text("Update your app"),
                                      content: new Text("You are using an old version of this app.\n"
                                          "Please update our app for better performance"),
                                      actions: <Widget>[
                                        CupertinoDialogAction(
                                          isDefaultAction: true,
                                          child: _reportProvider.postReportLoader?
                                          Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                            ),
                                          ):Text("Update"),
                                          onPressed: () async {
                                            StoreRedirect.redirect(iOSAppId: "1547466147");
                                          },
                                        ),
                                      ],
                                    ));
                              });
                        });
                      }
                      appCheckFirstTime=false;
                    }
                    return SizedBox();
                  }else{
                    return SizedBox();
                  }
                },
              ),
              Expanded(child: Container(child: _children[_currentIndex])),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
              border: Border(top: BorderSide(color: MateColors.darkDivider, width: 0.2)),
          ),
        child: BottomNavigationBar(
            onTap: onTabTapped,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            unselectedItemColor: MateColors.inActiveIcons,
            selectedItemColor: MateColors.activeIcons,
            items: [
              BottomNavigationBarItem(
                icon: Image.asset("lib/asset/homePageIcons/homeBlack.png",width: 18.0.sp,color: Color(0xFF414147),),
                activeIcon: Image.asset("lib/asset/homePageIcons/home.png",width: 18.0.sp,color: MateColors.activeIcons,),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Image.asset("lib/asset/iconsNewDesign/explore.png",width: 18.0.sp,color: Color(0xFF414147),),
                activeIcon: Image.asset("lib/asset/iconsNewDesign/eploreColor.png",width: 18.0.sp,color: MateColors.activeIcons,),
                label: "Explore",
              ),
              BottomNavigationBarItem(
                icon: Image.asset("lib/asset/homePageIcons/event.png",width: 18.0.sp,color: Color(0xFF414147),),
                activeIcon: Image.asset("lib/asset/homePageIcons/eventColor.png",width: 18.0.sp,color: MateColors.activeIcons,),
                label: "Events",
              ),
              BottomNavigationBarItem(
                icon: Image.asset("lib/asset/homePageIcons/cross.png",width: 24.0.sp,color: Color(0xFF414147),),
                activeIcon: Image.asset("lib/asset/homePageIcons/cross.png",width: 24.0.sp,color: MateColors.activeIcons,),
                label: "Campus",
              ),
              BottomNavigationBarItem(
                icon: Image.asset("lib/asset/homePageIcons/chat.png",width: 18.0.sp,color: Color(0xFF414147),),
                activeIcon: Image.asset("lib/asset/homePageIcons/chatColor.png",width: 18.0.sp,color: MateColors.activeIcons,),
                label: "Message",
              ),
            ])
        ),
      ));
  }

  int getExtendedVersionNumber(String version) {
    // Note that if you want to support bigger version cells than 99,
    // just increase the returned versionCells multipliers
    List versionCells = version.split('.');
    versionCells = versionCells.map((i) => int.parse(i)).toList();
    return versionCells[0] * 10000 + versionCells[1] * 100 + versionCells[2];
  }

  Widget notificationBell() {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, right: 8.0),
      child: Stack(
        children: [
          IconButton(
            icon: Icon(Icons.notifications, color: MateColors.activeIcons),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      if(_currentIndex==0){
        Provider.of<FeedProvider>(context, listen: false).fetchFeedListMyCampus(page: 1);
        Provider.of<FeedProvider>(context, listen: false).fetchFeedList(page: 1);
      }else if(_currentIndex==1){
        print("Event");
      }else if(_currentIndex==2){
        Provider.of<CampusTalkProvider>(context, listen: false).fetchCampusTalkPostList(page: 1);
      }
    });
  }
}
