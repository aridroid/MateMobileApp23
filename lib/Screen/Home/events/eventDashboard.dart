import 'dart:developer';
import 'dart:io';
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
import 'package:mate_app/audioAndVideoCalling/acceptRejectScreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Providers/AuthUserProvider.dart';
import '../../../Providers/FeedProvider.dart';
import '../../../Utility/Utility.dart';
import '../../../Widget/Drawer/DrawerWidget.dart';
import '../../../Widget/Home/HomeRow.dart';
import '../../../Widget/Loaders/Shimmer.dart';
import '../../../asset/Colors/MateColors.dart';
import '../../../calling/index.dart';
import '../../../controller/theme_controller.dart';
import 'package:googleapis/calendar/v3.dart' as gCal;
import '../../Profile/ProfileScreen.dart';
import '../../Profile/UserProfileScreen.dart';
import '../../Report/reportPage.dart';
import '../../chat1/screens/chat.dart';
import 'createEvent.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class EventDashBoard extends StatefulWidget {
  static final String routeName = '/eventDashboard';

  @override
  _EventDashBoardState createState() => _EventDashBoardState();
}

class _EventDashBoardState extends State<EventDashBoard> with TickerProviderStateMixin{
  ThemeController themeController = Get.find<ThemeController>();
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  TabController _tabController;
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

  @override
  void didUpdateWidget(covariant EventDashBoard oldWidget) {
    print("Did update widget is calling");
    setState(() {
      refreshPageOnBottomClick = true;
    });
    getStoredValue();
    //_scrollController.jumpTo(_scrollController.position.minScrollExtent);
    _tabController = new TabController(length: 2, vsync: this);
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
    _tabController = new TabController(length: 2, vsync: this);
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
    _tabController.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
  }

  void _scrollListener(){
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels != 0) {
        if(_tabController.index==0){
          print("//////////////////////////////");
          Future.delayed(Duration.zero,(){
            page += 1;
            setState(() {
              doingPagination = true;
            });
            print('scrolled to bottom page is now $page');
            future = _eventService.getEventListing(page: page,token: token);
            future.then((value){
              setState(() {
                enableFutureBuilder = true;
              });
            });
          });
        }else{
          print("//////////////////////////////");
          Future.delayed(Duration.zero,(){
            pageLocal += 1;
            setState(() {
              doingPaginationLocal = true;
            });
            print('scrolled to bottom page is now $pageLocal');
            futureLocal = _eventService.getEventListingLocal(page: pageLocal,token: token);
            futureLocal.then((value){
              setState(() {
                enableFutureBuilderLocal = true;
              });
            });
          });
        }
      }
    }
  }

  getStoredValue()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token");
    log(token);

    setState(() {
      doingPagination = false;
      doingPaginationLocal = false;
      page = 1;
      pageLocal = 1;
    });

    future = _eventService.getEventListing(page: page,token: token);
    future.then((value){
      setState(() {
        enableFutureBuilder = true;
      });
    });

    futureLocal = _eventService.getEventListingLocal(page: pageLocal,token: token);
    futureLocal.then((value){
      setState(() {
        enableFutureBuilderLocal = true;
      });
    });

    setState(() {
      refreshPageOnBottomClick = false;
    });
  }

  void changeBookmark(int index){
    if(_tabController.index==0){
      isBookMark[index] = !isBookMark[index];
      setState(() {});
    }else{
      isBookMarkLocal[index] = !isBookMarkLocal[index];
      setState(() {});
    }
  }

  void changeReaction(int index,String value){
    if(_tabController.index==0){
      reaction[index] = value;
      setState(() {});
    }else{
      reactionLocal[index] = value;
      setState(() {});
    }
  }

  void changeCommentCount(int index,bool increment){
    if(_tabController.index==0){
      increment ?
      list[index].commentsCount = list[index].commentsCount + 1 :
      list[index].commentsCount = list[index].commentsCount - 1 ;
      setState(() {});
    }else{
      increment ?
      listLocal[index].commentsCount = listLocal[index].commentsCount + 1 :
      listLocal[index].commentsCount = listLocal[index].commentsCount - 1 ;
      setState(() {});
    }
  }

  void changeFollowUnfollow(int index,bool value){
    if(_tabController.index==0){
      list[index].isFollowed = value;
      setState(() {});
    }else{
      listLocal[index].isFollowed = value;
      setState(() {});
    }
  }


  refreshPage()async{
    if(_tabController.index==0){
      setState(() {
        page = 1;
      });
      future = _eventService.getEventListing(page: page,token: token);
      future.then((value){
        setState(() {
          doingPagination = false;
          Future.delayed(Duration.zero,(){
            enableFutureBuilder = true;
          });
        });
      });
    }else{
      setState(() {
        pageLocal = 1;
      });
      futureLocal = _eventService.getEventListingLocal(page: pageLocal,token: token);
      futureLocal.then((value){
        setState(() {
          doingPaginationLocal = false;
          Future.delayed(Duration.zero,(){
            enableFutureBuilderLocal = true;
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer: DrawerWidget(),
      floatingActionButton: InkWell(
        onTap: ()async{
           await Navigator.of(context).pushNamed(CreateEvent.routeName);
           getStoredValue();
        },
        child: Container(
          height: 56,
          width: 56,
          margin: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: MateColors.activeIcons,
          ),
          child: Icon(Icons.add,color: themeController.isDarkMode?Colors.black:Colors.white,size: 28),
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        leading: _appBarLeading(context),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: InkWell(
              onTap: ()async{
                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                    return EventSearch(isLocal: _tabController.index==0?false:true,);
                  },),);
                //Navigator.of(context).pushNamed(EventSearch.routes);
              },
              child: Image.asset(
                "lib/asset/homePageIcons/searchPurple@3x.png",
                height: 23.7,
                width: 23.7,
                color: MateColors.activeIcons,
              ),
            ),
          ),
        ],
        title: Text(
          "Events",
          style: TextStyle(
            color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
            fontWeight: FontWeight.w700,
            fontSize: 17.0,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.0),
              border: Border(bottom: BorderSide(color: Color(0xFF65656B).withOpacity(0.2), width: 0.8)),
            ),
            child: TabBar(
              onTap: (value){
                print(value);
              },
              controller: _tabController,
              unselectedLabelColor: Color(0xFF656568),
              indicatorColor: MateColors.activeIcons,
              indicatorPadding: EdgeInsets.symmetric(horizontal: 20),
              labelColor: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
              labelStyle: TextStyle(fontSize: 15.0,fontFamily: "Poppins",fontWeight: FontWeight.w500),
              tabs: [
                Tab(
                  text: "All events",
                ),
                Tab(
                  text: "My events",
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                refreshPageOnBottomClick?
                timelineLoader():
                RefreshIndicator(
                  onRefresh: (){
                    return refreshPage();
                  },
                  child: FutureBuilder<EventListingModel>(
                    future: future,
                    builder: (context,snapshot){
                      if(snapshot.hasData){
                        if(snapshot.data.success==true || doingPagination==true){
                          if(enableFutureBuilder){
                            if(doingPagination){
                              for(int i=0;i<snapshot.data.data.result.length;i++){
                                list.add(snapshot.data.data.result[i]);
                                isBookMark.add(snapshot.data.data.result[i].isBookmarked!=null?true:false);
                                if(snapshot.data.data.result[i].isReacted!=null){
                                  reaction.add(
                                      snapshot.data.data.result[i].isReacted.status=="Going"?
                                     "Going": snapshot.data.data.result[i].isReacted.status=="Interested"?
                                      "Interested":"none"
                                  );
                                }else{
                                  reaction.add("none");
                                }
                              }
                              print("List length ${list.length}");
                              print("Bookmark list length ${isBookMark.length}");
                              print("Reaction list length ${reaction.length}");
                            }else{
                              list.clear();
                              isBookMark.clear();
                              reaction.clear();
                              for(int i=0;i<snapshot.data.data.result.length;i++){
                                list.add(snapshot.data.data.result[i]);
                                isBookMark.add(snapshot.data.data.result[i].isBookmarked!=null?true:false);
                                if(snapshot.data.data.result[i].isReacted!=null){
                                  reaction.add(
                                      snapshot.data.data.result[i].isReacted.status=="Going"?
                                      "Going": snapshot.data.data.result[i].isReacted.status=="Interested"?
                                      "Interested":"none"
                                  );
                                }else{
                                  reaction.add("none");
                                }
                              }
                              print("List length ${list.length}");
                              print("Bookmark list length ${isBookMark.length}");
                              print("Reaction list length ${reaction.length}");
                            }
                            Future.delayed(Duration.zero,(){
                              enableFutureBuilder = false;
                              setState(() {});
                            });
                          }
                          return ListView(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            controller: _scrollController,
                            children: [
                              SizedBox(height: 20,),
                              ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                itemCount: list.length,
                                itemBuilder: (context,index){
                                  return Container(
                                    margin: EdgeInsets.symmetric(horizontal: 16,vertical: 10),
                                    decoration: BoxDecoration(
                                      color: themeController.isDarkMode?MateColors.drawerTileColor:Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ListTile(
                                          onTap: (){
                                            if(list[index].user.uuid!=null){
                                              if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == list[index].user.uuid) {
                                                Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                                              }else{
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
                                            radius: 16,
                                            backgroundColor: MateColors.activeIcons,
                                            backgroundImage: NetworkImage(list[index].user.profilePhoto),
                                          ),
                                          title: Text(
                                            list[index].user.displayName,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0.1,
                                              color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                                            ),
                                          ),
                                          subtitle: Text(
                                            DateFormat('dd MMMM yyyy').format(DateTime.parse(list[index].createdAt.toString()).toLocal()).toString(),
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
                                            ),
                                          ),
                                          trailing: PopupMenuButton<int>(
                                              padding: EdgeInsets.only(bottom: 0, top: 0, left: 25, right: 0),
                                              color: themeController.isDarkMode?backgroundColor:Colors.white,
                                              icon: Image.asset(
                                                "lib/asset/icons/menu@3x.png",
                                                height: 18,
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
                                                }else if (index1 == 1) {
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => Chat(peerUuid: list[index].user.uuid, currentUserId: _currentUser.uid, peerId: list[index].user.firebaseUid, peerAvatar: list[index].user.profilePhoto, peerName: list[index].user.displayName)));
                                                }else if(index1 == 2){
                                                  _showFollowAlertDialog(eventId: list[index].id, indexVal: index,tabIndex: 0,isFollowed: list[index].isFollowed);
                                                }else if(index1 == 3){
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ReportPage(moduleId: list[index].id, moduleType: "Event",),));
                                                }else if(index1 == 4){
                                                  _showDeleteAlertDialog(eventId: list[index].id, indexVal: index,tabIndex: 0);
                                                }
                                              },
                                              itemBuilder: (context) => [
                                                // PopupMenuItem(
                                                //   value: 0,
                                                //   height: 40,
                                                //   child: Text(
                                                //     "Calendar",
                                                //     textAlign: TextAlign.start,
                                                //     style: TextStyle(color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor, fontWeight: FontWeight.w500, fontSize: 12.6.sp),
                                                //   ),
                                                // ),
                                                PopupMenuItem(
                                                  value: 1,
                                                  height: 40,
                                                  child: Text(
                                                    "Message",
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor, fontWeight: FontWeight.w500, fontSize: 12.6.sp),
                                                  ),
                                                ),
                                                PopupMenuItem(
                                                  value: 2,
                                                  height: 40,
                                                  child: Text(
                                                    list[index].isFollowed?"Unfollow Event":"Follow Event",
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor, fontWeight: FontWeight.w500, fontSize: 12.6.sp),
                                                  ),
                                                ),
                                                PopupMenuItem(
                                                  value: 3,
                                                  height: 40,
                                                  child: Text(
                                                    "Report",
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor, fontWeight: FontWeight.w500, fontSize: 12.6.sp),
                                                  ),
                                                ),
                                                ((Provider.of<AuthUserProvider>(context, listen: false).authUser.id == list[index].user.uuid))?
                                                PopupMenuItem(
                                                  value: 4,
                                                  height: 40,
                                                  child: Text(
                                                    "Delete Event",
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor, fontWeight: FontWeight.w500, fontSize: 12.6.sp),
                                                  ),
                                                ):PopupMenuItem(
                                                  value: 4,
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
                                        InkWell(
                                          onTap: (){
                                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
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
                                            padding: EdgeInsets.only(left: 16,top: 0),
                                            child: Text(
                                              list[index].title,
                                              style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w700,
                                                color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: (){
                                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
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
                                            padding: EdgeInsets.only(left: 16,top: 10,right: 10),
                                            child: Text(
                                              list[index].description,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                letterSpacing: 0.1,
                                                color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                                              ),
                                            ),
                                          ),
                                        ),

                                        list[index].hyperLinkText!=null && list[index].hyperLink!=null ?
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async{
                                            if (await canLaunch(list[index].hyperLink))
                                              await launch(list[index].hyperLink);
                                            else
                                              Fluttertoast.showToast(msg: " Could not launch given URL '${list[index].hyperLink}'", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
                                            throw "Could not launch ${list[index].hyperLink}";
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 16,top: 10,right: 10),
                                            child: Text(
                                              list[index].hyperLinkText,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 0.1,
                                                color: MateColors.activeIcons,
                                              ),
                                            ),
                                          ),
                                        ):SizedBox(),


                                        Padding(
                                          padding: EdgeInsets.only(left: 16,top: 10,right: 10),
                                          child: Row(
                                            children: [
                                              Image.asset("lib/asset/icons/pinEvent.png",
                                                height: 20,
                                                width: 14,
                                                fit: BoxFit.fitHeight,
                                              ),
                                              SizedBox(width: 8,),
                                              Text(
                                                list[index].location,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  letterSpacing: 0.1,
                                                  color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 16,top: 10,right: 10),
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
                                                  letterSpacing: 0.1,
                                                  color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 16,top: 10,right: 10),
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
                                                  letterSpacing: 0.1,
                                                  color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                                                ),
                                              ),
                                              if(list[index].endTime!=null)
                                              Text(
                                                " - "+DateFormat('hh:mm a').format(DateTime.parse(list[index].endTime.toString())).toString(),
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  letterSpacing: 0.1,
                                                  color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if(list[index].goingList.length>0)
                                        Container(
                                          height: 40,
                                          margin: EdgeInsets.only(left: 16,top: 10),
                                          width: MediaQuery.of(context).size.width,
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              ListView.builder(
                                                  scrollDirection: Axis.horizontal,
                                                  shrinkWrap: true,
                                                  physics: ScrollPhysics(),
                                                  itemCount: list[index].goingList.length>6?6:list[index].goingList.length,
                                                  itemBuilder: (context,ind){
                                                    return InkWell(
                                                      onTap: (){
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
                                              list[index].goingList.length>6?
                                              InkWell(
                                                onTap: (){
                                                  Get.to(MemberList(list: list[index].goingList,));
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 5),
                                                  child: Text("+${list[index].goingList.length -6}",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
                                                    ),
                                                  ),
                                                ),
                                              ):
                                              Offstage(),
                                            ],
                                          ),
                                        ),
                                        if(list[index].photoUrl!=null || list[index].videoUrl!=null)
                                        Container(
                                          height: 150,
                                          margin: EdgeInsets.only(bottom: 0.0, left: 16, right: 16, top: 10),
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            shrinkWrap: true,
                                            physics: BouncingScrollPhysics(),
                                            itemCount: list[index].photoUrl!=null && list[index].videoUrl!=null? 2 : list[index].photoUrl!=null?1:list[index].videoUrl!=null?1:0,
                                            itemBuilder: (context,indexSwipe){
                                              if(indexSwipe==0){
                                                return
                                                list[index].photoUrl!=null?
                                                  Padding(
                                                    padding: const EdgeInsets.only(bottom: 0.0, left: 0, right: 0, top: 10),
                                                    child: Container(
                                                      height: 150,
                                                      width: MediaQuery.of(context).size.width/1.2,
                                                      child: InkWell(
                                                        onTap: () => Navigator.of(context).push(MaterialPageRoute(
                                                            builder: (context) => FullImageWidget(
                                                              imagePath: list[index].photoUrl,
                                                            ))),
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.circular(12.0),
                                                          clipBehavior: Clip.hardEdge,
                                                          child: Image.network(
                                                            list[index].photoUrl,
                                                            fit: BoxFit.cover,
                                                            // height: 300,
                                                            // width: 400,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ):list[index].videoUrl!=null?
                                                VideoThumbnail(videoUrl: list[index].videoUrl,isLeftPadding: false,):Container();
                                              }else{
                                                return list[index].videoUrl!=null?
                                                  VideoThumbnail(videoUrl: list[index].videoUrl):Container();
                                              }
                                            }
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 16,right: 16,top: 25),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  InkWell(
                                                    onTap: (){
                                                      if(reaction[index]=="Going"){
                                                        reaction[index] = "none";
                                                        setState(() {});
                                                        _eventService.reaction(id: list[index].id,reaction: "none",token: token);
                                                      }else{
                                                        reaction[index] = "Going";
                                                        setState(() {});
                                                        _eventService.reaction(id: list[index].id,reaction: "Going",token: token);
                                                      }
                                                    },
                                                    child: Container(
                                                      height: 32,
                                                      width: 72,
                                                      decoration: BoxDecoration(
                                                        color: reaction[index]=="Going"?MateColors.activeIcons:Colors.transparent,
                                                        borderRadius: BorderRadius.circular(16),
                                                        border: Border.all(color: themeController.isDarkMode?MateColors.darkDivider:MateColors.lightDivider,width: 1),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          "Going",
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w500,
                                                            letterSpacing: 0.1,
                                                            color: themeController.isDarkMode? reaction[index]=="Going"? MateColors.blackTextColor:Colors.white:
                                                                reaction[index]=="Going"?Colors.white:MateColors.blackTextColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 10,),
                                                  InkWell(
                                                    onTap: (){
                                                      if(reaction[index]=="Interested"){
                                                        reaction[index] = "none";
                                                        setState(() {});
                                                        _eventService.reaction(id: list[index].id,reaction: "none",token: token);
                                                      }else{
                                                        reaction[index] = "Interested";
                                                        setState(() {});
                                                        _eventService.reaction(id: list[index].id,reaction: "Interested",token: token);
                                                      }
                                                    },
                                                    child: Container(
                                                      height: 32,
                                                      width: 99,
                                                      decoration: BoxDecoration(
                                                        color: reaction[index]=="Interested"?MateColors.activeIcons:Colors.transparent,
                                                        borderRadius: BorderRadius.circular(16),
                                                        border: Border.all(color: themeController.isDarkMode?MateColors.darkDivider:MateColors.lightDivider,width: 1),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          "Interested",
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w500,
                                                            letterSpacing: 0.1,
                                                            color: themeController.isDarkMode? reaction[index]=="Interested"? MateColors.blackTextColor:Colors.white:
                                                            reaction[index]=="Interested"?Colors.white:MateColors.blackTextColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    list[index].commentsCount.toString(),
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
                                                    ),
                                                  ),
                                                  SizedBox(width: 10,),
                                                  InkWell(
                                                    onTap: (){
                                                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
                                                          EventDetails(
                                                            list: list[index],
                                                            isBookmark: isBookMark[index],
                                                            index: index,
                                                            changeBookmark: changeBookmark,
                                                            reaction: reaction[index],
                                                            changeReaction: changeReaction,
                                                            changeCommentCount: changeCommentCount,
                                                            changeFollowUnfollow: changeFollowUnfollow,
                                                            showDetails:false,
                                                          )
                                                      ));
                                                    },
                                                    child: Image.asset("lib/asset/icons/message@3x.png",height: 20,color: themeController.isDarkMode?MateColors.iconDark:MateColors.iconLight,),
                                                  ),
                                                  SizedBox(width: 20,),
                                                  InkWell(
                                                    onTap: (){
                                                      setState(() {
                                                        isBookMark[index] = !isBookMark[index];
                                                      });
                                                      _eventService.bookMark(id: list[index].id,token: token);
                                                    },
                                                    child: isBookMark[index]?
                                                    Image.asset("lib/asset/icons/bookmarkColor.png",height: 20) :
                                                    Image.asset("lib/asset/homePageIcons/drawerBookmark@3x.png",height: 20,color: themeController.isDarkMode?MateColors.iconDark:MateColors.iconLight,),
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
                        }else{
                          return Center(
                            child: Text("No data found",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                              ),
                            ),
                          );
                        }
                      }else if(snapshot.hasError){
                        return Center(
                          child: Text("Something went wrong",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                            ),
                          ),
                        );
                      }else{
                        return timelineLoader();
                      }
                    },
                  ),
                ),
                refreshPageOnBottomClick?
                timelineLoader():
                RefreshIndicator(
                  onRefresh: (){
                    return refreshPage();
                  },
                  child: FutureBuilder<EventListingModel>(
                    future: futureLocal,
                    builder: (context,snapshot){
                      if(snapshot.hasData){
                        if(snapshot.data.success==true || doingPaginationLocal==true){
                          if(enableFutureBuilderLocal){
                            if(doingPaginationLocal){
                              for(int i=0;i<snapshot.data.data.result.length;i++){
                                listLocal.add(snapshot.data.data.result[i]);
                                isBookMarkLocal.add(snapshot.data.data.result[i].isBookmarked!=null?true:false);
                                if(snapshot.data.data.result[i].isReacted!=null){
                                  reactionLocal.add(
                                      snapshot.data.data.result[i].isReacted.status=="Going"?
                                      "Going": snapshot.data.data.result[i].isReacted.status=="Interested"?
                                      "Interested":"none"
                                  );
                                }else{
                                  reactionLocal.add("none");
                                }
                              }
                              print("Local List length ${listLocal.length}");
                              print("Bookmark Local list length ${isBookMarkLocal.length}");
                              print("reaction local list length ${reactionLocal.length}");
                            }else{
                              listLocal.clear();
                              isBookMarkLocal.clear();
                              reactionLocal.clear();
                              for(int i=0;i<snapshot.data.data.result.length;i++){
                                listLocal.add(snapshot.data.data.result[i]);
                                isBookMarkLocal.add(snapshot.data.data.result[i].isBookmarked!=null?true:false);
                                if(snapshot.data.data.result[i].isReacted!=null){
                                  reactionLocal.add(
                                      snapshot.data.data.result[i].isReacted.status=="Going"?
                                      "Going": snapshot.data.data.result[i].isReacted.status=="Interested"?
                                      "Interested":"none"
                                  );
                                }else{
                                  reactionLocal.add("none");
                                }
                              }
                              print("Local List length ${listLocal.length}");
                              print("Bookmark Local list length ${isBookMarkLocal.length}");
                              print("reaction local list length ${reactionLocal.length}");
                            }
                            Future.delayed(Duration.zero,(){
                              enableFutureBuilderLocal = false;
                              setState(() {});
                            });
                          }
                          return ListView(
                            controller: _scrollController,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            children: [
                              SizedBox(height: 20,),
                              ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                itemCount: listLocal.length,
                                itemBuilder: (context,index){
                                  return Container(
                                    margin: EdgeInsets.symmetric(horizontal: 16,vertical: 10),
                                    decoration: BoxDecoration(
                                      color: themeController.isDarkMode?MateColors.drawerTileColor:Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ListTile(
                                          onTap: (){
                                            if(listLocal[index].user.uuid!=null){
                                              if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == listLocal[index].user.uuid) {
                                                Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                                              }else{
                                                Navigator.of(context).pushNamed(UserProfileScreen.routeName,
                                                    arguments: {
                                                      "id": listLocal[index].user.uuid,
                                                      "name": listLocal[index].user.displayName,
                                                      "photoUrl": listLocal[index].user.profilePhoto,
                                                      "firebaseUid": listLocal[index].user.firebaseUid,
                                                    });
                                              }
                                            }
                                          },
                                          leading: CircleAvatar(
                                            radius: 16,
                                            backgroundColor: MateColors.activeIcons,
                                            backgroundImage: NetworkImage(listLocal[index].user.profilePhoto),
                                          ),
                                          title: Text(
                                            listLocal[index].user.displayName,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0.1,
                                              color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                                            ),
                                          ),
                                          subtitle: Text(
                                            DateFormat('dd MMMM yyyy').format(DateTime.parse(listLocal[index].createdAt.toString()).toLocal()).toString(),
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
                                            ),
                                          ),
                                          trailing: PopupMenuButton<int>(
                                              padding: EdgeInsets.only(bottom: 0, top: 0, left: 25, right: 0),
                                              color: themeController.isDarkMode?backgroundColor:Colors.white,
                                              icon: Image.asset(
                                                "lib/asset/icons/menu@3x.png",
                                                height: 18,
                                              ),
                                              onSelected: (index1) async {
                                                if (index1 == 0) {
                                                  gCal.Event event = gCal.Event(); // Create object of event
                                                  event.summary = listLocal[index].title; //Setting summary of object
                                                  event.description = listLocal[index].description; //Setting summary of object

                                                  gCal.EventDateTime start = new gCal.EventDateTime(); //Setting start time
                                                  start.dateTime = DateTime.parse(listLocal[index].createdAt.toString()).toLocal();
                                                  start.timeZone = "GMT+05:00";
                                                  event.start = start;

                                                  gCal.EventDateTime end = new gCal.EventDateTime(); //setting end time
                                                  end.timeZone = "GMT+05:00";
                                                  end.dateTime = DateTime.parse(listLocal[index].createdAt.toString()).toLocal();
                                                  event.end = end;

                                                  insertEvent(event);
                                                }else if(index1 == 1){
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => Chat(peerUuid: listLocal[index].user.uuid, currentUserId: _currentUser.uid, peerId: listLocal[index].user.firebaseUid, peerAvatar: listLocal[index].user.profilePhoto, peerName: listLocal[index].user.displayName)));
                                                }else if(index1 == 2){
                                                  _showFollowAlertDialog(eventId: listLocal[index].id, indexVal: index,tabIndex: 1,isFollowed: listLocal[index].isFollowed);
                                                }else if(index1 == 3){
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ReportPage(moduleId: listLocal[index].id, moduleType: "Event",),));
                                                }else if(index1 == 4){
                                                  _showDeleteAlertDialog(eventId: listLocal[index].id, indexVal: index,tabIndex: 1);
                                                }
                                              },
                                              itemBuilder: (context) => [
                                                // PopupMenuItem(
                                                //   value: 0,
                                                //   height: 40,
                                                //   child: Text(
                                                //     "Calendar",
                                                //     textAlign: TextAlign.start,
                                                //     style: TextStyle(color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor, fontWeight: FontWeight.w500, fontSize: 12.6.sp),
                                                //   ),
                                                // ),
                                                PopupMenuItem(
                                                  value: 1,
                                                  height: 40,
                                                  child: Text(
                                                    "Message",
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor, fontWeight: FontWeight.w500, fontSize: 12.6.sp),
                                                  ),
                                                ),
                                                PopupMenuItem(
                                                  value: 2,
                                                  height: 40,
                                                  child: Text(
                                                    listLocal[index].isFollowed?"Unfollow Event":"Follow Event",
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor, fontWeight: FontWeight.w500, fontSize: 12.6.sp),
                                                  ),
                                                ),
                                                PopupMenuItem(
                                                  value: 3,
                                                  height: 40,
                                                  child: Text(
                                                    "Report",
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor, fontWeight: FontWeight.w500, fontSize: 12.6.sp),
                                                  ),
                                                ),
                                                ((Provider.of<AuthUserProvider>(context, listen: false).authUser.id == list[index].user.uuid))?
                                                PopupMenuItem(
                                                  value: 4,
                                                  height: 40,
                                                  child: Text(
                                                    "Delete Event",
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor, fontWeight: FontWeight.w500, fontSize: 12.6.sp),
                                                  ),
                                                ):PopupMenuItem(
                                                  value: 4,
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
                                        InkWell(
                                          onTap: (){
                                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
                                                EventDetails(
                                                  list: listLocal[index],
                                                  isBookmark: isBookMarkLocal[index],
                                                  index: index,
                                                  changeBookmark: changeBookmark,
                                                  reaction: reactionLocal[index],
                                                  changeReaction: changeReaction,
                                                  changeCommentCount: changeCommentCount,
                                                  changeFollowUnfollow: changeFollowUnfollow,
                                                )
                                            ));
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 16,top: 0),
                                            child: Text(
                                              listLocal[index].title,
                                              style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w700,
                                                color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: (){
                                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
                                                EventDetails(
                                                  list: listLocal[index],
                                                  isBookmark: isBookMarkLocal[index],
                                                  index: index,
                                                  changeBookmark: changeBookmark,
                                                  reaction: reactionLocal[index],
                                                  changeReaction: changeReaction,
                                                  changeCommentCount: changeCommentCount,
                                                  changeFollowUnfollow: changeFollowUnfollow,
                                                )
                                            ));
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 16,top: 10,right: 10),
                                            child: Text(
                                              listLocal[index].description,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                letterSpacing: 0.1,
                                                color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                                              ),
                                            ),
                                          ),
                                        ),

                                        listLocal[index].hyperLinkText!=null && listLocal[index].hyperLink!=null ?
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async{
                                            if (await canLaunch(listLocal[index].hyperLink))
                                              await launch(listLocal[index].hyperLink);
                                            else
                                              Fluttertoast.showToast(msg: " Could not launch given URL '${listLocal[index].hyperLink}'", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
                                            throw "Could not launch ${listLocal[index].hyperLink}";
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 16,top: 10,right: 10),
                                            child: Text(
                                              listLocal[index].hyperLinkText,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 0.1,
                                                color: MateColors.activeIcons,
                                              ),
                                            ),
                                          ),
                                        ):SizedBox(),


                                        Padding(
                                          padding: EdgeInsets.only(left: 16,top: 10,right: 10),
                                          child: Row(
                                            children: [
                                              Image.asset("lib/asset/icons/pinEvent.png",
                                                height: 20,
                                                width: 14,
                                                fit: BoxFit.fitHeight,
                                              ),
                                              SizedBox(width: 8,),
                                              Text(
                                                listLocal[index].location,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  letterSpacing: 0.1,
                                                  color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 16,top: 10,right: 10),
                                          child: Row(
                                            children: [
                                              Image.asset("lib/asset/icons/calendarEvent.png",
                                                height: 14,
                                              ),
                                              SizedBox(width: 8,),
                                              Text(
                                                DateFormat('dd MMMM yyyy').format(DateTime.parse(listLocal[index].date.toString()).toLocal()).toString(),
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  letterSpacing: 0.1,
                                                  color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 16,top: 10,right: 10),
                                          child: Row(
                                            children: [
                                              Image.asset("lib/asset/icons/clockEvent.png",
                                                height: 14,
                                              ),
                                              SizedBox(width: 8,),
                                              Text(
                                                DateFormat('hh:mm a').format(DateTime.parse(listLocal[index].time.toString())).toString(),
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  letterSpacing: 0.1,
                                                  color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                                                ),
                                              ),
                                              if(listLocal[index].endTime!=null)
                                                Text(
                                                  " - "+DateFormat('hh:mm a').format(DateTime.parse(listLocal[index].endTime).toLocal()).toString(),
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    letterSpacing: 0.1,
                                                    color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                        if(listLocal[index].goingList.length>0)
                                        Container(
                                          height: 40,
                                          margin: EdgeInsets.only(left: 16,top: 10),
                                          width: MediaQuery.of(context).size.width,
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              ListView.builder(
                                                  scrollDirection: Axis.horizontal,
                                                  shrinkWrap: true,
                                                  physics: ScrollPhysics(),
                                                  itemCount: listLocal[index].goingList.length>6?6:listLocal[index].goingList.length,
                                                  itemBuilder: (context,ind){
                                                    return InkWell(
                                                      onTap: (){
                                                        Get.to(MemberList(list: listLocal[index].goingList,));
                                                      },
                                                      child: CircleAvatar(
                                                        radius: 12,
                                                        backgroundColor: MateColors.activeIcons,
                                                        backgroundImage: NetworkImage(listLocal[index].goingList[ind].profilePhoto),
                                                      ),
                                                    );
                                                  }
                                              ),
                                              listLocal[index].goingList.length>6?
                                              InkWell(
                                                onTap: (){
                                                  Get.to(MemberList(list: listLocal[index].goingList,));
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 5),
                                                  child: Text("+${listLocal[index].goingList.length -6}",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
                                                    ),
                                                  ),
                                                ),
                                              ):
                                              Offstage(),
                                            ],
                                          ),
                                        ),
                                        if(listLocal[index].photoUrl!=null || listLocal[index].videoUrl!=null)
                                          Container(
                                            height: 150,
                                            margin: EdgeInsets.only(bottom: 0.0, left: 16, right: 16, top: 10),
                                            child: ListView.builder(
                                                scrollDirection: Axis.horizontal,
                                                shrinkWrap: true,
                                                physics: BouncingScrollPhysics(),
                                                itemCount: listLocal[index].photoUrl!=null && listLocal[index].videoUrl!=null? 2 : listLocal[index].photoUrl!=null?1:listLocal[index].videoUrl!=null?1:0,
                                                itemBuilder: (context,indexSwipe){
                                                  if(indexSwipe==0){
                                                    return
                                                      listLocal[index].photoUrl!=null?
                                                      Padding(
                                                        padding: const EdgeInsets.only(bottom: 0.0, left: 0, right: 0, top: 10),
                                                        child: Container(
                                                          height: 150,
                                                          width: MediaQuery.of(context).size.width/1.2,
                                                          child: InkWell(
                                                            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                                                                builder: (context) => FullImageWidget(
                                                                  imagePath: listLocal[index].photoUrl,
                                                                ))),
                                                            child: ClipRRect(
                                                              borderRadius: BorderRadius.circular(12.0),
                                                              clipBehavior: Clip.hardEdge,
                                                              child: Image.network(
                                                                listLocal[index].photoUrl,
                                                                fit: BoxFit.cover,
                                                                // height: 300,
                                                                // width: 400,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ):listLocal[index].videoUrl!=null?
                                                      VideoThumbnail(videoUrl: listLocal[index].videoUrl,isLeftPadding: false,):Container();;
                                                  }else{
                                                    return listLocal[index].videoUrl!=null?
                                                    VideoThumbnail(videoUrl: listLocal[index].videoUrl):Container();
                                                  }
                                                }
                                            ),
                                          ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 16,right: 16,top: 25),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  InkWell(
                                                    onTap: (){
                                                      if(reactionLocal[index]=="Going"){
                                                        reactionLocal[index] = "none";
                                                        setState(() {});
                                                        _eventService.reaction(id: listLocal[index].id,reaction: "none",token: token);
                                                      }else{
                                                        reactionLocal[index] = "Going";
                                                        setState(() {});
                                                        _eventService.reaction(id: listLocal[index].id,reaction: "Going",token: token);
                                                      }
                                                    },
                                                    child: Container(
                                                      height: 32,
                                                      width: 72,
                                                      decoration: BoxDecoration(
                                                        color: reactionLocal[index]=="Going"?MateColors.activeIcons:Colors.transparent,
                                                        borderRadius: BorderRadius.circular(16),
                                                        border: Border.all(color: themeController.isDarkMode?MateColors.darkDivider:MateColors.lightDivider,width: 1),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          "Going",
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w500,
                                                            letterSpacing: 0.1,
                                                            color: themeController.isDarkMode? reactionLocal[index]=="Going"? MateColors.blackTextColor:Colors.white:
                                                            reactionLocal[index]=="Going"?Colors.white:MateColors.blackTextColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 10,),
                                                  InkWell(
                                                    onTap: (){
                                                      if(reaction[index]=="Interested"){
                                                        reactionLocal[index] = "none";
                                                        setState(() {});
                                                        _eventService.reaction(id: listLocal[index].id,reaction: "none",token: token);
                                                      }else{
                                                        reactionLocal[index] = "Interested";
                                                        setState(() {});
                                                        _eventService.reaction(id: listLocal[index].id,reaction: "Interested",token: token);
                                                      }
                                                    },
                                                    child: Container(
                                                      height: 32,
                                                      width: 99,
                                                      decoration: BoxDecoration(
                                                        color: reactionLocal[index]=="Interested"?MateColors.activeIcons:Colors.transparent,
                                                        borderRadius: BorderRadius.circular(16),
                                                        border: Border.all(color: themeController.isDarkMode?MateColors.darkDivider:MateColors.lightDivider,width: 1),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          "Interested",
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            fontWeight: FontWeight.w500,
                                                            letterSpacing: 0.1,
                                                            color: themeController.isDarkMode? reactionLocal[index]=="Interested"? MateColors.blackTextColor:Colors.white:
                                                            reactionLocal[index]=="Interested"?Colors.white:MateColors.blackTextColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                   listLocal[index].commentsCount.toString(),
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
                                                    ),
                                                  ),
                                                  SizedBox(width: 10,),
                                                  InkWell(
                                                    onTap: (){
                                                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
                                                          EventDetails(
                                                            list: listLocal[index],
                                                            isBookmark: isBookMarkLocal[index],
                                                            index: index,
                                                            changeBookmark: changeBookmark,
                                                            reaction: reactionLocal[index],
                                                            changeReaction: changeReaction,
                                                            changeCommentCount: changeCommentCount,
                                                            changeFollowUnfollow: changeFollowUnfollow,
                                                            showDetails:false,
                                                          )
                                                      ));
                                                    },
                                                    child: Image.asset("lib/asset/icons/message@3x.png",height: 20,color: themeController.isDarkMode?MateColors.iconDark:MateColors.iconLight,),
                                                  ),
                                                  SizedBox(width: 20,),
                                                  InkWell(
                                                    onTap: (){
                                                      setState(() {
                                                        isBookMarkLocal[index] = !isBookMarkLocal[index];
                                                      });
                                                      _eventService.bookMark(id: listLocal[index].id,token: token);
                                                    },
                                                    child: isBookMarkLocal[index]?
                                                    Image.asset("lib/asset/icons/bookmarkColor.png",height: 20) :
                                                    Image.asset("lib/asset/homePageIcons/drawerBookmark@3x.png",height: 20,color: themeController.isDarkMode?MateColors.iconDark:MateColors.iconLight,),
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
                        }else{
                          return Center(
                            child: Text("No data found",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                              ),
                            ),
                          );
                        }
                      }else if(snapshot.hasError){
                        return Center(
                          child: Text("Something went wrong",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                            ),
                          ),
                        );
                      }else{
                        return timelineLoader();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _appBarLeading(BuildContext context) {
    return Selector<AuthUserProvider, String>(
      selector: (ctx, authUserProvider) => authUserProvider.authUserPhoto,
      builder: (ctx, data, _) {
        return InkWell(
            onTap: () {
              _key.currentState.openDrawer();
            },
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 16,
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 16,
                backgroundImage: NetworkImage(data),
                // child: ClipOval(
                //     child: Image.network(
                //       data,
                //     ),
                // ),
              ),
            ),
        );
      },
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

  _showFollowAlertDialog({@required int eventId, @required int indexVal,@required int tabIndex,@required isFollowed}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: new Text("Are you sure?"),
          content: new Text(isFollowed?"You want to Unfollow this event":"You want to follow this event"),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: feedProvider.feedFollowLoader?
              Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ):
              Text("Yes"),
              onPressed: () async {
                if(tabIndex==0){
                  if(isFollowed){
                    Map<String, dynamic> body = {"post_id": eventId, "post_type": "Event"};
                    bool unFollowDone = await feedProvider.unFollowAFeed(body, eventId);
                    if (unFollowDone) {
                      list[indexVal].isFollowed = false;
                      setState(() {});
                      Navigator.pop(context);
                    }
                  }else{
                    Map<String, dynamic> body = {"post_id": eventId, "post_type": "Event"};
                    bool followDone = await feedProvider.followAFeed(body, eventId);
                    if (followDone) {
                      list[indexVal].isFollowed = true;
                      setState(() {});
                      Navigator.pop(context);
                    }
                  }
                }else{
                  if(isFollowed){
                    Map<String, dynamic> body = {"post_id": eventId, "post_type": "Event"};
                    bool unFollowDone = await feedProvider.unFollowAFeed(body, eventId);
                    if (unFollowDone) {
                      listLocal[indexVal].isFollowed = false;
                      setState(() {});
                      Navigator.pop(context);
                    }
                  }else{
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

  _showDeleteAlertDialog({@required int eventId, @required int indexVal,@required tabIndex})async{
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
              onPressed: ()async{
                bool res = await _eventService.deleteEvent(id: eventId,token: token);
                Navigator.of(context).pop();
                if(res){
                  getStoredValue();
                }else{
                  Fluttertoast.showToast(msg: "Something went wrong", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
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
