import 'package:mate_app/asset/Colors/MateColors.dart';
import 'package:mate_app/Screen/Home/TimeLine/TimeLine.dart';
import 'package:mate_app/Utility/Utility.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class FeedSearchBar extends StatefulWidget {
  final bool isFollowingFeeds;

  const FeedSearchBar({Key key, this.isFollowingFeeds}) : super(key: key);

  @override
  _FeedSearchBarState createState() => _FeedSearchBarState();
}

class _FeedSearchBarState extends State<FeedSearchBar> {

  TextEditingController searchEditingController=new TextEditingController();
  FocusNode focusNode= FocusNode();
  String searchText ="";

  @override
  void initState() {
    focusNode.requestFocus();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myHexColor,
      appBar: AppBar(
        backgroundColor: myHexColor,
        title: Text('Search Feeds', style: TextStyle(fontSize: 16.0.sp, fontWeight: FontWeight.bold, color: MateColors.activeIcons)),
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                style: TextStyle(color: Colors.white, fontSize: 14.0),
                cursorColor: Colors.cyanAccent,
                controller: searchEditingController,
                focusNode: focusNode,
                onChanged: (value) {
                  searchText = value;
                  setState(() {});
                },
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
            Expanded(child: widget.isFollowingFeeds!=null?TimeLine(searchKeyword: searchText.trim(),isFollowingFeeds: widget.isFollowingFeeds,):TimeLine(searchKeyword: searchText.trim(),)),
          ],
        ),
      ),
    );
  }
}
