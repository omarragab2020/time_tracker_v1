import 'package:time_tracker/app/models/chatMessageModel.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:time_tracker/app/services/api.dart';

class ChatStorage {
  final Db _db;

  ChatStorage(String dbUrl) : _db = Db(dbUrl);

  Future<void> storeMessage(Map<String, dynamic> message) async {
    await _db.open();
    var coll = _db.collection('chats');
    await coll.insert(message);
    await _db.close();
  }

  Future findLastMessages(String senderId, String receiverId) async {
    await _db.open();

    var sort = {'timestamp': 1};
    var chats = await _db.collection('chats');
    List last5Chats = await chats
        .find(where
            .eq("senderId", senderId)
            .and(where.eq("userId", receiverId))
            .sortBy('timestamp', descending: true)
            .limit(5))
        .toList();

    var chatMessages = last5Chats.reversed.toList().map((map) {
      return ChatMessage(
        messageContent: map['message'] as String,
        messageType: map['senderId'] == api.userID ? 'sender' : 'receiver',
      );
    }).toList();

    return chatMessages;
  }

  Future<List<String>> getDistinctSenderAndRecipient(String userId) async {
    await _db.open();
    var records = await _db.collection('chats');

    final pipeline = [
      {
        '\$match': {
          '\$or': [
            {'sender': userId},
            {'recipient': userId}
          ]
        }
      },
      {
        '\$group': {
          '_id': null,
          'senders': {'\$addToSet': '\$sender'},
          'recipients': {'\$addToSet': '\$recipient'}
        }
      }
    ];

    final result = await records.aggregateToStream(pipeline).first;
    final senders = result['senders'] as List;
    final recipients = result['recipients'] as List;
    final combined = [...senders, ...recipients];
    final distinct =
        Set<String>.from(combined).where((e) => e != userId).toList();

    await _db.close();
    return distinct;
  }
}
