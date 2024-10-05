// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

import 'user_model.dart';

class ChatModel {
  final UserModel currentUser;
  UserModel otherUser;
  final bool itBeenSeen;
  final String lastMessage;
  final String lastMessageFromWho;
  final Timestamp? createdAt;
  final Timestamp? seenAt;
  String? messageLastSeenAt;

  ChatModel({
    required this.currentUser,
    required this.otherUser,
    required this.itBeenSeen,
    required this.lastMessage,
    required this.lastMessageFromWho,
    this.createdAt,
    this.seenAt,
    this.messageLastSeenAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'currentUser': currentUser.toMap(),
      'otherUser': otherUser.toMap(),
      'itBeenSeen': itBeenSeen,
      'lastMessage': lastMessage,
      'lastMessageFromWho': lastMessageFromWho,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'seenAt': seenAt ?? FieldValue.serverTimestamp(),
      'messageLastSeenAt': messageLastSeenAt,
    };
  }

  ChatModel.fromMap(Map<String, dynamic> map)
      : currentUser = UserModel.fromMap(map['currentUser']),
        otherUser = UserModel.fromMap(map['otherUser']),
        itBeenSeen = map['itBeenSeen'],
        lastMessage = map['lastMessage'],
        lastMessageFromWho = map['lastMessageFromWho'],
        createdAt = map['createdAt'],
        seenAt = map['seenAt'],
        messageLastSeenAt = map['messageLastSeenAt'];

  @override
  String toString() {
    return 'ChatModel(currentUser: $currentUser, otherUser: $otherUser, itBeenSeen: $itBeenSeen, lastMessage: $lastMessage, lastMessageFromWho: $lastMessageFromWho, createdAt: $createdAt, seenAt: $seenAt, messageLastSeenAt: $messageLastSeenAt)';
  }
}
