import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userID;
  String email;
  String? userName;
  String? profilePhotoURL;
  Timestamp? createdAt;
  Timestamp? updatedAt;
  int? level;

  UserModel({required this.userID, this.email = ''});

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'email': email,
      'userName': userName ??
          email.substring(0, email.indexOf('@')) +
              randomNumCreator().toString(),
      'profilePhotoURL': profilePhotoURL ??
          'https://firebasestorage.googleapis.com/v0/b/messenger-app-8556c.appspot.com/o/blank-profile-picture.png?alt=media&token=c80dcaf1-63ed-43ba-9bf0-fba3e9800501',
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
        createdAt = map['createdAt'],
        updatedAt = map['updatedAt'],
        level = map['level'];

  int randomNumCreator() {
    int randomInt = Random().nextInt(99999);
    return randomInt;
  }

  @override
  int get hashCode => userID.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is UserModel) {
      return userID == other.userID;
    }
    return false;
  }

  @override
  String toString() {
    return userName.toString();
  }

  // @override
  // String toString() {
  //   return 'UserModel(userID: $userID, email: $email, userName: $userName, profilePhotoURL: $profilePhotoURL, createdAt: $createdAt, updatedAt: $updatedAt, level: $level)';
  // }
}
