part of 'message_bloc.dart';

abstract class MessageState extends Equatable {
  const MessageState();
  @override
  List<Object?> get props => [];
}

class MessageInitial extends MessageState {}

class MessageSentSuccess extends MessageState {
  final MessageEntity message;
  const MessageSentSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class MessageImageFromTempDirecctorySendState extends MessageState {
  final MessageEntity message;
  const MessageImageFromTempDirecctorySendState(this.message);

  @override
  List<Object?> get props => [message];
}

class MessageImageSavingToLocalDirectoryState extends MessageState {
  final MessageEntity message;
  const MessageImageSavingToLocalDirectoryState(this.message);

  @override
  List<Object?> get props => [message];
}

class MessageImageUploadingState extends MessageState {
  final MessageEntity message;
  const MessageImageUploadingState(this.message);

  @override
  List<Object?> get props => [message];
}

class MessageImageSentSuccessState extends MessageState {
  final MessageEntity message;
  const MessageImageSentSuccessState(this.message);

  @override
  List<Object?> get props => [message];
}

class MessageReceivedSuccess extends MessageState {
  final MessageEntity message;
  const MessageReceivedSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class MessageImageDownloadStarted extends MessageState {
  final MessageEntity message;
  const MessageImageDownloadStarted(this.message);

  @override
  List<Object?> get props => [message];
}

class MessageImageReceivedDownlodeCompleteState extends MessageState {
  final MessageEntity message;
  const MessageImageReceivedDownlodeCompleteState(this.message);

  @override
  List<Object?> get props => [message];
}
