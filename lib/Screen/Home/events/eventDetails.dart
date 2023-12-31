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
//import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Providers/AuthUserProvider.dart';
import '../../../Providers/FeedProvider.dart';
import '../../../Utility/Utility.dart';
import '../../../Widget/Loaders/Shimmer.dart';
import '../../../Widget/mediaViewer.dart';
import '../../../Widget/video_thumbnail.dart';
import '../../../asset/Colors/MateColors.dart';
import '../../../constant.dart';
import '../../../controller/theme_controller.dart';
import 'package:mate_app/Model/eventListingModel.dart' as listing;

import '../../../groupChat/services/dynamicLinkService.dart';
import '../../Profile/ProfileScreen.dart';
import '../../Profile/UserProfileScreen.dart';
import 'package:googleapis/calendar/v3.dart' as gCal;
import 'package:firebase_auth/firebase_auth.dart' as auth;

import '../../Report/reportPage.dart';
import '../../chat1/screens/chat.dart';
import 'editEvent.dart';
import 'eventCommnetReply.dart';
import 'memberList.dart';

class EventDetails extends StatefulWidget {
  listing.Result list;
  bool isBookmark;
  int index;
  Function(int index) changeBookmark;
  String reaction;
  bool showDetails;
  Function(int index,String value) changeReaction;
  Function(int index,bool increment)? changeCommentCount;
  Function(int index,bool value)? changeFollowUnfollow;
  EventDetails({this.showDetails=true,required this.list,required this.isBookmark,required this.index,required this.changeBookmark,required this.reaction,required this.changeReaction,this.changeCommentCount,this.changeFollowUnfollow});
  static final String routeName = '/eventDetails';

  @override
  _EventDetailsState createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  ThemeController themeController = Get.find<ThemeController>();
  TextEditingController messageEditingController = TextEditingController();
  EventService _eventService = EventService();
  String token = "";
  late Future<EventCommentListingModel?> _future;
  int page = 1;
  bool doingPagination = false;
  bool enableFutureBuilder = false;
  List<Result> list = [];
  late ScrollController _scrollController;
  late FeedProvider feedProvider;
  late ClientId _credentials;
  auth.User _currentUser = auth.FirebaseAuth.instance.currentUser!;

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
    fetchData();
  }

  fetchData()async{
    page = 1;
    setState(() {
      doingPagination = false;
    });
    _future =  _eventService.getComment(page: page,token: token,id: widget.list.id!);
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
            _future = _eventService.getComment(page: page,token: token,id: widget.list.id!);
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
    widget.changeCommentCount!(widget.index,increment);
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
              !widget.showDetails?
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height*0.07,
                  left: 16,
                  right: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Get.back();
                      },
                      child: Icon(Icons.arrow_back_ios,
                        size: 20,
                        color: themeController.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    Text(
                      "comments",
                      style: TextStyle(
                        color: themeController.isDarkMode ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                        fontSize: 18.0,
                      ),
                    ),
                    SizedBox(),
                  ],
                ),
              ):SizedBox(),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(top: widget.showDetails?60:10),
                  children: [
                    if(widget.showDetails)
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
                                if(widget.list.user!.uuid!=null){
                                  if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == widget.list.user!.uuid) {
                                    Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                                  }else{
                                    Navigator.of(context).pushNamed(UserProfileScreen.routeName,
                                        arguments: {
                                          "id": widget.list.user!.uuid,
                                          "name": widget.list.user!.displayName,
                                          "photoUrl": widget.list.user!.profilePhoto,
                                          "firebaseUid": widget.list.user!.firebaseUid,
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
                                    backgroundImage: NetworkImage(widget.list.user!.profilePhoto!),
                                  ),
                                ],
                              ),
                              title: Text(
                                widget.list.user!.displayName!,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  color: themeController.isDarkMode?Colors.white:Colors.black,
                                ),
                              ),
                              subtitle: Text(
                                DateFormat('dd MMMM yyyy').format(DateTime.parse(widget.list.createdAt.toString()).toLocal()).toString(),
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
                                      event.summary = widget.list.title; //Setting summary of object
                                      event.description = widget.list.description; //Setting summary of object

                                      gCal.EventDateTime start = new gCal.EventDateTime(); //Setting start time
                                      start.dateTime = DateTime.parse(widget.list.createdAt.toString()).toLocal();
                                      start.timeZone = "GMT+05:00";
                                      event.start = start;

                                      gCal.EventDateTime end = new gCal.EventDateTime(); //setting end time
                                      end.timeZone = "GMT+05:00";
                                      end.dateTime = DateTime.parse(widget.list.createdAt.toString()).toLocal();
                                      event.end = end;

                                      insertEvent(event);
                                    }else if (index1 == 1){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => Chat(peerUuid: widget.list.user!.uuid, currentUserId: _currentUser.uid, peerId: widget.list.user!.firebaseUid!, peerAvatar: widget.list.user!.profilePhoto!, peerName: widget.list.user!.displayName!)));
                                    }else if(index1 == 2){
                                      _showFollowAlertDialog(eventId: widget.list.id!,isFollowed: widget.list.isFollowed);
                                    }else if(index1 == 3){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => ReportPage(moduleId: widget.list.id!, moduleType: "Event",),));
                                    }else if(index1 == 4){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => EditEvent(data: widget.list),));
                                    }else if(index1 == 6){
                                      String? response  = await DynamicLinkService.buildDynamicLinkEvent(
                                        id: widget.list.id.toString(),
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
                                        widget.list.isFollowed!?"Unfollow Event":"Follow Event",
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
                                    ((Provider.of<AuthUserProvider>(context, listen: false).authUser.id == widget.list.user!.uuid))?
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
                                content: widget.list.title!,
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
                                content:  widget.list.description!,
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
                            widget.list.hyperLinkText!=null && widget.list.hyperLink!=null ?
                            InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async{
                                if (await canLaunch(widget.list.hyperLink!))
                                  await launch(widget.list.hyperLink!);
                                else
                                  Fluttertoast.showToast(msg: " Could not launch given URL '${widget.list.hyperLink}'", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
                                throw "Could not launch ${widget.list.hyperLink}";
                              },
                              child: Padding(
                                padding: EdgeInsets.only(left: 16,top: 10,right: 10),
                                child: Text(
                                  widget.list.hyperLinkText!,
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
                                    widget.list.location!,
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
                                    DateFormat('dd MMMM yyyy').format(DateTime.parse(widget.list.date.toString()).toLocal()).toString(),
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
                                    DateFormat('hh:mm a').format(DateTime.parse(widget.list.time.toString())).toString(),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: themeController.isDarkMode ? Colors.white : MateColors.blackTextColor,
                                    ),
                                  ),
                                  if(widget.list.endTime!=null)
                                    Text(
                                      " - "+DateFormat('hh:mm a').format(DateTime.parse(widget.list.endTime.toString())).toString(),
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
                              margin: EdgeInsets.only(left: 16,top: widget.list.goingList!.length>0?20:10,bottom: widget.list.goingList!.length>0?5:0),
                              width: MediaQuery.of(context).size.width,
                              child: Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: List.generate(widget.list.goingList!.length, (index) =>
                                    InkWell(
                                      onTap: (){
                                        Get.to(MemberList(list: widget.list.goingList!,));
                                      },
                                      child: CircleAvatar(
                                        radius: 16,
                                        backgroundColor: MateColors.activeIcons,
                                        backgroundImage: NetworkImage(widget.list.goingList![index].profilePhoto!),
                                      ),
                                    ),
                                ),
                              ),
                            ),
                            if(widget.list.photoUrl!=null || widget.list.videoUrl!=null)
                              Container(
                                height: 150,
                                margin: EdgeInsets.only(bottom: 0.0, left: 16, right: 16, top: 10),
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    physics: BouncingScrollPhysics(),
                                    itemCount: widget.list.photoUrl!=null && widget.list.videoUrl!=null? 2 : widget.list.photoUrl!=null?1:widget.list.videoUrl!=null?1:0,
                                    itemBuilder: (context,indexSwipe){
                                      if(indexSwipe==0){
                                        return
                                          widget.list.photoUrl!=null?
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 0.0, left: 0, right: 0, top: 10),
                                            child: Container(
                                              height: 150,
                                              width: MediaQuery.of(context).size.width/1.1,
                                              child: InkWell(
                                                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>MediaViewer(url: widget.list.photoUrl!,))),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(12.0),
                                                  clipBehavior: Clip.hardEdge,
                                                  child: Image.network(
                                                    widget.list.photoUrl!,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ):widget.list.videoUrl!=null?
                                          VideoThumbnail(videoUrl: widget.list.videoUrl!,isLeftPadding: false,):Container();
                                      }else{
                                        return  widget.list.videoUrl!=null?
                                        VideoThumbnail(videoUrl: widget.list.videoUrl!):Container();
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
                                          if(widget.reaction=="Going"){
                                            widget.reaction = "none";
                                            widget.changeReaction(widget.index,"none");
                                            setState(() {});
                                            _eventService.reaction(id: widget.list.id!,reaction: "none",token: token);
                                          }else{
                                            widget.reaction = "Going";
                                            widget.changeReaction(widget.index,"Going");
                                            setState(() {});
                                            _eventService.reaction(id: widget.list.id!,reaction: "Going",token: token);
                                          }
                                        },
                                        child: Container(
                                          height: 32,
                                          width: 72,
                                          decoration: BoxDecoration(
                                            color: widget.reaction=="Going"?MateColors.activeIcons:Colors.transparent,
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
                                                color: themeController.isDarkMode? widget.reaction=="Going"? MateColors.blackTextColor:Colors.white:
                                                widget.reaction=="Going"?Colors.white:MateColors.blackTextColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      InkWell(
                                        onTap: (){
                                          if(widget.reaction=="Interested"){
                                            widget.reaction = "none";
                                            widget.changeReaction(widget.index,"none");
                                            setState(() {});
                                            _eventService.reaction(id: widget.list.id!,reaction: "none",token: token);
                                          }else{
                                            widget.reaction = "Interested";
                                            widget.changeReaction(widget.index,"Interested");
                                            setState(() {});
                                            _eventService.reaction(id: widget.list.id!,reaction: "Interested",token: token);
                                          }
                                        },
                                        child: Container(
                                          height: 32,
                                          width: 99,
                                          decoration: BoxDecoration(
                                            color: widget.reaction=="Interested"?MateColors.activeIcons:Colors.transparent,
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
                                                color: themeController.isDarkMode? widget.reaction=="Interested"? MateColors.blackTextColor:Colors.white:
                                                widget.reaction=="Interested"?Colors.white:MateColors.blackTextColor,
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
                                  //         _eventService.bookMark(id: widget.list.id,token: token);
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
                                            widget.isBookmark = !widget.isBookmark;
                                          });
                                          widget.changeBookmark(widget.index);
                                          _eventService.bookMark(id: widget.list.id!,token: token);
                                        },
                                        child: Container(
                                          height: 39,
                                          width: 40,
                                          decoration: BoxDecoration(
                                            color: themeController.isDarkMode?MateColors.smallContainerDark:MateColors.smallContainerLight,
                                            shape: BoxShape.circle,
                                          ),
                                          child: widget.isBookmark?
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
                                bool response = await _eventService.comment(id: widget.list.id!,content: messageEditingController.text,token: token);
                                if(response){
                                  messageEditingController.clear();
                                  fetchData();
                                  widget.changeCommentCount!(widget.index,true);
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
                                  list.add(snapshot.data!.data!.result![i]);
                                }
                              }else{
                                list.clear();
                                for(int i=0;i<snapshot.data!.data!.result!.length;i++){
                                  list.add(snapshot.data!.data!.result![i]);
                                }
                              }
                              print(list.length);
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
                                  itemCount: list.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: GestureDetector(
                                            onTap: (){
                                              if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == list[index].user!.uuid) {
                                                Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                                              } else {
                                                Navigator.of(context).pushNamed(UserProfileScreen.routeName, arguments: {
                                                  "id": list[index].user!.uuid,
                                                  "name": list[index].user!.displayName,
                                                  "photoUrl": list[index].user!.profilePhoto,
                                                  "firebaseUid": list[index].user!.firebaseUid
                                                });
                                              }
                                            },
                                            child: ListTile(
                                              horizontalTitleGap: 1,
                                              dense: true,
                                              leading: list[index].user!.profilePhoto != null?
                                              ClipOval(
                                                child: Image.network(
                                                  list[index].user!.profilePhoto!,
                                                  height: 28,
                                                  width: 28,
                                                  fit: BoxFit.cover,
                                                ),
                                              ):CircleAvatar(
                                                radius: 14,
                                                child: Text(list[index].user!.displayName![0]),
                                              ),
                                              title: Padding(
                                                padding: const EdgeInsets.only(top: 10),
                                                child: buildEmojiAndText(
                                                  content:  list[index].content!,
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
                                                  DateFormat.yMMMEd().format(DateFormat("yyyy-MM-dd").parse(list[index].createdAt.toString(), true)),
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
                                                        result: list[index],
                                                        eventId: widget.list.id!,
                                                        commentId: list[index].id!,
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
                                              Text(list[index].replies!.isEmpty?"":list[index].repliesCount!>1?
                                              "   •   ${list[index].repliesCount} Replies":
                                              "   •   ${list[index].repliesCount} Reply",
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
                                                visible: Provider.of<AuthUserProvider>(context, listen: false).authUser.id == list[index].user!.uuid,
                                                child: list[index].isDeleting!?
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
                                                      list[index].isDeleting = true;
                                                    });
                                                    await _eventService.deleteComment(id: list[index].id!,token: token);
                                                    setState(() {
                                                      list[index].isDeleting = false;
                                                    });
                                                    list.removeAt(index);
                                                    setState(() {});
                                                    widget.changeCommentCount!(widget.index,false);
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
                                          visible: list[index].repliesCount!>1,
                                          child: Padding(
                                            padding: EdgeInsets.fromLTRB(58, 10, 5, 0),
                                            child: InkWell(
                                              onTap: ()async{
                                                await Navigator.of(context).push(MaterialPageRoute(
                                                    builder: (context) => EventCommentReply(
                                                      result: list[index],
                                                      eventId: widget.list.id!,
                                                      commentId: list[index].id!,
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
                                        list[index].replies!.isNotEmpty?
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(40, 0, 0, 5),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: InkWell(
                                                  onTap: () {
                                                    if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == list[index].replies!.last.user!.uuid) {
                                                      Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                                                    } else {
                                                      Navigator.of(context).pushNamed(UserProfileScreen.routeName, arguments: {
                                                        "id": list[index].replies!.last.user!.uuid,
                                                        "name": list[index].replies!.last.user!.displayName,
                                                        "photoUrl": list[index].replies!.last.user!.profilePhoto,
                                                        "firebaseUid": list[index].replies!.last.user!.firebaseUid
                                                      });
                                                    }

                                                  },
                                                  child: ListTile(
                                                    horizontalTitleGap: 1,
                                                    dense: true,
                                                    leading:
                                                    list[index].replies!.last.user!.profilePhoto != null ?
                                                    ClipOval(
                                                      child: Image.network(
                                                        list[index].replies!.last.user!.profilePhoto!,
                                                        height: 28,
                                                        width: 28,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ):CircleAvatar(
                                                      radius: 14,
                                                      child: Text(list[index].replies!.last.user!.displayName![0],),
                                                    ),
                                                    title: Padding(
                                                      padding: const EdgeInsets.only(top: 10),
                                                      child: buildEmojiAndText(
                                                        content:  list[index].replies!.last.content!,
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
                                                        DateFormat.yMMMEd().format(DateFormat("yyyy-MM-dd").parse(list[index].replies!.last.createdAt.toString(), true)),
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
                            height: widget.showDetails?scH/3:scH,
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
                    widget.list.isFollowed = false;
                    widget.changeFollowUnfollow!(widget.index,false);
                    setState(() {});
                    Navigator.pop(context);
                  }
                }else{
                  Map<String, dynamic> body = {"post_id": eventId, "post_type": "Event"};
                  bool followDone = await feedProvider.followAFeed(body, eventId);
                  if (followDone) {
                    widget.list.isFollowed  = true;
                    widget.changeFollowUnfollow!(widget.index,true);
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
