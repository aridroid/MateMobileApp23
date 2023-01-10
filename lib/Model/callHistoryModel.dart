class CallHistoryModel{
  String callType;
  bool isPersonalCall;
  String callerId;
  String receiverId;
  String createdAt;
  String callSymbol;

  CallHistoryModel(this.callType,this.isPersonalCall,this.createdAt,this.callerId,this.callSymbol,this.receiverId);

}