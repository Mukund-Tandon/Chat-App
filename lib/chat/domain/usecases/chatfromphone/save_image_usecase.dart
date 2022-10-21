import 'package:whatsapp_clone/chat/domain/entities/message_entity.dart';
import 'package:whatsapp_clone/chat/domain/repository/local_chat_repository.dart';

class SaveImageUsecase {
  final LocalChatRepository localChatRepository;
  SaveImageUsecase({required this.localChatRepository});
  Future<String> call(MessageEntity messageEntity) async {
    return await localChatRepository.saveImage(messageEntity);
  }
}
