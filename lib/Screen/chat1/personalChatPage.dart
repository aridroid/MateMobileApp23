import 'package:mate_app/Screen/chat1/screens/allUsersScreen.dart';
import 'package:mate_app/Screen/chat1/screens/chat.dart';
import 'package:mate_app/Screen/chat1/screens/groupChatLandingPage.dart';
import 'package:mate_app/Screen/chat1/screens/personSearchPage.dart';
import 'package:mate_app/groupChat/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../Providers/chatProvider.dart';
import '../../Widget/Loaders/Shimmer.dart';
import 'chatWidget.dart';
import 'package:mate_app/Utility/Utility.dart' as config;
import 'package:mate_app/asset/Colors/MateColors.dart';
import 'package:sizer/sizer.dart';

class PersonalChatScreen extends StatefulWidget {

  static final String routeName = '/personalChat';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<PersonalChatScreen> {


  User _user = FirebaseAuth.instance.currentUser!;
  late String personChatId;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero,(){
      Provider.of<ChatProvider>(context,listen: false).personalChatDataFetch(_user.uid);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      //backgroundColor: config.myHexColor,
      appBar: AppBar(
        elevation: 6,
        //backgroundColor: config.myHexColor,
        centerTitle: true,
        title: Image.asset(
          "lib/asset/logo.png",
          width: 50,
          height: 30,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 18.0, top: 10.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("My Personal Messages",
                  style: TextStyle(
                      fontSize: 14.2.sp,
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.w700,
                      color: MateColors.activeIcons)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => PersonSearchPage())),
                    style: TextStyle(color: Colors.white, fontSize: 13.0),
                    cursorColor: Colors.cyanAccent,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey[50],
                        size: 16,
                      ),
                      labelText: "Search",
                      contentPadding: EdgeInsets.symmetric(vertical: -5),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                        const BorderSide(color: Colors.grey, width: 0.3),
                        borderRadius: BorderRadius.circular(15.0),
                      ),

                      labelStyle: TextStyle(color: Colors.white, fontSize: 12.0.sp),
                      // fillColor: MateColors.activeIcons,

                      focusedBorder: OutlineInputBorder(
                        borderSide:
                        const BorderSide(color: Colors.grey, width: 0.3),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                ),
                IconButton(
                    icon: Icon(
                      Icons.person_search,
                      color: Colors.grey[50],
                      size: 25,
                    ),
                    onPressed: () => Get.to(() => AllUsersScreen())
                ),
              ],
            ),
          ),
          Expanded(
              child: _personalMessages()),
        ],
      ),
    );
  }


  Widget _personalMessages() {
    return Consumer<ChatProvider>(
      builder: (ctx, chatProvider, _) {
        print("group chat consumer is called");

        if (chatProvider.personalChatDataFetchLoader && chatProvider.personalChatModelData==null) {
          return timelineLoader();
        }
        else if (chatProvider.error != '') {
          return Center(
              child: Container(
                  color: Colors.red,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${chatProvider.error}',
                      style: TextStyle(color: Colors.white),
                    ),
                  )));

        }else if(chatProvider.personalChatModelData!=null){
          return chatProvider.personalChatModelData!.data!.length == 0
              ? Center(
            child: Text("Start a conversation, mate!", style: TextStyle(fontSize: 13.0.sp, fontWeight: FontWeight.w700, color: MateColors.activeIcons)),
          )
              : RefreshIndicator(
            onRefresh: () {
              return chatProvider.personalChatDataFetch(_user.uid);
            },
            child: ListView.builder(
                itemCount: chatProvider.personalChatModelData!.data!.length,
                shrinkWrap: true,
                itemBuilder: (context, index1) {
                  return StreamBuilder<QuerySnapshot>(
                      stream: DatabaseService().getPeerChatUserDetail(chatProvider.personalChatModelData!.data![index1].receiverUid!),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          // Future.delayed(Duration.zero,(){
                          //   Provider.of<ChatProvider>(context,listen: false).personalChatDataFetch(_user.uid);
                          // });
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data!.docs.length,
                              physics: ScrollPhysics(),
                              itemBuilder: (context, index) {
                                if (_user.uid.hashCode <= {snapshot.data!.docs[index].get('uid')}.hashCode) {
                                  personChatId = '${_user.uid}-${snapshot.data!.docs[index].get('uid')}';
                                } else {
                                  personChatId = '${snapshot.data!.docs[index].get('uid')}-${_user.uid}';
                                }
                                return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                                  child: ListTile(
                                    onTap: () =>
                                        Get.to(() =>
                                            Chat(
                                              peerUuid: snapshot.data!.docs[index].get('uuid'),
                                              currentUserId: _user.uid,
                                              peerId: snapshot.data!.docs[index].get('uid'),
                                              peerName: snapshot.data!.docs[index].get('displayName'),
                                              peerAvatar: snapshot.data!.docs[index].get('photoURL'),
                                            )),
                                    leading: CircleAvatar(
                                      radius: 20,
                                      backgroundColor: MateColors.activeIcons,
                                      backgroundImage: NetworkImage(
                                        snapshot.data!.docs[index].get('photoURL'),
                                      ),

                                    ),
                                    title: Row(
                                      children: [
                                        Expanded(child: Text(snapshot.data!.docs[index].get('displayName'), style: TextStyle(fontSize: 11.7.sp, fontWeight: FontWeight.w700, color: MateColors.activeIcons))),
                                        Text(chatProvider.personalChatModelData!.data![index1].unreadMessages!<1?"":chatProvider.personalChatModelData!.data![index1].unreadMessages.toString(), style: TextStyle(fontSize: 11.7.sp, fontWeight: FontWeight.w700, color: MateColors.activeIcons)),
                                      ],
                                    ),
                                    subtitle: StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance.collection('messages').doc(personChatId).collection(personChatId).orderBy('timestamp', descending: true).limit(1).snapshots(),
                                        // stream: DatabaseService().getLastPersonalChatMessage(personChatId),
                                        builder: (context, snapshot) {
                                          if(snapshot.hasData){
                                            print(snapshot.data!.docs);
                                            if(snapshot.data!.docs.length >0){
                                              return Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      snapshot.data!.docs[0].get('type')==0?"${snapshot.data!.docs[0].get('content')}":snapshot.data!.docs[0].get('type')==1?"🖼️ Image":snapshot.data!.docs[0].get('fileName'),
                                                      style: TextStyle(fontSize: 10.0.sp, fontWeight: FontWeight.w100, color: Colors.grey[50]),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  Text(
                                                    snapshot.data!.docs[0].get('timestamp').toString()!=""?"    ${DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(int.parse(snapshot.data!.docs[0].get('timestamp').toString())))}":"",
                                                    style: TextStyle(fontSize: 8.4.sp, fontWeight: FontWeight.w100, color: Colors.grey[50]),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),

                                                ],
                                              );
                                            }
                                            else return Text(
                                              "Tap to send message",
                                              style: TextStyle(fontSize: 10.0.sp, fontWeight: FontWeight.w100, color: Colors.grey[50]),
                                              overflow: TextOverflow.ellipsis,
                                            );
                                          }else
                                            return Text(
                                              "Tap to send message",
                                              style: TextStyle(fontSize: 10.0.sp, fontWeight: FontWeight.w100, color: Colors.grey[50]),
                                              overflow: TextOverflow.ellipsis,
                                            );

                                        }
                                    ),
                                  ),
                                );
                              });
                        } else {
                          return Center(
                            child: CircularProgressIndicator(
                              backgroundColor: MateColors.activeIcons,
                            ),
                          );
                        }
                      });
                }),
          );
        }else{
          return Container();
        }


      },
    );

    // return StreamBuilder(
    //     stream: DatabaseService(uid: _user.uid).getPeerChatUsers(),
    //     builder: (context, snapshot1) {
    //       if (snapshot1.hasData) {
    //         List<dynamic> peerChatUsers = snapshot1.data.docs[0].data()['chattingWith'];
    //         print(snapshot1.data.docs[0].data()['chattingWith']);
    //         return (peerChatUsers != null) ? (peerChatUsers.isNotEmpty) ?
    //         StreamBuilder(
    //             stream: DatabaseService().getPeerChatUsersDetails(peerChatUsers),
    //             builder: (context, snapshot) {
    //               if (snapshot.hasData) {
    //                 return ListView.builder(
    //                     shrinkWrap: true,
    //                     itemCount: snapshot.data.docs.length,
    //                     itemBuilder: (context, index) {
    //                       if (_user.uid.hashCode <= {snapshot.data.docs[index].data()["uid"]}.hashCode) {
    //                         personChatId = '${_user.uid}-${snapshot.data.docs[index].data()["uid"]}';
    //                       } else {
    //                         personChatId = '${snapshot.data.docs[index].data()["uid"]}-${_user.uid}';
    //                       }
    //                       return Padding(
    //                         padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
    //                         child: ListTile(
    //                           onTap: () =>
    //                               Get.to(() =>
    //                                   Chat(
    //                                     peerUuid: snapshot.data.docs[index].data()["uuid"],
    //                                     currentUserId: _user.uid,
    //                                     peerId: snapshot.data.docs[index].data()["uid"],
    //                                     peerName: snapshot.data.docs[index].data()["displayName"],
    //                                     peerAvatar: snapshot.data.docs[index].data()["photoURL"],
    //                                   )),
    //                           leading: CircleAvatar(
    //                             radius: 20,
    //                             backgroundColor: MateColors.activeIcons,
    //                             backgroundImage: NetworkImage(
    //                               snapshot.data.docs[index].data()["photoURL"],
    //                             ),
    //
    //                           ),
    //                           title: Text(snapshot.data.docs[index].data()["displayName"], style: TextStyle(fontSize: 11.7.sp, fontWeight: FontWeight.w700, color: MateColors.activeIcons)),
    //                           subtitle: StreamBuilder(
    //                               stream: FirebaseFirestore.instance.collection('messages').doc(personChatId).collection(personChatId).orderBy('timestamp', descending: true).limit(1).snapshots(),
    //                               // stream: DatabaseService().getLastPersonalChatMessage(personChatId),
    //                               builder: (context, snapshot) {
    //                                 if(snapshot.hasData){
    //                                   print(snapshot.data.docs);
    //                                   if(snapshot.data.docs.length >0){
    //                                     return Row(
    //                                       children: [
    //                                         Expanded(
    //                                           child: Text(
    //                                     snapshot.data.docs[0].data()['type']==0?"${snapshot.data.docs[0].data()['content']}":snapshot.data.docs[0].data()['type']==1?"🖼️ Image":snapshot.data.docs[0].data()['fileName'],
    //                                             style: TextStyle(fontSize: 10.0.sp, fontWeight: FontWeight.w100, color: Colors.grey[50]),
    //                                             overflow: TextOverflow.ellipsis,
    //                                           ),
    //                                         ),
    //                                         Text(
    //                                           snapshot.data.docs[0].data()['timestamp'].toString()!=""?"    ${DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(int.parse(snapshot.data.docs[0].data()['timestamp'].toString())))}":"",
    //                                           style: TextStyle(fontSize: 8.4.sp, fontWeight: FontWeight.w100, color: Colors.grey[50]),
    //                                           overflow: TextOverflow.ellipsis,
    //                                         ),
    //
    //                                       ],
    //                                     );
    //                                   }
    //                                  else return Text(
    //                                     "Tap to send message",
    //                                     style: TextStyle(fontSize: 10.0.sp, fontWeight: FontWeight.w100, color: Colors.grey[50]),
    //                                     overflow: TextOverflow.ellipsis,
    //                                   );
    //                                 }else
    //                                   return Text(
    //                                     "Tap to send message",
    //                                     style: TextStyle(fontSize: 10.0.sp, fontWeight: FontWeight.w100, color: Colors.grey[50]),
    //                                     overflow: TextOverflow.ellipsis,
    //                                   );
    //
    //                               }
    //                           ),
    //                         ),
    //                       );
    //                     });
    //               } else {
    //                 return Center(
    //                   child: CircularProgressIndicator(
    //                     backgroundColor: MateColors.activeIcons,
    //                   ),
    //                 );
    //               }
    //             })
    //             : Center(
    //           child: Text("Start a conversation, mate!", style: TextStyle(fontSize: 13.0.sp, fontWeight: FontWeight.w700, color: MateColors.activeIcons)),
    //         ) : Center(
    //           child: Text("Start a conversation, mate!", style: TextStyle(fontSize: 13.0.sp, fontWeight: FontWeight.w700, color: MateColors.activeIcons)),
    //         );
    //       } else {
    //         return Center(
    //           child: CircularProgressIndicator(
    //             backgroundColor: MateColors.activeIcons,
    //           ),
    //         );
    //       }
    //     });
  }

/*Widget _personalMessages() {
    return FutureBuilder(
        future: DatabaseService().getAllUserData(_user.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) =>
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                    child: ListTile(
                      onTap: () =>
                          Get.to(() =>
                              Chat(
                                currentUserId: _user.uid, //
                                peerId: snapshot.data.docs[index].data()["uid"],
                                peerName: snapshot.data.docs[index].data()["displayName"],
                                peerAvatar: snapshot.data.docs[index].data()["photoURL"],
                              )),
                      leading: CircleAvatar(
                        radius: 20,
                        backgroundColor: MateColors.activeIcons,
                        backgroundImage: NetworkImage(
                          snapshot.data.docs[index].data()["photoURL"],
                        ),

                      ),
                      title: Text(snapshot.data.docs[index].data()["displayName"], style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w700, color: MateColors.activeIcons)),
                      subtitle: Text(
                        "Tap to send message",
                        style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w100, color: Colors.grey[50]),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),);
          } else {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: MateColors.activeIcons,
              ),
            );
          }
        });
  }*/
}
