// import 'dart:convert';
// import 'dart:io';
//
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:time_tracker/app/models/chatMessageModel.dart';
// import 'package:time_tracker/app/services/api.dart';
// import 'package:time_tracker/app/services/chat-api.dart';
// import 'package:mqtt_client/mqtt_client.dart';
// import 'package:mqtt_client/mqtt_server_client.dart';
// import 'package:typed_data/src/typed_buffer.dart';
// import 'MQTTClientManager.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class ChatDetailPage extends StatefulWidget {
//   @override
//   String name;
//   String messageText = "";
//   String imageUrl = "";
//   String time = "";
//   String userId;
//   bool isMessageRead = false;
//
//   ChatDetailPage({
//     required this.name,
//     required this.userId,
//
//     // required this.messageText,
//     // required this.imageUrl,
//     // required this.time,
//     // required this.isMessageRead
//   });
//   _ChatDetailPageState createState() => _ChatDetailPageState();
// }
//
// class _ChatDetailPageState extends State<ChatDetailPage> {
//   // Future<void> getMessages() async {
//   //   //final storage = ChatStorage('mongodb://10.0.2.2:27017/time-tracker');
//   //   List<ChatMessage> chats =
//   //       await chatapi.findLastMessages(api.userID, widget.userId);
//
//   //   setState(() {
//   //     messages = chats;
//   //   });
//   // }
//   bool _isLoading = false;
//   bool _hasMore = true;
//   final int _limit = 10;
//   String _lastDocId = '';
//   List<ChatMessage> messages = [];
//   int _page = 1;
//   int _perPage = 10;
//   Future<void> _loadMessages(String senderId, String receiverId) async {
//     if (_hasMore && !_isLoading) {
//       setState(() {
//         _isLoading = true;
//       });
//       final filter = Uri.encodeComponent(
//           '{"_or":[{"_and":[{"sender":{"_eq":"${senderId}"}},{"recipient":{"_eq":"${receiverId}"}}]},{"_and":[{"sender":{"_eq":"${receiverId}"}},{"recipient":{"_eq":"${senderId}"}}]}]}');
//       final url = 'https://your-api-url.com/chats';
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       var dio = Dio();
//       (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
//         client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
//         return client;
//       };
//
//       dio.options.headers['Content-Type'] = 'application/json';
//       dio.options.headers['Authorization'] = 'Bearer ${prefs.getString('token')}';
//
//       try {
//         final response = await dio.get(
//           "https://ultimate.abuzeit.com/items/chats?filter=${filter}&page=${_page}&limit=14&sort=-date_created",
//         );
//
//         var server_json = jsonDecode(response.toString());
//         print(server_json);
//         if (server_json['data'].length == 0) {
//           return;
//         } else {
//           _page++;
//           List msgs = server_json['data'] as List;
//           if (msgs.length < _limit) {
//             _hasMore = false;
//           }
//
//           if (msgs.isNotEmpty) {
//             // _lastDocId = msgs.last['docId'] as String;
//             var chatMessages = msgs.toList().map((map) {
//               return ChatMessage(
//                 messageContent: map['message'] as String,
//                 messageType: map['sender'] == api.userID ? 'sender' : 'receiver',
//               );
//             }).toList();
//             setState(() {
//               messages.insertAll(messages.length, chatMessages);
//             });
//           }
//           setState(() {
//             _isLoading = false;
//           });
//         }
//
//         //    List last5Chats = server_json['data'] as List;
//
//         return;
//       } catch (error, stackTrace) {
//         print("errorrrr");
//         print(error);
//         print(stackTrace);
//         return;
//       }
//     }
//   }
//   // final response = await dio.get(url, queryParameters: {
//   //   'limit': _limit,
//   //   'lastDocId': _lastDocId,
//   // });
//
//   // final data = response.data;
//
//   // final messages = data['messages'];
//   // print("daaataaa");
//   // print(messages);
//   // if (messages.length < _limit) {
//   //   _hasMore = false;
//   // }
//   // if (messages.isNotEmpty) {
//   //   _lastDocId = messages.last['docId'] as String;
//   //   setState(() {
//   //     messages.insertAll(0, messages);
//   //   });
//   // }
//   // setState(() {
//   //   _isLoading = false;
//   // });
//
//   int _counter = 0;
//   Future<void> markRead() async {
//     final unreadChats = await chatapi.getUnreadChats(widget.userId, api.userID);
//     await chatapi.updateChatsStatus(unreadChats);
//   }
//
//   MQTTClientManager mqttClientManager = MQTTClientManager();
//   final String pubTopic = "abuzeit";
//   @override
//   void initState() {
//     setupMqttClient();
//     setupUpdatesListener();
//     _loadMessages(widget.userId, api.userID);
//     markRead();
//     getImage();
//     super.initState();
//   }
//
//   Future<void> setupMqttClient() async {
//     await mqttClientManager.connect();
//     mqttClientManager.subscribe(pubTopic);
//   }
//
//   void setupUpdatesListener() {
//     mqttClientManager.getMessagesStream()!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
//       final recMess = c![0].payload as MqttPublishMessage;
//       Map pt = json.decode(MqttPublishPayload.bytesToStringAsString(recMess.payload.message)) as Map;
//
//       var incoming = pt as Map;
//       String receiverId = incoming['recipient'] as String;
//       String message = incoming['message'] as String;
//       String senderId = incoming['sender'] as String;
//
//       if (senderId == widget.userId && receiverId == api.userID) {
//         setState(() {
//           messages.insert(0, ChatMessage(messageContent: message, messageType: "receiver"));
//         });
//       }
//       markRead();
//     });
//   }
//
//   @override
//   void dispose() {
//     mqttClientManager.disconnect();
//     super.dispose();
//   }
//
//   // Future<void> mongodb(Map<String, dynamic> message) async {
//   //   final storage = ChatStorage('mongodb://10.0.2.2:27017/time-tracker');
//
//   //   await storage.storeMessage(message);
//   // }
//   var avatar = "";
//   Future<void> getImage() async {
//     String pic = await chatapi.getUserImage(widget.userId) as String;
//
//     setState(() {
//       avatar = pic;
//     });
//   }
//
//   String message = "";
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Color.fromARGB(255, 24, 46, 59),
//         appBar: AppBar(
//           elevation: 0,
//           automaticallyImplyLeading: false,
//           backgroundColor: Colors.white,
//           flexibleSpace: SafeArea(
//             child: Container(
//               padding: EdgeInsets.only(right: 16),
//               child: Row(
//                 children: <Widget>[
//                   IconButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     icon: Icon(
//                       Icons.arrow_back,
//                       color: Colors.black,
//                     ),
//                   ),
//                   SizedBox(
//                     width: 2,
//                   ),
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
//                   SizedBox(
//                     width: 12,
//                   ),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         Text(
//                           widget.name,
//                           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//                         ),
//                         SizedBox(
//                           height: 6,
//                         ),
//                         Text(
//                           "Online",
//                           style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Icon(
//                     Icons.settings,
//                     color: Colors.black54,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         body: Column(
//           children: <Widget>[
//             Expanded(
//               child: NotificationListener<ScrollNotification>(
//                 onNotification: (ScrollNotification scrollInfo) {
//                   if (!_isLoading && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
//                     _loadMessages(widget.userId, api.userID);
//                   }
//                   return true;
//                 },
//                 child: ListView.builder(
//                   reverse: true,
//                   itemCount: messages.length,
//                   shrinkWrap: true,
//                   padding: EdgeInsets.only(top: 10, bottom: 10),
//                   itemBuilder: (context, index) {
//                     return Container(
//                       padding: EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
//                       child: Align(
//                         alignment: (messages[index].messageType == "receiver" ? Alignment.topLeft : Alignment.topRight),
//                         child: Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(20),
//                             color: (messages[index].messageType == "receiver" ? Colors.grey.shade200 : Colors.blue[200]),
//                           ),
//                           padding: EdgeInsets.all(16),
//                           child: Text(
//                             messages[index].messageContent,
//                             style: TextStyle(fontSize: 15),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//             Align(
//               alignment: Alignment.bottomLeft,
//               child: Container(
//                 padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
//                 height: 60,
//                 width: double.infinity,
//                 color: Colors.white,
//                 child: Row(
//                   children: <Widget>[
//                     GestureDetector(
//                       onTap: () {},
//                       child: Container(
//                         height: 30,
//                         width: 30,
//                         decoration: BoxDecoration(
//                           color: Color.fromARGB(255, 24, 46, 59),
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                         child: Icon(
//                           Icons.add,
//                           color: Color.fromARGB(255, 24, 46, 59),
//                           size: 20,
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       width: 15,
//                     ),
//                     Expanded(
//                       child: TextField(
//                         onChanged: (value) {
//                           message = value;
//                         },
//                         decoration:
//                             InputDecoration(hintText: "Write message...", hintStyle: TextStyle(color: Colors.black54), border: InputBorder.none),
//                       ),
//                     ),
//                     SizedBox(
//                       width: 15,
//                     ),
//                     FloatingActionButton(
//                       foregroundColor: Color.fromARGB(255, 24, 46, 59),
//                       onPressed: () {
//                         mqttClientManager.publishMessage(
//                             "abuzeit", json.encode({"recipient": widget.userId, "message": message, "sender": api.userID}));
//                         chatapi.send({"recipient": widget.userId, "message": message, "sender": api.userID, "status": "unread"});
//
//                         setState(() {
//                           messages.insert(0, ChatMessage(messageContent: message, messageType: "sender"));
//                         });
//                       },
//                       child: Icon(
//                         Icons.send,
//                         color: Colors.white,
//                         size: 18,
//                       ),
//                       backgroundColor: Color.fromARGB(255, 24, 46, 59),
//                       elevation: 0,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ));
//   }
// }
