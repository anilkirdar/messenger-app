import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'storage_service_base.dart';

class FirebaseStorageService implements StorageServiceBase {
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  Reference? storageReference;
  String? url;

  @override
  Future<String?> uploadFile(String userID, String fileType, XFile file) async {
    storageReference = firebaseStorage
        .ref()
        .child(userID)
        .child(fileType)
        .child('profile-photo.png');

    await storageReference!.putFile(File(file.path)).whenComplete(
      () async {
        url = await storageReference!.getDownloadURL();
      },
    );

    return url;
  }
}
