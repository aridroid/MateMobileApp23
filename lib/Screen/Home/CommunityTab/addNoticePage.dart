import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../asset/Colors/MateColors.dart';
import '../../../controller/theme_controller.dart';
import '../../../groupChat/services/database_service.dart';


class AddNoticePage extends StatefulWidget {
  final String groupId;
  final String notice;
  const AddNoticePage({Key? key,required this.groupId,required this.notice}) : super(key: key);

  @override
  _AddNoticePageState createState() => _AddNoticePageState();
}

class _AddNoticePageState extends State<AddNoticePage> {
  late TextEditingController descText;
  ThemeController themeController = Get.find<ThemeController>();


  @override
  void initState() {
    super.initState();
    descText = new TextEditingController(text: widget.notice);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(width: 1, color: themeController.isDarkMode?MateColors.darkDivider:MateColors.lightDivider),
          ),),
        width: double.infinity,
        height: 50,
        child: Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel",
                  style: TextStyle(
                    color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 17.0,
                  ),
                ),
              ),
            ),
            VerticalDivider(
              color: themeController.isDarkMode?MateColors.darkDivider:MateColors.lightDivider,
              width: 1,
              thickness: 1,
            ),
            Expanded(
              child: TextButton(
                onPressed: () {
                  if(descText.text.length>0){
                    DatabaseService().updateNotice(widget.groupId, descText.text);
                    Navigator.pop(context);
                  }else{
                    Fluttertoast.showToast(msg: "Please write something", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
                  }
                },
                child: Text("Save",
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
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        iconTheme: IconThemeData(
          color: MateColors.activeIcons,
        ),
        title: Text("Group Notice",
          style: TextStyle(
            color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
            fontWeight: FontWeight.w700,
            fontSize: 17.0,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 10.0),
                child: Text(
                  "Notice",
                  style: TextStyle(
                    color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 17.0,
                  ),
                ),
              ),
              TextFormField(
                controller: descText,
                decoration: _customInputDecoration(labelText: 'Add group notice', icon: Icons.perm_identity),
                style: TextStyle(color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor),
                cursorColor: MateColors.activeIcons,
                textInputAction: TextInputAction.done,
                minLines: 3,
                maxLines: 10,
                //maxLength: 512,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 10.0),
                child: Text(
                  "The group notice is visible to all the participants of this group.",
                  style: TextStyle(
                    color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 14.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }

  InputDecoration _customInputDecoration({required String labelText, IconData? icon}) {
    return InputDecoration(
      hintStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.1,
        color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
      ),
      hintText: labelText,
      counterStyle:  TextStyle(
        color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
        fontWeight: FontWeight.w500,
        fontSize: 12.0,
      ),
      fillColor: themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightButtonBackground,
      filled: true,
      focusedBorder: OutlineInputBorder(
        borderSide:  BorderSide(
          color: themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightButtonBackground,
        ),
        borderRadius: BorderRadius.circular(26.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide:  BorderSide(
          color:  themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightButtonBackground,
        ),
        borderRadius: BorderRadius.circular(26.0),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide:  BorderSide(
          color: themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightButtonBackground,
        ),
        borderRadius: BorderRadius.circular(26.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide:  BorderSide(
          color: themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightButtonBackground,
        ),
        borderRadius: BorderRadius.circular(26.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide:  BorderSide(
          color: themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightButtonBackground,
        ),
        borderRadius: BorderRadius.circular(26.0),
      ),
    );
  }
}
