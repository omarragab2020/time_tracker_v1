// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:time_tracker/app/models/chatUserModel.dart';
// import 'package:time_tracker/app/screens/chat/conversationList.dart';
// import 'package:time_tracker/app/screens/chat/newPage.dart';
// import 'package:time_tracker/app/services/chat-api.dart';
// import 'package:time_tracker/app/widgets/loading_circle.dart';
// import 'package:time_tracker/app/services/api.dart';
// import 'mongodb.dart';
//
// class ChatPage extends StatefulWidget {
//   @override
//   _ChatPageState createState() => _ChatPageState();
// }
//
// class _ChatPageState extends State<ChatPage> {
//   List<ChatUsers> chatUsers = [];
//
//   Future<void> getAllUsers() async {
//     List users = await chatapi.getAllUsers() as List;
//
//     for (int i = 0; i < users.length; i++) {
//       if (users[i]['first_name'] != null && users[i]['last_name'] != null) {
//         chatUsers.add(ChatUsers(
//             name: (users[i]['first_name'] as String) +
//                 (users[i]['last_name'] as String),
//             userId: users[i]['id'] as String));
//       }
//     }
//
//     setState(() {
//       allUsers = true;
//     });
//   }
//
//   Future<void> getOldMsgs() async {
//     final storage = ChatStorage('mongodb://10.0.2.2:27017/time-tracker');
//     List<ChatUsers> oldChats = [];
//     List chats = await chatapi.getDistinctSendersAndRecipients(api.userID);
//     for (int i = 0; i < chats.length; i++) {
//       oldChats.add(ChatUsers(
//           name: await chatapi.getUser(chats[i] as String) as String,
//           userId: chats[i] as String,
//           unreadMessages: await chatapi.getUnreadChatsNumber(
//               chats[i] as String, api.userID)));
//     }
//     //         as List<ChatMessage>;
//     setState(() {
//       chatUsers = oldChats;
//     });
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     getOldMsgs();
//     super.initState();
//     // getAllUsers();
//   }
//
//   bool allUsers = false;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color.fromARGB(255, 24, 46, 59),
//       body: SingleChildScrollView(
//         physics: BouncingScrollPhysics(),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             SafeArea(
//               child: Padding(
//                 padding: EdgeInsets.only(left: 16, right: 16, top: 10),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: <Widget>[
//                     Text(
//                       "Chats",
//                       style: TextStyle(
//                           fontSize: 32,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white),
//                     ),
//                     Row(
//                       children: <Widget>[
//                         // Icon(
//                         //   Icons.add,
//                         //   color: Colors.black,
//                         //   size: 20,
//                         // ),
//                         SizedBox(
//                           width: 2,
//                         ),
//                         TextButton(
//                             onPressed: () {
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => NewPage()));
//                             },
//                             child: Row(
//                               children: [
//                                 Icon(
//                                   Icons.add,
//                                   color: Colors.white,
//                                   size: 20,
//                                 ),
//                                 Text(
//                                   "New chat",
//                                   style: TextStyle(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white),
//                                 ),
//                               ],
//                             )),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             // Padding(
//             //   padding: EdgeInsets.only(top: 16, left: 16, right: 16),
//             //   child: TextField(
//             //     decoration: InputDecoration(
//             //       hintText: "Search...",
//             //       hintStyle: TextStyle(color: Colors.grey.shade600),
//             //       prefixIcon: Icon(
//             //         Icons.search,
//             //         color: Colors.grey.shade600,
//             //         size: 20,
//             //       ),
//             //       filled: true,
//             //       fillColor: Colors.grey.shade100,
//             //       contentPadding: EdgeInsets.all(8),
//             //       enabledBorder: OutlineInputBorder(
//             //           borderRadius: BorderRadius.circular(20),
//             //           borderSide: BorderSide(color: Colors.grey.shade100)),
//             //     ),
//             //   ),
//             // ),
//             ListView.builder(
//               itemCount: chatUsers.length,
//               shrinkWrap: true,
//               padding: EdgeInsets.only(top: 16),
//               physics: NeverScrollableScrollPhysics(),
//               itemBuilder: (context, index) {
//                 return ConversationList(
//                   name: chatUsers[index].name,
//                   userId: chatUsers[index].userId,
//                   messageText: chatUsers[index].messageText,
//                   imageUrl: chatUsers[index].imageURL,
//                   time: chatUsers[index].time,
//                   unreadMessages: chatUsers[index].unreadMessages,
//                 );
//               },
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
