import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:mate_app/asset/Colors/MateColors.dart';
import 'package:mate_app/groupChat/services/database_service.dart';
import 'package:flutter/material.dart';
import '../../constant.dart';
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
                  bottom: 16,
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
                child: Padding(
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
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins',
                              color: themeController.isDarkMode?Colors.white: Colors.black,
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: descText,
                          decoration: _customInputDecoration(labelText: 'Add group description', icon: Icons.perm_identity),
                          cursorColor: themeController.isDarkMode?MateColors.helpingTextDark:MateColors.helpingTextLight,
                          style:  TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.1,
                            color: themeController.isDarkMode?Colors.white:Colors.black,
                          ),
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
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins',
                              color: themeController.isDarkMode?Colors.white: Colors.black,
                            ),
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
                          DatabaseService().updateGroupDescription(widget.groupId, descText.text,_user.displayName,_user.photoURL);
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

  InputDecoration _customInputDecoration({@required String labelText, IconData icon}) {
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
