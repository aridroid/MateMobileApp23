

class ChatData {

  static bool isLastMessageLeft(var listMessage, String id, int index) {
    if ((index > 0 && listMessage != null && listMessage[index - 1].get('idFrom') == id) || index == 0) {
      return true;
    } else {
      return false;
    }
  }

  static bool isLastMessageRight(var listMessage, String id, int index) {
    if ((index > 0 && listMessage != null && listMessage[index - 1].get('idFrom') != id) || index == 0) {
      return true;
    } else {
      return false;
    }
  }
}
