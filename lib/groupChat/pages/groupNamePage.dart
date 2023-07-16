import 'package:get/get.dart';
import 'package:mate_app/asset/Colors/MateColors.dart';
import 'package:mate_app/controller/theme_controller.dart';
import 'package:mate_app/groupChat/services/database_service.dart';
import 'package:flutter/material.dart';

import '../../constant.dart';

class GroupNamePage extends StatefulWidget {
  final String groupName;
  final String groupId;
  const GroupNamePage({Key? key, required this.groupName, required this.groupId}) : super(key: key);

  @override
  _GroupNamePageState createState() => _GroupNamePageState();
}

class _GroupNamePageState extends State<GroupNamePage> {
  TextEditingController? groupNameText;
  ThemeController themeController = Get.find<ThemeController>();

  @override
  void initState() {
    super.initState();
    groupNameText=new TextEditingController(text: widget.groupName);
  }

  @override
  Widget build(BuildContext context) {
    final scH = MediaQuery.of(context).size.height;
    final scW = MediaQuery.of(context).size.width;
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
                      "Group Name",
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
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SingleChildScrollView(
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 10.0),
                          child: Text(
                            "Name",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins',
                              color: themeController.isDarkMode?Colors.white: Colors.black,
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: groupNameText,
                          decoration: _customInputDecoration(labelText: 'Add group Name', icon: Icons.perm_identity),
                          cursorColor: themeController.isDarkMode?MateColors.helpingTextDark:MateColors.helpingTextLight,
                          style:  TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.1,
                            color: themeController.isDarkMode?Colors.white:Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: themeController.isDarkMode?MateColors.dividerDark:MateColors.dividerLight,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Cancel",
                          style: TextStyle(
                            color: themeController.isDarkMode?Colors.white:MateColors.blackText,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                            fontSize: 17.0,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 1,
                      color: themeController.isDarkMode?MateColors.dividerDark:MateColors.dividerLight,
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          DatabaseService().updateGroupName(widget.groupId, groupNameText!.text);
                          Navigator.pop(context);
                        },
                        child: Text("Save",
                          style: TextStyle(
                            color: themeController.isDarkMode?Colors.white:MateColors.blackText,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                            fontSize: 17.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

      ),
    );
  }

  InputDecoration _customInputDecoration({required String labelText, required IconData icon}) {
    return InputDecoration(
      hintStyle: TextStyle(
        fontSize: 16,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w400,
        color: themeController.isDarkMode?MateColors.helpingTextDark:MateColors.helpingTextLight,
      ),
      hintText: labelText,
      counterStyle:  TextStyle(
        color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
        fontWeight: FontWeight.w500,
        fontSize: 12.0,
      ),
      fillColor: themeController.isDarkMode ? MateColors.containerDark : MateColors.containerLight,
      filled: true,
      focusedBorder: commonBorder,
      enabledBorder: commonBorder,
      disabledBorder: commonBorder,
      errorBorder: commonBorder,
      focusedErrorBorder: commonBorder,
    );
  }
}
