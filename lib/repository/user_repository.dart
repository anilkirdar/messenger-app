import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../locator.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';
import '../models/story_model.dart';
import '../models/user_model.dart';
import '../services/auth/fake_auth_service.dart';
import '../services/auth/firebase_auth_service.dart';
import '../services/database/firestore_db_service.dart';
import '../services/storage/firebase_storage_service.dart';

enum AppMode { debug, release }

class UserRepository {
  final AppMode _appMode = AppMode.release;
  final FirebaseAuthService _firebaseAuthService =
      locator<FirebaseAuthService>();
  final FakeAuthService _fakeAuthService = locator<FakeAuthService>();
  final FirestoreDBService _firestoreService = locator<FirestoreDBService>();
  final FirebaseStorageService _firebaseStorageService =
      locator<FirebaseStorageService>();

  Future<UserModel?> currentUser() async {
    if (_appMode == AppMode.debug) {
      return await _fakeAuthService.currentUser();
    } else {
      UserModel? user = await _firebaseAuthService.currentUser();

      if (user != null) {
        return await _firestoreService.readUser(user.userID);
      } else {
        return null;
      }
    }
  }

  Future<List<UserModel>> getUsers(
      {required UserModel user,
      required int countOfWillBeFetchedUserCount}) async {
    if (_appMode == AppMode.debug) {
      return [];
    } else {
      return await _firestoreService.getUsers(
        user: user,
        countOfWillBeFetchedUserCount: countOfWillBeFetchedUserCount,
      );
    }
  }

  Future<void> addStory(
      {required String storyPhotoUrl, required String userID, required ValueChanged<bool> resultCallBack}) async {
    if (_appMode == AppMode.debug) {
      return;
    } else {
      await _firestoreService.addStory(
        storyPhotoUrl: storyPhotoUrl,
        userID: userID,
        resultCallBack: resultCallBack,
      );
    }
  }

  Future<List<StoryModel>> getStories(
      {required String userID,
      required int countOfWillBeFetchedStoryCount,
      required UserModel currentUser}) async {
    if (_appMode == AppMode.debug) {
      return [];
    } else {
      return await _firestoreService.getStories(
        userID: userID,
        countOfWillBeFetchedStoryCount: countOfWillBeFetchedStoryCount,
        currentUser: currentUser,
      );
    }
  }

  Future<bool> saveChatMessage(
      {required MessageModel message,
      required ValueChanged<bool> resultCallBack}) async {
    if (_appMode == AppMode.debug) {
      return false;
    } else {
      return await _firestoreService.saveChatMessage(
          message: message, resultCallBack: resultCallBack);
    }
  }

  Future<bool?> updateUserName(
      {required String userID,
      required String newUserName,
      required ValueChanged<bool> resultCallBack}) async {
    if (_appMode == AppMode.debug) {
      return false;
    } else {
      return await _firestoreService.updateUserName(
        userID: userID,
        newUserName: newUserName,
        resultCallBack: resultCallBack,
      );
    }
  }

  Future<void> updateUserPass(
      {required String userID, required String newPass}) async {
    if (_appMode == AppMode.debug) {
      return;
    } else {
      await _firestoreService.updateUserPass(
        userID: userID,
        newPass: newPass,
      );
    }
  }

  Future<bool> deleteUser({required UserModel currentUser}) async {
    if (_appMode == AppMode.debug) {
      return true;
    } else {
      return await _firestoreService.deleteUser(currentUser: currentUser);
    }
  }

  Future<String?> updateUserProfilePhoto(
      {required String userID,
      required String fileType,
      required XFile? newProfilePhoto}) async {
    if (_appMode == AppMode.debug) {
      return 'profile-photo-url';
    } else {
      String? newProfilePhotoURL = await _firebaseStorageService.uploadFile(
          userID, fileType, newProfilePhoto!);
      await _firestoreService.updateUserProfilePhoto(
          userID: userID, newProfilePhotoURL: newProfilePhotoURL);

      return newProfilePhotoURL;
    }
  }

  Future<List<MessageModel>> getMessages(
      {required String currentUserID,
      required String otherUserID,
      MessageModel? message,
      required int countOfWillBeFetchedMessageCount,
      required bool isInitFunction}) async {
    if (_appMode == AppMode.debug) {
      return [];
    } else {
      return _firestoreService.getMessages(
          currentUserID: currentUserID,
          otherUserID: otherUserID,
          message: message,
          countOfWillBeFetchedMessageCount: countOfWillBeFetchedMessageCount,
          isInitFunction: isInitFunction);
    }
  }

  Stream<List<MessageModel?>> messageListener(
      {required String currentUserID,
      required String otherUserID,
      required BuildContext context}) {
    if (_appMode == AppMode.debug) {
      return const Stream.empty();
    } else {
      return _firestoreService.messageListener(
        currentUserID: currentUserID,
        otherUserID: otherUserID,
      );
    }
  }

  Future<Stream<List<ChatModel>>> getChats(
      {required UserModel currentUser,
      required int countOfWillBeFetchedChatCount}) async {
    if (_appMode == AppMode.debug) {
      return Stream.empty();
    } else {
      return _firestoreService.getChats(
        currentUser: currentUser,
        countOfWillBeFetchedChatCount: countOfWillBeFetchedChatCount,
      );
    }
  }

  Future<UserModel?> signAnonymously() async {
    if (_appMode == AppMode.debug) {
      return await _fakeAuthService.signAnonymously();
    } else {
      return await _firebaseAuthService.signAnonymously();
    }
  }

  Future<bool?> signOut() async {
    if (_appMode == AppMode.debug) {
      return await _fakeAuthService.signOut();
    } else {
      return await _firebaseAuthService.signOut();
    }
  }

  Future<UserModel?> signWithGoogle() async {
    if (_appMode == AppMode.debug) {
      return await _fakeAuthService.signWithGoogle();
    } else {
      UserModel? user = await _firebaseAuthService.signWithGoogle();
      bool? result = await _firestoreService.saveUser(user);

      if (result) {
        return await _firestoreService.readUser(user!.userID);
      } else {
        return null;
      }
    }
  }

  Future<UserModel?> signInWithEmail(String email, String password) async {
    if (_appMode == AppMode.debug) {
      return await _fakeAuthService.signInWithEmail(email, password);
    } else {
      UserModel? user =
          await _firebaseAuthService.signInWithEmail(email, password);

      if (user != null) {
        return await _firestoreService.readUser(user.userID);
      } else {
        return null;
      }
    }
  }

  Future<UserModel?> signUpWithEmail(String email, String password) async {
    if (_appMode == AppMode.debug) {
      return await _fakeAuthService.signUpWithEmail(email, password);
    } else {
      UserModel? user =
          await _firebaseAuthService.signUpWithEmail(email, password);
      bool result = await _firestoreService.saveUser(user);

      if (result) {
        return await _firestoreService.readUser(user!.userID);
      } else {
        return null;
      }
    }
  }
}
