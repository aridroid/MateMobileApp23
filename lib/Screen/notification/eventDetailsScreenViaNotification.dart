import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:intl/intl.dart';
import 'package:mate_app/Model/eventCommentListingModel.dart';
import 'package:mate_app/Services/eventService.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Providers/AuthUserProvider.dart';
import '../../../Providers/FeedProvider.dart';
import '../../../Widget/Loaders/Shimmer.dart';
import '../../../Widget/mediaViewer.dart';
import '../../../Widget/video_thumbnail.dart';
import '../../../asset/Colors/MateColors.dart';
import '../../../constant.dart';
import '../../../controller/theme_controller.dart';
import 'package:mate_app/Model/eventListingModel.dart' as listing;

import '../../../groupChat/services/dynamicLinkService.dart';
import 'package:googleapis/calendar/v3.dart' as gCal;
import 'package:firebase_auth/firebase_auth.dart' as auth;

import '../../Services/notificationService.dart';
import '../Home/events/editEvent.dart';
import '../Home/events/eventCommnetReply.dart';
import '../Home/events/memberList.dart';
import '../Profile/ProfileScreen.dart';
import '../Profile/UserProfileScreen.dart';
import '../Report/reportPage.dart';
import '../chat1/screens/chat.dart';


class EventDetailsScreenViaNotification extends StatefulWidget {
  int eventId;
  EventDetailsScreenViaNotification({required this.eventId});

  @override
  _EventDetailsScreenViaNotifiactionState createState() => _EventDetailsScreenViaNotifiactionState();
}

class _EventDetailsScreenViaNotifiactionState extends State<EventDetailsScreenViaNotification> {
  ThemeController themeController = Get.find<ThemeController>();
  TextEditingController messageEditingController = TextEditingController();
  EventService _eventService = EventService();
  String token = "";
  late Future<EventCommentListingModel?> _future;
  int page = 1;
  bool doingPagination = false;
  bool enableFutureBuilder = false;
  List<Result> listComment = [];
  late ScrollController _scrollController;
  late FeedProvider feedProvider;
  late ClientId _credentials;
  auth.User _currentUser = auth.FirebaseAuth.instance.currentUser!;
  NotificationService _notificationService = NotificationService();
  bool isLoading = true;
  listing.Result? list;
  late bool isBookmark;
  late int index;
  late String reaction;
  late bool showDetails;

  @override
  void initState() {
    feedProvider = Provider.of<FeedProvider>(context, listen: false);
    getStoredValue();
    _scrollController = new ScrollController()..addListener(_scrollListener);
    if (Platform.isAndroid) {
      _credentials = new ClientId("237545926078-9biln72s9c5h9vot53l84me39unhhnbf.apps.googleusercontent.com", "");
    } else if (Platform.isIOS) {
      _credentials = new ClientId("237545926078-99q5c35ugs0b49spmhf1ru0ghie7opnp.apps.googleusercontent.com", "");
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
  }

  getStoredValue()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("tokenApp")!;
    list = await _notificationService.getEventDetails(token: token,eventId: widget.eventId);
    if(list!=null && list!.isReacted!=null){
      reaction = list!.isReacted!.status == "Going"? "Going": list!.isReacted!.status =="Interested"?"Interested":"none";
    }else{
      reaction = "none";
    }
    if(list!=null && list!.isBookmarked==null){
      list!.isBookmarked = false;
    }
    if(list!=null){
      fetchData();
    }
    setState(() {
      isLoading = false;
    });
  }

  fetchData()async{
    page = 1;
    setState(() {
      doingPagination = false;
    });
    _future =  _eventService.getComment(page: page,token: token,id: list!.id!);
    _future.then((value){
      enableFutureBuilder = true;
      setState(() {});
    });
  }

  void _scrollListener() {
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels != 0) {
        Future.delayed(Duration.zero,(){
          page += 1;
          setState(() {
            doingPagination = true;
          });
          print('scrolled to bottom page is now $page');
          _future = _eventService.getComment(page: page,token: token,id: list!.id!);
          _future.then((value){
            setState(() {
              enableFutureBuilder = true;
            });
          });
        });
      }
    }
  }

  void changeCommentCount(bool increment){
    // widget.changeCommentCount(widget.index,increment);
  }

  @override
  Widget build(BuildContext context) {
    final scH = MediaQuery.of(context).size.height;
    final scW = MediaQuery.of(context).size.width;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: null,
      onPanUpdate: (details) {
        if (details.delta.dy > 0){
          FocusScope.of(context).requestFocus(FocusNode());
          print("Dragging in +Y direction");
        }
      },
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
              Expanded(
                child: isLoading?
                Padding(
                  padding: const EdgeInsets.only(top: 80),
                  child: timelineLoader(),
                ):
                list!=null?
                ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(top: 60),
                  children: [
                    Container(
                        margin: EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: themeController.isDarkMode ? MateColors.containerDark : MateColors.containerLight,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              onTap: (){
                                if(list!.user!.uuid!=null){
                                  if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == list!.user!.uuid) {
                                    Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                                  }else{
                                    Navigator.of(context).pushNamed(UserProfileScreen.routeName,
                                        arguments: {
                                          "id": list!.user!.uuid,
                                          "name": list!.user!.displayName,
                                          "photoUrl": list!.user!.profilePhoto,
                                          "firebaseUid": list!.user!.firebaseUid,
                                        });
                                  }
                                }
                              },
                              leading: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    onTap: (){
                                      Get.back();
                                    },
                                    child: Icon(Icons.arrow_back,color: MateColors.activeIcons,),
                                  ),
                                  SizedBox(width: 10,),
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundImage: NetworkImage(list!.user!.profilePhoto!),
                                  ),
                                ],
                              ),
                              title: Text(
                                list!.user!.displayName!,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  color: themeController.isDarkMode?Colors.white:Colors.black,
                                ),
                              ),
                              subtitle: Text(
                                DateFormat('dd MMMM yyyy').format(DateTime.parse(list!.createdAt.toString()).toLocal()).toString(),
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
                                  onSelected: (index1)async{
                                    if (index1 == 0) {
                                      gCal.Event event = gCal.Event(); // Create object of event
                                      event.summary = list!.title; //Setting summary of object
                                      event.description = list!.description; //Setting summary of object

                                      gCal.EventDateTime start = new gCal.EventDateTime(); //Setting start time
                                      start.dateTime = DateTime.parse(list!.createdAt.toString()).toLocal();
                                      start.timeZone = "GMT+05:00";
                                      event.start = start;

                                      gCal.EventDateTime end = new gCal.EventDateTime(); //setting end time
                                      end.timeZone = "GMT+05:00";
                                      end.dateTime = DateTime.parse(list!.createdAt.toString()).toLocal();
                                      event.end = end;

                                      insertEvent(event);
                                    }else if (index1 == 1){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => Chat(peerUuid: list!.user!.uuid, currentUserId: _currentUser.uid, peerId: list!.user!.firebaseUid!, peerAvatar: list!.user!.profilePhoto!, peerName: list!.user!.displayName!)));
                                    }else if(index1 == 2){
                                      _showFollowAlertDialog(eventId: list!.id!,isFollowed: list!.isFollowed);
                                    }else if(index1 == 3){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => ReportPage(moduleId: list!.id!, moduleType: "Event",),));
                                    }else if(index1 == 4){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => EditEvent(data: list!),));
                                    }else if(index1 == 6){
                                      String response  = await DynamicLinkService.buildDynamicLinkEvent(
                                        id: list!.id.toString(),
                                      );
                                      if(response!=null){
                                        Share.share(response);
                                      }
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
                                        list!.isFollowed!?"Unfollow Event":"Follow Event",
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
                                    ((Provider.of<AuthUserProvider>(context, listen: false).authUser.id == list!.user!.uuid))?
                                    PopupMenuItem(
                                      value: 4,
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
                                    ):PopupMenuItem(
                                      value: 4,
                                      enabled: false,
                                      height: 0,
                                      child: SizedBox(
                                        height: 0,
                                        width: 0,
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 6,
                                      height: 40,
                                      child: Text(
                                        "Share",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          color: themeController.isDarkMode?Colors.white:Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Poppins',
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ]
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 16,top: 0),
                              child: buildEmojiAndText(
                                content: list!.title!,
                                textStyle: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                  color: themeController.isDarkMode?Colors.white:Colors.black,
                                ),
                                normalFontSize: 16,
                                emojiFontSize: 26,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 16,top: 10,right: 10),
                              child: buildEmojiAndText(
                                content:  list!.description!,
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
                            list!.hyperLinkText!=null && list!.hyperLink!=null ?
                            InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async{
                                if (await canLaunch(list!.hyperLink!))
                                  await launch(list!.hyperLink!);
                                else
                                  Fluttertoast.showToast(msg: " Could not launch given URL '${list!.hyperLink}'", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
                                throw "Could not launch ${list!.hyperLink}";
                              },
                              child: Padding(
                                padding: EdgeInsets.only(left: 16,top: 10,right: 10),
                                child: Text(
                                  list!.hyperLinkText!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                    color: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
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
                                    list!.location!,
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
                              padding: EdgeInsets.only(left: 16,top: 10,right: 10),
                              child: Row(
                                children: [
                                  Image.asset("lib/asset/icons/calendarEvent.png",
                                    height: 14,
                                  ),
                                  SizedBox(width: 8,),
                                  Text(
                                    DateFormat('dd MMMM yyyy').format(DateTime.parse(list!.date.toString()).toLocal()).toString(),
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
                              padding: EdgeInsets.only(left: 16,top: 10,right: 10),
                              child: Row(
                                children: [
                                  Image.asset("lib/asset/icons/clockEvent.png",
                                    height: 14,
                                  ),
                                  SizedBox(width: 8,),
                                  Text(
                                    DateFormat('hh:mm a').format(DateTime.parse(list!.time.toString())).toString(),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: themeController.isDarkMode ? Colors.white : MateColors.blackTextColor,
                                    ),
                                  ),
                                  if(list!.endTime!=null)
                                    Text(
                                      " - "+DateFormat('hh:mm a').format(DateTime.parse(list!.endTime.toString())).toString(),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: themeController.isDarkMode ? Colors.white : MateColors.blackTextColor,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 16,top: list!.goingList!.length>0?20:10,bottom: list!.goingList!.length>0?5:0),
                              width: MediaQuery.of(context).size.width,
                              child: Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: List.generate(list!.goingList!.length, (index) =>
                                    InkWell(
                                      onTap: (){
                                        Get.to(MemberList(list: list!.goingList!,));
                                      },
                                      child: CircleAvatar(
                                        radius: 16,
                                        backgroundColor: MateColors.activeIcons,
                                        backgroundImage: NetworkImage(list!.goingList![index].profilePhoto!),
                                      ),
                                    ),
                                ),
                              ),
                            ),
                            if(list!.photoUrl!=null || list!.videoUrl!=null)
                              Container(
                                height: 150,
                                margin: EdgeInsets.only(bottom: 0.0, left: 16, right: 16, top: 10),
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    physics: BouncingScrollPhysics(),
                                    itemCount: list!.photoUrl!=null && list!.videoUrl!=null? 2 : list!.photoUrl!=null?1:list!.videoUrl!=null?1:0,
                                    itemBuilder: (context,indexSwipe){
                                      if(indexSwipe==0){
                                        return
                                          list!.photoUrl!=null?
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 0.0, left: 0, right: 0, top: 10),
                                            child: Container(
                                              height: 150,
                                              width: MediaQuery.of(context).size.width/1.1,
                                              child: InkWell(
                                                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>MediaViewer(url: list!.photoUrl!,))),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(12.0),
                                                  clipBehavior: Clip.hardEdge,
                                                  child: Image.network(
                                                    list!.photoUrl!,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ):list!.videoUrl!=null?
                                          VideoThumbnail(videoUrl: list!.videoUrl!,isLeftPadding: false,):Container();
                                      }else{
                                        return  list!.videoUrl!=null?
                                        VideoThumbnail(videoUrl: list!.videoUrl!):Container();
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
                                          if(reaction=="Going"){
                                            reaction = "none";
                                            setState(() {});
                                            _eventService.reaction(id: list!.id!,reaction: "none",token: token);
                                          }else{
                                            reaction = "Going";
                                            setState(() {});
                                            _eventService.reaction(id: list!.id!,reaction: "Going",token: token);
                                          }
                                        },
                                        child: Container(
                                          height: 32,
                                          width: 72,
                                          decoration: BoxDecoration(
                                            color: reaction=="Going"?MateColors.activeIcons:Colors.transparent,
                                            borderRadius: BorderRadius.circular(16),
                                            border: Border.all(color: themeController.isDarkMode ? Colors.white :
                                            Colors.black, width: 1),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Going",
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 0.1,
                                                color: themeController.isDarkMode? reaction=="Going"? MateColors.blackTextColor:Colors.white:
                                               reaction=="Going"?Colors.white:MateColors.blackTextColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      InkWell(
                                        onTap: (){
                                          if(reaction=="Interested"){
                                            reaction = "none";
                                            setState(() {});
                                            _eventService.reaction(id: list!.id!,reaction: "none",token: token);
                                          }else{
                                            reaction = "Interested";
                                            setState(() {});
                                            _eventService.reaction(id: list!.id!,reaction: "Interested",token: token);
                                          }
                                        },
                                        child: Container(
                                          height: 32,
                                          width: 99,
                                          decoration: BoxDecoration(
                                            color: reaction=="Interested"?MateColors.activeIcons:Colors.transparent,
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
                                                color: themeController.isDarkMode? reaction=="Interested"? MateColors.blackTextColor:Colors.white:
                                                reaction=="Interested"?Colors.white:MateColors.blackTextColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Row(
                                  //   children: [
                                  //     InkWell(
                                  //       onTap: (){
                                  //         setState(() {
                                  //           widget.isBookmark = !widget.isBookmark;
                                  //         });
                                  //         widget.changeBookmark(widget.index);
                                  //         _eventService.bookMark(id: list.id,token: token);
                                  //       },
                                  //       child: widget.isBookmark?
                                  //       Image.asset("lib/asset/icons/bookmarkColor.png",height: 20) :
                                  //       Image.asset("lib/asset/homePageIcons/drawerBookmark@3x.png",height: 20,color: themeController.isDarkMode?MateColors.iconDark:MateColors.iconLight,),
                                  //     ),
                                  //   ],
                                  // ),
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: (){
                                          setState(() {
                                            list!.isBookmarked = !list!.isBookmarked;
                                          });
                                          _eventService.bookMark(id: list!.id!,token: token);
                                        },
                                        child: Container(
                                          height: 39,
                                          width: 40,
                                          decoration: BoxDecoration(
                                            color: themeController.isDarkMode?MateColors.smallContainerDark:MateColors.smallContainerLight,
                                            shape: BoxShape.circle,
                                          ),
                                          child: list!.isBookmarked?
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
                      ),
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 10, 20, 5),
                      child: TextField(
                        controller: messageEditingController,
                        cursorColor: themeController.isDarkMode?MateColors.helpingTextDark:MateColors.helpingTextLight,
                        style:  TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.1,
                          color: themeController.isDarkMode?Colors.white:Colors.black,
                        ),
                        textInputAction: TextInputAction.done,
                        minLines: 1,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintStyle: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            color: themeController.isDarkMode?MateColors.helpingTextDark:MateColors.helpingTextLight,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.send,
                              size: 20,
                              color: themeController.isDarkMode?MateColors.helpingTextDark:MateColors.helpingTextLight,
                            ),
                            onPressed: ()async{
                              if(messageEditingController.text.length>0){
                                bool response = await _eventService.comment(id: list!.id!,content: messageEditingController.text,token: token);
                                if(response){
                                  messageEditingController.clear();
                                  fetchData();
                                  Fluttertoast.showToast(msg: "Comment added successfully", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
                                }else{
                                  Fluttertoast.showToast(msg: "Something went wrong", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
                                }
                              }
                            },
                          ),
                          hintText: "Add a comment...",
                          fillColor: themeController.isDarkMode ? MateColors.containerDark : MateColors.containerLight,
                          filled: true,
                          focusedBorder: commonBorderCircular,
                          enabledBorder: commonBorderCircular,
                          disabledBorder: commonBorderCircular,
                          errorBorder: commonBorderCircular,
                          focusedErrorBorder: commonBorderCircular,
                        ),
                      ),
                    ),
                    FutureBuilder<EventCommentListingModel?>(
                      future: _future,
                      builder: (context,snapshot){
                        if(snapshot.hasData){
                          if(snapshot.data!.success==true || doingPagination==true){
                            if(enableFutureBuilder){
                              if(doingPagination){
                                for(int i=0;i<snapshot.data!.data!.result!.length;i++){
                                  listComment.add(snapshot.data!.data!.result![i]);
                                }
                              }else{
                                listComment.clear();
                                for(int i=0;i<snapshot.data!.data!.result!.length;i++){
                                  listComment.add(snapshot.data!.data!.result![i]);
                                }
                              }
                              print(listComment.length);
                              Future.delayed(Duration.zero,(){
                                enableFutureBuilder = false;
                                setState(() {});
                              });
                            }
                            return ListView(
                              padding: EdgeInsets.only(top: 0),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              controller: _scrollController,
                              children: [
                                ListView.builder(
                                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  padding: EdgeInsets.fromLTRB(16, 10, 16, 16),
                                  itemCount: listComment.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: GestureDetector(
                                            onTap: (){
                                              if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == listComment[index].user!.uuid) {
                                                Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                                              } else {
                                                Navigator.of(context).pushNamed(UserProfileScreen.routeName, arguments: {
                                                  "id": listComment[index].user!.uuid,
                                                  "name": listComment[index].user!.displayName,
                                                  "photoUrl": listComment[index].user!.profilePhoto,
                                                  "firebaseUid": listComment[index].user!.firebaseUid
                                                });
                                              }
                                            },
                                            child: ListTile(
                                              horizontalTitleGap: 1,
                                              dense: true,
                                              leading: listComment[index].user!.profilePhoto != null?
                                              ClipOval(
                                                child: Image.network(
                                                  listComment[index].user!.profilePhoto!,
                                                  height: 28,
                                                  width: 28,
                                                  fit: BoxFit.cover,
                                                ),
                                              ):CircleAvatar(
                                                radius: 14,
                                                child: Text(listComment[index].user!.displayName![0]),
                                              ),
                                              title: Padding(
                                                padding: const EdgeInsets.only(top: 10),
                                                child: buildEmojiAndText(
                                                  content:  listComment[index].content!,
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
                                              subtitle: Padding(
                                                padding: const EdgeInsets.only(top: 5),
                                                child: Text(
                                                  DateFormat.yMMMEd().format(DateFormat("yyyy-MM-dd").parse(listComment[index].createdAt.toString(), true)),
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: themeController.isDarkMode?MateColors.helpingTextDark:Colors.black.withOpacity(0.72),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 58,top: 5),
                                          child: Row(
                                            children: [
                                              InkWell(
                                                onTap: ()async{
                                                  await Navigator.of(context).push(MaterialPageRoute(
                                                      builder: (context) => EventCommentReply(
                                                        result: listComment[index],
                                                        eventId: list!.id!,
                                                        commentId: listComment[index].id!,
                                                        changeCommentCount: changeCommentCount,
                                                      )));
                                                  fetchData();
                                                },
                                                child: Text("Reply",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w400,
                                                    letterSpacing: 0.1,
                                                    color: themeController.isDarkMode?Colors.white:Colors.black,
                                                  ),
                                                ),
                                              ),
                                              Text(listComment[index].replies!.isEmpty?"":listComment[index].repliesCount!>1?
                                              "   •   ${listComment[index].repliesCount} Replies":
                                              "   •   ${listComment[index].repliesCount} Reply",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w400,
                                                  letterSpacing: 0.1,
                                                  color: themeController.isDarkMode?Colors.white:Colors.black,
                                                ),
                                              ),
                                              Spacer(),
                                              Visibility(
                                                visible: Provider.of<AuthUserProvider>(context, listen: false).authUser.id == listComment[index].user!.uuid,
                                                child: listComment[index].isDeleting!?
                                                SizedBox(
                                                  height: 14,
                                                  width: 14,
                                                  child: CircularProgressIndicator(
                                                    color: themeController.isDarkMode?Colors.white:Colors.black,
                                                    strokeWidth: 1.2,
                                                  ),
                                                ):
                                                InkWell(
                                                  onTap: ()async{
                                                    setState(() {
                                                      listComment[index].isDeleting = true;
                                                    });
                                                    await _eventService.deleteComment(id: listComment[index].id!,token: token);
                                                    setState(() {
                                                      listComment[index].isDeleting = false;
                                                    });
                                                    listComment.removeAt(index);
                                                    setState(() {});
                                                  },
                                                  child: Icon(
                                                    Icons.delete_outline,
                                                    size: 18,
                                                    color: themeController.isDarkMode?Colors.white:Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: listComment[index].repliesCount!>1,
                                          child: Padding(
                                            padding: EdgeInsets.fromLTRB(58, 10, 5, 0),
                                            child: InkWell(
                                              onTap: ()async{
                                                await Navigator.of(context).push(MaterialPageRoute(
                                                    builder: (context) => EventCommentReply(
                                                      result: listComment[index],
                                                      eventId: list!.id!,
                                                      commentId: listComment[index].id!,
                                                      changeCommentCount: changeCommentCount,
                                                    )));
                                                fetchData();
                                              },
                                              child: Text(
                                                "Show previous replies...",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontFamily: 'Poppins',
                                                  letterSpacing: 0.1,
                                                  color: themeController.isDarkMode?Colors.white:Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        listComment[index].replies!.isNotEmpty?
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(40, 0, 0, 5),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: InkWell(
                                                  onTap: () {
                                                    if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == listComment[index].replies!.last.user!.uuid) {
                                                      Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                                                    } else {
                                                      Navigator.of(context).pushNamed(UserProfileScreen.routeName, arguments: {
                                                        "id": listComment[index].replies!.last.user!.uuid,
                                                        "name": listComment[index].replies!.last.user!.displayName,
                                                        "photoUrl": listComment[index].replies!.last.user!.profilePhoto,
                                                        "firebaseUid": listComment[index].replies!.last.user!.firebaseUid
                                                      });
                                                    }

                                                  },
                                                  child: ListTile(
                                                    horizontalTitleGap: 1,
                                                    dense: true,
                                                    leading:
                                                    listComment[index].replies!.last.user!.profilePhoto != null ?
                                                    ClipOval(
                                                      child: Image.network(
                                                        listComment[index].replies!.last.user!.profilePhoto!,
                                                        height: 28,
                                                        width: 28,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ):CircleAvatar(
                                                      radius: 14,
                                                      child: Text(listComment[index].replies!.last.user!.displayName![0],),
                                                    ),
                                                    title: Padding(
                                                      padding: const EdgeInsets.only(top: 10),
                                                      child: buildEmojiAndText(
                                                        content:  listComment[index].replies!.last.content!,
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
                                                    subtitle: Padding(
                                                      padding: const EdgeInsets.only(top: 5),
                                                      child: Text(
                                                        DateFormat.yMMMEd().format(DateFormat("yyyy-MM-dd").parse(listComment[index].replies!.last.createdAt.toString(), true)),
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: themeController.isDarkMode?MateColors.helpingTextDark:Colors.black.withOpacity(0.72),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ):SizedBox(),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            );
                          }else{
                            return Container();
                          }
                        }else if(snapshot.hasError){
                          return Container();
                        }else{
                          return Container(
                            height: scH/3,
                            width: scW,
                            child: Shimmer.fromColors(
                              baseColor: themeController.isDarkMode?Colors.white12:Colors.black12,
                              highlightColor: themeController.isDarkMode?Colors.white54:Colors.black54,
                              enabled: true,
                              child: GroupLoader(),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ):
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height/1.5,
                  child: Text("Something went wrong! or post deleted",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: themeController.isDarkMode?Colors.white:Colors.black,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
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
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _showFollowAlertDialog({required int eventId,required isFollowed}) async {
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
                if(isFollowed){
                  Map<String, dynamic> body = {"post_id": eventId, "post_type": "Event"};
                  bool unFollowDone = await feedProvider.unFollowAFeed(body, eventId);
                  if (unFollowDone) {
                    list!.isFollowed = false;
                    setState(() {});
                    Navigator.pop(context);
                  }
                }else{
                  Map<String, dynamic> body = {"post_id": eventId, "post_type": "Event"};
                  bool followDone = await feedProvider.followAFeed(body, eventId);
                  if (followDone) {
                    list!.isFollowed  = true;
                    setState(() {});
                    Navigator.pop(context);
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

}
