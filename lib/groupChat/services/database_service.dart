import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mate_app/Model/AuthUser.dart';
import 'package:provider/provider.dart';

import '../../Providers/chatProvider.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  // Collection reference
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('chat-users');
  final CollectionReference groupCollection = FirebaseFirestore.instance.collection('chat-group');
  final CollectionReference callCollection = FirebaseFirestore.instance.collection('call-details');

  // update userdata
  Future<void> updateUserData(User userData, String uuid, String displayName,String profileImage) async {
    // return await userCollection.doc(uid).set({
    //   'uid': userData.uid,
    //   'displayName': userData.displayName,
    //   'email': userData.email,
    //   'photoURL' : userData.photoURL,
    //   // 'chat-group': [],
    // });

    final QuerySnapshot result = await userCollection.where('uid', isEqualTo: userData.uid).get();
    final List<DocumentSnapshot> documents = result.docs;
    if (documents.length == 0) {
      // Update data to server if new user
      await saveNewUser(userData,uuid,displayName,profileImage);
    }
    await updateOldUser(userData,uuid,displayName,profileImage);
  }

  updateOldUser(User logInUser, String uuid, String displayName,String profileImage) {
    userCollection.doc(logInUser.uid).update({
      'displayName': displayName,
      'photoURL': profileImage??logInUser.photoURL,
      'uuid': uuid,
    });
  }

  saveNewUser(User logInUser, String uuid, String displayName,String profileImage) {
    userCollection.doc(logInUser.uid).set({
      'uid': logInUser.uid,
      'displayName': displayName,
      'email': logInUser.email,
      'photoURL': profileImage??logInUser.photoURL,
      'chat-group': [],
      'chattingWith': [],
      'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
      'online': null,
      'uuid': uuid,
    });
  }

  // create group
  Future<String> createGroup(String userName, String userId, String groupName, int maxParticipant, bool isPrivate) async {
    print("hiu");
    DocumentReference groupDocRef = await groupCollection.add({
      'groupName': groupName,
      'groupIcon': '',
      'admin': userName,
      'adminId': userId,
      'creator': userName,
      'creatorId' : userId,
      'createdAt' : DateTime.now().millisecondsSinceEpoch,
      'members': [],
      //'messages': ,
      'groupId': '',
      'description': "",
      'maxParticipantNumber': maxParticipant,
      'isPrivate': isPrivate,
      'recentMessage': '',
      'recentMessageSender': '',
      'recentMessageTime': ''
    });

    await groupDocRef.update({
      'members': FieldValue.arrayUnion(["${uid}_$userName"]),
      'groupId': groupDocRef.id
    });

    DocumentReference userDocRef = userCollection.doc(uid);
    await userDocRef.update({
      'chat-group': FieldValue.arrayUnion([groupDocRef.id + '_' + groupName])
    });

    return groupDocRef.id;


  }

  // toggling the user group join
  Future togglingGroupJoin(String groupId, String groupName, String userName) async {
    print(groupId);
    print(groupName);
    print(userName);
    DocumentReference userDocRef = userCollection.doc(uid);
    DocumentSnapshot userDocSnapshot = await userDocRef.get();

    DocumentReference groupDocRef = groupCollection.doc(groupId);

    List<dynamic> groups = await userDocSnapshot['chat-group'];

    if (groups != null) {
      if (groups.contains(groupId + '_' + groupName)) {
        //print('hey');
        await userDocRef.update({
          'chat-group': FieldValue.arrayRemove([groupId + '_' + groupName])
        });

        await groupDocRef.update({
          'members': FieldValue.arrayRemove([uid + '_' + userName])
        });
      } else {
        //print('nay');
        await userDocRef.update({
          'chat-group': FieldValue.arrayUnion([groupId + '_' + groupName])
        });

        await groupDocRef.update({
          'members': FieldValue.arrayUnion([uid + '_' + userName])
        });
      }
    } else {
      //print('nay');
      await userDocRef.update({
        'chat-group': FieldValue.arrayUnion([groupId + '_' + groupName])
      });

      await groupDocRef.update({
        'members': FieldValue.arrayUnion([uid + '_' + userName])
      });
    }
  }

  Future groupJoin(String groupId, String groupName, String userName) async {
    DocumentReference userDocRef = userCollection.doc(uid);
    DocumentSnapshot userDocSnapshot = await userDocRef.get();

    DocumentReference groupDocRef = groupCollection.doc(groupId);

    List<dynamic> groups = await userDocSnapshot['chat-group'];

    if (groups != null) {
      if (groups.contains(groupId + '_' + groupName)) {
        //print('hey');
      } else {
        //print('nay');
        await userDocRef.update({
          'chat-group': FieldValue.arrayUnion([groupId + '_' + groupName])
        });

        await groupDocRef.update({
          'members': FieldValue.arrayUnion([uid + '_' + userName])
        });
      }
    } else {
      //print('nay');
      await userDocRef.update({
        'chat-group': FieldValue.arrayUnion([groupId + '_' + groupName])
      });

      await groupDocRef.update({
        'members': FieldValue.arrayUnion([uid + '_' + userName])
      });
    }
  }

  // Exit the user groupjoin
  Future exitGroup(String groupId, String groupName, String userName) async {
    DocumentReference userDocRef = userCollection.doc(uid);
    DocumentSnapshot userDocSnapshot = await userDocRef.get();

    DocumentReference groupDocRef = groupCollection.doc(groupId);

    List<dynamic> groups = await userDocSnapshot['chat-group'];

      print(userName);
      for(int i=0;i<groups.length;i++){
        if(groups[i].contains(groupId)){
          await userDocRef.update({
            'chat-group': FieldValue.arrayRemove([groups[i]])
          });

          await groupDocRef.update({
            'members': FieldValue.arrayRemove([uid + '_' + userName])
          });

          break;
        }

      }
    // if (groups.contains(groupId + '_' + groupName)) {
    //   //print('hey');
    //   await userDocRef.update({
    //     'chat-group': FieldValue.arrayRemove([groupId + '_' + groupName])
    //   });
    //
    //   await groupDocRef.update({
    //     'members': FieldValue.arrayRemove([uid + '_' + userName])
    //   });
    // }
  }

  // has user joined the group
  Future<bool> isUserJoined(String groupId, String groupName, String userName) async {
    DocumentReference userDocRef = userCollection.doc(uid);
    DocumentSnapshot userDocSnapshot = await userDocRef.get();

    List<dynamic> groups = await userDocSnapshot['chat-group'];

    if (groups != null) {
      if (groups.contains(groupId + '_' + groupName)) {
        //print('he');
        return true;
      } else {
        //print('ne');
        return false;
      }
    } else
      return false;
  }

  // get user data
  Future getUserData(String email) async {
    QuerySnapshot snapshot = await userCollection.where('email', isEqualTo: email).get();
    print(snapshot.docs[0].data);
    return snapshot;
  }

  // get user data
  Future<QuerySnapshot> getAllUserData(String uid) async {
    QuerySnapshot snapshot = await userCollection.where('uid', isNotEqualTo: uid).get();
    print(snapshot.docs[0].data);
    return snapshot;
  }

  //get stream user data all..............
  // Stream<QuerySnapshot> getAllUserData(){
  //   Stream<QuerySnapshot> snapshot = userCollection.snapshots();
  //   return snapshot;
  // }

  // get user groups
  Stream<DocumentSnapshot> getUserGroups() {
    // return await Firestore.instance.collection("chat-users").where('email', isEqualTo: email).snapshots();
    return FirebaseFirestore.instance.collection("chat-users").doc(uid).snapshots();
  }

  Future<DocumentSnapshot> getUsersDetails(String userId) async {
    return FirebaseFirestore.instance.collection("chat-users").doc(userId).get();
  }

  Future<QuerySnapshot> getUsersDetailsAll() async {
    return FirebaseFirestore.instance.collection("chat-users").get();
  }

  Future<bool> getUserExistGroup(String groupId,String userId,String userName) async {
    DocumentSnapshot groupDocSnapshot = await groupCollection.doc(groupId).get();
    List<dynamic> groupUsers = groupDocSnapshot['members'];
    if(groupUsers!=null){
      if(groupUsers.contains("${userId}_$userName")){
        return true;
      }else{
        return false;
      }
    }else{
      return false;
    }
  }

  Future<bool> userGroupJoin(String groupId, String groupName, String userName) async {
    DocumentReference userDocRef = userCollection.doc(uid);
    DocumentSnapshot userDocSnapshot = await userDocRef.get();
    DocumentReference groupDocRef = groupCollection.doc(groupId);

    await userDocRef.update({
      'chat-group': FieldValue.arrayUnion([groupId + '_' + groupName])
    });

    await groupDocRef.update({
      'members': FieldValue.arrayUnion([uid + '_' + userName])
    });

    return true;

  }


  // send message
  //here I changed chatDocRef and
  sendMessage(String groupId, chatMessageData,String senderImage) async{
    DocumentReference chatDocRef = await FirebaseFirestore.instance.collection('chat-group').doc(groupId).collection('messages').add(chatMessageData);
    Map<String, dynamic> recentChatMessage={
      'recentMessage': chatMessageData['message'],
      'recentMessageSender': chatMessageData['sender'],
      'recentMessageTime': chatMessageData['time'].toString(),
      'isImage': chatMessageData['isImage'],
      'isFile' : chatMessageData['isFile'],
      'isGif' : chatMessageData['isGif'],
      'isAudio': chatMessageData['isAudio']
    };
    if(chatMessageData['fileName']!=null){
      recentChatMessage['fileName'] = chatMessageData['fileName'];
    }

    FirebaseFirestore.instance.collection('chat-group').doc(groupId).update(recentChatMessage);
    //here I changed
    FirebaseFirestore.instance.collection('chat-group').doc(groupId).collection("messages").doc(chatDocRef.id).set(
      {'messageId': chatDocRef.id,'messageReaction':[],"senderImage": senderImage},
      SetOptions(merge: true),
    );

  }



  sendMessageForwarded(String groupId, chatMessageData,String senderImage) async{
    DocumentReference chatDocRef = await FirebaseFirestore.instance.collection('chat-group').doc(groupId).collection('messages').add(chatMessageData);
    Map<String, dynamic> recentChatMessage={
      'recentMessage': chatMessageData['message'],
      'recentMessageSender': chatMessageData['sender'],
      'recentMessageTime': chatMessageData['time'].toString(),
      'isImage': chatMessageData['isImage'],
      'isFile' : chatMessageData['isFile'],
      'isGif' : chatMessageData['isGif'],
      'isAudio':chatMessageData['isAudio'],
    };
    if(chatMessageData['fileName']!=null){
      recentChatMessage['fileName'] = chatMessageData['fileName'];
    }

    FirebaseFirestore.instance.collection('chat-group').doc(groupId).update(recentChatMessage);
    //here I changed
    FirebaseFirestore.instance.collection('chat-group').doc(groupId).collection("messages").doc(chatDocRef.id).set(
      {'messageId': chatDocRef.id,'messageReaction':[],"senderImage": senderImage,"isForwarded":true},
      SetOptions(merge: true),
    );

  }


  // get chats of a particular group
  getChats(String groupId) async {
    return groupCollection.doc(groupId).collection('messages').orderBy('time', descending: true).snapshots();
  }

  Stream<DocumentSnapshot> getGroupDetails(String groupId){
    return groupCollection.doc(groupId).snapshots();
  }

   Future<DocumentSnapshot> getGroupDetailsOnce(String groupId){
    return groupCollection.doc(groupId).get();
  }


  updateGroupIcon(String groupId, String image){
    FirebaseFirestore.instance.collection('chat-group').doc(groupId).update({
      'groupIcon': image,
    });
  }

  updateGroupDescription(String groupId, String desc,String descriptionCreatorName,String descriptionCreatorImage,){
    FirebaseFirestore.instance.collection('chat-group').doc(groupId).set({
      'description': desc.trim(),
      'descriptionCreatorName' : descriptionCreatorName,
      'descriptionCreatorImage' : descriptionCreatorImage,
      'descriptionCreationTime' : DateTime.now().millisecondsSinceEpoch,
    }, SetOptions(merge: true),
    );
  }

  updateGroupName(String groupId, String groupName){
    FirebaseFirestore.instance.collection('chat-group').doc(groupId).update({
      'groupName': groupName.trim(),
    });
  }









  Stream<DocumentSnapshot> getLastChatMessage(String groupId) {
    String message = "";
    return FirebaseFirestore.instance.collection('chat-group').doc(groupId).snapshots();
    /*.then((value) {
       print("ei to");
       print(value.data()['recentMessage']);

       message = value.data()['recentMessage'];
     });
     return message;*/
  }

  Future<DocumentSnapshot> getMateGroupDetailsData(String groupId)async{
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('chat-group').doc(groupId).get();
    return snapshot;
  }

  // search groups
  searchByName(String groupName) {
    return FirebaseFirestore.instance.collection("chat-group").where('groupName', isEqualTo: groupName).get();
  }

  searchByUserName(String personName) {
    return FirebaseFirestore.instance.collection("chat-users").where('displayName', isEqualTo: personName).get();
  }

  Stream<QuerySnapshot> getPeerChatUsers() {
    Stream<QuerySnapshot> snapshot = userCollection.where('uid', isEqualTo: uid).snapshots();
    return snapshot;
  }

  Stream<QuerySnapshot> getPeerChatUsersDetails(List<dynamic> peerId) {
    Stream<QuerySnapshot> snapshot = userCollection.where('uid', whereIn: peerId).snapshots();
    return snapshot;
  }

  Stream<QuerySnapshot> getPeerChatUserDetail(String peerId) {
    Stream<QuerySnapshot> snapshot = userCollection.where('uid', isEqualTo: peerId).snapshots();
    return snapshot;
  }



  Stream<QuerySnapshot> getLastPersonalChatMessage(String personChatId) {
    print("personChatId $personChatId");
    return FirebaseFirestore.instance.collection('messages').doc(personChatId).collection(personChatId).orderBy('timestamp', descending: true)./*limit(5).*/snapshots();
  }

  Future<QuerySnapshot> getAllGroups() async{
    QuerySnapshot snapshot =await FirebaseFirestore.instance.collection('chat-group').get();
    return snapshot;
  }

// addPeerChatUserDetails(){
//   FirebaseFirestore.instance.collection('chat-group').doc(groupId).collection('messages').add(chatMessageData);
// }


  // Future<void> deleteUser(String groupId,String val)async{
  //   var response =  await FirebaseFirestore.instance.collection('chat-group').doc(groupId).update({'members': FieldValue.arrayRemove([val])});
  // }


  Future<String> addUserToGroup(String userUid,String groupId, String groupName, String userName) async {
    DocumentReference userDocRef = userCollection.doc(userUid);
    DocumentSnapshot userDocSnapshot = await userDocRef.get();

    DocumentReference groupDocRef = groupCollection.doc(groupId);

    List<dynamic> groups = await userDocSnapshot['chat-group'];

    String result = "";

    if (groups != null) {
      if (groups.contains(groupId + '_' + groupName)) {
        //print('hey');
        result = "already added";
      } else {
        //print('nay');
        await userDocRef.update({
          'chat-group': FieldValue.arrayUnion([groupId + '_' + groupName])
        });

        await groupDocRef.update({
          'members': FieldValue.arrayUnion([userUid + '_' + userName])
        });

        result = "Success";
      }
    } else {
      //print('nay');
      await userDocRef.update({
        'chat-group': FieldValue.arrayUnion([groupId + '_' + groupName])
      });

      await groupDocRef.update({
        'members': FieldValue.arrayUnion([userUid + '_' + userName])
      });

      result = "Success";
    }
    return result;
  }


  updateNotice(String groupId, String notice){
    FirebaseFirestore.instance.collection('chat-group').doc(groupId).set(
      {'notice': notice},
      SetOptions(merge: true),
    );
  }

  setMessageReaction(String groupId, String messageId,String value,String displayName,String photo){
    FirebaseFirestore.instance.collection('chat-group').doc(groupId).collection("messages").doc(messageId).set(
      {'messageReaction': FieldValue.arrayUnion([uid + '_____' +displayName + '_____' +photo + "_____" + value])},
      SetOptions(merge: true),
    );
  }

  updateMessageReaction(String groupId, String messageId,String previousValue){
    FirebaseFirestore.instance.collection('chat-group').doc(groupId).collection("messages").doc(messageId).update(
      {'messageReaction': FieldValue.arrayRemove([previousValue])},
    );
  }

  setMessageReactionOneToOne(String personChatId, String messageId,String value,String displayName,String photo){
    FirebaseFirestore.instance.collection('messages').doc(personChatId).collection(personChatId).doc(messageId).set(
      {'messageReaction': FieldValue.arrayUnion([uid + '_____' +displayName + '_____' +photo + "_____" + value])},
      SetOptions(merge: true),
    );
  }

  updateMessageReactionOneToOne(String personChatId, String messageId,String previousValue){
    FirebaseFirestore.instance.collection('messages').doc(personChatId).collection(personChatId).doc(messageId).update(
      {'messageReaction': FieldValue.arrayRemove([previousValue])},
    );
  }

  deleteMessageOneToOne(String personChatId, String messageId){
    FirebaseFirestore.instance.collection('messages').doc(personChatId).collection(personChatId).doc(messageId).delete();
  }

  deleteMessage(String groupId, String messageId){
    FirebaseFirestore.instance.collection('chat-group').doc(groupId).collection("messages").doc(messageId).delete();
  }
  
  editMessage(String groupId, String messageId,String message){
    FirebaseFirestore.instance.collection('chat-group').doc(groupId).collection("messages").doc(messageId).update({
      'message':message,
    });
  }

  editMessageOneToOne(String personChatId, String messageId,String message){
    FirebaseFirestore.instance.collection('messages').doc(personChatId).collection(personChatId).doc(messageId).update({
      'content':message
    });
  }


  Future<void> updateUserDataLoginWithEmail(AuthUser userData) async {
    final QuerySnapshot result = await userCollection.where('uid', isEqualTo: userData.firebaseUid).get();
    final List<DocumentSnapshot> documents = result.docs;
    if (documents.length == 0) {
      await saveNewUserLoginWithEmail(userData);
    }
    await updateOldUserLoginWithEmail(userData);
  }

  updateOldUserLoginWithEmail(AuthUser logInUser) {
    print("old user update");
    print(logInUser.firebaseUid);
    print(logInUser.displayName);
    print(logInUser.photoUrl);
    print(logInUser.id);
    userCollection.doc(logInUser.firebaseUid).update({
      'displayName': logInUser.displayName,
      'photoURL': logInUser.photoUrl,
      'uuid': logInUser.id,
    });
  }

  saveNewUserLoginWithEmail(AuthUser logInUser) {
    print("new user added");
    print(logInUser.firebaseUid);
    userCollection.doc(logInUser.firebaseUid).set({
      'uid': logInUser.firebaseUid,
      'displayName': logInUser.displayName,
      'email': logInUser.email,
      'photoURL': logInUser.photoUrl,
      'chat-group': [],
      'chattingWith': [],
      'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
      'online': null,
      'uuid': logInUser.id,
    });
  }



  setIsMuted(String groupId, String uid){
    FirebaseFirestore.instance.collection('chat-group').doc(groupId).set(
      {'isMuted': FieldValue.arrayUnion([uid])},
      SetOptions(merge: true),
    );
  }

  removeIsMuted(String groupId, String uid){
    FirebaseFirestore.instance.collection('chat-group').doc(groupId).set(
      {'isMuted': FieldValue.arrayRemove([uid])},
      SetOptions(merge: true),
    );
  }

  setTopToPin(String groupId, String uid){
    FirebaseFirestore.instance.collection('chat-group').doc(groupId).set(
      {'isPinned': FieldValue.arrayUnion([uid])},
      SetOptions(merge: true),
    );
  }

  removeTopToPin(String groupId, String uid){
    FirebaseFirestore.instance.collection('chat-group').doc(groupId).set(
      {'isPinned': FieldValue.arrayRemove([uid])},
      SetOptions(merge: true),
    );
  }

  ///Call related functions

  createCall({String channelName, String groupIdORPeerId, String groupNameORCallerName,String videoOrAudio,String token,String callerUid,List<String> groupMember}) async {
    Map<String,dynamic> body = {
      'channelName' : channelName,
      'groupIdORPeerId' : groupIdORPeerId,
      'groupNameORCallerName' : groupNameORCallerName,
      'isCallOnGoing' : true,
      'createdAt' : DateTime.now().millisecondsSinceEpoch,
      'callType' : videoOrAudio,
      'membersWhoJoined' : [],
      'memberWhoIsOnCall' : [],
      'memberWhoseCallHistoryAddedToChat' : [],
      'token' : token,
      'callerUid' : callerUid,
      'groupMember' : groupMember,
    };
    callCollection.doc(channelName).set(body).then((_) => print('Added')).catchError((error) => print('Add failed: $error'));
  }

  joinCall({String channelName,String uid}) async {
    callCollection.doc(channelName).set(
      {'membersWhoJoined': FieldValue.arrayUnion([uid]),'memberWhoIsOnCall':FieldValue.arrayUnion([uid])},
      SetOptions(merge: true),
    );
  }

  leaveCall({String channelName,String uid}) async {
    DocumentSnapshot result = await callCollection.doc(channelName).get();
    if(result['memberWhoIsOnCall'].length==1){
      callCollection.doc(channelName).set(
        {'memberWhoIsOnCall':FieldValue.arrayRemove([uid]),'isCallOnGoing':false},
        SetOptions(merge: true),
      );
    }else{
      callCollection.doc(channelName).set(
        {'memberWhoIsOnCall':FieldValue.arrayRemove([uid])},
        SetOptions(merge: true),
      );
    }
  }

  updateCallHistory({String channelName,String uid}) async {
    callCollection.doc(channelName).set(
      {'memberWhoseCallHistoryAddedToChat': FieldValue.arrayUnion([uid])},
      SetOptions(merge: true),
    );
  }

  Stream<DocumentSnapshot> getCallDetailByChannelName(String channelName) {
    Stream<DocumentSnapshot> snapshot = callCollection.doc(channelName).snapshots();
    return snapshot;
  }

  Future<QuerySnapshot> checkCallIsOngoing(String groupOrPeerId) {
    Future<QuerySnapshot> snapshot = callCollection.where('groupIdORPeerId', isEqualTo: groupOrPeerId).where('isCallOnGoing',isEqualTo: true).get();
    return snapshot;
  }

  Future<QuerySnapshot> getCallHistory() {
    Future<QuerySnapshot> snapshot = callCollection.where('isCallOnGoing',isEqualTo: false).orderBy('createdAt',descending: true).get();
    return snapshot;
  }

}
