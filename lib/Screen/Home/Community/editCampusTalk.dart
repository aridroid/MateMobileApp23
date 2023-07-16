import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mate_app/Providers/campusTalkProvider.dart';
import 'package:mate_app/Widget/loader.dart';
import 'package:mate_app/asset/Colors/MateColors.dart';
import 'package:flutter/material.dart';
import 'package:mate_app/controller/theme_controller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../../Model/campusTalkPostsModel.dart';
import '../../../Services/campusTalkService.dart';
import '../../../Widget/video_thumbnail.dart';
import '../../../constant.dart';
import 'package:mate_app/Model/campusTalkPostsModel.dart' as postModel;
import 'package:mate_app/Model/campusTalkTypeModel.dart' as campusTalkTypeModel;
import 'package:http/http.dart'as http;

class EditCampusTalk extends StatefulWidget {
  final String? title,description,anonymousUser;
  final int? id,isAnonymous;
  final bool? isBookmarkedPage;
  final bool? isUserProfile;
  final bool? isTrending;
  final bool? isLatest;
  final bool? isForums;
  final bool? isYourCampus;
  final bool? isListCard;
  final bool? isSearch;
  final postModel.User? user;
  final List<CampusTalkTypes>? campusTalkTypes;
  final String? image;
  final String? video;
  final String? audio;
  const EditCampusTalk({Key? key, this.title, this.description, this.anonymousUser, this.isAnonymous, this.id,
    this.isTrending = false,
    this.isLatest = false,
    this.isForums = false,
    this.isYourCampus = false,
    this.isListCard = false,
    this.isBookmarkedPage = false,
    this.isUserProfile = false, this.user,this.isSearch = false, this.campusTalkTypes,
     this.image, this.video, this.audio

  }) : super(key: key);

  @override
  State<EditCampusTalk> createState() => _EditCampusTalkState();
}

class _EditCampusTalkState extends State<EditCampusTalk> {
  final _formKey = GlobalKey<FormState>();
  FocusNode focusNode= FocusNode();
  late String _description;
  late String _title;
  late String anonymousUser;
  bool isAnonymous=false;
  bool isToggleAvailable = true;
  ThemeController themeController = Get.find<ThemeController>();
  int titleLength = 0;
  int descriptionLength = 0;
  bool isLoading = false;
  late int _id;
  List<String> typeName = [];
  String token = "";
  List<campusTalkTypeModel.Data> type = [];
  List<bool> typeSelected = [];
  CampusTalkService _campusTalkService = CampusTalkService();
  String _imageUrl = "";
  String _videoUrl = "";
  String _audioUrl = "";
  bool imagedDeleted = false;
  bool videoDeleted = false;
  bool audioDeleted = false;
  final picker = ImagePicker();
  File? _image;
  File? _video;
  File? _audio;
  String? _base64encodedImage;
  String? _base64encodedVideo;
  String? _base64encodedAudio;
  bool isPausedRecording = false;
  bool isPlaying = false;
  Duration? currentDuration;
  AudioPlayer _audioPlayer = AudioPlayer();
  bool showDeleteIcon = true;

  @override
  void initState() {
    focusNode.requestFocus();
    _id = widget.id!;
    _title = widget.title!;
    _description = widget.description!;
    isAnonymous = widget.isAnonymous==1?true:false;
    isToggleAvailable = !isAnonymous;
    anonymousUser = widget.anonymousUser??"";
    for(int i=0;i<widget.campusTalkTypes!.length;i++){
      typeName.add(widget.campusTalkTypes![i].type!.name!);
    }
    _imageUrl = widget.image??"";
    _videoUrl = widget.video??"";
    _audioUrl = widget.audio??"";
    getStoredValue();
    print(_title);
    print(_description);
    print(isAnonymous);
    print(anonymousUser);
    setState(() {});
    super.initState();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    focusNode.dispose();
    super.dispose();
  }

  getStoredValue()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("tokenApp")!;
    type = await _campusTalkService.getType(token: token);
    for(int i=0;i<type.length;i++){
      typeSelected.add(false);
    }
    for(int i=0;i<type.length;i++){
      if(typeName.contains(type[i].name)){
        typeSelected[i] = true;
      }
    }
    setState(() {});
  }

  pauseRecording()async{
    _audioPlayer.pause();
    setState(() {
      isPlaying = false;
      isPausedRecording = true;
    });
  }

  startAudio()async{
    if(isPausedRecording){
      isPlaying = true;
      isPausedRecording = false;
      _audioPlayer.play();
      setState(() {});
      _audioPlayer.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          setState(() {
            isPlaying = false;
            isPausedRecording = false;
          });
        }
      });
      _audioPlayer.positionStream.listen((event) {
        setState(() {
          currentDuration = event;
        });
      });
    }else{
      _audioPlayer.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          setState(() {
            isPlaying = false;
            isPausedRecording = false;
          });
        }
      });
      _audioPlayer.positionStream.listen((event) {
        setState(() {
          currentDuration = event;
        });
      });
      _audioPlayer.stop();
      setState(() {
        isPlaying = false;
      });
      if(_audio!=null){
        _audioPlayer.setFilePath(_audio!.path);
      }else{
        var dir = await getApplicationDocumentsDirectory();
        var filePathAndName = dir.path + "/audios/" +_audioUrl.split("/").last + ".mp3";
        if(File(filePathAndName).existsSync()){
          print("------File Already Exist-------");
          print(filePathAndName);
          await _audioPlayer.setFilePath(filePathAndName);
        }else{
          String path = await downloadAudio(_audioUrl);
          if(path !=""){
            await _audioPlayer.setFilePath(path);
          }else{
            Fluttertoast.showToast(msg: "Something went wrong while playing audio please try again!", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
          }
        }
      }
      _audioPlayer.play();
      isPlaying = true;
      setState(() {});
    }
  }

  Future<String> downloadAudio(String url)async{
    var dir = await getApplicationDocumentsDirectory();
    var firstPath = dir.path + "/audios";
    var filePathAndName = dir.path + "/audios/" +url.split("/").last + ".mp3";
    await Directory(firstPath).create(recursive: true);
    File file = new File(filePathAndName);
    try{
      var request = await http.get(Uri.parse(url));
      print(request.statusCode);
      var res = await file.writeAsBytes(request.bodyBytes);
      print("---File Path----");
      print(res.path);
      return res.path;
    }catch(e){
      print(e);
      return "";
    }
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
                          "Edit Discussion",
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
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Poppins',
                                    color: themeController.isDarkMode?Colors.white: Colors.black,
                                  ),
                                ),
                                Text(
                                  "$titleLength/50",
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
                          TextFormField(
                            initialValue: _title,
                            decoration: _customInputDecoration(labelText: 'Title', icon: Icons.perm_identity),
                            cursorColor: themeController.isDarkMode?MateColors.helpingTextDark:MateColors.helpingTextLight,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.1,
                              color: themeController.isDarkMode?Colors.white:Colors.black,
                            ),
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
                              _title = value!;
                            },
                            validator: (value) {
                              if(value!.isEmpty){
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
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Poppins',
                                    color: themeController.isDarkMode?Colors.white: Colors.black,
                                  ),
                                ),
                                Text(
                                  "$descriptionLength/512",
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
                          TextFormField(
                            initialValue: _description,
                            decoration: _customInputDecoration(labelText: 'What\'s on your mind?', icon: Icons.perm_identity),
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
                              _description = value!;
                            },
                            validator: (value) {
                              if(value!.isEmpty){
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
                                    fontFamily: 'Poppins',
                                    color: themeController.isDarkMode?Colors.white: Colors.black,
                                  ),
                                ),
                                value: isAnonymous,
                                onChanged: (newValue) {
                                  if(isToggleAvailable){
                                    isAnonymous=newValue!;
                                    setState(() {});
                                  }
                                },
                                controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
                              ),
                            ),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: ()async{
                                 modalSheetForImage();
                                },
                                child: Container(
                                  margin: EdgeInsets.only(top: 20),
                                  height: 60,
                                  width: scW*0.28,
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    color: themeController.isDarkMode?MateColors.smallContainerDark:MateColors.smallContainerLight,
                                  ),
                                  child: Center(
                                    child: Image.asset(
                                      "lib/asset/iconsNewDesign/gallery.png",
                                      height: 26,
                                      width: 26,
                                      color: themeController.isDarkMode?Colors.white:Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: ()async{
                                  modalSheetForVideo();
                                },
                                child: Container(
                                  margin: EdgeInsets.only(top: 20),
                                  height: 60,
                                  width: scW*0.28,
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    color: themeController.isDarkMode?MateColors.smallContainerDark:MateColors.smallContainerLight,
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.video_call,
                                      size: 30,
                                      color: themeController.isDarkMode?Colors.white:Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: ()async{
                                 modalSheetForAudio();
                                },
                                child: Container(
                                  margin: EdgeInsets.only(top: 20),
                                  height: 60,
                                  width: scW*0.28,
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    color: themeController.isDarkMode?MateColors.smallContainerDark:MateColors.smallContainerLight,
                                  ),
                                  child: Center(
                                    child: Image.asset(
                                      "lib/asset/iconsNewDesign/mic2.png",
                                      height: 23,
                                      width: 23,
                                      color: themeController.isDarkMode?Colors.white:Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if(isRecordingAudioFromMic)
                            Container(
                              height: 100,
                              margin: EdgeInsets.only(top: 20),
                              padding: EdgeInsets.only(left: 16,right: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                              ),
                              child: Column(
                                children: [
                                  SizedBox(height: 16,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(minute.toString().padLeft(2,'0') +":"+ second.toString().padLeft(2,"0"),
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15,
                                              color: themeController.isDarkMode ? Colors.white:Colors.black,
                                            ),
                                          ),
                                          SizedBox(width: 16,),
                                          Icon(Icons.multitrack_audio_sharp,color: themeController.isDarkMode ? Colors.white:Colors.black,),
                                          Icon(Icons.multitrack_audio_sharp,color: themeController.isDarkMode ? Colors.white:Colors.black,),
                                          Icon(Icons.multitrack_audio_sharp,color: themeController.isDarkMode ? Colors.white:Colors.black,),
                                          Icon(Icons.multitrack_audio_sharp,color: themeController.isDarkMode ? Colors.white:Colors.black,),
                                          Icon(Icons.multitrack_audio_sharp,color: themeController.isDarkMode ? Colors.white:Colors.black,),
                                          Icon(Icons.multitrack_audio_sharp,color: themeController.isDarkMode ? Colors.white:Colors.black,),
                                          Icon(Icons.multitrack_audio_sharp,color: themeController.isDarkMode ? Colors.white:Colors.black,),
                                          Icon(Icons.multitrack_audio_sharp,color: themeController.isDarkMode ? Colors.white:Colors.black,),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10,right: 10,top: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          onTap: (){
                                            deleteRecording();
                                          },
                                          child: Image.asset("lib/asset/iconsNewDesign/delete.png",
                                            width: 20,
                                            height: 20,
                                            color: themeController.isDarkMode?Colors.white:Colors.black,
                                          ),
                                        ),
                                        InkWell(
                                          onTap: (){
                                            isRecordingPaused ? resumeRecording(): pauseRecordingAudio();
                                          },
                                          child: Icon(!isRecordingPaused ? Icons.pause_circle_outline: Icons.play_circle,
                                            size: 30,
                                            color: themeController.isDarkMode?Colors.white:Colors.black,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: (){
                                            stopRecording();
                                          },
                                          child: Container(
                                            height: 34,
                                            width: 34,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: themeController.isDarkMode?Color(0xFF67AE8C):MateColors.appThemeDark,
                                            ),
                                            alignment: Alignment.center,
                                            child: Icon(Icons.send,
                                              size: 18,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          _audio!=null || _audioUrl!=""?
                          Container(
                            height: showDeleteIcon?118:60,
                            margin: EdgeInsets.only(top: 20),
                            padding: EdgeInsets.only(left: 16,right: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                            ),
                            child: Column(
                              children: [
                                SizedBox(height: 16,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        currentDuration!=null?
                                        Text(currentDuration!.inMinutes.toString().padLeft(2,'0') +":"+ currentDuration!.inSeconds.toString().padLeft(2,"0"),
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15,
                                            color: themeController.isDarkMode ? Colors.white:Colors.black,
                                          ),
                                        ):Text("00" +":"+ "00",
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15,
                                            color: themeController.isDarkMode ? Colors.white:Colors.black,
                                          ),
                                        ),
                                        SizedBox(width: 16,),
                                        Icon(Icons.multitrack_audio_sharp,color: themeController.isDarkMode ? Colors.white:Colors.black,),
                                        Icon(Icons.multitrack_audio_sharp,color: themeController.isDarkMode ? Colors.white:Colors.black,),
                                        Icon(Icons.multitrack_audio_sharp,color: themeController.isDarkMode ? Colors.white:Colors.black,),
                                        Icon(Icons.multitrack_audio_sharp,color: themeController.isDarkMode ? Colors.white:Colors.black,),
                                        Icon(Icons.multitrack_audio_sharp,color: themeController.isDarkMode ? Colors.white:Colors.black,),
                                        Icon(Icons.multitrack_audio_sharp,color: themeController.isDarkMode ? Colors.white:Colors.black,),
                                        Icon(Icons.multitrack_audio_sharp,color: themeController.isDarkMode ? Colors.white:Colors.black,),
                                        Icon(Icons.multitrack_audio_sharp,color: themeController.isDarkMode ? Colors.white:Colors.black,),
                                        if(showDeleteIcon)
                                          Icon(Icons.multitrack_audio_sharp,color: themeController.isDarkMode ? Colors.white:Colors.black,),
                                        if(!showDeleteIcon)
                                          GestureDetector(
                                            onTap: (){
                                              setState(() {
                                                showDeleteIcon = !showDeleteIcon;
                                              });
                                            },
                                            child: Container(
                                              height: 34,
                                              width: 34,
                                              margin: EdgeInsets.only(left: 10),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: themeController.isDarkMode?Color(0xFF67AE8C):MateColors.appThemeDark,
                                              ),
                                              alignment: Alignment.center,
                                              child: Icon(Icons.keyboard_arrow_down_outlined,
                                                size: 25,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                                if(showDeleteIcon)
                                  SizedBox(height: 25,),
                                if(showDeleteIcon)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10,right: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          onTap: (){
                                            if(_audioUrl.isNotEmpty){
                                              _audioUrl = "";
                                              audioDeleted = true;
                                            }else{
                                              _audio = null;
                                              _base64encodedAudio = null;
                                            }
                                            _audioPlayer.stop();
                                            setState(() {});
                                          },
                                          child: Image.asset("lib/asset/iconsNewDesign/delete.png",
                                            width: 20,
                                            height: 20,
                                            color: themeController.isDarkMode?Colors.white:Colors.black,
                                          ),
                                        ),
                                        InkWell(
                                          onTap: (){
                                            isPlaying ? pauseRecording(): startAudio();
                                          },
                                          child: Icon(isPlaying ? Icons.pause_circle_outline: Icons.play_circle,
                                            size: 30,
                                            color: themeController.isDarkMode?Colors.white:Colors.black,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: (){
                                            setState(() {
                                              showDeleteIcon = !showDeleteIcon;
                                            });
                                          },
                                          child: Container(
                                            height: 34,
                                            width: 34,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: themeController.isDarkMode?Color(0xFF67AE8C):MateColors.appThemeDark,
                                            ),
                                            alignment: Alignment.center,
                                            child: Icon(Icons.keyboard_arrow_up,
                                              size: 25,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ):SizedBox(),

                          _image!=null || _imageUrl!=""?
                          Stack(
                            children: [
                              Container(
                                height: 150,
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(top: 30),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  clipBehavior: Clip.hardEdge,
                                  child: _imageUrl!=""?
                                  Image.network(_imageUrl,fit: BoxFit.fill):
                                  Image.file(_image!,fit: BoxFit.fill),
                                ),
                              ),
                              Positioned(
                                top: 18,
                                right: 0,
                                child: InkWell(
                                  onTap: (){
                                    if(_imageUrl!=""){
                                      _imageUrl = "";
                                      imagedDeleted = true;
                                    }else{
                                      _image = null;
                                      _base64encodedImage = null;
                                    }
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
                                    child: _imageUrl!=""?
                                    Icon(Icons.delete,color: Colors.black,size: 16,):
                                    Icon(Icons.clear,color: Colors.black,size: 16,),
                                  ),
                                ),
                              ),
                            ],
                          ):Offstage(),
                          _video!=null || _videoUrl!=""?
                          Stack(
                            children: [
                              Container(
                                height: 150,
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(top: 30),
                                child: _videoUrl!=""?
                                VideoThumbnail(videoUrl: _videoUrl):
                                VideoThumbnailFile(videoUrl: _video!),
                              ),
                              Positioned(
                                top: 18,
                                right: 0,
                                child: InkWell(
                                  onTap: (){
                                    if(_videoUrl!=""){
                                      _videoUrl = "";
                                      videoDeleted = true;
                                    }else{
                                      _video = null;
                                      _base64encodedVideo = null;
                                    }
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
                                    child: _videoUrl!=""?
                                    Icon(Icons.delete,color: Colors.black,size: 16,):
                                    Icon(Icons.clear,color: Colors.black,size: 16,),
                                  ),
                                ),
                              ),
                            ],
                          ):Offstage(),

                          Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 15.0, 3.0, 10.0),
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
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: List.generate(type.length, (index) =>
                                InkWell(
                                    onTap: (){
                                      typeSelected[index]=!typeSelected[index];
                                      setState(() {});
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 18,vertical: 6),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color: typeSelected[index]?
                                        themeController.isDarkMode? MateColors.appThemeDark:MateColors.appThemeLight:
                                        themeController.isDarkMode?MateColors.smallContainerDark:MateColors.smallContainerLight,
                                      ),
                                      child: Text(type[index].name!,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: "Poppins",
                                          color: themeController.isDarkMode?
                                          typeSelected[index]?Colors.black:Colors.white:
                                          typeSelected[index]?
                                          Colors.white:Colors.black,
                                        ),
                                      ),
                                    ))
                            ),
                          ),
                          _submitButton(context),
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

  Consumer<CampusTalkProvider> _submitButton(BuildContext context) {
    return Consumer<CampusTalkProvider>(
      builder: (ctx, campusTalkProvider, _) {
        return Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Container(
            height: 60,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
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
              onPressed: () {
                if(_formKey.currentState!.validate()) _submitForm(context);
              },
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
      setState(() {
        isLoading = true;
      });
      _formKey.currentState!.save();
      List<String> uuid = [];
      for(int i=0;i<typeSelected.length;i++){
        if(typeSelected[i]){
          uuid.add(type[i].uuid!);
        }
      }
      bool posted= await Provider.of<CampusTalkProvider>(context, listen: false).updateACampusTalkPost(
          _id,
          _title,
          _description,
          isAnonymous,
          isToggleAvailable==false?anonymousUser:null,
          uuid,
        _base64encodedImage,
        _base64encodedVideo,
        _base64encodedAudio,
        imagedDeleted && _image==null,
        videoDeleted && _video==null,
        audioDeleted && _audio==null,
      );
      setState(() {
        isLoading = false;
      });
      if(posted){
        final campusTalkProvider = Provider.of<CampusTalkProvider>(context, listen: false);
        if (widget.isBookmarkedPage!) {
          campusTalkProvider.fetchCampusTalkPostBookmarkedList();
        } else if (widget.isUserProfile!) {
          campusTalkProvider.fetchCampusTalkByAuthUser(widget.user!.uuid!, page: 1);
        } else if(widget.isTrending!){
          campusTalkProvider.fetchCampusTalkPostTendingList(page: 1);
        } else if(widget.isLatest!){
          campusTalkProvider.fetchCampusTalkPostTLatestList(page: 1);
        }else if(widget.isForums!){
          campusTalkProvider.fetchCampusTalkPostForumsList(page: 1);
        }else if(widget.isYourCampus!){
          campusTalkProvider.fetchCampusTalkPostYourCampusList(page: 1);
        }else if(widget.isListCard!){
          campusTalkProvider.fetchCampusTalkPostListCard();
        }else if(widget.isListCard!){
          Get.back();
        }
        Navigator.pop(context);
      }
    }
  }

  InputDecoration _customInputDecoration({required String labelText, IconData? icon}) {
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

  modalSheetForImage() {
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
                        onTap: () =>  _getImage(0),
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
                        onTap: () =>  _getImage(1),
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

  Future _getImage(int option) async {
    final pickedFile = await picker.getImage(source: option == 0?ImageSource.camera:ImageSource.gallery,imageQuality: 70);
    if (pickedFile != null) {
      _imageUrl = "";
      _image = File(pickedFile.path);
      _base64encodedImage = pickedFile.path;
      setState(() {});
      print('image selected:: ${_base64encodedImage.toString()}');
    } else {
      print('No image selected.');
    }
    Navigator.of(context).pop();
  }

  modalSheetForVideo() {
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
                      "Select video source",
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
                        onTap: () =>  _getVideo(0),
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
                        onTap: () =>  _getVideo(1),
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

  Future _getVideo(int option) async {
    final pickedFile = await picker.getVideo(source: option==0?ImageSource.camera:ImageSource.gallery,);
    if (pickedFile != null) {
      _videoUrl = "";
      _video = File(pickedFile.path);
      _base64encodedVideo = pickedFile.path;
      setState(() {});
      print('video selected:: ${_base64encodedVideo.toString()}');
    } else {
      print('No video selected.');
    }
    Navigator.of(context).pop();
  }

  modalSheetForAudio() {
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
                      "Select audio source",
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
                        onTap: () =>  _getAudio(0),
                        child: Column(
                          children: [
                            Image.asset(
                              "lib/asset/iconsNewDesign/mic2.png",
                              height: 25,
                              width: 25,
                              color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Record",
                              style: TextStyle(fontSize: 11.7.sp, fontWeight: FontWeight.w500, color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor),
                            )
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () =>  _getAudio(1),
                        child: Column(
                          children: [
                            Image.asset(
                              "lib/asset/iconsNewDesign/directory.png",
                              height: 25,
                              width: 25,
                              color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "File",
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

  Future _getAudio(int option) async {
    if(option==0){
      startRecording();
    }else{
      final pickedFile = await FilePicker.platform.pickFiles(type: FileType.audio);
      if (pickedFile != null) {
        _audio = File(pickedFile.paths.first!);
        var audio = _audio!.readAsBytesSync();
        //_base64encodedAudio = base64Encode(audio);
        _base64encodedAudio = pickedFile.paths.first;
        _audioUrl = "";
        isPausedRecording = false;
        isPlaying = false;
        _audioPlayer.stop();
        currentDuration = null;
        setState(() {});
        print('Audio selected:: ${_base64encodedAudio.toString()}');
      } else {
        print('No audio selected.');
      }
    }
    Navigator.of(context).pop();
  }

  Record recordMp3 = Record();
  bool _isAcceptedPermission = false;
  Timer? _timer;
  int second = 0;
  int minute = 0;
  bool isRecordingPaused = false;
  bool isRecordingAudioFromMic = false;

  voidInitialSound() async {
    if (Platform.isIOS) _isAcceptedPermission = true;
    final status = await Permission.microphone.status;
    if (status.isGranted) {
      final result = await Permission.storage.request();
      if (result.isGranted) {
        _isAcceptedPermission = true;
      }
    }
  }

  startRecording() async {
    if (!_isAcceptedPermission) {
      await Permission.microphone.request();
      await Permission.manageExternalStorage.request();
      await Permission.storage.request();
      _isAcceptedPermission = true;
    }else{
      String recordFilePath = await getFilePath();
      recordMp3.start(path: recordFilePath);
      isRecordingAudioFromMic = true;
      _mapCounterGenerator();
      setState(() {});
    }
    setState(() {});
  }

  Future<String> getFilePath() async {
    auth.User _user = auth.FirebaseAuth.instance.currentUser!;
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path + "/" + _user.uid + ".m4a";
    if(File(appDocPath).existsSync()){
      print("Deleted");
      await File(appDocPath).delete();
    }
    return appDocPath;
  }

  void _mapCounterGenerator() {
    _timer = Timer(const Duration(seconds: 1), () {
      second = second + 1;
      if (second == 60) {
        second = 0;
        minute = minute + 1;
      }
      setState(() {});
      _mapCounterGenerator();
    });
  }

  pauseRecordingAudio()async{
    if(second > 0 || minute > 0){
      _timer?.cancel();
      await recordMp3.pause();
      isRecordingPaused = true;
      setState(() {});
    }
  }

  resumeRecording()async{
    _mapCounterGenerator();
    if(isRecordingPaused){
      await recordMp3.resume();
    }
    isRecordingPaused = false;
    setState(() {});
  }

  stopRecording()async{
    isRecordingAudioFromMic = false;
    second = 0;
    minute = 0;
    _timer!.cancel();

    String? pickedFile = await recordMp3.stop();
    if (pickedFile != null) {
      _audio = File(pickedFile);
      var audio = _audio!.readAsBytesSync();
      //_base64encodedAudio = base64Encode(audio);
      _base64encodedAudio = pickedFile;
      _audioUrl = "";
      isPausedRecording = false;
      isPlaying = false;
      _audioPlayer.stop();
      currentDuration = null;
      setState(() {});
      print('Audio selected:: ${_base64encodedAudio.toString()}');
    } else {
      print('No audio selected.');
    }
  }

  deleteRecording()async{
    isRecordingAudioFromMic = false;
    second = 0;
    minute = 0;
    _timer!.cancel();
    setState(() {});
  }

}
