import 'package:cloud_firestore/cloud_firestore.dart';

import 'user_model.dart';

class MessageModel {
  final String? messageID;
  final UserModel fromWho;
  final UserModel toWho;
  final String message;
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
    return message;
  }

  // @override
  // String toString() {
  //   return 'MessageModel(fromWho: $fromWho, toWho: $toWho, message: $message, isFromMe: $isFromMe, createdAt: $createdAt)';
  // }
}
