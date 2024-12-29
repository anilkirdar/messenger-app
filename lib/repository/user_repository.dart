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

  void setNull() {
    if (_appMode == AppMode.debug) {
      return;
    } else {
      return _firestoreService.setNull();
    }
  }

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

  Future<List<UserModel>> getUsers({
    required UserModel user,
    required int countOfWillBeFetchedUserCount,
    required UserModel currentUser,
  }) async {
    if (_appMode == AppMode.debug) {
      return [];
    } else {
      return await _firestoreService.getUsers(
        currentUser: currentUser,
        user: user,
        countOfWillBeFetchedUserCount: countOfWillBeFetchedUserCount,
      );
    }
  }

  Future<void> addStory(
      {required String userID, required XFile newStoryPhoto}) async {
    if (_appMode == AppMode.debug) {
      return;
    } else {
      String? storyPhotoUrl = await _firebaseStorageService.uploadFile(
        userID: userID,
        fileType: 'story-photos',
        file: newStoryPhoto,
        fileName: newStoryPhoto.name,
      );

      await _firestoreService.addStory(
        storyPhotoUrl: storyPhotoUrl,
        fileName: newStoryPhoto.name,
        userID: userID,
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

  Future<bool?> saveChatMessage(
      {required MessageModel message,
      required UserModel currentUser,
      required UserModel otherUser,
      required ValueChanged<bool> resultCallBack}) async {
    if (_appMode == AppMode.debug) {
      return null;
    } else {
      return await _firestoreService.saveChatMessage(
        message: message,
        resultCallBack: resultCallBack,
        currentUser: currentUser,
        otherUser: otherUser,
      );
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
      {required String userID, required XFile? newProfilePhoto}) async {
    if (_appMode == AppMode.debug) {
      return 'profile-photo-url';
    } else {
      String? newProfilePhotoURL = await _firebaseStorageService.uploadFile(
        userID: userID,
        fileType: 'profile-photo',
        fileName: 'profile-photo.png',
        file: newProfilePhoto!,
      );
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
      {required String currentUserID, required String otherUserID}) {
    if (_appMode == AppMode.debug) {
      return const Stream.empty();
    } else {
      return _firestoreService.messageListener(
        currentUserID: currentUserID,
        otherUserID: otherUserID,
      );
    }
  }

  Stream<dynamic> currentUserStoryListener({required String currentUserID}) {
    if (_appMode == AppMode.debug) {
      return const Stream.empty();
    } else {
      return _firestoreService.currentUserStoryListener(
          currentUserID: currentUserID);
    }
  }

  Future<Stream<List<ChatModel>>> getChatListStream(
      {required String currentUserID,
      required int countOfWillBeFetchedChatCount}) async {
    if (_appMode == AppMode.debug) {
      return Stream.empty();
    } else {
      return _firestoreService.getChatListStream(
        currentUserID: currentUserID,
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
      bool? result = await _firestoreService.saveUser(user: user);

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
        UserModel willReturnUser =
            await _firestoreService.readUser(user.userID);

        await _firestoreService.addDefaultStorySettingsToUser(
            user: willReturnUser);

        return willReturnUser;
      } else {
        return null;
      }
    }
  }

  Future<UserModel?> signUpWithEmail(String email, String pass) async {
    if (_appMode == AppMode.debug) {
      return await _fakeAuthService.signUpWithEmail(email, pass);
    } else {
      UserModel? user = await _firebaseAuthService.signUpWithEmail(email, pass);
      bool result = await _firestoreService.saveUser(user: user, pass: pass);

      if (result) {
        UserModel willReturnUser =
            await _firestoreService.readUser(user!.userID);

        await _firestoreService.addDefaultStorySettingsToUser(
            user: willReturnUser);

        return willReturnUser;
      } else {
        return null;
      }
    }
  }
}
