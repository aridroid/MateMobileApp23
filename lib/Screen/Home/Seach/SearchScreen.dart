import 'package:mate_app/asset/Colors/MateColors.dart';
import 'package:mate_app/Providers/FeedProvider.dart';
import 'package:mate_app/Screen/Home/Seach/feedSearchBar.dart';
import 'package:mate_app/Screen/Home/TimeLine/TimeLine.dart';
import 'package:mate_app/Screen/Profile/FollowingScreen.dart';
import 'package:mate_app/Widget/Loaders/Shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../chat1/screens/allUsersScreen.dart';

class SearchScreen extends StatefulWidget {
  static final String searchScreenRoute = '/search';
  final String feedTypeName;

  const SearchScreen({Key? key, this.feedTypeName = ""}) : super(key: key);
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  List<Widget> _containers = [];
  List<Tab> _tabList = [];

  bool _isFetching = true;

  @override
  void initState() {
    print('init state called in search screen');
    _tabList.add(Tab(text: "Following"));
    _containers.add(_tabBarViewWithSearch(isFollowingFeeds: true,));
    super.initState();
    Future.delayed(Duration(seconds: 0), () {
      var fp = Provider.of<FeedProvider>(context, listen: false);

      fp.fetchFeedTypes().then((_) {
        _tabController =
            TabController(length: fp.feedTypeList.length+1, vsync: this);
        int tabIndex=0;
        for (int i = 0; i < fp.feedTypeList.length; i++) {
          if(fp.feedTypeList[i].name==widget.feedTypeName) tabIndex=i+1;
          _tabList.add(Tab(
            text: fp.feedTypeList[i].name,
          ));
          _containers.add(_tabBarViewWithSearch(id: fp.feedTypeList[i].id!));
        }

        setState(() { _isFetching = !_isFetching;
        _tabController.animateTo(tabIndex);
        });
      });
    });
    print('in search screen');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('didchange dpend called');
  }

  @override
  void dispose() {
    _tabController.dispose();
    print('dispose called');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isFetching) {
      return tabHeadingLoader();
    } else {
      return Scaffold(
        body: Container(
          width: double.infinity,
          child: Column(
            children: [
              Consumer<FeedProvider>(
                builder: (ctx, feedProvider, _) {
                  if(feedProvider.error != ''){
                    return Center(child: Container(
                        color: Colors.red,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('${feedProvider.error}', style: TextStyle(color: Colors.white),),
                        )));
                  }

                  return TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: MateColors.activeIcons,
                    labelStyle: TextStyle(fontSize: 14.0),
                    onTap: (int index) {
                      print('on tap called');
                      //feedProvider.fetchFeedList(page: 1, feedId: feedProvider.feedTypeList[index].id.toString());
                    },
                    tabs: _tabList,
                  );
                },
              ),
              Expanded(
                child:
                    TabBarView(controller: _tabController, children: _containers),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _tabBarViewWithSearch({String? id, bool? isFollowingFeeds}){
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  readOnly: true,
                  onTap: ()=> Get.to(()=> _tabController.index==0?FeedSearchBar(isFollowingFeeds: true,):FeedSearchBar()),
                  style: TextStyle(color: Colors.white, fontSize: 14.0),
                  cursorColor: Colors.cyanAccent,
                  // controller: searchEditingController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey[50],
                      size: 16,
                    ),
                    labelText: "Search",
                    contentPadding: EdgeInsets.symmetric(vertical: -5),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey, width: 0.3),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    labelStyle: TextStyle(color: Colors.white, fontSize: 12.0.sp),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey, width: 0.3),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
              ),
              IconButton(
                  icon: Icon(
                    Icons.person_search,
                    color: Colors.grey[50],
                    size: 20.0.sp,
                  ),
                  onPressed: () => Get.to(() => AllUsersScreen())
              ),
            ],
          ),
        ),
        Expanded(
          child: TimeLine(id: id!, isFollowingFeeds: isFollowingFeeds!,),
        ),
      ],
    );
  }
}
