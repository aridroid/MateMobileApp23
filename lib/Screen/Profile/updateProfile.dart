import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../Providers/AuthUserProvider.dart';
import '../../Services/AuthUserService.dart';
import '../../Widget/loader.dart';
import '../../asset/Colors/MateColors.dart';
import '../../constant.dart';
import '../../controller/theme_controller.dart';
import 'package:mate_app/Model/universityListingModel.dart';

import '../Home/HomeScreen.dart';

class UpdateProfile extends StatefulWidget {
  final String photoUrl;
  final String coverPhotoUrl;
  final String fullName;
  final int? universityId;
  final String? about;
  final String uuid;
  final bool isGoToHome;
  const UpdateProfile({Key? key,this.isGoToHome = false ,required this.photoUrl, required this.coverPhotoUrl, required this.fullName, this.universityId, this.about, required this.uuid}) : super(key: key);

  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  ThemeController themeController = Get.find<ThemeController>();
  late TextEditingController fullNameController;
  TextEditingController? aboutController;
  TextEditingController universityController = TextEditingController();
  String imageSource = "Camera";
  final picker = ImagePicker();
  String profileImage ="";
  String coverImage= "";
  File? _profileImage;
  File? _coverImage;
  String? _base64encodedImageForProfilePic;
  String? _base64encodedImageForCoverPIc;
  final formKey = GlobalKey<FormState>();
  AuthUserService authUserService = AuthUserService();
  bool isLoading = false;
  String? universityId;
  List<Datum> universityList = [];
  late String token;

  @override
  void initState(){
    fullNameController = TextEditingController(text: widget.fullName);
    aboutController = TextEditingController(text: widget.about??"");
    profileImage = widget.photoUrl;
    coverImage = widget.coverPhotoUrl;
    print("///////////////////////");
    print(Provider.of<AuthUserProvider>(context, listen: false).authUser.universityId);
    getStoredValue();
    super.initState();
  }

  getStoredValue()async{
    if(widget.about==null || widget.about==""){
      print("======Fetch user about data========");
      Future.delayed(Duration(seconds: 0), () async{
        await Provider.of<AuthUserProvider>(context, listen: false).getUserInfo(widget.uuid);
        if(Provider.of<AuthUserProvider>(context, listen: false).userAboutDataLoader==false){
          aboutController!.text = Provider.of<AuthUserProvider>(context, listen: false).userAboutData!.data!.about??"";
          setState(() {});
        }
      });
    }
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("tokenApp")!;
    log(token);
    universityList = await authUserService.getUniversityList(token: token);
    print(universityList);
    if(widget.universityId!=null){
      universityId = widget.universityId.toString();
      print(universityId);
      for(int i=0;i<universityList.length;i++){
        if(universityList[i].id == int.parse(universityId!)){
          universityController.text = universityList[i].name!;
        }
      }
    }
    setState(() {});
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
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height*0.07,
                      left: 16,
                      right: 6,
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
                          "Update Profile",
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
                    child: Form(
                      key: formKey,
                      child: ListView(
                        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        children: [
                          Center(
                            child: Container(
                              height: 100,
                              width: 100,
                              margin: EdgeInsets.only(top: scH*0.04),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightButtonBackground,
                              ),
                              child: GestureDetector(
                                onTap: ()=>modalSheetForProfilePic(),
                                child: DottedBorder(
                                  color: MateColors.activeIcons,
                                  strokeWidth: 1,
                                  dashPattern: [10, 6, 10, 6],
                                  borderType: BorderType.Circle,
                                  child: profileImage==""?
                                  Center(
                                    child: Image.asset("lib/asset/icons/galleryPlus.png",height: 22,),
                                  ):
                                  profileImage.contains("http")?
                                  Center(
                                    child: CircleAvatar(
                                      radius: 60,
                                      backgroundImage: NetworkImage(profileImage),
                                    ),
                                  ):
                                  Center(
                                    child: CircleAvatar(
                                      radius: 60,
                                      backgroundImage: FileImage(File(profileImage)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 2),
                            child: Text(
                              "Full name",
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
                            controller: fullNameController,
                            keyboardType: TextInputType.text,
                            autofocus: false,
                            maxLines: 1,
                            cursorColor: themeController.isDarkMode?MateColors.helpingTextDark:MateColors.helpingTextLight,
                            style:  TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.1,
                              color: themeController.isDarkMode?Colors.white:Colors.black,
                            ),
                            validator: validateTextField,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                                color: themeController.isDarkMode?MateColors.helpingTextDark:MateColors.helpingTextLight,
                              ),
                              hintText: "Your full name",
                              fillColor: themeController.isDarkMode ? MateColors.containerDark : MateColors.containerLight,
                              filled: true,
                              focusedBorder: commonBorder,
                              enabledBorder: commonBorder,
                              disabledBorder: commonBorder,
                              errorBorder: commonBorder,
                              focusedErrorBorder: commonBorder,
                            ),
                          ),
                          SizedBox(height: 40,),
                          Padding(
                            padding: const EdgeInsets.only(left: 2),
                            child: Text(
                              "University or organization",
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
                            padding: EdgeInsets.only(top: 10),
                            decoration: ShapeDecoration(
                              color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(14)),
                              ),
                            ),
                            child: DropdownSearch<Datum>(
                              mode: Mode.MENU,
                              showSelectedItems: false,
                              dropdownButtonProps: IconButtonProps(
                                padding: EdgeInsets.only(bottom: 5),
                                icon: Icon(Icons.keyboard_arrow_down_sharp,size: 20),
                                color: themeController.isDarkMode?MateColors.iconDark:MateColors.iconLight,
                              ),
                              dropdownBuilder: (context,data){
                                return Padding(
                                  padding: const EdgeInsets.only(left: 16),
                                  child: Text(universityController.text.isEmpty?"Pick one":universityController.text,
                                    style:  TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.1,
                                      color: themeController.isDarkMode?Colors.white:Colors.black,
                                    ),
                                  ),
                                );
                              },
                              showSearchBox: true,
                              items: universityList,
                              itemAsString: (Datum? u) => u!.name!,
                              dropdownSearchDecoration: InputDecoration(
                                hintText: universityController.text.isEmpty?"Pick one":universityController.text,
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.1,
                                  color: themeController.isDarkMode?Colors.white:Colors.black,
                                ),
                                border: InputBorder.none,
                              ),
                              onChanged: (value){
                                universityController.text = value!.name!;
                                for(int i=0;i<universityList.length;i++){
                                  if(universityList[i].name == value.name){
                                    universityId = universityList[i].id.toString();
                                  }
                                }
                                print(universityId);
                                setState(() {});
                              },
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 2),
                            child: Text(
                              "About",
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
                            controller: aboutController,
                            keyboardType: TextInputType.text,
                            autofocus: false,
                            maxLines: 1,
                            cursorColor: themeController.isDarkMode?MateColors.helpingTextDark:MateColors.helpingTextLight,
                            style:  TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.1,
                              color: themeController.isDarkMode?Colors.white:Colors.black,
                            ),
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                                color: themeController.isDarkMode?MateColors.helpingTextDark:MateColors.helpingTextLight,
                              ),
                              hintText: "About",
                              fillColor: themeController.isDarkMode ? MateColors.containerDark : MateColors.containerLight,
                              filled: true,
                              focusedBorder: commonBorder,
                              enabledBorder: commonBorder,
                              disabledBorder: commonBorder,
                              errorBorder: commonBorder,
                              focusedErrorBorder: commonBorder,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 2,top: 40),
                            child: Text(
                              "Banner image",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Poppins',
                                color: themeController.isDarkMode?Colors.white: Colors.black,
                              ),
                            ),
                          ),
                          Container(
                            height: 112,
                            margin: EdgeInsets.only(top: scH*0.01),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightButtonBackground,
                            ),
                            child: GestureDetector(
                              onTap: ()=> modalSheetForCoverPic(),
                              child: DottedBorder(
                                color: MateColors.activeIcons,
                                strokeWidth: 1,
                                dashPattern: [10, 6, 10, 6],
                                radius: Radius.circular(16),
                                borderType: BorderType.RRect,
                                child: coverImage ==""?
                                Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset("lib/asset/icons/galleryPlus.png",height: 22,),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "Select image",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.1,
                                          color: MateColors.activeIcons,
                                        ),
                                      ),
                                    ],
                                  ),
                                ):coverImage.contains("http")?
                                Container(
                                  height: 112,
                                  width: scW,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.network(coverImage),
                                  ),
                                ):
                                Container(
                                  height: 112,
                                  width: scW,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.file(File(coverImage),fit: BoxFit.fitWidth),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 56,
                            margin: EdgeInsets.only(top: 50,left: 0,right: 0,bottom: 15),
                            width: 160,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: MateColors.activeIcons,
                                onPrimary: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              ),
                              onPressed: ()async{
                                if(formKey.currentState!.validate()){
                                  if(universityId!=""||universityId!=null){
                                    String? firstName,lastName;
                                    var names;
                                    if(fullNameController.text.contains(" ")){
                                      names = fullNameController.text.split(' ');
                                    }else{
                                      names = fullNameController.text.split(' ');
                                    }
                                    if(names.length>=2){
                                      for(int i=0;i<names.length-1;i++){
                                        if(firstName==null){
                                          firstName = names[i];
                                        }else{
                                          firstName = firstName + " " + names[i];
                                        }
                                      }
                                      lastName = names.last;
                                    }else{
                                      firstName = fullNameController.text;
                                      lastName = " ";
                                    }
                                    print(firstName);
                                    print(lastName);
                                    print(fullNameController.text);
                                    setState(() {
                                      isLoading = true;
                                    });
                                    if(profileImage!=""){
                                      if(!profileImage.contains("http")){
                                        Provider.of<AuthUserProvider>(context, listen: false).updatePhoto(imageFile: _base64encodedImageForProfilePic!);
                                      }
                                    }
                                    if(coverImage!=""){
                                      if(!coverImage.contains("http")){
                                        Provider.of<AuthUserProvider>(context, listen: false).updateCoverPhoto(imageFile: _base64encodedImageForCoverPIc!);
                                      }
                                    }
                                    if(aboutController!.text!=null && aboutController!.text!=""){
                                      Map<String, dynamic> _body = {
                                        "uuid": widget.uuid,
                                        "about": aboutController!.text,
                                      };
                                      await Provider.of<AuthUserProvider>(context, listen: false).updateUserInfo(_body);
                                      Provider.of<AuthUserProvider>(context, listen: false).getUserInfo(widget.uuid);
                                    }else{
                                      Map<String, dynamic> _body = {
                                        "uuid": widget.uuid,
                                        "about": "",
                                      };
                                      await Provider.of<AuthUserProvider>(context, listen: false).updateUserInfo(_body);
                                      Provider.of<AuthUserProvider>(context, listen: false).getUserInfo(widget.uuid);
                                    }
                                    String response = await authUserService.updateUserProfile(
                                      firstName: firstName!,
                                      lastName: lastName!,
                                      displayName: fullNameController.text,
                                      universityId: universityId!,
                                      token: token,
                                    );
                                    if(response=="User profile updated."){
                                      await Provider.of<AuthUserProvider>(context, listen: false).getUserProfileData(saveToSharedPref: true);
                                      setState(() {
                                        isLoading = false;
                                      });
                                      Fluttertoast.showToast(msg: "Profile updated successfully", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
                                      if(widget.isGoToHome){
                                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen(index: 0,)));
                                      }else{
                                        Navigator.pop(context);
                                      }
                                    }else{
                                      setState(() {
                                        isLoading = false;
                                      });
                                      Fluttertoast.showToast(msg: "Something went wrong", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
                                    }
                                  }else{
                                    Fluttertoast.showToast(msg: "Please select university from drop down", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
                                  }
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("UPDATE",
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
                        ],
                      ),
                    ),
                  ),
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

  modalSheetForProfilePic() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15.0),
        ),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: 10.0,
                  ),
                  Center(
                    child: Text(
                      "Select image source",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor),
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () =>  _getProfileImage(2),
                        child: Column(
                          children: [
                            Image.asset(
                              "lib/asset/icons/cameraNew.png",
                              height: 25,
                              width: 25,
                              color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Camera",
                              style: TextStyle(fontSize: 11.7.sp, fontWeight: FontWeight.w500, color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor),
                            )
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () =>  _getProfileImage(1),
                        child: Column(
                          children: [
                            Image.asset(
                              "lib/asset/icons/galleryNew.png",
                              height: 25,
                              width: 25,
                              color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Gallery",
                              style: TextStyle(fontSize: 11.7.sp, fontWeight: FontWeight.w500, color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  // Theme(
                  //   data: ThemeData(
                  //     unselectedWidgetColor: MateColors.inActiveIcons, // Your color
                  //   ),
                  //   child: RadioListTile(
                  //     activeColor: MateColors.activeIcons,
                  //     contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
                  //     title: Text(
                  //       "Camera",
                  //       style: TextStyle(
                  //         fontSize: 12.5.sp,
                  //         color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                  //         fontWeight: FontWeight.w500,
                  //       ),
                  //     ),
                  //     value: "Camera",
                  //     groupValue: imageSource,
                  //     onChanged: (value) {
                  //       setState(() {
                  //         imageSource = value;
                  //         print(imageSource);
                  //       });
                  //     },
                  //   ),
                  // ),
                  // Theme(
                  //   data: ThemeData(
                  //     unselectedWidgetColor: MateColors.inActiveIcons, // Your color
                  //   ),
                  //   child: RadioListTile(
                  //     activeColor: MateColors.activeIcons,
                  //     contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
                  //     title: Text(
                  //       "Gallery",
                  //       style: TextStyle(
                  //         fontSize: 12.5.sp,
                  //         color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                  //         fontWeight: FontWeight.w500,
                  //       ),
                  //     ),
                  //     value: "Gallery",
                  //     groupValue: imageSource,
                  //     onChanged: (value) {
                  //       setState(() {
                  //         imageSource = value;
                  //         print(imageSource);
                  //       });
                  //     },
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 15.0,
                  // ),
                  // InkWell(
                  //   onTap: () {
                  //     if (imageSource == "Gallery") {
                  //       _getProfileImage(1);
                  //     } else {
                  //       _getProfileImage(2);
                  //     }
                  //   },
                  //   child: Container(
                  //     height: 40.0,
                  //     width: MediaQuery.of(context).size.width,
                  //     // margin: EdgeInsets.all(2),
                  //     alignment: Alignment.center,
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  //       boxShadow: <BoxShadow>[
                  //         BoxShadow(
                  //             color: Colors.transparent,
                  //             // offset: Offset(2, 4),
                  //             blurRadius: 5,
                  //             spreadRadius: 0)
                  //       ],
                  //       color: MateColors.activeIcons,
                  //       //gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Colors.teal, MateColors.activeIcons])
                  //     ),
                  //     child: Text(
                  //       'Continue',
                  //       style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w600, color: themeController.isDarkMode?MateColors.blackTextColor:Colors.white,),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future _getProfileImage(int option) async {
    PickedFile? pickImage;
    if (option == 1) {
      pickImage = await picker.getImage(source: ImageSource.gallery, imageQuality: 50);
    } else
      pickImage = await picker.getImage(source: ImageSource.camera, imageQuality: 50);

    if (pickImage != null) {

      setState(() {
        profileImage = pickImage!.path;
      });

      _profileImage = File(pickImage.path);

      var img = _profileImage!.readAsBytesSync();

      _base64encodedImageForProfilePic = base64Encode(img);

      print('image selected:: ${_profileImage.toString()}');

      //Provider.of<AuthUserProvider>(context, listen: false).updatePhoto(imageFile: _base64encodedImageForProfilePic);
    } else {
      print('No image selected.');
    }
    Navigator.of(context).pop();
  }

  modalSheetForCoverPic() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15.0),
        ),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: 10.0,
                  ),
                  Center(
                    child: Text(
                      "Select image source",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor),
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () =>  _getCoverImage(2),
                        child: Column(
                          children: [
                            Image.asset(
                              "lib/asset/icons/cameraNew.png",
                              height: 25,
                              width: 25,
                              color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Camera",
                              style: TextStyle(fontSize: 11.7.sp, fontWeight: FontWeight.w500, color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor),
                            )
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () =>  _getCoverImage(1),
                        child: Column(
                          children: [
                            Image.asset(
                              "lib/asset/icons/galleryNew.png",
                              height: 25,
                              width: 25,
                              color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Gallery",
                              style: TextStyle(fontSize: 11.7.sp, fontWeight: FontWeight.w500, color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  // Theme(
                  //   data: ThemeData(
                  //     unselectedWidgetColor: MateColors.inActiveIcons, // Your color
                  //   ),
                  //   child: RadioListTile(
                  //     activeColor: MateColors.activeIcons,
                  //     contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
                  //     title: Text(
                  //       "Camera",
                  //       style: TextStyle(
                  //         fontSize: 12.5.sp,
                  //         color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                  //         fontWeight: FontWeight.w500,
                  //       ),
                  //     ),
                  //     value: "Camera",
                  //     groupValue: imageSource,
                  //     onChanged: (value) {
                  //       setState(() {
                  //         imageSource = value;
                  //         print(imageSource);
                  //       });
                  //     },
                  //   ),
                  // ),
                  // Theme(
                  //   data: ThemeData(
                  //     unselectedWidgetColor: MateColors.inActiveIcons, // Your color
                  //   ),
                  //   child: RadioListTile(
                  //     activeColor: MateColors.activeIcons,
                  //     contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
                  //     title: Text(
                  //       "Gallery",
                  //       style: TextStyle(
                  //         fontSize: 12.5.sp,
                  //         color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                  //         fontWeight: FontWeight.w500,
                  //       ),
                  //     ),
                  //     value: "Gallery",
                  //     groupValue: imageSource,
                  //     onChanged: (value) {
                  //       setState(() {
                  //         imageSource = value;
                  //         print(imageSource);
                  //       });
                  //     },
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 15.0,
                  // ),
                  // InkWell(
                  //   onTap: () {
                  //     if (imageSource == "Gallery") {
                  //       _getCoverImage(1);
                  //     } else {
                  //       _getCoverImage(2);
                  //     }
                  //   },
                  //   child: Container(
                  //     height: 40.0,
                  //     width: MediaQuery.of(context).size.width,
                  //     // margin: EdgeInsets.all(2),
                  //     alignment: Alignment.center,
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  //       boxShadow: <BoxShadow>[
                  //         BoxShadow(
                  //             color: Colors.transparent,
                  //             // offset: Offset(2, 4),
                  //             blurRadius: 5,
                  //             spreadRadius: 0)
                  //       ],
                  //       color: MateColors.activeIcons,
                  //       //gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Colors.teal, MateColors.activeIcons])
                  //     ),
                  //     child: Text(
                  //       'Continue',
                  //       style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w600, color: themeController.isDarkMode?MateColors.blackTextColor:Colors.white,),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future _getCoverImage(int option) async {
    PickedFile? pickImage;
    if (option == 1) {
      pickImage = await picker.getImage(source: ImageSource.gallery, imageQuality: 50);
    } else
      pickImage = await picker.getImage(source: ImageSource.camera, imageQuality: 50);

    if (pickImage != null) {
      setState(() {
        coverImage = pickImage!.path;
      });

      _coverImage = File(pickImage.path);

      var img = _coverImage!.readAsBytesSync();

      _base64encodedImageForCoverPIc = base64Encode(img);

      print('image selected:: ${_coverImage.toString()}');

      // Provider.of<AuthUserProvider>(context, listen: false).updateCoverPhoto(imageFile: _base64encodedImageForCoverPIc);
    } else {
      print('No image selected.');
    }
    Navigator.of(context).pop();
  }


  String? validateTextField(String? value) {
    if(value!.isEmpty){
      return "This field is required";
    }
    return null;
  }

}
