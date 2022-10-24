import 'package:mate_app/asset/Colors/MateColors.dart';
import 'package:mate_app/Widget/Home/Group/GroupRow.dart';
import 'package:flutter/material.dart';

class GroupScreen extends StatefulWidget {
  static final String groupScreenRoute = '/group';

  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text("My Study Groups",
                  style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.w700,
                      color: MateColors.activeIcons)),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  style: TextStyle(color: Colors.white, fontSize: 13.0),
                  cursorColor: Colors.cyanAccent,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey[50],
                      size: 16,
                    ),
                    labelText: "Search",
                    contentPadding: EdgeInsets.symmetric(vertical: -5),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 0.3),
                      borderRadius: BorderRadius.circular(15.0),
                    ),

                    labelStyle: TextStyle(color: Colors.white, fontSize: 16),
                    // fillColor: MateColors.activeIcons,

                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 0.3),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
              ),
              IconButton(
                  icon: Icon(
                    Icons.bookmark_border,
                    color: Colors.grey[50],
                    size: 25,
                  ),
                  onPressed: () {}),
            ],
          ),
        ),
        Expanded(
            child: ListView.builder(
                itemCount: 3, itemBuilder: (ctx, index) => GroupRow())),
      ],
    );
  }
}
