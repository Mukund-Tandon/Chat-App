import 'dart:io';

class ImageUploadEntity {
  String name;
  File image;
  ImageUploadEntity(this.image, this.name);
}
