// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:time_tracker/app/models/chatUserModel.dart';
// import 'package:time_tracker/app/screens/chat/conversationList.dart';
// import 'package:time_tracker/app/services/chat-api.dart';
// import 'package:time_tracker/app/widgets/loading_circle.dart';
//
// class NewPage extends StatefulWidget {
//   @override
//   _NewPageState createState() => _NewPageState();
// }
//
// class _NewPageState extends State<NewPage> {
//   List<ChatUsers> chatUsers = [];
//
//   Future<void> getAllUsers() async {
//     List users = await chatapi.getAllUsers() as List;
//
//     for (int i = 0; i < users.length; i++) {
//       if (users[i]['first_name'] != null && users[i]['last_name'] != null) {
//         chatUsers.add(ChatUsers(
//             name: (users[i]['first_name'] as String) +
//                 " " +
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
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getAllUsers();
//   }
//
//   bool allUsers = false;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         physics: BouncingScrollPhysics(),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             SafeArea(
//               child: Padding(
//                 padding: EdgeInsets.only(left: 16, right: 16, top: 10),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: <Widget>[
//                     // Text(
//                     //   "Conversations",
//                     //   style:
//                     //       TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
//                     // ),
//                     // Container(
//                     //   padding:
//                     //       EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
//                     //   height: 30,
//                     //   decoration: BoxDecoration(
//                     //     borderRadius: BorderRadius.circular(30),
//                     //     color: Colors.pink[50],
//                     //   ),
//                     // child: Row(
//                     //   children: <Widget>[
//                     //     Icon(
//                     //       Icons.add,
//                     //       color: Colors.pink,
//                     //       size: 20,
//                     //     ),
//                     //     SizedBox(
//                     //       width: 2,
//                     //     ),
//                     //     Text(
//                     //       "Add New",
//                     //       style: TextStyle(
//                     //           fontSize: 14, fontWeight: FontWeight.bold),
//                     //     ),
//                     //   ],
//                     // ),
//                     // )
//                   ],
//                 ),
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.only(top: 16, left: 16, right: 16),
//               child: TextField(
//                 decoration: InputDecoration(
//                   hintText: "Search...",
//                   hintStyle: TextStyle(color: Colors.grey.shade600),
//                   prefixIcon: Icon(
//                     Icons.search,
//                     color: Colors.grey.shade600,
//                     size: 20,
//                   ),
//                   filled: true,
//                   fillColor: Colors.grey.shade100,
//                   contentPadding: EdgeInsets.all(8),
//                   enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(20),
//                       borderSide: BorderSide(color: Colors.grey.shade100)),
//                 ),
//               ),
//             ),
//             allUsers
//                 ? ListView.builder(
//                     itemCount: chatUsers.length,
//                     shrinkWrap: true,
//                     padding: EdgeInsets.only(top: 16),
//                     physics: NeverScrollableScrollPhysics(),
//                     itemBuilder: (context, index) {
//                       return ConversationList(
//                         name: chatUsers[index].name,
//                         userId: chatUsers[index].userId,
//                         messageText: chatUsers[index].messageText,
//                         imageUrl: chatUsers[index].imageURL,
//                         time: chatUsers[index].time,
//                         unreadMessages: 0,
//                       );
//                     },
//                   )
//                 : LoadingCircle()
//           ],
//         ),
//       ),
//     );
//   }
// }
