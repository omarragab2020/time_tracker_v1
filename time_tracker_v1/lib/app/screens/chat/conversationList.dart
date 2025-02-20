// import 'package:flutter/material.dart';
// import 'chatPageDetail.dart';
// import 'package:time_tracker/app/services/chat-api.dart';
//
// class ConversationList extends StatefulWidget {
//   String name;
//   String messageText;
//   String imageUrl;
//   String time;
//   int unreadMessages;
//   String userId;
//   ConversationList(
//       {required this.name,
//       required this.userId,
//       required this.messageText,
//       required this.imageUrl,
//       required this.time,
//       required this.unreadMessages});
//
//   @override
//   _ConversationListState createState() => _ConversationListState();
// }
//
// class _ConversationListState extends State<ConversationList> {
//   var avatar = null;
//   Future<void> getImage() async {
//     var pic = await chatapi.getUserImage(widget.userId);
//
//     setState(() {
//       avatar = pic;
//     });
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     getImage();
//     super.initState();
//   }
//
//   //var imageurl = chatapi.getUserImage(widget.userId);
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(context, MaterialPageRoute(builder: (context) {
//           return ChatDetailPage(name: widget.name, userId: widget.userId);
//         }));
//       },
//       child: Container(
//         color: Color.fromARGB(255, 24, 46, 59),
//         padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
//         child: Row(
//           children: <Widget>[
//             Expanded(
//               child: Row(
//                 children: <Widget>[
//                   if (avatar == null)
//                     CircleAvatar(
//                       backgroundImage: AssetImage("assets/images/profile.webp"),
//                       radius: 40,
//                     )
//                   else
//                     CircleAvatar(
//                       radius: 40,
//                       backgroundColor: Color.fromARGB(255, 24, 46, 59),
//                       child: ClipOval(
//                         child: Image.network(
//                           'https://ultimate.abuzeit.com/assets/${avatar}',
//                           fit: BoxFit.fill,
//                         ),
//                       ),
//                     ),
//                   // CircleAvatar(
//                   //   backgroundImage: NetworkImage(widget.imageUrl),
//                   //   maxRadius: 30,
//                   // ),
//                   SizedBox(
//                     width: 16,
//                   ),
//                   Expanded(
//                     child: Container(
//                       color: Colors.transparent,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           Text(
//                             widget.name,
//                             style: TextStyle(fontSize: 16, color: Colors.white),
//                           ),
//                           SizedBox(
//                             height: 6,
//                           ),
//                           Text(
//                             widget.unreadMessages.toString() +
//                                 " unread messages",
//                             style: TextStyle(
//                               fontSize: 13,
//                               color: Colors.grey.shade600,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Text(
//               widget.time,
//               style: TextStyle(
//                 fontSize: 12,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
