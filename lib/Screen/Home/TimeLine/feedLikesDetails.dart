import 'package:get/get.dart';
import 'package:mate_app/Providers/FeedProvider.dart';
import 'package:mate_app/Screen/Profile/UserProfileScreen.dart';
import 'package:mate_app/Widget/Loaders/Shimmer.dart';
import 'package:mate_app/asset/Colors/MateColors.dart';
import 'package:mate_app/reactionsContants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedLikesDetails extends StatefulWidget {
  final int feedId;
  const FeedLikesDetails({Key? key, required this.feedId}) : super(key: key);

  @override
  _FeedLikesDetailsState createState() => _FeedLikesDetailsState();
}

class _FeedLikesDetailsState extends State<FeedLikesDetails> with TickerProviderStateMixin{
  late TabController _tabController;
  List<Widget> _containers = [];
  List<Tab> _tabList = [];
  int totalTab=0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 0, vsync: this);
    Future.delayed(Duration.zero,(){
      FeedProvider fp = Provider.of<FeedProvider>(context, listen: false);
      fp.fetchLikeDetailsOfAFeed(widget.feedId).then((value) {
        _containers.add(mainList(fp));
        _tabList.add(Tab(text: "ALL  ${fp.likeDetailsFetchData!.data!.result!.length} "));

        for (int i = 0; i < reactionTexts.length; i++) {
          print(fp.likeDetailsFetchData!.emojiGroups["$i"]);
          if(fp.likeDetailsFetchData!.emojiGroups["$i"]!=null){
            totalTab++;
            _tabList.add(Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    reactionImages[i],
                    width: 16,
                  ),
                  Text("   ${fp.likeDetailsFetchData!.emojiGroups["$i"].length}"),
                ],
              ),
            ));
          _containers.add(subList(fp.likeDetailsFetchData!.emojiGroups["$i"]));
          }
        }
        _tabController = TabController(length: totalTab+1, vsync: this);
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    print('dispose called');
    super.dispose();
  }

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
                    "Reactions",
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
            Expanded(
              child: Consumer<FeedProvider>(
                builder: (ctx, feedProvider, _){
                  if(feedProvider.fetchLikeDetailsLoader){
                    return userListLoader();
                  }
                  else if (feedProvider.error != '') {
                    return Center(
                        child: Container(
                            color: Colors.red,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${feedProvider.error}',
                                style: TextStyle(color: Colors.white),
                              ),
                            )));

                  }else if(feedProvider.likeDetailsFetchData!=null){
                    return Column(
                      children: [
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.0),
                            border: Border(bottom: BorderSide(color: Color(0xFF65656B).withOpacity(0.2), width: 0.8)),
                          ),
                          child: TabBar(
                            controller: _tabController,
                            unselectedLabelColor: Color(0xFF656568),
                            indicatorColor: MateColors.activeIcons,
                            indicatorPadding: EdgeInsets.symmetric(horizontal: 20),
                            labelColor: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                            labelStyle: TextStyle(fontSize: 15.0,fontFamily: "Poppins",fontWeight: FontWeight.w500),
                            onTap: (int index) {},
                            tabs: _tabList,
                          ),
                        ),
                        Expanded(
                          child:
                          TabBarView(controller: _tabController, children: _containers),
                        ),
                      ],
                    );
                  }
                  return Center(child: Text("No Data Found"),);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget mainList(FeedProvider feedProvider){
    return ListView.builder(
      shrinkWrap: true,
      itemCount: feedProvider.likeDetailsFetchData!.data!.result!.length,
      padding: EdgeInsets.only(top: 16),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0, left: 0.0, right: 0.0,top: 5),
          child: InkWell(
            onTap: (){
              Navigator.of(context).pushNamed(UserProfileScreen.routeName, arguments: {
                "id": feedProvider.likeDetailsFetchData!.data!.result![index].user!.uuid,
                "name": feedProvider.likeDetailsFetchData!.data!.result![index].user!.displayName,
                "photoUrl": feedProvider.likeDetailsFetchData!.data!.result![index].user!.profilePhoto,
                "firebaseUid": feedProvider.likeDetailsFetchData!.data!.result![index].user!.firebaseUid
              });
            },
            child: ListTile(
              leading: Stack(
                // alignment: Alignment.topCenter,
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundImage: NetworkImage(
                      feedProvider.likeDetailsFetchData!.data!.result![index].user!.profilePhoto!,
                    ),
                  ),
                  Positioned(
                    right: -4,
                    top: 27,
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: MateColors.line,
                      child: Image.asset(
                        reactionImages[feedProvider.likeDetailsFetchData!.data!.result![index].emojiValue!],
                        width: 14,
                      ),
                    ),
                  )
                ],
              ),
              title: Text(feedProvider.likeDetailsFetchData!.data!.result![index].user!.displayName!,
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w600,
                  color: themeController.isDarkMode?Colors.white: MateColors.blackTextColor,
                ),
              ),
            ),
          ),
        );
      },);
  }

  Widget subList(List<dynamic> result){
    return ListView.builder(
      shrinkWrap: true,
      itemCount: result.length,
      padding: EdgeInsets.only(top: 16),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0, left: 0.0, right: 0.0,top: 5),
          child: InkWell(
            onTap: (){
              Navigator.of(context).pushNamed(UserProfileScreen.routeName, arguments: {
                "id": result[index]["user"]['uuid'],
                "name": result[index]["user"]['display_name'],
                "photoUrl": result[index]["user"]['profile_photo'],
                "firebaseUid": result[index]["user"]['firebase_uid']
              });
            },
            child: ListTile(
              leading: Stack(
                // alignment: Alignment.topCenter,
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundImage: NetworkImage(
                      result[index]["user"]['profile_photo'],
                    ),
                  ),
                  Positioned(
                    right: -4,
                    top: 27,
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: MateColors.line,
                      child: Image.asset(
                        reactionImages[result[index]['emoji_value']],
                        width: 14,
                      ),
                    ),
                  )
                ],
              ),
              title: Text(result[index]["user"]['display_name'],
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w600,
                  color: themeController.isDarkMode?Colors.white: MateColors.blackTextColor,
                ),
              ),
            ),
          ),
        );
      },);
  }
}
