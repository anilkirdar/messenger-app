import 'package:flutter/material.dart';
import '../../models/chat_model.dart';
import '../../models/message_model.dart';
import '../../models/user_model.dart';

abstract class DBServiceBase {
  Future<bool> saveUser(UserModel user);

  Future<UserModel> readUser(String userID);

  Future<bool> updateUserName(
      {required String userID,
      required String newUserName,
      required ValueChanged<bool> resultCallBack});

  Future<bool> updateUserProfilePhoto({
    required String userID,
    required String? newProfilePhotoURL,
  });

  Future<List<UserModel>> getUsers(
      {required UserModel user, required int countOfWillBeFetchedUserCount});

  Future<List<ChatModel>> getChats({required UserModel currentUser});

  Future<List<MessageModel>> getMessages(
      {required String currentUserID,
      required String otherUserID,
      MessageModel? message,
      required int countOfWillBeFetchedMessageCount,
      required bool isInitFunction});

  // void activateMessageListener(
  //     {required String currentUserID,
  //     required String otherUserID,
  //     required BuildContext context});

  Stream<List<MessageModel?>> messageListener(
      {required String currentUserID, required String otherUserID});

  Future<DateTime> fetchMessageTime({required String userID});

  Future<bool> saveChatMessage(
      {required MessageModel message,
      required ValueChanged<bool> resultCallBack});
}
