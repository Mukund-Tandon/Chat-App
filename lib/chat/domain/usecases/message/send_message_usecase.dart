import 'package:whatsapp_clone/chat/domain/entities/message_entity.dart';
import 'package:whatsapp_clone/chat/domain/repository/message_repository.dart';

class SendMessage {
  final MessageRepository messageRepository;
  SendMessage(this.messageRepository);

  Future<MessageEntity> call(MessageEntity messageEntity) {
    return messageRepository.sendMessage(messageEntity);
  }
}
