import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:mate_app/Utility/Utility.dart';
import 'package:mate_app/Widget/Loaders/Shimmer.dart';
import 'package:mate_app/groupChat/pages/customAlertDialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../asset/Colors/MateColors.dart';

class PersonMessageTile extends StatelessWidget {
  final String message;
  final String sender;
  final bool sentByMe;
  final String messageTime;
  final bool isImage;
  final bool isFile;
  final String fileExtension;
  final String fileName;
  final String fileSize;
  final String fileSizeUnit;
  final int index;
  final List<String> date;
  final List<String> time;
  final bool isForwarded;

  PersonMessageTile({this.isForwarded,this.message, this.sender, this.sentByMe, this.messageTime, this.isImage = false, this.isFile = false, this.fileExtension, this.fileName, this.fileSize, this.fileSizeUnit, this.index, this.date, this.time});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: sentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        index == 0?
        Padding(
          padding: const EdgeInsets.only(left: 16,right: 16,top: 35,bottom: 16),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 1,
                  color: themeController.isDarkMode?MateColors.darkDivider:MateColors.lightDivider,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20,right: 20),
                child: Text(
                  date[index],
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: "Poppins",
                    color: sentByMe?
                    themeController.isDarkMode? MateColors.subTitleTextDark: MateColors.subTitleTextLight:
                    themeController.isDarkMode? MateColors.subTitleTextDark: MateColors.subTitleTextLight,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 1,
                  color: themeController.isDarkMode?MateColors.darkDivider:MateColors.lightDivider,
                ),
              ),
            ],
          ),
        ):
        date[index] != date[index-1]?
        Padding(
          padding: const EdgeInsets.only(left: 16,right: 16,top: 35,bottom: 16),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 1,
                  color: themeController.isDarkMode?MateColors.darkDivider:MateColors.lightDivider,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20,right: 20),
                child: Text(
                  date[index],
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: "Poppins",
                    color: sentByMe?
                    themeController.isDarkMode? MateColors.subTitleTextDark: MateColors.subTitleTextLight:
                    themeController.isDarkMode? MateColors.subTitleTextDark: MateColors.subTitleTextLight,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 1,
                  color: themeController.isDarkMode?MateColors.darkDivider:MateColors.lightDivider,
                ),
              ),
            ],
          ),
        ):Offstage(),
        Container(
          padding: EdgeInsets.only(top: 4, bottom: 4, left: sentByMe ? 0 : 24, right: sentByMe ? 24 : 0),
          alignment: sentByMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: sentByMe ? EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.2,top: 10) : EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.2,top: 10),
            padding: EdgeInsets.only(top: isImage ? 15 : 15, bottom: 15, left: 20, right:20),
            decoration: BoxDecoration(
              borderRadius: sentByMe
                  ? BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20), bottomLeft: Radius.circular(20))
                  : BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
              color: sentByMe ? chatTealColor : themeController.isDarkMode? chatGreyColor: MateColors.lightDivider,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                isForwarded?
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                    Image.asset(
                      "lib/asset/icons/forward.png",
                      color: themeController.isDarkMode?
                      sentByMe?MateColors.blackTextColor : Colors.white:
                      sentByMe?
                      Colors.white :MateColors.blackTextColor,
                      height: 18,
                      width: 18,
                    ),
                    SizedBox(width: 5,),
                    Text("Forwarded",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.1,
                        color: sentByMe?
                        themeController.isDarkMode? MateColors.blackTextColor: Colors.white:
                        themeController.isDarkMode? Colors.white : MateColors.blackTextColor,
                      ),
                    ),
                  ]),
                ):SizedBox(),
                isImage ?
                _chatImage(message, context) :
                isFile ?
                _chatFile(message, context) :
                Linkify(
                  onOpen: (link) async {
                    print("Clicked ${link.url}!");
                    if (await canLaunch(link.url))
                      await launch(link.url);
                    else
                      throw "Could not launch ${link.url}";
                  },
                  text: message.trim(),
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.1,
                    color: sentByMe?
                    themeController.isDarkMode? MateColors.blackTextColor: Colors.white:
                    themeController.isDarkMode? Colors.white : MateColors.blackTextColor,
                  ),
                  textAlign: TextAlign.start,
                  linkStyle: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontSize: 14.0,letterSpacing: 0.1),
                ),
                // Text(message.trim(),
                //   textAlign: TextAlign.start,
                //   style: TextStyle(
                //     fontFamily: "Poppins",
                //     fontSize: 14.0,
                //     fontWeight: FontWeight.w400,
                //     letterSpacing: 0.1,
                //     color: sentByMe?
                //     themeController.isDarkMode? MateColors.blackTextColor: Colors.white:
                //     themeController.isDarkMode? Colors.white : MateColors.blackTextColor,
                //   ),
                // ),
              ],
            ),
          ),
        ),
        isFile ?
        Padding(
              //padding: EdgeInsets.only(right: sentByMe?24:0),
          padding: EdgeInsets.only(right: sentByMe?24:0,left: sentByMe?0:24,top: 5),
              child: Row(
                mainAxisAlignment: sentByMe? MainAxisAlignment.end :MainAxisAlignment.start,
          children: [
              Text(fileSize, textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: "Poppins",
                  color: sentByMe?
                  themeController.isDarkMode? MateColors.subTitleTextDark: MateColors.subTitleTextDark:
                  themeController.isDarkMode? MateColors.subTitleTextDark: MateColors.subTitleTextDark,
                ),
              ),
              Text(" " + fileSizeUnit, textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: "Poppins",
                  color: sentByMe?
                  themeController.isDarkMode? MateColors.subTitleTextDark: MateColors.subTitleTextDark:
                  themeController.isDarkMode? MateColors.subTitleTextDark: MateColors.subTitleTextDark,
                ),
              ),
              Text("  •  " + fileExtension.toUpperCase(),
                  textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: "Poppins",
                  color: sentByMe?
                  themeController.isDarkMode? MateColors.subTitleTextDark: MateColors.subTitleTextDark:
                  themeController.isDarkMode? MateColors.subTitleTextDark: MateColors.subTitleTextDark,
                ),
              ),
              //Spacer(),
              SizedBox(width: 10,),
              Text(
                date[index] == "Today" || date[index] == "Yesterday"?
                date[index] + " at " + time[index]:
                time[index],
                //DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(int.parse(messageTime))),
                  textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: "Poppins",
                  color: sentByMe?
                  themeController.isDarkMode? MateColors.subTitleTextDark: MateColors.subTitleTextDark:
                  themeController.isDarkMode? MateColors.subTitleTextDark: MateColors.subTitleTextDark,
                ),
              ),
          ],
        ),
            )
            : Padding(
              padding: EdgeInsets.only(right: sentByMe?24:0,left: sentByMe?0:24,top: 5),
              child: Align(
                alignment: sentByMe? Alignment.centerRight :Alignment.centerLeft,
          child: Text(
            date[index] == "Today" || date[index] == "Yesterday"?
            date[index] + " at " + time[index]:
            time[index],
            //DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(int.parse(messageTime))),
                textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 12,
                fontFamily: "Poppins",
                color: sentByMe?
                themeController.isDarkMode? MateColors.subTitleTextDark: MateColors.subTitleTextDark:
                themeController.isDarkMode? MateColors.subTitleTextDark: MateColors.subTitleTextDark,
              ),
          ),
        ),
            ),
      ],
    );
  }

  Widget _chatFile(String chatContent, BuildContext context) {
    return InkWell(
      onTap: () async {
        if (await canLaunch(chatContent)) {
          await launch(chatContent);
        } else {
          throw 'Could not launch $chatContent';
        }
        // OpenFile.open(chatContent);

      },
      child: Container(
        height: 50,
        // width: 200,
        clipBehavior: Clip.hardEdge,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.fromLTRB(9, 0, 9, 0),
        margin: EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          color: sentByMe ? myHexColor.withOpacity(0.1) : myHexColor.withOpacity(0.3),
        ),
        child: Text(fileName,
            maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.start, style: TextStyle(fontSize: 11.7.sp, color: sentByMe ? Colors.black : Colors.white, fontWeight: FontWeight.w500)),
      ),
    );
  }

  Widget _chatImage(String chatContent, BuildContext context) {
    return InkWell(
      onTap: () => showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => CustomDialog(
          backgroundColor: Colors.transparent,
          clipBehavior: Clip.hardEdge,
          insetPadding: EdgeInsets.all(0),
          child: Padding(
            padding: const EdgeInsets.all(00.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.8,
              child: InteractiveViewer(
                panEnabled: true,
                // Set it to false to prevent panning.
                boundaryMargin: EdgeInsets.all(50),
                minScale: 0.5,
                maxScale: 4,
                child: CachedNetworkImage(
                    imageUrl: chatContent,
                    height: 150,
                    width: 200,
                    placeholder: (context, url) => Center(child: SizedBox(width: 30, height: 30, child: CircularProgressIndicator())),
                    errorWidget: (context, url, error) => Icon(Icons.error)),
              ),
            ),
          ),
        ),
      ),
      child: Container(
        height: 150,
        width: 200,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12.0)), color: myHexColor),
        child: _widgetShowImages(chatContent),
      ),
    );
  }

  // Show Images from network
  Widget _widgetShowImages(
    String imageUrl,
  ) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      height: 150,
      width: 200,
      placeholder: (context, url) => Center(child: SizedBox(width: 30, height: 30, child: CircularProgressIndicator())),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
