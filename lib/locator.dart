import 'package:get_it/get_it.dart';

import 'repository/user_repository.dart';
import 'services/auth/fake_auth_service.dart';
import 'services/auth/firebase_auth_service.dart';
import 'services/database/firestore_db_service.dart';
import 'services/storage/firebase_storage_service.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => FakeAuthService());
  locator.registerLazySingleton(() => FirestoreDBService());
  locator.registerLazySingleton(() => FirebaseStorageService());
  locator.registerLazySingleton(() => UserRepository());
}
