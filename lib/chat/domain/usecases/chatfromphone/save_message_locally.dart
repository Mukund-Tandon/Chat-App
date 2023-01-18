import 'package:whatsapp_clone/chat/domain/repository/local_chat_repository.dart';

import '../../entities/message_entity.dart';

class SaveMessageLocallyUsecase {
  final LocalChatRepository localChatRepository;
  SaveMessageLocallyUsecase({required this.localChatRepository});
  Future<String> call(MessageEntity messageEntity) async {
    return localChatRepository.sendMessage(messageEntity);
  }
}
