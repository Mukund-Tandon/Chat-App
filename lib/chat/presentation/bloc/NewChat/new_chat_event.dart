part of 'new_chat_bloc.dart';

abstract class NewChatEvent extends Equatable {
  const NewChatEvent();
}

class NewChatLoadingEvent extends NewChatEvent {
  @override
  List<Object?> get props => [];
}

class NewChatFindUserEvent extends NewChatEvent {
  String phoneNumber;
  NewChatFindUserEvent({required this.phoneNumber});
  @override
  List<Object?> get props => [phoneNumber];
}

class NewChatGetContactListFromPhone extends NewChatEvent {
  @override
  List<Object?> get props => [];
}

class NewChatOriginalState extends NewChatEvent {
  @override
  List<Object?> get props => [];
}
