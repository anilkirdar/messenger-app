// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

import 'user_model.dart';

class MessageModel {
  final String? messageID;
  final UserModel fromWho;
  final UserModel toWho;
  String message;
  final bool isFromMe;
  final Timestamp? createdAt;

  MessageModel(
      {this.messageID,
      required this.fromWho,
      required this.toWho,
      required this.message,
      required this.isFromMe,
      this.createdAt});

  Map<String, dynamic> toMap() {
    return {
      'fromWho': fromWho.toMap(),
      'toWho': toWho.toMap(),
      'message': message,
      'isFromMe': isFromMe,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  MessageModel.fromMap(Map<String, dynamic> map)
      : messageID = map['messageID'],
        fromWho = UserModel.fromMap(map['fromWho']),
        toWho = UserModel.fromMap(map['toWho']),
        message = map['message'],
        isFromMe = map['isFromMe'],
        createdAt = map['createdAt'];

  @override
  String toString() {
    return 'MessageModel(messageID: $messageID, fromWho: $fromWho, toWho: $toWho, message: $message, isFromMe: $isFromMe, createdAt: $createdAt)';
  }
}
