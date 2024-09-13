import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../locator.dart';
import '../models/user_model.dart';
import '../services/auth/auth_service_base.dart';
import '../services/auth/fake_auth_service.dart';
import '../services/auth/firebase_auth_service.dart';
import '../services/database/firestore_db_service.dart';
import '../services/storage/firebase_storage_service.dart';

enum AppMode { debug, release }

class UserRepository implements AuthServiceBase {
  AppMode appMode = AppMode.release;
  FirebaseAuthService firebaseAuthService = locator<FirebaseAuthService>();
  FakeAuthService fakeAuthService = locator<FakeAuthService>();
  FirestoreDBService firestoreService = locator<FirestoreDBService>();
  FirebaseStorageService firebaseStorageService =
      locator<FirebaseStorageService>();

  @override
  Future<UserModel?> currentUser() async {
    if (appMode == AppMode.debug) {
      return await fakeAuthService.currentUser();
    } else {
      UserModel? user = await firebaseAuthService.currentUser();

      if (user != null) {
        return await firestoreService.readUser(user.userID);
      } else {
        return null;
      }
    }
  }

  Future<bool?> updateUserName(
      {required String userID,
      required String newUserName,
      required ValueChanged<bool> resultCallBack}) async {
    if (appMode == AppMode.debug) {
      return false;
    } else {
      return await firestoreService.updateUserName(
        userID: userID,
        newUserName: newUserName,
        resultCallBack: resultCallBack,
      );
    }
  }

  Future<String?> updateUserProfilePhoto(
      {required String userID,
      required String fileType,
      required XFile? newProfilePhoto}) async {
    if (appMode == AppMode.debug) {
      return 'profile-photo-url';
    } else {
      String? newProfilePhotoURL = await firebaseStorageService.uploadFile(
          userID, fileType, newProfilePhoto!);
      await firestoreService.updateUserProfilePhoto(
          userID: userID, newProfilePhotoURL: newProfilePhotoURL);

      return newProfilePhotoURL;
    }
  }

  @override
  Future<UserModel?> signAnonymously() async {
    if (appMode == AppMode.debug) {
      return await fakeAuthService.signAnonymously();
    } else {
      return await firebaseAuthService.signAnonymously();
    }
  }

  @override
  Future<bool?> signOut() async {
    if (appMode == AppMode.debug) {
      return await fakeAuthService.signOut();
    } else {
      return await firebaseAuthService.signOut();
    }
  }

  @override
  Future<UserModel?> signWithGoogle() async {
    if (appMode == AppMode.debug) {
      return await fakeAuthService.signWithGoogle();
    } else {
      UserModel? user = await firebaseAuthService.signWithGoogle();
      bool result = await firestoreService.saveUser(user!);

      if (result) {
        return await firestoreService.readUser(user.userID);
      } else {
        return null;
      }
    }
  }

  @override
  Future<UserModel?> signInWithEmail(String email, String password) async {
    if (appMode == AppMode.debug) {
      return await fakeAuthService.signInWithEmail(email, password);
    } else {
      UserModel? user =
          await firebaseAuthService.signInWithEmail(email, password);
      return await firestoreService.readUser(user!.userID);
    }
  }

  @override
  Future<UserModel?> signUpWithEmail(String email, String password) async {
    if (appMode == AppMode.debug) {
      return await fakeAuthService.signUpWithEmail(email, password);
    } else {
      UserModel? user =
          await firebaseAuthService.signUpWithEmail(email, password);
      bool result = await firestoreService.saveUser(user!);

      if (result) {
        return await firestoreService.readUser(user.userID);
      } else {
        return null;
      }
    }
  }
}
