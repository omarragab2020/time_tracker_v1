import 'package:flutter/cupertino.dart';

class ChatUsers {
  String name;
  String messageText = "";
  String imageURL = "";
  String time = "";
  String userId;
  int unreadMessages;
  ChatUsers(
      {required this.name, required this.userId, this.unreadMessages = 0});
}
