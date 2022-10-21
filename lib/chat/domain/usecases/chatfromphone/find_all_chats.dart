import 'package:whatsapp_clone/chat/domain/repository/local_chat_repository.dart';

import '../../entities/chat_entity.dart';

class FindAllChats {
  final LocalChatRepository localChatRepository;
  FindAllChats({required this.localChatRepository});

  Future<List<ChatEntity>> call() {
    return localChatRepository.findAllChats();
  }
}
