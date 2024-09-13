import 'package:image_picker/image_picker.dart';

abstract class StorageServiceBase {
  Future<String?> uploadFile(String userID, String fileType, XFile file);
}
