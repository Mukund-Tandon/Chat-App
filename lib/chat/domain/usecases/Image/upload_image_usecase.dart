import 'package:image_picker/image_picker.dart';
import 'package:whatsapp_clone/chat/domain/entities/image_upload_entity.dart';
import 'package:whatsapp_clone/chat/domain/repository/image_upload_repository.dart';
import 'dart:io';

class UploadImage {
  final ImageUploadRepository imageUploadRepository;
  UploadImage(this.imageUploadRepository);

  Future<String?> call(File imagefile, String username, String fileName) {
    String name = username.split(" ").join("") + fileName;
    ImageUploadEntity imageUploadEntity = ImageUploadEntity(imagefile, name);
    return imageUploadRepository.uploadImage(imageUploadEntity);
  }
}
