import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mate_app/Providers/beAMateProvider.dart';
import 'package:mate_app/asset/Colors/MateColors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../Widget/datetime_picker.dart';
import '../../../Widget/loader.dart';
import '../../../constant.dart';
import '../../../controller/theme_controller.dart';

class CreateBeAMatePost extends StatefulWidget {
  const CreateBeAMatePost({Key? key}) : super(key: key);

  @override
  _CreateBeAMatePostState createState() => _CreateBeAMatePostState();
}

class _CreateBeAMatePostState extends State<CreateBeAMatePost> {
  final _formKey = GlobalKey<FormState>();
  FocusNode focusNode= FocusNode();
  TextEditingController _fromDateController = TextEditingController();
  TextEditingController _toDateController = TextEditingController();
  TextEditingController _fromTimeController = TextEditingController();
  TextEditingController _toTimeController = TextEditingController();
  String? _title;
  String? _portfolio;
  String? _description;
  String? _fromDate;
  String? _toDate;
  String? _fromTime;
  String? _toTime;
  String? _linkText;
  String? _link;
  final dateFormat = DateFormat("MM-dd-yyyy");
  final timeFormat = DateFormat("HH:mm");
  ThemeController themeController = Get.find<ThemeController>();
  int titleLength= 0;
  int descriptionLength= 0;
  int linkLength= 0;
  int linkTextLength= 0;
  File? _image;
  String? _base64encodedImage;
  File? _video;
  String? _base64encodedVideo;
  final picker = ImagePicker();
  bool isLoading = false;

  @override
  void initState() {
    focusNode.requestFocus();
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scH = MediaQuery.of(context).size.height;
    final scW = MediaQuery.of(context).size.width;
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
                            color: themeController.isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        Text(
                          "Create Post",
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
                    child: Form(
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
                                "I can help with...",
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
                              decoration: _customInputDecoration(labelText: 'Title', icon: Icons.perm_identity),
                              cursorColor: themeController.isDarkMode?MateColors.helpingTextDark:MateColors.helpingTextLight,
                              style:  TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.1,
                                color: themeController.isDarkMode?Colors.white:Colors.black,
                              ),
                              textInputAction: TextInputAction.next,
                              focusNode: focusNode,
                              onFieldSubmitted: (val) {
                                print('onFieldSubmitted :: Title = $val');
                              },
                              onSaved: (value) {
                                print('onSaved Title = $value');
                                _title = value;
                              },
                              validator: (value) {
                                if(value!.isEmpty){
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
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Poppins',
                                  color: themeController.isDarkMode?Colors.white: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(height: 10,),
                            TextFormField(
                              decoration: _customInputDecoration(labelText: 'How can you help your mates?', icon: Icons.perm_identity),
                              cursorColor: themeController.isDarkMode?MateColors.helpingTextDark:MateColors.helpingTextLight,
                              style:  TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.1,
                                color: themeController.isDarkMode?Colors.white:Colors.black,
                              ),
                              textInputAction: TextInputAction.done,
                              minLines: 3,
                              maxLines: 6,
                              onFieldSubmitted: (val) {
                                print('onFieldSubmitted :: description = $val');
                              },
                              onSaved: (value) {
                                print('onSaved lastName = $value');
                                _description = value;
                              },
                              validator: (value) {
                                if(value!.isEmpty){
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
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Poppins',
                                      color: themeController.isDarkMode?Colors.white: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    "$linkTextLength/100",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Poppins',
                                      color: themeController.isDarkMode?Colors.white: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10,),
                            TextFormField(
                              decoration: _customInputDecoration(labelText: 'Link Text', icon: Icons.location_on),
                              cursorColor: themeController.isDarkMode?MateColors.helpingTextDark:MateColors.helpingTextLight,
                              style:  TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.1,
                                color: themeController.isDarkMode?Colors.white:Colors.black,
                              ),
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
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Poppins',
                                      color: themeController.isDarkMode?Colors.white: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    "$linkLength/100",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Poppins',
                                      color: themeController.isDarkMode?Colors.white: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10,),
                            TextFormField(
                              decoration: _customInputDecoration(labelText: 'Link', icon: Icons.location_on),
                              cursorColor: themeController.isDarkMode?MateColors.helpingTextDark:MateColors.helpingTextLight,
                              style:  TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.1,
                                color: themeController.isDarkMode?Colors.white:Colors.black,
                              ),
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
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Portfolio – Optional",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Poppins',
                                      color: themeController.isDarkMode?Colors.white: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    "$linkLength/100",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Poppins',
                                      color: themeController.isDarkMode?Colors.white: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10,),
                            TextFormField(
                              decoration: _customInputDecoration(labelText: 'Link', icon: Icons.perm_identity),
                              cursorColor: themeController.isDarkMode?MateColors.helpingTextDark:MateColors.helpingTextLight,
                              style:  TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.1,
                                color: themeController.isDarkMode?Colors.white:Colors.black,
                              ),
                              textInputAction: TextInputAction.next,
                              maxLength: 100,
                              onChanged: (value){
                                linkLength = value.length;
                                setState(() {});
                              },
                              onFieldSubmitted: (val) {
                                print('onFieldSubmitted :: Title = $val');
                              },
                              onSaved: (value) {
                                print('onSaved Title = $value');
                                _portfolio = value;
                              },
                            ),
                            SizedBox(height: 30,),
                            Padding(
                              padding: const EdgeInsets.only(left: 2,right: 2),
                              child: Text(
                                "Available Date",
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
                              controller: _fromDateController,
                              onTap: ()async{
                                DateTime ? value = await getDate(context:context);
                                _fromDate = value!=null?value.toString():null;
                                if(value!=null){
                                  _fromDateController.text = value.toString();
                                }
                              },
                              readOnly: true,
                              decoration: _customInputDecoration(labelText: 'Available From', icon: Icons.calendar_today_outlined,isSuffix: true),
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
                            // DateTimeField(
                            //   format: dateFormat,
                            //   decoration: _customInputDecoration(labelText: 'Available From', icon: Icons.perm_identity),
                            //   cursorColor: themeController.isDarkMode?MateColors.helpingTextDark:MateColors.helpingTextLight,
                            //   style:  TextStyle(
                            //     fontSize: 14,
                            //     fontWeight: FontWeight.w500,
                            //     letterSpacing: 0.1,
                            //     color: themeController.isDarkMode?Colors.white:Colors.black,
                            //   ),
                            //   textInputAction: TextInputAction.done,
                            //   onShowPicker: (context, currentValue) {
                            //     return showDatePicker(
                            //         context: context,
                            //         firstDate: DateTime(1900),
                            //         initialDate: currentValue ?? DateTime.now(),
                            //         lastDate: DateTime(2100));
                            //   },
                            //   onSaved: (value) {
                            //     print('onSaved fromDate = $value');
                            //     _fromDate = value!=null?value.toString():null;
                            //   },
                            // ),
                            SizedBox(height: 10,),
                            TextFormField(
                              controller: _toDateController,
                              onTap: ()async{
                                DateTime ? value = await getDate(context:context);
                                _toDate = value!=null?value.toString():null;
                                if(value!=null){
                                  _toDateController.text = value.toString();
                                }
                              },
                              readOnly: true,
                              decoration: _customInputDecoration(labelText: 'Available To', icon: Icons.calendar_today_outlined,isSuffix: true),
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
                            // DateTimeField(
                            //   format: dateFormat,
                            //   decoration: _customInputDecoration(labelText: 'Available To', icon: Icons.perm_identity),
                            //   cursorColor: themeController.isDarkMode?MateColors.helpingTextDark:MateColors.helpingTextLight,
                            //   style:  TextStyle(
                            //     fontSize: 14,
                            //     fontWeight: FontWeight.w500,
                            //     letterSpacing: 0.1,
                            //     color: themeController.isDarkMode?Colors.white:Colors.black,
                            //   ),
                            //   textInputAction: TextInputAction.done,
                            //   onShowPicker: (context, currentValue) {
                            //     return showDatePicker(
                            //         context: context,
                            //         firstDate: DateTime(1900),
                            //         initialDate: currentValue ?? DateTime.now(),
                            //         lastDate: DateTime(2100));
                            //   },
                            //   onSaved: (value) {
                            //     print('onSaved toDate = $value');
                            //     _toDate = value!=null?value.toString():null;
                            //   },
                            // ),
                            SizedBox(height: 30,),
                            Padding(
                              padding: const EdgeInsets.only(left: 2,right: 2),
                              child: Text(
                                "Available Time",
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
                              onTap: ()async{
                                TimeOfDay? value = await selectTime(context);
                                _fromTime = value!=null?value.toString():null;
                                if(value!=null){
                                  _fromTimeController.text = value.toString();
                                }
                              },
                              controller: _fromTimeController,
                              readOnly: true,
                              decoration: _customInputDecoration(labelText: 'Available From', icon: Icons.access_time,isSuffix: true),
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
                            // DateTimeField(
                            //   format: timeFormat,
                            //   decoration: _customInputDecoration(labelText: 'Available From', icon: Icons.perm_identity),
                            //   cursorColor: themeController.isDarkMode?MateColors.helpingTextDark:MateColors.helpingTextLight,
                            //   style:  TextStyle(
                            //     fontSize: 14,
                            //     fontWeight: FontWeight.w500,
                            //     letterSpacing: 0.1,
                            //     color: themeController.isDarkMode?Colors.white:Colors.black,
                            //   ),
                            //   textInputAction: TextInputAction.done,
                            //   onShowPicker: (context, currentValue) async {
                            //     final time = await showTimePicker(
                            //       context: context,
                            //       initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                            //     );
                            //     return DateTimeField.convert(time!);
                            //   },
                            //   onSaved: (value) {
                            //     print('onSaved fromTime = $value');
                            //     _fromTime = value!=null?value.toString():null;
                            //   },
                            // ),
                            SizedBox(height: 10,),
                            TextFormField(
                              onTap: ()async{
                                TimeOfDay? value = await selectTime(context);
                                _toTime = value!=null?value.toString():null;
                                if(value!=null){
                                  _toTimeController.text = value.toString();
                                }
                              },
                              controller: _toTimeController,
                              readOnly: true,
                              decoration: _customInputDecoration(labelText: 'Available To', icon: Icons.access_time,isSuffix: true),
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
                            // DateTimeField(
                            //   format: timeFormat,
                            //   decoration: _customInputDecoration(labelText: 'Available To', icon: Icons.perm_identity),
                            //   cursorColor: themeController.isDarkMode?MateColors.helpingTextDark:MateColors.helpingTextLight,
                            //   style:  TextStyle(
                            //     fontSize: 14,
                            //     fontWeight: FontWeight.w500,
                            //     letterSpacing: 0.1,
                            //     color: themeController.isDarkMode?Colors.white:Colors.black,
                            //   ),
                            //   textInputAction: TextInputAction.done,
                            //   onShowPicker: (context, currentValue) async {
                            //     final time = await showTimePicker(
                            //       context: context,
                            //       initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                            //     );
                            //     return DateTimeField.convert(time!);
                            //   },
                            //   onSaved: (value) {
                            //     print('onSaved toTime = $value');
                            //     _toTime = value!=null?value.toString():null;
                            //   },
                            // ),
                            _imageSelectionButton(),
                          ],
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
    );
  }

  Widget _imageSelectionButton(){
    return Padding(
      padding: const EdgeInsets.only(top: 40,bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          _submitButton(context),
        ],
      ),
    );
  }

  Consumer<BeAMateProvider> _submitButton(BuildContext context) {
    return Consumer<BeAMateProvider>(
      builder: (ctx, beAMateProvider, _) {
        if (beAMateProvider.uploadPostLoader) {
          Future.delayed(Duration.zero,(){
            setState(() {
              isLoading = true;
            });
          });
        }
        return Expanded(
          child: Container(
            height: 60,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: (){
                if(_formKey.currentState!.validate()) _submitForm(context);
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
      },
    );
  }

  void _submitForm(BuildContext context) async {
    FocusScope.of(context).unfocus();
    bool validated = _formKey.currentState!.validate();
    if (validated) {
      _formKey.currentState!.save();
      Map<String, dynamic> body={"title":_title, "description": _description};
      if(_portfolio!=null && _portfolio!.isNotEmpty){
        body['portfolio_link']=_portfolio;
      }
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
      bool posted= await Provider.of<BeAMateProvider>(context, listen: false).uploadBeAMatePost(body);
      if(posted){
        Provider.of<BeAMateProvider>(context, listen: false).fetchBeAMatePostList(page: 1);
        Navigator.pop(context);
        Navigator.pop(context);
      }
    }
  }

  Future<DateTime?> getDate({required BuildContext context}) async {
    DateTime? value = await showDatePicker(
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
    return value;
    // if(dateLocal!=null){
    //   dateValue = dateLocal.toString();
    //   print(dateValue);
    //   List<String> split = dateLocal.toString().split(" ");
    //   DateTime dateParsed = DateTime.parse(split[0]);
    //   String dateFormatted = DateFormat('yyyy-MM-dd').format(dateParsed);
    //   _date.text = dateFormatted;
    // }
  }

  Future<TimeOfDay?> selectTime(BuildContext context) async {
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
    return picked;
    // if (picked != null) {
    //   final now = new DateTime.now();
    //   final timeStart = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
    //   String minute = picked.minute.toString().padLeft(2,'0');
    //   String timeFormatted = picked.hour.toString() + ":" + minute;
    //   timeValue = timeStart.toString();
    //   print(timeValue);
    //   _time.text = timeFormatted;
    // }
  }

  // InputDecoration _customInputDecoration({required String labelText, IconData? icon}) {
  //   return InputDecoration(
  //     hintStyle: TextStyle(
  //       fontSize: 16,
  //       fontFamily: 'Poppins',
  //       fontWeight: FontWeight.w400,
  //       color: themeController.isDarkMode?MateColors.helpingTextDark:MateColors.helpingTextLight,
  //     ),
  //     hintText: labelText,
  //     counterText: "",
  //     fillColor: themeController.isDarkMode ? MateColors.containerDark : MateColors.containerLight,
  //     filled: true,
  //     focusedBorder: commonBorder,
  //     enabledBorder: commonBorder,
  //     disabledBorder: commonBorder,
  //     errorBorder: commonBorder,
  //     focusedErrorBorder: commonBorder,
  //   );
  // }
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
