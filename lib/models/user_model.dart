import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userId;
  String email;
  String? userName;
  String? profilURL;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? level;

  UserModel({required this.userId, this.email = ''});

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'email': email,
      'userName': userName ??
          email.substring(0, email.indexOf('@')) +
              randomNumCreator().toString(),
      'profilURL': profilURL ?? '',
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': updatedAt ?? FieldValue.serverTimestamp(),
      'level': level ?? 1,
    };
  }

  UserModel.fromMap(Map<String, dynamic> map)
      : userId = map['userId'],
        email = map['email'],
        userName = map['userName'],
        profilURL = map['profilURL'],
        createdAt = (map['createdAt'] as Timestamp).toDate(),
        updatedAt = (map['updatedAt'] as Timestamp).toDate(),
        level = map['level'];

  int randomNumCreator() {
    int randomInt = Random().nextInt(99999);
    return randomInt;
  }
}
