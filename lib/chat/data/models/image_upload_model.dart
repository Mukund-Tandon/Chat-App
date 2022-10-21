import 'dart:io';

import 'package:whatsapp_clone/chat/domain/entities/image_upload_entity.dart';

class ImageUploadModel extends ImageUploadEntity {
  ImageUploadModel(File image, String name) : super(image, name);
}
