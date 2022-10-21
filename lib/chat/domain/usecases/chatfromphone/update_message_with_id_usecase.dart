import '../../entities/local_message_entity.dart';
import '../../repository/local_chat_repository.dart';

class UpdateMessageWithId {
  final LocalChatRepository localChatRepository;
  UpdateMessageWithId({required this.localChatRepository});

  Future<void> call(LocalMessageEntity localMessageEntity, String oldId) async {
    await localChatRepository.updateMessageWithId(localMessageEntity, oldId);
  }
}
