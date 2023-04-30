import 'dart:async';
import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mate_app/Providers/AuthUserProvider.dart';
import 'package:mate_app/Providers/FeedProvider.dart';
import 'package:mate_app/Screen/Home/TimeLine/createFeedSelectType.dart';
import 'package:mate_app/Screen/Home/TimeLine/globalFeed.dart';
import 'package:mate_app/Screen/Home/studentOffer/studentOffer.dart';
import 'package:mate_app/Screen/Login/GoogleLogin.dart';
import 'package:mate_app/Screen/marketPlace/marketPlaceDashboard.dart';
import 'package:mate_app/Widget/Loaders/Shimmer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mate_app/constant.dart';
import 'package:mate_app/controller/theme_controller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../../../Model/universityListingModel.dart';
import '../../../Services/AuthUserService.dart';
import '../../../Widget/Drawer/DrawerWidget.dart';
import '../../../Widget/Home/HomeRow.dart';
import '../../../asset/Colors/MateColors.dart';
import '../HomeScreen.dart';
import '../Mate/MateScreen.dart';
import 'CreateFeedPost.dart';
import 'package:http/http.dart' as http;

class TimeLine extends StatefulWidget {
  static final String timeLineScreenRoute = '/timeline';
  String id;
  String searchKeyword;
  bool isFollowingFeeds;
  String userId;
  TimeLine({this.searchKeyword, this.id, this.isFollowingFeeds, this.userId});

  @override
  _TimeLineState createState() => _TimeLineState();
}

class _TimeLineState extends State<TimeLine> with TickerProviderStateMixin{
  ScrollController _scrollController;
  int _pageMyCampus;
  ThemeController themeController = Get.find<ThemeController>();
  int universityId = 0;
  int _selectedIndex = 0;
  int segmentedControlValue = 0;
  bool isGlobalFeed=false;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  FeedProvider feedProvider;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getUniversityListing();
    print(Provider.of<AuthUserProvider>(context, listen: false).authUser.universityId);
    feedProvider = Provider.of<FeedProvider>(context,listen: false);
    universityId = Provider.of<AuthUserProvider>(context, listen: false).authUser.universityId??0;
    Future.delayed(Duration(milliseconds: 600), (){
      if (widget.id == null) {
        Provider.of<FeedProvider>(context, listen: false).fetchFeedListMyCampus(page: 1, feedId: widget.id);
      }else {
        Provider.of<FeedProvider>(context, listen: false).fetchFeedList(page: 1, feedId: widget.id);
      }
    });
    _pageMyCampus =1;
    _scrollController = new ScrollController()..addListener(_scrollListener);
    checkEula();
  }

  checkEula()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool val = preferences.getBool('home')??false;
    if(val==false){
      showEulaPopup(context, "home");
    }
  }

  String token;
  AuthUserService authUserService = AuthUserService();
  getUniversityListing()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token");
    universityList = await authUserService.getUniversityList(token: token);
    print(universityList);
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
  }

  List<Datum> universityList = [];
  String universityIdDropDown;
  TextEditingController universityController = TextEditingController();

  void _scrollListener() {
    if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      if (!isScrollingDown) {
        isScrollingDown = true;
        _showAppbar = false;
        setState(() {});
      }
    }
    if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
      if (isScrollingDown) {
        isScrollingDown = false;
        _showAppbar = true;
        setState(() {});
      }
    }

    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels != 0) {
        Future.delayed(Duration.zero,(){
          _pageMyCampus += 1;
          print('scrolled to bottom page is now $_pageMyCampus');
          Provider.of<FeedProvider>(context, listen: false).fetchFeedListMyCampus(page: _pageMyCampus, feedId: widget.id, paginationCheck: true, isFollowingFeeds: widget.isFollowingFeeds, userId: widget.userId );
        });
      }
    }
  }

  final audioPlayer = AudioPlayer();

  Future<void> startAudio(String url,int index) async {
    print(url);
    print(index);
    print(feedProvider.feedListMyCampus[index].isPaused);
    if(feedProvider.feedListMyCampus[index].isPaused==true){
      for(int i=0;i<feedProvider.feedListMyCampus.length;i++){
        feedProvider.feedListMyCampus[i].isPlaying = false;
      }
      feedProvider.feedListMyCampus[index].isPaused = false;
      audioPlayer.play();
      setState(() {
        feedProvider.feedListMyCampus[index].isPlaying = true;
      });
      audioPlayer.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          setState(() {
            feedProvider.feedListMyCampus[index].isPlaying = false;
            feedProvider.feedListMyCampus[index].isPaused = false;
          });
        }
      });

      audioPlayer.positionStream.listen((event) {
        setState(() {
         // currentDuration = event;
        });
      });

    }else{
      try{
        audioPlayer.playerStateStream.listen((state) {
          if (state.processingState == ProcessingState.completed) {
            setState(() {
              feedProvider.feedListMyCampus[index].isPlaying = false;
              feedProvider.feedListMyCampus[index].isPaused = false;
            });
          }
        });

        audioPlayer.positionStream.listen((event) {
          setState(() {
            //currentDuration = event;
          });
        });

        audioPlayer.stop();
        for(int i=0;i<feedProvider.feedListMyCampus.length;i++){
          feedProvider.feedListMyCampus[i].isPlaying = false;
        }
        setState(() {});

        var dir = await getApplicationDocumentsDirectory();
        var filePathAndName = dir.path + "/audios/" +url.split("/").last + ".mp3";
        if(File(filePathAndName).existsSync()){
          print("------File Already Exist-------");
          print(filePathAndName);
          await audioPlayer.setFilePath(filePathAndName);
          audioPlayer.play();
          setState(() {
            feedProvider.feedListMyCampus[index].isPlaying = true;
          });
        }else{
          setState(() {
            feedProvider.feedListMyCampus[index].isLoadingAudio = true;
          });

          String path = await downloadAudio(url);

          setState(() {
            feedProvider.feedListMyCampus[index].isLoadingAudio = false;
          });

          if(path !=""){
            await audioPlayer.setFilePath(path);
            audioPlayer.play();
            setState(() {
              feedProvider.feedListMyCampus[index].isPlaying = true;
            });
          }else{
            Fluttertoast.showToast(msg: "Something went wrong while playing audio please try again!", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
          }
        }

      }catch(e){
        print("Error loading audio source: $e");
      }
    }
  }

  void pauseAudio(int index)async{
    audioPlayer.pause();
    setState(() {
      feedProvider.feedListMyCampus[index].isPlaying = false;
      feedProvider.feedListMyCampus[index].isPaused = true;
    });
  }

  Future<String> downloadAudio(String url)async{
    var dir = await getApplicationDocumentsDirectory();
    var firstPath = dir.path + "/audios";
    var filePathAndName = dir.path + "/audios/" +url.split("/").last + ".mp3";
    await Directory(firstPath).create(recursive: true);
    File file = new File(filePathAndName);
    try{
      var request = await http.get(Uri.parse(url));
      print(request.statusCode);
      var res = await file.writeAsBytes(request.bodyBytes);
      print("---File Path----");
      print(res.path);
      return res.path;
    }catch(e){
      print(e);
      return "";
    }
  }

  bool _showAppbar = true;
  bool isScrollingDown = false;

  @override
  Widget build(BuildContext context) {
    final scH = MediaQuery.of(context).size.height;
    final scW = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _key,
      endDrawer: DrawerWidget(),
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
            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              height: _showAppbar ? 360 : 120,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: scH*0.06,
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 16,top: 5,left: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on_sharp,
                                size: 25,
                                color: themeController.isDarkMode?Colors.white:Colors.black,
                              ),
                              Consumer<AuthUserProvider>(
                                builder: (ctx, data1, _){
                                  return  Container(
                                    width: scW*0.55,
                                    child: Theme(
                                      data: ThemeData(
                                        textTheme: TextTheme(
                                          subtitle1: TextStyle(
                                            color: themeController.isDarkMode?Colors.white:Colors.black,
                                          ),
                                        ),
                                      ),
                                      child: DropdownSearch<Datum>(
                                        mode: Mode.MENU,
                                        showSelectedItems: false,
                                        popupBackgroundColor: themeController.isDarkMode?Color(0xFF2a3b4b).withOpacity(0.9):Color(0xFFe8f8f5),
                                        dropdownButtonProps: IconButtonProps(
                                          icon: Icon(Icons.keyboard_arrow_down_sharp,size: 0),
                                          color: themeController.isDarkMode?MateColors.iconDark:MateColors.iconLight,
                                        ),
                                        searchFieldProps: TextFieldProps(
                                          cursorColor: themeController.isDarkMode?Colors.white:Colors.black,
                                          decoration: InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                width: 1,
                                                color: themeController.isDarkMode?Colors.white:Colors.black,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                width: 1,
                                                color: themeController.isDarkMode?Colors.white:Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                        dropdownBuilder: (context,data){
                                          return Padding(
                                            padding: const EdgeInsets.only(left: 16),
                                            child: Text(data1.authUser.university,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'Poppins',
                                                color: themeController.isDarkMode?Colors.white.withOpacity(0.7):Colors.black.withOpacity(0.7),
                                              ),
                                            ),
                                          );
                                        },
                                        showSearchBox: true,
                                        items: universityList,
                                        itemAsString: (Datum u) => u.name,
                                        dropdownSearchDecoration: InputDecoration(
                                          hintText: data1.authUser.university,
                                          hintStyle: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.1,
                                            color: themeController.isDarkMode?Colors.white:Colors.black,
                                          ),
                                          border: InputBorder.none,
                                        ),
                                        onChanged: (value)async{
                                          universityController.text = value.name;
                                          for(int i=0;i<universityList.length;i++){
                                            if(universityList[i].name == value.name){
                                              universityIdDropDown = universityList[i].id.toString();
                                            }
                                          }
                                          print(universityIdDropDown);
                                          setState(() {});
                                          String response = await authUserService.updateUserProfile(
                                            firstName: data1.authUser.firstName,
                                            lastName: data1.authUser.lastName,
                                            displayName: data1.authUser.displayName,
                                            universityId: universityIdDropDown,
                                            token: token,
                                          );
                                          if(response=="User profile updated."){
                                            await Provider.of<AuthUserProvider>(context, listen: false).getUserProfileData(saveToSharedPref: true);
                                            setState(() {
                                              isLoading = false;
                                            });
                                            Fluttertoast.showToast(msg: "University updated successfully", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
                                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen(index: 0,)));
                                          }else{
                                            setState(() {
                                              isLoading = false;
                                            });
                                            Fluttertoast.showToast(msg: "Something went wrong", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
                                          }
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Get.to(CreateFeedSelectType());
                              },
                              child: Container(
                                height: 48,
                                width: 48,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                                ),
                                child: Icon(Icons.add,color: MateColors.blackTextColor,size: 28),
                              ),
                            ),
                            Selector<AuthUserProvider, String>(
                                selector: (ctx, authUserProvider) => authUserProvider.authUserPhoto,
                                builder: (ctx, data, _) {
                                  return Padding(
                                    padding:  EdgeInsets.only(left: 12.0.sp),
                                    child: InkWell(
                                        onTap: () {
                                          _key.currentState.openEndDrawer();
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: MateColors.activeIcons,
                                          radius: 20,
                                          child: CircleAvatar(
                                            backgroundColor: Colors.transparent,
                                            radius: 20,
                                            backgroundImage: NetworkImage(data),
                                          ),
                                        )
                                    ),
                                  );
                                }),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if(_showAppbar)
                  Padding(
                    padding: const EdgeInsets.only(left: 16,top: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Selector<AuthUserProvider, String>(
                            selector: (ctx, authUserProvider) =>
                            authUserProvider.authUser.displayName,
                            builder: (ctx, data, _) {
                              return Text(
                                  "Hello $data! ☺️",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w600,
                                    overflow: TextOverflow.ellipsis,
                                    color: themeController.isDarkMode?Colors.white:Colors.black,
                                  ));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  if(_showAppbar)
                  Padding(
                    padding: EdgeInsets.only(left: 16,right: 16,top: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Selector<AuthUserProvider, String>(
                          selector: (ctx, authUserProvider) => authUserProvider.authUserPhoto,
                          builder: (ctx, data, _) {
                            return Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(data),
                                ),
                              ),
                            );
                          },
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: (){
                              Navigator.of(context).pushNamed(CreateFeedPost.routeName);
                            },
                            child: Container(
                              margin: EdgeInsets.only(left: 16),
                              height: 60,
                              width: MediaQuery.of(context).size.width*0.7,
                              decoration: BoxDecoration(
                                color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: EdgeInsets.only(left: 16,right: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Share what you want",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: scW*0.035,
                                      color: themeController.isDarkMode?MateColors.helpingTextDark:Colors.black.withOpacity(0.72),
                                    ),
                                  ),
                                  SizedBox(),
                                  Container(
                                    height: 36,
                                    width: 36,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: themeController.isDarkMode?MateColors.bottomSheetItemBackgroundDark:MateColors.containerLight,
                                    ),
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset(
                                        "lib/asset/iconsNewDesign/gallery.png",
                                        color: themeController.isDarkMode?Colors.white:MateColors.blackText,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 36,
                                    width: 36,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: themeController.isDarkMode?MateColors.bottomSheetItemBackgroundDark:MateColors.containerLight,
                                    ),
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset(
                                        "lib/asset/iconsNewDesign/mic.png",
                                        color: themeController.isDarkMode?Colors.white:MateColors.blackText,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if(_showAppbar)
                  Padding(
                    padding: const EdgeInsets.only(left: 16,right: 16,top: 20,bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.to(()=>GlobalFeed());
                          },
                          child: Container(
                            height: 92,
                            width: MediaQuery.of(context).size.width*0.21,
                            decoration: BoxDecoration(
                              color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.only(top: 12,bottom: 12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: themeController.isDarkMode?MateColors.textFieldSearchDark:Color(0xFF049571),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Image.asset('lib/asset/iconsNewDesign/global.png'),
                                  ),
                                ),
                                Text('Global Feed',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w500,
                                    overflow: TextOverflow.ellipsis,
                                    color: themeController.isDarkMode?Colors.white:Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(()=>MateScreen());
                          },
                          child: Container(
                            height: 92,
                            width: MediaQuery.of(context).size.width*0.21,
                            decoration: BoxDecoration(
                              color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.only(top: 12,bottom: 12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: themeController.isDarkMode?MateColors.textFieldSearchDark:Color(0xFF64ADF0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Image.asset('lib/asset/iconsNewDesign/jobBoard.png'),
                                  ),
                                ),
                                Text('Job Board',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w500,
                                    overflow: TextOverflow.ellipsis,
                                    color: themeController.isDarkMode?Colors.white:Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(()=>MarketPlaceDashboard());
                          },
                          child: Container(
                            height: 92,
                            width: MediaQuery.of(context).size.width*0.21,
                            decoration: BoxDecoration(
                              color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.only(top: 12,bottom: 12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: themeController.isDarkMode?MateColors.textFieldSearchDark:Color(0xFFFFA6A6),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Image.asset('lib/asset/iconsNewDesign/marketPlace.png',color: Colors.white,),
                                  ),
                                ),
                                Text('Marketplace',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w500,
                                    overflow: TextOverflow.ellipsis,
                                    color: themeController.isDarkMode?Colors.white:Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(()=>StudentOffer());
                          },
                          child: Container(
                            height: 92,
                            width: MediaQuery.of(context).size.width*0.21,
                            decoration: BoxDecoration(
                              color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.only(top: 12,bottom: 12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: themeController.isDarkMode?MateColors.textFieldSearchDark:Color(0xFFCB89FF),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Image.asset('lib/asset/iconsNewDesign/studentOffer.png'),
                                  ),
                                ),
                                Text('Student Offers',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w500,
                                    overflow: TextOverflow.ellipsis,
                                    color: themeController.isDarkMode?Colors.white:Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Consumer<FeedProvider>(
                builder: (ctx, feedProvider, _) {
                  if (feedProvider.feedLoader && feedProvider.feedListMyCampus.length == 0) {
                    return timelineLoader();
                  }
                  if (feedProvider.error != '') {
                    if(feedProvider.error.contains("Your session has expired")){
                      Future.delayed(Duration.zero,(){
                        Provider.of<AuthUserProvider>(context, listen: false).logout();
                        feedProvider.error='';
                        Navigator.of(context).pushNamedAndRemoveUntil(GoogleLogin.loginScreenRoute, (Route<dynamic> route) => false);
                      });
                      Fluttertoast.showToast(msg: " ${feedProvider.error} ", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
                    }
                    return Center(
                      child: Container(
                        color: Colors.red,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${feedProvider.error}',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  }
                  return feedProvider.feedListMyCampus.length == 0 ?
                  Center(
                    child: Text(
                      'Nothing new',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                        letterSpacing: 0.1,
                        color: themeController.isDarkMode?Colors.white:Colors.black,
                      ),
                    ),
                  ):
                  RefreshIndicator(
                    onRefresh: () {
                      if (widget.id == null) {
                        _pageMyCampus=1;
                        return feedProvider.fetchFeedListMyCampus(page: 1, feedId: widget.id);
                      }else{
                        _pageMyCampus=1;
                        return feedProvider.fetchFeedList(page: 1, isFollowingFeeds: widget.isFollowingFeeds, userId: widget.userId);
                      }
                    },
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: widget.userId!=null?feedProvider.feedItemListOfUser.length:feedProvider.feedListMyCampus.length,
                      itemBuilder: (_, index) {
                        var feedItem = widget.userId!=null?feedProvider.feedItemListOfUser[index]:feedProvider.feedListMyCampus[index];
                        return Visibility(
                          visible: widget.searchKeyword!=null? widget.searchKeyword!=""? feedItem.title.toLowerCase().contains(widget.searchKeyword.toLowerCase()):false : true,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: HomeRow(
                              previousPageUserId:widget.userId,
                              id: feedItem.id,
                              feedId: feedItem.feedId,
                              title: feedItem.title,
                              feedType: feedItem.feedTypes,
                              start: feedItem.start,
                              end: feedItem.end,
                              calenderDate: feedItem.feedCreatedAt,
                              description: feedItem.description,
                              created: feedItem.created,
                              user: feedItem.user,
                              location: feedItem.location,
                              hyperlinkText: feedItem.hyperlinkText,
                              hyperlink: feedItem.hyperlink,
                              media: feedItem.media,
                              isLiked: feedItem.isLiked,
                              liked: feedItem.isLiked!=null?true:false,
                              bookMarked: feedItem.isBookmarked,
                              isFollowed: feedItem.isFollowed??false,
                              likeCount: feedItem.likeCount,
                              bookmarkCount: feedItem.bookmarkCount,
                              shareCount: feedItem.shareCount,
                              commentCount: feedItem.commentCount,
                              isShared: feedItem.isShared,
                              indexVal: index,
                              pageType : "TimeLineMyCampus",
                              mediaOther: feedItem.mediaOther,
                              isPlaying: feedItem.isPlaying,
                              isPaused: feedItem.isPaused,
                              isLoadingAudio: feedItem.isLoadingAudio,
                              startAudio: startAudio,
                              pauseAudio: pauseAudio,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}