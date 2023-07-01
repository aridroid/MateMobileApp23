import 'dart:async';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mate_app/Widget/Loaders/Shimmer.dart';
import 'package:mate_app/Widget/social_media_recorder/provider/sound_record_notifier.dart';
import 'package:mate_app/asset/Colors/MateColors.dart';
import 'dart:io';
import 'package:mate_app/Utility/Utility.dart';
import 'package:mate_app/groupChat/pages/groupSettingsPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mate_app/groupChat/services/database_service.dart';
import 'package:mate_app/groupChat/widgets/message_tile.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';
import 'package:sizer/sizer.dart';

import '../../Providers/AuthUserProvider.dart';
import '../../Providers/chatProvider.dart';
import '../../Screen/Profile/ProfileScreen.dart';
import '../../Screen/Profile/UserProfileScreen.dart';
import 'package:giphy_picker/giphy_picker.dart';
import '../../Widget/social_media_recorder/audio_encoder_type.dart';
import '../../Widget/social_media_recorder/screen/social_media_recorder.dart';
import '../../audioAndVideoCalling/calling.dart';
import '../../audioAndVideoCalling/connectingScreen.dart';
import 'package:http/http.dart' as http;

import '../../constant.dart';
import 'package:flutter/foundation.dart' as foundation;

class ChatPage extends StatefulWidget {
  final String groupId;
  final String userName;
  final String totalParticipant;
  final String groupName;
  final String photoURL;
  final List<dynamic> memberList;
  ChatPage({this.groupId, this.userName, this.groupName, this.photoURL = "",this.totalParticipant, this.memberList});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Stream<QuerySnapshot> _chats;
  User _user;
  TextEditingController messageEditingController = new TextEditingController();
  final ScrollController listScrollController = new ScrollController();
  PickedFile imageFile;
  File file;
  String fileExtension = "";
  String fileName = "";
  int fileSize = 0;
  bool isLoading = false;
  bool isShowSticker;
  String imageUrl;
  String fileUrl;
  bool readMessageUpdate = true;
  int messageLength = 0;
  User currentUser = FirebaseAuth.instance.currentUser;
  String _gifPath;
  String selectedMessage = "";
  String sender = "";
  bool showSelected = false;
  bool showDate = false;
  bool isUserMember = true;

  void showDateToggle(){
    setState(() {
      showDate = !showDate;
    });
  }

  bool isEditing = false;
  String editGroupId;
  String editMessageId;
  void editMessage(String groupId,String messageId,String previousMessage)async{
    setState(() {
      isEditing = true;
      editGroupId = groupId;
      editMessageId = messageId;
      messageEditingController.text = previousMessage;
    });
  }

  Widget _chatMessages() {
    return GestureDetector(
      onHorizontalDragStart: (val){
        showDateToggle();
      },
      onHorizontalDragEnd: (val){
        showDateToggle();
      },
      child: StreamBuilder(
        stream: _chats,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            messageLength = snapshot.data.docs.length;
            if(messageLength!=isPlaying.length){
              if(messageLength>isPlaying.length && messageLength<isPlaying.length+2){
                isPlaying.add(false);
                isPaused.add(false);
                isLoadingAudio.add(false);
              }else{
                isPlaying.clear();
                isPaused.clear();
                isLoadingAudio.clear();
                for(int i=0;i<messageLength;i++){
                  isPlaying.add(false);
                  isPaused.add(false);
                  isLoadingAudio.add(false);
                }
              }
              print(isPlaying.length);
              print(isPaused.length);
              print(isLoadingAudio.length);
            }
            if (readMessageUpdate) {
              Map<String, dynamic> body = {"group_id": widget.groupId, "read_by": _user.uid, "messages_read": messageLength};
              Future.delayed(Duration.zero, () {
                Provider.of<ChatProvider>(context, listen: false).groupChatMessageReadUpdate(body);
                Provider.of<ChatProvider>(context, listen: false).groupChatDataFetch(_user.uid);
              });
              readMessageUpdate = false;
            }


            List<String> date = [];
            List<String> time = [];

            var dateTimeNowToday = DateTime.now();
            List<String> splitToday = dateTimeNowToday.toString().split(" ");
            DateTime dateParsedToday = DateTime.parse(splitToday[0]);
            String dateFormattedToday = DateFormat('dd MMMM yyyy').format(dateParsedToday);

            var dateTimeNowYesterday = DateTime.now().subtract(const Duration(days:1));
            List<String> splitYesterday = dateTimeNowYesterday.toString().split(" ");
            DateTime dateParsedYesterday = DateTime.parse(splitYesterday[0]);
            String dateFormattedYesterday = DateFormat('dd MMMM yyyy').format(dateParsedYesterday);

            for(int i=0; i<snapshot.data.docs.length; i++){
              DateTime dateFormat = new DateTime.fromMillisecondsSinceEpoch(int.parse(snapshot.data.docs[i].data()["time"].toString()));
              String dateFormatted = DateFormat('dd MMMM yyyy').format(dateFormat);
              if(dateFormatted == dateFormattedToday){
                String formattedTime = DateFormat.jm().format(dateFormat);
                date.add("Today"+", "+formattedTime);
              }else if(dateFormatted == dateFormattedYesterday){
                String formattedTime = DateFormat.jm().format(dateFormat);
                date.add("Yesterday"+", "+formattedTime);
              }else{
                String formattedTime = DateFormat.jm().format(dateFormat);
                String dateNew = getFormattedDate(dateFormatted);
                date.add(dateNew+", "+formattedTime);
              }
              String formattedTime = DateFormat.jm().format(dateFormat);
              time.add(formattedTime);
            }

            List<String> dateReversed = date.reversed.toList();
            List<String> timeReversed = time.reversed.toList();

            return ListView.builder(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                itemCount: snapshot.data.docs.length,
                reverse: true,
                controller: listScrollController,
                itemBuilder: (context, index) {
                  double size = 0;
                  String unit = "";
                  if (snapshot.data.docs[index].data()["fileSize"] != null) {
                    if (snapshot.data.docs[index].data()["fileSize"] < 100000) {
                      size = snapshot.data.docs[index].data()["fileSize"] / 1000;
                      unit = "KB";
                    } else if (snapshot.data.docs[index].data()["fileSize"] > 100000) {
                      size = snapshot.data.docs[index].data()["fileSize"] / 1000000;
                      unit = "MB";
                    }
                  }
                  int itemCount = snapshot.data.docs.length ?? 0;
                  int reversedIndex = itemCount - 1 - index;
                  return MessageTile(
                    messageId: snapshot.data.docs[index].data()["messageId"]??"",
                    messageReaction: snapshot.data.docs[index].data()["messageReaction"]??[],
                    groupId: widget.groupId,
                    message: snapshot.data.docs[index].data()["message"],
                    sender: snapshot.data.docs[index].data()["sender"],
                    senderImage: snapshot.data.docs[index].data()["senderImage"]??"",
                    sentByMe: _user.uid == snapshot.data.docs[index].data()["senderId"],
                    messageTime: snapshot.data.docs[index].data()["time"].toString(),
                    isImage: snapshot.data.docs[index].data()["isImage"] ?? false,
                    isFile: snapshot.data.docs[index].data()["isFile"] ?? false,
                    isGif: snapshot.data.docs[index].data()["isGif"] ?? false,
                    fileExtension: snapshot.data.docs[index].data()["fileExtension"] ?? "",
                    fileName: snapshot.data.docs[index].data()["fileName"] ?? "",
                    fileSize: size.toStringAsPrecision(2),
                    fileSizeUnit: unit,
                    userId: _user.uid,
                    displayName: _user.displayName,
                    photo: _user.photoURL,
                    index: reversedIndex,
                    date: dateReversed,
                    time: timeReversed,
                    fileSizeFull: snapshot.data.docs[index].data()["fileSize"]??0,
                    isForwarded: snapshot.data.docs[index].data()["isForwarded"]!=null?true:false,
                    senderId: snapshot.data.docs[index].data()["senderId"],
                    selectMessage: selectedMessageFunc,
                    previousMessage: snapshot.data.docs[index].data()["previousMessage"]??"",
                    previousSender: snapshot.data.docs[index].data()["previousSender"]??"",
                    isAudio: snapshot.data.docs[index].data()["isAudio"] ?? false,
                    isPlaying: isPlaying[reversedIndex],
                    isPaused: isPaused[reversedIndex],
                    isLoadingAudio: isLoadingAudio[reversedIndex],
                    startAudio: startAudio,
                    pauseAudio: pauseAudio,
                    duration: duration,
                    currentDuration: currentDuration,
                    editMessage: editMessage,
                    showDate: showDate,
                    showDateToggle: showDateToggle,
                    isUserMember: isUserMember,
                    onEmojiKeyboardToggle: onEmojiKeyboardToggle,
                    //onPlusIconCall: onPlusIconCall,
                  );
                });
          } else {
            return Container();
          }
        },
      ),
    );
  }

  final audioPlayer = AudioPlayer();
  List<bool> isPlaying = [];
  List<bool> isPaused = [];
  List<bool> isLoadingAudio = [];
  Duration duration;
  Duration currentDuration;

  Future<void> startAudio(String url,int index) async {
    if(isPaused[index]==true){
      for(int i=0;i<isPlaying.length;i++){
        isPlaying[i] = false;
      }
      isPaused[index] = false;
      audioPlayer.play();
      setState(() {
        isPlaying[index] = true;
      });
      audioPlayer.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          setState(() {
            isPlaying[index] = false;
            isPaused[index] = false;
          });
        }
      });

      audioPlayer.positionStream.listen((event) {
        setState(() {
          currentDuration = event;
        });
      });

    }else{
      try{
        audioPlayer.playerStateStream.listen((state) {
          if (state.processingState == ProcessingState.completed) {
            setState(() {
              isPlaying[index] = false;
              isPaused[index] = false;
            });
          }
        });

        audioPlayer.positionStream.listen((event) {
          setState(() {
            currentDuration = event;
          });
        });

        audioPlayer.stop();
        for(int i=0;i<isPlaying.length;i++){
          isPlaying[i] = false;
        }
        setState(() {});

        var dir = await getApplicationDocumentsDirectory();
        var filePathAndName = dir.path + "/audios/" +url.split("/").last + ".m4a";
        if(File(filePathAndName).existsSync()){
          print("------File Already Exist-------");
          print(filePathAndName);
          duration = await audioPlayer.setFilePath(filePathAndName);
          audioPlayer.play();
          setState(() {
            isPlaying[index] = true;
          });
        }else{
          setState(() {
            isLoadingAudio[index] = true;
          });

          String path = await downloadAudio(url);

          setState(() {
            isLoadingAudio[index] = false;
          });

          if(path !=""){
            duration = await audioPlayer.setFilePath(path);
            audioPlayer.play();
            setState(() {
              isPlaying[index] = true;
            });
          }else{
            Fluttertoast.showToast(msg: "Something went wrong while playing audio please try again!", fontSize: 16, backgroundColor: Colors.black54, textColor: Colors.white, toastLength: Toast.LENGTH_LONG);
          }
        }

      }catch(e){
        print("Error loading audio source: $e");
      }
    }
  }

  void pauseAudio(int index)async{
    audioPlayer.pause();
    setState(() {
      isPlaying[index] = false;
      isPaused[index] = true;
    });
  }

  Future<String> downloadAudio(String url)async{
    var dir = await getApplicationDocumentsDirectory();
    var firstPath = dir.path + "/audios";
    var filePathAndName = dir.path + "/audios/" +url.split("/").last + ".m4a";
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

  Widget _members() {
    return StreamBuilder<DocumentSnapshot>(
        stream: DatabaseService().getGroupDetails(widget.groupId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data['createdAt']);
            return ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 25, left: 5),
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Text("${snapshot.data['members'].length} ${snapshot.data['members'].length < 2 ? "participant" : "participants"}",
                      style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w500, color: Colors.white)),
                ),
                ListView.builder(
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: snapshot.data['members'].length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.0),
                        child: FutureBuilder(
                            future: DatabaseService().getUsersDetails(snapshot.data['members'][index].split("_")[0]),
                            builder: (context, snapshot1) {
                              if (snapshot1.hasData) {
                                return ListTile(
                                  onTap: () {
                                    if (snapshot1.data.data()['uuid'] != null) {
                                      if (Provider.of<AuthUserProvider>(context, listen: false).authUser.id == snapshot1.data.data()['uuid']) {
                                        Navigator.of(context).pushNamed(ProfileScreen.profileScreenRoute);
                                      } else {
                                        Navigator.of(context).pushNamed(UserProfileScreen.routeName, arguments: {
                                          "id": snapshot1.data.data()['uuid'],
                                          "name": snapshot1.data.data()['displayName'],
                                          "photoUrl": snapshot1.data.data()['photoURL'],
                                          "firebaseUid": snapshot1.data.data()['uid']
                                        });
                                      }
                                    }
                                  },
                                  leading: snapshot1.data.data()['photoURL'] != null
                                      ? CircleAvatar(
                                          radius: 20,
                                          backgroundColor: MateColors.activeIcons,
                                          backgroundImage: NetworkImage(
                                            snapshot1.data.data()['photoURL'],
                                          ),
                                        )
                                      : CircleAvatar(
                                          radius: 20,
                                          backgroundColor: MateColors.activeIcons,
                                          child: Text(
                                            snapshot.data['members'][index].split('_')[1].substring(0, 1),
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                  contentPadding: EdgeInsets.only(top: 5),
                                  title: Text(currentUser.uid == snapshot1.data.data()['uid'] ? "You" : snapshot1.data.data()['displayName'],
                                      style: TextStyle(fontSize: 13.0.sp, fontWeight: FontWeight.w500, color: Colors.white)),
                                );
                              } else if (snapshot1.connectionState == ConnectionState.waiting) {
                                return SizedBox(
                                  height: 50,
                                  child: Center(
                                    child: LinearProgressIndicator(
                                      color: Colors.white,
                                      backgroundColor: myHexColor,
                                      // strokeWidth: 1.2,
                                      minHeight: 3,
                                    ),
                                  ),
                                );
                              }
                              return SizedBox();
                            }),
                      );
                    }),
              ],
            );
          } else
            return Center(child: Text("Oops! Something went wrong! \nplease trey again..", style: TextStyle(fontSize: 10.9.sp)));
        });
  }

  _sendMessage(String message, {bool isImage = false, bool isFile = false, bool isGif = false,bool isAudio=false}) {
    if (message.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": message.trim(),
        "sender": widget.userName,
        'senderId': _user.uid,
        'time': DateTime.now().millisecondsSinceEpoch,
        'isImage': isImage,
        'isFile': isFile,
        'isGif' : isGif,
        'isAudio':isAudio,
      };
      if (fileExtension.isNotEmpty) {
        chatMessageMap['fileExtension'] = fileExtension;
      }
      if (fileName.isNotEmpty) {
        chatMessageMap['fileName'] = fileName;
      }
      if (fileSize > 0) {
        chatMessageMap['fileSize'] = fileSize;
      }

      if(showSelected){
        chatMessageMap['previousSender'] = sender;
        chatMessageMap['previousMessage'] = selectedMessage;
      }

      DatabaseService().sendMessage(widget.groupId, chatMessageMap,_user.photoURL);
      listScrollController.animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
      setState(() {
        messageEditingController.text = "";
        showSelected = false;
      });

      Map<String, dynamic> body1 = {"group_id": widget.groupId, "read_by": _user.uid, "messages_read": messageLength + 1};
      Map<String, dynamic> body2 = {"group_id": widget.groupId, "total_messages": messageLength + 1};

      Future.delayed(Duration.zero, () {
        Provider.of<ChatProvider>(context, listen: false).groupChatMessageReadUpdate(body1);
        Provider.of<ChatProvider>(context, listen: false).groupChatDataUpdate(body2);
      });
    }
  }

  void _getGif() {
    // request your Giphy API key at https://developers.giphy.com/
    GiphyPicker.pickGif(
      context: context,
      apiKey: 'CiV4ZW1c1LiWXApeGQ7PNfRWBaVwf58Q',
      fullScreenDialog: false,
      previewType: GiphyPreviewType.previewWebp,
      decorator: GiphyDecorator(
        showAppBar: true,
        searchElevation: 4,
        giphyTheme: ThemeData.dark().copyWith(
          inputDecorationTheme: InputDecorationTheme(
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ),
    ).then((value) {
      _gifPath = value.images.downsized.url;
      if (_gifPath != null) {
        _sendMessage(_gifPath, isGif: true);
      }else{
        Fluttertoast.showToast(msg: 'Something went wrong.\nPlease try again');
      }
    });


  }

  Future _getFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(allowCompression: true);

    if (result != null) {
      file = File(result.files.single.path);
      fileExtension = result.files.single.extension;
      fileName = result.files.single.name;
      fileSize = result.files.single.size;

      if (result.files.single.size > 10480000) {
        Fluttertoast.showToast(msg: 'This file size must be within 10MB');
      } else {
        setState(() {
          isLoading = true;
        });
        _uploadFile();
      }
    } else {
      // User canceled the picker
    }
  }

  Future _getImage(int index) async {
    imageFile = index == 0 ?
    await ImagePicker.platform.pickImage(source: ImageSource.gallery) :
    await ImagePicker.platform.pickImage(source: ImageSource.camera);

    if (imageFile != null) {
      setState(() {
        isLoading = true;
      });
      _uploadImage();
    }
  }

  Future _uploadImage() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference = FirebaseStorage.instance.ref().child(fileName);

    File compressedFile = await FlutterNativeImage.compressImage(imageFile.path, quality: 80, percentage: 90);

    UploadTask uploadTask = reference.putFile(compressedFile);
    TaskSnapshot storageTaskSnapshot = await uploadTask.whenComplete(() {});
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      imageUrl = downloadUrl;
      setState(() {
        isLoading = false;
        _sendMessage(imageUrl, isImage: true);
      });
    }, onError: (err) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: 'This file is not an image');
    });
  }

  Future _uploadFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference = FirebaseStorage.instance.ref().child(fileName);

    UploadTask uploadTask = reference.putFile(file);
    TaskSnapshot storageTaskSnapshot = await uploadTask.whenComplete(() {});
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      fileUrl = downloadUrl;
      setState(() {
        isLoading = false;
        _sendMessage(fileUrl, isFile: true);
      });
    }, onError: (err) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: 'This is not a file');
    });
  }

  Future _uploadAudio() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference = FirebaseStorage.instance.ref().child(fileName);

    UploadTask uploadTask = reference.putFile(file);
    TaskSnapshot storageTaskSnapshot = await uploadTask.whenComplete(() {});
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      fileUrl = downloadUrl;
      setState(() {
        isLoading = false;
        _sendMessage(fileUrl, isAudio: true);
      });
    }, onError: (err) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: 'This is not a file');
    });
  }

  Widget _buildLoading() {
    return Positioned(
      child: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(myHexColor)),
              ),
              color: Colors.white.withOpacity(0.2),
            )
          : Container(),
    );
  }

  selectedMessageFunc(String message,String senderName,bool selected)async{
    selectedMessage = message;
    showSelected = selected;
    sender = senderName;
    setState(() {});
  }

  bool emojiShowing = false;
  onEmojiKeyboardToggle(){
    setState(() {
      emojiShowing = true;
    });
  }

  String messageId;
  List<dynamic> messageReaction;
  onPlusIconCall(String messageIdFromBack ,List<dynamic> messageReactionFromBack){
    messageId = messageIdFromBack;
    messageReaction = messageReactionFromBack;
  }

  Widget _messageSendWidget() {
    return Padding(
      padding: EdgeInsets.only(top: 20,bottom: Platform.isIOS?16:0),
      child: isUserMember?
      Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Visibility(
            visible: showSelected,
            child: Container(
              margin: EdgeInsets.only(left: 10,right: 10,bottom: 0),
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(
                left: 20,
                right: 10,
                top: 5,
                bottom: 20,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  topLeft: Radius.circular(10),
                  // bottomLeft: Radius.circular(10),
                  // bottomRight: Radius.circular(10),
                ),
                color: themeController.isDarkMode?MateColors.darkDivider:MateColors.lightDivider,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      onTap: (){
                        showSelected = false;
                        setState(() {});
                      },
                      child: Icon(Icons.clear,size: 20,),
                    ),
                  ),
                  Text(
                    sender,
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.1,
                      color: MateColors.activeIcons,
                      //color: themeController.isDarkMode? Colors.white : MateColors.blackTextColor,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    selectedMessage,
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.1,
                      color: themeController.isDarkMode? Colors.white : MateColors.blackTextColor,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          ),
          Consumer<SoundRecordNotifier>(
            builder: (cnt,state,child){
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Visibility(
                    visible: !state.buttonPressed,//!isPressed,
                    child: Expanded(
                      child: TextField(
                        controller: messageEditingController,
                        cursorColor: themeController.isDarkMode?MateColors.helpingTextDark:MateColors.helpingTextLight,
                        style:  TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.1,
                          color: themeController.isDarkMode?Colors.white:Colors.black,
                        ),
                        textInputAction: TextInputAction.done,
                        minLines: 1,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintStyle: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            color: themeController.isDarkMode?MateColors.helpingTextDark:MateColors.helpingTextLight,
                          ),
                          prefixIcon:  Padding(
                            padding: const EdgeInsets.only(left: 10,right: 10),
                            child: SpeedDial(
                              child: Container(
                                height: 50,
                                width: 50,
                                padding: const EdgeInsets.all(15.0),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: themeController.isDarkMode?MateColors.textFieldSearchDark:MateColors.containerLight
                                ),
                                child: Image.asset("lib/asset/icons/attachment.png",color: themeController.isDarkMode?Colors.white:Colors.black,),
                              ),
                              activeIcon: Icons.close,
                              spaceBetweenChildren: 6,
                              backgroundColor: themeController.isDarkMode?Colors.transparent:Colors.white,
                              elevation: 0,
                              foregroundColor: Colors.transparent,
                              activeForegroundColor: MateColors.activeIcons,
                              overlayColor: Colors.transparent,
                              overlayOpacity: 0.5,
                              switchLabelPosition: true,
                              tooltip: "Send File",
                              children: [
                                SpeedDialChild(
                                  child:  Image.asset(
                                    "lib/asset/chatPageAssets/gif@3x.png",
                                    width: 15.5.sp,
                                    color: Colors.black,
                                  ),
                                  label: "Gif",
                                  elevation: 2.0,
                                  onTap: () => _getGif(),
                                ),
                                SpeedDialChild(
                                  child: Icon(Icons.image),
                                  label: "Image",
                                  elevation: 2.0,
                                  onTap: () => _getImage(0),
                                ),
                                SpeedDialChild(
                                  child:Icon(Icons.camera_alt),
                                  label: "Camera",
                                  elevation: 2.0,
                                  onTap: () => _getImage(1),
                                ),
                                SpeedDialChild(
                                  child:Icon(Icons.file_present),
                                  label: "Document",
                                  elevation: 2.0,
                                  onTap: () => _getFile(),
                                ),
                              ],
                            ),
                          ),
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.send,
                                  size: 20,
                                  color: Color(0xFF65656B),
                                ),
                                onPressed: ()async{
                                  if(isEditing){
                                    if(messageEditingController.text.isNotEmpty)
                                      await DatabaseService().editMessage(editGroupId, editMessageId, messageEditingController.text.trim());
                                    setState(() {
                                      isEditing = false;
                                      messageEditingController.text = "";
                                    });
                                  }else{
                                    _sendMessage(messageEditingController.text.trim());
                                  }
                                },
                              ),
                              isEditing?
                              IconButton(
                                  onPressed: (){
                                    setState(() {
                                      isEditing = false;
                                      messageEditingController.text = "";
                                    });
                                  },
                                  icon: Icon(
                                    Icons.clear,
                                    color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
                                  )
                              ):SizedBox(),
                            ],
                          ),
                          hintText: "Write a message...",
                          fillColor: themeController.isDarkMode ? MateColors.containerDark : MateColors.containerLight,
                          filled: true,
                          focusedBorder: commonBorderCircular,
                          enabledBorder: commonBorderCircular,
                          disabledBorder: commonBorderCircular,
                          errorBorder: commonBorderCircular,
                          focusedErrorBorder: commonBorderCircular,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: state.buttonPressed?120:0),
                    child: SocialMediaRecorder(
                      backGroundColor: MateColors.activeIcons,
                      recordIconBackGroundColor: MateColors.activeIcons,
                      sendRequestFunction: (soundFile) {
                        print("the current path is ${soundFile.path}");
                        file = File(soundFile.path);
                        fileSize = soundFile.lengthSync();
                        if (fileSize > 10480000) {
                          Fluttertoast.showToast(msg: 'This file size must be within 10MB');
                        } else {
                          setState(() {
                            isLoading = true;
                          });
                          _uploadAudio();
                        }
                      },
                      encode: AudioEncoderType.AAC,
                    ),
                  ),
                ],
              );
            },
          ),
          // Offstage(
          //   offstage: !emojiShowing,
          //   child: SizedBox(
          //       height: 350,
          //       child: EmojiPicker(
          //         onEmojiSelected: (cat,emoji)async{
          //           print(cat);
          //           print(emoji.emoji);
          //           setState(() {
          //             emojiShowing = false;
          //           });
          //           String previousValue = "";
          //           bool add = true;
          //           print(messageId);
          //           if(messageId!=""){
          //             for(int i=0; i< messageReaction.length ;i++){
          //               if(messageReaction[i].contains(_user.uid)){
          //                 add = false;
          //                 previousValue = messageReaction[i];
          //                 await DatabaseService(uid: _user.uid).updateMessageReaction(widget.groupId, messageId,previousValue);
          //                 await DatabaseService(uid: _user.uid).setMessageReaction(widget.groupId, messageId, emoji.emoji,_user.displayName,_user.photoURL);
          //                 break;
          //               }
          //             }
          //             if(add){
          //               DatabaseService(uid: _user.uid).setMessageReaction(widget.groupId, messageId, emoji.emoji,_user.displayName,_user.photoURL);
          //             }
          //           }
          //         },
          //         config: Config(
          //           columns: 7,
          //           emojiSizeMax: 32 * (foundation.defaultTargetPlatform == TargetPlatform.iOS ? 1.30 : 1.0),
          //           verticalSpacing: 0,
          //           horizontalSpacing: 0,
          //           gridPadding: EdgeInsets.zero,
          //           initCategory: Category.RECENT,
          //           bgColor: const Color(0xFFF2F2F2),
          //           indicatorColor: Colors.blue,
          //           iconColor: Colors.grey,
          //           iconColorSelected: Colors.blue,
          //           backspaceColor: Colors.blue,
          //           skinToneDialogBgColor: Colors.white,
          //           skinToneIndicatorColor: Colors.grey,
          //           enableSkinTones: true,
          //           showRecentsTab: true,
          //           recentsLimit: 28,
          //           replaceEmojiOnLimitExceed: false,
          //           noRecents: const Text(
          //             'No Recents',
          //             style: TextStyle(fontSize: 20, color: Colors.black26),
          //             textAlign: TextAlign.center,
          //           ),
          //           loadingIndicator: const SizedBox.shrink(),
          //           tabIndicatorAnimDuration: kTabScrollDuration,
          //           categoryIcons: const CategoryIcons(),
          //           buttonMode: ButtonMode.MATERIAL,
          //           checkPlatformCompatibility: true,
          //         ),
          //       )),
          // ),
        ],
      ):
      Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20,20,20,20),
        decoration: BoxDecoration(
          color: themeController.isDarkMode?MateColors.drawerTileColor:Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("You can't send message to this group because",
              style: TextStyle(letterSpacing: 0.1,fontSize: 14,fontFamily: "Poppins",fontWeight: FontWeight.w500,color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,),
            ),
            SizedBox(
              height: 5,
            ),
            Text("you're no longer a participant.",
              style: TextStyle(letterSpacing: 0.1,fontSize: 14,fontFamily: "Poppins",fontWeight: FontWeight.w500,color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    getGroupDetails();
    DatabaseService().getChats(widget.groupId).then((val) {
      setState(() {
        _chats = val;
      });
    });
  }

  DocumentSnapshot documentSnapshot;
  getGroupDetails()async{
    documentSnapshot =  await DatabaseService().getGroupDetailsOnce(widget.groupId);
    isUserMember = documentSnapshot['members'].contains(_user.uid + '_' + _user.displayName);
    setState(() {});
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioRecorder.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  bool isPressed = false;
  int _recordDuration = 0;
  Timer _timer;
  final _audioRecorder = Record();
  bool sendAudio = false;
  bool showCancelLock = false;
  bool showLockedView = false;
  bool isPausedRecording = false;

  startRecording()async{
    try {
      if (await _audioRecorder.hasPermission()) {
        Directory appDocDir = await getApplicationDocumentsDirectory();
        String appDocPath = appDocDir.path + "/" + _user.uid + ".m4a";
        if(File(appDocPath).existsSync()){
          print("Deleted");
          await File(appDocPath).delete();
        }
        await _audioRecorder.start(
          path: appDocPath,
        );
        _recordDuration = 0;
        minute = 0;
        second = 0;
        _startTimer();
      }
    } catch (e) {
      print(e.toString());
    }
  }


  int minute = 0,second=0;
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      _recordDuration++;
      print(_recordDuration);

      int n = _recordDuration;
      n %= 3600;
      minute = n ~/ 60 ;

      n %= 60;
      second = n;
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final scH = MediaQuery.of(context).size.height;
    final scW = MediaQuery.of(context).size.width;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: (){
        setState(() {
          if(emojiShowing){
            emojiShowing = false;
          }
        });
      },
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
          child: Stack(
            children: [
              Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height*0.07,
                      left: 16,
                      right: 16,
                      bottom: 10,
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
                        InkWell(
                          onTap: ()async{
                            await Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => GroupSettingsPage(
                                  groupId: widget.groupId,
                                )));
                            getGroupDetails();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              widget.photoURL != "" ?
                              Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: CircleAvatar(
                                  radius: 22,
                                  backgroundImage: NetworkImage(widget.photoURL),
                                ),
                              ) :
                              Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: CircleAvatar(
                                  radius: 22,
                                  backgroundColor: MateColors.activeIcons,
                                  child: Text(widget.groupName.substring(0, 1).toUpperCase(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: themeController.isDarkMode?Colors.black:Colors.white, fontSize: 13.0.sp, fontWeight: FontWeight.w400)),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  buildEmojiAndText(
                                    content: widget.groupName,
                                    textStyle: TextStyle(
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w600,
                                      color: themeController.isDarkMode?Colors.white:MateColors.blackText,
                                    ),
                                    normalFontSize: 15,
                                    emojiFontSize: 25,
                                  ),
                                  Text(widget.totalParticipant + " members",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w400,
                                      color: themeController.isDarkMode?Colors.white.withOpacity(0.5):Colors.black.withOpacity(0.5),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(),
                        SizedBox(),
                        SizedBox(),
                        SizedBox(),
                        Row(
                          children: [
                            IconButton(
                              onPressed: ()async{
                                if(isUserMember){
                                  QuerySnapshot res = await DatabaseService().checkCallIsOngoing(widget.groupId);
                                  if(res.docs.length>0){
                                    DateTime dateTimeLocal = DateTime.now();
                                    DateTime dateFormatServer = new DateTime.fromMillisecondsSinceEpoch(int.parse(res.docs[0]['createdAt'].toString()));
                                    Duration diff = dateTimeLocal.difference(dateFormatServer);
                                    print(diff.inMinutes);
                                    if(diff.inMinutes<120){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => Calling(
                                        channelName: res.docs[0]['channelName'],
                                        token: res.docs[0]['token'],
                                        callType: res.docs[0]['callType'],
                                        image: widget.photoURL,
                                        name: widget.groupName,
                                        isGroupCall: true,
                                      )));
                                    }else{
                                      Get.to(()=>ConnectingScreen(
                                        callType: "Audio Calling",
                                        receiverImage: widget.photoURL,
                                        receiverName: widget.groupName,
                                        uid: widget.memberList,
                                        isGroupCalling: true,
                                        groupOrPeerId: widget.groupId,
                                        groupOrCallerName: widget.groupName,
                                      ));
                                    }
                                  }else{
                                    Get.to(()=>ConnectingScreen(
                                      callType: "Audio Calling",
                                      receiverImage: widget.photoURL,
                                      receiverName: widget.groupName,
                                      uid: widget.memberList,
                                      isGroupCalling: true,
                                      groupOrPeerId: widget.groupId,
                                      groupOrCallerName: widget.groupName,
                                    ));
                                  }
                                }
                              },
                              icon: Icon(Icons.call,
                                color: themeController.isDarkMode?Colors.white:Colors.black,
                              ),
                            ),
                            IconButton(
                              onPressed: ()async{
                                if(isUserMember){
                                  QuerySnapshot res = await DatabaseService().checkCallIsOngoing(widget.groupId);
                                  if(res.docs.length>0){
                                    DateTime dateTimeLocal = DateTime.now();
                                    DateTime dateFormatServer = new DateTime.fromMillisecondsSinceEpoch(int.parse(res.docs[0]['createdAt'].toString()));
                                    Duration diff = dateTimeLocal.difference(dateFormatServer);
                                    print(diff.inMinutes);
                                    if(diff.inMinutes<120){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => Calling(
                                        channelName: res.docs[0]['channelName'],
                                        token: res.docs[0]['token'],
                                        callType: res.docs[0]['callType'],
                                        image: widget.photoURL,
                                        name: widget.groupName,
                                        isGroupCall: true,
                                      )));
                                    }else{
                                      Get.to(()=>ConnectingScreen(
                                        callType: "Video Calling",
                                        receiverImage: widget.photoURL,
                                        receiverName: widget.groupName,
                                        uid: widget.memberList,
                                        isGroupCalling: true,
                                        groupOrPeerId: widget.groupId,
                                        groupOrCallerName: widget.groupName,
                                      ));
                                    }
                                  }else{
                                    Get.to(()=>ConnectingScreen(
                                      callType: "Video Calling",
                                      receiverImage: widget.photoURL,
                                      receiverName: widget.groupName,
                                      uid: widget.memberList,
                                      isGroupCalling: true,
                                      groupOrPeerId: widget.groupId,
                                      groupOrCallerName: widget.groupName,
                                    ));
                                  }
                                }
                              },
                              icon: Icon(Icons.video_call_rounded,
                                color: themeController.isDarkMode?Colors.white:Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(child: _chatMessages()),
                  _messageSendWidget(),
                ],
              ),
              _buildLoading(),
            ],
          ),
        ),
      ),
    );
  }
}

/*Stack(
          fit: StackFit.loose,
          children: [

           // Container(child: _members()),
          // Container(
          //   alignment: Alignment.center,
          //   child: InkWell(
          //       onTap: () async {
          //         String shareableLink = await DynamicLinkService.buildDynamicLink(groupId: widget.groupId, groupName: widget.groupName, groupIcon: widget.photoURL, userName: widget.userName);
          //         Share.share("Follow this link to join my MATE group $shareableLink");
          //       },
          //       child: SendInvitationButton("Invite People")),
          // ),
            // buildLoading(),
          ],
        ),*/
