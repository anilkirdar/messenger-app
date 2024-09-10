import '../models/user_model.dart';
import 'auth_base.dart';

class FakeAuthService implements AuthBase {
  String userId = '123123';
  String email = 'fakemail@gmail.com';

  @override
  Future<UserModel?> currentUser() async {
    return Future.value(UserModel(userId: userId, email: email));
  }

  @override
  Future<UserModel?> signAnonymously() async {
    return Future.value(UserModel(userId: userId, email: email));
  }

  @override
  Future<bool> signOut() async {
    return Future.value(true);
  }

  @override
  Future<UserModel?> signWithGoogle() async {
    return Future.value(UserModel(userId: 'google_user_id_123', email: email));
  }

  @override
  Future<UserModel?> signInWithEmail(String email, String password) async {
    return Future.value(UserModel(userId: 'loggedin_user_id_123', email: email));
  }

  @override
  Future<UserModel?> signUpWithEmail(String email, String password) async {
    return Future.value(UserModel(userId: 'created_user_id_123', email: email));
  }
}