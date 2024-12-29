// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'message_model.dart';
import 'user_model.dart';

class ChatModel {
  final UserModel fromWho;
  final UserModel toWho;
  MessageModel lastMessage;
  String lastMessageFromWho;
  String? lastMessageSentAt;

  ChatModel({
    required this.fromWho,
    required this.toWho,
    required this.lastMessage,
    required this.lastMessageFromWho,
    this.lastMessageSentAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'fromWho': fromWho.toMap(),
      'toWho': toWho.toMap(),
      'lastMessage': lastMessage.toMap(),
      'lastMessageFromWho': lastMessageFromWho,
      'messageLastSeenAt': lastMessageSentAt,
    };
  }

  ChatModel.fromMap(Map<String, dynamic> map)
      : fromWho = UserModel.fromMap(map['fromWho']),
        toWho = UserModel.fromMap(map['toWho']),
        lastMessage = MessageModel.fromMap(map['lastMessage']),
        lastMessageFromWho = map['lastMessageFromWho'],
        lastMessageSentAt = map['messageLastSeenAt'];
}
