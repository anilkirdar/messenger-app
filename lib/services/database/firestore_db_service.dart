import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/user_model.dart';
import 'database_service_base.dart';

class FirestoreDBService implements DBServiceBase {
  final FirebaseFirestore firestoreDB = FirebaseFirestore.instance;

  @override
  Future<bool> saveUser(UserModel user) async {
    try {
      await firestoreDB.collection('users').doc(user.userID).set(user.toMap());

      return true;
    } catch (e) {
      // ignore: avoid_print
      print('FIRESTOREDBSERVICE saveUser ERROR: $e');
      return false;
    }
  }

  @override
  Future<bool> updateUserName(
      {required String userID,
      required String newUserName,
      required ValueChanged<bool> resultCallBack}) async {
    try {
      QuerySnapshot<Map<String, dynamic>> users = await firestoreDB
          .collection('users')
          .where('userName', isEqualTo: newUserName)
          .get();

      if (users.docs.isEmpty) {
        await firestoreDB
            .collection('users')
            .doc(userID)
            .update({'userName': newUserName});

        resultCallBack(true);
        return true;
      } else {
        resultCallBack(false);
        return false;
      }
    } catch (e) {
      // ignore: avoid_print
      print('FIRESTOREDBSERVICE updateUserName ERROR: $e');
      return false;
    }
  }

  @override
  Future<bool> updateUserProfilePhoto(
      {required String userID, required String? newProfilePhotoURL}) async {
    try {
      if (newProfilePhotoURL != null) {
        await firestoreDB
            .collection('users')
            .doc(userID)
            .update({'profilePhotoURL': newProfilePhotoURL});

        return true;
      } else {
        return false;
      }
    } catch (e) {
      // ignore: avoid_print
      print('FIRESTOREDBSERVICE updateUserName ERROR: $e');
      return false;
    }
  }

  @override
  Future<UserModel> readUser(String userID) async {
    DocumentSnapshot userSnapshot =
        await firestoreDB.collection('users').doc(userID).get();
    Map<String, dynamic> userData =
        userSnapshot.data()! as Map<String, dynamic>;
    return UserModel.fromMap(userData);
  }
}
