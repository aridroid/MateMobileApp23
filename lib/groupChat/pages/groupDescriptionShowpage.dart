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
                    "Community Description",
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
              child: ListView(
                physics: ScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 0,vertical: 16),
                children: [
                  if(widget.descriptionCreatorName!="")
                  ListTile(
                    dense: true,
                    horizontalTitleGap: 15,
                    leading: CircleAvatar(
                      radius: 22,
                      backgroundColor: MateColors.activeIcons,
                      backgroundImage: NetworkImage(widget.descriptionCreatorImage),
                    ),
                    title: Text(
                      widget.descriptionCreatorName,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Poppins",
                        color: themeController.isDarkMode?Colors.white:Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      date,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Poppins",
                        color: themeController.isDarkMode?Colors.white.withOpacity(0.5):Colors.black.withOpacity(0.5),
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
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Poppins",
                        color: themeController.isDarkMode?Colors.white:Colors.black,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: scW,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: themeController.isDarkMode?MateColors.dividerDark:MateColors.dividerLight,
                ),
              ),
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
          ],
        ),
      ),
    );
  }
}
