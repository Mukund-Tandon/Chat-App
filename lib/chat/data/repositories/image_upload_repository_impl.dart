import 'package:whatsapp_clone/chat/data/datasources/remotedatasources/image_remote_data_source.dart';
import 'package:whatsapp_clone/chat/domain/entities/image_upload_entity.dart';
import 'package:whatsapp_clone/chat/domain/repository/image_upload_repository.dart';

class ImageUploadRepositoryImp implements ImageUploadRepository {
  final ImageRemoteDataSource imageRemoteDataSource;
  ImageUploadRepositoryImp(this.imageRemoteDataSource);
  @override
  Future<String?> uploadImage(ImageUploadEntity image) {
    return imageRemoteDataSource.uploadImage(image);
  }
}
