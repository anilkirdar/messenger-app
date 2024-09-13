import 'package:flutter/material.dart';

import '../../models/user_model.dart';

abstract class DBServiceBase {
  Future<bool> saveUser(UserModel user);
  Future<UserModel> readUser(String userID);
  Future<bool> updateUserName(
      {required String userID,
      required String newUserName,
      required ValueChanged<bool> resultCallBack});
  Future<bool> updateUserProfilePhoto(
      {required String userID, required String? newProfilePhotoURL});
}
