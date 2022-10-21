import 'package:whatsapp_clone/chat/domain/entities/cache_chat_entity.dart';
import 'package:whatsapp_clone/chat/domain/repository/local_chat_repository.dart';

class GetCachedChats {
  final LocalChatRepository localChatRepository;
  GetCachedChats({required this.localChatRepository});

  List<CacheChats> call() {
    return localChatRepository.getCachedchats();
  }
}
