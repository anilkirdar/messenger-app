import 'package:get_it/get_it.dart';

import 'repository/user_repository.dart';
import 'services/fake_auth_service.dart';
import 'services/firebase_auth_service.dart';
import 'services/firestore_db_service.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => FakeAuthService());
  locator.registerLazySingleton(() => FirestoreDBService());
  locator.registerLazySingleton(() => UserRepository());
}
