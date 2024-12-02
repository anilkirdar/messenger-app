import 'package:cloud_firestore/cloud_firestore.dart';

import 'user_model.dart';

class MessageModel {
  final String? messageID;
  final UserModel fromWho;
  final UserModel toWho;
  String message;
  final bool isFromMe;
  final Timestamp? createdAt;
  final bool itBeenSeen;

  MessageModel(
      {this.messageID,
      required this.fromWho,
      required this.toWho,
      required this.message,
      this.itBeenSeen = false,
      this.isFromMe = true,
      this.createdAt});

  Map<String, dynamic> toMap() {
    return {
      'fromWho': fromWho.toMap(),
      'toWho': toWho.toMap(),
      'message': message,
      'isFromMe': isFromMe,
      'createdAt': createdAt,
      'itBeenSeen': itBeenSeen,
    };
  }

  MessageModel.fromMap(Map<String, dynamic> map)
      : messageID = map['messageID'],
        fromWho = UserModel.fromMap(map['fromWho']),
        toWho = UserModel.fromMap(map['toWho']),
        message = map['message'],
        isFromMe = map['isFromMe'],
        itBeenSeen = map['itBeenSeen'],
        createdAt = map['createdAt'];

  @override
  String toString() {
    return 'MessageModel(message: $message, createdAt: $createdAt)';
  }
}
