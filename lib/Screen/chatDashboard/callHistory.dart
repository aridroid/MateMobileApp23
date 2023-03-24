import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Model/callHistoryModel.dart';
import '../../asset/Colors/MateColors.dart';
import '../../controller/theme_controller.dart';
import '../../groupChat/services/database_service.dart';

class CallHistory extends StatefulWidget {
  const CallHistory({Key key}) : super(key: key);

  @override
  State<CallHistory> createState() => _CallHistoryState();
}

class _CallHistoryState extends State<CallHistory> {
  ThemeController themeController = Get.find<ThemeController>();
  List<CallHistoryModel> callHistoryList = [];
  String token;
  User _user = FirebaseAuth.instance.currentUser;
  bool isLoading = true;

  @override
  void initState() {
    getStoredValue();
    getCallHistory();
    super.initState();
  }

  getStoredValue()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("token");
  }

  void getCallHistory()async{
    QuerySnapshot callHistory = await DatabaseService().getCallHistory();
    callHistoryList.clear();
    print("Fetching call history");
    for(int i=0;i<callHistory.docs.length;i++){
      String callType;
      bool isPersonalCall;
      String callerId;
      String createdAt;
      String callSymbol;
      String receiverId;

      if(callHistory.docs[i]['groupIdORPeerId']!=null){
        if(callHistory.docs[i]['groupIdORPeerId'].contains(_user.uid)){
          callType = callHistory.docs[i]['callType'];
          createdAt = callHistory.docs[i]['createdAt'].toString();
          isPersonalCall = callHistory.docs[i]['groupIdORPeerId'].contains(_user.uid);
          List<String> split = callHistory.docs[i]['groupIdORPeerId'].toString().split("-");
          List<String> splitOther = split.where((element) => element!=_user.uid).toList();
          callerId = _user.displayName ==  callHistory.docs[i]['groupNameORCallerName'] ? _user.uid : splitOther[0];
          receiverId = _user.displayName ==  callHistory.docs[i]['groupNameORCallerName'] ? splitOther[0] : _user.uid;
          callSymbol = _user.displayName ==  callHistory.docs[i]['groupNameORCallerName'] ? 'called' : callHistory.docs[i]['membersWhoJoined'].contains(_user.uid)? 'received' : 'missed';
          callHistoryList.add(CallHistoryModel(callType, isPersonalCall, createdAt, callerId, callSymbol,receiverId));
          if(callSymbol=="missed" && callHistory.docs[i].toString().contains('memberWhoseCallHistoryAddedToChat') && !callHistory.docs[i]['memberWhoseCallHistoryAddedToChat'].contains(_user.uid)){
            _sendMessagePersonalChat(callHistory.docs[i]);
          }
        }else if(callHistory.docs[i]['groupMember'].contains(_user.uid)){
          callType = callHistory.docs[i]['callType'];
          createdAt = callHistory.docs[i]['createdAt'].toString();
          isPersonalCall = callHistory.docs[i]['groupIdORPeerId'].contains(_user.uid);
          callerId = callHistory.docs[i]['groupIdORPeerId'];
          receiverId = callHistory.docs[i]['groupIdORPeerId'];
          callSymbol = _user.uid == callHistory.docs[i]['callerUid']?'called': callHistory.docs[i]['membersWhoJoined'].contains(_user.uid)?"received":"missed";
          callHistoryList.add(CallHistoryModel(callType, isPersonalCall, createdAt, callerId, callSymbol,receiverId));
          if(callSymbol=="missed" && callHistory.docs[i].toString().contains('memberWhoseCallHistoryAddedToChat') && !callHistory.docs[i]['memberWhoseCallHistoryAddedToChat'].contains(_user.uid)){
            _sendMessageGroupChat(callHistory.docs[i]);
          }
        }
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  _sendMessageGroupChat(QueryDocumentSnapshot data,{bool isImage = false, bool isFile = false, bool isGif = false,bool isAudio=false}){
    String callType = data['callType']=="Video Calling"?"video call":"voice call";
    DateTime dateFormat = new DateTime.fromMillisecondsSinceEpoch(int.parse(data["createdAt"].toString()));
    String formattedTime = DateFormat.jm().format(dateFormat);
    String message = "This is missed call@#%___Missed $callType at $formattedTime";
    print("-----Inserting missed call to group chat : $message----------");

    Map<String, dynamic> chatMessageMap = {
      "message": message.trim(),
      "sender": _user.displayName,
      'senderId': _user.uid,
      'time': DateTime.now().millisecondsSinceEpoch,
      'isImage': isImage,
      'isFile': isFile,
      'isGif' : isGif,
      'isAudio':isAudio,
    };

    DatabaseService().sendMessage(data['groupIdORPeerId'], chatMessageMap,_user.photoURL);
    DatabaseService().updateCallHistory(channelName: data['channelName'],uid: _user.uid);
  }

  _sendMessagePersonalChat(QueryDocumentSnapshot data) {
    String callType = data['callType']=="Video Calling"?"video call":"voice call";
    DateTime dateFormat = new DateTime.fromMillisecondsSinceEpoch(int.parse(data["createdAt"].toString()));
    String formattedTime = DateFormat.jm().format(dateFormat);
    String message = "This is missed call@#%___Missed $callType at $formattedTime";
    print("-----Inserting missed call to personal chat : $message----------");

    String idTo = data['groupIdORPeerId'].toString().split('-').first == _user.uid? data['groupIdORPeerId'].toString().split('-').last : data['groupIdORPeerId'].toString().split('-').first;

    var documentReference = FirebaseFirestore.instance.collection('messages').doc(data['groupIdORPeerId']).collection(data['groupIdORPeerId']).doc(DateTime.now().millisecondsSinceEpoch.toString());

    Map<String, dynamic> chatMessageMap = {'idFrom': _user.uid, 'idTo': idTo, 'timestamp': DateTime.now().millisecondsSinceEpoch.toString(), 'content': message.trim(), 'type': 0,'messageId':documentReference.id};

    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(
        documentReference,
        chatMessageMap,
      );
    });
    DatabaseService().updateCallHistory(channelName: data['channelName'],uid: _user.uid);
  }

  @override
  Widget build(BuildContext context) {
    final scH = MediaQuery.of(context).size.height;
    final scW = MediaQuery.of(context).size.width;
    return Scaffold(
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
                  Text(
                    "Call Logs",
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
              child: isLoading?
              Container(
                child: Center(
                  child: CircularProgressIndicator(
                    color: MateColors.activeIcons,
                  ),
                ),
              ):
              callHistoryList.isEmpty?
              Center(
                child: Text("No call logs found",
                  style: TextStyle(
                    color: themeController.isDarkMode?MateColors.subTitleTextDark:MateColors.subTitleTextLight,
                    fontWeight: FontWeight.w400,
                    fontSize: 15.0,
                  ),
                ),
              ):
              ListView.separated(
                padding: EdgeInsets.only(top: 10),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: ScrollPhysics(),
                itemCount: callHistoryList.length,
                itemBuilder: (context,index){
                  String callTime;

                  var dateTimeNowToday = DateTime.now();
                  List<String> splitToday = dateTimeNowToday.toString().split(" ");
                  DateTime dateParsedToday = DateTime.parse(splitToday[0]);
                  String dateFormattedToday = DateFormat('dd MMMM yyyy').format(dateParsedToday);

                  var dateTimeNowYesterday = DateTime.now().subtract(const Duration(days:1));
                  List<String> splitYesterday = dateTimeNowYesterday.toString().split(" ");
                  DateTime dateParsedYesterday = DateTime.parse(splitYesterday[0]);
                  String dateFormattedYesterday = DateFormat('dd MMMM yyyy').format(dateParsedYesterday);

                  DateTime dateFormat = new DateTime.fromMillisecondsSinceEpoch(int.parse(callHistoryList[index].createdAt));
                  String dateFormatted = DateFormat('dd MMMM yyyy').format(dateFormat);
                  String formattedTime = DateFormat.jm().format(dateFormat);
                  if(dateFormatted == dateFormattedToday){
                    callTime = "Today, " + formattedTime;
                  }else if(dateFormatted == dateFormattedYesterday){
                    callTime = "Yesterday, " + formattedTime;
                  }else{
                    callTime = "$dateFormatted, " + formattedTime;
                  }

                  return callHistoryList[index].isPersonalCall?
                  FutureBuilder(
                      future: DatabaseService().getUsersDetails(callHistoryList[index].callSymbol == 'called'? callHistoryList[index].receiverId : callHistoryList[index].callerId),
                      builder: (context, snapshot1) {
                        if(snapshot1.hasData){
                          return Padding(
                            padding: EdgeInsets.only(top: index==0?16:10),
                            child: ListTile(
                              leading: snapshot1.data.data()['photoURL']!=null?
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                                backgroundImage: NetworkImage(
                                  snapshot1.data.data()['photoURL'],
                                ),
                              ):
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                                child: Text(snapshot1.data.data()['displayName']!=null?
                                snapshot1.data.data()['displayName'].substring(0,1):'',style: TextStyle(color: themeController.isDarkMode?Colors.black:Colors.white),),
                              ),
                              title: Text(
                                snapshot1.data.data()['displayName']!=null?
                                snapshot1.data.data()['displayName']:"",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                  color: themeController.isDarkMode?Colors.white: MateColors.blackTextColor,
                                ),
                              ),
                              trailing: Padding(
                                padding: const EdgeInsets.only(right: 4,left: 4),
                                child: Image.asset(
                                  callHistoryList[index].callType == "Video Calling" ?
                                  "lib/asset/iconsNewDesign/videoCall.png" :
                                  "lib/asset/iconsNewDesign/audioCall.png",
                                  color: themeController.isDarkMode?Color(0xFF67AE8C):Color(0xFF17F3DE),
                                  width: 20,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    callHistoryList[index].callSymbol=="called"?
                                    Icon(Icons.call_made,color: Colors.green,):
                                    callHistoryList[index].callSymbol=="received"?
                                    Icon(Icons.call_received,color: Colors.green,):
                                    Icon(Icons.call_received,color: Colors.red,),
                                    SizedBox(width: 5,),
                                    Expanded(
                                      child: Text(callTime,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: themeController.isDarkMode?MateColors.containerLight:Colors.black.withOpacity(0.5),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                        else if(snapshot1.connectionState == ConnectionState.waiting){
                          return SizedBox(
                            height: 50,
                            width: 50,
                            child: Center(
                              child: LinearProgressIndicator(
                                color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                                minHeight: 3,
                              ),
                            ),
                          );
                        }
                        return SizedBox();
                      }
                  ):
                  FutureBuilder(
                      future: DatabaseService().getGroupDetailsOnce(callHistoryList[index].callerId),
                      builder: (context, snapshot1) {
                        if(snapshot1.hasData){
                          return Padding(
                            padding: EdgeInsets.only(top: index==0?16:10),
                            child: ListTile(
                              leading: snapshot1.data.data()['groupIcon']!=null?
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                                backgroundImage: NetworkImage(
                                  snapshot1.data.data()['groupIcon'],
                                ),
                              ):
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                                child: Text(snapshot1.data.data()['groupName']!=null ?
                                snapshot1.data.data()['groupName'].substring(0,1):'',style: TextStyle(color: themeController.isDarkMode?Colors.black:Colors.white),),
                              ),
                              title: Text(snapshot1.data.data()['groupName']!=null?
                              snapshot1.data.data()['groupName']:"",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w600,
                                  color: themeController.isDarkMode?Colors.white: MateColors.blackTextColor,
                                ),
                              ),
                              trailing: Padding(
                                padding: const EdgeInsets.only(right: 4,left: 4),
                                child: Image.asset(
                                  callHistoryList[index].callType == "Video Calling" ?
                                  "lib/asset/iconsNewDesign/videoCall.png" :
                                  "lib/asset/iconsNewDesign/audioCall.png",
                                  color: themeController.isDarkMode?Color(0xFF67AE8C):Color(0xFF17F3DE),
                                  width: 20,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    callHistoryList[index].callSymbol=="called"?
                                    Icon(Icons.call_made,color: Colors.green,):
                                    callHistoryList[index].callSymbol=="received"?
                                    Icon(Icons.call_received,color: Colors.green,):
                                    Icon(Icons.call_received,color: Colors.red,),
                                    SizedBox(width: 5,),
                                    Expanded(
                                      child: Text(callTime,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: themeController.isDarkMode?MateColors.containerLight:Colors.black.withOpacity(0.5),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                        else if(snapshot1.connectionState == ConnectionState.waiting){
                          return SizedBox(
                            height: 50,
                            width: 50,
                            child: Center(
                              child: LinearProgressIndicator(
                                color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                                minHeight: 3,
                              ),
                            ),
                          );
                        }
                        return SizedBox();
                      }
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 20,right: 20,top: 2,bottom: 2),
                    child: Divider(
                      thickness: 1,
                      color: themeController.isDarkMode?MateColors.dividerDark:MateColors.dividerLight,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
