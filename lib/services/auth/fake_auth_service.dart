import '../../models/user_model.dart';
import 'auth_service_base.dart';

class FakeAuthService implements AuthServiceBase {
  final String _userID = '123123';
  final String _email = 'fakemail@gmail.com';

  @override
  Future<UserModel?> currentUser() async {
    return Future.value(UserModel(userID: _userID, email: _email));
  }

  @override
  Future<UserModel?> signAnonymously() async {
    return Future.value(UserModel(userID: _userID, email: _email));
  }

  @override
  Future<bool> signOut() async {
    return Future.value(true);
  }

  @override
  Future<UserModel?> signWithGoogle() async {
    return Future.value(UserModel(userID: 'google_user_id_123', email: _email));
  }

  @override
  Future<UserModel?> signInWithEmail(String email, String password) async {
    return Future.value(
        UserModel(userID: 'loggedin_user_id_123', email: _email));
  }

  @override
  Future<UserModel?> signUpWithEmail(String email, String password) async {
    return Future.value(
        UserModel(userID: 'created_user_id_123', email: _email));
  }
}
