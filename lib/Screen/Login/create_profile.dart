import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mate_app/Model/universityListingModel.dart';
import 'package:mate_app/Widget/loader.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Providers/AuthUserProvider.dart';
import '../../Services/AuthUserService.dart';
import '../../asset/Colors/MateColors.dart';
import '../../constant.dart';
import '../../controller/signup_controller.dart';
import '../../controller/theme_controller.dart';
import '../Home/HomeScreen.dart';

class CreateProfile extends StatefulWidget {
  final String photoUrl;
  final String coverPhotoUrl;
  final String fullName;
  final String email;
  final String password;
  CreateProfile({required this.photoUrl,required this.coverPhotoUrl,required this.fullName, required this.email, required this.password});
  static final String routeName = '/createProfile';

  @override
  _CreateProfileState createState() => _CreateProfileState();
}


class _CreateProfileState extends State<CreateProfile> {
  ThemeController themeController = Get.find<ThemeController>();
  late TextEditingController fullNameController;
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
  String? token;
  late FirebaseMessaging _firebaseMessaging;

  @override
  void initState(){
    _firebaseMessaging = FirebaseMessaging.instance;
    _firebaseMessaging.requestPermission();
    fullNameController = TextEditingController(text: widget.fullName);
    profileImage = widget.photoUrl;
    coverImage = widget.coverPhotoUrl;
    getStoredValue();
    super.initState();
  }

  getStoredValue()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("tokenApp");
    if(token==null){
      SignupController signupController = Get.find<SignupController>();
      token = signupController.token;
    }
    log(token!);
    universityList = await authUserService.getUniversityList(token: token!);
    print(universityList);
    setState(() {});
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
                      top: MediaQuery.of(context).size.height*0.06,
                      left: 16,
                      right: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 20,
                          child: IconButton(
                            icon: Icon(Icons.arrow_back_ios,
                              size: 20,
                              color: themeController.isDarkMode ? Colors.white : MateColors.blackText,
                            ),
                            onPressed: (){
                              Get.back();
                            },
                          ),
                        ),
                        Text(
                          "Create Profile",
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            color: themeController.isDarkMode?Colors.white:Colors.black,
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
                                color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                              ),
                              child: GestureDetector(
                                onTap: ()=>modalSheetForProfilePic(),
                                child: DottedBorder(
                                  color: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
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
                                letterSpacing: 0.1,
                                color: themeController.isDarkMode?Colors.white:Colors.black,
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
                                letterSpacing: 0.1,
                                color: themeController.isDarkMode?Colors.white:Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Container(
                            padding: EdgeInsets.only(top: 5),
                            decoration: ShapeDecoration(
                              color: themeController.isDarkMode ? MateColors.containerDark : MateColors.containerLight,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(14.0)),
                              ),
                            ),
                            child: DropdownSearch<Datum>(
                              mode: Mode.MENU,
                              showSelectedItems: false,
                              dropdownButtonProps: IconButtonProps(
                                padding: EdgeInsets.only(bottom: 5),
                                icon: Icon(Icons.keyboard_arrow_down_sharp,size: 20),
                                color: themeController.isDarkMode?Colors.white:Colors.black,
                              ),
                              dropdownBuilder: (context,data){
                                return Padding(
                                  padding: const EdgeInsets.only(left: 16),
                                  child: Text(universityController.text.isEmpty?"Pick one":universityController.text,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Poppins',
                                      color: themeController.isDarkMode?Colors.white.withOpacity(0.6):Colors.black.withOpacity(0.6),
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
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Poppins',
                                  color: Colors.white.withOpacity(0.6),
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
                          Padding(
                            padding: const EdgeInsets.only(left: 2,top: 40),
                            child: Text(
                              "Banner image",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Poppins',
                                letterSpacing: 0.1,
                                color: themeController.isDarkMode?Colors.white:Colors.black,
                              ),
                            ),
                          ),
                          Container(
                            height: 112,
                            margin: EdgeInsets.only(top: scH*0.01),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                            ),
                            child: GestureDetector(
                              onTap: ()=> modalSheetForCoverPic(),
                              child: DottedBorder(
                                color: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
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
                                          color: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
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
                            height: 60,
                            width: scW,
                            margin: EdgeInsets.only(top: 30,),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                primary: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                                onPrimary: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              ),
                              onPressed: ()async{
                                if(formKey.currentState!.validate()){
                                  if(universityController.text!=""){
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
                                    if(profileImage!=""){
                                      if(!profileImage.contains("http")){
                                        authUserService.updatePhotoWhileSignup(imageFile: _base64encodedImageForProfilePic!);
                                      }
                                    }
                                    if(coverImage!=""){
                                      if(!coverImage.contains("http")){
                                        authUserService.updateCoverPhotoWhileSignup(imageFile: _base64encodedImageForCoverPIc!);
                                      }
                                    }
                                    setState(() {
                                      isLoading = true;
                                    });
                                    String response = await authUserService.createProfile(
                                      firstName: firstName!,
                                      lastName: lastName!,
                                      displayName: fullNameController.text,
                                      universityId: universityId!,
                                    );
                                    if(response=="User profile updated."){
                                      String? deviceId = await _firebaseMessaging.getToken();
                                      print(deviceId);
                                      dynamic response = await authUserService.signInWithEmail(
                                        email: widget.email,
                                        password: widget.password,
                                        deviceId: deviceId!,
                                      );
                                      if(response == "Invalid user credentials."){
                                        setState(() {
                                          isLoading = false;
                                        });
                                        Fluttertoast.showToast(msg: "Invalid user credentials", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
                                      }else if(response !="result"){
                                        setState(() {
                                          isLoading = false;
                                        });
                                        if(response.universityId!=null){
                                          SharedPreferences prefs = await SharedPreferences.getInstance();
                                          prefs.setBool('login_app', true);
                                          Provider.of<AuthUserProvider>(context,listen: false).authUser = response;
                                          Navigator.of(context).pushNamedAndRemoveUntil(HomeScreen.homeScreenRoute, (route) => false);
                                        }else{
                                          var prefs = await SharedPreferences.getInstance();
                                          prefs.remove('googleToken');
                                          prefs.remove('authUser');
                                          Fluttertoast.showToast(msg: "Please update profile first", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
                                        }
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
                                  Text("Continue",
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
        ),
        Visibility(
          visible: isLoading,
          child: Loader(),
        ),
      ],
    );
  }


  modalSheetForProfilePic() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: themeController.isDarkMode?MateColors.bottomSheetBackgroundDark:MateColors.bottomSheetBackgroundLight,
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
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                        letterSpacing: 0.1,
                        color: Colors.white,
                      ),
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
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                color: themeController.isDarkMode?MateColors.bottomSheetItemBackgroundDark:MateColors.bottomSheetItemBackgroundLight,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Image.asset(
                                  "lib/asset/icons/cameraNew.png",
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Camera",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Poppins',
                                letterSpacing: 0.1,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () =>  _getProfileImage(1),
                        child: Column(
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                color: themeController.isDarkMode?MateColors.bottomSheetItemBackgroundDark:MateColors.bottomSheetItemBackgroundLight,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Image.asset(
                                  "lib/asset/icons/galleryNew.png",
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Gallery",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Poppins',
                                letterSpacing: 0.1,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
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

    } else {
      print('No image selected.');
    }
    Navigator.of(context).pop();
  }

  modalSheetForCoverPic() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: themeController.isDarkMode?MateColors.bottomSheetBackgroundDark:MateColors.bottomSheetBackgroundLight,
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
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                        letterSpacing: 0.1,
                        color: Colors.white,
                      ),
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
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                color: themeController.isDarkMode?MateColors.bottomSheetItemBackgroundDark:MateColors.bottomSheetItemBackgroundLight,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Image.asset(
                                  "lib/asset/icons/cameraNew.png",
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Camera",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Poppins',
                                letterSpacing: 0.1,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () =>  _getCoverImage(1),
                        child: Column(
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                color: themeController.isDarkMode?MateColors.bottomSheetItemBackgroundDark:MateColors.bottomSheetItemBackgroundLight,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Image.asset(
                                  "lib/asset/icons/galleryNew.png",
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Gallery",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Poppins',
                                letterSpacing: 0.1,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
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
