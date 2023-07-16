import 'package:mate_app/Model/Message.dart';
import 'package:mate_app/Model/StudyGroup.dart';
import 'package:mate_app/Screen/Chat/ChatController.dart';
import 'package:mate_app/Screen/Chat/ChatListener.dart';
import 'package:mate_app/Utility/Utility.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

class ChatScreen extends StatefulWidget {
  static final String chatScreenRoute = '/chat';
  StudyGroup studyGroup;

  ChatScreen(this.studyGroup);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> implements ChatListener {
  // int _currentIndex = 0;
  final TextEditingController msgController = new TextEditingController();
  ChatController _chatController = Get.put(ChatController());
  List<Message> messageList = [];
  TextEditingController _editingController = TextEditingController();

  @override
  void initState() {
    _chatController.setChatMessageListener(widget.studyGroup);
    _chatController.setChatListener(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myHexColor,
      appBar: AppBar(
        backgroundColor: myHexColor,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage("https://picsum.photos/96"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Flexible(
                  child: Text(
                    "${widget.studyGroup.name}",
                    style: TextStyle(
                      fontSize: 16.0.sp,
                    ),
                  )),
            )
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {},
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          ListView.builder(
            itemCount: messageList.length,
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 10, bottom: 10),
            itemBuilder: (context, index) {
              Message message = messageList[index];
              if (message.messageType == TEXT_MESSAGE) {
                return Container(
                  padding:
                  EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
                  child: Align(
                    alignment: (message.senderId == _chatController.getUserId()
                        ? Alignment.topRight
                        : Alignment.topLeft),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: (message.senderId == _chatController.getUserId()
                            ? Colors.grey.shade200
                            : Colors.blue[200]),
                      ),
                      padding: EdgeInsets.all(16),
                      child: Text(
                        message.textMessage!,
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                );
              } else if (message.messageType == IMAGE_MESSAGE) {
                return Container(
                  padding:
                  EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
                  child: Align(
                    alignment: (message.senderId == _chatController.getUserId()
                        ? Alignment.topRight
                        : Alignment.topLeft),
                    child: Image.network(
                      message.textMessage!,
                      width: 150,
                      height: 150,
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () async {
                      // if (await Permission.storage.request().isGranted) {
                      //   _chatController.sendImageMessage();
                      // }
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _editingController,
                      decoration: InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      String value = _editingController.text.trim();

                      if (!value.isEmpty) {
                        _chatController.sendMessage(value);
                        _editingController.clear();
                      }
                    },
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                    backgroundColor: Colors.blue,
                    elevation: 0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void onReceivedNewMessage(List<Message> newMsg) {
    setState(() {
      messageList.addAll(newMsg);
    });
  }
}
