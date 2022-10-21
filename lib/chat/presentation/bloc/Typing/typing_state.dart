part of 'typing_bloc.dart';

abstract class TypingState extends Equatable {
  const TypingState();
  @override
  List<Object?> get props => [];
}

class TypingInitial extends TypingState {}

class TypingEventSentSuccess extends TypingState {
  final TypingEventEntity typingEvent;
  const TypingEventSentSuccess(this.typingEvent);

  @override
  List<Object?> get props => [typingEvent];
}

class TypingEventReceivedSuccess extends TypingState {
  final TypingEventEntity typingEvent;
  const TypingEventReceivedSuccess(this.typingEvent);

  @override
  List<Object?> get props => [typingEvent];
}
