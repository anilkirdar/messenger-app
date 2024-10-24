// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class StoryModel {
  final String userID;
  final String userName;
  final String profilePhotoURL;
  final List? storyPhotoUrlList;
  final Timestamp? createdAt;

  StoryModel({
    required this.userID,
    required this.userName,
    required this.profilePhotoURL,
    this.storyPhotoUrlList,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'userName': userName,
      'profilePhotoURL': profilePhotoURL,
      'storyPhotoUrlList': storyPhotoUrlList ?? [],
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  StoryModel.fromMap(Map<String, dynamic> map)
      : userID = map['userID'],
        userName = map['userName'],
        profilePhotoURL = map['profilePhotoURL'],
        storyPhotoUrlList = map['storyPhotoUrlList'],
        createdAt = map['createdAt'];

  @override
  String toString() {
    return 'StoryModel(userName: $userName)';
  }
}
