import 'package:mate_app/Model/findAMatePostsModel.dart';
import 'package:mate_app/Providers/findAMateProvider.dart';
import 'package:mate_app/Widget/Home/Mate/findAMateRow.dart';
import 'package:mate_app/Widget/Loaders/Shimmer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../Utility/Utility.dart';

class FindAMateScreen extends StatefulWidget {
  const FindAMateScreen({Key key}) : super(key: key);

  @override
  _FindAMateScreenState createState() => _FindAMateScreenState();
}

class _FindAMateScreenState extends State<FindAMateScreen> {

  String searchText="";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: myHexColor,
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: MateColors.activeIcons,
      //   child: Icon(
      //     Icons.add,
      //     size: 28,
      //   ),
      //   elevation: 6,
      //   onPressed: () {
      //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateFindAMatePost()));
      //   },
      // ),
      body: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(12.0),
          //   child: TextFormField(
          //     style: TextStyle(color: Colors.white, fontSize: 12.5.sp),
          //     cursorColor: Colors.cyanAccent,
          //     onChanged: (value) {
          //       searchText = value;
          //       setState(() {});
          //     },
          //     decoration: InputDecoration(
          //       prefixIcon: Icon(
          //         Icons.search,
          //         color: Colors.grey[50],
          //         size: 16,
          //       ),
          //       labelText: "Find a mate Search",
          //       contentPadding: EdgeInsets.symmetric(vertical: -5),
          //       enabledBorder: OutlineInputBorder(
          //         borderSide: const BorderSide(color: Colors.grey, width: 0.3),
          //         borderRadius: BorderRadius.circular(15.0),
          //       ),
          //       labelStyle: TextStyle(color: Colors.white, fontSize: 12.0.sp),
          //       focusedBorder: OutlineInputBorder(
          //         borderSide: const BorderSide(color: Colors.grey, width: 0.3),
          //         borderRadius: BorderRadius.circular(15.0),
          //       ),
          //     ),
          //   ),
          // ),
          Expanded(child: FindAMate(searchText: searchText,)),
        ],
      ),
    );
  }
}

class FindAMate extends StatefulWidget {
  final String searchText;

  const FindAMate({Key key, this.searchText}) : super(key: key);


  @override
  _FindAMateState createState() => _FindAMateState();
}

class _FindAMateState extends State<FindAMate> {

  ScrollController _scrollController;
  int _page;


  void _scrollListener() {
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels != 0) {
        Future.delayed(Duration.zero, () {
          _page += 1;
          print('scrolled to bottom page is now $_page');
          Provider.of<FindAMateProvider>(context, listen: false).fetchFindAMatePostList(page: _page);
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 0), () {
      Provider.of<FindAMateProvider>(context, listen: false).fetchFindAMatePostList(page: 1);
    });
    _page = 1;
    _scrollController = new ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FindAMateProvider>(
      builder: (ctx, findAMateProvider, _) {
        print("timline consumer is called");

        if (findAMateProvider.findAMatePostLoader && findAMateProvider.findAMatePostsDataList.length == 0) {
          return timelineLoader();
        }
        if (findAMateProvider.error != '') {
          return Center(
              child: Container(
                  color: Colors.red,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${findAMateProvider.error}',
                      style: TextStyle(color: Colors.white),
                    ),
                  )));
        }

        return findAMateProvider.findAMatePostsDataList.length == 0
            ? Center(
          child: Text(
            'Nothing new',
            style: TextStyle(color: themeController.isDarkMode?Colors.white:Colors.black),
          ),
        )
            : RefreshIndicator(
          onRefresh: () {
            _page = 1;
            return findAMateProvider.fetchFindAMatePostList(page: 1);
          },
          child: ListView.builder(
            controller: _scrollController,
            shrinkWrap: true,
            itemCount: findAMateProvider.findAMatePostsDataList.length,
            itemBuilder: (context, index) {
              Result findAMateData = findAMateProvider.findAMatePostsDataList[index];
              return Visibility(
                visible: widget.searchText.isNotEmpty? findAMateData.title.toLowerCase().contains(widget.searchText.trim().toLowerCase()): true,
                child: FindAMateRow(
                  findAMateId: findAMateData.id,
                  description: findAMateData.description,
                  title: findAMateData.title,
                  fromDate: findAMateData.fromDate,
                  toDate: findAMateData.toDate,
                  fromTime: findAMateData.timeFrom,
                  toTime: findAMateData.timeTo,
                  hyperlinkText: findAMateData.hyperLinkText,
                  hyperlink: findAMateData.hyperLink,
                  user: findAMateData.user,
                  createdAt: "${DateFormat.yMMMEd().format(DateFormat("yyyy-MM-dd").parse(findAMateData.createdAt, true))}",
                  rowIndex: index,
                  isActive: findAMateData.isActive,
                ),
              );
            },
          ),
        );
      },
    );
  }
}

