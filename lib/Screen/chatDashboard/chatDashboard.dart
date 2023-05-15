import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mate_app/Screen/Home/CommunityTab/communityTab.dart';
import 'package:mate_app/Screen/chatDashboard/chatMergedSearch.dart';
import 'package:mate_app/Screen/chatDashboard/new_message.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../Model/callHistoryModel.dart';
import '../../Providers/AuthUserProvider.dart';
import '../../Providers/chatProvider.dart';
import '../../Services/community_tab_services.dart';
import '../../Widget/Loaders/Shimmer.dart';
import '../../Widget/focused_menu/focused_menu.dart';
import '../../Widget/focused_menu/modals.dart';
import '../../asset/Colors/MateColors.dart';
import '../../controller/addUserController.dart';
import '../../controller/theme_controller.dart';
import '../../groupChat/services/database_service.dart';
import '../../groupChat/widgets/group_tile.dart';
import '../Home/CommunityTab/addPersonWhileCreatingGroup.dart';
import '../chat1/screens/chat.dart';
import 'archived_view.dart';

class ChatDashboard extends StatefulWidget {
  static final String routeName = '/chatDashboard';
  @override
  _ChatDashboardState createState() => _ChatDashboardState();
}

class _ChatDashboardState extends State<ChatDashboard> with TickerProviderStateMixin {
  ThemeController themeController = Get.find<ThemeController>();
  final AddUserController _addUserController = Get.put(AddUserController());
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  User _user = FirebaseAuth.instance.currentUser;
  String personChatId;
  PageController _pageController;
  List<CallHistoryModel> callHistoryList = [];
  bool isLoading = true;
  int _selectedIndex = 0;
  int universityId = 0;
  String university;
  String displayName;

  @override
  void initState() {
    _pageController = PageController(initialPage: _selectedIndex);
    getStoredValue();
    getCallHistory();
    Future.delayed(Duration.zero, () {
      Provider.of<ChatProvider>(context, listen: false).mergedChatDataFetch(_user.uid,true);
    });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String token;
  getStoredValue()async{
    universityId = Provider.of<AuthUserProvider>(context, listen: false).authUser.universityId??0;
    university = Provider.of<AuthUserProvider>(context, listen: false).authUser.university??"";
    displayName = Provider.of<AuthUserProvider>(context, listen: false).authUser.displayName;
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

  loadData()async{
    Future.delayed(Duration.zero, () {
      Provider.of<ChatProvider>(context, listen: false).mergedChatDataFetch(_user.uid,false);
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
      key: _key,
      body: SlidableAutoCloseBehavior(
        closeWhenOpened: true,
        child: Container(
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
              SizedBox(
                height: scH*0.07,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width/4,
                  ),
                  Text(
                    "Messages",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: themeController.isDarkMode ? MateColors.whiteText : MateColors.blackText,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed(NewMessage.routeName);
                        },
                        child: Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: themeController.isDarkMode? MateColors.appThemeDark: MateColors.appThemeLight,
                          ),
                          child: Icon(Icons.add,
                            color: Colors.black,
                            size: 28,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: ()async{
                          if(_selectedIndex==0)
                            await Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ChatMergedSearch(onlyGroupSearch: true,)));
                          else
                            await Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ChatMergedSearch(onlyGroupSearch: false,)));
                          loadData();
                        },
                        child: Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: themeController.isDarkMode? MateColors.smallContainerDark: MateColors.smallContainerLight,
                          ),
                          padding: EdgeInsets.all(13),
                          child: Image.asset(
                            "lib/asset/iconsNewDesign/search.png",
                            height: 23.7,
                            width: 23.7,
                            color: themeController.isDarkMode? Colors.white: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16,right: 16,top: 16,bottom: 5),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: themeController.isDarkMode?Colors.white.withOpacity(0.12):Colors.white.withOpacity(0.2),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 7),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _pageController.animateToPage(0, duration: Duration(milliseconds: 500), curve: Curves.ease);
                        },
                        child: Container(
                          height: 36,
                          width: MediaQuery.of(context).size.width*0.43,
                          decoration: BoxDecoration(
                            color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                            borderRadius: BorderRadius.circular(9),
                          ),
                          alignment: Alignment.center,
                          child: Text('Communities',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                              overflow: TextOverflow.ellipsis,
                              color: _selectedIndex==0?
                              themeController.isDarkMode?Colors.white:Colors.black :
                              themeController.isDarkMode?Colors.white.withOpacity(0.5):Colors.black.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _pageController.animateToPage(1, duration: Duration(milliseconds: 500), curve: Curves.ease);
                        },
                        child: Container(
                          height: 36,
                          width: MediaQuery.of(context).size.width*0.43,
                          decoration: BoxDecoration(
                            color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                            borderRadius: BorderRadius.circular(9),
                          ),
                          alignment: Alignment.center,
                          child: Text('Chats',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                              overflow: TextOverflow.ellipsis,
                              color: _selectedIndex==1?
                              themeController.isDarkMode?Colors.white:Colors.black :
                              themeController.isDarkMode?Colors.white.withOpacity(0.5):Colors.black.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (val){
                    setState(() {
                      _selectedIndex = val;
                    });
                  },
                  children: [
                    RefreshIndicator(
                      onRefresh: () {
                        return Provider.of<ChatProvider>(context, listen: false).mergedChatDataFetch(_user.uid,false);
                      },
                      child: Consumer<ChatProvider>(
                        builder: (ctx, chatProvider, _){
                          if (chatProvider.mergedChatDataFetchLoader) {
                            return Shimmer.fromColors(
                              baseColor: themeController.isDarkMode?Colors.white12:Colors.black12,
                              highlightColor: themeController.isDarkMode?Colors.white54:Colors.black54,
                              enabled: true,
                              child: GroupLoader(),
                            );
                          }else if(chatProvider.mergedChatApiError){
                            return Center(
                              child: Container(
                                color: Colors.red,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Something went wrong!',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 15,
                                      color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }else if(chatProvider.mergedChatModelData!=null){
                            return chatProvider.mergedChatModelData.data.length == 0 ?
                            Center(
                              child: Text("You don't have any message",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 15,
                                  color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ):
                            ListView(
                              padding: EdgeInsets.only(top: 20),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              children: [
                                if(chatProvider.mergedChatModelData.archived.length>0)
                                  InkWell(
                                    onTap: ()async{
                                      await Get.to(()=>ArchivedView());
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(left: 25,top: 0,bottom: 16),
                                      child: Row(
                                        children: [
                                          Icon(Icons.archive,
                                            color: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                                          ),
                                          SizedBox(width: 35,),
                                          Text("Archived",
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 15,
                                              color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 26,top: 5,bottom: 16,right: 16),
                                  child: GestureDetector(
                                    onTap: ()async{
                                      _addUserController.addConnectionUid.clear();
                                      _addUserController.addConnectionDisplayName.clear();
                                      _addUserController.selected.clear();
                                      await Get.to(()=>AddPersonWhileCreatingGroup());
                                      loadData();
                                      // print(_addUserController.addConnectionUid);
                                      // if(_addUserController.addConnectionUid.isNotEmpty){
                                      //   _popupDialog(context);
                                      // }
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset("lib/asset/homePageIcons/groupPersonColor.png",width: 18.0,
                                              color: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                                            ),
                                            SizedBox(width: 20,),
                                            Text("New Group",
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 15,
                                                color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Icon(Icons.add_circle_outline,
                                          color: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                                          size: 22,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                ListView.separated(
                                  itemCount: chatProvider.mergedChatModelData.data.length,
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  physics: ScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (context, indexMain) {
                                    return chatProvider.mergedChatModelData.data[indexMain].type=="group"?
                                    Slidable(
                                      key: Key(indexMain.toString()),
                                      endActionPane: ActionPane(
                                        motion: StretchMotion(),
                                        children: [
                                          CustomSlidableAction(
                                            onPressed: (v)async{
                                              DocumentSnapshot data = await DatabaseService().getMateGroupDetailsData(chatProvider.mergedChatModelData.data[indexMain].roomId);
                                              if(!data.toString().contains('isPinned')){
                                                DatabaseService().setTopToPin(chatProvider.mergedChatModelData.data[indexMain].roomId, _user.uid);
                                              }else if(data['isPinned'].contains(_user.uid)){
                                                DatabaseService().removeTopToPin(chatProvider.mergedChatModelData.data[indexMain].roomId, _user.uid);
                                              }else{
                                                DatabaseService().setTopToPin(chatProvider.mergedChatModelData.data[indexMain].roomId, _user.uid);
                                              }
                                              await CommunityTabService().toggleTopToPin(groupId: chatProvider.mergedChatModelData.data[indexMain].roomId,uid: _user.uid,token: token);
                                              loadData();
                                            },
                                            padding: EdgeInsets.zero,
                                            backgroundColor: Colors.transparent,
                                            child: VisibilityDetector(
                                              key: Key(indexMain.toString()),
                                              onVisibilityChanged: (visibilityInfo) {
                                                setState(() {
                                                  if(visibilityInfo.visibleFraction==1.0){
                                                    chatProvider.mergedChatModelData.data[indexMain].isVisible = true;
                                                  }else{
                                                    chatProvider.mergedChatModelData.data[indexMain].isVisible = false;
                                                  }
                                                });
                                                print(visibilityInfo.visibleFraction);
                                                var visiblePercentage = visibilityInfo.visibleFraction * 100;
                                                debugPrint('Widget ${visibilityInfo.key} is ${visiblePercentage}% visible');
                                              },
                                              child: Container(
                                                height: 48,
                                                width: 48,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(15.0),
                                                  child: Image.asset("lib/asset/icons/pinToTop.png",),
                                                ),
                                              ),
                                            ),
                                          ),
                                          CustomSlidableAction(
                                            onPressed: (v)async{
                                              await CommunityTabService().toggleArchive(roomId: chatProvider.mergedChatModelData.data[indexMain].roomId,uid: _user.uid,token: token);
                                              loadData();
                                            },
                                            backgroundColor: Colors.transparent,
                                            padding: EdgeInsets.zero,
                                            child: Container(
                                              height: 48,
                                              width: 48,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                                              ),
                                              child: Icon(Icons.archive,
                                                size: 20,
                                                color: themeController.isDarkMode?MateColors.helpingTextLight:Colors.black,
                                              ),
                                            ),
                                          ),
                                          CustomSlidableAction(
                                            onPressed: (v)async{
                                              if(chatProvider.mergedChatModelData.data[indexMain].isMuted){
                                                DatabaseService().removeIsMuted(chatProvider.mergedChatModelData.data[indexMain].roomId, _user.uid);
                                              }else{
                                                DatabaseService().setIsMuted(chatProvider.mergedChatModelData.data[indexMain].roomId, _user.uid);
                                              }
                                              await CommunityTabService().toggleMute(groupId: chatProvider.mergedChatModelData.data[indexMain].roomId,uid: _user.uid,token: token);
                                              loadData();
                                            },
                                            padding: EdgeInsets.zero,
                                            backgroundColor: Colors.transparent,
                                            child: Container(
                                              height: 48,
                                              width: 48,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: themeController.isDarkMode?MateColors.containerDark:MateColors.containerLight,
                                              ),
                                              child: Icon(
                                                chatProvider.mergedChatModelData.data[indexMain].isMuted?
                                                Icons.volume_up:
                                                Icons.volume_off,
                                                size: 20,
                                                color: themeController.isDarkMode?MateColors.helpingTextLight:Colors.black,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      child: FocusedMenuHolder(
                                        menuWidth: MediaQuery.of(context).size.width*0.52,
                                        blurSize: 5.0,
                                        menuItemExtent: 45,
                                        menuBoxDecoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius: BorderRadius.all(Radius.circular(20)),
                                        ),
                                        duration: Duration(milliseconds: 100),
                                        animateMenuItems: true,
                                        openWithTap: false, // Open Focused-Menu on Tap rather than Long Press
                                        menuOffset: 16.0, // Offset value to show menuItem from the selected item
                                        bottomOffsetHeight: 80.0,
                                        menuItems: <FocusedMenuItem>[
                                          FocusedMenuItem(
                                            title: Row(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(left: 0),
                                                  child: Text(
                                                    "Archive",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontFamily: "Poppins",
                                                      fontWeight: FontWeight.w600,
                                                      color: themeController.isDarkMode?Colors.white: MateColors.blackTextColor,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.23),
                                                  child: Icon(Icons.archive,
                                                    size: 20,
                                                    color: themeController.isDarkMode?MateColors.helpingTextLight:Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            backgroundColor: Colors.white.withOpacity(0.15),
                                            onPressed: ()async{
                                              await CommunityTabService().toggleArchive(roomId: chatProvider.mergedChatModelData.data[indexMain].roomId,uid: _user.uid,token: token);
                                              loadData();
                                            },
                                          ),
                                          FocusedMenuItem(
                                            title: Row(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(left: 0),
                                                  child: Text(
                                                    chatProvider.mergedChatModelData.data[indexMain].isMuted?
                                                    "Unmute":
                                                    "Mute",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontFamily: "Poppins",
                                                      fontWeight: FontWeight.w600,
                                                      color: themeController.isDarkMode?Colors.white: MateColors.blackTextColor,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(left:
                                                  chatProvider.mergedChatModelData.data[indexMain].isMuted?
                                                  MediaQuery.of(context).size.width*0.23:
                                                  MediaQuery.of(context).size.width*0.28),
                                                  child: Icon(
                                                    chatProvider.mergedChatModelData.data[indexMain].isMuted?
                                                    Icons.volume_up:
                                                    Icons.volume_off,
                                                    size: 20,
                                                    color: themeController.isDarkMode?MateColors.helpingTextLight:Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            backgroundColor: Colors.white.withOpacity(0.15),
                                            onPressed: ()async{
                                              if(chatProvider.mergedChatModelData.data[indexMain].isMuted){
                                                DatabaseService().removeIsMuted(chatProvider.mergedChatModelData.data[indexMain].roomId, _user.uid);
                                              }else{
                                                DatabaseService().setIsMuted(chatProvider.mergedChatModelData.data[indexMain].roomId, _user.uid);
                                              }
                                              await CommunityTabService().toggleMute(groupId: chatProvider.mergedChatModelData.data[indexMain].roomId,uid: _user.uid,token: token);
                                              loadData();
                                            },
                                          ),
                                          FocusedMenuItem(
                                            title: Row(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(left: 0),
                                                  child: Text(
                                                    "Exit Group",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontFamily: "Poppins",
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.18),
                                                  child: Icon(Icons.cancel_outlined,
                                                    size: 20,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            backgroundColor: Colors.white.withOpacity(0.15),
                                            onPressed: ()async{
                                              DocumentSnapshot data = await DatabaseService().getMateGroupDetailsData(chatProvider.mergedChatModelData.data[indexMain].roomId);
                                              DatabaseService(uid: _user.uid).togglingGroupJoin(chatProvider.mergedChatModelData.data[indexMain].roomId,data["groupName"],_user.displayName);
                                              await CommunityTabService().exitGroup(token: token,uid: _user.uid,groupId: chatProvider.mergedChatModelData.data[indexMain].roomId);
                                              loadData();
                                            },
                                          ),
                                        ],
                                        onPressed: (){},
                                        child: GroupTile(
                                          userName: _user.displayName,
                                          groupId: chatProvider.mergedChatModelData.data[indexMain].roomId,
                                          unreadMessages: chatProvider.mergedChatModelData.data[indexMain].unreadMessages,
                                          currentUserUid: _user.uid,
                                          loadData: loadData,
                                          isMuted: chatProvider.mergedChatModelData.data[indexMain].isMuted,
                                          isPinned: chatProvider.mergedChatModelData.data[indexMain].isPinned==0?false:true,
                                          index: indexMain,
                                          showColor: chatProvider.mergedChatModelData.data[indexMain].isVisible,
                                        ),
                                      ),
                                    ):
                                    SizedBox();
                                  },
                                  separatorBuilder: (BuildContext context, int index) {
                                    return chatProvider.mergedChatModelData.data[index].type=="group"?Padding(
                                      padding: const EdgeInsets.only(left: 16,right: 16,top: 5,bottom: 5),
                                      child: Divider(
                                        thickness: 1,
                                        color: themeController.isDarkMode?MateColors.dividerDark:MateColors.dividerLight,
                                      ),
                                    ):SizedBox();
                                  },
                                ),
                              ],
                            );
                          }else{
                            return Container();
                          }
                        },
                      ),
                    ),
                    RefreshIndicator(
                      onRefresh: () {
                        return Provider.of<ChatProvider>(context, listen: false).mergedChatDataFetch(_user.uid,false);
                      },
                      child: Consumer<ChatProvider>(
                        builder: (ctx, chatProvider, _){
                          if (chatProvider.mergedChatDataFetchLoader) {
                            return Shimmer.fromColors(
                              baseColor: themeController.isDarkMode?Colors.white12:Colors.black12,
                              highlightColor: themeController.isDarkMode?Colors.white54:Colors.black54,
                              enabled: true,
                              child: GroupLoader(),
                            );
                          }else if(chatProvider.mergedChatApiError){
                            return Center(
                              child: Container(
                                color: Colors.red,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Something went wrong!',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 15,
                                      color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }else if(chatProvider.mergedChatModelData!=null){
                            return chatProvider.mergedChatModelData.data.length == 0 ?
                            Center(
                              child: Text("You don't have any message",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 15,
                                  color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ):ListView(
                              padding: EdgeInsets.only(top: 20),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              children: [
                                if(chatProvider.mergedChatModelData.archived.length>0)
                                  InkWell(
                                    onTap: ()async{
                                      await Get.to(()=>ArchivedView());
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(left: 25,top: 0,bottom: 16),
                                      child: Row(
                                        children: [
                                          Icon(Icons.archive,
                                            color: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                                          ),
                                          SizedBox(width: 35,),
                                          Text("Archived",
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 15,
                                              color: themeController.isDarkMode?Colors.white:MateColors.blackTextColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ListView.builder(
                                  itemCount: chatProvider.mergedChatModelData.data.length,
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  physics: ScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (context, indexMain) {
                                    return chatProvider.mergedChatModelData.data[indexMain].type=="group"?
                                    SizedBox():
                                    StreamBuilder(
                                        stream: DatabaseService().getPeerChatUserDetail(chatProvider.mergedChatModelData.data[indexMain].receiverUid),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return ListView.separated(
                                                shrinkWrap: true,
                                                padding: EdgeInsets.zero,
                                                itemCount: snapshot.data.docs.length,
                                                physics: ScrollPhysics(),
                                                itemBuilder: (context, index) {
                                                  if (_user.uid.hashCode <= snapshot.data.docs[index].data()["uid"].hashCode) {
                                                    personChatId = '${_user.uid}-${snapshot.data.docs[index].data()["uid"]}';
                                                  } else {
                                                    personChatId = '${snapshot.data.docs[index].data()["uid"]}-${_user.uid}';
                                                  }
                                                  chatProvider.messageList[indexMain].name = snapshot.data.docs[index].data()["displayName"];
                                                  return FocusedMenuHolder(
                                                    menuWidth: MediaQuery.of(context).size.width*0.52,
                                                    blurSize: 5.0,
                                                    menuItemExtent: 45,
                                                    menuBoxDecoration: BoxDecoration(
                                                      color: Colors.transparent,
                                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                                    ),
                                                    duration: Duration(milliseconds: 100),
                                                    animateMenuItems: true,
                                                    openWithTap: false, // Open Focused-Menu on Tap rather than Long Press
                                                    menuOffset: 16.0, // Offset value to show menuItem from the selected item
                                                    bottomOffsetHeight: 80.0,
                                                    menuItems: <FocusedMenuItem>[
                                                      FocusedMenuItem(
                                                        title: Row(
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets.only(left: 0),
                                                              child: Text(
                                                                "Archive",
                                                                style: TextStyle(
                                                                  fontSize: 15,
                                                                  fontFamily: "Poppins",
                                                                  fontWeight: FontWeight.w600,
                                                                  color: themeController.isDarkMode?Colors.white: MateColors.blackTextColor,
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.23),
                                                              child: Icon(Icons.archive,
                                                                size: 20,
                                                                color: themeController.isDarkMode?MateColors.helpingTextLight:Colors.white,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        backgroundColor: Colors.white.withOpacity(0.15),
                                                        onPressed: ()async{
                                                          await CommunityTabService().toggleArchive(roomId: chatProvider.mergedChatModelData.data[indexMain].roomId,uid: _user.uid,token: token);
                                                          loadData();
                                                        },
                                                      ),
                                                      FocusedMenuItem(
                                                        title: Row(
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets.only(left: 0),
                                                              child: Text(
                                                                chatProvider.mergedChatModelData.data[indexMain].isMuted?
                                                                "Unmute":
                                                                "Mute",
                                                                style: TextStyle(
                                                                  fontSize: 15,
                                                                  fontFamily: "Poppins",
                                                                  fontWeight: FontWeight.w600,
                                                                  color: themeController.isDarkMode?Colors.white: MateColors.blackTextColor,
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets.only(left:
                                                              chatProvider.mergedChatModelData.data[indexMain].isMuted?
                                                              MediaQuery.of(context).size.width*0.23:
                                                              MediaQuery.of(context).size.width*0.28),
                                                              child: Icon(
                                                                chatProvider.mergedChatModelData.data[indexMain].isMuted?
                                                                Icons.volume_up:
                                                                Icons.volume_off,
                                                                size: 20,
                                                                color: themeController.isDarkMode?MateColors.helpingTextLight:Colors.white,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        backgroundColor: Colors.white.withOpacity(0.15),
                                                        onPressed: ()async{
                                                          await CommunityTabService().toggleMutePersonalChat(roomId: chatProvider.mergedChatModelData.data[indexMain].roomId,uid: _user.uid,token: token);
                                                          loadData();
                                                        },
                                                      ),
                                                    ],
                                                    onPressed: (){},
                                                    child: Padding(
                                                      padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                                                      child: ListTile(
                                                        onTap: ()async {
                                                          await Navigator.push(context, MaterialPageRoute(
                                                              builder: (context) => Chat(
                                                                peerUuid: snapshot.data.docs[index].data()["uuid"],
                                                                currentUserId: _user.uid,
                                                                peerId: snapshot.data.docs[index].data()["uid"],
                                                                peerName: snapshot.data.docs[index].data()["displayName"],
                                                                peerAvatar: snapshot.data.docs[index].data()["photoURL"],
                                                                roomId: chatProvider.messageList[indexMain].roomId,
                                                              )));
                                                          loadData();
                                                        },
                                                        leading: CircleAvatar(
                                                          radius: 30,
                                                          backgroundColor: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                                                          backgroundImage: NetworkImage(snapshot.data.docs[index].data()["photoURL"]),
                                                        ),
                                                        title: Row(
                                                          children: [
                                                            Text(
                                                              snapshot.data.docs[index].data()["displayName"],
                                                              style: TextStyle(
                                                                fontSize: 15,
                                                                fontFamily: "Poppins",
                                                                fontWeight: FontWeight.w600,
                                                                color: themeController.isDarkMode?Colors.white: MateColors.blackTextColor,
                                                              ),
                                                            ),
                                                            chatProvider.mergedChatModelData.data[indexMain].isMuted?
                                                            Padding(
                                                              padding: EdgeInsets.only(left: 10),
                                                              child: Image.asset("lib/asset/icons/mute.png",
                                                                color: themeController.isDarkMode?MateColors.helpingTextLight:MateColors.iconPopupLight,
                                                                height: 14,
                                                                width: 19,
                                                              ),
                                                            ):Offstage(),
                                                          ],
                                                        ),
                                                        subtitle: StreamBuilder(
                                                            stream: FirebaseFirestore.instance.collection('messages').doc(personChatId).collection(personChatId).orderBy('timestamp', descending: true).limit(1).snapshots(),
                                                            builder: (context, snapshot) {
                                                              if (snapshot.hasData) {
                                                                print(snapshot.data.docs);
                                                                if (snapshot.data.docs.length > 0) {
                                                                  return Text(
                                                                    snapshot.data.docs[0].data()['type'] == 4?
                                                                    "Audio" :
                                                                    snapshot.data.docs[0].data()['type'] == 0 ?
                                                                    snapshot.data.docs[0].data()['content'].toString().contains('This is missed call@#%')?
                                                                    "${snapshot.data.docs[0].data()['content'].toString().split('___').last}":
                                                                    "${snapshot.data.docs[0].data()['content']}" :
                                                                    snapshot.data.docs[0].data()['type'] == 1 ?
                                                                    "🖼️ Image" :
                                                                    snapshot.data.docs[0].data()['fileName'],
                                                                    style: TextStyle(
                                                                      fontFamily: "Poppins",
                                                                      fontSize: 14.0,
                                                                      fontWeight: FontWeight.w400,
                                                                      color: themeController.isDarkMode?
                                                                      chatProvider.mergedChatModelData.data[indexMain].unreadMessages >0?
                                                                      Colors.white: Colors.white.withOpacity(0.5):
                                                                      chatProvider.mergedChatModelData.data[indexMain].unreadMessages >0?
                                                                      Colors.black: Colors.black.withOpacity(0.5),
                                                                    ),
                                                                    overflow: TextOverflow.ellipsis,
                                                                  );
                                                                } else
                                                                  return Text(
                                                                    "Tap to send message",
                                                                    style: TextStyle(
                                                                        fontFamily: "Poppins",
                                                                        fontSize: 14.0,
                                                                        fontWeight: FontWeight.w400,
                                                                        color: themeController.isDarkMode?Colors.white.withOpacity(0.5):Colors.black.withOpacity(0.5),
                                                                    ),
                                                                    overflow: TextOverflow.ellipsis,
                                                                  );
                                                              } else
                                                                return Text(
                                                                  "Tap to send message",
                                                                  style: TextStyle(
                                                                    fontFamily: "Poppins",
                                                                    fontSize: 14.0,
                                                                    fontWeight: FontWeight.w400,
                                                                    color: themeController.isDarkMode?Colors.white.withOpacity(0.5):Colors.black.withOpacity(0.5),
                                                                  ),
                                                                  overflow: TextOverflow.ellipsis,
                                                                );
                                                            }),
                                                        trailing: chatProvider.mergedChatModelData.data[indexMain].unreadMessages >0 && chatProvider.mergedChatModelData.data[indexMain].isMuted==false?
                                                        Container(
                                                          height: 20,
                                                          width: 20,
                                                          margin: EdgeInsets.only(right: 10),
                                                          decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            color: themeController.isDarkMode?MateColors.appThemeDark:MateColors.appThemeLight,
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              chatProvider.mergedChatModelData.data[indexMain].unreadMessages.toString(),
                                                              style: TextStyle(fontFamily: "Poppins",
                                                                fontSize: 12.0,
                                                                fontWeight: FontWeight.w400,
                                                                color: Colors.black,
                                                              ),
                                                            ),
                                                          ),
                                                        ):Offstage(),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              separatorBuilder: (BuildContext context, int index) {
                                                return chatProvider.mergedChatModelData.data[indexMain].type=="group"?
                                                SizedBox() :
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 16,right: 16,top: 5,bottom: 5),
                                                  child: Divider(
                                                    thickness: 1,
                                                    color: themeController.isDarkMode?MateColors.dividerDark:MateColors.dividerLight,
                                                  ),
                                                );
                                              },
                                            );
                                          } else {
                                            return Container();
                                          }
                                        });
                                  },
                                ),
                              ],
                            );
                          }else{
                            return Container();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _popupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MyDialog(
          user: _user,
          displayName: displayName,
          universityId: universityId,
          university: university,
        );
      },
    ).whenComplete((){
      Future.delayed(Duration(seconds: 5),(){
        getStoredValue();
      });
    });
  }
}
