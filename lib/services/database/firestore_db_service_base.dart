import 'package:flutter/material.dart';
import '../../models/chat_model.dart';
import '../../models/message_model.dart';
import '../../models/story_model.dart';
import '../../models/user_model.dart';

abstract class FirestoreDBServiceBase {
  Future<bool> saveUser(UserModel user);

  Future<UserModel> readUser(String userID);

  Future<bool> updateUserName(
      {required String userID,
      required String newUserName,
      required ValueChanged<bool> resultCallBack});

  Future<void> updateUserPass(
      {required String userID, required String newPass});

  Future<bool> deleteUser({required UserModel currentUser});

  Future<bool> updateUserProfilePhoto({
    required String userID,
    required String? newProfilePhotoURL,
  });

  Future<void> addStory(
      {required String userID, required String storyPhotoUrl, required ValueChanged<bool> resultCallBack});

  Future<List<StoryModel>> getStories(
      {required String userID,
      required int countOfWillBeFetchedStoryCount,
      required UserModel currentUser});

  Future<List<UserModel>> getUsers(
      {required UserModel user, required int countOfWillBeFetchedUserCount});

  Future<Stream<List<ChatModel>>> getChats(
      {required UserModel currentUser,
      required int countOfWillBeFetchedChatCount});

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
