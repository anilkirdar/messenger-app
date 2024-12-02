import 'package:image_picker/image_picker.dart';

abstract class StorageServiceBase {
  Future<String?> uploadFile(
      {required String userID,
      required String fileType,
      required XFile file,
      required String fileName});
}
