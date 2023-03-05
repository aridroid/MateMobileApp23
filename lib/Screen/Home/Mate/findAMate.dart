import 'package:mate_app/Model/findAMatePostsModel.dart';
import 'package:mate_app/Providers/findAMateProvider.dart';
import 'package:mate_app/Widget/Home/Mate/findAMateRow.dart';
import 'package:mate_app/Widget/Loaders/Shimmer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FindAMateScreen extends StatefulWidget {
  const FindAMateScreen({Key key}) : super(key: key);

  @override
  _FindAMateScreenState createState() => _FindAMateScreenState();
}

class _FindAMateScreenState extends State<FindAMateScreen> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: FindAMate()),
      ],
    );
  }
}

class FindAMate extends StatefulWidget {
  const FindAMate({Key key}) : super(key: key);

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
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
          );
        }
        return findAMateProvider.findAMatePostsDataList.length == 0 ?
        Center(
          child: Text(
            'Nothing new',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
              letterSpacing: 0.1,
              color: themeController.isDarkMode?Colors.white:Colors.black,
            ),
          ),
        ):
        RefreshIndicator(
          onRefresh: () {
            _page = 1;
            return findAMateProvider.fetchFindAMatePostList(page: 1);
          },
          child: ListView.builder(
            padding: EdgeInsets.zero,
            controller: _scrollController,
            shrinkWrap: true,
            itemCount: findAMateProvider.findAMatePostsDataList.length,
            itemBuilder: (context, index) {
              Result findAMateData = findAMateProvider.findAMatePostsDataList[index];
              return FindAMateRow(
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
              );
            },
          ),
        );
      },
    );
  }
}

