import '../locator.dart';
import '../models/user_model.dart';
import '../services/auth_base.dart';
import '../services/fake_auth_service.dart';
import '../services/firebase_auth_service.dart';
import '../services/firestore_db_service.dart';

enum AppMode { debug, release }

class UserRepository implements AuthBase {
  AppMode appMode = AppMode.release;
  FirebaseAuthService firebaseAuthService = locator<FirebaseAuthService>();
  FakeAuthService fakeAuthService = locator<FakeAuthService>();
  FirestoreDBService firestoreService = locator<FirestoreDBService>();

  @override
  Future<UserModel?> currentUser() async {
    if (appMode == AppMode.debug) {
      return await fakeAuthService.currentUser();
    } else {
      UserModel? user = await firebaseAuthService.currentUser();

      if (user != null) {
        return await firestoreService.readUser(user.userId);
      } else {
        return null;
      }
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
        return await firestoreService.readUser(user.userId);
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
      return await firestoreService.readUser(user!.userId);
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
        return await firestoreService.readUser(user.userId);
      } else {
        return null;
      }
    }
  }
}
