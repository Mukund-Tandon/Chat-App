import 'package:whatsapp_clone/chat/domain/repository/local_chat_repository.dart';

import '../../entities/message_entity.dart';

class MessageSentUsecase {
  final LocalChatRepository localChatRepository;
  MessageSentUsecase({required this.localChatRepository});
  Future<void> call(MessageEntity messageEntity) async {
    return localChatRepository.sendMessage(messageEntity);
  }
}
