import 'dart:convert';
import 'dart:io';

import 'package:mate_app/Model/AuthUser.dart';
import 'package:mate_app/Model/Message.dart';
import 'package:mate_app/Model/StudyGroup.dart';
import 'package:mate_app/Screen/Chat/ChatListener.dart';
import 'package:mate_app/Utility/Utility.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

class ChatController extends GetxController {
  StudyGroup _studyGroup;
  FirebaseFirestore _firestore;
  FirebaseStorage _firebaseStorage;
  CollectionReference _messageCollectionReference;
  GetStorage _getStorage;
  AuthUser _userData;
  ChatListener chatListener;

  @override
  void onInit() {
    _firestore = FirebaseFirestore.instance;
    _firebaseStorage = FirebaseStorage.instance;
    _getStorage = GetStorage();
    var selfUser = _getStorage.read("self_user");
    _userData = AuthUser.fromJson(jsonDecode(selfUser));
    super.onInit();
  }

  String getUserId() {
    return _userData.id;
  }

  @override
  void onClose() {
    super.onClose();
  }

  void setChatListener(ChatListener listener) {
    chatListener = listener;
  }

  void setChatMessageListener(StudyGroup studyGroup) {
    _messageCollectionReference = _firestore
        .collection("message")
        .doc(studyGroup.id)
        .collection("messages");
    _firestore
        .collection("message")
        .doc(studyGroup.id)
        .collection("messages")
        .snapshots()
        .listen((querySnaps) {
      List<Message> messageList = [];
      querySnaps.docChanges.forEach((docChange) {
        if (docChange.type == DocumentChangeType.added) {
          var data = docChange.doc.data();
          Message message = Message.fromMap(data);
          message.id = docChange.doc.id;
          messageList.add(message);
        } else if (docChange.type == DocumentChangeType.modified) {
        } else if (docChange.type == DocumentChangeType.removed) {}
      });
      chatListener.onReceivedNewMessage(messageList);
    });
  }

  void sendMessage(String msg) async {
    Message message = Message(_userData.id, _userData.displayName,
        _userData.photoUrl, msg, Timestamp.now(), TEXT_MESSAGE);
    await _messageCollectionReference.add(message.toMap()).then((value) {
      print("Message has send");
    });
  }

  // void sendImageMessage() async {
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.getImage(source: ImageSource.gallery);
  //   if (pickedFile == null) return;
  //   var fileUploadDb =
  //   _firebaseStorage.ref().child("images/${DateTime.now()}.png");
  //   Get.defaultDialog(
  //       title: "File uploading...", content: CircularProgressIndicator());
  //
  //   await fileUploadDb.putFile(File(pickedFile.path)).whenComplete(() async {
  //     var downloadPath = await fileUploadDb.getDownloadURL();
  //     if(Get.isDialogOpen){
  //       Get.back();
  //     }
  //     Message message = Message(_userData.id, _userData.displayName,
  //         _userData.photoUrl, downloadPath, Timestamp.now(), IMAGE_MESSAGE);
  //     await _messageCollectionReference.add(message.toMap()).then((value) {
  //       print("Message has send");
  //     });
  //   });
  // }
}
