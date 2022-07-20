import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomModel {
  String? chatRoomID;
  Map<String, dynamic>? participants;
  String? lastMessage;

  ChatRoomModel({this.chatRoomID, this.participants, this.lastMessage});

  ChatRoomModel.fromMap(Map<String, dynamic> map) {
    chatRoomID = map['chatRoomID'];
    participants = map['participants'];
    lastMessage = map['lastMessage'];
  }

  Map<String, dynamic> toMap() {
    return {
      "chatRoomID": chatRoomID,
      "participants": participants,
      'lastMessage': lastMessage,
    };
  }
}
