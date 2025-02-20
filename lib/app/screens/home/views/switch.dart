import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SwitchExample extends StatefulWidget {
  @override
  _SwitchExampleState createState() => _SwitchExampleState();
}

class _SwitchExampleState extends State<SwitchExample> {
  bool isSwitched = false;

  Future<void> sendSwitchState(bool state) async {
    final url = Uri.parse("https://ultimate.abuzeit.com/items/time_tracker/"); // استبدل برابط الـ API الخاص بك

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"RemoteWork": state}),
      );

      if (response.statusCode == 200) {
        print("تم إرسال البيانات بنجاح!");
      } else {
        print("خطأ في الإرسال: ${response.statusCode}");
      }
    } catch (e) {
      print("حدث خطأ: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: isSwitched,
      onChanged: (bool value) {
        setState(() {
          isSwitched = value;
        });

        sendSwitchState(value); // إرسال النتيجة إلى API
      },
    );
  }
}
