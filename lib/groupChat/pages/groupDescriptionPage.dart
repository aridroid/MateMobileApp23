import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:mate_app/asset/Colors/MateColors.dart';
import 'package:mate_app/groupChat/services/database_service.dart';
import 'package:flutter/material.dart';
import '../../controller/theme_controller.dart';

class GroupDescriptionPage extends StatefulWidget {
  final String description;
  final String groupId;

  GroupDescriptionPage({Key key, this.description, this.groupId}) : super(key: key);

  @override
  _GroupDescriptionPageState createState() => _GroupDescriptionPageState();
}

class _GroupDescriptionPageState extends State<GroupDescriptionPage> {

  TextEditingController descText;
  ThemeController themeController = Get.find<ThemeController>();
  User _user;

  @override
  void initState(){
    _user = FirebaseAuth.instance.currentUser;
    super.initState();
    descText=new TextEditingController(text: widget.description);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
       behavior: HitTestBehavior.translucent,
          onTap: null,
          onPanUpdate: (details) {
            if (details.delta.dy > 0){
              FocusScope.of(context).requestFocus(FocusNode());
              print("Dragging in +Y direction");
            }
          },
      child: Scaffold(
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
                    DatabaseService().updateGroupDescription(widget.groupId, descText.text,_user.displayName,_user.photoURL);
                    Navigator.pop(context);
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
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 10.0),
                  child: Text(
                    "Description",
                    style: TextStyle(
                      color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 17.0,
                    ),
                  ),
                ),
                TextFormField(
                  controller: descText,
                  decoration: _customInputDecoration(labelText: 'Add group description', icon: Icons.perm_identity),
                  style: TextStyle(color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor),
                  cursorColor: MateColors.activeIcons,
                  textInputAction: TextInputAction.done,
                  minLines: 3,
                  maxLines: 10,
                  maxLength: 512,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 10.0),
                  child: Text(
                    "The group description is visible to all the participants of this group.",
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
