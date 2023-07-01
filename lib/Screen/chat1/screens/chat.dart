import 'dart:async';
import 'dart:io';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mate_app/Providers/chatProvider.dart';
import 'package:mate_app/Screen/Profile/UserProfileScreen.dart';
import 'package:mate_app/Screen/chat1/screens/personMessageTile.dart';
import 'package:mate_app/asset/Colors/MateColors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';
import '../../../Widget/social_media_recorder/audio_encoder_type.dart';
import '../../../Widget/social_media_recorder/provider/sound_record_notifier.dart';
import '../../../Widget/social_media_recorder/screen/social_media_recorder.dart';
import '../../../audioAndVideoCalling/calling.dart';
import '../../../audioAndVideoCalling/connectingScreen.dart';
import '../../../constant.dart';
import '../../../controller/theme_controller.dart';
import '../../../groupChat/services/database_service.dart';
import '../constForChat.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:http/http.dart'as http;

class Chat extends StatelessWidget {
  final String peerUuid;
  final String peerId;
  final String peerAvatar;
  final String peerName;
  final String currentUserId;
  final String roomId;
  Chat({Key key, @required this.peerUuid, @required this.currentUserId, @required this.peerId, @required this.peerAvatar, @required this.peerName, this.roomId}) : super(key: key);

  ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    final scH = MediaQuery.of(context).size.height;
    final scW = MediaQuery.of(context).size.width;
    return new Scaffold(
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
                      color: themeController.isDarkMode ? Colors.white : MateColors.blackTextColor,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 0),
                    child: InkWell(
                      onTap: () {
                        if (peerUuid != null) {
                          Navigator.of(context).pushNamed(UserProfileScreen.routeName, arguments: {"id": peerUuid, "name": peerName, "photoUrl": peerAvatar, "firebaseUid": peerId});
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: CircleAvatar(
                              radius: 22,
                              backgroundImage: NetworkImage(
                                peerAvatar,
                              ),
                            ),
                          ),
                          Text(
                            " $peerName",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600,
                              color: themeController.isDarkMode?Colors.white:MateColors.blackText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(),
                  Row(
                    children: [
                      IconButton(
                        onPressed: ()async{
                          String id = currentUserId ?? '';
                          String personChatId;
                          if (id.hashCode <= peerId.hashCode) {
                            personChatId = '$id-$peerId';
                          } else {
                            personChatId = '$peerId-$id';
                          }
                          String callerName = FirebaseAuth.instance.currentUser.displayName;

                          QuerySnapshot res = await DatabaseService().checkCallIsOngoing(personChatId);
                          if(res.docs.length>0){
                            DateTime dateTimeLocal = DateTime.now();
                            DateTime dateFormatServer = new DateTime.fromMillisecondsSinceEpoch(int.parse(res.docs[0]['createdAt'].toString()));
                            Duration diff = dateTimeLocal.difference(dateFormatServer);
                            print(diff.inMinutes);
                            if(diff.inMinutes<120){
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Calling(
                                channelName: res.docs[0]['channelName'],
                                token: res.docs[0]['token'],
                                callType: res.docs[0]['callType'],
                                image: peerAvatar,
                                name: peerName,
                                isGroupCall: false,
                              )));
                            }else{
                              Get.to(()=>ConnectingScreen(
                                callType: "Audio Calling",
                                receiverImage: peerAvatar,
                                receiverName: peerName,
                                uid: [peerId],
                                isGroupCalling: false,
                                groupOrPeerId: personChatId,
                                groupOrCallerName: callerName,
                              ));
                            }
                          }else{
                            Get.to(()=>ConnectingScreen(
                              callType: "Audio Calling",
                              receiverImage: peerAvatar,
                              receiverName: peerName,
                              uid: [peerId],
                              isGroupCalling: false,
                              groupOrPeerId: personChatId,
                              groupOrCallerName: callerName,
                            ));
                          }
                        },
                        icon: Icon(Icons.call,
                          color: themeController.isDarkMode?Colors.white:Colors.black,
                        ),
                      ),
                      IconButton(
                        onPressed: ()async{
                          String id = currentUserId ?? '';
                          String personChatId;
                          if (id.hashCode <= peerId.hashCode) {
                            personChatId = '$id-$peerId';
                          } else {
                            personChatId = '$peerId-$id';
                          }
                          String callerName = FirebaseAuth.instance.currentUser.displayName;

                          QuerySnapshot res = await DatabaseService().checkCallIsOngoing(personChatId);
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
                                image: peerAvatar,
                                name: peerName,
                                isGroupCall: false,
                              )));
                            }else{
                              Get.to(()=>ConnectingScreen(
                                callType: "Video Calling",
                                receiverImage: peerAvatar,
                                receiverName: peerName,
                                uid: [peerId],
                                isGroupCalling: false,
                                groupOrPeerId: personChatId,
                                groupOrCallerName: callerName,
                              ));
                            }
                          }else{
                            Get.to(()=>ConnectingScreen(
                              callType: "Video Calling",
                              receiverImage: peerAvatar,
                              receiverName: peerName,
                              uid: [peerId],
                              isGroupCalling: false,
                              groupOrPeerId: personChatId,
                              groupOrCallerName: callerName,
                            ));
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
            Expanded(
              child: _ChatScreen(
                currentUserId: currentUserId,
                peerId: peerId,
                peerAvatar: peerAvatar,
                peerName: peerName,
                roomId: roomId,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatScreen extends StatefulWidget {
  final String peerId;
  final String peerAvatar;
  final String currentUserId;
  final String peerName;
  final String roomId;
  _ChatScreen({Key key, @required this.peerId, @required this.peerAvatar, @required this.currentUserId, this.peerName, this.roomId}) : super(key: key);

  @override
  State createState() => new _ChatScreenState(peerId: peerId, peerAvatar: peerAvatar);
}

class _ChatScreenState extends State<_ChatScreen> {
  _ChatScreenState({Key key, @required this.peerId, @required this.peerAvatar});
  String peerId;
  String peerAvatar;
  String id;
  bool firstHit = true;
  bool readMessageUpdate=true;

  var listMessage;
  String personChatId;

  PickedFile imageFile;
  bool isLoading;
  bool isShowSticker;
  String imageUrl;

  File file;
  String fileExtension = "";
  String fileName = "";
  int fileSize = 0;
  String fileUrl;

  final TextEditingController textEditingController = new TextEditingController();
  final ScrollController listScrollController = new ScrollController();
  final FocusNode focusNode = new FocusNode();
  ThemeController themeController = Get.find<ThemeController>();
  User _user;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    focusNode.addListener(onFocusChange);
    personChatId = '';
    isLoading = false;
    isShowSticker = false;
    imageUrl = '';
    readLocal();
  }


  bool isPressed = false;
  int _recordDuration = 0;
  Timer _timer;
  final _audioRecorder = Record();
  bool sendAudio = false;
  bool showCancelLock = false;
  bool showLockedView = false;
  bool isPausedRecording = false;
  bool showDate = false;

  void showDateToggle(){
    setState(() {
      showDate = !showDate;
    });
  }

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
  void dispose() {
    _timer?.cancel();
    _audioRecorder.dispose();
    audioPlayer.dispose();
    super.dispose();
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


  void onFocusChange() {
    if (focusNode.hasFocus) {
      setState(() {
        isShowSticker = false;
      });
    }
  }

  readLocal() async {
    id = widget.currentUserId ?? '';
    if (id.hashCode <= peerId.hashCode) {
      personChatId = '$id-$peerId';
    } else {
      personChatId = '$peerId-$id';
    }
    setState(() {});
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

    }
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
        onSendMessage(fileUrl, 3);
      });
    }, onError: (err) {
      setState(() {
        isLoading = false;
      });
      print("err $err");
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
        onSendMessage(fileUrl, 4);
      });
    }, onError: (err) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: 'This is not a file');
    });
  }

  Future getImage(int index) async {
    imageFile = index == 0 ? await ImagePicker.platform.pickImage(source: ImageSource.gallery) : await ImagePicker.platform.pickImage(source: ImageSource.camera);

    if (imageFile != null) {
      setState(() {
        isLoading = true;
      });
      uploadImage();
    }
  }

  Future uploadImage() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference = FirebaseStorage.instance.ref().child(fileName);

    File compressedFile = await FlutterNativeImage.compressImage(imageFile.path, quality: 80, percentage: 90);

    UploadTask uploadTask = reference.putFile(compressedFile);
    TaskSnapshot storageTaskSnapshot = await uploadTask.whenComplete(() {});
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      imageUrl = downloadUrl;
      setState(() {
        isLoading = false;
        onSendMessage(imageUrl, 1);
      });
    }, onError: (err) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: 'This file is not an image');
    });
  }

  void onSendMessage(String content, int type) {
    print(type);
    if (content.trim() != '') {
      textEditingController.clear();

      var documentReference = FirebaseFirestore.instance.collection('messages').doc(personChatId).collection(personChatId).doc(DateTime.now().millisecondsSinceEpoch.toString());

      Map<String, dynamic> chatMessageMap = {'idFrom': id, 'idTo': peerId, 'timestamp': DateTime.now().millisecondsSinceEpoch.toString(), 'content': content.trim(), 'type': type,'messageId':documentReference.id};
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

      FirebaseFirestore.instance.runTransaction((transaction) async {
        await transaction.set(
          documentReference,
          chatMessageMap,
        );
      });
      listScrollController.animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.easeOut);

      setState(() {
        showSelected = false;
      });

      if (firstHit) {
        FirebaseFirestore.instance.collection('chat-users').doc(id).update({
          'chattingWith': FieldValue.arrayUnion([peerId])
        });
        FirebaseFirestore.instance.collection('chat-users').doc(widget.peerId).update({
          'chattingWith': FieldValue.arrayUnion([id])
        });
        firstHit = false;
      }
      /// our server api call--->

      Map<String, dynamic> body1={
        "room_id": personChatId,
        "read_by": widget.currentUserId,
        "messages_read": listMessage.length+1
      };
      Map<String, dynamic> body2={
        "room_id": personChatId,
        "receiver_uid": widget.peerId,
        "total_messages": listMessage.length+1
      };

      Future.delayed(Duration.zero,(){
        Provider.of<ChatProvider>(context,listen: false).personalChatMessageReadUpdate(body1);
        Provider.of<ChatProvider>(context,listen: false).personalChatDataUpdate(body2);
      });
    } else {
      Fluttertoast.showToast(msg: 'Nothing to send');
    }
  }

  String selectedMessage = "";
  String sender = "";
  bool showSelected = false;
  selectedMessageFunc(String message,String senderName,bool selected)async{
    selectedMessage = message;
    showSelected = selected;
    sender = senderName;
    setState(() {});
  }

  int messageLength = 0;

  bool isEditing = false;
  String editPersonChatId;
  String editMessageId;
  void editMessage(String personChatId,String messageId,String previousMessage)async{
    setState(() {
      isEditing = true;
      editPersonChatId = personChatId;
      editMessageId = messageId;
      textEditingController.text = previousMessage;
    });
  }

  @override
  Widget build(BuildContext context) {
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
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              // List of messages
              // ChatWidget.widgetChatBuildListMessage(personChatId, listMessage, widget.currentUserId, peerAvatar, listScrollController),

              Flexible(
                child: personChatId == ''
                    ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(themeColor)))
                    : GestureDetector(
                  onHorizontalDragStart: (val){
                    showDateToggle();
                  },
                  onHorizontalDragEnd: (val){
                    showDateToggle();
                  },
                      child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('messages').doc(personChatId).collection(personChatId).orderBy('timestamp', descending: true) /*.limit(20)*/ .snapshots(),
                  builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(themeColor)));
                      } else {
                        listMessage = snapshot.data.docs;

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

                        if(readMessageUpdate){
                          Map<String, dynamic> body={
                            "room_id": personChatId,
                            "read_by": widget.currentUserId,
                            "messages_read": listMessage.length
                          };
                          Future.delayed(Duration.zero,(){
                            Provider.of<ChatProvider>(context,listen: false).personalChatMessageReadUpdate(body);
                            Provider.of<ChatProvider>(context,listen: false).personalChatDataFetch(widget.currentUserId);
                          });
                          readMessageUpdate=false;
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
                          DateTime dateFormat = new DateTime.fromMillisecondsSinceEpoch(int.parse(snapshot.data.docs[i].data()["timestamp"].toString()));
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
                            return PersonMessageTile(
                              messageTime: snapshot.data.docs[index].data()["timestamp"],
                              message: snapshot.data.docs[index].data()["content"],
                              sentByMe: snapshot.data.docs[index].data()["idFrom"] == id,
                              isImage: snapshot.data.docs[index].data()["type"] == 1,
                              isFile: snapshot.data.docs[index].data()["type"] == 3,
                              fileExtension: snapshot.data.docs[index].data()["fileExtension"] ?? "",
                              fileName: snapshot.data.docs[index].data()["fileName"] ?? "",
                              fileSize: size.toStringAsPrecision(2),
                              fileSizeUnit: unit,
                              index: reversedIndex,
                              date: dateReversed,
                              time: timeReversed,
                              isForwarded: snapshot.data.docs[index].data()["isForwarded"]!=null?true:false,
                              messageReaction: snapshot.data.docs[index].data()["messageReaction"]??[],
                              messageId: snapshot.data.docs[index].data()["messageId"]??"",
                              userId: _user.uid,
                              displayName: _user.displayName,
                              photo: _user.photoURL,
                              personChatId: personChatId,
                              fileSizeFull: snapshot.data.docs[index].data()["fileSize"]??0,
                              sender: snapshot.data.docs[index].data()["idFrom"] == id?_user.displayName:widget.peerName,
                              selectMessage: selectedMessageFunc,
                              previousMessage: snapshot.data.docs[index].data()["previousMessage"]??"",
                              previousSender: snapshot.data.docs[index].data()["previousSender"]??"",
                              roomId: widget.roomId,
                              isAudio: snapshot.data.docs[index].data()["type"] == 4,
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
                              onEmojiKeyboardToggle: onEmojiKeyboardToggle,
                              //onPlusIconCall: onPlusIconCall,
                            );
                          },
                          // ChatWidget.widgetChatBuildItem(context, listMessage, widget.currentUserId, index, snapshot.data.documents[index], peerAvatar),
                          itemCount: snapshot.data.docs.length,
                          reverse: true,
                          controller: listScrollController,
                        );
                      }
                  },
                ),
                    ),
              ),
              buildInput(),
            ],
          ),
          buildLoading()
        ],
      ),
    );
  }

  Widget buildLoading() {
    return Positioned(
      child: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(themeColor)),
              ),
              color: Colors.white.withOpacity(0.2),
            )
          : Container(),
    );
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

  Widget buildInput() {
    return Padding(
      padding: EdgeInsets.only(top: 20,bottom: Platform.isIOS?16:0),
      child: Column(
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
                color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
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
                         controller: textEditingController,
                         cursorColor: themeController.isDarkMode?MateColors.helpingTextDark:MateColors.helpingTextLight,
                         style: TextStyle(
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
                                   child:Icon(Icons.image),
                                   label: "Image",
                                   elevation: 2.0,
                                   onTap: () => getImage(0),
                                 ),
                                 SpeedDialChild(
                                   child:Icon(Icons.camera_alt),
                                   label: "Camera",
                                   elevation: 2.0,
                                   onTap: () => getImage(1),
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
                           suffixIcon: Padding(
                             padding: const EdgeInsets.only(right: 10),
                             child: Row(
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
                                       if(textEditingController.text.isNotEmpty)
                                         await DatabaseService().editMessageOneToOne(editPersonChatId, editMessageId, textEditingController.text.trim());
                                       setState(() {
                                         isEditing = false;
                                         textEditingController.text = "";
                                       });
                                     }else{
                                       onSendMessage(textEditingController.text, 0);
                                     }
                                   },
                                 ),
                                 isEditing?
                                 IconButton(
                                     onPressed: (){
                                       setState(() {
                                         isEditing = false;
                                         textEditingController.text = "";
                                       });
                                     },
                                     icon: Icon(
                                       Icons.clear,
                                       color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
                                     )
                                 ):SizedBox(),
                               ],
                             ),
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
                     margin: EdgeInsets.only(top: state.buttonPressed?120:0,right: 5),
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
          //           if(messageId!=""){
          //             for(int i=0; i< messageReaction.length ;i++){
          //               if(messageReaction[i].contains(_user.uid)){
          //                 add = false;
          //                 previousValue = messageReaction[i];
          //                 await DatabaseService(uid: _user.uid).updateMessageReactionOneToOne(personChatId, messageId,previousValue);
          //                 await DatabaseService(uid: _user.uid).setMessageReactionOneToOne(personChatId, messageId, emoji.emoji,_user.displayName,_user.photoURL);
          //                 break;
          //               }
          //             }
          //             if(add){
          //               DatabaseService(uid: _user.uid).setMessageReactionOneToOne(personChatId, messageId, emoji.emoji,_user.displayName,_user.photoURL);
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
      ),
    );
  }
}
