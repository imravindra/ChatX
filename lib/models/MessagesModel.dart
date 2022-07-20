import 'package:cloud_firestore/cloud_firestore.dart';

class MessagesModel {
  String? messageId;
  String? sender;
  String? text;
  bool? seen;
  Timestamp? createdOn;

  MessagesModel(
      {this.sender, this.text, this.seen, this.createdOn, this.messageId});

  MessagesModel.fromMap(Map<String, dynamic> map) {
    sender = map['sender'];
    text = map['text'];
    seen = map['seen'];
    createdOn = map['createdOn'];
    messageId = map['messageId'];
  }

  Map<String, dynamic> toMap() {
    return {
      "sender": sender,
      "text": text,
      "seen": seen,
      "createdOn": createdOn,
      "messageId": messageId
    };
  }
}
