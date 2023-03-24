import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mate_app/Providers/FeedProvider.dart';
import 'package:mate_app/Utility/Utility.dart';
import 'package:mate_app/Widget/loader.dart';
import 'package:mate_app/asset/Colors/MateColors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../../../Model/FeedItem.dart';
import '../../../Widget/video_thumbnail.dart';
import '../../../constant.dart';
import '../../../controller/theme_controller.dart';
import '../HomeScreen.dart';
import 'package:http/http.dart'as http;

class EditFeedPost extends StatefulWidget {
  final int id;
  final String title;
  final String description;
  final String link;
  final String linkText;
  final String imageUrl;
  final String videoUrl;
  final String audioUrl;
  final List feedType;
  static final String routeName = 'create-post';
  const EditFeedPost({Key key, this.id, this.title, this.description, this.link, this.linkText, this.imageUrl, this.feedType, this.videoUrl, this.audioUrl}) : super(key: key);

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
  File _video;
  String _base64encodedVideo;
  File _audio;
  String _base64encodedAudio;
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
  List<String> feedTypeName =[];
  String _imageUrl = "";
  String _videoUrl = "";
  String _audioUrl = "";
  bool mediaDeleted = false;

  @override
  void initState() {
    setPreviousData();
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

  void setPreviousData(){
    _id = widget.id;
    _title = widget.title;
    _description = widget.description;
    _hyperlink = widget.link;
    _hyperlinkText = widget.linkText;
    _imageUrl = widget.imageUrl??"";
    _videoUrl = widget.videoUrl??"";
    _audioUrl = widget.audioUrl??"";
    for(int i=0;i<widget.feedType.length;i++){
      feedTypeName.add(widget.feedType[i].type.name);
    }
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
          audio: _base64encodedAudio !=null ? _base64encodedAudio :null,
          video: _base64encodedVideo !=null ? _base64encodedVideo : null,
          feedId: _id,
          mediaDeleted: mediaDeleted && (_image==null && _video==null && _audio==null),
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

  InputDecoration _customInputDecoration({@required String labelText, IconData icon,bool isSuffix=false}) {
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
        );
      },
    );
  }

  bool isPausedRecording = false;
  bool isPlaying = false;
  Duration currentDuration;
  AudioPlayer _audioPlayer = AudioPlayer();
  bool showDeleteIcon = true;

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
        _audioPlayer.setFilePath(_audio.path);
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
                            "Edit Post",
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
                                  initialValue: _title,
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: ()async{
                                        final pickedFile = await picker.getImage(source: ImageSource.gallery,imageQuality: 70);
                                        if (pickedFile != null) {
                                          _image = File(pickedFile.path);
                                          var img = _image.readAsBytesSync();
                                          _base64encodedImage = base64Encode(img);
                                          _imageUrl = "";
                                          _video = null;
                                          _videoUrl = "";
                                          _base64encodedVideo = null;
                                          _audio = null;
                                          _audioUrl = "";
                                          _base64encodedAudio = null;
                                          setState(() {});
                                          print('image selected:: ${_base64encodedImage.toString()}');
                                        } else {
                                          print('No image selected.');
                                        }
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
                                        final pickedFile = await picker.getVideo(source: ImageSource.gallery,);
                                        if (pickedFile != null) {
                                          _video = File(pickedFile.path);
                                          var video = _video.readAsBytesSync();
                                          _base64encodedVideo = base64Encode(video);
                                          _videoUrl = "";
                                          _image = null;
                                          _imageUrl = "";
                                          _base64encodedImage = null;
                                          _audio = null;
                                          _audioUrl = "";
                                          _base64encodedAudio = null;
                                          setState(() {});
                                          print('video selected:: ${_base64encodedVideo.toString()}');
                                        } else {
                                          print('No video selected.');
                                        }
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
                                        final pickedFile = await FilePicker.platform.pickFiles(type: FileType.audio);
                                        if (pickedFile != null) {
                                          _audio = File(pickedFile.paths.first);
                                          var audio = _audio.readAsBytesSync();
                                          _base64encodedAudio = base64Encode(audio);
                                          _audioUrl = "";
                                          _image = null;
                                          _imageUrl = "";
                                          _base64encodedImage = null;
                                          _video = null;
                                          _videoUrl = "";
                                          _base64encodedVideo = null;
                                          isPausedRecording = false;
                                          isPlaying = false;
                                          _audioPlayer.stop();
                                          currentDuration = null;
                                          setState(() {});
                                          print('Audio selected:: ${_base64encodedAudio.toString()}');
                                        } else {
                                          print('No audio selected.');
                                        }
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
                                              Text(currentDuration.inMinutes.toString().padLeft(2,'0') +":"+ currentDuration.inSeconds.toString().padLeft(2,"0"),
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
                                                    mediaDeleted = true;
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
                                  initialValue: _description,
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
                                  initialValue: _hyperlinkText,
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
                                  initialValue: _hyperlink,
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
                                _image != null || _imageUrl!="" ?
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
                                              mediaDeleted = true;
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
                                _video != null || _videoUrl!="" ?
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
                                          child: _video != null?
                                          VideoThumbnailFile(videoUrl: _video):
                                          VideoThumbnail(videoUrl: _videoUrl)
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
                                            if(_videoUrl.isNotEmpty){
                                              _videoUrl = "";
                                              mediaDeleted = true;
                                            }else{
                                              _video = null;
                                              _base64encodedVideo = null;
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
                                              child: _videoUrl!=""?
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
          // GestureDetector(
          //   onTap: ()async{
          //     final pickedFile = await picker.getImage(source: ImageSource.gallery,imageQuality: 70);
          //     if (pickedFile != null) {
          //       _image = File(pickedFile.path);
          //       _imageUrl = "";
          //       var img = _image.readAsBytesSync();
          //       _base64encodedImage = base64Encode(img);
          //       setState(() {});
          //       print('image selected:: ${_base64encodedImage.toString()}');
          //     } else {
          //       print('No image selected.');
          //     }
          //   },
          //   child: Container(
          //     height: 60,
          //     width: 60,
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(14),
          //       color: themeController.isDarkMode?MateColors.smallContainerDark:MateColors.smallContainerLight,
          //     ),
          //     child: Center(
          //       child: Image.asset(
          //         "lib/asset/icons/galleryPlus.png",
          //         height: 25,
          //         width: 25,
          //         color: themeController.isDarkMode?Colors.white:Colors.black,
          //       ),
          //     ),
          //   ),
          // ),
          // SizedBox(
          //   width: 20,
          // ),
          _submitButton(context),
          // SizedBox(
          //   width: 5,
          // ),
        ],
      ),
    );
  }
}
