part of 'chats_cubit.dart';

abstract class ChatsState extends Equatable {
  const ChatsState();
}

class ChatsInitial extends ChatsState {
  @override
  List<Object> get props => [];
}

class CachedChatState extends ChatsState {
  List<CacheChats> chatList;
  CachedChatState({required this.chatList});
  @override
  List<Object?> get props => [chatList];
}

class ChatsLoaded extends ChatsState {
  List<ChatEntity> chats;

  ChatsLoaded({required this.chats});

  @override
  List<Object?> get props => [chats];
}
