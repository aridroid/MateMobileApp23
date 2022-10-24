import 'package:mate_app/Model/Message.dart';

abstract class ChatListener{
  void onReceivedNewMessage(List<Message> messageList);
}