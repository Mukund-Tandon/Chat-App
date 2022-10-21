part of 'new_chat_bloc.dart';

abstract class NewChatState extends Equatable {
  const NewChatState();
}

class NewChatInitial extends NewChatState {
  @override
  List<Object> get props => [];
}

class NewChatUserFound extends NewChatState {
  final UserEntity user;
  NewChatUserFound({required this.user});
  @override
  List<Object> get props => [user];
}

class NewChatUserNotFound extends NewChatState {
  @override
  List<Object> get props => [];
}

class NewChatLoading extends NewChatState {
  @override
  List<Object> get props => [];
}

class NewChatContactListFromPhoneLoaded extends NewChatState {
  List<Contact> contactList;
  NewChatContactListFromPhoneLoaded({required this.contactList});
  @override
  List<Object> get props => [];
}
