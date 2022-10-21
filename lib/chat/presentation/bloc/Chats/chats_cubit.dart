import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:whatsapp_clone/chat/domain/entities/message_entity.dart';

import '../../../domain/entities/cache_chat_entity.dart';
import '../../../domain/entities/chat_entity.dart';
import '../../../domain/usecases/chatCache/get_cached_chats.dart';
import '../../../domain/usecases/chatfromphone/find_all_chats.dart';
import '../../../domain/usecases/chatfromphone/received_message_usecase.dart';

part 'chats_state.dart';

class ChatsCubit extends Cubit<ChatsState> {
  final FindAllChats findAllChats;
  final ReceivedMessage receivedMessage;
  final GetCachedChats getCachedChats;
  ChatsCubit(
      {required this.findAllChats,
      required this.receivedMessage,
      required this.getCachedChats})
      : super(ChatsInitial());
  Future<void> getAllChats() async {
    cachedChats();
    final chats = await findAllChats.call();
    print('uncached chats $chats');
    emit(ChatsLoaded(chats: chats));
  }

  void cachedChats() {
    final cachedChats = getCachedChats.call();
    print('get cached chats $cachedChats');
    emit(CachedChatState(chatList: cachedChats));
  }

  Future<void> messageReceived(MessageEntity messageEntity) async {
    await receivedMessage.call(messageEntity);
  }
}
