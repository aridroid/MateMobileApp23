import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:mate_app/Providers/FeedProvider.dart';
import 'package:mate_app/Utility/Utility.dart';
import 'package:mate_app/Widget/loader.dart';
import 'package:mate_app/asset/Colors/MateColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../controller/theme_controller.dart';
import '../HomeScreen.dart';

class CreateFeedPost extends StatefulWidget {
  static final String routeName = 'create-post';

  @override
  _CreateFeedPostState createState() => _CreateFeedPostState();
}

class _CreateFeedPostState extends State<CreateFeedPost> {
  final _formKey = GlobalKey<FormState>();
  FocusNode focusNode= FocusNode();

  String _id;
  String _title;
  String _description;
  String _location;
  String _hyperlinkText;
  String _hyperlink;
  TextEditingController _otherFeedType = new TextEditingController(text: "");

  File _image;
  String _base64encodedImage;
  final picker = ImagePicker();

  String _selectedItem = '';

  FocusNode _descriptionFocusNode = FocusNode();
  FocusNode _locationFocusNode = FocusNode();

  bool _toggleStartDate = false;
  bool _toggleEndDate = false;
  List<bool> feedTypeChek = [];
  bool feedTypeOtherCheck = false;
  List<String> feedTypeId = [];
  bool feedInsertFirstCheck=true;

  DateTime _startDate;
  DateTime _endDate;

  ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    _descriptionFocusNode.dispose();
    _locationFocusNode.dispose();
    focusNode.dispose();

    super.dispose();
  }

  @override
  void initState() {
    print(DateTime.now());
    //2022-10-08 13:47:14.870293
    super.initState();
    focusNode.requestFocus();
    Future.delayed(Duration(seconds: 1), () {
      Provider.of<FeedProvider>(context, listen: false).fetchFeedTypes();
    });
  }

  void _submitForm(BuildContext context) async {
    FocusScope.of(context).unfocus();
    bool validated = _formKey.currentState.validate();

    if (validated) {
      setState(() {
        isLoading = true;
      });
      _formKey.currentState.save(); //it will trigger a onSaved(){} method on all TextEditingController();

      List<String> feedTypeIdFinal = [];
      for(int i=0;i<feedTypeChek.length;i++){
        if(feedTypeChek[i]){
          feedTypeIdFinal.add(feedTypeId[i]);
        }
      }

      bool updated = await Provider.of<FeedProvider>(context, listen: false).postFeed(
          id: feedTypeIdFinal.isNotEmpty? feedTypeIdFinal : null,
          //make dynamic
          feedTypeOther: (feedTypeOtherCheck==true)?_otherFeedType.text.trim():null,
          title: _title,
          description: _description,
          location: _location,
          hyperlink: _hyperlink,
          hyperlinkText: _hyperlinkText,
          startDate: _startDate != null ? _startDate.toString() : null,
          endDate: _endDate != null ? _endDate.toString() : null,
          image: _base64encodedImage != null ? _base64encodedImage : null);


      if (updated) {
        setState(() {
          isLoading = false;
        });
        // Get.back();
        // Get.back();
        //Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => HomeScreen(
              index: 0,
            )));
      } else {
        //
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


      // InputDecoration(
      //   contentPadding: EdgeInsets.fromLTRB(12, 13, 12, 13),
      //   isDense: true,
      //   counterStyle: TextStyle(color: Colors.grey),
      //   hintStyle: TextStyle(fontSize: 15.0, color: Colors.white70),
      //   hintText: labelText,
      //   // prefixIcon: Icon(
      //   //   icon,
      //   //   color: MateColors.activeIcons,
      //   // ),
      //   enabledBorder: OutlineInputBorder(
      //     borderSide: const BorderSide(color: Colors.grey, width: 0.3),
      //     borderRadius: BorderRadius.circular(15.0),
      //   ),
      //   focusedBorder: OutlineInputBorder(
      //     borderSide: const BorderSide(color: Colors.white, width: 0.3),
      //     borderRadius: BorderRadius.circular(15.0),
      //   ),
      //   border: InputBorder.none);
  }

  Consumer _dropdownMenuItems() {
    return Consumer<FeedProvider>(
      builder: (ctx, feedProvider, _) {
        List<DropdownMenuItem<String>> dropDownItems = [];

        feedProvider.feedTypeList.forEach((element) {
          // print('inForeach:: ${element.id}');

          dropDownItems.add(DropdownMenuItem<String>(
            value: element.id,
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                element.name,
                style: TextStyle(color: MateColors.activeIcons),
              ),
            ),
          ));
        });

        return Container(
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(color: Colors.grey, style: BorderStyle.solid, width: 0.30),
          ),
          child: DropdownButton(
            value: _id,
            dropdownColor: myHexColor,
            isExpanded: true,
            icon: Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Icon(Icons.arrow_drop_down),
            ),
            iconSize: 25,
            underline: SizedBox(),
            hint: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                'Select Feed Type',
                style: TextStyle(color: MateColors.activeIcons),
              ),
            ),
            onChanged: (value) {
              _id = value;
              setState(() {
                _selectedItem = feedProvider.feedTypeList.firstWhere((element) => element.id == _id).name;
              });

            },
            items: dropDownItems,
          ),
        );
      },
    );
  }

  Consumer<FeedProvider> _submitButton(BuildContext context) {
    return Consumer<FeedProvider>(
      builder: (ctx, feedProvider, _) {
        // if (feedProvider.feedPostLoader) {
        //   Future.delayed(Duration.zero,(){
        //     setState(() {
        //       isLoading = true;
        //     });
        //   });
          // return Center(
          //   child: NutsActivityIndicator(
          //     radius: 10,
          //     activeColor: Colors.indigo,
          //     inactiveColor: Colors.red,
          //     tickCount: 11,
          //     startRatio: 0.55,
          //     animationDuration: Duration(seconds: 2),
          //   ),
          // );
        // }
        //
        return Expanded(
          child: Align(
            alignment: Alignment.centerRight,
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
                  FocusScope.of(context).unfocus();
                  bool validated = _formKey.currentState.validate();
                  _formKey.currentState.save();

                  if (feedTypeChek.any((element) => element == true || feedTypeOtherCheck)) {
                    if(feedTypeOtherCheck && _otherFeedType.text.trim().isEmpty){
                      Fluttertoast.showToast(msg: " Enter Other Feed Type ", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
                    }else{
                      _submitForm(ctx);
                      // if(_hyperlink.isNotEmpty && _hyperlinkText.isEmpty){
                      //   Fluttertoast.showToast(msg: " Enter Hyperlink text along with URL ", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
                      // }else if(_hyperlink.isEmpty && _hyperlinkText.isNotEmpty){
                      //   Fluttertoast.showToast(msg: " Enter URL along with Hyperlink text ", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
                      // }else{
                      //   _submitForm(ctx);
                      // }
                    }
                  } else
                    Fluttertoast.showToast(msg: " Select Feed Type ", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
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



        //   Padding(
        //   padding: const EdgeInsets.only(bottom: 30.0),
        //   child: ButtonTheme(
        //     minWidth: MediaQuery.of(context).size.width - 20,
        //     child: RaisedButton(
        //       color: MateColors.activeIcons,
        //       child: Text(
        //         'Post',
        //         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0.sp),
        //       ),
        //       onPressed: () {
        //           FocusScope.of(context).unfocus();
        //           bool validated = _formKey.currentState.validate();
        //           _formKey.currentState.save();
        //
        //           if (feedTypeChek.any((element) => element == true || feedTypeOtherCheck)) {
        //             if(feedTypeOtherCheck && _otherFeedType.text.trim().isEmpty){
        //               Fluttertoast.showToast(msg: " Enter Other Feed Type ", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
        //             }else{
        //               if(_hyperlink.isNotEmpty && _hyperlinkText.isEmpty){
        //                 Fluttertoast.showToast(msg: " Enter Hyperlink text along with URL ", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
        //               }else if(_hyperlink.isEmpty && _hyperlinkText.isNotEmpty){
        //                 Fluttertoast.showToast(msg: " Enter URL along with Hyperlink text ", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
        //               }else{
        //                 _submitForm(ctx);
        //               }
        //             }
        //           } else
        //             Fluttertoast.showToast(msg: " Select Feed Type ", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
        //       },
        //     ),
        //   ),
        // );
      },
    );
  }
  ThemeController themeController = Get.find<ThemeController>();
  int titleLength= 0;
  int descriptionLength= 0;
  int linkLength= 0;
  int linkTextLength= 0;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final scH = MediaQuery.of(context).size.height;
    final scW = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Scaffold(
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
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Selector<FeedProvider, String>(
                        builder: (ctx, error, _) {
                          if (error != '') {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                  color: Colors.red,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "$error",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )),
                            );
                          }
                          return SizedBox.shrink();
                        },
                        selector: (ctx, feedProvider) => feedProvider.error,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 2,right: 2),
                        child:  Text(
                          "Title",
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
                        scrollPadding: const EdgeInsets.all(0.0),
                        focusNode: focusNode,
                        decoration: _customInputDecoration(labelText: 'Title', icon: Icons.title),
                        style:  TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.1,
                          color: themeController.isDarkMode?Colors.white:Colors.black,
                        ),
                        cursorColor: MateColors.activeIcons,
                        textInputAction: TextInputAction.next,
                        // maxLength: 100,
                        // onChanged: (value){
                        //   titleLength = value.length;
                        //   setState(() {});
                        // },
                        onFieldSubmitted: (val) {
                          print('onFieldSubmitted :: title = $val');
                          FocusScope.of(context).requestFocus(_descriptionFocusNode);
                        },
                        onSaved: (value) {
                          print('onSaved title = $value');
                          _title = value;
                        },
                        validator: (value) {
                          if (value.length == 0) {
                            return "Title field is Required";
                          }else {
                            return null;
                          }
                          //returning null means no error occurred. if there are any error then simply return a string
                        },
                      ),
                      Consumer<FeedProvider>(
                        builder: (ctx, feedProvider, _) {
                          if (feedProvider.validationErrors.containsKey('title')) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text(
                                "${feedProvider.validationErrors['title'][0].toString()}",
                                style: TextStyle(color: Colors.red),
                              ),
                            );
                          }
                          return SizedBox.shrink();
                        },
                      ),
                      SizedBox(height: 40,),
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
                        decoration: _customInputDecoration(labelText: 'What’s on your mind?', icon: Icons.perm_identity),
                        style:  TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.1,
                          color: themeController.isDarkMode?Colors.white:Colors.black,
                        ),
                        cursorColor: MateColors.activeIcons,
                        textInputAction: TextInputAction.newline,
                        minLines: 3,
                        maxLines: 8,
                        // maxLength: 512,
                        // onChanged: (value){
                        //   descriptionLength = value.length;
                        //   setState(() {});
                        // },
                        onFieldSubmitted: (val) {
                          print('onFieldSubmitted :: description = $val');
                          FocusScope.of(context).requestFocus(_locationFocusNode);
                        },
                        onSaved: (value) {
                          print('onSaved lastName = $value');
                          _description = value;
                        },
                        validator: (value) {
                          if (value.length == 0) {
                            return "Description field is Required";
                          }else {
                            return null;
                          }
                        },
                      ),
                      Consumer<FeedProvider>(
                        builder: (ctx, feedProvider, _) {
                          if (feedProvider.validationErrors.containsKey('description')) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text(
                                "${feedProvider.validationErrors['description'][0].toString()}",
                                style: TextStyle(color: Colors.red),
                              ),
                            );
                          }
                          return SizedBox.shrink();
                        },
                      ),




                      SizedBox(height: 40,),
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
                        // focusNode: _locationFocusNode,
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
                        onFieldSubmitted: (val) {
                          print('onFieldSubmitted :: _hyperlinkText = $val');
                        },
                        onSaved: (value) {
                          print('onSaved _hyperlinkText = $value');
                          _hyperlinkText = value;
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
                      // Padding(
                      //   padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 10.0),
                      //   child: Text(
                      //     "Hyperlink URL",
                      //     style: TextStyle(fontSize: 13.3.sp, color: MateColors.activeIcons),
                      //   ),
                      // ),
                      TextFormField(
                        // focusNode: _locationFocusNode,
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
                        onFieldSubmitted: (val) {
                          print('onFieldSubmitted :: _hyperlink = $val');
                        },
                        onSaved: (value) {
                          print('onSaved _hyperlink = $value');
                          _hyperlink = value;
                        },
                        validator: (value) {
                          return null;
                        },
                      ),
                      // Padding(
                      //   padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 10.0),
                      //   child: Text(
                      //     "Location and Time",
                      //     style: TextStyle(fontSize: 13.3.sp, color: MateColors.activeIcons),
                      //   ),
                      // ),
                      // TextFormField(
                      //   focusNode: _locationFocusNode,
                      //   decoration: _customInputDecoration(labelText: 'Location', icon: Icons.location_on),
                      //   style: TextStyle(color: Colors.white, fontSize: 15.0.sp),
                      //   cursorColor: MateColors.activeIcons,
                      //   textInputAction: TextInputAction.done,
                      //   maxLength: 100,
                      //   onFieldSubmitted: (val) {
                      //     print('onFieldSubmitted :: location = $val');
                      //   },
                      //   onSaved: (value) {
                      //     print('onSaved displayName = $value');
                      //     _location = value;
                      //   },
                      //   validator: (value) {
                      //     return null;
                      //   },
                      // ),

                      Consumer<FeedProvider>(
                        builder: (ctx, feedProvider, _) {
                          if (feedProvider.validationErrors.containsKey('location')) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text(
                                "${feedProvider.validationErrors['location'][0].toString()}",
                                style: TextStyle(color: Colors.red),
                              ),
                            );
                          }
                          return SizedBox.shrink();
                        },
                      ),
                      //SizedBox(height: 30,),
                      Padding(
                        padding: EdgeInsets.fromLTRB(8.0, 30.0, 8.0, 10.0),
                        child: Text(
                          "Tags",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.1,
                            color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                          ),
                        ),
                      ),
                     SizedBox(height: 5,),
                      Consumer<FeedProvider>(
                        builder: (ctx, feedProvider, _) {
                          if(feedProvider.feedTypeList.isNotEmpty){
                            if(feedInsertFirstCheck){
                              feedProvider.feedTypeList.forEach((element) {
                                feedTypeChek.add(false);
                                feedTypeId.add(element.id);
                              });
                              feedInsertFirstCheck=false;
                            }

                            return Column(
                              children: [
                                Wrap(
                                  spacing: 10,
                                  runSpacing: 10,
                                children: List.generate(feedProvider.feedTypeList.length+1, (index) =>
                                index==feedProvider.feedTypeList.length?
                                InkWell(
                                    onTap: (){
                                      feedTypeOtherCheck=!feedTypeOtherCheck;
                                      print(feedTypeOtherCheck);
                                      setState(() {});
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 18,vertical: 6),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color: feedTypeOtherCheck? MateColors.activeIcons:themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightDivider,
                                        //border: Border.all(color: e.value.isSelected?AppColors.primaryColor:AppColors.lightBlueBorder,width: 1),
                                      ),
                                      child: Text("Others",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          letterSpacing: 0.1,
                                          color:
                                          themeController.isDarkMode?
                                          feedTypeOtherCheck?MateColors.blackTextColor:Colors.white:
                                          feedTypeOtherCheck?
                                          Colors.white:MateColors.blackTextColor,
                                        ),
                                      ),
                                    )):
                                    InkWell(
                                        onTap: (){
                                          feedTypeChek[index]=!feedTypeChek[index];
                                          feedTypeOtherCheck=false;
                                          setState(() {});
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 18,vertical: 6),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(25),
                                            color: feedTypeChek[index]? MateColors.activeIcons:themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightDivider,
                                            //border: Border.all(color: e.value.isSelected?AppColors.primaryColor:AppColors.lightBlueBorder,width: 1),
                                          ),
                                          child: Text(feedProvider.feedTypeList[index].name,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              letterSpacing: 0.1,
                                              color:
                                              themeController.isDarkMode?
                                              feedTypeChek[index]?MateColors.blackTextColor:Colors.white:
                                              feedTypeChek[index]?
                                              Colors.white:MateColors.blackTextColor,
                                            ),
                                          ),
                                        ))
                                ),
                                ),

                                      Visibility(
                                        visible: feedTypeOtherCheck,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(5.0,20.0,5.0,0.0),
                                          child: TextFormField(
                                            controller: _otherFeedType,
                                            decoration: _customInputDecoration(labelText: 'Enter Other Type',),
                                            style:  TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0.1,
                                              color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
                                            ),
                                            cursorColor: MateColors.activeIcons,
                                            textInputAction: TextInputAction.done,
                                            maxLength: 12,
                                            validator: (value) {
                                              return null;
                                            },
                                          ),
                                        ),
                                      )



                                //   Container(
                                //   padding: EdgeInsets.fromLTRB(3, 0, 3, 12),
                                //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0), border: Border.all(color: Colors.grey, width: 0.3)),
                                //   child: Column(
                                //     children: [
                                //       GridView.builder(
                                //         physics: ScrollPhysics(),
                                //         shrinkWrap: true,
                                //         itemCount: feedProvider.feedTypeList.length + 1,
                                //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                //           crossAxisCount: 2,
                                //           mainAxisSpacing: 8,
                                //           crossAxisSpacing: 8,
                                //           childAspectRatio: 10 / 3,
                                //         ),
                                //         itemBuilder: (context, index) {
                                //           if(index==feedProvider.feedTypeList.length){
                                //             return CheckboxListTile(
                                //               activeColor: MateColors.activeIcons,
                                //               checkColor: Colors.black,
                                //               contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
                                //               title: Text(
                                //                 "Other",
                                //                 style: TextStyle(
                                //                   fontSize: 12.5.sp,
                                //                   color: Colors.white70,
                                //                   fontWeight: FontWeight.w500,
                                //                 ),
                                //               ),
                                //               value: feedTypeOtherCheck,
                                //               onChanged: (newValue) {
                                //                 feedTypeOtherCheck=newValue;
                                //                 // for(int i=0;i<feedTypeChek.length;i++){
                                //                 //   feedTypeChek[i]=false;
                                //                 // }
                                //                 setState(() {});
                                //               },
                                //               controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
                                //             );
                                //           }else{
                                //             return CheckboxListTile(
                                //               activeColor: MateColors.activeIcons,
                                //               checkColor: Colors.black,
                                //               contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
                                //               title: Text(
                                //                 feedProvider.feedTypeList[index].name,
                                //                 style: TextStyle(
                                //                   fontSize: 12.5.sp,
                                //                   color: Colors.white70,
                                //                   fontWeight: FontWeight.w500,
                                //                 ),
                                //               ),
                                //               value: feedTypeChek[index]??false,
                                //               onChanged: (newValue) {
                                //                 feedTypeChek[index]=newValue;
                                //                 feedTypeOtherCheck=false;
                                //                 setState(() {});
                                //               },
                                //               controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
                                //             );
                                //           }
                                //         },
                                //       ),
                                //       Visibility(
                                //         visible: feedTypeOtherCheck,
                                //         child: Padding(
                                //           padding: const EdgeInsets.fromLTRB(10.0,8.0,10.0,0.0),
                                //           child: TextFormField(
                                //             controller: _otherFeedType,
                                //             decoration: _customInputDecoration(labelText: 'Enter Other Type',),
                                //             style:  TextStyle(
                                //               fontSize: 14,
                                //               fontWeight: FontWeight.w500,
                                //               letterSpacing: 0.1,
                                //               color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
                                //             ),
                                //             cursorColor: MateColors.activeIcons,
                                //             textInputAction: TextInputAction.done,
                                //             maxLength: 12,
                                //             validator: (value) {
                                //               return null;
                                //             },
                                //           ),
                                //         ),
                                //       )
                                //     ],
                                //   ),
                                // ),


                              ],
                            );




                          }else return SizedBox();

                        },
                      ),

                      // InkWell(
                      //   onTap: () {
                      //     FocusScope.of(context).unfocus();
                      //   },
                      //   child: _dropdownMenuItems(),
                      // ),
                      Consumer<FeedProvider>(
                        builder: (ctx, feedProvider, _) {
                          if (feedProvider.validationErrors.containsKey('feed_type_id')) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 8, top: 5),
                              child: Text(
                                "${feedProvider.validationErrors['feed_type_id'][0].toString()}",
                                style: TextStyle(color: Colors.red),
                              ),
                            );
                          }
                          return SizedBox.shrink();
                        },
                      ),
                      /*_toggleStartDate
                          ? Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: _startDatePicker(),
                            )
                          : SizedBox.shrink(),
                      Padding(
                        padding: EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 8.0),
                        child: Text(
                          "Start",
                          style: TextStyle(fontSize: 16, color: MateColors.activeIcons),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RaisedButton(
                            color: MateColors.activeIcons,
                            onPressed: () {
                              setState(() {
                                _toggleStartDate = !_toggleStartDate;
                              });
                            },
                            child: Text(_toggleStartDate ? 'Selct Start Date' : 'Set Start Date'),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 1.0, color: Colors.white38),
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: _startDate == null
                                  ? Text(
                                      "YYYY-MM-DD  hh : mm",
                                      style: TextStyle(color: Colors.grey),
                                    )
                                  : Text(
                                      "${_startDate.year}-${_startDate.month}-${_startDate.day} ${_startDate.hour}:${_startDate.minute}",
                                      style: TextStyle(color: Colors.white),
                                    ),
                            ),
                          ),
                        ],
                      ),
                      _toggleEndDate
                          ? Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: _endDatePicker(),
                            )
                          : SizedBox.shrink(),
                      Padding(
                        padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                        child: Text(
                          "End",
                          style: TextStyle(fontSize: 16, color: MateColors.activeIcons),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RaisedButton(
                            color: MateColors.activeIcons,
                            onPressed: () {
                              setState(() {
                                _toggleEndDate = !_toggleEndDate;
                              });
                            },
                            child: Text(_toggleEndDate ? "Select End Date" : 'Set End Date'),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 1.0, color: Colors.white38),
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: _endDate == null
                                  ? Text(
                                      'YYYY-MM-DD  hh : mm',
                                      style: TextStyle(color: Colors.grey),
                                    )
                                  : Text(
                                      "${_endDate.year}-${_endDate.month}-${_endDate.day} ${_endDate.hour}:${_endDate.minute}",
                                      style: TextStyle(color: Colors.white),
                                    ),
                            ),
                          ),
                        ],
                      ),*/
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0, top: 5),
                        child: _imageSelectionButton(),
                      ),
                      Consumer<FeedProvider>(
                        builder: (ctx, fp, _) {
                          if (fp.validationErrors.containsKey('media.0')) {
                            return Text("${fp.validationErrors['media.0'][0].toString()}", style: TextStyle(color: Colors.red));
                          }
                          return SizedBox.shrink();
                        },
                      ),
                      _image != null
                          ? Stack(
                        clipBehavior: Clip.none,
                        children: [
                          InkWell(
                            // onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => CommentFullImage(imageFilePath: _image,),)),
                            child: Container(
                                clipBehavior: Clip.hardEdge,
                                // width: 100,
                                // height: 300,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), border: Border.all(color: Colors.grey, width: 0.3)),
                                padding: EdgeInsets.all(5),
                                margin: EdgeInsets.only(left: 0, bottom: 10),
                                child: Image.file(
                                  _image,
                                  fit: BoxFit.fill,
                                )),
                          ),
                          Positioned(
                            top: -5,
                            right: -5,
                            child: InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () {
                                setState(() {
                                  _image = null;
                                  _base64encodedImage = null;
                                });
                              },
                              child: SizedBox(
                                width: 35,
                                height: 35,
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: CircleAvatar(
                                    backgroundColor: myHexColor,
                                    radius: 11,
                                    child: ImageIcon(
                                      AssetImage("lib/asset/icons/cross.png"),
                                      size: 22,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ):SizedBox(),
                    ],
                  ),
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

  SizedBox _endDatePicker() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );

    return SizedBox(
      height: 200,
      child: CupertinoDatePicker(
        backgroundColor: Colors.white,
        initialDateTime: DateTime.now(),
        onDateTimeChanged: (val) {
          print("${val.toString()}");
          _endDate = val;
        },
      ),
    );
  }

  SizedBox _startDatePicker() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );

    return SizedBox(
      height: 200,
      child: CupertinoDatePicker(
        backgroundColor: Colors.white,
        initialDateTime: DateTime.now(),
        onDateTimeChanged: (val) {
          print("${val.toString()} and type is ${val.runtimeType}");
          _startDate = val;
        },
      ),
    );
  }

  Widget _imageSelectionButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 40,bottom: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          GestureDetector(
            onTap: ()async{
              final pickedFile = await picker.getImage(source: ImageSource.gallery,imageQuality: 70);
              if (pickedFile != null) {
                _image = File(pickedFile.path);

                var img = _image.readAsBytesSync();

                _base64encodedImage = base64Encode(img);
                setState(() {});

                print('image selected:: ${_base64encodedImage.toString()}');
              } else {
                print('No image selected.');
              }
            },
            child: Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: themeController.isDarkMode?MateColors.darkDivider:MateColors.lightDivider,
              ),
              child: Center(
                child: Image.asset(
                  "lib/asset/icons/galleryPlus.png",
                  height: 20,
                  width: 20,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          // GestureDetector(
          //   onTap: ()async{
          //     final pickedFile = await picker.getVideo(source: ImageSource.gallery,);
          //     if (pickedFile != null) {
          //       _image = File(pickedFile.path);
          //
          //       var img = _image.readAsBytesSync();
          //
          //       _base64encodedImage = base64Encode(img);
          //       setState(() {});
          //
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
          //     child: Icon(
          //         Icons.video_call,
          //         color: MateColors.activeIcons,
          //         size: 30,
          //       ),
          //   ),
          // ),
          _submitButton(context),
        ],
      ),
    );
  }
}
