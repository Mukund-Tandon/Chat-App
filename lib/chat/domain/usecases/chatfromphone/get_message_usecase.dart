import 'package:whatsapp_clone/chat/domain/repository/local_chat_repository.dart';
import 'package:whatsapp_clone/chat/domain/usecases/message/send_message_usecase.dart';

import '../../entities/local_message_entity.dart';

class GetMessagesFromPhoneLocalWithChatId {
  final LocalChatRepository localChatRepository;
  GetMessagesFromPhoneLocalWithChatId({required this.localChatRepository});
  Future<List<LocalMessageEntity>> call(String chatId) async {
    return await localChatRepository.getMessages(chatId);
  }
}
