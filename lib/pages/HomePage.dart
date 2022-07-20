import 'dart:developer';

import 'package:chat_application/models/ChatRoomModel.dart';
import 'package:chat_application/models/FirebaseHelper.dart';
import 'package:chat_application/models/UserModel.dart';
import 'package:chat_application/pages/ChatRoomPage.dart';
import 'package:chat_application/pages/LoginPage.dart';
import 'package:chat_application/pages/SearchPeopleButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const HomePage(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("ChatX"),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) {
                  return const LoginPage();
                }),
              );
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("chatrooms")
                .where("participants.${widget.userModel.uid}", isEqualTo: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  QuerySnapshot chatRoomSnapshot =
                      snapshot.data as QuerySnapshot;

                  return ListView.builder(
                    itemCount: chatRoomSnapshot.docs.length,
                    itemBuilder: (context, index) {
                      ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(
                          chatRoomSnapshot.docs[index].data()
                              as Map<String, dynamic>);

                      Map<String, dynamic> participants =
                          chatRoomModel.participants!;

                      List<String> participantKeys = participants.keys.toList();
                      participantKeys.remove(widget.userModel.uid);

                      return FutureBuilder(
                        future:
                            FirebaseHelper.getUserModelByID(participantKeys[0]),
                        builder: (context, userData) {
                          if (userData.connectionState ==
                              ConnectionState.done) {
                            if (userData.data != null) {
                              UserModel targetUser = userData.data as UserModel;

                              return ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      return ChatRoomPage(
                                        chatroom: chatRoomModel,
                                        firebaseUser: widget.firebaseUser,
                                        userModel: widget.userModel,
                                        targetUser: targetUser,
                                      );
                                    }),
                                  );
                                },
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      targetUser.profilePicture.toString()),
                                ),
                                title: Text(targetUser.fullName.toString()),
                                subtitle: (chatRoomModel.lastMessage
                                            .toString() !=
                                        "")
                                    ? Text(chatRoomModel.lastMessage.toString())
                                    : Text(
                                        "Say hi to your new friend!",
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                      ),
                              );
                            } else {
                              return Container();
                            }
                          } else {
                            return Container();
                          }
                        },
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                } else {
                  return Center(
                    child: Text("No Chats"),
                  );
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return SearchPeopleButton(
                userModel: widget.userModel, firebaseUser: widget.firebaseUser);
          }));
        },
        child: Icon(Icons.search),
      ),
    );
  }
}

// class HomePage extends StatefulWidget {
//   final UserModel userModel;
//   final User firebaseUser;

//   const HomePage(
//       {super.key, required this.userModel, required this.firebaseUser});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         actions: [
//           IconButton(
//               onPressed: () async {
//                 await FirebaseAuth.instance.signOut();
//                 // ignore: use_build_context_synchronously
//                 Navigator.popUntil(context, (route) => route.isFirst);
//                 // ignore: use_build_context_synchronously
//                 Navigator.pushReplacement(context,
//                     MaterialPageRoute(builder: (context) {
//                   return const LoginPage();
//                 }));
//               },
//               icon: const Icon(Icons.exit_to_app))
//         ],
//       ),
//       body: SafeArea(
//           child: Container(
//               padding: const EdgeInsets.all(10.0),
//               child: StreamBuilder(
//                 stream: FirebaseFirestore.instance
//                     .collection("chatrooms")
//                     .where("participants.${widget.userModel.uid}",
//                         isEqualTo: true)
//                     .snapshots(),
//                 builder: (BuildContext context,
//                     AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
//                         snapshot) {
//                   if (snapshot.connectionState == ConnectionState.active) {
//                     if (snapshot.hasData) {
//                       QuerySnapshot chatRoomSnapshot =
//                           snapshot.data as QuerySnapshot;
//                       return ListView.builder(
//                           itemCount: chatRoomSnapshot.docs.length,
//                           itemBuilder: (context, index) {
//                             ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(
//                                 chatRoomSnapshot.docs[index].data()
//                                     as Map<String, dynamic>);

//                             Map<String, dynamic> participants =
//                                 chatRoomModel.participants!;

//                             List<String> participantKeys =
//                                 participants.keys.toList();

//                             participantKeys.remove(widget.userModel.uid);

//                             return FutureBuilder(
//                                 future: FirebaseHelper.getUserModelByID(
//                                     participantKeys[0]),
//                                 builder: (context, userData) {
//                                   if (userData.connectionState ==
//                                       ConnectionState.done) {
//                                     UserModel targetUser =
//                                         userData.data as UserModel;

//                                     return ListTile(
//                                       onTap: () {
//                                         Navigator.push(context,
//                                             MaterialPageRoute(
//                                                 builder: (context) {
//                                           return ChatRoomPage(
//                                               userModel: widget.userModel,
//                                               firebaseUser: widget.firebaseUser,
//                                               targetUser: targetUser,
//                                               chatRoom: chatRoomModel);
//                                         }));
//                                       },
//                                       leading: CircleAvatar(
//                                           backgroundImage: NetworkImage(
//                                         targetUser.profilePicture.toString(),
//                                       )),
//                                       title:
//                                           Text(targetUser.fullName.toString()),
//                                       subtitle: (chatRoomModel.lastMessage
//                                                   .toString() !=
//                                               "")
//                                           ? Text(chatRoomModel.lastMessage
//                                               .toString())
//                                           : Text(
//                                               "Say hi to your new friend!",
//                                               style: TextStyle(
//                                                 color: Theme.of(context)
//                                                     .colorScheme
//                                                     .secondary,
//                                               ),
//                                             ),
//                                     );
//                                   } else {
//                                     return const Center(
//                                       child: CircularProgressIndicator(),
//                                     );
//                                   }
//                                 });
//                           });
//                     } else if (snapshot.hasError) {
//                       log("${snapshot.error}");
//                       return const Text("Error Occurred");
//                     } else {
//                       return const Text("No Chats");
//                     }
//                   } else {
//                     return const Text("No Internet Connection");
//                   }
//                 },
//               ))),
//       floatingActionButton: FloatingActionButton(
//           child: const Icon(Icons.search),
//           onPressed: () {
//             Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => SearchPeopleButton(
//                           firebaseUser: widget.firebaseUser,
//                           userModel: widget.userModel,
//                         )));
//           }),
//     );
//   }
// }