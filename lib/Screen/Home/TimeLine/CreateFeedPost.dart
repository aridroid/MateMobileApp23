import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:mate_app/Providers/FeedProvider.dart';
import 'package:mate_app/Utility/Utility.dart';
import 'package:mate_app/Widget/loader.dart';
import 'package:mate_app/asset/Colors/MateColors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../constant.dart';
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
  String _title;
  String _description;
  String _location;
  String _hyperlinkText;
  String _hyperlink;
  TextEditingController _otherFeedType = new TextEditingController(text: "");
  File _image;
  String _base64encodedImage;
  final picker = ImagePicker();
  FocusNode _descriptionFocusNode = FocusNode();
  FocusNode _locationFocusNode = FocusNode();
  List<bool> feedTypeChek = [];
  bool feedTypeOtherCheck = false;
  List<String> feedTypeId = [];
  bool feedInsertFirstCheck=true;
  DateTime _startDate;
  DateTime _endDate;
  ScrollController _scrollController = ScrollController();
  ThemeController themeController = Get.find<ThemeController>();
  int titleLength= 0;
  int descriptionLength= 0;
  int linkLength= 0;
  int linkTextLength= 0;
  bool isLoading = false;

  @override
  void initState() {
    focusNode.requestFocus();
    Future.delayed(Duration(seconds: 1), () {
      Provider.of<FeedProvider>(context, listen: false).fetchFeedTypes();
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _descriptionFocusNode.dispose();
    _locationFocusNode.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void _submitForm(BuildContext context) async {
    FocusScope.of(context).unfocus();
    bool validated = _formKey.currentState.validate();
    if (validated) {
      setState(() {
        isLoading = true;
      });
      _formKey.currentState.save();
      List<String> feedTypeIdFinal = [];
      for(int i=0;i<feedTypeChek.length;i++){
        if(feedTypeChek[i]){
          feedTypeIdFinal.add(feedTypeId[i]);
        }
      }
      bool updated = await Provider.of<FeedProvider>(context, listen: false).postFeed(
          id: feedTypeIdFinal.isNotEmpty? feedTypeIdFinal : null,
          feedTypeOther: (feedTypeOtherCheck==true)?_otherFeedType.text.trim():null,
          title: _title,
          description: _description,
          location: _location,
          hyperlink: _hyperlink,
          hyperlinkText: _hyperlinkText,
          startDate: _startDate != null ? _startDate.toString() : null,
          endDate: _endDate != null ? _endDate.toString() : null,
          image: _base64encodedImage != null ? _base64encodedImage : null,
      );

      if (updated) {
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen(index: 0,)));
      } else {
      }
    }
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

  Consumer<FeedProvider> _submitButton(BuildContext context) {
    return Consumer<FeedProvider>(
      builder: (ctx, feedProvider, _) {
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
                FocusScope.of(context).unfocus();
                _formKey.currentState.save();
                if (feedTypeChek.any((element) => element == true || feedTypeOtherCheck)) {
                  if(feedTypeOtherCheck && _otherFeedType.text.trim().isEmpty){
                    Fluttertoast.showToast(msg: " Enter Other Feed Type ", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
                  }else{
                    _submitForm(ctx);
                  }
                } else
                  Fluttertoast.showToast(msg: " Select Feed Type ", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
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
                                                style: TextStyle(
                                                  decoration: TextDecoration.none,
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: 'Poppins',
                                                ),
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
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Poppins',
                                      color: themeController.isDarkMode?Colors.white: Colors.black,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10,),
                                TextFormField(
                                  scrollPadding: const EdgeInsets.all(0.0),
                                  focusNode: focusNode,
                                  decoration: _customInputDecoration(labelText: 'Title', icon: Icons.title),
                                  cursorColor: themeController.isDarkMode?MateColors.helpingTextDark:MateColors.helpingTextLight,
                                  style:  TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.1,
                                    color: themeController.isDarkMode?Colors.white:Colors.black,
                                  ),
                                  textInputAction: TextInputAction.next,
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
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Poppins',
                                      color: themeController.isDarkMode?Colors.white: Colors.black,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10,),
                                TextFormField(
                                  decoration: _customInputDecoration(labelText: 'What’s on your mind?', icon: Icons.perm_identity),
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
                                          fontSize: 16,
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
                                          fontSize: 16,
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
                                Padding(
                                  padding: EdgeInsets.fromLTRB(8.0, 30.0, 8.0, 10.0),
                                  child: Text(
                                    "Tags",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Poppins',
                                      color: themeController.isDarkMode?Colors.white: Colors.black,
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
                                                  color: feedTypeOtherCheck?
                                                  themeController.isDarkMode? MateColors.appThemeDark:MateColors.appThemeLight:
                                                  themeController.isDarkMode?MateColors.smallContainerDark:MateColors.smallContainerLight,
                                                ),
                                                child: Text("Others",
                                                  style: TextStyle(
                                                    fontFamily: "Poppins",
                                                    fontSize: 14,
                                                    color: themeController.isDarkMode?
                                                    feedTypeOtherCheck? Colors.black: Colors.white:
                                                    feedTypeOtherCheck?
                                                    Colors.white:Colors.black,
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
                                                      color: feedTypeChek[index]?
                                                      themeController.isDarkMode? MateColors.appThemeDark:MateColors.appThemeLight:
                                                      themeController.isDarkMode?MateColors.smallContainerDark:MateColors.smallContainerLight,
                                                    ),
                                                    child: Text(feedProvider.feedTypeList[index].name,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontFamily: "Poppins",
                                                        color: themeController.isDarkMode?
                                                        feedTypeChek[index]?Colors.black:Colors.white:
                                                        feedTypeChek[index]?
                                                        Colors.white:Colors.black,
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
                                                      cursorColor: themeController.isDarkMode?MateColors.helpingTextDark:MateColors.helpingTextLight,
                                                      style:  TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w500,
                                                        letterSpacing: 0.1,
                                                        color: themeController.isDarkMode?Colors.white:Colors.black,
                                                      ),
                                                      textInputAction: TextInputAction.done,
                                                      maxLength: 12,
                                                      validator: (value) {
                                                        return null;
                                                      },
                                                    ),
                                                  ),
                                                ),
                                        ],
                                      );
                                    }else return SizedBox();
                                  },
                                ),
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
                                _image != null ?
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    InkWell(
                                      child: Container(
                                          clipBehavior: Clip.hardEdge,
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
          _submitButton(context),
          SizedBox(
            width: 5,
          ),
        ],
      ),
    );
  }
}
