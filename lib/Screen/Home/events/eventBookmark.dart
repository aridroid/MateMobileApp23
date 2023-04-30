import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Providers/AuthUserProvider.dart';
import '../../../Providers/FeedProvider.dart';
import '../../../Services/eventService.dart';
import '../../../Widget/Loaders/Shimmer.dart';
import '../../../Widget/mediaViewer.dart';
import '../../../Widget/video_thumbnail.dart';
import '../../../asset/Colors/MateColors.dart';
import '../../../constant.dart';
import '../../../controller/theme_controller.dart';
import 'package:mate_app/Model/eventListingModel.dart';

import '../../Profile/ProfileScreen.dart';
import '../../Profile/UserProfileScreen.dart';
import 'package:googleapis/calendar/v3.dart' as gCal;

import '../../Report/reportPage.dart';
import '../../chat1/screens/chat.dart';
import 'editEvent.dart';
import 'eventDetails.dart';
import 'memberList.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class EventBookmark extends StatefulWidget {
  const EventBookmark({Key key}) : super(key: key);

  @override
  State<EventBookmark> createState() => _EventBookmarkState();
}

class _EventBookmarkState extends State<EventBookmark> {
  ThemeController themeController = Get.find<ThemeController>();
  EventService _eventService = EventService();
  ScrollController _scrollController;
  List<Result> list = [];
  List<bool> isBookMark = [];
  List<String> reaction = [];
  Future<EventListingModel> future;
  int page = 1;
  bool enableFutureBuilder = false;
  bool doingPagination = false;
  String token = "";
  FeedProvider feedProvider;
  auth.User _currentUser = auth.FirebaseAuth.instance.currentUser;
  ClientId _credentials;

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
          future = _eventService.getEventListingBookmark(page: page, token: token);
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

    setState(() {
      doingPagination = false;
      page = 1;
    });

    future = _eventService.getEventListingBookmark(page: page, token: token);
    future.then((value) {
      setState(() {
        enableFutureBuilder = true;
      });
    });
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
    future = _eventService.getEventListingBookmark(page: page, token: token);
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
    return RefreshIndicator(
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
                padding: EdgeInsets.only(top: 10),
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
                                child: buildEmojiAndText(
                                  content: list[index].title,
                                  textStyle: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w700,
                                    color: themeController.isDarkMode?Colors.white:Colors.black,
                                  ),
                                  normalFontSize: 16,
                                  emojiFontSize: 26,
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
                                child: buildEmojiAndText(
                                  content: list[index].description,
                                  textStyle: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 0.1,
                                    color: themeController.isDarkMode?Colors.white:Colors.black,
                                  ),
                                  normalFontSize: 14,
                                  emojiFontSize: 24,
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
                                        onTap: ()async{
                                          setState(() {
                                            isBookMark[index] = !isBookMark[index];
                                          });
                                          await _eventService.bookMark(id: list[index].id, token: token);
                                          refreshPage();
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
    );

    //   Scaffold(
    //   body: Container(
    //     height: scH,
    //     width: scW,
    //     decoration: BoxDecoration(
    //       color: themeController.isDarkMode?Color(0xFF000000):Colors.white,
    //       image: DecorationImage(
    //         image: AssetImage(themeController.isDarkMode?'lib/asset/Background.png':'lib/asset/BackgroundLight.png'),
    //         fit: BoxFit.cover,
    //       ),
    //     ),
    //     child: Column(
    //       children: [
    //         Padding(
    //           padding: EdgeInsets.only(
    //             top: MediaQuery.of(context).size.height*0.07,
    //             left: 16,
    //             right: 16,
    //           ),
    //           child: Row(
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             children: [
    //               GestureDetector(
    //                 onTap: (){
    //                   Get.back();
    //                 },
    //                 child: Icon(Icons.arrow_back_ios,
    //                   size: 20,
    //                   color: themeController.isDarkMode ? Colors.white : MateColors.blackTextColor,
    //                 ),
    //               ),
    //               Text(
    //                 "Events",
    //                 style: TextStyle(
    //                   color: themeController.isDarkMode ? Colors.white : MateColors.blackTextColor,
    //                   fontWeight: FontWeight.w700,
    //                   fontSize: 17.0,
    //                 ),
    //               ),
    //               SizedBox(),
    //             ],
    //           ),
    //         ),
    //         Expanded(
    //           child: RefreshIndicator(
    //             onRefresh: () {
    //               return refreshPage();
    //             },
    //             child: FutureBuilder<EventListingModel>(
    //               future: future,
    //               builder: (context, snapshot) {
    //                 if (snapshot.hasData) {
    //                   if (snapshot.data.success == true || doingPagination == true) {
    //                     if (enableFutureBuilder) {
    //                       if (doingPagination) {
    //                         for (int i = 0; i < snapshot.data.data.result.length; i++) {
    //                           list.add(snapshot.data.data.result[i]);
    //                           isBookMark.add(snapshot.data.data.result[i].isBookmarked != null ? true : false);
    //                           if (snapshot.data.data.result[i].isReacted != null) {
    //                             reaction.add(
    //                                 snapshot.data.data.result[i].isReacted.status == "Going" ?
    //                                 "Going" : snapshot.data.data.result[i].isReacted.status == "Interested" ?
    //                                 "Interested" : "none"
    //                             );
    //                           } else {
    //                             reaction.add("none");
    //                           }
    //                         }
    //                         print("List length ${list.length}");
    //                         print("Bookmark list length ${isBookMark.length}");
    //                         print("Reaction list length ${reaction.length}");
    //                       } else {
    //                         list.clear();
    //                         isBookMark.clear();
    //                         reaction.clear();
    //                         for (int i = 0; i < snapshot.data.data.result.length; i++) {
    //                           list.add(snapshot.data.data.result[i]);
    //                           isBookMark.add(snapshot.data.data.result[i].isBookmarked != null ? true : false);
    //                           if (snapshot.data.data.result[i].isReacted != null) {
    //                             reaction.add(
    //                                 snapshot.data.data.result[i].isReacted.status == "Going" ?
    //                                 "Going" : snapshot.data.data.result[i].isReacted.status == "Interested" ?
    //                                 "Interested" : "none"
    //                             );
    //                           } else {
    //                             reaction.add("none");
    //                           }
    //                         }
    //                         print("List length ${list.length}");
    //                         print("Bookmark list length ${isBookMark.length}");
    //                         print("Reaction list length ${reaction.length}");
    //                       }
    //                       Future.delayed(Duration.zero, () {
    //                         enableFutureBuilder = false;
    //                         setState(() {});
    //                       });
    //                     }
    //                     return ListView(
    //                       scrollDirection: Axis.vertical,
    //                       shrinkWrap: true,
    //                       physics: ScrollPhysics(),
    //                       controller: _scrollController,
    //                       padding: EdgeInsets.only(top: 10),
    //                       children: [
    //                         ListView.builder(
    //                           scrollDirection: Axis.vertical,
    //                           padding: EdgeInsets.zero,
    //                           shrinkWrap: true,
    //                           physics: ScrollPhysics(),
    //                           itemCount: list.length,
    //                           itemBuilder: (context, index) {
    //                             return Container(
    //                               margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    //                               decoration: BoxDecoration(
    //                                 color: themeController.isDarkMode ? MateColors.containerDark : MateColors.containerLight,
    //                                 borderRadius: BorderRadius.circular(14),
    //                               ),
    //                               child: Column(
    //                                 crossAxisAlignment: CrossAxisAlignment.start,
    //                                 children: [
    //                                   ListTile(
    //                                     onTap: () {
    //                                       if (list[index].user.uuid != null) {
    //                                         if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == list[index].user.uuid) {
    //                                           Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
    //                                         } else {
    //                                           Navigator.of(context).pushNamed(UserProfileScreen.routeName,
    //                                               arguments: {
    //                                                 "id": list[index].user.uuid,
    //                                                 "name": list[index].user.displayName,
    //                                                 "photoUrl": list[index].user.profilePhoto,
    //                                                 "firebaseUid": list[index].user.firebaseUid,
    //                                               });
    //                                         }
    //                                       }
    //                                     },
    //                                     leading: CircleAvatar(
    //                                       radius: 20,
    //                                       backgroundImage: NetworkImage(list[index].user.profilePhoto),
    //                                     ),
    //                                     title: Text(
    //                                       list[index].user.displayName,
    //                                       style: TextStyle(
    //                                         fontSize: 15,
    //                                         fontFamily: 'Poppins',
    //                                         fontWeight: FontWeight.w600,
    //                                         color: themeController.isDarkMode?Colors.white:Colors.black,
    //                                       ),
    //                                     ),
    //                                     subtitle: Text(
    //                                       DateFormat('dd MMMM yyyy').format(DateTime.parse(list[index].createdAt.toString()).toLocal()).toString(),
    //                                       style: TextStyle(
    //                                         fontSize: 14,
    //                                         color: themeController.isDarkMode?MateColors.helpingTextDark:Colors.black.withOpacity(0.72),
    //                                       ),
    //                                     ),
    //                                     trailing: PopupMenuButton<int>(
    //                                         padding: EdgeInsets.zero,
    //                                         elevation: 0,
    //                                         color: themeController.isDarkMode?MateColors.popupDark:MateColors.popupLight,
    //                                         icon: Icon(
    //                                           Icons.more_vert,
    //                                           color: themeController.isDarkMode?Colors.white:MateColors.blackText,
    //                                         ),
    //                                         onSelected: (index1) async {
    //                                           if (index1 == 0) {
    //                                             gCal.Event event = gCal.Event(); // Create object of event
    //                                             event.summary = list[index].title; //Setting summary of object
    //                                             event.description = list[index].description; //Setting summary of object
    //
    //                                             gCal.EventDateTime start = new gCal.EventDateTime(); //Setting start time
    //                                             start.dateTime = DateTime.parse(list[index].createdAt.toString()).toLocal();
    //                                             start.timeZone = "GMT+05:00";
    //                                             event.start = start;
    //
    //                                             gCal.EventDateTime end = new gCal.EventDateTime(); //setting end time
    //                                             end.timeZone = "GMT+05:00";
    //                                             end.dateTime = DateTime.parse(list[index].createdAt.toString()).toLocal();
    //                                             event.end = end;
    //
    //                                             insertEvent(event);
    //                                           } else if (index1 == 1) {
    //                                             Navigator.push(context, MaterialPageRoute(builder: (context) =>
    //                                                 Chat(peerUuid: list[index].user.uuid,
    //                                                     currentUserId: _currentUser.uid,
    //                                                     peerId: list[index].user.firebaseUid,
    //                                                     peerAvatar: list[index].user.profilePhoto,
    //                                                     peerName: list[index].user.displayName)));
    //                                           } else if (index1 == 2) {
    //                                             _showFollowAlertDialog(eventId: list[index].id, indexVal: index, tabIndex: 0, isFollowed: list[index].isFollowed);
    //                                           } else if (index1 == 3) {
    //                                             Navigator.push(context, MaterialPageRoute(builder: (context) => ReportPage(moduleId: list[index].id, moduleType: "Event",),));
    //                                           } else if (index1 == 4) {
    //                                             _showDeleteAlertDialog(eventId: list[index].id, indexVal: index, tabIndex: 0);
    //                                           } else if (index1 == 5) {
    //                                             await Navigator.push(context, MaterialPageRoute(builder: (context) => EditEvent(data: list[index]),));
    //                                             getStoredValue();
    //                                           }
    //                                         },
    //                                         itemBuilder: (context) => [
    //                                           PopupMenuItem(
    //                                             value: 1,
    //                                             height: 40,
    //                                             child: Text(
    //                                               "Message",
    //                                               textAlign: TextAlign.start,
    //                                               style: TextStyle(
    //                                                 color: themeController.isDarkMode?Colors.white:Colors.black,
    //                                                 fontWeight: FontWeight.w500,
    //                                                 fontFamily: 'Poppins',
    //                                                 fontSize: 14,
    //                                               ),
    //                                             ),
    //                                           ),
    //                                           PopupMenuItem(
    //                                             value: 2,
    //                                             height: 40,
    //                                             child: Text(
    //                                               list[index].isFollowed ? "Unfollow Event" : "Follow Event",
    //                                               textAlign: TextAlign.start,
    //                                               style: TextStyle(
    //                                                 color: themeController.isDarkMode?Colors.white:Colors.black,
    //                                                 fontWeight: FontWeight.w500,
    //                                                 fontFamily: 'Poppins',
    //                                                 fontSize: 14,
    //                                               ),
    //                                             ),
    //                                           ),
    //                                           PopupMenuItem(
    //                                             value: 3,
    //                                             height: 40,
    //                                             child: Text(
    //                                               "Report",
    //                                               textAlign: TextAlign.start,
    //                                               style: TextStyle(
    //                                                 color: themeController.isDarkMode?Colors.white:Colors.black,
    //                                                 fontWeight: FontWeight.w500,
    //                                                 fontFamily: 'Poppins',
    //                                                 fontSize: 14,
    //                                               ),
    //                                             ),
    //                                           ),
    //                                           ((Provider
    //                                               .of<AuthUserProvider>(context, listen: false)
    //                                               .authUser
    //                                               .id == list[index].user.uuid)) ?
    //                                           PopupMenuItem(
    //                                             value: 4,
    //                                             height: 40,
    //                                             child: Text(
    //                                               "Delete Event",
    //                                               textAlign: TextAlign.start,
    //                                               style: TextStyle(
    //                                                 color: themeController.isDarkMode?Colors.white:Colors.black,
    //                                                 fontWeight: FontWeight.w500,
    //                                                 fontFamily: 'Poppins',
    //                                                 fontSize: 14,
    //                                               ),
    //                                             ),
    //                                           ) : PopupMenuItem(
    //                                             value: 4,
    //                                             enabled: false,
    //                                             height: 0,
    //                                             child: SizedBox(
    //                                               height: 0,
    //                                               width: 0,
    //                                             ),
    //                                           ),
    //                                           ((Provider
    //                                               .of<AuthUserProvider>(context, listen: false)
    //                                               .authUser
    //                                               .id == list[index].user.uuid)) ?
    //                                           PopupMenuItem(
    //                                             value: 5,
    //                                             height: 40,
    //                                             child: Text(
    //                                               "Edit Event",
    //                                               textAlign: TextAlign.start,
    //                                               style: TextStyle(
    //                                                 color: themeController.isDarkMode?Colors.white:Colors.black,
    //                                                 fontWeight: FontWeight.w500,
    //                                                 fontFamily: 'Poppins',
    //                                                 fontSize: 14,
    //                                               ),
    //                                             ),
    //                                           ) : PopupMenuItem(
    //                                             value: 5,
    //                                             enabled: false,
    //                                             height: 0,
    //                                             child: SizedBox(
    //                                               height: 0,
    //                                               width: 0,
    //                                             ),
    //                                           ),
    //                                         ]
    //                                     ),
    //                                   ),
    //                                   Padding(
    //                                     padding: const EdgeInsets.symmetric(horizontal: 16),
    //                                     child: Divider(
    //                                       thickness: 1,
    //                                       color: themeController.isDarkMode?MateColors.dividerDark:MateColors.dividerLight,
    //                                     ),
    //                                   ),
    //                                   InkWell(
    //                                     onTap: () {
    //                                       Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
    //                                           EventDetails(
    //                                             list: list[index],
    //                                             isBookmark: isBookMark[index],
    //                                             index: index,
    //                                             changeBookmark: changeBookmark,
    //                                             reaction: reaction[index],
    //                                             changeReaction: changeReaction,
    //                                             changeCommentCount: changeCommentCount,
    //                                             changeFollowUnfollow: changeFollowUnfollow,
    //                                           )
    //                                       ));
    //                                     },
    //                                     child: Padding(
    //                                       padding: EdgeInsets.only(left: 16, top: 5),
    //                                       child: Text(
    //                                         list[index].title,
    //                                         style: TextStyle(
    //                                           fontSize: 16,
    //                                           fontFamily: 'Poppins',
    //                                           fontWeight: FontWeight.w700,
    //                                           color: themeController.isDarkMode?Colors.white:Colors.black,
    //                                         ),
    //                                       ),
    //                                     ),
    //                                   ),
    //                                   InkWell(
    //                                     onTap: () {
    //                                       Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
    //                                           EventDetails(
    //                                             list: list[index],
    //                                             isBookmark: isBookMark[index],
    //                                             index: index,
    //                                             changeBookmark: changeBookmark,
    //                                             reaction: reaction[index],
    //                                             changeReaction: changeReaction,
    //                                             changeCommentCount: changeCommentCount,
    //                                             changeFollowUnfollow: changeFollowUnfollow,
    //                                           )
    //                                       ));
    //                                     },
    //                                     child: Padding(
    //                                       padding: EdgeInsets.only(left: 16, top: 10, right: 10),
    //                                       child: Text(
    //                                         list[index].description,
    //                                         style: TextStyle(
    //                                           fontSize: 14,
    //                                           fontFamily: 'Poppins',
    //                                           fontWeight: FontWeight.w400,
    //                                           letterSpacing: 0.1,
    //                                           color: themeController.isDarkMode?Colors.white:Colors.black,
    //                                         ),
    //                                       ),
    //                                     ),
    //                                   ),
    //                                   list[index].hyperLinkText != null && list[index].hyperLink != null ?
    //                                   InkWell(
    //                                     splashColor: Colors.transparent,
    //                                     highlightColor: Colors.transparent,
    //                                     onTap: () async {
    //                                       if (await canLaunch(list[index].hyperLink))
    //                                         await launch(list[index].hyperLink);
    //                                       else
    //                                         Fluttertoast.showToast(msg: " Could not launch given URL '${list[index].hyperLink}'",
    //                                             fontSize: 16,
    //                                             backgroundColor: Colors.black54,
    //                                             textColor: Colors.white,
    //                                             toastLength: Toast.LENGTH_LONG);
    //                                       throw "Could not launch ${list[index].hyperLink}";
    //                                     },
    //                                     child: Padding(
    //                                       padding: EdgeInsets.only(left: 16, top: 10, right: 10),
    //                                       child: Text(
    //                                         list[index].hyperLinkText,
    //                                         style: TextStyle(
    //                                           fontSize: 14,
    //                                           fontFamily: 'Poppins',
    //                                           color: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
    //                                         ),
    //                                       ),
    //                                     ),
    //                                   ) : SizedBox(),
    //                                   Padding(
    //                                     padding: EdgeInsets.only(left: 16, top: 10, right: 10),
    //                                     child: Row(
    //                                       children: [
    //                                         Image.asset("lib/asset/icons/pinEvent.png",
    //                                           height: 20,
    //                                           width: 14,
    //                                           fit: BoxFit.fitHeight,
    //                                         ),
    //                                         SizedBox(width: 8,),
    //                                         Expanded(
    //                                           child: Text(
    //                                             list[index].location,
    //                                             style: TextStyle(
    //                                               fontSize: 14,
    //                                               fontWeight: FontWeight.w400,
    //                                               color: themeController.isDarkMode ? Colors.white : MateColors.blackTextColor,
    //                                             ),
    //                                           ),
    //                                         ),
    //                                       ],
    //                                     ),
    //                                   ),
    //                                   Padding(
    //                                     padding: EdgeInsets.only(left: 16, top: 10, right: 10),
    //                                     child: Row(
    //                                       children: [
    //                                         Image.asset("lib/asset/icons/calendarEvent.png",
    //                                           height: 14,
    //                                         ),
    //                                         SizedBox(width: 8,),
    //                                         Text(
    //                                           DateFormat('dd MMMM yyyy').format(DateTime.parse(list[index].date.toString()).toLocal()).toString(),
    //                                           style: TextStyle(
    //                                             fontSize: 14,
    //                                             fontWeight: FontWeight.w400,
    //                                             color: themeController.isDarkMode ? Colors.white : MateColors.blackTextColor,
    //                                           ),
    //                                         ),
    //                                       ],
    //                                     ),
    //                                   ),
    //                                   Padding(
    //                                     padding: EdgeInsets.only(left: 16, top: 10, right: 10),
    //                                     child: Row(
    //                                       children: [
    //                                         Image.asset("lib/asset/icons/clockEvent.png",
    //                                           height: 14,
    //                                         ),
    //                                         SizedBox(width: 8,),
    //                                         Text(
    //                                           DateFormat('hh:mm a').format(DateTime.parse(list[index].time.toString())).toString(),
    //                                           style: TextStyle(
    //                                             fontSize: 14,
    //                                             fontWeight: FontWeight.w400,
    //                                             color: themeController.isDarkMode ? Colors.white : MateColors.blackTextColor,
    //                                           ),
    //                                         ),
    //                                         if(list[index].endTime != null)
    //                                           Text(
    //                                             " - " + DateFormat('hh:mm a').format(DateTime.parse(list[index].endTime.toString())).toString(),
    //                                             style: TextStyle(
    //                                               fontSize: 14,
    //                                               fontWeight: FontWeight.w400,
    //                                               color: themeController.isDarkMode ? Colors.white : MateColors.blackTextColor,
    //                                             ),
    //                                           ),
    //                                       ],
    //                                     ),
    //                                   ),
    //                                   if(list[index].goingList.length > 0)
    //                                     Container(
    //                                       height: 40,
    //                                       margin: EdgeInsets.only(left: 16, top: 10),
    //                                       width: MediaQuery
    //                                           .of(context)
    //                                           .size
    //                                           .width,
    //                                       child: Row(
    //                                         crossAxisAlignment: CrossAxisAlignment.center,
    //                                         children: [
    //                                           ListView.builder(
    //                                               scrollDirection: Axis.horizontal,
    //                                               shrinkWrap: true,
    //                                               physics: ScrollPhysics(),
    //                                               itemCount: list[index].goingList.length > 6 ? 6 : list[index].goingList.length,
    //                                               itemBuilder: (context, ind) {
    //                                                 return InkWell(
    //                                                   onTap: () {
    //                                                     Get.to(MemberList(list: list[index].goingList,));
    //                                                   },
    //                                                   child: CircleAvatar(
    //                                                     radius: 12,
    //                                                     backgroundColor: MateColors.activeIcons,
    //                                                     backgroundImage: NetworkImage(list[index].goingList[ind].profilePhoto),
    //                                                   ),
    //                                                 );
    //                                               }
    //                                           ),
    //                                           list[index].goingList.length > 6 ?
    //                                           InkWell(
    //                                             onTap: () {
    //                                               Get.to(MemberList(list: list[index].goingList,));
    //                                             },
    //                                             child: Padding(
    //                                               padding: const EdgeInsets.only(left: 5),
    //                                               child: Text("+${list[index].goingList.length - 6}",
    //                                                 style: TextStyle(
    //                                                   fontSize: 14,
    //                                                   fontWeight: FontWeight.w400,
    //                                                   color: themeController.isDarkMode ? Colors.white : MateColors.blackTextColor,
    //                                                 ),
    //                                               ),
    //                                             ),
    //                                           ) :
    //                                           Offstage(),
    //                                         ],
    //                                       ),
    //                                     ),
    //                                   if(list[index].photoUrl != null || list[index].videoUrl != null)
    //                                     Container(
    //                                       height: 150,
    //                                       margin: EdgeInsets.only(bottom: 0.0, left: 16, right: 16, top: 10),
    //                                       child: ListView.builder(
    //                                           scrollDirection: Axis.horizontal,
    //                                           shrinkWrap: true,
    //                                           physics: BouncingScrollPhysics(),
    //                                           itemCount: list[index].photoUrl != null && list[index].videoUrl != null ? 2 : list[index].photoUrl != null ? 1 : list[index].videoUrl != null ? 1 : 0,
    //                                           itemBuilder: (context, indexSwipe) {
    //                                             if (indexSwipe == 0) {
    //                                               return
    //                                                 list[index].photoUrl != null ?
    //                                                 Padding(
    //                                                   padding: const EdgeInsets.only(bottom: 0.0, left: 0, right: 0, top: 10),
    //                                                   child: Container(
    //                                                     height: 150,
    //                                                     width: MediaQuery
    //                                                         .of(context)
    //                                                         .size
    //                                                         .width / 1.2,
    //                                                     child: InkWell(
    //                                                       onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MediaViewer(url: list[index].photoUrl,))),
    //                                                       child: ClipRRect(
    //                                                         borderRadius: BorderRadius.circular(12.0),
    //                                                         clipBehavior: Clip.hardEdge,
    //                                                         child: Image.network(
    //                                                           list[index].photoUrl,
    //                                                           fit: BoxFit.cover,
    //                                                         ),
    //                                                       ),
    //                                                     ),
    //                                                   ),
    //                                                 ) : list[index].videoUrl != null ?
    //                                                 VideoThumbnail(videoUrl: list[index].videoUrl, isLeftPadding: false,) : Container();
    //                                             } else {
    //                                               return list[index].videoUrl != null ?
    //                                               VideoThumbnail(videoUrl: list[index].videoUrl) : Container();
    //                                             }
    //                                           }
    //                                       ),
    //                                     ),
    //                                   Padding(
    //                                     padding: const EdgeInsets.only(left: 16, right: 16, top: 25),
    //                                     child: Row(
    //                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                                       children: [
    //                                         Row(
    //                                           children: [
    //                                             InkWell(
    //                                               onTap: () {
    //                                                 if (reaction[index] == "Going") {
    //                                                   reaction[index] = "none";
    //                                                   setState(() {});
    //                                                   _eventService.reaction(id: list[index].id, reaction: "none", token: token);
    //                                                 } else {
    //                                                   reaction[index] = "Going";
    //                                                   setState(() {});
    //                                                   _eventService.reaction(id: list[index].id, reaction: "Going", token: token);
    //                                                 }
    //                                               },
    //                                               child: Container(
    //                                                 height: 32,
    //                                                 width: 72,
    //                                                 decoration: BoxDecoration(
    //                                                   color: reaction[index] == "Going" ? MateColors.activeIcons : Colors.transparent,
    //                                                   borderRadius: BorderRadius.circular(16),
    //                                                   border: Border.all(color: themeController.isDarkMode ? Colors.white : Colors.black, width: 1),
    //                                                 ),
    //                                                 child: Center(
    //                                                   child: Text(
    //                                                     "Going",
    //                                                     style: TextStyle(
    //                                                       fontSize: 13,
    //                                                       fontWeight: FontWeight.w500,
    //                                                       letterSpacing: 0.1,
    //                                                       color: themeController.isDarkMode ? reaction[index] == "Going" ? MateColors.blackTextColor : Colors.white :
    //                                                       reaction[index] == "Going" ? Colors.white : MateColors.blackTextColor,
    //                                                     ),
    //                                                   ),
    //                                                 ),
    //                                               ),
    //                                             ),
    //                                             SizedBox(width: 10,),
    //                                             InkWell(
    //                                               onTap: () {
    //                                                 if (reaction[index] == "Interested") {
    //                                                   reaction[index] = "none";
    //                                                   setState(() {});
    //                                                   _eventService.reaction(id: list[index].id, reaction: "none", token: token);
    //                                                 } else {
    //                                                   reaction[index] = "Interested";
    //                                                   setState(() {});
    //                                                   _eventService.reaction(id: list[index].id, reaction: "Interested", token: token);
    //                                                 }
    //                                               },
    //                                               child: Container(
    //                                                 height: 32,
    //                                                 width: 99,
    //                                                 decoration: BoxDecoration(
    //                                                   color: reaction[index] == "Interested" ? MateColors.activeIcons : Colors.transparent,
    //                                                   borderRadius: BorderRadius.circular(16),
    //                                                   border: Border.all(color: themeController.isDarkMode ? Colors.white : Colors.black, width: 1),
    //                                                 ),
    //                                                 child: Center(
    //                                                   child: Text(
    //                                                     "Interested",
    //                                                     style: TextStyle(
    //                                                       fontSize: 13,
    //                                                       fontWeight: FontWeight.w500,
    //                                                       letterSpacing: 0.1,
    //                                                       color: themeController.isDarkMode ? reaction[index] == "Interested" ? MateColors.blackTextColor : Colors.white :
    //                                                       reaction[index] == "Interested" ? Colors.white : MateColors.blackTextColor,
    //                                                     ),
    //                                                   ),
    //                                                 ),
    //                                               ),
    //                                             ),
    //                                           ],
    //                                         ),
    //                                         Row(
    //                                           children: [
    //                                             InkWell(
    //                                               onTap: (){
    //                                                 Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
    //                                                     EventDetails(
    //                                                       list: list[index],
    //                                                       isBookmark: isBookMark[index],
    //                                                       index: index,
    //                                                       changeBookmark: changeBookmark,
    //                                                       reaction: reaction[index],
    //                                                       changeReaction: changeReaction,
    //                                                       changeCommentCount: changeCommentCount,
    //                                                       changeFollowUnfollow: changeFollowUnfollow,
    //                                                       showDetails: false,
    //                                                     )
    //                                                 ));
    //                                               },
    //                                               child: Container(
    //                                                 height: 39,
    //                                                 width: 83,
    //                                                 alignment: Alignment.center,
    //                                                 decoration: BoxDecoration(
    //                                                   color: themeController.isDarkMode?MateColors.smallContainerDark:MateColors.smallContainerLight,
    //                                                   borderRadius: BorderRadius.circular(25),
    //                                                 ),
    //                                                 child: Row(
    //                                                   mainAxisAlignment: MainAxisAlignment.center,
    //                                                   children: [
    //                                                     Padding(
    //                                                       padding: const EdgeInsets.all(10.0),
    //                                                       child: Image.asset("lib/asset/iconsNewDesign/msg.png",
    //                                                         color: themeController.isDarkMode?Colors.white:Colors.black,
    //                                                       ),
    //                                                     ),
    //                                                     Text(
    //                                                       list[index].commentsCount.toString(),
    //                                                       style: TextStyle(
    //                                                         fontFamily: "Poppins",
    //                                                         fontSize: 15,
    //                                                         fontWeight: FontWeight.w500,
    //                                                         color: themeController.isDarkMode?Colors.white:Colors.black,
    //                                                       ),
    //                                                     ),
    //                                                   ],
    //                                                 ),
    //                                               ),
    //                                             ),
    //                                             SizedBox(width: 10,),
    //                                             InkWell(
    //                                               onTap: ()async{
    //                                                 setState(() {
    //                                                   isBookMark[index] = !isBookMark[index];
    //                                                 });
    //                                                 await _eventService.bookMark(id: list[index].id, token: token);
    //                                                 refreshPage();
    //                                               },
    //                                               child: Container(
    //                                                 height: 39,
    //                                                 width: 40,
    //                                                 decoration: BoxDecoration(
    //                                                   color: themeController.isDarkMode?MateColors.smallContainerDark:MateColors.smallContainerLight,
    //                                                   shape: BoxShape.circle,
    //                                                 ),
    //                                                 child: isBookMark[index]?
    //                                                 Padding(
    //                                                   padding: const EdgeInsets.all(11.0),
    //                                                   child: Image.asset("lib/asset/icons/bookmarkColor.png",
    //                                                     color: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
    //                                                   ),
    //                                                 ):
    //                                                 Padding(
    //                                                   padding: const EdgeInsets.all(11.0),
    //                                                   child: Image.asset("lib/asset/homePageIcons/drawerBookmark@3x.png",
    //                                                     color: themeController.isDarkMode?Colors.white:Colors.black,
    //                                                   ),
    //                                                 ),
    //                                               ),
    //                                             ),
    //                                           ],
    //                                         ),
    //                                       ],
    //                                     ),
    //                                   ),
    //                                   SizedBox(height: 20,),
    //                                 ],
    //                               ),
    //                             );
    //                           },
    //                         ),
    //                       ],
    //                     );
    //                   } else {
    //                     return Center(
    //                       child: Text("No data found",
    //                         style: TextStyle(
    //                           fontSize: 17,
    //                           fontWeight: FontWeight.w700,
    //                           color: themeController.isDarkMode ? Colors.white : MateColors.blackTextColor,
    //                         ),
    //                       ),
    //                     );
    //                   }
    //                 } else if (snapshot.hasError) {
    //                   return Center(
    //                     child: Text("Something went wrong",
    //                       style: TextStyle(
    //                         fontSize: 17,
    //                         fontWeight: FontWeight.w700,
    //                         color: themeController.isDarkMode ? Colors.white : MateColors.blackTextColor,
    //                       ),
    //                     ),
    //                   );
    //                 } else {
    //                   return timelineLoader();
    //                 }
    //               },
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
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
