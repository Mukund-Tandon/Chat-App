part of 'message_thread_cubit.dart';

abstract class MessageThreadState extends Equatable {
  const MessageThreadState();
}

class MessageThreadInitial extends MessageThreadState {
  @override
  List<Object> get props => [];
}

class MessageThreadLoaded extends MessageThreadState {
  List<LocalMessageEntity> messages;
  MessageThreadLoaded({required this.messages});
  @override
  List<Object> get props => [messages];
}
