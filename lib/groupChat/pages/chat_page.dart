import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mate_app/Widget/Loaders/Shimmer.dart';
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
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../Providers/AuthUserProvider.dart';
import '../../Providers/chatProvider.dart';
import '../../Screen/Profile/ProfileScreen.dart';
import '../../Screen/Profile/UserProfileScreen.dart';
import 'package:giphy_picker/giphy_picker.dart';

import '../../audioAndVideoCalling/connectingScreen.dart';


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

  Widget _chatMessages() {
    return StreamBuilder(
      stream: _chats,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          messageLength = snapshot.data.docs.length;
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
                );
              });
        } else {
          return Container();
        }
      },
    );
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

  _sendMessage(String message, {bool isImage = false, bool isFile = false, bool isGif = false}) {
    if (message.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": message.trim(),
        "sender": widget.userName,
        'senderId': _user.uid,
        'time': DateTime.now().millisecondsSinceEpoch,
        'isImage': isImage,
        'isFile': isFile,
        'isGif' : isGif
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

  Widget _messageSendWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: themeController.isDarkMode?MateColors.darkDivider:MateColors.lightDivider,
                        width: 0.3,
                      ),
                    ),
                  ),
                  child: TextField(
                    controller: messageEditingController,
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
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: IconButton(
                          icon: Icon(
                            Icons.send,
                            size: 20,
                            color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
                          ),
                          onPressed: ()async{
                            _sendMessage(messageEditingController.text.trim());
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
                ),
              ),
            ],
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   mainAxisSize: MainAxisSize.min,
          //   children: [
          //     Flexible(
          //       child: Container(
          //         alignment: Alignment.bottomCenter,
          //         // width: MediaQuery.of(context).size.width * 0.5,
          //         margin: EdgeInsets.fromLTRB(5, 0, 10, 5),
          //         padding: EdgeInsets.only(left: 15),
          //         // decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12.0)), color: Colors.transparent, border: Border.all(color: Colors.grey, width: 0.3)),
          //         child: TextField(
          //           controller: messageEditingController,
          //           cursorColor: Colors.cyanAccent,
          //           style: TextStyle(color: Colors.white, fontSize: 12.5.sp),
          //           textInputAction: TextInputAction.done,
          //           minLines: 1,
          //           maxLines: 4,
          //           decoration: InputDecoration(
          //               hintText: "Send a message",
          //               hintStyle: TextStyle(
          //                 color: Colors.white38,
          //                 fontSize: 12.5.sp,
          //               ),
          //               border: InputBorder.none),
          //         ),
          //       ),
          //     ),
          //     GestureDetector(
          //       onTap: () {
          //         _sendMessage(messageEditingController.text.trim());
          //       },
          //       child: Padding(
          //         padding: const EdgeInsets.only(right: 15.0, bottom: 5),
          //         child: Container(
          //           height: 45.0,
          //           width: 45.0,
          //           child: Center(
          //               child: Image.asset(
          //             "lib/asset/chatPageAssets/send-active@3x.png",
          //             width: 15.5.sp,
          //           )),
          //         ),
          //       ),
          //     )
          //   ],
          // ),





          // SpeedDial(
          //   icon: Icons.attach_file_outlined,
          //   activeIcon: Icons.close,
          //   spaceBetweenChildren: 6,
          //   backgroundColor: myHexColor,
          //   foregroundColor: Colors.grey,
          //   activeForegroundColor: Colors.grey,
          //   overlayColor: Colors.transparent,
          //   overlayOpacity: 0.5,
          //   switchLabelPosition: true,
          //   tooltip: "Send File",
          //   children: [
          //     SpeedDialChild(
          //       child: Icon(Icons.image),
          //       label: "Image",
          //       elevation: 2.0,
          //       onTap: () => _getImage(0),
          //     ),
          //     SpeedDialChild(
          //       child: Icon(Icons.camera_alt),
          //       label: "Camera",
          //       elevation: 2.0,
          //       onTap: () => _getImage(1),
          //     ),
          //     SpeedDialChild(
          //       child: Icon(Icons.file_present),
          //       label: "Document",
          //       elevation: 2.0,
          //       onTap: () => _getFile(),
          //     ),
          //   ],
          // ),



          // Row(
          //   children: [
          //     SizedBox(
          //       width: 8.0.sp,
          //     ),
          //     IconButton(
          //       onPressed: () => _getFile(),
          //       icon: Image.asset(
          //         "lib/asset/chatPageAssets/add-folder@3x.png",
          //         width: 15.5.sp,
          //       ),
          //     ),
          //     IconButton(
          //       onPressed: () => _getImage(1),
          //       icon: Image.asset(
          //         "lib/asset/chatPageAssets/camera@3x.png",
          //         width: 15.5.sp,
          //       ),
          //     ),
          //     IconButton(
          //       onPressed: () => _getImage(0),
          //       icon: Image.asset(
          //         "lib/asset/chatPageAssets/picture@3x.png",
          //         width: 15.5.sp,
          //       ),
          //     ),
          //     IconButton(
          //       onPressed: () => _getGif(),
          //       icon: Image.asset(
          //         "lib/asset/chatPageAssets/gif@3x.png",
          //         width: 15.5.sp,
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    DatabaseService().getChats(widget.groupId).then((val) {
      // print(val);
      setState(() {
        _chats = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: myHexColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, size: 24,),
        ),
        elevation: 0,
        iconTheme: IconThemeData(
          color: MateColors.activeIcons,
        ),
        centerTitle: true,
        bottom: PreferredSize(
            child: Container(
              color: themeController.isDarkMode?MateColors.darkDivider:MateColors.lightDivider,
              height: 1.0,
            ),
            preferredSize: Size.fromHeight(1.0)),
        title: Padding(
          padding: const EdgeInsets.only(right: 0,left: 0),
          child: InkWell(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => GroupSettingsPage(
                      groupId: widget.groupId,
                    ))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                widget.photoURL != ""
                    ? Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: CircleAvatar(
                          radius: 16,
                          backgroundImage: NetworkImage(widget.photoURL),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: MateColors.activeIcons,
                          child: Text(widget.groupName.substring(0, 1).toUpperCase(),
                              textAlign: TextAlign.center,
                              style: TextStyle(color: themeController.isDarkMode?Colors.black:Colors.white, fontSize: 13.0.sp, fontWeight: FontWeight.w400)),
                        ),
                      ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.groupName,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.1,
                          color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                        ),
                      ),
                      Text(widget.totalParticipant + " members",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.1,
                          color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
                        ),
                      ),
                    ],
                  ),
                ),
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Text(widget.groupName, style: TextStyle(color: Colors.white, fontSize: 10.5.sp)),
                //     SizedBox(
                //       height: 5,
                //     ),
                //     StreamBuilder<DocumentSnapshot>(
                //         stream: DatabaseService().getGroupDetails(widget.groupId),
                //         builder: (context, snapshot) {
                //           if (snapshot.hasData) {
                //             print(snapshot.data.data()['createdAt']);
                //             return Row(
                //               children: [
                //                 Image.asset(
                //                   "lib/asset/chatPageAssets/user@2x.png",
                //                   width: 11.0.sp,
                //                 ),
                //                 Text("  ${snapshot.data.data()['members'].length}", style: TextStyle(fontSize: 9.5.sp, fontWeight: FontWeight.w500, color: Colors.white)),
                //               ],
                //             );
                //           } else
                //             return Center(child: Text("Oops! Something went wrong! \nplease trey again..", style: TextStyle(fontSize: 10.9.sp)));
                //         })
                //   ],
                // ),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: (){
              Get.to(()=>ConnectingScreen(
                callType: "Audio Calling",
                receiverImage: widget.photoURL,
                receiverName: widget.groupName,
                uid: widget.memberList,
                isGroupCalling: true,
              ));
            },
            icon: Icon(Icons.call,color: MateColors.activeIcons,),
          ),
          IconButton(
            onPressed: (){
              Get.to(()=>ConnectingScreen(
                callType: "Video Calling",
                receiverImage: widget.photoURL,
                receiverName: widget.groupName,
                uid: widget.memberList,
                isGroupCalling: true,
              ));
            },
            icon: Icon(Icons.video_call_rounded,color: MateColors.activeIcons,),
          ),
        ],
        //backgroundColor: myHexColor,
        // actions: [
        //   PopupMenuButton<int>(
        //     color: Colors.grey[850],
        //     onSelected: (value) async {
        //       if (value == 0) {
        //         Future.delayed(
        //           Duration.zero,
        //           () => showDialog(
        //             context: context,
        //             barrierDismissible: true,
        //             builder: (context) => AlertDialog(
        //               backgroundColor: Colors.grey[800],
        //               titlePadding: EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0.0),
        //               contentPadding: EdgeInsets.all(0),
        //               title: Text(
        //                 "Exit \"${widget.groupName}\" group?",
        //                 style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12.5.sp),
        //               ),
        //               actions: [
        //                 TextButton(
        //                   child: Text(
        //                     "CANCEL",
        //                     style: TextStyle(color: MateColors.activeIcons, fontWeight: FontWeight.w500, fontSize: 12.0.sp),
        //                   ),
        //                   onPressed: () => Navigator.pop(context),
        //                 ),
        //                 TextButton(
        //                   child: Text("EXIT", style: TextStyle(color: MateColors.activeIcons, fontWeight: FontWeight.w500, fontSize: 12.0.sp)),
        //                   onPressed: () async {
        //                     await DatabaseService(uid: _user.uid).exitGroup(widget.groupId, widget.groupName, widget.userName).then((value) {
        //                       Navigator.pop(context);
        //                       Navigator.pop(context);
        //                     });
        //                   },
        //                 ),
        //               ],
        //             ),
        //           ),
        //         );
        //       } else if (value == 1) {
        //         Navigator.of(context).push(MaterialPageRoute(
        //             builder: (context) => GroupSettingsPage(
        //                   groupId: widget.groupId,
        //                 )));
        //       } else if (value == 2) {
        //         String shareableLink = await DynamicLinkService.buildDynamicLink(groupId: widget.groupId, groupName: widget.groupName, groupIcon: widget.photoURL, userName: widget.userName);
        //         Share.share("Follow this link to join my MATE group $shareableLink");
        //       }
        //     },
        //     itemBuilder: (context) => [
        //       PopupMenuItem(
        //         value: 0,
        //         child: Text(
        //           "Exit Group",
        //           textAlign: TextAlign.start,
        //           style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12.5.sp),
        //         ),
        //       ),
        //       PopupMenuItem(
        //         value: 1,
        //         child: Text(
        //           "Group Settings",
        //           textAlign: TextAlign.start,
        //           style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12.5.sp),
        //         ),
        //       ),
        //       PopupMenuItem(
        //         value: 2,
        //         child: Text(
        //           "Share Group",
        //           textAlign: TextAlign.start,
        //           style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12.5.sp),
        //         ),
        //       ),
        //     ],
        //   )
        // ],
        // bottom: TabBar(
        //   indicatorColor: Colors.white,
        //   tabs: [
        //     Tab(
        //       icon: Icon(
        //         Icons.message_outlined,
        //         color: Colors.white,
        //       ),
        //       text: "Messages",
        //     ),
        //     Tab(
        //       icon: Image.asset(
        //         "lib/asset/chatPageAssets/user@2x.png",
        //         width: 15.0.sp,
        //       ),
        //       text: "Members",
        //     ),
        //     Tab(
        //       icon: Image.asset(
        //         "lib/asset/chatPageAssets/invite@3x.png",
        //         width: 15.0.sp,
        //       ),
        //       text: "Invite",
        //     ),
        //   ],
        // ),
      ),
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              Expanded(child: _chatMessages()),
              // Divider(
              //   color: Colors.grey.shade200,
              //   thickness: 0.1,
              // ),
              _messageSendWidget(),
            ],
          ),
          _buildLoading(),
        ],
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
