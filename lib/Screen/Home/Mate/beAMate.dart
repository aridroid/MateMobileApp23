import 'package:mate_app/Model/beAMatePostsModel.dart';
import 'package:mate_app/Providers/beAMateProvider.dart';
import 'package:mate_app/Widget/Home/Mate/beAMateRow.dart';
import 'package:mate_app/Widget/Loaders/Shimmer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BeAMateScreen extends StatefulWidget {
  const BeAMateScreen({Key? key}) : super(key: key);

  @override
  _BeAMateScreenState createState() => _BeAMateScreenState();
}

class _BeAMateScreenState extends State<BeAMateScreen> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: BeAMate()),
      ],
    );
  }
}


class BeAMate extends StatefulWidget {
  const BeAMate({Key? key}) : super(key: key);

  @override
  _BeAMateState createState() => _BeAMateState();
}

class _BeAMateState extends State<BeAMate> {
  late ScrollController _scrollController;
  late int _page;

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
              ),
            ),
          );
        }
        return beAMateProvider.beAMatePostsDataList.length == 0 ?
        Center(
          child: Text(
            'Nothing new',
            style: TextStyle(color: themeController.isDarkMode?Colors.white:Colors.black),
          ),
        ):
        RefreshIndicator(
          onRefresh: () {
            _page = 1;
            return beAMateProvider.fetchBeAMatePostList(page: 1);
          },
          child: ListView.builder(
            padding: EdgeInsets.zero,
            controller: _scrollController,
            shrinkWrap: true,
            itemCount: beAMateProvider.beAMatePostsDataList.length,
            itemBuilder: (context, index) {
              Result beAMateData = beAMateProvider.beAMatePostsDataList[index];
              return BeAMateRow(
                beAMateId: beAMateData.id!,
                description: beAMateData.description!,
                title: beAMateData.title!,
                portfolioLink: beAMateData.portfolioLink,
                fromDate: beAMateData.fromDate,
                toDate: beAMateData.toDate,
                fromTime: beAMateData.timeFrom,
                toTime: beAMateData.timeTo,
                user: beAMateData.user!,
                hyperlinkText: beAMateData.hyperLinkText,
                hyperlink: beAMateData.hyperLink,
                createdAt: "${DateFormat.yMMMEd().format(DateFormat("yyyy-MM-dd").parse(beAMateData.createdAt!, true))}",
                rowIndex: index,
                isActive: beAMateData.isActive!,
              );
            },
          ),
        );
      },
    );
  }
}

