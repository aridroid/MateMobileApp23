import 'package:mate_app/Model/beAMatePostsModel.dart';
import 'package:mate_app/Providers/beAMateProvider.dart';
import 'package:mate_app/Utility/Utility.dart';
import 'package:mate_app/Widget/Home/Mate/beAMateRow.dart';
import 'package:mate_app/Widget/Loaders/Shimmer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class BeAMateScreen extends StatefulWidget {
  const BeAMateScreen({Key key}) : super(key: key);
  @override
  _BeAMateScreenState createState() => _BeAMateScreenState();
}

class _BeAMateScreenState extends State<BeAMateScreen> {

  String searchText="";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: myHexColor,
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: MateColors.activeIcons,
      //   child: Icon(
      //     Icons.add,
      //     size: 28,
      //   ),
      //   elevation: 6,
      //   onPressed: () {
      //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateBeAMatePost()));
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
          //       labelText: "Be a mate search",
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
          Expanded(child: BeAMate(searchText: searchText,)),
        ],
      ),
    );
  }
}


class BeAMate extends StatefulWidget {
  final String searchText;

  const BeAMate({Key key, this.searchText}) : super(key: key);

  @override
  _BeAMateState createState() => _BeAMateState();
}

class _BeAMateState extends State<BeAMate> {

  ScrollController _scrollController;
  int _page;

  void _scrollListener() {
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels != 0) {
        Future.delayed(Duration.zero, () {
          _page += 1;
          print('scrolled to bottom page is now $_page');
          Provider.of<BeAMateProvider>(context, listen: false).fetchBeAMatePostList(page: _page);
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 0), () {
      Provider.of<BeAMateProvider>(context, listen: false).fetchBeAMatePostList(page: 1);
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
    return Consumer<BeAMateProvider>(
      builder: (ctx, beAMateProvider, _) {
        print("timline consumer is called");

        if (beAMateProvider.beAMatePostLoader && beAMateProvider.beAMatePostsDataList.length == 0) {
          return timelineLoader();
        }
        if (beAMateProvider.error != '') {
          return Center(
              child: Container(
                  color: Colors.red,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${beAMateProvider.error}',
                      style: TextStyle(color: Colors.white),
                    ),
                  )));
        }

        return beAMateProvider.beAMatePostsDataList.length == 0
            ? Center(
          child: Text(
            'Nothing new',
            style: TextStyle(color: themeController.isDarkMode?Colors.white:Colors.black),
          ),
        )
            : RefreshIndicator(
          onRefresh: () {
            _page = 1;
            return beAMateProvider.fetchBeAMatePostList(page: 1);
          },
          child: ListView.builder(
            controller: _scrollController,
            shrinkWrap: true,
            itemCount: beAMateProvider.beAMatePostsDataList.length,
            itemBuilder: (context, index) {
              Result beAMateData = beAMateProvider.beAMatePostsDataList[index];
              return Visibility(
                visible: widget.searchText.isNotEmpty? beAMateData.title.toLowerCase().contains(widget.searchText.trim().toLowerCase()): true,
                child: BeAMateRow(
                  beAMateId: beAMateData.id,
                  description: beAMateData.description,
                  title: beAMateData.title,
                  portfolioLink: beAMateData.portfolioLink,
                  fromDate: beAMateData.fromDate,
                  toDate: beAMateData.toDate,
                  fromTime: beAMateData.timeFrom,
                  toTime: beAMateData.timeTo,
                  user: beAMateData.user,
                  hyperlinkText: beAMateData.hyperLinkText,
                  hyperlink: beAMateData.hyperLink,
                  createdAt: "${DateFormat.yMMMEd().format(DateFormat("yyyy-MM-dd").parse(beAMateData.createdAt, true))}",
                  rowIndex: index,
                  isActive: beAMateData.isActive,
                ),
              );
            },
          ),
        );
      },
    );
  }
}

