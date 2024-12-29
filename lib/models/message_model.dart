import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String? messageID;
  String message;
  bool isFromMe;
  Timestamp? createdAt;
  bool itBeenSeen;

  MessageModel(
      {this.messageID,
      required this.message,
      this.itBeenSeen = false,
      this.isFromMe = true,
      this.createdAt});

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'isFromMe': isFromMe,
      'createdAt': createdAt,
      'itBeenSeen': itBeenSeen,
    };
  }

  MessageModel.fromMap(Map<String, dynamic> map)
      : messageID = map['messageID'],
        message = map['message'],
        isFromMe = map['isFromMe'],
        itBeenSeen = map['itBeenSeen'],
        createdAt = map['createdAt'];

  @override
  String toString() {
    return 'MessageModel(message: $message, createdAt: $createdAt)';
  }
}
