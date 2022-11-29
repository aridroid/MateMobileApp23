import 'dart:convert';

import 'package:mate_app/Model/AuthUser.dart';
import 'package:mate_app/Model/StudyGroup.dart';
import 'package:mate_app/Screen/Chat/ChatScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class GroupController extends GetxController {
  FirebaseFirestore _firestore;
  GetStorage _storage;

  @override
  void onInit() {
    super.onInit();
    _firestore = FirebaseFirestore.instance;
    _storage = GetStorage();
  }

  @override
  get onStart => super.onStart;

  @override
  void onClose() {
    super.onClose();
  }

  void checkAndGoToChatPage(StudyGroup studyGroup, BuildContext context) async {
    var selfUser = _storage.read("self_user");
    if (selfUser == null) {
      print("User null--------");
      return;
    }
    AuthUser userData = AuthUser.fromJson(jsonDecode(selfUser));
    bool isIamMember = false;

    await _firestore
        .collection("groups")
        .doc(studyGroup.id)
        .get()
        .then((documentSnap) {
      StudyGroup group = StudyGroup.fromJson(documentSnap.data());

      group.members.forEach((item) {
        if (item.id == userData.id) {
          isIamMember = true;
        }
      });
      if (!isIamMember) {
        Get.defaultDialog(
          title: "Join group",
          content: Text("Please join the group before chat"),
          confirm: ElevatedButton(
            onPressed: () async {
              Members member = Members(
                  id: userData.id,
                  name: userData.displayName,
                  photoUrl: userData.photoUrl);
              group.members.add(member);
              await _firestore
                  .collection("groups")
                  .doc(studyGroup.id)
                  .update(group.toJson())
                  .then(
                    (value) {
                  Get.back();
                  Get.to(ChatScreen(studyGroup));
                },
              );
            },
            child: Text("Join"),
          ),
          cancel: ElevatedButton(
            onPressed: () => Get.back(),
            child: Text("Cancel"),
          ),
        );
      } else {
        Get.to(
          ChatScreen(studyGroup),
        );
      }
    });
  }
}
