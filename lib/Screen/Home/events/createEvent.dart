import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mate_app/Services/eventService.dart';
import 'package:mate_app/Widget/loader.dart';
import 'package:mate_app/Widget/video_thumbnail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Model/eventCateoryModel.dart';
import '../../../asset/Colors/MateColors.dart';
import '../../../constant.dart';
import '../../../controller/theme_controller.dart';

class CreateEvent extends StatefulWidget {
  static final String routeName = '/createEvent';

  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  ThemeController themeController = Get.find<ThemeController>();
  final _formKey = GlobalKey<FormState>();
  int titleLength = 0;
  int descriptionLength = 0;
  int locationLength = 0;
  int linkLength= 0;
  int linkTextLength= 0;
  File? _image;
  File? _video;
  String? _base64encodedImage;
  String? _base64encodedVideo;
  final picker = ImagePicker();
  TextEditingController _title = TextEditingController();
  TextEditingController _description = TextEditingController();
  TextEditingController _location = TextEditingController();
  TextEditingController _date = TextEditingController();
  TextEditingController _time = TextEditingController();
  TextEditingController _timeEnd = TextEditingController();
  TextEditingController _linkText = TextEditingController();
  TextEditingController _link = TextEditingController();
  bool isLoading = false;
  ScrollController _scrollController = ScrollController();
  String? dateValue;
  String? timeValue;
  String? timeValueEnd;
  EventService _eventService = EventService();
  String token = "";
  late EventCategoryModel eventCategoryModel;
  List<int> categoryId = [];
  List<String> categoryName = [];
  int selectedCategoryId = 0;
  String selectedCategoryName = "";
  String selectedLocationOption = "On Campus";

  @override
  void initState() {
    getStoredValue();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  getStoredValue()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("tokenApp")!;
    eventCategoryModel = await _eventService.getCategory(token: token);
    for(int i=0;i<eventCategoryModel.data!.length;i++){
      categoryId.add(eventCategoryModel.data![i].id!);
      categoryName.add(eventCategoryModel.data![i].name!);
    }
    if(categoryId.isNotEmpty && categoryName.isNotEmpty){
      selectedCategoryId = categoryId[0];
      selectedCategoryName = categoryName[0];
    }
    setState(() {});
  }

  _submitButton(BuildContext context) {
    return Expanded(
      child: Container(
        height: 60,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
            onPrimary: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          onPressed: ()async{
            if(_formKey.currentState!.validate()){
              if(selectedCategoryId==0){
                Fluttertoast.showToast(msg: "Please select category", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
                return;
              }
              setState(() {
                isLoading = true;
              });
              String response = await _eventService.createEvent(
                title: _title.text,
                desc: _description.text,
                location: _location.text,
                date: dateValue,
                time: timeValue,
                photo: _base64encodedImage,
                video: _base64encodedVideo,
                token: token,
                linkText: _linkText.text,
                link: _link.text,
                endTime: timeValueEnd,
                locationOption: selectedLocationOption,
                typeId: selectedCategoryId,
              );
              setState(() {
                isLoading = false;
              });
              if(response=="Event created successfully"){
                Get.back();
                Fluttertoast.showToast(msg: "Event created successfully", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
              }else{
                Fluttertoast.showToast(msg: "Something went wrong", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
              }
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("POST",
                style: TextStyle(
                  color: MateColors.blackTextColor,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Poppins",
                  fontSize: 18.0,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Image.asset('lib/asset/iconsNewDesign/arrowRight.png',
                width: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imageSelectionButton() {
    final scH = MediaQuery.of(context).size.height;
    final scW = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(top: scH*0.1,bottom: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          GestureDetector(
            onTap: ()async{
              final pickedFile = await picker.getImage(source: ImageSource.gallery,imageQuality: 70);
              if (pickedFile != null) {
                _image = File(pickedFile.path);
                _base64encodedImage = pickedFile.path;
                setState(() {});
                print('image selected:: ${_base64encodedImage.toString()}');
              } else {
                print('No image selected.');
              }
            },
            child: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: themeController.isDarkMode?MateColors.smallContainerDark:MateColors.smallContainerLight,
              ),
              child: Center(
                child: Image.asset(
                  "lib/asset/icons/galleryPlus.png",
                  height: 25,
                  width: 25,
                  color: themeController.isDarkMode?Colors.white:Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          GestureDetector(
            onTap: ()async{
              final pickedFile = await picker.getVideo(source: ImageSource.gallery,);
              if (pickedFile != null) {
                _video = File(pickedFile.path);
                _base64encodedVideo = pickedFile.path;
                setState(() {});
                print('video selected:: ${_base64encodedVideo.toString()}');
              } else {
                print('No video selected.');
              }
            },
            child: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: themeController.isDarkMode?MateColors.smallContainerDark:MateColors.smallContainerLight,
              ),
              child: Icon(
                Icons.video_call,
                size: 30,
                color: themeController.isDarkMode?Colors.white:Colors.black,
              ),
            ),
          ),
          SizedBox(
            width: 16,
          ),
          _submitButton(context),
          SizedBox(
            width: 5,
          ),
        ],
      ),
    );
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
      child: Stack(
        children: [
          Scaffold(
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
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
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
                              color: themeController.isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                          Text(
                            "Create Event",
                            style: TextStyle(
                              color: themeController.isDarkMode ? Colors.white : Colors.black,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                              fontSize: 18.0,
                            ),
                          ),
                          SizedBox(),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                        controller: _scrollController,
                        child: Form(
                          key: _formKey,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 2,right: 2,top: 10),
                                  child:   Text(
                                    "Categories",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Poppins',
                                      color: themeController.isDarkMode?Colors.white: Colors.black,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Container(
                                  height: 60,
                                  padding: EdgeInsets.only(left: 16,right: 16),
                                  decoration: ShapeDecoration(
                                    color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(14)),
                                    ),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      isDense: true,
                                      isExpanded: true,
                                      //value: selectedCategoryName,
                                      items: categoryName.map((String items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text(items,
                                            style: const TextStyle(fontSize: 14.0),
                                          ),
                                        );
                                      }).toList(),
                                      hint: Text(selectedCategoryName==""?"Types":selectedCategoryName,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w400,
                                          color: themeController.isDarkMode?MateColors.helpingTextDark:MateColors.helpingTextLight,
                                        ),
                                      ),
                                      onChanged: (newValue) {
                                        setState(() {
                                          selectedCategoryName = newValue!;
                                          int index = categoryName.indexOf(selectedCategoryName);
                                          selectedCategoryId = categoryId[index];
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(height: 40,),
                                Padding(
                                  padding: const EdgeInsets.only(left: 2,right: 2,),
                                  child:   Text(
                                    "Title",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Poppins',
                                      color: themeController.isDarkMode?Colors.white: Colors.black,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10,),
                                TextFormField(
                                  controller: _title,
                                  scrollPadding: const EdgeInsets.all(0.0),
                                  decoration: _customInputDecoration(labelText: 'Title', icon: Icons.title),
                                  cursorColor: themeController.isDarkMode?MateColors.helpingTextDark:MateColors.helpingTextLight,
                                  style:  TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.1,
                                    color: themeController.isDarkMode?Colors.white:Colors.black,
                                  ),
                                  textInputAction: TextInputAction.next,
                                  validator: (value) {
                                    if(value!.isEmpty){
                                      return "This field is required";
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 40,),
                                Padding(
                                  padding: const EdgeInsets.only(left: 2,right: 2),
                                  child:  Text(
                                    "Description",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Poppins',
                                      color: themeController.isDarkMode?Colors.white: Colors.black,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10,),
                                TextFormField(
                                  controller: _description,
                                  decoration: _customInputDecoration(labelText: 'Describe your event', icon: Icons.perm_identity),
                                  cursorColor: themeController.isDarkMode?MateColors.helpingTextDark:MateColors.helpingTextLight,
                                  style:  TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.1,
                                    color: themeController.isDarkMode?Colors.white:Colors.black,
                                  ),
                                  textInputAction: TextInputAction.newline,
                                  minLines: 3,
                                  maxLines: 8,
                                  validator: (value) {
                                    if(value!.isEmpty){
                                      return "This field is required";
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 40,),
                                Padding(
                                  padding: const EdgeInsets.only(left: 2,right: 2),
                                  child:  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Link Text – Optional",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Poppins',
                                          color: themeController.isDarkMode?Colors.white: Colors.black,
                                        ),
                                      ),
                                      // Text(
                                      //   "$linkTextLength/100",
                                      //   style: TextStyle(
                                      //     fontSize: 12,
                                      //     fontWeight: FontWeight.w400,
                                      //     letterSpacing: 0.1,
                                      //     color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10,),
                                TextFormField(
                                  controller: _linkText,
                                  decoration: _customInputDecoration(labelText: 'Link Text', icon: Icons.location_on),
                                  cursorColor: themeController.isDarkMode?MateColors.helpingTextDark:MateColors.helpingTextLight,
                                  style:  TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.1,
                                    color: themeController.isDarkMode?Colors.white:Colors.black,
                                  ),
                                  textInputAction: TextInputAction.done,
                                  //maxLength: 100,
                                  onChanged: (value){
                                    linkTextLength = value.length;
                                    setState(() {});
                                  },
                                  validator: (value) {
                                    return null;
                                  },
                                ),
                                SizedBox(height: 40,),
                                Padding(
                                  padding: const EdgeInsets.only(left: 2,right: 2),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Link – Optional",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Poppins',
                                          color: themeController.isDarkMode?Colors.white: Colors.black,
                                        ),
                                      ),
                                      // Text(
                                      //   "$linkLength/100",
                                      //   style: TextStyle(
                                      //     fontSize: 12,
                                      //     fontWeight: FontWeight.w400,
                                      //     letterSpacing: 0.1,
                                      //     color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10,),
                                TextFormField(
                                  controller: _link,
                                  decoration: _customInputDecoration(labelText: 'Link', icon: Icons.location_on),
                                  cursorColor: themeController.isDarkMode?MateColors.helpingTextDark:MateColors.helpingTextLight,
                                  style:  TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.1,
                                    color: themeController.isDarkMode?Colors.white:Colors.black,
                                  ),
                                  textInputAction: TextInputAction.done,
                                  //maxLength: 100,
                                  onChanged: (value){
                                    linkLength = value.length;
                                    setState(() {});
                                  },
                                  validator: (value) {
                                    return null;
                                  },
                                ),
                                SizedBox(height: 40,),
                                Padding(
                                  padding: const EdgeInsets.only(left: 2,right: 2),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Location",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Poppins',
                                          color: themeController.isDarkMode?Colors.white: Colors.black,
                                        ),
                                      ),
                                      // Text(
                                      //   "$locationLength/50",
                                      //   style: TextStyle(
                                      //     fontSize: 12,
                                      //     fontWeight: FontWeight.w400,
                                      //     letterSpacing: 0.1,
                                      //     color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10,),
                                TextFormField(
                                  controller: _location,
                                  decoration: _customInputDecoration(labelText: 'Location', icon: Icons.location_on),
                                  cursorColor: themeController.isDarkMode?MateColors.helpingTextDark:MateColors.helpingTextLight,
                                  style:  TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.1,
                                    color: themeController.isDarkMode?Colors.white:Colors.black,
                                  ),
                                  textInputAction: TextInputAction.done,
                                  //maxLength: 50,
                                  onChanged: (value){
                                    locationLength = value.length;
                                    setState(() {});
                                  },
                                  validator: (value) {
                                    if(value!.isEmpty){
                                      return "This field is required";
                                    }
                                    return null;
                                  },
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                        selectedLocationOption = "On Campus";
                                        setState(() {});
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(top: 20),
                                        height: 39,
                                        padding: EdgeInsets.symmetric(horizontal: 16),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(25),
                                          color: selectedLocationOption=="On Campus"?
                                          themeController.isDarkMode?
                                          MateColors.appThemeDark:
                                          MateColors.appThemeLight:
                                          themeController.isDarkMode?
                                          Color(0xFF595E6E).withOpacity(0.35):
                                          Colors.white.withOpacity(0.5),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "On Campus",
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                              color: selectedLocationOption=="On Campus"?
                                              themeController.isDarkMode? Colors.black: Colors.white:
                                              themeController.isDarkMode? Colors.white:Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: (){
                                        selectedLocationOption = "Off Campus";
                                        setState(() {});
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(top: 20),
                                        height: 39,
                                        padding: EdgeInsets.symmetric(horizontal: 16),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(25),
                                          color: selectedLocationOption=="Off Campus"?
                                          themeController.isDarkMode?
                                          MateColors.appThemeDark:
                                          MateColors.appThemeLight:
                                          themeController.isDarkMode?
                                          Color(0xFF595E6E).withOpacity(0.35):
                                          Colors.white.withOpacity(0.5),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Off Campus",
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                              color: selectedLocationOption=="Off Campus"?
                                              themeController.isDarkMode? Colors.black: Colors.white:
                                              themeController.isDarkMode? Colors.white:Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: (){
                                        selectedLocationOption = "Virtual";
                                        setState(() {});
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(top: 20),
                                        height: 39,
                                        padding: EdgeInsets.symmetric(horizontal: 16),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(25),
                                          color: selectedLocationOption=="Virtual"?
                                          themeController.isDarkMode?
                                          MateColors.appThemeDark:
                                          MateColors.appThemeLight:
                                          themeController.isDarkMode?
                                          Color(0xFF595E6E).withOpacity(0.35):
                                          Colors.white.withOpacity(0.5),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Virtual",
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                              color: selectedLocationOption=="Virtual"?
                                              themeController.isDarkMode? Colors.black: Colors.white:
                                              themeController.isDarkMode? Colors.white:Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 40,),
                                Padding(
                                  padding: const EdgeInsets.only(left: 2,right: 2),
                                  child: Text(
                                    "Date",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Poppins',
                                      color: themeController.isDarkMode?Colors.white: Colors.black,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10,),
                                TextFormField(
                                  controller: _date,
                                  onTap: (){
                                    getDate(context:context);
                                  },
                                  readOnly: true,
                                  decoration: _customInputDecoration(labelText: 'Date', icon: Icons.calendar_today_outlined,isSuffix: true),
                                  cursorColor: themeController.isDarkMode?MateColors.helpingTextDark:MateColors.helpingTextLight,
                                  style:  TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.1,
                                    color: themeController.isDarkMode?Colors.white:Colors.black,
                                  ),
                                  textInputAction: TextInputAction.done,
                                  maxLength: 50,
                                  validator: (value) {
                                    if(value!.isEmpty){
                                      return "This field is required";
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 40,),
                                Padding(
                                  padding: const EdgeInsets.only(left: 2,right: 2),
                                  child: Text(
                                    "Start Time",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Poppins',
                                      color: themeController.isDarkMode?Colors.white: Colors.black,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10,),
                                TextFormField(
                                  onTap: (){
                                    selectTime(context);
                                  },
                                  controller: _time,
                                  readOnly: true,
                                  decoration: _customInputDecoration(labelText: 'Start Time', icon: Icons.access_time,isSuffix: true),
                                  cursorColor: themeController.isDarkMode?MateColors.helpingTextDark:MateColors.helpingTextLight,
                                  style:  TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.1,
                                    color: themeController.isDarkMode?Colors.white:Colors.black,
                                  ),
                                  textInputAction: TextInputAction.done,
                                  maxLength: 50,
                                  validator: (value) {
                                    if(value!.isEmpty){
                                      return "This field is required";
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 40,),
                                Padding(
                                  padding: const EdgeInsets.only(left: 2,right: 2),
                                  child: Text(
                                    "End Time",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Poppins',
                                      color: themeController.isDarkMode?Colors.white: Colors.black,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10,),
                                TextFormField(
                                  onTap: (){
                                    selectTimeEnd(context);
                                  },
                                  controller: _timeEnd,
                                  readOnly: true,
                                  decoration: _customInputDecoration(labelText: 'End Time', icon: Icons.access_time,isSuffix: true),
                                  cursorColor: themeController.isDarkMode?MateColors.helpingTextDark:MateColors.helpingTextLight,
                                  style:  TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.1,
                                    color: themeController.isDarkMode?Colors.white:Colors.black,
                                  ),
                                  textInputAction: TextInputAction.done,
                                  maxLength: 50,
                                  // validator: (value) {
                                  //   if(value.isEmpty){
                                  //     return "This field is required";
                                  //   }
                                  //   return null;
                                  // },
                                ),
                                _image!=null?
                                Stack(
                                  children: [
                                    Container(
                                      height: 150,
                                      width: MediaQuery.of(context).size.width,
                                      margin: EdgeInsets.only(top: 30),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8.0),
                                        clipBehavior: Clip.hardEdge,
                                        child: Image.file(_image!,fit: BoxFit.fill),
                                      ),
                                    ),
                                    Positioned(
                                      top: 18,
                                      right: 0,
                                      child: InkWell(
                                        onTap: (){
                                          _image = null;
                                          _base64encodedImage = null;
                                          setState(() {});
                                        },
                                        child: Container(
                                          height: 30,
                                          padding: EdgeInsets.all(5),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: MateColors.activeIcons,
                                          ),
                                          child: Icon(Icons.clear,color: Colors.black,size: 16,),
                                        ),
                                      ),
                                    ),
                                  ],
                                ):Offstage(),
                                _video!=null?
                                Stack(
                                  children: [
                                    Container(
                                      height: 150,
                                      width: MediaQuery.of(context).size.width,
                                      margin: EdgeInsets.only(top: 30),
                                      child: VideoThumbnailFile(videoUrl: _video!),
                                    ),
                                    Positioned(
                                      top: 18,
                                      right: 0,
                                      child: InkWell(
                                        onTap: (){
                                          _video = null;
                                          _base64encodedVideo = null;
                                          setState(() {});
                                        },
                                        child: Container(
                                          height: 30,
                                          padding: EdgeInsets.all(5),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: MateColors.activeIcons,
                                          ),
                                          child: Icon(Icons.clear,color: Colors.black,size: 16,),
                                        ),
                                      ),
                                    ),
                                  ],
                                ):Offstage(),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0, top: 5),
                                  child: _imageSelectionButton(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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

  void getDate({required BuildContext context}) async {
    DateTime? dateLocal = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light(),
          child: child!,
        );
      },
    );
    if(dateLocal!=null){
      dateValue = dateLocal.toString();
      print(dateValue);
      List<String> split = dateLocal.toString().split(" ");
      DateTime dateParsed = DateTime.parse(split[0]);
      String dateFormatted = DateFormat('yyyy-MM-dd').format(dateParsed);
      _date.text = dateFormatted;
    }
  }

  void selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );
    if (picked != null) {
      final now = new DateTime.now();
      final timeStart = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
      String minute = picked.minute.toString().padLeft(2,'0');
      String timeFormatted = picked.hour.toString() + ":" + minute;
      timeValue = timeStart.toString();
      print(timeValue);
      _time.text = timeFormatted;
    }
  }

  void selectTimeEnd(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );
    if (picked != null) {
      final now = new DateTime.now();
      final timeEnd = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
      String minute = picked.minute.toString().padLeft(2,'0');
      String timeFormatted = picked.hour.toString() + ":" + minute;
      List<String> dateTime = timeEnd.toString().split(" ");
      timeValueEnd = dateTime[0] + "T" + dateTime[1];
      print(timeValueEnd);
      _timeEnd.text = timeFormatted;
    }
  }

  InputDecoration _customInputDecoration({required String labelText, IconData? icon,bool isSuffix=false}) {
    return InputDecoration(
      hintStyle: TextStyle(
        fontSize: 16,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w400,
        color: themeController.isDarkMode?MateColors.helpingTextDark:MateColors.helpingTextLight,
      ),
      hintText: labelText,
      suffixIcon: isSuffix?Icon(
        icon,
        size: 20,
        color: themeController.isDarkMode?MateColors.helpingTextDark:MateColors.helpingTextLight,
      ):Offstage(),
      counterText: "",
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
