import 'style.dart';
import 'constant.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 23, 25, 54),
      body: ListView(
        children: [customAppBar(context), header(), chatArea(context)],
      ),
    );
  }

  Container chatArea(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(30)),
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height - 300,
              padding: const EdgeInsets.only(
                top: 5,
                left: 20,
                right: 20,
              ),
              child: ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) =>
                      messages[index]['from'] == 'sender'
                          ? sender(
                              messages[index]['message']!,
                              messages[index]['time']!,
                              messages[index]['date']!)
                          : receiver(
                              messages[index]['message']!,
                              messages[index]['time']!,
                              messages[index]['date']!)),
            ),
            Container(
              padding: const EdgeInsets.only(top: 40),
              child: TextField(
                decoration: InputDecoration(
                  fillColor: Colors.grey[200],
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 25,
                  ),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RawMaterialButton(
                      constraints: const BoxConstraints(minWidth: 0),
                      onPressed: () {},
                      elevation: 2.0,
                      fillColor: const Color.fromARGB(255, 23, 25, 54),
                      padding: const EdgeInsets.all(10.0),
                      shape: const CircleBorder(),
                      child: const Icon(Icons.send,
                          size: 22.0, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  Padding header() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Avatar(avatarUrl: 'assets/avatar-1.png', width: 40, height: 40),
          const PrimaryText(
            text: 'Abu zeit Chat',
            fontSize: 25,
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RawMaterialButton(
                constraints: const BoxConstraints(minWidth: 0),
                onPressed: () {},
                elevation: 2.0,
                fillColor: Colors.white38,
                padding: const EdgeInsets.all(10.0),
                shape: const CircleBorder(),
                child: const Icon(Icons.call, size: 24.0, color: Colors.white),
              ),
              const SizedBox(width: 10),
              RawMaterialButton(
                constraints: const BoxConstraints(minWidth: 0),
                onPressed: () {},
                elevation: 2.0,
                fillColor: Colors.white38,
                padding: const EdgeInsets.all(10.0),
                shape: const CircleBorder(),
                child: const Icon(Icons.video_call,
                    size: 24.0, color: Colors.white),
              )
            ],
          )
        ],
      ),
    );
  }

  Padding customAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
              child: const PrimaryText(text: 'Back', color: Colors.white54),
              onPressed: () => {Navigator.pop(context)}),
        ],
      ),
    );
  }

  Widget sender(String message, String time, String date) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Row(
        // mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: PrimaryText(text: time, color: Colors.grey, fontSize: 14),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: PrimaryText(text: date, color: Colors.grey, fontSize: 14),
          ),
          Container(
            constraints: const BoxConstraints(minWidth: 100, maxWidth: 280),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: const BoxDecoration(
                color: Color.fromARGB(255, 23, 25, 54),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(0))),
            child: PrimaryText(
              text: message,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget receiver(String message, String time, String date) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Avatar(
                  avatarUrl: 'assets/avatar-1.png', width: 30, height: 30),
              Container(
                constraints: const BoxConstraints(minWidth: 100, maxWidth: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                    color: Colors.blueGrey[50],
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(25))),
                child: PrimaryText(
                  text: message,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: PrimaryText(text: time, color: Colors.grey, fontSize: 14),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: PrimaryText(text: date, color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
