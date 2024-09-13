import '../../models/user_model.dart';

abstract class AuthServiceBase {
  Future<UserModel?> currentUser();
  Future<UserModel?> signAnonymously();
  Future<bool?> signOut();
  Future<UserModel?> signWithGoogle();
  Future<UserModel?> signUpWithEmail(
      String email, String password);
  Future<UserModel?> signInWithEmail(String email, String password);
}
