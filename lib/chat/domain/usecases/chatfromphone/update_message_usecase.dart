import 'package:whatsapp_clone/chat/domain/entities/local_message_entity.dart';
import 'package:whatsapp_clone/chat/domain/entities/message_entity.dart';
import 'package:whatsapp_clone/chat/domain/repository/local_chat_repository.dart';

class UpdateMessageUsecase {
  final LocalChatRepository localChatRepository;
  UpdateMessageUsecase({required this.localChatRepository});

  Future<void> call(LocalMessageEntity localMessageEntity) async {
    await localChatRepository.updateMessage(localMessageEntity);
  }
}
