import 'dart:convert';
import 'dart:io';
import 'package:dio/io.dart';
import 'package:time_tracker/app/models/chatMessageModel.dart';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api.dart';

// ignore: avoid_classes_with_only_static_members
class chatapi {
  static Future getUser(user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };

    dio.options.headers['Authorization'] = 'Bearer ${prefs.getString('token')}';
    final Response response = await dio.get('https://ultimate.abuzeit.com/users?filter[id][_eq]=${user}');

    var server_json = jsonDecode(response.toString());
    if (server_json['data'].length == 0) {
      return null;
    } else {
      print(server_json);
      String first_name = server_json['data'][0]['first_name'] as String;
      String last_name = server_json['data'][0]['last_name'] as String;
      String full_name = first_name + " " + last_name;
      return full_name;
    }
  }

  static Future getAllUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = await prefs.getString('userID') as String;

    var dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };

    dio.options.headers['Authorization'] = 'Bearer ${prefs.getString('token')}';
    var last_session;

    try {
      var response = await dio.get('https://ultimate.abuzeit.com/users');
      var server_json = response.data;

      if (server_json['data'].length == 0) {
        return null;
      } else {
        last_session = server_json['data'];
        return last_session;
      }
    } catch (error, stackTrace) {}
  }

  static Future<String?> send(Map payload) async {
    print("senddddd");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer ${prefs.getString('token')}';

    try {
      Response response = await dio.post('https://ultimate.abuzeit.com/items/chats/', data: payload);
      var server_json = jsonDecode(response.toString());
      print(server_json);
    } catch (error, stackTrace) {
      print("errorrrr");
      print(error);
      print(stackTrace);
    }
  }

  static Future<List<ChatMessage>> findLastMessages(String senderId, String receiverId) async {
    print("last 5 messages");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer ${prefs.getString('token')}';
    final filter = Uri.encodeComponent(
      '{"_or":[{"_and":[{"sender":{"_eq":"${senderId}"}},{"recipient":{"_eq":"${receiverId}"}}]},{"_and":[{"sender":{"_eq":"${receiverId}"}},{"recipient":{"_eq":"${senderId}"}}]}]}',
    );
    // final sort = Uri.encodeComponent(
    //     '[{"field":"date_created","direction":"DESC"}]'); // sort by user_created in descending order
    // final limit = 5;
    try {
      Response response = await dio.get('https://ultimate.abuzeit.com/items/chats?filter=${filter}&sort=-date_created&limit=5');
      var server_json = jsonDecode(response.toString());
      print(server_json);
      if (server_json['data'].length == 0) {
        return [];
      } else {
        List last5Chats = server_json['data'] as List;
        var chatMessages =
            last5Chats.reversed.toList().map((map) {
              return ChatMessage(messageContent: map['message'] as String, messageType: map['sender'] == api.userID ? 'sender' : 'receiver');
            }).toList();
        return chatMessages;
      }
    } catch (error, stackTrace) {
      print("errorrrr");
      print(error);
      print(stackTrace);
      return [];
    }
    // List last5Chats = await chats
    //     .find(where
    //         .eq("senderId", senderId)
    //         .and(where.eq("userId", receiverId))
    //         .sortBy('timestamp', descending: true)
    //         .limit(5))
    //     .toList();

    // var chatMessages = last5Chats.reversed.toList().map((map) {
    //   return ChatMessage(
    //     messageContent: map['message'] as String,
    //     messageType: map['senderId'] == api.userID ? 'sender' : 'receiver',
    //   );
    // }).toList();

    // return chatMessages;
  }

  static Future<List<String>> getDistinctSendersAndRecipients(String userId) async {
    print("distincttttt");
    final apiUrl = 'https://ultimate.abuzeit.com/items/chats';
    final filter = jsonEncode({
      "_or": [
        {
          "sender": {"_eq": userId},
        },
        {
          "recipient": {"_eq": userId},
        },
      ],
    });
    final headers = {'Content-Type': 'application/json'};
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer ${prefs.getString('token')}';
    Response response = await dio.get('https://ultimate.abuzeit.com/items/chats?filter=${filter}');
    if (response.statusCode != 200) {
      throw Exception('Failed to retrieve data from API');
    }

    final data = response.data;
    final chats = data['data'] as List<dynamic>;
    final senders = <String>{};
    final recipients = <String>{};

    for (final chat in chats) {
      final sender = chat['sender'] as String;
      final recipient = chat['recipient'] as String;

      if (sender == userId) {
        recipients.add(recipient);
      } else if (recipient == userId) {
        senders.add(sender);
      }
    }

    final distinctSendersAndRecipients = [...senders, ...recipients].toSet().toList();
    print("resulttt");
    print(distinctSendersAndRecipients);
    return distinctSendersAndRecipients;
  }

  static Future<List<dynamic>> getUnreadChats(String senderId, String recipientId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer ${prefs.getString('token')}';

    final response = await dio.get(
      'https://ultimate.abuzeit.com/items/chats',
      queryParameters: {
        'filter': json.encode({
          'status': {'_eq': 'unread'},
          'sender': {'_eq': senderId},
          'recipient': {'_eq': recipientId},
        }),
      },
    );

    if (response.statusCode == 200) {
      final data = response.data;
      final chats = data['data'] as List<dynamic>;
      return chats;
    } else {
      throw Exception('Failed to retrieve unread chats');
    }
  }

  static Future<int> getUnreadChatsNumber(String senderId, String recipientId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer ${prefs.getString('token')}';

    final response = await dio.get(
      'https://ultimate.abuzeit.com/items/chats',
      queryParameters: {
        'filter': json.encode({
          'status': {'_eq': 'unread'},
          'sender': {'_eq': senderId},
          'recipient': {'_eq': recipientId},
        }),
      },
    );

    if (response.statusCode == 200) {
      final data = response.data;
      final chats = data['data'] as List<dynamic>;
      return chats.length;
    } else {
      throw Exception('Failed to retrieve unread chats');
    }
  }

  static Future<void> updateChatsStatus(List<dynamic> chats) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer ${prefs.getString('token')}';
    dio.options.headers['Content-Type'] = 'application/json';

    for (dynamic chat in chats) {
      final response = await dio.patch('https://ultimate.abuzeit.com/items/chats/${chat['id']}', data: {"status": "read"});

      if (response.statusCode != 200) {
        throw Exception('Failed to update chat status');
      }
    }
  }

  static Future getUserImage(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer ${prefs.getString('token')}';
    String user;

    try {
      Response response = await dio.get('https://ultimate.abuzeit.com/users/${id}');
      // var server_json = jsonDecode(response.toString());
      Map server_json = jsonDecode(response.toString()) as Map;
      var image = server_json['data']['avatar'];
      return image;
    } catch (error, stackTrace) {
      return {};
    }
  }
  // static Future getUserImage(String id) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var dio = Dio();
  //   (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
  //       (HttpClient client) {
  //     client.badCertificateCallback =
  //         (X509Certificate cert, String host, int port) => true;
  //     return client;
  //   };
  //   dio.options.headers['Content-Type'] = 'application/json';
  //   dio.options.headers['Authorization'] = 'Bearer ${prefs.getString('token')}';
  //   String user;

  //   try {
  //     Response response =
  //         await dio.get('https://ultimate.abuzeit.com/users/me');
  //     // var server_json = jsonDecode(response.toString());
  //     Map server_json = jsonDecode(response.toString()) as Map;
  //     var image = server_json['data']['avatar'];
  //     return image;
  //   } catch (error, stackTrace) {
  //     return {};
  //   }
  // }
}
