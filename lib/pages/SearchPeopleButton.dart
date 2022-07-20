import 'dart:developer';

import 'package:chat_application/main.dart';
import 'package:chat_application/models/ChatRoomModel.dart';
import 'package:chat_application/models/UserModel.dart';
import 'package:chat_application/pages/ChatRoomPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchPeopleButton extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const SearchPeopleButton(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  State<SearchPeopleButton> createState() => _SearchPeopleButtonState();
}

class _SearchPeopleButtonState extends State<SearchPeopleButton> {
  TextEditingController searchController = TextEditingController();

  ChatRoomModel? chatRoom;

  Future<ChatRoomModel?> getChatRoomModel(UserModel targetUser) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .where("participants.${widget.userModel.uid}", isEqualTo: true)
        .where("participants.${targetUser.uid}", isEqualTo: true)
        .get();

    if (snapshot.docs.isNotEmpty) {
      //Fetch the existing chatroom
      log("chatrooom already exists");
      var docData = snapshot.docs[0].data();
      ChatRoomModel existingChatRoom =
          ChatRoomModel.fromMap(docData as Map<String, dynamic>);

      chatRoom = existingChatRoom;
    } else {
      //create a new chatroom
      ChatRoomModel newChatRoom = ChatRoomModel(
          chatRoomID: uuid.v1(),
          participants: {
            widget.userModel.uid.toString(): true,
            targetUser.uid.toString(): true
          });
      await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(newChatRoom.chatRoomID)
          .set(newChatRoom.toMap());

      chatRoom = newChatRoom;
      log("New chatroom created");
    }

    return chatRoom;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: const InputDecoration(
                  hintText: "Search By Email", label: Text("Search")),
            ),
            CupertinoButton(
                onPressed: () {
                  setState(() {});
                },
                child: const Text("Search")),
            const SizedBox(
              height: 40.0,
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .where("userEmail", isEqualTo: searchController.text)
                    .where("userEmail", isNotEqualTo: widget.firebaseUser.email)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      log("snapshot has data");
                      QuerySnapshot dataSnapshot =
                          snapshot.data as QuerySnapshot;

                      log(dataSnapshot.docs.toString());
                      if (dataSnapshot.docs.isNotEmpty) {
                        Map<String, dynamic> userMap =
                            dataSnapshot.docs[0].data() as Map<String, dynamic>;

                        UserModel searchedUser = UserModel.fromMap(userMap);
                        log("data is available");

                        return ListTile(
                          onTap: () async {
                            ChatRoomModel? chatroomModel =
                                await getChatRoomModel(searchedUser);

                            if (chatroomModel != null) {
                              // ignore: use_build_context_synchronously
                              Navigator.pop(context);
                              // ignore: use_build_context_synchronously
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return ChatRoomPage(
                                  targetUser: searchedUser,
                                  userModel: widget.userModel,
                                  firebaseUser: widget.firebaseUser,
                                  chatroom: chatroomModel,
                                );
                              }));
                            }
                          },
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(searchedUser.profilePicture!),
                          ),
                          title: Text(searchedUser.fullName!),
                          subtitle: Text(searchedUser.userEmail!),
                          trailing:
                              const Icon(Icons.keyboard_arrow_right_sharp),
                        );
                      } else if (snapshot.hasError) {
                        return const Text("Error occured");
                      } else {
                        return const Text("No results Found!");
                      }
                    }
                  }

                  return const Text("Connection Lost");
                }),
          ],
        ),
      ),
    );
  }
}
