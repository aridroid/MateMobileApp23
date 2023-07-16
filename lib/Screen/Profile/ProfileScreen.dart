import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mate_app/Screen/Profile/bio_details_page.dart';
import 'package:mate_app/Screen/Profile/updateProfile.dart';
import 'package:mate_app/Services/AuthUserService.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Providers/AuthUserProvider.dart';
import '../../Providers/FeedProvider.dart';
import '../../Widget/Home/HomeRow.dart';
import '../../controller/theme_controller.dart';
import '../Login/GoogleLogin.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  static final String profileScreenRoute = '/profile';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String imageSource = "Camera";
  final picker = ImagePicker();
  late ScrollController _scrollController;
  late int _page;
  late String userId;
  late AuthUserProvider authUserProvider;
  late FeedProvider feedProvider;

  @override
  void initState() {
    feedProvider = Provider.of<FeedProvider>(context, listen: false);
    authUserProvider = Provider.of<AuthUserProvider>(context, listen: false);
    userId = Provider.of<AuthUserProvider>(context, listen: false).authUser.id!;
    Future.delayed(Duration(milliseconds: 600), (){
      Provider.of<FeedProvider>(context, listen: false).fetchFeedList(page: 1,userId: userId);
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
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels != 0) {
        Future.delayed(Duration.zero,(){
          _page += 1;
          print('scrolled to bottom page is now $_page');
          Provider.of<FeedProvider>(context, listen: false).fetchFeedList(page: _page, paginationCheck: true, userId: userId);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scH = MediaQuery.of(context).size.height;
    final scW = MediaQuery.of(context).size.width;
    ThemeController themeController = Get.find<ThemeController>();
    Future.delayed(Duration(seconds: 0), () {
      Provider.of<AuthUserProvider>(context, listen: false).getUserInfo(userId);
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
              child: Consumer<AuthUserProvider>(builder: (ctx, provider, _) {
                return Stack(
                  children: [
                    Container(
                      height: 220,
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        image: DecorationImage(
                          image:
                          (provider.authUser.coverPhotoUrl != null && provider.authUser.coverPhotoUrl! != "")
                              ? NetworkImage(provider.authUser.coverPhotoUrl!) :
                          AssetImage("lib/asset/icons/profile-cover-new.png") as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 125,left: 33),
                      child: InkWell(
                        onTap: (){
                          //modalSheet();
                        },
                        child: CircleAvatar(
                          backgroundColor: Color(0xFF143548),
                          radius: 60,
                          child: CircleAvatar(
                            radius: 54,
                            backgroundImage: NetworkImage(provider.authUser.photoUrl!),
                            child: Visibility(
                              visible: provider.photoUpdateLoaderStatus,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 150,left: 170),
                      child: Text(provider.authUser.displayName!,
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
                            child: Text(provider.authUser.university!,
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
                    Positioned(
                      right: 30,
                      top: 20,
                      child: InkWell(
                        onTap: (){
                          Get.to(UpdateProfile(
                            fullName: provider.authUser.displayName!,
                            about: provider.userAboutData!.data!.about!,
                            uuid: provider.authUser.id!,
                            universityId: provider.authUser.universityId!,
                            photoUrl: provider.authUser.photoUrl!,
                            coverPhotoUrl: provider.authUser.coverPhotoUrl!,
                          ));
                         // modalSheetForCoverPic();
                        },
                        child: Image.asset("lib/asset/icons/edit.png",
                          height: 23,
                          color: themeController.isDarkMode?Colors.white:Colors.black,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 60,
                      top: 22,
                      child: InkWell(
                        onTap: (){
                          _showDeleteDialog(uuid: provider.authUser.id!);
                        },
                        child: Image.asset(
                          "lib/asset/icons/trashNew.png",
                          height: 20,
                          width: 20,
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
                if(!userProvider.userAboutDataLoader && userProvider.userAboutData != null && userProvider.userAboutData!.data!.about!=""){
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 16,left: 16,right: 16),
                      child: InkWell(
                        onTap: (){
                          Get.to(BioDetailsPage(bio: userProvider.userAboutData!.data!.about??"",));
                        },
                        child: Text(
                          userProvider.userAboutData!.data!.about??"",
                          //"hello world just loke other hope value of the text just like hope that is nothing to do with person on the planet hope you are doing well but sould know the value of the person that is very improtant in the field of biology",
                          //textAlign: TextAlign.center,
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
                      var feedItemListOfUser = feedProvider.feedItemListOfUser[index];//feedProvider.feedList[index];
                      return Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: HomeRow(
                          previousPageUserId: userId,
                          id: feedItemListOfUser.id,
                          feedId: feedItemListOfUser.feedId,
                          title: feedItemListOfUser.title,
                          feedType: feedItemListOfUser.feedTypes,
                          start: feedItemListOfUser.start,
                          end: feedItemListOfUser.end,
                          calenderDate: feedItemListOfUser.feedCreatedAt,
                          description: feedItemListOfUser.description,
                          created: feedItemListOfUser.created,
                          user: feedItemListOfUser.user,
                          location: feedItemListOfUser.location,
                          hyperlinkText: feedItemListOfUser.hyperlinkText,
                          hyperlink: feedItemListOfUser.hyperlink,
                          media: feedItemListOfUser.media,
                          isLiked: feedItemListOfUser.isLiked,
                          liked: feedItemListOfUser.isLiked!=null?true:false,
                          bookMarked: feedItemListOfUser.isBookmarked,
                          isFollowed: feedItemListOfUser.isFollowed??false,
                          likeCount: feedItemListOfUser.likeCount,
                          bookmarkCount: feedItemListOfUser.bookmarkCount,
                          shareCount: feedItemListOfUser.shareCount,
                          commentCount: feedItemListOfUser.commentCount,
                          isShared: feedItemListOfUser.isShared,
                          indexVal: index,
                          pageType: "User",
                          mediaOther: feedItemListOfUser.mediaOther,
                          isPlaying: feedItemListOfUser.isPlaying,
                          isPaused: feedItemListOfUser.isPaused,
                          isLoadingAudio: feedItemListOfUser.isLoadingAudio,
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

  Future<void> _showDeleteDialog({required String uuid}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: new Text("Are you sure?"),
          content: new Text("You want to delete your account?"),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text("Yes"),
              onPressed: ()async{
                SharedPreferences preferences = await SharedPreferences.getInstance();
                String token = preferences.getString("tokenApp")!;
                bool res = await AuthUserService().deleteUser(token: token, uuid: uuid);
                if(res){
                  authUserProvider.logout();
                  Navigator.of(context).pop();
                  Get.offNamedUntil(GoogleLogin.loginScreenRoute, (route) => false);
                }else{
                  Navigator.of(context).pop();
                  Fluttertoast.showToast(msg: "Something went wrong", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
                }
              },
            ),
            CupertinoDialogAction(
                child: Text("No"),
                onPressed: () {
                  print(uuid);
                  Navigator.of(context).pop();
                })
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

