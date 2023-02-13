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
import '../../../Model/FeedItem.dart';
import '../../../controller/theme_controller.dart';
import '../HomeScreen.dart';

class EditFeedPost extends StatefulWidget {
  final int id;
  final String title;
  final String description;
  final String link;
  final String linkText;
  final String imageUrl;
  final List<FeedTypes> feedType;
  static final String routeName = 'create-post';
  const EditFeedPost({Key key, this.id, this.title, this.description, this.link, this.linkText, this.imageUrl, this.feedType}) : super(key: key);

  @override
  _EditFeedPostState createState() => _EditFeedPostState();
}

class _EditFeedPostState extends State<EditFeedPost> {
  final _formKey = GlobalKey<FormState>();
  FocusNode focusNode= FocusNode();
  FocusNode _descriptionFocusNode = FocusNode();
  FocusNode _locationFocusNode = FocusNode();
  ScrollController _scrollController = ScrollController();
  int _id;
  String _title;
  String _description;
  String _location;
  String _hyperlinkText;
  String _hyperlink;
  TextEditingController _otherFeedType = new TextEditingController(text: "");
  File _image;
  String _base64encodedImage;
  final picker = ImagePicker();
  List<bool> feedTypeChek = [];
  bool feedTypeOtherCheck = false;
  List<String> feedTypeId = [];
  bool feedInsertFirstCheck=true;
  DateTime _startDate;
  DateTime _endDate;
  ThemeController themeController = Get.find<ThemeController>();
  int titleLength= 0;
  int descriptionLength= 0;
  int linkLength= 0;
  int linkTextLength= 0;
  bool isLoading = false;
  //List<FeedTypes> feedType;
  List<String> feedTypeName =[];
  String _imageUrl = "";
  bool imageDeleted = false;

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
    setPreviousData();
    focusNode.requestFocus();
    Future.delayed(Duration(seconds: 1), () {
      Provider.of<FeedProvider>(context, listen: false).fetchFeedTypes();
    });
    super.initState();
  }

  void setPreviousData(){
    _id = widget.id;
    _title = widget.title;
    _description = widget.description;
    _hyperlink = widget.link;
    _hyperlinkText = widget.linkText;
    _imageUrl = widget.imageUrl??"";
    for(int i=0;i<widget.feedType.length;i++){
      feedTypeName.add(widget.feedType[i].type.name);
    }
    //feedTypeName = widget.feedType.map((e) => e.name);
    setState(() {});
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

      bool updated = await Provider.of<FeedProvider>(context, listen: false).updateFeed(
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
          feedId: _id,
          imageDeleted: imageDeleted && _image==null,
      );

      if (updated) {
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen(index: 0,)));
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
  }

  Consumer<FeedProvider> _submitButton(BuildContext context) {
    return Consumer<FeedProvider>(
      builder: (ctx, feedProvider, _) {
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
                    }
                  } else
                    Fluttertoast.showToast(msg: " Select Feed Type ", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
                },
                child: Text("Update",
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
      },
    );
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
                "Edit Post",
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
                          initialValue: _title,
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
                          initialValue: _description,
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
                          initialValue: _hyperlinkText,
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
                          //maxLength: 100,
                          onChanged: (value){
                            linkTextLength = value.length;
                            _hyperlinkText = value;
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
                          initialValue: _hyperlink,
                          decoration: _customInputDecoration(labelText: 'Link', icon: Icons.location_on),
                          style:  TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.1,
                            color: themeController.isDarkMode?Colors.white:Colors.black,
                          ),
                          cursorColor: MateColors.activeIcons,
                          textInputAction: TextInputAction.done,
                          //maxLength: 100,
                          onChanged: (value){
                            linkLength = value.length;
                            _hyperlink = value;
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
                                Future.delayed(Duration(seconds: 1),(){
                                  print(feedTypeName);
                                  List<String> mainName = [];
                                  for(int i=0;i<feedProvider.feedTypeList.length;i++){
                                    mainName.add(feedProvider.feedTypeList[i].name);
                                    if(feedTypeName.contains(feedProvider.feedTypeList[i].name)){
                                      feedTypeChek[i] = true;
                                      feedTypeId[i] = feedProvider.feedTypeList[i].id;
                                    }
                                  }
                                  for(int i=0;i<feedTypeName.length;i++){
                                    if(!mainName.contains(feedTypeName[i])){
                                      _otherFeedType.text = feedTypeName[i];
                                      feedTypeOtherCheck = true;
                                    }
                                  }
                                  setState(() {});
                                });
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
                        _image != null || _imageUrl!=""
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
                                  child: _image != null?
                                  Image.file(
                                    _image,
                                    fit: BoxFit.fill,
                                  ):Image.network(_imageUrl,fit: BoxFit.fill,)
                              ),
                            ),
                            Positioned(
                              top: -5,
                              right: -5,
                              child: InkWell(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () {
                                  setState(() {
                                    if(_imageUrl.isNotEmpty){
                                      _imageUrl = "";
                                      imageDeleted = true;
                                    }else{
                                      _image = null;
                                      _base64encodedImage = null;
                                    }
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
                                      child: _imageUrl!=""?
                                          Icon(Icons.delete,size: 16,
                                            color: Colors.white70,) :
                                      ImageIcon(
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
                _imageUrl = "";

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
          _submitButton(context),
        ],
      ),
    );
  }
}
