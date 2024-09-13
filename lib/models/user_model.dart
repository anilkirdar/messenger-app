import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userID;
  String email;
  String? userName;
  String? profilePhotoURL;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? level;

  UserModel({required this.userID, this.email = ''});

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'email': email,
      'userName': userName ??
          email.substring(0, email.indexOf('@')) +
              randomNumCreator().toString(),
      'profilePhotoURL':
          profilePhotoURL ?? 'https://emrealtunbilek.com/wp-content/uploads/2016/10/apple-icon-72x72.png',
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': updatedAt ?? FieldValue.serverTimestamp(),
      'level': level ?? 1,
    };
  }

  UserModel.fromMap(Map<String, dynamic> map)
      : userID = map['userID'],
        email = map['email'],
        userName = map['userName'],
        profilePhotoURL = map['profilePhotoURL'],
        createdAt = (map['createdAt'] as Timestamp).toDate(),
        updatedAt = (map['updatedAt'] as Timestamp).toDate(),
        level = map['level'];

  int randomNumCreator() {
    int randomInt = Random().nextInt(99999);
    return randomInt;
  }
}
