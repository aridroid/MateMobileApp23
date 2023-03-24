import 'package:get/get.dart';
import 'package:mate_app/audioAndVideoCalling/addParticipantsScreen.dart';

class AddUserController extends GetxController{
  List<int> selected = [];
  List<String> addConnectionUid = [];
  List<String> addConnectionDisplayName = [];
  List<UserListModel> personList = [];
}