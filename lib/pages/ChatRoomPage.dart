import 'dart:developer';

import 'package:chat_application/main.dart';
import 'package:chat_application/models/ChatRoomModel.dart';
import 'package:chat_application/models/MessagesModel.dart';
import 'package:chat_application/models/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatRoomPage extends StatefulWidget {
  final UserModel targetUser;
  final ChatRoomModel chatroom;
  final UserModel userModel;
  final User firebaseUser;

  const ChatRoomPage(
      {Key? key,
      required this.targetUser,
      required this.chatroom,
      required this.userModel,
      required this.firebaseUser})
      : super(key: key);

  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  TextEditingController messageController = TextEditingController();

  void sendMessage() async {
    String msg = messageController.text.trim();
    messageController.clear();

    if (msg != "") {
      // Send Message
      MessagesModel newMessage = MessagesModel(
          messageId: uuid.v1(),
          sender: widget.userModel.uid,
          createdOn: Timestamp.now(),
          text: msg,
          seen: false);

      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatroom.chatRoomID)
          .collection("messages")
          .doc(newMessage.messageId)
          .set(newMessage.toMap());

      widget.chatroom.lastMessage = msg;
      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatroom.chatRoomID)
          .set(widget.chatroom.toMap());

      log("Message Sent!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey[300],
              backgroundImage:
                  NetworkImage(widget.targetUser.profilePicture.toString()),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(widget.targetUser.fullName.toString()),
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              // This is where the chats will go
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("chatrooms")
                        .doc(widget.chatroom.chatRoomID)
                        .collection("messages")
                        .orderBy("createdOn", descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        if (snapshot.hasData) {
                          QuerySnapshot dataSnapshot =
                              snapshot.data as QuerySnapshot;

                          return ListView.builder(
                              reverse: true,
                              itemCount: dataSnapshot.docs.length,
                              itemBuilder: ((context, index) {
                                MessagesModel currentMessage =
                                    MessagesModel.fromMap(
                                        dataSnapshot.docs[index].data()
                                            as Map<String, dynamic>);
                                return Row(
                                    mainAxisAlignment: (currentMessage.sender ==
                                            widget.userModel.uid)
                                        ? MainAxisAlignment.end
                                        : MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 3),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              color: (currentMessage.sender ==
                                                      widget.userModel.uid)
                                                  ? Colors.grey
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .secondary),
                                          child: Text(
                                            style: const TextStyle(
                                                fontSize: 18,
                                                color: Colors.white),
                                            currentMessage.text.toString(),
                                          )),
                                    ]);
                              }));
                        } else if (snapshot.hasError) {
                          return const Text("an error occurred!");
                        } else {
                          return const Text("Say Hi to your new friend!");
                        }
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ),
              ),

              Container(
                color: Colors.grey[200],
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Row(
                  children: [
                    Flexible(
                      child: TextField(
                        controller: messageController,
                        maxLines: null,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter message"),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        sendMessage();
                      },
                      icon: Icon(
                        Icons.send,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
