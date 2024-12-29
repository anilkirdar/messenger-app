import 'package:flutter/material.dart';
import '../../models/chat_model.dart';
import '../../models/message_model.dart';
import '../../models/story_model.dart';
import '../../models/user_model.dart';

abstract class FirestoreDBServiceBase {
  Future<bool> saveUser({required UserModel? user, required String pass});

  Future<UserModel> readUser(String userID);

  Future<void> addDefaultStorySettingsToUser({required UserModel user});

  void setNull();

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
      {required String userID,
      required String? storyPhotoUrl,
      required String fileName});

  Future<List<StoryModel>> getStories(
      {required String userID,
      required int countOfWillBeFetchedStoryCount,
      required UserModel currentUser});

  Future<List<UserModel>> getUsers(
      {required UserModel currentUser,
      required UserModel user,
      required int countOfWillBeFetchedUserCount});

  Future<Stream<List<ChatModel>>> getChatListStream(
      {required String currentUserID,
      required int countOfWillBeFetchedChatCount});

  Future<List<MessageModel>> getMessages(
      {required String currentUserID,
      required String otherUserID,
      MessageModel? message,
      required int countOfWillBeFetchedMessageCount,
      required bool isInitFunction});

  Stream<List<MessageModel?>> messageListener(
      {required String currentUserID, required String otherUserID});

  Stream<List<dynamic>?> currentUserStoryListener(
      {required String currentUserID});

  Future<DateTime> fetchTime({required String userID});

  Future<bool?> saveChatMessage(
      {required MessageModel message,
      required UserModel currentUser,
      required UserModel otherUser,
      required ValueChanged<bool> resultCallBack});
}
