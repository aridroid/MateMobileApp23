import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
import 'package:provider/provider.dart';
import '../../../audioAndVideoCalling/connectingScreen.dart';
import '../../../controller/theme_controller.dart';
import '../chatWidget.dart';
import 'package:mate_app/Utility/Utility.dart' as config;
import '../constForChat.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class Chat extends StatelessWidget {
  final String peerUuid;
  final String peerId;
  final String peerAvatar;
  final String peerName;
  final String currentUserId;

  Chat({Key key, @required this.peerUuid, @required this.currentUserId, @required this.peerId, @required this.peerAvatar, @required this.peerName}) : super(key: key);

  ThemeController themeController = Get.find<ThemeController>();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      //backgroundColor: config.myHexColor,
      appBar: AppBar(
        //leadingWidth: 30,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              size: 24,
            )),
        elevation: 0,
        iconTheme: IconThemeData(
          color: MateColors.activeIcons,
        ),
        centerTitle: true,
        //backgroundColor: config.myHexColor,
        title: Padding(
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
                    radius: 12,
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
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.1,
                    color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        bottom: PreferredSize(
            child: Container(
              color: themeController.isDarkMode?MateColors.darkDivider:MateColors.lightDivider,
              height: 1.0,
            ),
            preferredSize: Size.fromHeight(0.0),
        ),
        actions: [
          IconButton(
              onPressed: (){
                Get.to(()=>ConnectingScreen(
                  callType: "Audio Calling",
                  receiverImage: peerAvatar,
                  receiverName: peerName,
                  uid: [peerId],
                  isGroupCalling: false,
                ));
              },
              icon: Icon(Icons.call,color: MateColors.activeIcons,),
          ),
          IconButton(
            onPressed: (){
              Get.to(()=>ConnectingScreen(
                callType: "Video Calling",
                receiverImage: peerAvatar,
                receiverName: peerName,
                uid: [peerId],
                isGroupCalling: false,
              ));
            },
            icon: Icon(Icons.video_call_rounded,color: MateColors.activeIcons,),
          ),
        ],
      ),
      body: new _ChatScreen(
        currentUserId: currentUserId,
        peerId: peerId,
        peerAvatar: peerAvatar,
      ),
    );
  }
}

class _ChatScreen extends StatefulWidget {
  final String peerId;
  final String peerAvatar;
  final String currentUserId;

  _ChatScreen({Key key, @required this.peerId, @required this.peerAvatar, @required this.currentUserId}) : super(key: key);

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

  void onFocusChange() {
    if (focusNode.hasFocus) {
      // Hide sticker when keyboard appear
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
      // User canceled the picker
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
    // type: 0 = text, 1 = image, 2 = sticker
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

      FirebaseFirestore.instance.runTransaction((transaction) async {
        await transaction.set(
          documentReference,
          chatMessageMap,
        );
      });
      listScrollController.animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.easeOut);

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

  Future<bool> onBackPress() {
    Navigator.pop(context);
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              // List of messages
              // ChatWidget.widgetChatBuildListMessage(personChatId, listMessage, widget.currentUserId, peerAvatar, listScrollController),

              Flexible(
                child: personChatId == ''
                    ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(themeColor)))
                    : StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('messages').doc(personChatId).collection(personChatId).orderBy('timestamp', descending: true) /*.limit(20)*/ .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(themeColor)));
                    } else {
                      listMessage = snapshot.data.docs;
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
                          date.add("Today");
                        }else if(dateFormatted == dateFormattedYesterday){
                          date.add("Yesterday");
                        }else{
                          date.add(dateFormatted);
                        }
                        String formattedTime = DateFormat.jm().format(dateFormat);
                        time.add(formattedTime);
                      }

                      List<String> dateReversed = date.reversed.toList();
                      List<String> timeReversed = time.reversed.toList();


                      return ListView.builder(
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
              // Input content
              buildInput(),
            ],
          ),

          // Loading
          buildLoading()
        ],
      ),
      onWillPop: onBackPress,
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

  Widget buildInput() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // Button send image
        /*IconButton(
          padding: EdgeInsets.all(0),
          icon: new Icon(Icons.image),
          onPressed: () => getImage(0),
          color: Colors.grey,
        ),
        IconButton(
          padding: EdgeInsets.all(0),
          icon: new Icon(Icons.camera_alt),
          onPressed: () => getImage(1),
          color: Colors.grey,
        ),
        IconButton(
          padding: EdgeInsets.all(0),
          icon: new Icon(Icons.attach_file),
          onPressed: () => _getFile(),
          color: Colors.grey,
        ),
*/
        Flexible(
          child: Container(
            //alignment: Alignment.bottomCenter,
            // width: MediaQuery.of(context).size.width * 0.5,
            //margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
            //padding: EdgeInsets.only(left: 15),
            decoration: BoxDecoration(
                //borderRadius: BorderRadius.all(Radius.circular(12.0)),
              border: Border(
                top: BorderSide(
                  color: themeController.isDarkMode?MateColors.darkDivider:MateColors.lightDivider,
                  width: 0.3,
                ),
              ),
            ),
            child: TextField(
              controller: textEditingController,
              cursorColor: Colors.cyanAccent,
              style: TextStyle(fontSize: 12.5.sp, height: 2.0, color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor),
              textInputAction: TextInputAction.done,
              minLines: 1,
              maxLines: 4,
              decoration: InputDecoration(
                hintStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.1,
                  color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
                ),
                prefixIcon:  Padding(
                  padding: const EdgeInsets.only(left: 10,right: 10),
                  child: SpeedDial(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Image.asset("lib/asset/icons/attachment.png"),
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
                  child: IconButton(
                    icon: Icon(
                      Icons.send,
                      size: 20,
                      color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
                    ),
                    onPressed: ()async{
                      onSendMessage(textEditingController.text, 0);
                    },
                  ),
                ),
                hintText: "Write a message...",
                focusedBorder: OutlineInputBorder(
                  borderSide:  BorderSide(
                    color: themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightButtonBackground,
                  ),
                  borderRadius: BorderRadius.circular(26.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:  BorderSide(
                    color:  themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightButtonBackground,
                  ),
                  borderRadius: BorderRadius.circular(26.0),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide:  BorderSide(
                    color: themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightButtonBackground,
                  ),
                  borderRadius: BorderRadius.circular(26.0),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide:  BorderSide(
                    color: themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightButtonBackground,
                  ),
                  borderRadius: BorderRadius.circular(26.0),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide:  BorderSide(
                    color: themeController.isDarkMode?MateColors.drawerTileColor:MateColors.lightButtonBackground,
                  ),
                  borderRadius: BorderRadius.circular(26.0),
                ),
              ),
            ),


            // TextField(
            //   controller: textEditingController,
            //   cursorColor: Colors.cyanAccent,
            //   style: TextStyle(
            //     color: Colors.white,
            //     fontSize: 12.5.sp,
            //   ),
            //   textInputAction: TextInputAction.done,
            //   minLines: 1,
            //   maxLines: 4,
            //   decoration: InputDecoration(
            //       hintText: "Type message ...",
            //       hintStyle: TextStyle(
            //         color: Colors.white38,
            //         fontSize: 13.0.sp,
            //       ),
            //       border: InputBorder.none),
            // ),
          ),
        ),

        // Button send message
        // GestureDetector(
        //   onTap: () => onSendMessage(textEditingController.text, 0),
        //   child: Container(
        //     height: 45.0,
        //     width: 45.0,
        //     decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(50.0)), color: Colors.transparent, border: Border.all(color: Colors.grey, width: 0.3)),
        //     child: Center(child: Icon(Icons.send, color: MateColors.activeIcons)),
        //   ),
        // )
      ],
    );
  }
}
