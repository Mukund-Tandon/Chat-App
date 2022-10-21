import 'package:http/http.dart';
import 'package:whatsapp_clone/chat/domain/entities/image_upload_entity.dart';
import 'package:whatsapp_clone/core/superbase_service.dart';

abstract class ImageRemoteDataSource {
  Future<String?> uploadImage(ImageUploadEntity imageUploadEntity);
}

class ImageRemoteDataSourceImpl implements ImageRemoteDataSource {
  @override
  Future<String?> uploadImage(ImageUploadEntity imageUploadEntity) async {
    dynamic file = imageUploadEntity.image;
    final res = await SupabseCredentials.supabaseClient.storage
        .from('profile-photos')
        .upload(imageUploadEntity.name, file);
    final url = await SupabseCredentials.supabaseClient.storage
        .from('profile-photos')
        .getPublicUrl(imageUploadEntity.name);
    print(url);
    return url.data;
  }
}
