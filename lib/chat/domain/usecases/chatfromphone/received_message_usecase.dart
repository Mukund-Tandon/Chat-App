import '../../entities/message_entity.dart';
import '../../repository/local_chat_repository.dart';

class ReceivedMessage {
  final LocalChatRepository localChatRepository;
  ReceivedMessage({required this.localChatRepository});
  Future<void> call(MessageEntity messageEntity) async {
    await localChatRepository.receivedMessage(messageEntity);
  }
}
