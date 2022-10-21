import 'package:whatsapp_clone/chat/domain/entities/message_entity.dart';
import 'package:whatsapp_clone/chat/domain/repository/message_repository.dart';

class UploadImageUsecase {
  final MessageRepository messageRepository;
  UploadImageUsecase({required this.messageRepository});
  Future<String> call(MessageEntity messageEntity) async {
    return await messageRepository.uploadImage(messageEntity);
  }
}
