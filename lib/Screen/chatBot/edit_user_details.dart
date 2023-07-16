import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mate_app/controller/theme_controller.dart';
import 'package:mate_app/groupChat/services/database_service.dart';
import 'package:sizer/sizer.dart';

import '../../Widget/loader.dart';
import '../../asset/Colors/MateColors.dart';
import '../../constant.dart';

class EditUserDetails extends StatefulWidget {
  final String uid;
  final String name;
  final String image;
  const EditUserDetails({Key? key, required this.uid, required this.name, required this.image}) : super(key: key);

  @override
  State<EditUserDetails> createState() => _EditUserDetailsState();
}

class _EditUserDetailsState extends State<EditUserDetails> {
  ThemeController themeController = Get.find<ThemeController>();
  late TextEditingController nameController;
  final picker = ImagePicker();
  String image = "";
  PickedFile? _pickedFile;
  bool isLoading = false;

  void setData(){
    setState(() {
      nameController = TextEditingController(text: widget.name);
      image = widget.image;
    });
  }

  @override
  void initState() {
    setData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final scH = MediaQuery.of(context).size.height;
    final scW = MediaQuery.of(context).size.width;
    return Stack(
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
                        "Update bot profile",
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
                    padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                              onTap: ()=> modalSheetForProfilePic(),
                              child: DottedBorder(
                                color: MateColors.activeIcons,
                                strokeWidth: 1,
                                dashPattern: [10, 6, 10, 6],
                                borderType: BorderType.Circle,
                                child: image.contains("http")?
                                Center(
                                  child: CircleAvatar(
                                    radius: 60,
                                    backgroundImage: NetworkImage(image),
                                  ),
                                ):
                                image == ""?
                                Center(
                                  child: Image.asset("lib/asset/icons/galleryPlus.png",height: 22,),
                                ):
                                Center(
                                  child: CircleAvatar(
                                    radius: 60,
                                    backgroundImage: FileImage(File(image)),
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
                            "Bot name",
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
                          controller: nameController,
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
                            hintText: "Enter Bot name",
                            fillColor: themeController.isDarkMode ? MateColors.containerDark : MateColors.containerLight,
                            filled: true,
                            focusedBorder: commonBorder,
                            enabledBorder: commonBorder,
                            disabledBorder: commonBorder,
                            errorBorder: commonBorder,
                            focusedErrorBorder: commonBorder,
                          ),
                        ),
                        Center(
                          child: Container(
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
                                setState(() {
                                  isLoading = true;
                                });
                                if(_pickedFile!=null){
                                  String url = await uploadImage();
                                  if(url!=""){
                                    DatabaseService().createOrUpdateUserChatBotDetails(
                                      uid: widget.uid,
                                      name: nameController.text,
                                      photoUrl: url,
                                    );
                                  }else{
                                    DatabaseService().createOrUpdateUserChatBotDetails(
                                      uid: widget.uid,
                                      name: nameController.text,
                                      photoUrl: image,
                                    );
                                  }
                                }else{
                                  DatabaseService().createOrUpdateUserChatBotDetails(
                                    uid: widget.uid,
                                    name: nameController.text,
                                    photoUrl: image,
                                  );
                                }
                                setState(() {
                                  isLoading = false;
                                });
                                Get.back();
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
                                ],
                              ),
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
    } else {
      pickImage = await picker.getImage(source: ImageSource.camera, imageQuality: 50);
    }
    if (pickImage != null) {
      setState(() {
        image = pickImage!.path;
        _pickedFile = pickImage;
      });
    } else {
      print('No image selected.');
    }
    Navigator.of(context).pop();
  }

  Future<String> uploadImage() async {
    String imageUrl = "";
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    File compressedFile = await FlutterNativeImage.compressImage(_pickedFile!.path, quality: 80, percentage: 90);
    UploadTask uploadTask = reference.putFile(compressedFile);
    TaskSnapshot storageTaskSnapshot = await uploadTask.whenComplete(() {});
    imageUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return imageUrl;
  }

}
