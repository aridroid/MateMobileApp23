import 'package:get/get.dart';
import 'package:mate_app/Providers/campusTalkProvider.dart';
import 'package:mate_app/Widget/loader.dart';
import 'package:mate_app/asset/Colors/MateColors.dart';
import 'package:flutter/material.dart';
import 'package:mate_app/controller/theme_controller.dart';
import 'package:provider/provider.dart';

class EditCampusTalk extends StatefulWidget {
  final String title,description,anonymousUser;
  final int id,isAnonymous;
  const EditCampusTalk({Key key, this.title, this.description, this.anonymousUser, this.isAnonymous, this.id}) : super(key: key);

  @override
  State<EditCampusTalk> createState() => _EditCampusTalkState();
}

class _EditCampusTalkState extends State<EditCampusTalk> {
  final _formKey = GlobalKey<FormState>();
  FocusNode focusNode= FocusNode();

  String _description;
  String _title;
  String anonymousUser;
  bool isAnonymous=false;
  bool isToggleAvailable = true;
  ThemeController themeController = Get.find<ThemeController>();
  int titleLength = 0;
  int descriptionLength = 0;
  bool isLoading = false;
  int _id;

  @override
  void initState() {
    _id = widget.id;
    _title = widget.title;
    _description = widget.description;
    isAnonymous = widget.isAnonymous==1?true:false;
    isToggleAvailable = !isAnonymous;
    anonymousUser = widget.anonymousUser??"";
    print(_title);
    print(_description);
    print(isAnonymous);
    print(anonymousUser);
    setState(() {

    });
    // TODO: implement initState
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
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: null,
      onPanUpdate: (details) {
        if (details.delta.dy > 0){
          FocusScope.of(context).requestFocus(FocusNode());
          print("Dragging in +Y direction");
        }
      },
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              elevation: 0,
              iconTheme: IconThemeData(
                color: MateColors.activeIcons,
              ),
              centerTitle: true,
              title: Text(
                'Create New Discussion',
                style: TextStyle(
                  color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 17.0,
                ),
              ),
            ),
            body: Form(
              key: _formKey,
              child: ListView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                shrinkWrap: true,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 15.0, 3.0, 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Title",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.1,
                            color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                          ),
                        ),
                        Text(
                          "$titleLength/50",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.1,
                            color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextFormField(
                    initialValue: _title,
                    decoration: _customInputDecoration(labelText: 'Title', icon: Icons.perm_identity),
                    style:  TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.1,
                      color: themeController.isDarkMode?Colors.white:Colors.black,
                    ),
                    cursorColor: MateColors.activeIcons,
                    textInputAction: TextInputAction.next,
                    maxLength: 50,
                    focusNode: focusNode,
                    onChanged: (value){
                      _title = value;
                      titleLength = value.length;
                      setState(() {});
                    },
                    onFieldSubmitted: (val) {
                      print('onFieldSubmitted :: Title = $val');
                    },
                    onSaved: (value) {
                      print('onSaved Title = $value');
                      _title = value;
                    },
                    validator: (value) {
                      if(value.isEmpty){
                        return "Please Enter Title";
                      }else
                        return null;
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 15.0, 3.0, 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Description",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.1,
                            color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                          ),
                        ),
                        Text(
                          "$descriptionLength/512",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.1,
                            color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextFormField(
                    initialValue: _description,
                    decoration: _customInputDecoration(labelText: 'What\'s on your mind?', icon: Icons.perm_identity),
                    style:  TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.1,
                      color: themeController.isDarkMode?Colors.white:Colors.black,
                    ),
                    cursorColor: MateColors.activeIcons,
                    textInputAction: TextInputAction.done,
                    minLines: 3,
                    maxLines: 6,
                    maxLength: 512,
                    onChanged: (value){
                      _description = value;
                      descriptionLength = value.length;
                      setState(() {});
                    },
                    onFieldSubmitted: (val) {
                      print('onFieldSubmitted :: description = $val');
                    },
                    onSaved: (value) {
                      print('onSaved lastName = $value');
                      _description = value;
                    },
                    validator: (value) {
                      if(value.isEmpty){
                        return "Please Type Description";
                      }else
                        return null;
                    },
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: 160,
                      child: CheckboxListTile(
                        dense: true,
                        side: BorderSide(color: themeController.isDarkMode?Colors.white:Colors.black),
                        activeColor: MateColors.activeIcons,
                        checkColor: Colors.black,
                        contentPadding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                        title: Text(
                          "Anonymous",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.1,
                            color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                          ),
                        ),
                        value: isAnonymous,
                        onChanged: (newValue) {
                          if(isToggleAvailable){
                            isAnonymous=newValue;
                            setState(() {});
                          }
                        },
                        controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
                      ),
                    ),
                  ),
                  _submitButton(context),
                ],
              ),
            ),
          ),
          Visibility(
            visible: isLoading,
            child: Loader(),
          ),
        ],
      ),
    );
  }

  Consumer<CampusTalkProvider> _submitButton(BuildContext context) {
    return Consumer<CampusTalkProvider>(
      builder: (ctx, campusTalkProvider, _) {
        return Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Container(
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: MateColors.activeIcons,
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(
                'Update',
                style: TextStyle(
                  color: themeController.isDarkMode?MateColors.blackTextColor:Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 17.0,
                ),
              ),
              onPressed: () {
                if(_formKey.currentState.validate()) _submitForm(context);
              },
            ),
          ),
        );
      },
    );
  }

  void _submitForm(BuildContext context) async {
    FocusScope.of(context).unfocus();
    bool validated = _formKey.currentState.validate();

    if (validated) {
      setState(() {
        isLoading = true;
      });
      _formKey.currentState.save(); //it will trigger a onSaved(){} method on all TextEditingController();
      print('hgfhfhgfghfhgfghf');
      print(anonymousUser);
      bool posted= await Provider.of<CampusTalkProvider>(context, listen: false).updateACampusTalkPost(_id,_title, _description, isAnonymous,isToggleAvailable==false?anonymousUser:null);
      setState(() {
        isLoading = false;
      });
      if(posted){
        Provider.of<CampusTalkProvider>(context, listen: false).fetchCampusTalkPostList(page: 1);
        Navigator.pop(context);
      }
    }
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
      counterText: "",
      fillColor: themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightButtonBackground,
      filled: true,
      focusedBorder: OutlineInputBorder(
        borderSide:  BorderSide(
          color: themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightButtonBackground,
        ),
        borderRadius: BorderRadius.circular(16.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide:  BorderSide(
          color:  themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightButtonBackground,
        ),
        borderRadius: BorderRadius.circular(16.0),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide:  BorderSide(
          color: themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightButtonBackground,
        ),
        borderRadius: BorderRadius.circular(16.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide:  BorderSide(
          color:  themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightButtonBackground,
        ),
        borderRadius: BorderRadius.circular(16.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide:  BorderSide(
          color: themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightButtonBackground,
        ),
        borderRadius: BorderRadius.circular(16.0),
      ),
    );
  }
}
