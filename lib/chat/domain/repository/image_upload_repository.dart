import 'package:whatsapp_clone/chat/domain/entities/image_upload_entity.dart';

abstract class ImageUploadRepository {
  Future<String?> uploadImage(ImageUploadEntity image);
}
