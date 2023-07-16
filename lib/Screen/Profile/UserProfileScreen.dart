import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mate_app/constant.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Providers/AuthUserProvider.dart';
import '../../Providers/FeedProvider.dart';
import '../../Providers/UserProvider.dart';
import '../../Providers/reportProvider.dart';
import '../../Services/connection_service.dart';
import '../../Widget/Home/HomeRow.dart';
import '../../audioAndVideoCalling/connectingScreen.dart';
import '../../controller/theme_controller.dart';
import '../../groupChat/pages/customAlertDialog.dart';
import '../Home/HomeScreen.dart';
import '../chat1/personalChatPage.dart';
import '../chat1/screens/chat.dart';
import 'bio_details_page.dart';
import 'package:http/http.dart'as http;

class UserProfileScreen extends StatefulWidget {
  static final String routeName = '/user-profile';
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  ThemeController themeController = Get.find<ThemeController>();
  late ScrollController _scrollController;
  late int _page;
  User _currentUser = FirebaseAuth.instance.currentUser!;
  late UserProvider userProvider;
  late ReportProvider reportProvider;
  late String token;
  late FeedProvider feedProvider;

  getStoredValue()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("tokenApp")!;
  }

  @override
  void initState() {
    getStoredValue();
    feedProvider = Provider.of<FeedProvider>(context, listen: false);
    userProvider = Provider.of<UserProvider>(context, listen: false);
    reportProvider = Provider.of<ReportProvider>(context, listen: false);
    Future.delayed(Duration(milliseconds: 600), (){
      final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      Provider.of<FeedProvider>(context, listen: false).fetchFeedList(page: 1,userId: routeArgs['id']);
    });
    _page = 1;
    _scrollController = new ScrollController()..addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
  }

  void _scrollListener() {
    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels != 0) {
        Future.delayed(Duration.zero,(){
          _page += 1;
          print('scrolled to bottom page is now $_page');
          Provider.of<FeedProvider>(context, listen: false).fetchFeedList(page: _page, paginationCheck: true, userId: routeArgs['id']);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scH = MediaQuery.of(context).size.height;
    final scW = MediaQuery.of(context).size.width;
    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    Future.delayed(Duration(seconds: 0), () {
      Provider.of<UserProvider>(context, listen: false).findUserById(id: routeArgs["id"]);
      Provider.of<AuthUserProvider>(context, listen: false).getUserInfo(routeArgs["id"]);
    });
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
            SizedBox(
              height: scH*0.07,
            ),
            Container(
              height: 250,
              child: Consumer<UserProvider>(builder: (ctx, provider, _) {
                return Stack(
                  children: [
                    Container(
                      height: 220,
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        image: DecorationImage(
                          image: provider.fullUserDetail!=null?(provider.fullUserDetail!.coverPhotoUrl!=null && provider.fullUserDetail!.coverPhotoUrl!="")?
                          NetworkImage(provider.fullUserDetail!.coverPhotoUrl!) as ImageProvider
                              :AssetImage("lib/asset/icons/profile-cover-new.png"):AssetImage("lib/asset/icons/profile-cover-new.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 125,left: 33),
                      child: InkWell(
                        onTap: (){
                          showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (context) {
                                return CustomDialog(
                                  backgroundColor: Colors.transparent,
                                  clipBehavior: Clip.hardEdge,
                                  insetPadding: EdgeInsets.all(0),
                                  child: Padding(
                                    padding: const EdgeInsets.all(00.0),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width*0.8,
                                      height: MediaQuery.of(context).size.height*0.6,
                                      child: InteractiveViewer(
                                        panEnabled: true, // Set it to false to prevent panning.
                                        boundaryMargin: EdgeInsets.all(50),
                                        minScale: 0.5,
                                        maxScale: 4,
                                        child: provider.fullUserDetail!=null?(provider.fullUserDetail!.photoUrl!=null && provider.fullUserDetail!.photoUrl!="")?
                                        Image.network(provider.fullUserDetail!.photoUrl!)
                                            :Image.network(routeArgs["photoUrl"]??""):Image.network(routeArgs["photoUrl"]??""),
                                      ),
                                    ),
                                  ),
                                );
                              });
                          // });
                        },
                        child: CircleAvatar(
                          backgroundColor: Color(0xFF143548),
                          radius: 60,
                          child: CircleAvatar(
                            radius: 54,
                            backgroundImage: provider.fullUserDetail!=null?(provider.fullUserDetail!.photoUrl!=null && provider.fullUserDetail!.photoUrl!="")?
                            NetworkImage(provider.fullUserDetail!.photoUrl!) :NetworkImage(routeArgs["photoUrl"]??""):NetworkImage(routeArgs["photoUrl"]??""),
                            ),
                          ),
                      ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(top: 150,left: 170),
                      child: Text(routeArgs['name'],
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 22.0,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 185,left: 165),
                      child: Row(
                        children: [
                          Icon(Icons.location_on_sharp,
                            color: Colors.white,
                            size: 15,
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Expanded(
                            child: Text(
                              userProvider.fullUserDetail!=null?
                              userProvider.fullUserDetail!.university??"":"",
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                color: Colors.white.withOpacity(0.7),
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                fontFamily: "Poppins",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 30,
                      top: 20,
                      child: InkWell(
                        onTap: (){
                          Get.back();
                        },
                        child: Icon(Icons.arrow_back_ios,
                          size: 23,
                          color: themeController.isDarkMode?Colors.white:Colors.black,
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
            Consumer<AuthUserProvider>(
              builder: (context, userProvider, _){
                if(!userProvider.userAboutDataLoader && userProvider.userAboutData != null && userProvider.userAboutData!.data!.about!=null){
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 16,left: 16,right: 16),
                      child: InkWell(
                        onTap: (){
                          Get.to(BioDetailsPage(bio: userProvider.userAboutData!.data!.about??"",));
                        },
                        child: Text(
                          userProvider.userAboutData!.data!.about??"",
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.1,
                            color: themeController.isDarkMode?Colors.white:Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                }else{
                  return Container();
                }
              },
            ),
            _threeButtons(context, routeArgs),
            Expanded(
              child: Consumer<FeedProvider>(
                builder: (ctx, feedProvider, _){
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    controller: _scrollController,
                    shrinkWrap: true,
                    padding: EdgeInsets.only(top: 10),
                    physics: ScrollPhysics(),
                    itemCount: feedProvider.feedItemListOfUser.length,//feedProvider.feedList.length,
                    itemBuilder: (context,index){
                      var feedItem = feedProvider.feedItemListOfUser[index];//feedProvider.feedList[index];
                      return Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: HomeRow(
                          previousPageUserId: routeArgs['id'],
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
                          pageType: "User",
                          mediaOther: feedItem.mediaOther,
                          isPlaying: feedItem.isPlaying,
                          isPaused: feedItem.isPaused,
                          isLoadingAudio: feedItem.isLoadingAudio,
                          startAudio: startAudio,
                          pauseAudio: pauseAudio,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _threeButtons(BuildContext context, Map<String, dynamic> routeArgs) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        IconButton(
          onPressed: (){
            Get.to(()=>ConnectingScreen(
              callType: "Audio Calling",
              receiverImage: routeArgs["photoUrl"]??"",
              receiverName: routeArgs['name'],
              uid: [routeArgs['firebaseUid']],
              isGroupCalling: false,
            ));
          },
          icon: Icon(Icons.call,
            color: themeController.isDarkMode?Colors.white:Colors.black,
          ),
        ),
        IconButton(
          onPressed: (){
            Get.to(()=>ConnectingScreen(
              callType: "Video Calling",
              receiverImage: routeArgs["photoUrl"]??"",
              receiverName: routeArgs['name'],
              uid: [routeArgs['firebaseUid']],
              isGroupCalling: false,
            ));
          },
          icon: Icon(Icons.video_call_rounded,
            color: themeController.isDarkMode?Colors.white:Colors.black,
          ),
        ),
        IconButton(
          padding: EdgeInsets.fromLTRB(8, 8, 0, 8),
          iconSize: 22,
          onPressed: (){
            if(requestSentUid.contains(routeArgs['firebaseUid'])){
              Fluttertoast.showToast(msg: "Connection request already sent", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
            }else if(requestGetUidSender.contains(routeArgs['firebaseUid'])){
              Fluttertoast.showToast(msg: "Please go to connection screen to accept request", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
            }else{
              _showAddConnectionAlertDialog(uid: routeArgs['firebaseUid'], name: routeArgs['name'],uuid: routeArgs['id']);
            }
          },
          icon: !connectionGlobalUidList.contains(routeArgs['firebaseUid'])?
          Image.asset(
            "lib/asset/icons/addPerson.png",
            width: 15,
            fit: BoxFit.fitWidth,
            color: themeController.isDarkMode?Colors.white:Colors.black,
          ):
          Icon(Icons.person_remove_alt_1,
            color: themeController.isDarkMode?Colors.white:Colors.black,
          ),
        ),
      IconButton(
        padding: EdgeInsets.fromLTRB(0, 8, 8, 8),
        iconSize: 20,
         icon: Image.asset(
           "lib/asset/homePageIcons/chat.png",
            width: 18,
            fit: BoxFit.fitWidth,
           color: themeController.isDarkMode?Colors.white:Colors.black,
          ),
          onPressed: () {
            if(routeArgs['firebaseUid']!=null){
              Get.to(() =>
                  Chat(
                    peerUuid: routeArgs['id'],
                    currentUserId: _currentUser.uid,
                    peerId: routeArgs['firebaseUid'],
                    peerName: routeArgs['name'],
                    peerAvatar: routeArgs['photoUrl'],
                  ));
            }else
              Get.to(() => PersonalChatScreen());

          },
        ),
        IconButton(
          padding: EdgeInsets.fromLTRB(0, 8, 8, 8),
          iconSize: 20,
          icon:Icon(Icons.block,
            color: themeController.isDarkMode?Colors.white:Colors.black,
          ) ,
          onPressed: () {
            Map<String, dynamic> body = {
              "user_uuid": routeArgs['id']
            };
            _showDeleteAlertDialog(body: body, name: routeArgs["name"].toString().trim());
          },
        ),
      ],
    );
  }


  _showDeleteAlertDialog({required Map<String, dynamic> body, required String name})async{
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: new Text("Are you sure that you want to block $name"),
          content: new Text("\n"+name + "  will no longer be able to : \n\n"
              "See your Feeds, CampusLive, CampusTalk, BeAMate, FindAMate posts\n"
              "See your profile\n"
              "Start a conversation with you"),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text("Block"),
              onPressed: () async {
                print(body);
                bool reportDone = await reportProvider.blockUser(body);
                if (reportDone) {
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeScreen(),), (route) => false);
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


  _showAddConnectionAlertDialog({required String uid, required String name,required String uuid})async{
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: new Text("Are you sure?"),
          content: new Text(
              !connectionGlobalUidList.contains(uid)?
              "You want to add ${name} to your connection":"You want to remove ${name} from your connection"
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text("Yes"),
              onPressed: ()async{
                if(!connectionGlobalUidList.contains(uid)){
                  await ConnectionService().addConnection(uid: uid,name: name,uuid:uuid,token: token);
                }else{
                  int index = connectionGlobalUidList.indexOf(uid);
                  int connId = connectionGlobalList[index].id!;
                  await ConnectionService().removeConnection(connId: connId,token: token);
                }
                Navigator.of(context).pop();
                await getConnection();
                setState(() {});
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

  final audioPlayer = AudioPlayer();

  Future<void> startAudio(String url,int index) async {
    print(url);
    print(index);
    print(feedProvider.feedItemListOfUser[index].isPaused);
    if(feedProvider.feedItemListOfUser[index].isPaused==true){
      for(int i=0;i<feedProvider.feedItemListOfUser.length;i++){
        feedProvider.feedItemListOfUser[i].isPlaying = false;
      }
      feedProvider.feedItemListOfUser[index].isPaused = false;
      audioPlayer.play();
      setState(() {
        feedProvider.feedItemListOfUser[index].isPlaying = true;
      });
      audioPlayer.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          setState(() {
            feedProvider.feedItemListOfUser[index].isPlaying = false;
            feedProvider.feedItemListOfUser[index].isPaused = false;
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
              feedProvider.feedItemListOfUser[index].isPlaying = false;
              feedProvider.feedItemListOfUser[index].isPaused = false;
            });
          }
        });

        audioPlayer.positionStream.listen((event) {
          setState(() {
            //currentDuration = event;
          });
        });

        audioPlayer.stop();
        for(int i=0;i<feedProvider.feedItemListOfUser.length;i++){
          feedProvider.feedItemListOfUser[i].isPlaying = false;
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
            feedProvider.feedItemListOfUser[index].isPlaying = true;
          });
        }else{
          setState(() {
            feedProvider.feedItemListOfUser[index].isLoadingAudio = true;
          });

          String path = await downloadAudio(url);

          setState(() {
            feedProvider.feedItemListOfUser[index].isLoadingAudio = false;
          });

          if(path !=""){
            await audioPlayer.setFilePath(path);
            audioPlayer.play();
            setState(() {
              feedProvider.feedItemListOfUser[index].isPlaying = true;
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
      feedProvider.feedItemListOfUser[index].isPlaying = false;
      feedProvider.feedItemListOfUser[index].isPaused = true;
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

}
