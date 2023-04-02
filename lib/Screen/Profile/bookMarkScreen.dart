import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mate_app/Widget/Loaders/Shimmer.dart';
import 'package:mate_app/asset/Colors/MateColors.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../Model/bookmarkByUserModel.dart';
import '../../Providers/FeedProvider.dart';
import '../../Widget/Home/HomeRow.dart';
import '../Home/events/eventBookmark.dart';
import 'campusTalkBookmark.dart';
import 'feedsBookmark.dart';
import 'package:http/http.dart'as http;
import '../../Model/FeedItem.dart' as feedItem;

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({Key key}) : super(key: key);
  @override
  _BookmarkScreenState createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> with TickerProviderStateMixin{
  //FeedProvider feedProvider;
  PageController _pageController;
  int _selectedIndex = 0;

  @override
  void initState() {
    _pageController = PageController(initialPage: _selectedIndex);
    //feedProvider = Provider.of<FeedProvider>(context, listen: false);
    super.initState();
    //Future.delayed(Duration(milliseconds: 600),()=>Provider.of<FeedProvider>(context, listen: false).myCampusBookmarkedFeed());
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  //
  // final audioPlayer = AudioPlayer();
  //
  // Future<void> startAudio(String url,int index) async {
  //   print(url);
  //   print(index);
  //   print(feedProvider.bookmarkByUserDataMycampus.data.feeds[index].isPaused);
  //   if(feedProvider.bookmarkByUserDataMycampus.data.feeds[index].isPaused==true){
  //     for(int i=0;i<feedProvider.bookmarkByUserDataMycampus.data.feeds.length;i++){
  //       feedProvider.bookmarkByUserDataMycampus.data.feeds[i].isPlaying = false;
  //     }
  //     feedProvider.bookmarkByUserDataMycampus.data.feeds[index].isPaused = false;
  //     audioPlayer.play();
  //     setState(() {
  //       feedProvider.bookmarkByUserDataMycampus.data.feeds[index].isPlaying = true;
  //     });
  //     audioPlayer.playerStateStream.listen((state) {
  //       if (state.processingState == ProcessingState.completed) {
  //         setState(() {
  //           feedProvider.bookmarkByUserDataMycampus.data.feeds[index].isPlaying = false;
  //           feedProvider.bookmarkByUserDataMycampus.data.feeds[index].isPaused = false;
  //         });
  //       }
  //     });
  //
  //     audioPlayer.positionStream.listen((event) {
  //       setState(() {
  //         // currentDuration = event;
  //       });
  //     });
  //
  //   }else{
  //     try{
  //       audioPlayer.playerStateStream.listen((state) {
  //         if (state.processingState == ProcessingState.completed) {
  //           setState(() {
  //             feedProvider.bookmarkByUserDataMycampus.data.feeds[index].isPlaying = false;
  //             feedProvider.bookmarkByUserDataMycampus.data.feeds[index].isPaused = false;
  //           });
  //         }
  //       });
  //
  //       audioPlayer.positionStream.listen((event) {
  //         setState(() {
  //           //currentDuration = event;
  //         });
  //       });
  //
  //       audioPlayer.stop();
  //       for(int i=0;i<feedProvider.bookmarkByUserDataMycampus.data.feeds.length;i++){
  //         feedProvider.bookmarkByUserDataMycampus.data.feeds[i].isPlaying = false;
  //       }
  //       setState(() {});
  //
  //       var dir = await getApplicationDocumentsDirectory();
  //       var filePathAndName = dir.path + "/audios/" +url.split("/").last + ".mp3";
  //       if(File(filePathAndName).existsSync()){
  //         print("------File Already Exist-------");
  //         print(filePathAndName);
  //         await audioPlayer.setFilePath(filePathAndName);
  //         audioPlayer.play();
  //         setState(() {
  //           feedProvider.bookmarkByUserDataMycampus.data.feeds[index].isPlaying = true;
  //         });
  //       }else{
  //         setState(() {
  //           feedProvider.bookmarkByUserDataMycampus.data.feeds[index].isLoadingAudio = true;
  //         });
  //
  //         String path = await downloadAudio(url);
  //
  //         setState(() {
  //           feedProvider.bookmarkByUserDataMycampus.data.feeds[index].isLoadingAudio = false;
  //         });
  //
  //         if(path !=""){
  //           await audioPlayer.setFilePath(path);
  //           audioPlayer.play();
  //           setState(() {
  //             feedProvider.bookmarkByUserDataMycampus.data.feeds[index].isPlaying = true;
  //           });
  //         }else{
  //           Fluttertoast.showToast(msg: "Something went wrong while playing audio please try again!", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
  //         }
  //       }
  //
  //     }catch(e){
  //       print("Error loading audio source: $e");
  //     }
  //   }
  // }
  //
  // void pauseAudio(int index)async{
  //   audioPlayer.pause();
  //   setState(() {
  //     feedProvider.bookmarkByUserDataMycampus.data.feeds[index].isPlaying = false;
  //     feedProvider.bookmarkByUserDataMycampus.data.feeds[index].isPaused = true;
  //   });
  // }
  //
  // Future<String> downloadAudio(String url)async{
  //   var dir = await getApplicationDocumentsDirectory();
  //   var firstPath = dir.path + "/audios";
  //   var filePathAndName = dir.path + "/audios/" +url.split("/").last + ".mp3";
  //   await Directory(firstPath).create(recursive: true);
  //   File file = new File(filePathAndName);
  //   try{
  //     var request = await http.get(Uri.parse(url));
  //     print(request.statusCode);
  //     var res = await file.writeAsBytes(request.bodyBytes);
  //     print("---File Path----");
  //     print(res.path);
  //     return res.path;
  //   }catch(e){
  //     print(e);
  //     return "";
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final scH = MediaQuery.of(context).size.height;
    final scW = MediaQuery.of(context).size.width;
    return Scaffold(
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
                      color: themeController.isDarkMode ? Colors.white : MateColors.blackTextColor,
                    ),
                  ),
                  Text(
                    "Bookmarks",
                    style: TextStyle(
                      color: themeController.isDarkMode ? Colors.white : MateColors.blackTextColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 17.0,
                    ),
                  ),
                  SizedBox(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16,right: 16,top: 20,bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      //Get.to(()=>FeedsBookmark());
                      _pageController.animateToPage(0, duration: Duration(milliseconds: 500), curve: Curves.ease);
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
                              child: Image.asset('lib/asset/iconsNewDesign/house.png',color: Colors.white,),
                            ),
                          ),
                          Text('Home Feed',
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
                      _pageController.animateToPage(1, duration: Duration(milliseconds: 500), curve: Curves.ease);
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
                      //Get.to(()=>EventBookmark());
                      _pageController.animateToPage(2, duration: Duration(milliseconds: 500), curve: Curves.ease);
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
                              child: Image.asset('lib/asset/iconsNewDesign/calendar.png',color: Colors.white,),
                            ),
                          ),
                          Text('Events',
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
                      //Get.to(()=>CampusTalkBookmark());
                      _pageController.animateToPage(3, duration: Duration(milliseconds: 500), curve: Curves.ease);
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
                              child: Image.asset('lib/asset/iconsNewDesign/document.png',color: Colors.white,),
                            ),
                          ),
                          Text('Campus Forum',
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
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (val){
                  setState(() {
                    _selectedIndex = val;
                  });
                },
                children: [
                  FeedsBookmark(),
                  Container(
                    child: Center(
                      child: Text(
                        "Coming soon",
                        style: TextStyle(
                          color: themeController.isDarkMode ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                  EventBookmark(),
                  CampusTalkBookmark(),
                ],
              ),


              // Consumer<FeedProvider>(
              //   builder: (context, value, child) {
              //     if(!value.myCampusBookmarkedFeedLoader && value.bookmarkByUserDataMycampus!=null && value.bookmarkByUserDataMycampus.data.feeds!=null){
              //       return ListView.builder(
              //         itemCount: value.bookmarkByUserDataMycampus.data.feeds.length,
              //         padding: EdgeInsets.only(top: 10,left: 16,right: 16,bottom: 16),
              //         itemBuilder: (context, index) {
              //           Feeds feeds= value.bookmarkByUserDataMycampus.data.feeds[index];
              //           return HomeRow(
              //             id: feeds.id,
              //             feedId: feeds.feedId,
              //             title: feeds.title,
              //             feedType: feeds.feedTypes,
              //             start: feeds.start,
              //             end: feeds.end,
              //             calenderDate: feeds.feedCreatedAt,
              //             description: feeds.description,
              //             created: feeds.created,
              //             user: feeds.user,
              //             location: feeds.location,
              //             hyperlinkText: feeds.hyperlinkText,
              //             hyperlink: feeds.hyperlink,
              //             media: feeds.media,
              //             liked: feeds.isLiked!=null?true:false,
              //             isLiked: feeds.isLiked,
              //             bookMarked: feeds.isBookmarked,
              //             isFollowed: feeds.isFollowed,
              //             isBookmarkedPage: true,
              //             likeCount: feeds.likeCount,
              //             bookmarkCount: feeds.bookmarkCount,
              //             shareCount: feeds.shareCount,
              //             commentCount: feeds.commentCount,
              //             isShared: feeds.isShared,
              //             indexVal: index,
              //             pageType: "BookmarkMyCampus",
              //             mediaOther: feeds.mediaOther,
              //             isPlaying: feeds.isPlaying,
              //             isPaused: feeds.isPaused,
              //             isLoadingAudio: feeds.isLoadingAudio,
              //             startAudio: startAudio,
              //             pauseAudio: pauseAudio,
              //           );
              //         },
              //       );
              //     }
              //     if (value.error != '') {
              //       return Center(
              //         child: Container(
              //           color: Colors.red,
              //           child: Padding(
              //             padding: const EdgeInsets.all(8.0),
              //             child: Text(
              //               '${value.error}',
              //               style: TextStyle(
              //                 color: Colors.white,
              //               ),
              //             ),
              //           ),
              //         ),
              //       );
              //     }
              //     if(value.myCampusBookmarkedFeedLoader) {
              //       return timelineLoader();
              //     }
              //     return Container();
              //   },
              // ),
            ),
          ],
        ),
      ),
    );
  }
}
