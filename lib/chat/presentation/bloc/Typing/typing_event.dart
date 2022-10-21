part of 'typing_bloc.dart';

@immutable
abstract class TypingEvent extends Equatable {
  const TypingEvent();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class SubscribedTyping extends TypingEvent {
  final UserEntity user;
  final List<String> userWithChat;
  const SubscribedTyping(this.user, this.userWithChat);

  @override
  // TODO: implement props
  List<Object?> get props => [user, userWithChat];
}

class NotSubscribed extends TypingEvent {}

class TypingEventSent extends TypingEvent {
  final TypingEventEntity typingEvent;

  const TypingEventSent(this.typingEvent);
  @override
  // TODO: implement props
  List<Object?> get props => [typingEvent];
}

class TypingEventReceived extends TypingEvent {
  final TypingEventEntity typingEvent;
  const TypingEventReceived(this.typingEvent);
  @override
  // TODO: implement props
  List<Object?> get props => [typingEvent];
}
