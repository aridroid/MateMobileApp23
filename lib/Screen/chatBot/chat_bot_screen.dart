// Link for api - https://beta.openai.com/account/api-keys
import 'dart:developer';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mate_app/Screen/chatBot/edit_user_details.dart';
import 'package:mate_app/Screen/chatBot/three_dot.dart';
import 'package:mate_app/Utility/Utility.dart';
import 'package:mate_app/groupChat/services/database_service.dart';
import '../../asset/Colors/MateColors.dart';
import '../../constant.dart';
import '../../controller/theme_controller.dart';
import 'chat_message.dart';


class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen();

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  ThemeController themeController = Get.find<ThemeController>();
  User _user = FirebaseAuth.instance.currentUser!;
  final TextEditingController _controller = TextEditingController();
  final ScrollController listScrollController = new ScrollController();
  final List<ChatMessage> _messages = [];
  late OpenAI? chatGPT;
  bool _isImageSearch = false;
  bool _isTyping = false;
  String name = "", image = "";

  @override
  void initState() {
    chatGPT = OpenAI.instance.build(
      token: "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",
      baseOption: HttpSetup(receiveTimeout: Duration(milliseconds: 60000)),
    );
    super.initState();
  }

  @override
  void dispose() {
    // chatGPT?.dis();
    // chatGPT?.genImgClose();
    super.dispose();
  }

  void _sendMessage() async {
    if (_controller.text.isEmpty) return;
    ChatMessage message = ChatMessage(
      text: _controller.text,
      sender: "ME",
      isImage: false,
    );

    setState(() {
      _messages.insert(0, message);
      _isTyping = true;
    });

    _controller.clear();

    if (_isImageSearch) {
      final request = GenerateImage(message.text, 1, size: ImageSize.size512);
      final response = await chatGPT!.generateImage(request);
      log(response!.data!.last!.url!);
      insertNewData(response.data!.last!.url!, isImage: true);
    } else {
      final request = ChatCompleteText(
        messages: [
          Messages(role: Role.user,content: message.text),
        ],
        maxToken: 200,
        model: GptTurboChatModel(),
      );
      final response = await chatGPT!.onChatCompletion(request: request);
      //print(response!.choices.map((e) => e.message!.content));
      log(response!.choices[0].message!.content);
      insertNewData(response.choices[0].message!.content.trim(), isImage: false);
    }
  }

  void insertNewData(String response, {bool isImage = false}) {
    ChatMessage botMessage = ChatMessage(
      text: response,
      sender: name,
      isImage: isImage,
    );

    setState(() {
      _isTyping = false;
      _messages.insert(0, botMessage);
    });
  }

  // Widget _buildTextComposer() {
  //   return Row(
  //     children: [
  //       Expanded(
  //         child: TextField(
  //           controller: _controller,
  //           onSubmitted: (value) => _sendMessage(),
  //           decoration: const InputDecoration.collapsed(
  //               hintText: "Question/description"),
  //         ),
  //       ),
  //       ButtonBar(
  //         children: [
  //           IconButton(
  //             icon: const Icon(Icons.send),
  //             onPressed: () {
  //               _isImageSearch = false;
  //               _sendMessage();
  //             },
  //           ),
  //           TextButton(
  //               onPressed: () {
  //                 _isImageSearch = true;
  //                 _sendMessage();
  //               },
  //               child: const Text("Generate Image"))
  //         ],
  //       ),
  //     ],
  //   );
  // }

  Widget _messageSendWidget() {
    return Container(
      alignment: Alignment.bottomCenter,
      margin: EdgeInsets.fromLTRB(16, 25, 16, 20),
      child: TextField(
        controller: _controller,
        onSubmitted: (value) => _sendMessage(),
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
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            color: themeController.isDarkMode?MateColors.helpingTextDark:MateColors.helpingTextLight,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              Icons.send,
              size: 20,
              color: themeController.isDarkMode?MateColors.helpingTextDark:MateColors.helpingTextLight,
            ),
            onPressed: ()async {
              _isImageSearch = false;
              _sendMessage();
            },
          ),
          hintText: "Send a chat",
          fillColor: themeController.isDarkMode ? MateColors.containerDark : MateColors.containerLight,
          filled: true,
          focusedBorder: commonBorderCircular,
          enabledBorder: commonBorderCircular,
          disabledBorder: commonBorderCircular,
          errorBorder: commonBorderCircular,
          focusedErrorBorder: commonBorderCircular,
        ),
      ),
    );
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
                    top: MediaQuery.of(context).size.height*0.07,
                    left: 16,
                    right: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
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
                      StreamBuilder<DocumentSnapshot>(
                        stream: DatabaseService().getChatBotUserDetails(_user.uid),
                        builder: (context, snapshot){
                          if (snapshot.hasData) {
                            name = snapshot.data!.exists? snapshot.data!['name']: "My AI";
                            image = snapshot.data!.exists && snapshot.data!['photo']!=""? snapshot.data!['photo']: "";
                            return Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: Container(
                                      height: 44,
                                      width: 44,
                                      decoration: BoxDecoration(
                                        shape: snapshot.data!.exists && snapshot.data!['photo']!=""?
                                        BoxShape.circle : BoxShape.rectangle,
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: snapshot.data!.exists && snapshot.data!['photo']!=""?
                                          NetworkImage(snapshot.data!['photo']):
                                          AssetImage("lib/asset/iconsNewDesign/bot.png") as ImageProvider,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    snapshot.data!.exists?
                                    snapshot.data!['name']:
                                    "My AI",
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w600,
                                      color: themeController.isDarkMode?Colors.white:MateColors.blackText,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            onPressed: (){
                              Get.to(()=>EditUserDetails(
                                uid: _user.uid,
                                name:  name,
                                image: image,
                              ));
                            },
                            icon: Icon(Icons.edit,
                              color: themeController.isDarkMode?Colors.white:Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                _messages.isEmpty?
                Container(
                  margin: EdgeInsets.only(top: 20,left: 10,right: 10),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: chatTealColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Image.asset('lib/asset/iconsNewDesign/msg.png',
                        width: 25,
                        height: 25,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Ask question about anything",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ):
                SizedBox(),
                Flexible(
                    child: ListView.builder(
                      controller: listScrollController,
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                      reverse: true,
                      padding: EdgeInsets.all(8),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        return _messages[index];
                      },
                    )),
                if (_isTyping) const ThreeDots(),
                // const Divider(
                //   height: 1.0,
                // ),
                // Container(
                //   decoration: BoxDecoration(
                //     color: Colors.blue,
                //   ),
                //   child: _buildTextComposer(),
                // )
                _messageSendWidget(),
              ],
            ),
          )),
    );
  }
}