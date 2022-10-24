import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Model/eventListingModel.dart';
import '../../../Services/eventService.dart';
import '../../../Utility/Utility.dart';
import '../../../Widget/Home/HomeRow.dart';
import '../../../Widget/video_thumbnail.dart';
import '../../../asset/Colors/MateColors.dart';
import '../../../controller/theme_controller.dart';
import '../../chat1/screens/chat.dart';
import 'eventDetails.dart';
import 'package:googleapis/calendar/v3.dart' as gCal;
import 'package:firebase_auth/firebase_auth.dart' as auth;

import 'memberList.dart';

class EventSearch extends StatefulWidget {
  static final String routes = '/eventSearch';
  final bool isLocal;
  const EventSearch({Key key, this.isLocal}) : super(key: key);

  @override
  _EventSearchState createState() => _EventSearchState();
}

class _EventSearchState extends State<EventSearch> {
  ThemeController themeController = Get.find<ThemeController>();
  String token = "";
  EventService _eventService = EventService();
  Future<EventListingModel> future;
  int page = 1;
  bool enterFutureBuilder = false;
  List<Result> list = [];
  List<bool> isBookMark = [];
  List<String> reaction = [];
  TextEditingController _textEditingController = TextEditingController();
  ScrollController _scrollController;
  bool doingPagination = false;

  ClientId _credentials;
  auth.User _currentUser = auth.FirebaseAuth.instance.currentUser;

  getStoredValue()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token");
    log(token);
  }

  Timer _throttle;
  _onSearchChanged() {
    if (_throttle?.isActive??false) _throttle?.cancel();
    _throttle = Timer(const Duration(milliseconds: 200), () {
      if(_textEditingController.text.length>2){
        fetchData();
      }
    });
  }

  fetchData()async{
    page = 1;
    if(widget.isLocal){
      print("///////////Local search//////////////");
      future = _eventService.getSearchLocal(text: _textEditingController.text,page: page,token: token);
      future.then((value) {
        setState(() {
          doingPagination = false;
        });
        Future.delayed(Duration(milliseconds: 100),(){
          setState(() {
            enterFutureBuilder = true;
          });
        });
      });
    }else{
      print("///////////Global search//////////////");
      future = _eventService.getSearch(text: _textEditingController.text,page: page,token: token);
      future.then((value) {
        setState(() {
          doingPagination = false;
        });
        Future.delayed(Duration(milliseconds: 100),(){
          setState(() {
            enterFutureBuilder = true;
          });
        });
      });
    }
  }


  void _scrollListener() {
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels != 0 && enterFutureBuilder==false) {
        Future.delayed(Duration.zero,(){
          page += 1;
          setState(() {
            doingPagination = true;
          });
          print('scrolled to bottom page is now $page');
          if(widget.isLocal){
            print("///////////Local search Pagination//////////////");
            future = _eventService.getSearchLocal(text: _textEditingController.text,page: page,token: token);
            future.then((value) {
              setState(() {
                enterFutureBuilder = true;
              });
            });
          }else{
            print("///////////Global search Pagination//////////////");
            future = _eventService.getSearch(text: _textEditingController.text,page: page,token: token);
            future.then((value) {
              setState(() {
                enterFutureBuilder = true;
              });
            });
          }
        });
      }
    }
  }


  @override
  void initState() {
    getStoredValue();
    _textEditingController.addListener(_onSearchChanged);
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
    _textEditingController.removeListener(_onSearchChanged);
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void changeBookmark(int index){
    isBookMark[index] = !isBookMark[index];
    setState(() {});
  }

  void changeReaction(int index,String value){
    reaction[index] = value;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print(widget.isLocal);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: TextField(
          controller: _textEditingController,
          onChanged: (value){
            if(value.length>2){
              _onSearchChanged();
            }
          },
          style: TextStyle(color: themeController.isDarkMode?Colors.white:Colors.black),
          decoration: InputDecoration(
            hintStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.1,
              color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
            ),
            hintText: "Search",
            // contentPadding: EdgeInsets.only(
            //   left: 190,
            //   right: 0,
            //   bottom: 0,
            //   top: 13
            // ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 15,top: 15,bottom: 15),
              child: Image.asset(
                "lib/asset/homePageIcons/searchPurple@3x.png",
                height: 10,
                width: 10,
                color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
              ),
            ),
            suffixIcon: InkWell(
              onTap: (){
                Get.back();
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 16,right: 15),
                child: Text(
                  "Close",
                  style: TextStyle(
                    fontSize: 15,
                    letterSpacing: 0.1,
                    fontWeight: FontWeight.w700,
                    color: MateColors.activeIcons,
                  ),
                ),
              ),
            ),
            enabledBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(width: 3,color: themeController.isDarkMode?MateColors.darkDivider:MateColors.lightDivider),
            ),
            focusedBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(width: 3,color: themeController.isDarkMode?MateColors.darkDivider:MateColors.lightDivider),
            ),
          ),
        ),
      ),
      body: ListView(
        controller: _scrollController,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        children: [
          FutureBuilder<EventListingModel>(
            future: future,
            builder: (context,snapshot){
              if(snapshot.hasData){
                if(snapshot.data.success==true || doingPagination==true){
                  if(enterFutureBuilder){
                    if(doingPagination==false){
                      list.clear();
                      isBookMark.clear();
                      reaction.clear();
                    }
                    for(int i=0;i<snapshot.data.data.result.length;i++){
                      list.add(snapshot.data.data.result[i]);
                      isBookMark.add(snapshot.data.data.result[i].isBookmarked!=null?true:false);
                      if(snapshot.data.data.result[i].isReacted!=null){
                        reaction.add(snapshot.data.data.result[i].isReacted.status=="Going"?"Going":"Interested");
                      }else{
                        reaction.add("blank");
                      }
                    }
                    print("List length ${list.length}");
                    print("List bookmark length ${isBookMark.length}");
                    print("Reaction list length ${reaction.length}");
                    Future.delayed(Duration.zero,(){
                      enterFutureBuilder = false;
                      setState(() {});
                    });
                  }
                  return ListView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    children: [
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
                                  trailing:  PopupMenuButton<int>(
                                      padding: EdgeInsets.only(bottom: 0, top: 0, left: 25, right: 0),
                                      color: themeController.isDarkMode?backgroundColor:Colors.white,
                                      icon: Image.asset(
                                        "lib/asset/icons/menu@3x.png",
                                        height: 18,
                                      ),
                                      onSelected: (index) async {
                                        if (index == 0) {
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
                                        } else if (index == 1) {
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => Chat(peerUuid: list[index].user.uuid, currentUserId: _currentUser.uid, peerId: list[index].user.firebaseUid, peerAvatar: list[index].user.profilePhoto, peerName: list[index].user.displayName)));
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
                                        // PopupMenuItem(
                                        //   value: 1,
                                        //   height: 40,
                                        //   child: Text(
                                        //     "Message",
                                        //     textAlign: TextAlign.start,
                                        //     style: TextStyle(color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor, fontWeight: FontWeight.w500, fontSize: 12.6.sp),
                                        //   ),
                                        // ),
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
                                        DateFormat('hh:mm a').format(DateTime.parse(list[index].time.toString()).toLocal()).toString(),
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          letterSpacing: 0.1,
                                          color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                                        ),
                                      ),
                                      if(list[index].endTime!=null)
                                        Text(
                                          " - "+DateFormat('hh:mm a').format(DateTime.parse(list[index].endTime.toString()).toLocal()).toString(),
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
                                // Container(
                                //   height: 40,
                                //   margin: EdgeInsets.only(left: 16,top: 10),
                                //   width: MediaQuery.of(context).size.width,
                                //   child: ListView.builder(
                                //       scrollDirection: Axis.horizontal,
                                //       shrinkWrap: true,
                                //       physics: ScrollPhysics(),
                                //       itemCount: list[index].goingList.length>6?6:list[index].goingList.length,
                                //       itemBuilder: (context,ind){
                                //         return Row(
                                //           children: [
                                //             CircleAvatar(
                                //               radius: 12,
                                //               backgroundColor: MateColors.activeIcons,
                                //               backgroundImage: NetworkImage(list[index].goingList[ind].profilePhoto),
                                //             ),
                                //             list[index].goingList.length>6?
                                //             Padding(
                                //               padding: const EdgeInsets.only(left: 5),
                                //               child: Text("+${list[index].goingList.length -6}",
                                //                 style: TextStyle(
                                //                   fontSize: 14,
                                //                   color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
                                //                 ),
                                //               ),
                                //             ):
                                //             Offstage(),
                                //           ],
                                //         );
                                //       }
                                //   ),
                                // ),
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
                                              if(reaction[index]=="Interested" || reaction[index]=="blank"){
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
                                              if(reaction[index]=="Going" || reaction[index]=="blank"){
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
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    child: Center(
                      child: Text("No data found",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                        ),
                      ),
                    ),
                  );
                }
              }else if(snapshot.hasError){
                return Container(
                  height: MediaQuery.of(context).size.height,
                  child: Center(
                    child: Text("Something went wrong",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                      ),
                    ),
                  ),
                );
              }else{
                return Container();
                //   Center(
                //   child: CircularProgressIndicator(),
                // );
                //   Shimmer.fromColors(
                //   baseColor: const Color(0xFFC4C4C4),
                //   highlightColor: const Color(0xFF9E9E9E),
                //   enabled: true,
                //   child: const MyRideShimmer(),
                // );
              }
            },
          ),
          // Container(
          //   height: 51,
          //   child: ListView.builder(
          //     scrollDirection: Axis.horizontal,
          //     shrinkWrap: true,
          //     physics: BouncingScrollPhysics(),
          //     itemCount: 10,
          //     itemBuilder: (context,index){
          //       return Container(
          //         margin: EdgeInsets.only(left: 15,top: 15),
          //         decoration: BoxDecoration(
          //           borderRadius: BorderRadius.circular(25),
          //           color: themeController.isDarkMode?MateColors.darkDivider:MateColors.lightDivider,
          //         ),
          //         child: Center(
          //           child: Padding(
          //             padding: const EdgeInsets.symmetric(horizontal: 25),
          //             child: Text("Opportunities",style: TextStyle(fontSize: 14,fontFamily: "Poppins",color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,),),
          //           ),
          //         ),
          //       );
          //     },
          //   ),
          // ),
        ],
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

}
