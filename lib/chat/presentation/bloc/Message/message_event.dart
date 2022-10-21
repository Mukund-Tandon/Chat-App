part of 'message_bloc.dart';

@immutable
abstract class MessageEvent extends Equatable {
  const MessageEvent();
}

class Subscribed extends MessageEvent {
  final UserEntity user;
  const Subscribed(this.user);

  @override
  // TODO: implement props
  List<Object?> get props => [user];
}

class MessageSent extends MessageEvent {
  final MessageEntity message;
  const MessageSent(this.message);
  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

class MessageReceived extends MessageEvent {
  final MessageEntity message;
  const MessageReceived(this.message);
  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

class MessageImageSend extends MessageEvent {
  final MessageEntity message;
  const MessageImageSend(this.message);
  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

class MessageImageinTempDirectoryEvent extends MessageEvent {
  final MessageEntity message;
  const MessageImageinTempDirectoryEvent(this.message);
  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

class MessageImageiSavingInLocalDirectory extends MessageEvent {
  final MessageEntity message;
  const MessageImageiSavingInLocalDirectory(this.message);
  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

class MessageImageUploadingEvent extends MessageEvent {
  final MessageEntity message;
  const MessageImageUploadingEvent(this.message);
  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

class MessageImageSentSuccess extends MessageEvent {
  final MessageEntity message;
  const MessageImageSentSuccess(this.message);
  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

class MessageImageReceivedEvent extends MessageEvent {
  final MessageEntity message;
  const MessageImageReceivedEvent(this.message);
  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

class MessageImageDownloadStartedEvent extends MessageEvent {
  final MessageEntity message;
  const MessageImageDownloadStartedEvent(this.message);
  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

class MessageImageDownloadCompletedEvent extends MessageEvent {
  final MessageEntity message;
  const MessageImageDownloadCompletedEvent(this.message);
  @override
  // TODO: implement props
  List<Object?> get props => [message];
}
