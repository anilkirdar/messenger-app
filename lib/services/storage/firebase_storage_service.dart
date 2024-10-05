import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'storage_service_base.dart';

class FirebaseStorageService implements StorageServiceBase {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  Reference? _storageReference;
  String? _url;

  @override
  Future<String?> uploadFile(String userID, String fileType, XFile file) async {
    _storageReference = _firebaseStorage
        .ref()
        .child(userID)
        .child(fileType)
        .child('profile-photo.png');

    await _storageReference!.putFile(File(file.path)).whenComplete(
      () async {
        _url = await _storageReference!.getDownloadURL();
      },
    );

    return _url;
  }
}
