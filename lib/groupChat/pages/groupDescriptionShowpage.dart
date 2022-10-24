import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mate_app/controller/theme_controller.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../asset/Colors/MateColors.dart';
import 'groupDescriptionPage.dart';


class GroupDescriptionShowPage extends StatefulWidget {
  final String description;
  final String groupId;
  final String descriptionCreatorName;
  final String descriptionCreatorImage;
  final int descriptionCreationTime;
  const GroupDescriptionShowPage({Key key,this.groupId,this.description, this.descriptionCreatorName, this.descriptionCreatorImage, this.descriptionCreationTime,}) : super(key: key);

  @override
  _GroupDescriptionShowPageState createState() => _GroupDescriptionShowPageState();
}

class _GroupDescriptionShowPageState extends State<GroupDescriptionShowPage> {
  ThemeController themeController = Get.find<ThemeController>();
  @override
  Widget build(BuildContext context) {

    String date;

    var dateTimeNowToday = DateTime.now();
    List<String> splitToday = dateTimeNowToday.toString().split(" ");
    DateTime dateParsedToday = DateTime.parse(splitToday[0]);
    String dateFormattedToday = DateFormat('dd MMMM yyyy').format(dateParsedToday);

    var dateTimeNowYesterday = DateTime.now().subtract(const Duration(days:1));
    List<String> splitYesterday = dateTimeNowYesterday.toString().split(" ");
    DateTime dateParsedYesterday = DateTime.parse(splitYesterday[0]);
    String dateFormattedYesterday = DateFormat('dd MMMM yyyy').format(dateParsedYesterday);

    DateTime dateFormat = new DateTime.fromMillisecondsSinceEpoch(int.parse(widget.descriptionCreationTime.toString()));
    String dateFormatted = DateFormat('dd MMMM yyyy').format(dateFormat);
    if(dateFormatted == dateFormattedToday){
      date = "Today";
    }else if(dateFormatted == dateFormattedYesterday){
      date = "Yesterday";
    }else{
      date = dateFormatted;
    }


    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(width: 1, color: themeController.isDarkMode?MateColors.darkDivider:MateColors.lightDivider),
          ),),
        width: double.infinity,
        height: 50,
        child: TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => GroupDescriptionPage(
              groupId: widget.groupId,
              description: widget.description ?? "",
            )));
          },
          child: Text("Update",
            style: TextStyle(
              color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
              fontWeight: FontWeight.w500,
              fontSize: 17.0,
            ),
          ),
        ),
      ),
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        iconTheme: IconThemeData(
          color: MateColors.activeIcons,
        ),
        title: Text("Community Description",
          style: TextStyle(
            color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
            fontWeight: FontWeight.w700,
            fontSize: 17.0,
          ),
        ),
      ),
      body: ListView(
        physics: ScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 0,vertical: 0),
        children: [
          if(widget.descriptionCreatorName!="")
          ListTile(
            dense: true,
            horizontalTitleGap: 5,
            leading: CircleAvatar(
              radius: 16,
              backgroundColor: MateColors.activeIcons,
              backgroundImage: NetworkImage(widget.descriptionCreatorImage),
            ),
            title: Text(
              widget.descriptionCreatorName,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.1,
                color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
              ),
            ),
            subtitle: Text(
              date,
              style: TextStyle(
                fontSize: 12,
                color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16,vertical: 16),
            child: Linkify(
              onOpen: (link) async {
                if (await canLaunch(link.url)) {
                  await launch(link.url);
                } else {
                  throw 'Could not launch $link';
                }
              },
              options: LinkifyOptions(humanize: false),
              text: widget.description,
              style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w500, color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor),
            ),
          )
        ],
      ),
    );
  }
}
