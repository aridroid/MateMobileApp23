import 'dart:developer';
import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:intl/intl.dart';
import 'package:mate_app/Model/eventListingModel.dart';
import 'package:mate_app/Screen/Home/events/eventDetails.dart';
import 'package:mate_app/Screen/Home/events/event_search.dart';
import 'package:mate_app/Screen/Home/events/memberList.dart';
import 'package:mate_app/Services/eventService.dart';
import 'package:mate_app/Widget/video_thumbnail.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Model/eventCateoryModel.dart';
import '../../../Providers/AuthUserProvider.dart';
import '../../../Providers/FeedProvider.dart';
import '../../../Widget/Loaders/Shimmer.dart';
import '../../../Widget/mediaViewer.dart';
import '../../../asset/Colors/MateColors.dart';
import '../../../controller/theme_controller.dart';
import 'package:googleapis/calendar/v3.dart' as gCal;
import '../../Profile/ProfileScreen.dart';
import '../../Profile/UserProfileScreen.dart';
import '../../Report/reportPage.dart';
import '../../chat1/screens/chat.dart';
import 'createEvent.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'editEvent.dart';

class EventDashBoard extends StatefulWidget {
  static final String routeName = '/eventDashboard';

  @override
  _EventDashBoardState createState() => _EventDashBoardState();
}

class _EventDashBoardState extends State<EventDashBoard> with TickerProviderStateMixin {
  ThemeController themeController = Get.find<ThemeController>();
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  String token = "";
  EventService _eventService = EventService();
  ScrollController _scrollController;

  List<Result> list = [];
  List<bool> isBookMark = [];
  List<String> reaction = [];
  Future<EventListingModel> future;
  int page = 1;
  bool enableFutureBuilder = false;
  bool doingPagination = false;

  List<Result> listLocal = [];
  List<bool> isBookMarkLocal = [];
  List<String> reactionLocal = [];
  Future<EventListingModel> futureLocal;
  int pageLocal = 1;
  bool enableFutureBuilderLocal = false;
  bool doingPaginationLocal = false;

  ClientId _credentials;
  auth.User _currentUser = auth.FirebaseAuth.instance.currentUser;
  bool refreshPageOnBottomClick = false;
  FeedProvider feedProvider;

  List<String> filterDate = ['Today','This Week','This Month'];
  String filterDateValue = "";
  String filterDateValueApi = "";
  List<String> filterLocation = ['On Campus','Off Campus','Virtual'];
  String filterLocationValue = "";
  String filterLocationValueApi = "";
  EventCategoryModel eventCategoryModel;
  List<String> filterType = [];
  List<int> categoryId = [];
  String filterTypeValue = "";
  int filterTypeValueApi = 0;

  @override
  void didUpdateWidget(covariant EventDashBoard oldWidget) {
    print("Did update widget is calling");
    setState(() {
      refreshPageOnBottomClick = true;
    });
    getStoredValue();
    _scrollController = new ScrollController()..addListener(_scrollListener);
    if (Platform.isAndroid) {
      _credentials = new ClientId("237545926078-9biln72s9c5h9vot53l84me39unhhnbf.apps.googleusercontent.com", "");
    } else if (Platform.isIOS) {
      _credentials = new ClientId("237545926078-99q5c35ugs0b49spmhf1ru0ghie7opnp.apps.googleusercontent.com", "");
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
    feedProvider = Provider.of<FeedProvider>(context, listen: false);
    getStoredValue();
    _scrollController = new ScrollController()..addListener(_scrollListener);
    if (Platform.isAndroid) {
      _credentials = new ClientId("237545926078-9biln72s9c5h9vot53l84me39unhhnbf.apps.googleusercontent.com", "");
    } else if (Platform.isIOS) {
      _credentials = new ClientId("237545926078-99q5c35ugs0b49spmhf1ru0ghie7opnp.apps.googleusercontent.com", "");
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels != 0) {
        print("//////////////Event Fetching////////////////");
        Future.delayed(Duration.zero, () {
          page += 1;
          setState(() {
            doingPagination = true;
          });
          print('scrolled to bottom page is now $page');
          future = _eventService.getEventListing(page: page, filterDate: filterDateValueApi,filterLocation: filterLocationValueApi,filterType: filterTypeValueApi,token: token);
          future.then((value) {
            setState(() {
              enableFutureBuilder = true;
            });
          });
        });
      }
    }
  }
  getStoredValue() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token");
    getTypeListing();
    print('///////////////////////////');
    log(token);
    print('///////////////////////////');

    setState(() {
      doingPagination = false;
      page = 1;
    });

    future = _eventService.getEventListing(page: page, filterDate: filterDateValueApi,filterLocation: filterLocationValueApi,filterType: filterTypeValueApi,token: token);
    future.then((value) {
      setState(() {
        enableFutureBuilder = true;
      });
    });

    setState(() {
      refreshPageOnBottomClick = false;
    });
  }

  getTypeListing()async{
    eventCategoryModel = await _eventService.getCategory(token: token);
    for(int i=0;i<eventCategoryModel.data.length;i++){
      categoryId.add(eventCategoryModel.data[i].id);
      filterType.add(eventCategoryModel.data[i].name);
    }
    setState(() {});
  }

  void changeBookmark(int index) {
    isBookMark[index] = !isBookMark[index];
    setState(() {});
  }

  void changeReaction(int index, String value) {
    reaction[index] = value;
    setState(() {});
  }

  void changeCommentCount(int index, bool increment) {
    increment ?
    list[index].commentsCount = list[index].commentsCount + 1 :
    list[index].commentsCount = list[index].commentsCount - 1;
    setState(() {});
  }

  void changeFollowUnfollow(int index, bool value) {
    list[index].isFollowed = value;
    setState(() {});
  }

  refreshPage() async {
    setState(() {
      page = 1;
    });
    future = _eventService.getEventListing(page: page, filterDate: filterDateValueApi,filterLocation: filterLocationValueApi,filterType: filterTypeValueApi,token: token);
    future.then((value) {
      setState(() {
        doingPagination = false;
        Future.delayed(Duration.zero, () {
          enableFutureBuilder = true;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final scH = MediaQuery.of(context).size.height;
    final scW = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _key,
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
            SizedBox(
              height: scH*0.07,
            ),
            Center(
              child: Text(
                "Events",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: themeController.isDarkMode ? MateColors.whiteText : MateColors.blackText,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                          return EventSearch(isLocal: false,);
                        },),);
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 16),
                        height: 60,
                        decoration: BoxDecoration(
                          color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.only(left: 16, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Search here...",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                color: themeController.isDarkMode?MateColors.helpingTextDark:Colors.black.withOpacity(0.72),
                              ),
                            ),
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: themeController.isDarkMode?MateColors.textFieldSearchDark:MateColors.textFieldSearchLight,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Image.asset(
                                  "lib/asset/iconsNewDesign/search.png",
                                  color: themeController.isDarkMode?Colors.white:MateColors.blackText,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16,),
                  InkWell(
                    onTap: () async {
                      await Navigator.of(context).pushNamed(CreateEvent.routeName);
                      getStoredValue();
                    },
                    child: Container(
                      height: 60,
                      width: 60,
                      margin: EdgeInsets.only(right: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                      ),
                      child: Icon(Icons.add, color: MateColors.blackTextColor, size: 28),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 70,
              margin: EdgeInsets.only(top: 10,left: 0,),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: 3,
                itemBuilder: (context,index){
                  if(index==0){
                    return Container(
                      width: 260,
                      child: Theme(
                        data: ThemeData(
                          textTheme: TextTheme(
                            subtitle1: TextStyle(
                              color: themeController.isDarkMode?Colors.white:Colors.black,
                            ),
                          ),
                        ),
                        child: DropdownSearch<String>(
                          mode: Mode.MENU,
                          showSelectedItems: false,
                          popupShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          maxHeight: 170,
                          popupBackgroundColor: themeController.isDarkMode?Color(0xFF2a3b4b).withOpacity(0.9):Color(0xFFe8f8f5),
                          dropdownButtonProps: IconButtonProps(
                            icon: Icon(Icons.keyboard_arrow_down_sharp,size: 0),
                            color: themeController.isDarkMode?MateColors.iconDark:MateColors.iconLight,
                          ),
                          dropdownBuilder: (context,data){
                            return Container(
                              height: 48,
                              width: 140,
                              decoration: BoxDecoration(
                                color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                                borderRadius: BorderRadius.circular(48),
                              ),
                              child: ListTile(
                                dense: true,
                                contentPadding: EdgeInsets.only(left: 5,right: 15,),
                                horizontalTitleGap: 13,
                                leading: Padding(
                                  padding: const EdgeInsets.only(bottom: 2),
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: themeController.isDarkMode?Colors.white.withOpacity(0.12):Colors.white.withOpacity(0.2)
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Image.asset(
                                        'lib/asset/iconsNewDesign/bottomBarEvent.png',
                                        color: filterDateValue==""?
                                        themeController.isDarkMode?Color(0xFFC5CACA):Color(0xFF8A8A99):
                                        themeController.isDarkMode?Color(0xFF67AE8C):Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                title: Text(filterDateValue==""?'Date':filterDateValue,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    color: themeController.isDarkMode?Colors.white:Colors.black,
                                  ),
                                ),
                                trailing: filterDateValue==""?
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 30,
                                  color: themeController.isDarkMode?Colors.white:Colors.black,
                                ):GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      filterDateValue = "";
                                      filterDateValueApi = "";
                                    });
                                    refreshPage();
                                  },
                                  child: Icon(Icons.clear,
                                    size: 25,
                                    color: themeController.isDarkMode?Colors.white:Colors.black,
                                  ),
                                ),
                              ),
                            );
                          },
                          showSearchBox: false,
                          items: filterDate,
                          itemAsString: (String u) => u,
                          dropdownSearchDecoration: InputDecoration(
                            hintText: '',
                            hintStyle: TextStyle(
                              fontSize: 0,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.1,
                              color: themeController.isDarkMode?Colors.white:Colors.black,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(top: 10),
                            icon: Icon(Icons.add,size: 0,),
                          ),
                          onChanged: (value)async{
                            setState(() {
                              filterDateValue = value;
                              if(filterDateValue=="Today"){
                                filterDateValueApi = "today";
                              }else if(filterDateValue=="This Week"){
                                filterDateValueApi = "this_week";
                              }else{
                                filterDateValueApi = "this_month";
                              }
                            });
                            refreshPage();
                          },
                        ),
                      ),
                    );
                  }else if(index==1){
                    return Container(
                      width: 210,
                      child: Theme(
                        data: ThemeData(
                          textTheme: TextTheme(
                            subtitle1: TextStyle(
                              color: themeController.isDarkMode?Colors.white:Colors.black,
                            ),
                          ),
                        ),
                        child: DropdownSearch<String>(
                          mode: Mode.MENU,
                          showSelectedItems: false,
                          popupShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          maxHeight: 170,
                          popupBackgroundColor: themeController.isDarkMode?Color(0xFF2a3b4b).withOpacity(0.9):Color(0xFFe8f8f5),
                          dropdownButtonProps: IconButtonProps(
                            icon: Icon(Icons.keyboard_arrow_down_sharp,size: 0),
                            color: themeController.isDarkMode?MateColors.iconDark:MateColors.iconLight,
                          ),
                          dropdownBuilder: (context,data){
                            return Container(
                              height: 48,
                              width: 168,
                              decoration: BoxDecoration(
                                color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                                borderRadius: BorderRadius.circular(48),
                              ),
                              child: ListTile(
                                dense: true,
                                contentPadding: EdgeInsets.only(left: 5,right: 15,),
                                horizontalTitleGap: 13,
                                leading: Padding(
                                  padding: const EdgeInsets.only(bottom: 2),
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: themeController.isDarkMode?Colors.white.withOpacity(0.12):Colors.white.withOpacity(0.2)
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.location_on_sharp,
                                        color: filterLocationValue==""?
                                        themeController.isDarkMode?Color(0xFFC5CACA):Color(0xFF8A8A99):
                                        themeController.isDarkMode?Color(0xFF67AE8C):Colors.black,
                                        size: 25,
                                      ),
                                    ),
                                  ),
                                ),
                                title: Text(filterLocationValue==""?'Location':filterLocationValue,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    color: themeController.isDarkMode?Colors.white:Colors.black,
                                  ),
                                ),
                                trailing: filterLocationValue==""?
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 30,
                                  color: themeController.isDarkMode?Colors.white:Colors.black,
                                ):GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      filterLocationValue = "";
                                      filterLocationValueApi = "";
                                    });
                                    refreshPage();
                                  },
                                  child: Icon(Icons.clear,
                                    size: 25,
                                    color: themeController.isDarkMode?Colors.white:Colors.black,
                                  ),
                                ),
                              ),
                            );
                          },
                          showSearchBox: false,
                          items: filterLocation,
                          itemAsString: (String u) => u,
                          dropdownSearchDecoration: InputDecoration(
                            hintText: '',
                            hintStyle: TextStyle(
                              fontSize: 0,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.1,
                              color: themeController.isDarkMode?Colors.white:Colors.black,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(left: -40,top: 10),
                          ),
                          onChanged: (value)async{
                            setState(() {
                              filterLocationValue = value;
                              filterLocationValueApi = filterLocationValue;
                            });
                            refreshPage();
                          },
                        ),
                      ),
                    );
                  }else{
                    return Container(
                      width: 220,
                      child: Theme(
                        data: ThemeData(
                          textTheme: TextTheme(
                            subtitle1: TextStyle(
                              color: themeController.isDarkMode?Colors.white:Colors.black,
                            ),
                          ),
                        ),
                        child: DropdownSearch<String>(
                          mode: Mode.MENU,
                          showSelectedItems: false,
                          popupShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          maxHeight: 500,
                          popupBackgroundColor: themeController.isDarkMode?Color(0xFF2a3b4b).withOpacity(0.9):Color(0xFFe8f8f5),
                          dropdownButtonProps: IconButtonProps(
                            icon: Icon(Icons.keyboard_arrow_down_sharp,size: 0),
                            color: themeController.isDarkMode?MateColors.iconDark:MateColors.iconLight,
                          ),
                          dropdownBuilder: (context,data){
                            return Container(
                              height: 48,
                              width: 140,
                              decoration: BoxDecoration(
                                color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                                borderRadius: BorderRadius.circular(48),
                              ),
                              child: ListTile(
                                dense: true,
                                contentPadding: EdgeInsets.only(left: 5,right: 15,),
                                horizontalTitleGap: 13,
                                leading: Padding(
                                  padding: const EdgeInsets.only(bottom: 2),
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: themeController.isDarkMode?Colors.white.withOpacity(0.12):Colors.white.withOpacity(0.2)
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Image.asset(
                                        'lib/asset/iconsNewDesign/type.png',
                                        color: filterTypeValue==""?
                                        themeController.isDarkMode?Color(0xFFC5CACA):Color(0xFF8A8A99):
                                        themeController.isDarkMode?Color(0xFF67AE8C):Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                title: Text(filterTypeValue==""?'Type':filterTypeValue,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    color: themeController.isDarkMode?Colors.white:Colors.black,
                                  ),
                                ),
                                trailing: filterTypeValue==""?
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 30,
                                  color: themeController.isDarkMode?Colors.white:Colors.black,
                                ):GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      filterTypeValue = "";
                                      filterTypeValueApi = 0;
                                    });
                                    refreshPage();
                                  },
                                  child: Icon(Icons.clear,
                                    size: 25,
                                    color: themeController.isDarkMode?Colors.white:Colors.black,
                                  ),
                                ),
                              ),
                            );
                          },
                          showSearchBox: false,
                          items: filterType,
                          itemAsString: (String u) => u,
                          dropdownSearchDecoration: InputDecoration(
                            hintText: '',
                            hintStyle: TextStyle(
                              fontSize: 0,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.1,
                              color: themeController.isDarkMode?Colors.white:Colors.black,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(left: -40,top: 10),
                          ),
                          onChanged: (value)async{
                            setState(() {
                              filterTypeValue = value;
                              int index = filterType.indexOf(filterTypeValue);
                              filterTypeValueApi = categoryId[index];
                            });
                            refreshPage();
                          },
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
            Expanded(
              child: refreshPageOnBottomClick ?
              timelineLoader() :
              RefreshIndicator(
                onRefresh: () {
                  return refreshPage();
                },
                child: FutureBuilder<EventListingModel>(
                  future: future,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.success == true || doingPagination == true) {
                        if (enableFutureBuilder) {
                          if (doingPagination) {
                            for (int i = 0; i < snapshot.data.data.result.length; i++) {
                              list.add(snapshot.data.data.result[i]);
                              isBookMark.add(snapshot.data.data.result[i].isBookmarked != null ? true : false);
                              if (snapshot.data.data.result[i].isReacted != null) {
                                reaction.add(
                                    snapshot.data.data.result[i].isReacted.status == "Going" ?
                                    "Going" : snapshot.data.data.result[i].isReacted.status == "Interested" ?
                                    "Interested" : "none"
                                );
                              } else {
                                reaction.add("none");
                              }
                            }
                            print("List length ${list.length}");
                            print("Bookmark list length ${isBookMark.length}");
                            print("Reaction list length ${reaction.length}");
                          } else {
                            list.clear();
                            isBookMark.clear();
                            reaction.clear();
                            for (int i = 0; i < snapshot.data.data.result.length; i++) {
                              list.add(snapshot.data.data.result[i]);
                              isBookMark.add(snapshot.data.data.result[i].isBookmarked != null ? true : false);
                              if (snapshot.data.data.result[i].isReacted != null) {
                                reaction.add(
                                    snapshot.data.data.result[i].isReacted.status == "Going" ?
                                    "Going" : snapshot.data.data.result[i].isReacted.status == "Interested" ?
                                    "Interested" : "none"
                                );
                              } else {
                                reaction.add("none");
                              }
                            }
                            print("List length ${list.length}");
                            print("Bookmark list length ${isBookMark.length}");
                            print("Reaction list length ${reaction.length}");
                          }
                          Future.delayed(Duration.zero, () {
                            enableFutureBuilder = false;
                            setState(() {});
                          });
                        }
                        return ListView(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          controller: _scrollController,
                          padding: EdgeInsets.only(top: 0),
                          children: [
                            ListView.builder(
                              scrollDirection: Axis.vertical,
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              itemCount: list.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: themeController.isDarkMode ? MateColors.containerDark : MateColors.containerLight,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ListTile(
                                        onTap: () {
                                          if (list[index].user.uuid != null) {
                                            if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == list[index].user.uuid) {
                                              Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                                            } else {
                                              Navigator.of(context).pushNamed(UserProfileScreen.routeName,
                                                  arguments: {
                                                    "id": list[index].user.uuid,
                                                    "name": list[index].user.displayName,
                                                    "photoUrl": list[index].user.profilePhoto,
                                                    "firebaseUid": list[index].user.firebaseUid,
                                                  });
                                            }
                                          }
                                        },
                                        leading: CircleAvatar(
                                          radius: 20,
                                          backgroundImage: NetworkImage(list[index].user.profilePhoto),
                                        ),
                                        title: Text(
                                          list[index].user.displayName,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w600,
                                            color: themeController.isDarkMode?Colors.white:Colors.black,
                                          ),
                                        ),
                                        subtitle: Text(
                                          DateFormat('dd MMMM yyyy').format(DateTime.parse(list[index].createdAt.toString()).toLocal()).toString(),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: themeController.isDarkMode?MateColors.helpingTextDark:Colors.black.withOpacity(0.72),
                                          ),
                                        ),
                                        trailing: PopupMenuButton<int>(
                                            padding: EdgeInsets.zero,
                                            elevation: 0,
                                            color: themeController.isDarkMode?MateColors.popupDark:MateColors.popupLight,
                                            icon: Icon(
                                              Icons.more_vert,
                                              color: themeController.isDarkMode?Colors.white:MateColors.blackText,
                                            ),
                                            onSelected: (index1) async {
                                              if (index1 == 0) {
                                                gCal.Event event = gCal.Event(); // Create object of event
                                                event.summary = list[index].title; //Setting summary of object
                                                event.description = list[index].description; //Setting summary of object

                                                gCal.EventDateTime start = new gCal.EventDateTime(); //Setting start time
                                                start.dateTime = DateTime.parse(list[index].createdAt.toString()).toLocal();
                                                start.timeZone = "GMT+05:00";
                                                event.start = start;

                                                gCal.EventDateTime end = new gCal.EventDateTime(); //setting end time
                                                end.timeZone = "GMT+05:00";
                                                end.dateTime = DateTime.parse(list[index].createdAt.toString()).toLocal();
                                                event.end = end;

                                                insertEvent(event);
                                              } else if (index1 == 1) {
                                                Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                                    Chat(peerUuid: list[index].user.uuid,
                                                        currentUserId: _currentUser.uid,
                                                        peerId: list[index].user.firebaseUid,
                                                        peerAvatar: list[index].user.profilePhoto,
                                                        peerName: list[index].user.displayName)));
                                              } else if (index1 == 2) {
                                                _showFollowAlertDialog(eventId: list[index].id, indexVal: index, tabIndex: 0, isFollowed: list[index].isFollowed);
                                              } else if (index1 == 3) {
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => ReportPage(moduleId: list[index].id, moduleType: "Event",),));
                                              } else if (index1 == 4) {
                                                _showDeleteAlertDialog(eventId: list[index].id, indexVal: index, tabIndex: 0);
                                              } else if (index1 == 5) {
                                                await Navigator.push(context, MaterialPageRoute(builder: (context) => EditEvent(data: list[index]),));
                                                getStoredValue();
                                              }
                                            },
                                            itemBuilder: (context) => [
                                              PopupMenuItem(
                                                value: 1,
                                                height: 40,
                                                child: Text(
                                                  "Message",
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    color: themeController.isDarkMode?Colors.white:Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: 'Poppins',
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                              PopupMenuItem(
                                                value: 2,
                                                height: 40,
                                                child: Text(
                                                  list[index].isFollowed ? "Unfollow Event" : "Follow Event",
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    color: themeController.isDarkMode?Colors.white:Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: 'Poppins',
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                              PopupMenuItem(
                                                value: 3,
                                                height: 40,
                                                child: Text(
                                                  "Report",
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    color: themeController.isDarkMode?Colors.white:Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: 'Poppins',
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                              ((Provider
                                                  .of<AuthUserProvider>(context, listen: false)
                                                  .authUser
                                                  .id == list[index].user.uuid)) ?
                                              PopupMenuItem(
                                                value: 4,
                                                height: 40,
                                                child: Text(
                                                  "Delete Event",
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    color: themeController.isDarkMode?Colors.white:Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: 'Poppins',
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ) : PopupMenuItem(
                                                value: 4,
                                                enabled: false,
                                                height: 0,
                                                child: SizedBox(
                                                  height: 0,
                                                  width: 0,
                                                ),
                                              ),
                                              ((Provider
                                                  .of<AuthUserProvider>(context, listen: false)
                                                  .authUser
                                                  .id == list[index].user.uuid)) ?
                                              PopupMenuItem(
                                                value: 5,
                                                height: 40,
                                                child: Text(
                                                  "Edit Event",
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    color: themeController.isDarkMode?Colors.white:Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: 'Poppins',
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ) : PopupMenuItem(
                                                value: 5,
                                                enabled: false,
                                                height: 0,
                                                child: SizedBox(
                                                  height: 0,
                                                  width: 0,
                                                ),
                                              ),
                                            ]
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16),
                                        child: Divider(
                                          thickness: 1,
                                          color: themeController.isDarkMode?MateColors.dividerDark:MateColors.dividerLight,
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                                              EventDetails(
                                                list: list[index],
                                                isBookmark: isBookMark[index],
                                                index: index,
                                                changeBookmark: changeBookmark,
                                                reaction: reaction[index],
                                                changeReaction: changeReaction,
                                                changeCommentCount: changeCommentCount,
                                                changeFollowUnfollow: changeFollowUnfollow,
                                              )
                                          ));
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 16, top: 5),
                                          child: Text(
                                            list[index].title,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w700,
                                              color: themeController.isDarkMode?Colors.white:Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                                              EventDetails(
                                                list: list[index],
                                                isBookmark: isBookMark[index],
                                                index: index,
                                                changeBookmark: changeBookmark,
                                                reaction: reaction[index],
                                                changeReaction: changeReaction,
                                                changeCommentCount: changeCommentCount,
                                                changeFollowUnfollow: changeFollowUnfollow,
                                              )
                                          ));
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 16, top: 10, right: 10),
                                          child: Text(
                                            list[index].description,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w400,
                                              letterSpacing: 0.1,
                                              color: themeController.isDarkMode?Colors.white:Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                      list[index].hyperLinkText != null && list[index].hyperLink != null ?
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          if (await canLaunch(list[index].hyperLink))
                                            await launch(list[index].hyperLink);
                                          else
                                            Fluttertoast.showToast(msg: " Could not launch given URL '${list[index].hyperLink}'",
                                                fontSize: 16,
                                                backgroundColor: Colors.black54,
                                                textColor: Colors.white,
                                                toastLength: Toast.LENGTH_LONG);
                                          throw "Could not launch ${list[index].hyperLink}";
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 16, top: 10, right: 10),
                                          child: Text(
                                            list[index].hyperLinkText,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Poppins',
                                              color: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                                            ),
                                          ),
                                        ),
                                      ) : SizedBox(),
                                      Padding(
                                        padding: EdgeInsets.only(left: 16, top: 10, right: 10),
                                        child: Row(
                                          children: [
                                            Image.asset("lib/asset/icons/pinEvent.png",
                                              height: 20,
                                              width: 14,
                                              fit: BoxFit.fitHeight,
                                            ),
                                            SizedBox(width: 8,),
                                            Expanded(
                                              child: Text(
                                                list[index].location,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  color: themeController.isDarkMode ? Colors.white : MateColors.blackTextColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 16, top: 10, right: 10),
                                        child: Row(
                                          children: [
                                            Image.asset("lib/asset/icons/calendarEvent.png",
                                              height: 14,
                                            ),
                                            SizedBox(width: 8,),
                                            Text(
                                              DateFormat('dd MMMM yyyy').format(DateTime.parse(list[index].date.toString()).toLocal()).toString(),
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color: themeController.isDarkMode ? Colors.white : MateColors.blackTextColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 16, top: 10, right: 10),
                                        child: Row(
                                          children: [
                                            Image.asset("lib/asset/icons/clockEvent.png",
                                              height: 14,
                                            ),
                                            SizedBox(width: 8,),
                                            Text(
                                              DateFormat('hh:mm a').format(DateTime.parse(list[index].time.toString())).toString(),
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color: themeController.isDarkMode ? Colors.white : MateColors.blackTextColor,
                                              ),
                                            ),
                                            if(list[index].endTime != null)
                                              Text(
                                                " - " + DateFormat('hh:mm a').format(DateTime.parse(list[index].endTime.toString())).toString(),
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  color: themeController.isDarkMode ? Colors.white : MateColors.blackTextColor,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      if(list[index].goingList.length > 0)
                                        Container(
                                          height: 40,
                                          margin: EdgeInsets.only(left: 16, top: 10),
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width,
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              ListView.builder(
                                                  scrollDirection: Axis.horizontal,
                                                  shrinkWrap: true,
                                                  physics: ScrollPhysics(),
                                                  itemCount: list[index].goingList.length > 6 ? 6 : list[index].goingList.length,
                                                  itemBuilder: (context, ind) {
                                                    return InkWell(
                                                      onTap: () {
                                                        Get.to(MemberList(list: list[index].goingList,));
                                                      },
                                                      child: CircleAvatar(
                                                        radius: 12,
                                                        backgroundColor: MateColors.activeIcons,
                                                        backgroundImage: NetworkImage(list[index].goingList[ind].profilePhoto),
                                                      ),
                                                    );
                                                  }
                                              ),
                                              list[index].goingList.length > 6 ?
                                              InkWell(
                                                onTap: () {
                                                  Get.to(MemberList(list: list[index].goingList,));
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 5),
                                                  child: Text("+${list[index].goingList.length - 6}",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w400,
                                                      color: themeController.isDarkMode ? Colors.white : MateColors.blackTextColor,
                                                    ),
                                                  ),
                                                ),
                                              ) :
                                              Offstage(),
                                            ],
                                          ),
                                        ),
                                      if(list[index].photoUrl != null || list[index].videoUrl != null)
                                        Container(
                                          height: 150,
                                          margin: EdgeInsets.only(bottom: 0.0, left: 16, right: 16, top: 10),
                                          child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              shrinkWrap: true,
                                              physics: BouncingScrollPhysics(),
                                              itemCount: list[index].photoUrl != null && list[index].videoUrl != null ? 2 : list[index].photoUrl != null ? 1 : list[index].videoUrl != null ? 1 : 0,
                                              itemBuilder: (context, indexSwipe) {
                                                if (indexSwipe == 0) {
                                                  return
                                                    list[index].photoUrl != null ?
                                                    Padding(
                                                      padding: const EdgeInsets.only(bottom: 0.0, left: 0, right: 0, top: 10),
                                                      child: Container(
                                                        height: 150,
                                                        width: MediaQuery
                                                            .of(context)
                                                            .size
                                                            .width / 1.2,
                                                        child: InkWell(
                                                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MediaViewer(url: list[index].photoUrl,))),
                                                          child: ClipRRect(
                                                            borderRadius: BorderRadius.circular(12.0),
                                                            clipBehavior: Clip.hardEdge,
                                                            child: Image.network(
                                                              list[index].photoUrl,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ) : list[index].videoUrl != null ?
                                                    VideoThumbnail(videoUrl: list[index].videoUrl, isLeftPadding: false,) : Container();
                                                } else {
                                                  return list[index].videoUrl != null ?
                                                  VideoThumbnail(videoUrl: list[index].videoUrl) : Container();
                                                }
                                              }
                                          ),
                                        ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 16, right: 16, top: 25),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    if (reaction[index] == "Going") {
                                                      reaction[index] = "none";
                                                      setState(() {});
                                                      _eventService.reaction(id: list[index].id, reaction: "none", token: token);
                                                    } else {
                                                      reaction[index] = "Going";
                                                      setState(() {});
                                                      _eventService.reaction(id: list[index].id, reaction: "Going", token: token);
                                                    }
                                                  },
                                                  child: Container(
                                                    height: 32,
                                                    width: 72,
                                                    decoration: BoxDecoration(
                                                      color: reaction[index] == "Going" ? MateColors.activeIcons : Colors.transparent,
                                                      borderRadius: BorderRadius.circular(16),
                                                      border: Border.all(color: themeController.isDarkMode ? Colors.white : Colors.black, width: 1),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        "Going",
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight: FontWeight.w500,
                                                          letterSpacing: 0.1,
                                                          color: themeController.isDarkMode ? reaction[index] == "Going" ? MateColors.blackTextColor : Colors.white :
                                                          reaction[index] == "Going" ? Colors.white : MateColors.blackTextColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 10,),
                                                InkWell(
                                                  onTap: () {
                                                    if (reaction[index] == "Interested") {
                                                      reaction[index] = "none";
                                                      setState(() {});
                                                      _eventService.reaction(id: list[index].id, reaction: "none", token: token);
                                                    } else {
                                                      reaction[index] = "Interested";
                                                      setState(() {});
                                                      _eventService.reaction(id: list[index].id, reaction: "Interested", token: token);
                                                    }
                                                  },
                                                  child: Container(
                                                    height: 32,
                                                    width: 99,
                                                    decoration: BoxDecoration(
                                                      color: reaction[index] == "Interested" ? MateColors.activeIcons : Colors.transparent,
                                                      borderRadius: BorderRadius.circular(16),
                                                      border: Border.all(color: themeController.isDarkMode ? Colors.white : Colors.black, width: 1),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        "Interested",
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight: FontWeight.w500,
                                                          letterSpacing: 0.1,
                                                          color: themeController.isDarkMode ? reaction[index] == "Interested" ? MateColors.blackTextColor : Colors.white :
                                                          reaction[index] == "Interested" ? Colors.white : MateColors.blackTextColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                InkWell(
                                                  onTap: (){
                                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                                                        EventDetails(
                                                          list: list[index],
                                                          isBookmark: isBookMark[index],
                                                          index: index,
                                                          changeBookmark: changeBookmark,
                                                          reaction: reaction[index],
                                                          changeReaction: changeReaction,
                                                          changeCommentCount: changeCommentCount,
                                                          changeFollowUnfollow: changeFollowUnfollow,
                                                          showDetails: false,
                                                        )
                                                    ));
                                                  },
                                                  child: Container(
                                                    height: 39,
                                                    width: 83,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      color: themeController.isDarkMode?MateColors.smallContainerDark:MateColors.smallContainerLight,
                                                      borderRadius: BorderRadius.circular(25),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.all(10.0),
                                                          child: Image.asset("lib/asset/iconsNewDesign/msg.png",
                                                            color: themeController.isDarkMode?Colors.white:Colors.black,
                                                          ),
                                                        ),
                                                        Text(
                                                          list[index].commentsCount.toString(),
                                                          style: TextStyle(
                                                            fontFamily: "Poppins",
                                                            fontSize: 15,
                                                            fontWeight: FontWeight.w500,
                                                            color: themeController.isDarkMode?Colors.white:Colors.black,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 10,),
                                                InkWell(
                                                  onTap: (){
                                                    setState(() {
                                                      isBookMark[index] = !isBookMark[index];
                                                    });
                                                    _eventService.bookMark(id: list[index].id, token: token);
                                                  },
                                                  child: Container(
                                                    height: 39,
                                                    width: 40,
                                                    decoration: BoxDecoration(
                                                      color: themeController.isDarkMode?MateColors.smallContainerDark:MateColors.smallContainerLight,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: isBookMark[index]?
                                                    Padding(
                                                      padding: const EdgeInsets.all(11.0),
                                                      child: Image.asset("lib/asset/icons/bookmarkColor.png",
                                                        color: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                                                      ),
                                                    ):
                                                    Padding(
                                                      padding: const EdgeInsets.all(11.0),
                                                      child: Image.asset("lib/asset/homePageIcons/drawerBookmark@3x.png",
                                                        color: themeController.isDarkMode?Colors.white:Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 20,),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      } else {
                        return Center(
                          child: Text("No data found",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: themeController.isDarkMode ? Colors.white : MateColors.blackTextColor,
                            ),
                          ),
                        );
                      }
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text("Something went wrong",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: themeController.isDarkMode ? Colors.white : MateColors.blackTextColor,
                          ),
                        ),
                      );
                    } else {
                      return timelineLoader();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  insertEvent(event) {
    try {
      const _scopes = const [gCal.CalendarApi.calendarScope];
      clientViaUserConsent(_credentials, _scopes, prompt).then((AuthClient client) {
        var calendar = gCal.CalendarApi(client);
        String calendarId = "primary";
        calendar.events.insert(event, calendarId).then((value) {
          print("ADDEDDD_________________${value.status}");
          if (value.status == "confirmed") {
            print('Event added in google calendar');
          } else {
            print("Unable to add event in google calendar");
          }
        });
      });
    } catch (e) {
      print('Error creating event $e');
    }
  }

  void prompt(String url) async {
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _showFollowAlertDialog({@required int eventId, @required int indexVal, @required int tabIndex, @required isFollowed}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: new Text("Are you sure?"),
          content: new Text(isFollowed ? "You want to Unfollow this event" : "You want to follow this event"),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: feedProvider.feedFollowLoader ?
              Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ) :
              Text("Yes"),
              onPressed: () async {
                if (tabIndex == 0) {
                  if (isFollowed) {
                    Map<String, dynamic> body = {"post_id": eventId, "post_type": "Event"};
                    bool unFollowDone = await feedProvider.unFollowAFeed(body, eventId);
                    if (unFollowDone) {
                      list[indexVal].isFollowed = false;
                      setState(() {});
                      Navigator.pop(context);
                    }
                  } else {
                    Map<String, dynamic> body = {"post_id": eventId, "post_type": "Event"};
                    bool followDone = await feedProvider.followAFeed(body, eventId);
                    if (followDone) {
                      list[indexVal].isFollowed = true;
                      setState(() {});
                      Navigator.pop(context);
                    }
                  }
                } else {
                  if (isFollowed) {
                    Map<String, dynamic> body = {"post_id": eventId, "post_type": "Event"};
                    bool unFollowDone = await feedProvider.unFollowAFeed(body, eventId);
                    if (unFollowDone) {
                      listLocal[indexVal].isFollowed = false;
                      setState(() {});
                      Navigator.pop(context);
                    }
                  } else {
                    Map<String, dynamic> body = {"post_id": eventId, "post_type": "Event"};
                    bool followDone = await feedProvider.followAFeed(body, eventId);
                    if (followDone) {
                      listLocal[indexVal].isFollowed = true;
                      setState(() {});
                      Navigator.pop(context);
                    }
                  }
                }
              },
            ),
            CupertinoDialogAction(
                child: Text("No"),
                onPressed: () {
                  Navigator.of(context).pop();
                })
          ],
        );
      },
    );
  }

  _showDeleteAlertDialog({@required int eventId, @required int indexVal, @required tabIndex}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: new Text("Are you sure?"),
          content: new Text("You want to delete your event"),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text("Yes"),
              onPressed: () async {
                bool res = await _eventService.deleteEvent(id: eventId, token: token);
                Navigator.of(context).pop();
                if (res) {
                  getStoredValue();
                } else {
                  Fluttertoast.showToast(msg: "Something went wrong",
                      fontSize: 16,
                      backgroundColor: Colors.black54,
                      textColor: Colors.white,
                      toastLength: Toast.LENGTH_LONG);
                }
              },
            ),
            CupertinoDialogAction(
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}



