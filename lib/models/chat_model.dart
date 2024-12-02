import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_model.dart';

class ChatModel {
  final UserModel fromWho;
  final UserModel toWho;
  String lastMessage;
  final String lastMessageFromWho;
  final Timestamp? createdAt;
  String? messageLastSeenAt;

  ChatModel({
    required this.fromWho,
    required this.toWho,
    required this.lastMessage,
    required this.lastMessageFromWho,
    this.createdAt,
    this.messageLastSeenAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'fromWho': fromWho.toMap(),
      'toWho': toWho.toMap(),
      'lastMessage': lastMessage,
      'lastMessageFromWho': lastMessageFromWho,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'messageLastSeenAt': messageLastSeenAt,
    };
  }

  ChatModel.fromMap(Map<String, dynamic> map)
      : fromWho = UserModel.fromMap(map['fromWho']),
        toWho = UserModel.fromMap(map['toWho']),
        lastMessage = map['lastMessage'],
        lastMessageFromWho = map['lastMessageFromWho'],
        createdAt = map['createdAt'],
        messageLastSeenAt = map['messageLastSeenAt'];
}
