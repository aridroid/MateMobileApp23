import 'package:mate_app/Utility/Utility.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'chatData.dart';
import 'constForChat.dart';
import 'screens/chat.dart';
import 'screens/zoomImage.dart';
import 'package:mate_app/asset/Colors/MateColors.dart';


class ChatWidget {
  static String lastChat = "";
  

  static getFriendList() {
    List<String> data = ["h7127ZCne0OzSRwNXtktMPei0CH3", "pdj9dlfEQMTUD6s954qiPeplEog2"];
    return data;
  }
  static Widget widgetSingleChat(BuildContext context) {
    return ColoredBox(
      color: myHexColor,
      child: Stack(
        children: [
          Center(
            child: Container(
                child: Text(
              "M A T E",
              style: TextStyle(fontSize: 28,color: MateColors.activeIcons),
            )),
          ),
          Column(
            children: [
              InkWell(
                onTap: (){
                  Get.to(Chat(
                    currentUserId: "fAuYQW7x3eXvQwt3wzQ1hZFaw3o2" , //
                    peerId: "AI9zWQi7ATXibgL7Em6HqulKJCY2",
                    peerName: "Person 2",
                    peerAvatar:  "lib/asset/profile.png",
                  ));
                },
                child: Container(
                  height: 70,
                  margin: EdgeInsets.only(left: 30),
                  alignment: Alignment.centerLeft,
                  child: Text("Enter Chat Screen as Person 1",style: TextStyle(fontSize: 18,color: MateColors.activeIcons),),
                ),
              ),
              Divider(
                thickness: 1,
                  color: MateColors.activeIcons
              ),
              InkWell(
                onTap: (){
                  Get.to(Chat(
                    currentUserId:  "AI9zWQi7ATXibgL7Em6HqulKJCY2",
                    peerId: "fAuYQW7x3eXvQwt3wzQ1hZFaw3o2" ,
                    peerName: "Person 1",
                    peerAvatar:  "lib/asset/profile.png",
                  ));
                },
                child: Container(
                  height: 70,
                  margin: EdgeInsets.only(left: 30),
                  alignment: Alignment.centerLeft,
                  child: Text("Enter Chat Screen as Person 2",style: TextStyle(fontSize: 18,color: MateColors.activeIcons),),
                ),
              ),
              Divider(
                thickness: 1,
                  color: MateColors.activeIcons
              ),
            ],
          )
        ],
      ),
    );
  }


  static Widget widgetFullPhoto(BuildContext context, String url) {
    return Container(child: PhotoView(imageProvider: NetworkImage(url)));
  }

  static Widget widgetChatBuildItem(BuildContext context, var listMessage, String id, int index, DocumentSnapshot document, String peerAvatar) {
    if (document.get('idFrom') == id) {
      return Row(
        children: <Widget>[document.get('type') == 0 ? chatText(document.get('content'), id, listMessage, index, true) : chatImage(context, id, listMessage, document.get('content'), index, true)],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    } else {
      DateTime now = new DateTime.now();
      String timeNow = now.hour.toString() + ":" + now.minute.toString();
      print("Chat here time " + timeNow);
      if (index == 0) {
        // ChatWidget.lastChat = document.data().values.elementAt(3);
        ChatWidget.lastChat = document[3];

        print("Chat here " + ChatWidget.lastChat);

        print("time1 " + DateFormat('kk:mm').format(DateTime.fromMillisecondsSinceEpoch(int.parse(document.get('timestamp')))));
      }
      Future.delayed(Duration(seconds: 1), () {
        if (DateFormat('kk:mm').format(DateTime.fromMillisecondsSinceEpoch(int.parse(document.get('timestamp')))) == timeNow) {
          print("chat hbe abar");
        }
      });
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[

                document.get('type') == 0 ? chatText(document.get('content'), id, listMessage, index, false) : chatImage(context, id, listMessage, document.get('content'), index, false)
              ],
            ),

            // Time
            ChatData.isLastMessageLeft(listMessage, id, index)
                ? Container(
                    child: Text(
                      DateFormat('dd MMM kk:mm').format(DateTime.fromMillisecondsSinceEpoch(int.parse(document.get('timestamp')))),
                      style: TextStyle(color: greyColor, fontSize: 12.0, fontStyle: FontStyle.italic),
                    ),
                    margin: EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
                  )
                : Container()
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      ); //recived msg
    }
  }


  static Widget widgetChatBuildListMessage(personChatId, listMessage, currentUserId, peerAvatar, listScrollController) {
    return Flexible(
      child: personChatId == ''
          ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(themeColor)))
          : StreamBuilder(
              stream: FirebaseFirestore.instance.collection('messages').doc(personChatId).collection(personChatId).orderBy('timestamp', descending: true)/*.limit(20)*/.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(themeColor)));
                } else {
                  listMessage = snapshot.data.documents;
                  return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, index) => ChatWidget.widgetChatBuildItem(context, listMessage, currentUserId, index, snapshot.data.documents[index], peerAvatar),
                    itemCount: snapshot.data.documents.length,
                    reverse: true,
                    controller: listScrollController,
                  );
                }
              },
            ),
    );
  }

  static Widget widgetGroupChatBuildListMessage(personChatId, listMessage, currentUserId, peerAvatar, listScrollController) {
    return Flexible(
      child: personChatId == ''
          ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(themeColor)))
          : StreamBuilder(
              stream: FirebaseFirestore.instance.collection('messages').doc(personChatId).collection(personChatId).orderBy('timestamp', descending: true).limit(100).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(themeColor)));
                } else {
                  listMessage = snapshot.data.documents;
                  return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, index) => ChatWidget.widgetChatBuildItem(context, listMessage, currentUserId, index, snapshot.data.documents[index], peerAvatar),
                    itemCount: snapshot.data.documents.length,
                    reverse: true,
                    controller: listScrollController,
                  );
                }
              },
            ),
    );
  }

  static Widget chatText(String chatContent, String id, var listMessage, int index, bool logUserMsg) {
    return logUserMsg ?Container(
      child: Text(
        chatContent.split("(<{<[<?>]>}>)").first,
        style: TextStyle(color: logUserMsg ? primaryColor : Colors.white),
      ),
      padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
      width: 200.0,
      decoration: BoxDecoration(color: logUserMsg ? greyColor2 : primaryColor, borderRadius: BorderRadius.circular(8.0)),
      margin: logUserMsg ? EdgeInsets.only(bottom: ChatData.isLastMessageRight(listMessage, id, index) ? 20.0 : 10.0, right: 10.0) : EdgeInsets.only(left: 10.0),
    ):Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          chatContent.split("(<{<[<?>]>}>)").length==2?
          Padding(
            padding: const EdgeInsets.only(bottom: 2.0),
            child: Text(
              chatContent.split("(<{<[<?>]>}>)").last,
              style: TextStyle(color: chatContent.split("(<{<[<?>]>}>)").last.toLowerCase().characters.first=="a" ||chatContent.split("(<{<[<?>]>}>)").last.toLowerCase().characters.first=="z" ||chatContent.split("(<{<[<?>]>}>)").last.toLowerCase().characters.first=="m"?
              Color.fromRGBO(255, 0, 8, 1):
              chatContent.split("(<{<[<?>]>}>)").last.toLowerCase().characters.first=="b" ||chatContent.split("(<{<[<?>]>}>)").last.toLowerCase().characters.first=="y" ||chatContent.split("(<{<[<?>]>}>)").last.toLowerCase().characters.first=="n"?
              Color.fromRGBO(135, 0, 255, 1):
              chatContent.split("(<{<[<?>]>}>)").last.toLowerCase().characters.first=="c" ||chatContent.split("(<{<[<?>]>}>)").last.toLowerCase().characters.first=="x" ||chatContent.split("(<{<[<?>]>}>)").last.toLowerCase().characters.first=="o"?
              Color.fromRGBO(255, 81, 237, 1):
              chatContent.split("(<{<[<?>]>}>)").last.toLowerCase().characters.first=="d" ||chatContent.split("(<{<[<?>]>}>)").last.toLowerCase().characters.first=="w" ||chatContent.split("(<{<[<?>]>}>)").last.toLowerCase().characters.first=="l"?
              Color.fromRGBO(243, 243, 243, 1):
              chatContent.split("(<{<[<?>]>}>)").last.toLowerCase().characters.first=="e" ||chatContent.split("(<{<[<?>]>}>)").last.toLowerCase().characters.first=="v" ||chatContent.split("(<{<[<?>]>}>)").last.toLowerCase().characters.first=="k"?
              Color.fromRGBO(0, 255, 220, 1):
              chatContent.split("(<{<[<?>]>}>)").last.toLowerCase().characters.first=="f" ||chatContent.split("(<{<[<?>]>}>)").last.toLowerCase().characters.first=="q" ||chatContent.split("(<{<[<?>]>}>)").last.toLowerCase().characters.first=="t"?
              Color.fromRGBO(255, 0, 146, 1):
              chatContent.split("(<{<[<?>]>}>)").last.toLowerCase().characters.first=="g" ||chatContent.split("(<{<[<?>]>}>)").last.toLowerCase().characters.first=="p" ||chatContent.split("(<{<[<?>]>}>)").last.toLowerCase().characters.first=="u"?
              Color.fromRGBO(255, 255, 1, 1):
              chatContent.split("(<{<[<?>]>}>)").last.toLowerCase().characters.first=="h" ||chatContent.split("(<{<[<?>]>}>)").last.toLowerCase().characters.first=="j" ||chatContent.split("(<{<[<?>]>}>)").last.toLowerCase().characters.first=="s"?
              Color.fromRGBO(255, 127, 0, 1):
              chatContent.split("(<{<[<?>]>}>)").last.toLowerCase().characters.first=="i" ||chatContent.split("(<{<[<?>]>}>)").last.toLowerCase().characters.first=="r" ?
              Color.fromRGBO(17, 255, 0, 1):
               Colors.white, fontWeight: FontWeight.bold),
            ),
          ):SizedBox(height: 0,),
          Text(
            chatContent.split("(<{<[<?>]>}>)").first,
            style: TextStyle(color: logUserMsg ? primaryColor : Colors.white),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
      width: 200.0,
      decoration: BoxDecoration(color: logUserMsg ? greyColor2 : primaryColor, borderRadius: BorderRadius.circular(8.0)),
      margin: logUserMsg ? EdgeInsets.only(bottom: ChatData.isLastMessageRight(listMessage, id, index) ? 20.0 : 10.0, right: 10.0) : EdgeInsets.only(left: 10.0),
    );
  }

  static Widget chatImage(BuildContext context, String id, var listMessage, String chatContent, int index, bool logUserMsg) {
    return Container(
      child: TextButton(
        child: Material(
          child: widgetShowImages(chatContent, 50),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          clipBehavior: Clip.hardEdge,
        ),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ZoomImage(url: chatContent)));
        },
        //padding: EdgeInsets.all(0),
      ),
      margin: logUserMsg ? EdgeInsets.only(bottom: ChatData.isLastMessageRight(listMessage, id, index) ? 20.0 : 10.0, right: 10.0) : EdgeInsets.only(left: 10.0),
    );
  }

  // Show Images from network
  static Widget widgetShowImages(String imageUrl, double imageSize) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      height: imageSize,
      width: imageSize,
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }

  static Widget widgetShowText(String text, dynamic textSize, dynamic textColor) {
    return Text(
      '$text',
      style: TextStyle(color: (textColor == '') ? Colors.white70 : textColor, fontSize: textSize == '' ? 14.0 : textSize),
    );
  }
}
