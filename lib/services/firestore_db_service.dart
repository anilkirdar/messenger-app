import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';
import 'database_base.dart';

class FirestoreDBService implements DBBase {
  final FirebaseFirestore firestoreAuth = FirebaseFirestore.instance;

  @override
  Future<bool> saveUser(UserModel user) async {
    try {
      await firestoreAuth
          .collection('users')
          .doc(user.userId)
          .set(user.toMap());

      // DocumentSnapshot fetchedUser =
      //     await firestoreAuth.collection('users').doc(user.userId).get();
      // Object? fetchedUserData = fetchedUser.data();
      // print(UserModel.fromMap(fetchedUserData as Map<String, dynamic>)
      //     .toString());

      return true;
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
      return false;
    }
  }

  @override
  Future<UserModel> readUser(String userID) async {
    DocumentSnapshot userSnapshot =
        await firestoreAuth.collection('users').doc(userID).get();
    Map<String, dynamic> userData =
        userSnapshot.data()! as Map<String, dynamic>;
    return UserModel.fromMap(userData);
  }
}
