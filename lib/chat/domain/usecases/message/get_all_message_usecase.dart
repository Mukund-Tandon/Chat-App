import 'package:whatsapp_clone/chat/domain/entities/message_entity.dart';
import 'package:whatsapp_clone/chat/domain/entities/user_entity.dart';
import 'package:whatsapp_clone/chat/domain/repository/message_repository.dart';

class GetAllMessages {
  final MessageRepository messageRepository;
  GetAllMessages(this.messageRepository);

  Stream<MessageEntity> call({required UserEntity userEntity}) {
    return messageRepository.getAllMessages(userEntity: userEntity);
  }
}
