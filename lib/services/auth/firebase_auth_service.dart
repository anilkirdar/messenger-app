import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../bloc/user_view_model_bloc.dart';
import '../../models/user_model.dart';
import 'auth_service_base.dart';

class FirebaseAuthService implements AuthServiceBase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();

  @override
  Future<UserModel?> currentUser() async {
    try {
      User? currentUser = _firebaseAuth.currentUser;
      if (currentUser != null) {
        return UserModel(userID: currentUser.uid);
      } else {
        return null;
      }
    } catch (e) {
      // ignore: avoid_print
      print('FIREBASE currentUser SERVICE ERROR: $e');
      return null;
    }
  }

  @override
  Future<UserModel?> signAnonymously() async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInAnonymously();
      return UserModel(userID: userCredential.user!.uid);
    } catch (e) {
      // ignore: avoid_print
      print('FIREBASE signInAnonymously SERVICE ERROR: $e');
      return null;
    }
  }

  @override
  Future<bool?> signOut() async {
    try {
      if (_googleSignIn.currentUser != null) {
        await _googleSignIn.signOut();
      }
      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      // ignore: avoid_print
      print('FIREBASE signOut SERVICE ERROR: $e');
      return false;
    }
  }

  @override
  Future<UserModel?> signWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        UserCredential userCredential =
            await _firebaseAuth.signInWithCredential(credential);
        return UserModel(
            userID: userCredential.user!.uid,
            email: userCredential.user!.email!);
      } else {
        return null;
      }
    } catch (e) {
      // ignore: avoid_print
      print('FIREBASE signInWithGoogle SERVICE ERROR: $e');
      return null;
    }
  }

  @override
  Future<UserModel?> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return UserModel(
          userID: userCredential.user!.uid, email: userCredential.user!.email!);
    } on FirebaseAuthException catch (e) {
      UserViewModelBloc.errorCode = e.code.toLowerCase();
      // ignore: avoid_print
      print('FIREBASE signInWithEmail SERVICE ERROR: $e');
      return null;
    }
  }

  @override
  Future<UserModel?> signUpWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      return UserModel(
          userID: userCredential.user!.uid, email: userCredential.user!.email!);
    } on FirebaseAuthException catch (e) {
      UserViewModelBloc.errorCode = e.code.toLowerCase();
      // ignore: avoid_print
      print('FIREBASE signUpWithEmail SERVICE ERROR: ${e.code}');
      return null;
    }
  }
}
