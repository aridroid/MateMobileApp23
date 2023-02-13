import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mate_app/Providers/findAMateProvider.dart';
import 'package:mate_app/Utility/Utility.dart';
import 'package:mate_app/asset/Colors/MateColors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nuts_activity_indicator/nuts_activity_indicator.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../Widget/datetime_picker.dart';
import '../../../Widget/loader.dart';
import '../../../controller/theme_controller.dart';

class CreateFindAMatePost extends StatefulWidget {
  const CreateFindAMatePost({Key key}) : super(key: key);

  @override
  _CreateFindAMatePostState createState() => _CreateFindAMatePostState();
}

class _CreateFindAMatePostState extends State<CreateFindAMatePost> {

  final _formKey = GlobalKey<FormState>();
  FocusNode focusNode= FocusNode();
  String _title;
  String _description;
  String _fromDate;
  String _toDate;
  String _fromTime;
  String _toTime;
  String _linkText;
  String _link;
  final dateFormat = DateFormat("MM-dd-yyyy");
  final timeFormat = DateFormat("HH:mm");
  ThemeController themeController = Get.find<ThemeController>();
  int titleLength= 0;
  int descriptionLength= 0;
  int linkLength= 0;
  int linkTextLength= 0;
  File _image;
  String _base64encodedImage;
  File _video;
  String _base64encodedVideo;
  final picker = ImagePicker();
  bool isLoading = false;

  @override
  void initState() {
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
    return Stack(
      children: [
        GestureDetector(
           behavior: HitTestBehavior.translucent,
          onTap: null,
          onPanUpdate: (details) {
            if (details.delta.dy > 0){
              FocusScope.of(context).requestFocus(FocusNode());
              print("Dragging in +Y direction");
            }
          },
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              iconTheme: IconThemeData(
                color: MateColors.activeIcons,
              ),
              title: Text(
                "Create Post",
                style: TextStyle(
                  color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 17.0,
                ),
              ),
              centerTitle: true,
            ),
            body: Form(
              key: _formKey,
              child: SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 2,right: 2),
                      child:  Text(
                        "I need help with...",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.1,
                          color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    TextFormField(
                      decoration: _customInputDecoration(labelText: 'Title', icon: Icons.perm_identity),
                      style:  TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.1,
                        color: themeController.isDarkMode?Colors.white:Colors.black,
                      ),
                      cursorColor: MateColors.activeIcons,
                      textInputAction: TextInputAction.next,
                      // maxLength: 50,
                      // onChanged: (value){
                      //   titleLength = value.length;
                      //   setState(() {});
                      // },
                      focusNode: focusNode,
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
                    SizedBox(height: 30,),
                    Padding(
                      padding: const EdgeInsets.only(left: 2,right: 2),
                      child: Text(
                        "Description",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.1,
                          color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    TextFormField(
                      decoration: _customInputDecoration(labelText: "How can your mates help? Please describe your issue.", icon: Icons.perm_identity),
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
                      // maxLength: 256,
                      // onChanged: (value){
                      //   descriptionLength = value.length;
                      //   setState(() {});
                      // },
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


                    SizedBox(height: 30,),
                    Padding(
                      padding: const EdgeInsets.only(left: 2,right: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Link Text – Optional",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.1,
                              color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                            ),
                          ),
                          Text(
                            "$linkTextLength/100",
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
                    SizedBox(height: 10,),
                    TextFormField(
                      decoration: _customInputDecoration(labelText: 'Link Text', icon: Icons.location_on),
                      style:  TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.1,
                        color: themeController.isDarkMode?Colors.white:Colors.black,
                      ),
                      cursorColor: MateColors.activeIcons,
                      textInputAction: TextInputAction.done,
                      maxLength: 100,
                      onChanged: (value){
                        linkTextLength = value.length;
                        setState(() {});
                      },
                      onSaved: (value) {
                        print('onSaved link text = $value');
                        _linkText = value;
                      },
                      validator: (value) {
                        return null;
                      },
                    ),
                    SizedBox(height: 30,),
                    Padding(
                      padding: const EdgeInsets.only(left: 2,right: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Link – Optional",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.1,
                              color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                            ),
                          ),
                          Text(
                            "$linkLength/100",
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
                    SizedBox(height: 10,),
                    TextFormField(
                      decoration: _customInputDecoration(labelText: 'Link', icon: Icons.location_on),
                      style:  TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.1,
                        color: themeController.isDarkMode?Colors.white:Colors.black,
                      ),
                      cursorColor: MateColors.activeIcons,
                      textInputAction: TextInputAction.done,
                      maxLength: 100,
                      onChanged: (value){
                        linkLength = value.length;
                        setState(() {});
                      },
                      onSaved: (value) {
                        print('onSaved link = $value');
                        _link = value;
                      },
                      validator: (value) {
                        return null;
                      },
                    ),

                    SizedBox(height: 30,),
                    Padding(
                      padding: const EdgeInsets.only(left: 2,right: 2),
                      child: Text(
                        "Available Date",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.1,
                          color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    DateTimeField(
                      format: dateFormat,
                      decoration: _customInputDecoration(labelText: 'Available From', icon: Icons.perm_identity),
                      style:  TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.1,
                        color: themeController.isDarkMode?Colors.white:Colors.black,
                      ),
                      cursorColor: MateColors.activeIcons,
                      textInputAction: TextInputAction.done,
                      onShowPicker: (context, currentValue) {
                        return showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            initialDate: currentValue ?? DateTime.now(),
                            lastDate: DateTime(2100));
                      },
                      onSaved: (value) {
                        print('onSaved fromDate = $value');
                        _fromDate = value!=null?value.toString():null;
                      },
                      // validator: (value) {
                      //   if(value==null){
                      //     return "Please Select Available Date";
                      //   }else
                      //     return null;
                      // },
                    ),
                    SizedBox(height: 10,),
                    DateTimeField(
                      format: dateFormat,
                      decoration: _customInputDecoration(labelText: 'Available To', icon: Icons.perm_identity),
                      style:  TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.1,
                        color: themeController.isDarkMode?Colors.white:Colors.black,
                      ),
                      cursorColor: MateColors.activeIcons,
                      textInputAction: TextInputAction.done,
                      onShowPicker: (context, currentValue) {
                        return showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            initialDate: currentValue ?? DateTime.now(),
                            lastDate: DateTime(2100));
                      },
                      onSaved: (value) {
                        print('onSaved toDate = $value');
                        _toDate = value!=null?value.toString():null;
                      },
                    ),
                    SizedBox(height: 30,),
                    Padding(
                      padding: const EdgeInsets.only(left: 2,right: 2),
                      child: Text(
                        "Available Time",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.1,
                          color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    DateTimeField(
                      format: timeFormat,
                      decoration: _customInputDecoration(labelText: 'Available From', icon: Icons.perm_identity),
                      style:  TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.1,
                        color: themeController.isDarkMode?Colors.white:Colors.black,
                      ),
                      cursorColor: MateColors.activeIcons,
                      textInputAction: TextInputAction.done,
                      onShowPicker: (context, currentValue) async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                        );
                        return DateTimeField.convert(time);
                      },
                      onSaved: (value) {
                        print('onSaved fromTime = $value');
                        _fromTime = value!=null?value.toString():null;
                      },
                      // validator: (value) {
                      //   if(value==null){
                      //     return "Please Select Available Time";
                      //   }else
                      //     return null;
                      // },
                    ),
                    SizedBox(height: 10,),
                    DateTimeField(
                      format: timeFormat,
                      decoration: _customInputDecoration(labelText: 'Available To', icon: Icons.perm_identity),
                      style:  TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.1,
                        color: themeController.isDarkMode?Colors.white:Colors.black,
                      ),
                      cursorColor: MateColors.activeIcons,
                      textInputAction: TextInputAction.done,
                      onShowPicker: (context, currentValue) async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                        );
                        return DateTimeField.convert(time);
                      },
                      onSaved: (value) {
                        print('onSaved toTime = $value');
                        _toTime = value!=null?value.toString():null;
                      },
                    ),
                    _imageSelectionButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: isLoading,
          child: Loader(),
        ),
      ],
    );
  }


  Widget _imageSelectionButton(){
    return Padding(
      padding: const EdgeInsets.only(top: 40,bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          // GestureDetector(
          //   onTap: ()async{
          //     final pickedFile = await picker.getImage(source: ImageSource.gallery,imageQuality: 70);
          //     if (pickedFile != null) {
          //       _image = File(pickedFile.path);
          //       var img = _image.readAsBytesSync();
          //       _base64encodedImage = base64Encode(img);
          //       setState(() {});
          //       print('image selected:: ${_base64encodedImage.toString()}');
          //     } else {
          //       print('No image selected.');
          //     }
          //   },
          //   child: Container(
          //     height: 56,
          //     width: 56,
          //     decoration: BoxDecoration(
          //       shape: BoxShape.circle,
          //       color: themeController.isDarkMode?MateColors.darkDivider:MateColors.lightDivider,
          //     ),
          //     child: Center(
          //       child: Image.asset(
          //         "lib/asset/icons/galleryPlus.png",
          //         height: 20,
          //         width: 20,
          //       ),
          //     ),
          //   ),
          // ),
          // SizedBox(
          //   width: 20,
          // ),
          // GestureDetector(
          //   onTap: ()async{
          //     final pickedFile = await picker.getVideo(source: ImageSource.gallery,);
          //     if (pickedFile != null) {
          //       _video = File(pickedFile.path);
          //       var img = _video.readAsBytesSync();
          //       _base64encodedVideo = base64Encode(img);
          //       setState(() {});
          //       print('video selected:: ${_base64encodedVideo.toString()}');
          //     } else {
          //       print('No video selected.');
          //     }
          //   },
          //   child: Container(
          //     height: 56,
          //     width: 56,
          //     decoration: BoxDecoration(
          //       shape: BoxShape.circle,
          //       color: themeController.isDarkMode?MateColors.darkDivider:MateColors.lightDivider,
          //     ),
          //     child: Icon(
          //       Icons.video_call,
          //       color: MateColors.activeIcons,
          //       size: 30,
          //     ),
          //   ),
          // ),
          _submitButton(context),
        ],
      ),
    );
  }

  Consumer<FindAMateProvider> _submitButton(BuildContext context) {
    return Consumer<FindAMateProvider>(
      builder: (ctx, findAMateProvider, _) {
        if (findAMateProvider.uploadPostLoader) {
          Future.delayed(Duration.zero,(){
            setState(() {
              isLoading = true;
            });
          });
          // return Padding(
          //   padding: const EdgeInsets.all(15.0),
          //   child: NutsActivityIndicator(
          //     radius: 10,
          //     activeColor: Colors.indigo,
          //     inactiveColor: Colors.red,
          //     tickCount: 11,
          //     startRatio: 0.55,
          //     animationDuration: Duration(seconds: 2),
          //   ),
          // );
        }

        return Expanded(
          child: Align(
            alignment: Alignment.center,
            child: Container(
              height: 56,
              width: 120,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: MateColors.activeIcons,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                ),
                onPressed: (){
                  if(_formKey.currentState.validate()) _submitForm(context);
                },
                child: Text("Post",
                  style: TextStyle(
                    color: themeController.isDarkMode?MateColors.blackTextColor:Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 17.0,
                  ),
                ),
              ),
            ),
          ),
        );




        // Padding(
        //   padding: const EdgeInsets.only(top: 16),
        //   child: ButtonTheme(
        //     minWidth: MediaQuery.of(context).size.width - 40,
        //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        //     child: RaisedButton(
        //       color: MateColors.activeIcons,
        //       padding: EdgeInsets.symmetric(vertical: 11),
        //       child: Text(
        //         'Post',
        //         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0.sp),
        //       ),
        //       onPressed: () {
        //         if(_formKey.currentState.validate()) _submitForm(context);
        //       },
        //     ),
        //   ),
        // );
      },
    );
  }


  void _submitForm(BuildContext context) async {
    FocusScope.of(context).unfocus();
    bool validated = _formKey.currentState.validate();

    if (validated) {
      _formKey.currentState.save(); //it will trigger a onSaved(){} method on all TextEditingController();


      Map<String, dynamic> body={"title":_title, "description": _description};
      if(_fromDate!=null){
        body['from_date']=_fromDate;
      }
      if(_toDate!=null){
        body['to_date']=_toDate;
      }
      if(_fromTime!=null){
        body['time_from']=_fromTime;
      }
      if(_toTime!=null){
        body['time_to']=_toTime;
      }
      if(_linkText!=null){
        body['hyperlinkText']=_linkText;
      }
      if(_link!=null){
        body['hyperlink']=_link;
      }
      print(body);
      bool posted= await Provider.of<FindAMateProvider>(context, listen: false).uploadFindAMatePost(body);
      if(posted){
        Provider.of<FindAMateProvider>(context, listen: false).fetchFindAMatePostList(page: 1);
        Navigator.pop(context);
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
