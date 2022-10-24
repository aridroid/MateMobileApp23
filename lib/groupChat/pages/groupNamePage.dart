import 'package:get/get.dart';
import 'package:mate_app/Screen/Home/HomeScreen.dart';
import 'package:mate_app/Utility/Utility.dart';
import 'package:mate_app/asset/Colors/MateColors.dart';
import 'package:mate_app/controller/theme_controller.dart';
import 'package:mate_app/groupChat/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


class GroupNamePage extends StatefulWidget {
  final String groupName;
  final String groupId;

  const GroupNamePage({Key key, this.groupName, this.groupId}) : super(key: key);

  @override
  _GroupNamePageState createState() => _GroupNamePageState();
}

class _GroupNamePageState extends State<GroupNamePage> {

  TextEditingController groupNameText;
  ThemeController themeController = Get.find<ThemeController>();

  @override
  void initState() {
    super.initState();
    groupNameText=new TextEditingController(text: widget.groupName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: myHexColor,
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
                  DatabaseService().updateGroupName(widget.groupId, groupNameText.text);
                  Navigator.pop(context);
                  // Navigator.of(context).pushAndRemoveUntil(
                  //     MaterialPageRoute(builder: (context) => HomeScreen(index: 3)),
                  //     ModalRoute.withName("/home"));
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
        //backgroundColor: myHexColor,
        elevation: 0,
        iconTheme: IconThemeData(
          color: MateColors.activeIcons,
        ),
        centerTitle: false,
        title: Text("Group Name",
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
                  "Name",
                  style: TextStyle(
                    color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 17.0,
                  ),
                ),
              ),
              TextFormField(
                controller: groupNameText,
                decoration: _customInputDecoration(labelText: 'Add group Name', icon: Icons.perm_identity),
                style: TextStyle(color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor),
                cursorColor: MateColors.activeIcons,
                //textInputAction: TextInputAction.newline,
                // minLines: 1,
                // maxLines: 5,
              ),
            ],
          ),
        ),
      ),

    );
  }

  InputDecoration _customInputDecoration({@required String labelText, IconData icon}) {
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
