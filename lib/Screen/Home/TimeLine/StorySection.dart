import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mate_app/Screen/Home/TimeLine/pageViewForStory.dart';
import 'package:mate_app/Screen/Home/TimeLine/postAStory.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../Model/getStoryModel.dart';
import '../../../Providers/AuthUserProvider.dart';
import '../../../Providers/FeedProvider.dart';
import '../../../asset/Colors/MateColors.dart';
import '../../../controller/theme_controller.dart';
import 'StoryPreviewScreen.dart';

class StorySection extends StatefulWidget {
  @override
  _StorySectionState createState() => _StorySectionState();
}

class _StorySectionState extends State<StorySection> {
  ThemeController themeController = Get.find<ThemeController>();
  int page = 1;
  bool pagination = false;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = new ScrollController()..addListener(_scrollListener);
    Future.delayed(Duration(seconds: 0), () {
      Provider.of<FeedProvider>(context, listen: false).getStories(page,pagination);
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener(){
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels != 0) {
          Future.delayed(Duration.zero,(){
            page += 1;
            pagination = true;
            print('scrolled to bottom page is now $page');
            Provider.of<FeedProvider>(context, listen: false).getStories(page,pagination);
          });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Expanded(
            child: Consumer<FeedProvider>(
              builder: (ctx, FeedProvider, _) {
                print("done");
                if (1==1){//!FeedProvider.getStoriesLoader
                  return SizedBox(
                    height: 110,
                    child: ListView.builder(
                      controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        itemCount: FeedProvider.getStoryList.length+1,
                        padding: EdgeInsets.fromLTRB(5, 12, 12, 0),
                        itemBuilder: (context, index) {
                          Result data;
                          if(index!=0){
                            data = FeedProvider.getStoryList[index-1];
                          }
                          return index==0?
                          InkWell(
                            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateStory())),
                            child: Container(
                                child: Column(
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          height: 64,
                                          width: 64,
                                          decoration: BoxDecoration(
                                            color: themeController.isDarkMode ? MateColors.darkDivider : MateColors.lightDivider,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.add,
                                            color: MateColors.activeIcons,
                                            size: 25,
                                          ),
                                        ),
                                        Positioned(
                                          right: 0,
                                          bottom: 0,
                                          child: Selector<AuthUserProvider, String>(
                                              selector: (ctx, authUserProvider) =>
                                              authUserProvider.authUserPhoto,
                                              builder: (ctx, data, _) {
                                                return Padding(
                                                  padding: EdgeInsets.only(left: 12.0.sp),
                                                  child: InkWell(
                                                      onTap: () {
                                                        Scaffold.of(ctx).openDrawer();
                                                      },
                                                      child: CircleAvatar(
                                                        backgroundColor: MateColors.activeIcons,
                                                        radius: 10,
                                                        child: CircleAvatar(
                                                          backgroundColor: Colors.transparent,
                                                          radius: 10,
                                                          backgroundImage: NetworkImage(data),
                                                          // child: ClipOval(
                                                          //     child: Image.network(
                                                          //       data,
                                                          //     )
                                                          // ),
                                                        ),
                                                      )),
                                                );
                                              }),
                                        ),
                                      ],
                                    ),
                                    //Image.asset("lib/asset/homePageIcons/create_story@3x.png",width: 40.0.sp,fit: BoxFit.fitWidth,),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Add",
                                        style: TextStyle(
                                            color: themeController.isDarkMode
                                                ? Colors.white
                                                : MateColors.blackTextColor,
                                            fontSize: 12.0,
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.w400),
                                      ),
                                    )
                                  ],
                                )),
                          ):
                          InkWell(
                            onTap: () =>Get.to(PageViewForStory(storyList: FeedProvider.getStoryList,indexValue: index-1,page: page,)),
                                // Navigator.of(context).push(MaterialPageRoute(
                                //     builder: (context) =>
                                //     PageViewForStory(storyList: FeedProvider.getStoryList,indexValue: index-1,page: page,))),
                                      //   StoryPreviewScreen(
                                      //     picUrl: data.media[0],
                                      //     displayName: "${data.user.displayName.split(" ").first}",
                                      //     message: data.text,
                                      //     displayPic: data.user.profilePhoto,
                                      // created: "${DateFormat.yMMMMEEEEd().format(DateFormat("yyyy-MM-dd").parse(data.createdAt, true))}",
                                      //   ))),
                            child: data.media.length != 0
                                ? Padding(
                                    padding: const EdgeInsets.only(left: 15.0),
                                    child: Column(
                                      children: [
                                        ClipOval(
                                          child: Image.network(
                                            data.user.profilePhoto,
                                            height: 60,
                                            width: 60,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Text(
                                            "${data.user.displayName.split(" ").first}",
                                            style: TextStyle(
                                                color: themeController
                                                        .isDarkMode
                                                    ? Colors.white
                                                    : MateColors.blackTextColor,
                                                fontSize: 12.0,
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : ClipOval(
                                    child: Image.asset(
                                      "lib/asset/logo.png",
                                      height: 40,
                                      width: 40,
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                          );
                        }),
                  );
                }
                if (FeedProvider.error != '') {
                  return Center(
                      child: Container(
                          color: Colors.red,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '${FeedProvider.error}',
                              style: TextStyle(color: Colors.white),
                            ),
                          )));
                }
                if (FeedProvider.getStoriesLoader) {
                  return SizedBox(
                    height: 0,
                    // child: CircularProgressIndicator()
                  );
                }
                return Container();
              },
            ),
          )
        ],
      ),
    );
  }
}
