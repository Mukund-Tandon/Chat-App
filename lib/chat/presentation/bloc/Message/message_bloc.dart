import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whatsapp_clone/chat/domain/entities/message_entity.dart';
import 'package:whatsapp_clone/chat/domain/entities/user_entity.dart';
import 'package:whatsapp_clone/chat/domain/usecases/chatfromphone/save_image_usecase.dart';
import 'package:whatsapp_clone/chat/domain/usecases/chatfromphone/update_message_with_id_usecase.dart';
import 'package:whatsapp_clone/chat/domain/usecases/message/dispose_usecase.dart';
import 'package:whatsapp_clone/chat/domain/usecases/message/get_all_message_usecase.dart';
import 'package:whatsapp_clone/chat/domain/usecases/message/send_message_usecase.dart';

import '../../../domain/entities/local_message_entity.dart';
import '../../../domain/entities/receipt_entity.dart';
import '../../../domain/usecases/chatfromphone/message_sent.dart';
import '../../../domain/usecases/chatfromphone/save_network_image.dart';
import '../../../domain/usecases/chatfromphone/update_message_usecase.dart';
import '../../../domain/usecases/message/upload_image_usecase.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  GetAllMessages getAllMessages;
  SendMessage sendMessage;
  Dispose dispose;
  SaveImageUsecase saveImageUsecase;
  Stream<MessageEntity>? st;
  UploadImageUsecase uploadImageUsecase;
  UpdateMessageUsecase updateMessageUsecase;
  UpdateMessageWithId updateMessageWithId;
  SaveNetworkImage saveNetworkImage;
  MessageBloc({
    required this.updateMessageWithId,
    required this.saveNetworkImage,
    required this.saveImageUsecase,
    required this.getAllMessages,
    required this.sendMessage,
    required this.dispose,
    required this.updateMessageUsecase,
    required this.uploadImageUsecase,
  }) : super(MessageInitial()) {
    on<Subscribed>((event, emit) async {
      print('subscribing message vloc');
      // streamSubscription?.cancel();

      st = getAllMessages.call(userEntity: event.user);
      st?.listen((message) {
        print('new message from stream bloc ${message.contents}');
        if (message.isImage) {
          add(MessageImageReceivedEvent(message));
        } else {
          add(MessageReceived(message));
        }
      }).onDone(() {
        print('stream closed');
      });
    });
    on<MessageReceived>((event, emit) {
      emit(MessageReceivedSuccess(event.message));
    });
    on<MessageSent>((event, emit) async {
      final message = await sendMessage.call(event.message);
      emit(MessageSentSuccess(message));
    });
    on<MessageImageSentSuccess>((event, emit) async {
      emit(MessageImageSentSuccessState(event.message));
    });
    on<MessageImageinTempDirectoryEvent>((event, emit) async {
      emit(MessageImageFromTempDirecctorySendState(event.message));
    });
    on<MessageImageiSavingInLocalDirectory>((event, emit) async {
      emit(MessageImageSavingToLocalDirectoryState(event.message));
    });
    on<MessageImageUploadingEvent>((event, emit) async {
      emit(MessageImageUploadingState(event.message));
    });
    on<MessageImageSend>((event, emit) async {
      add(MessageImageinTempDirectoryEvent(event.message));
      final status = await Permission.storage.request();
      String imagePath = await saveImageUsecase.call(event.message);

      add(MessageImageUploadingEvent(event.message));
      String url = await uploadImageUsecase.call(event.message);
      final message = MessageEntity(
          imageStatus: ImageStatus.downloading,
          sender: event.message.sender,
          receiver: event.message.receiver,
          timestamp: event.message.timestamp,
          contents: url,
          isImage: event.message.isImage);

      final sentmessage = await sendMessage.call(message);

      final updatemessage = MessageEntity(
          imageStatus: ImageStatus.done,
          sender: sentmessage.sender,
          receiver: sentmessage.receiver,
          timestamp: sentmessage.timestamp,
          contents: imagePath,
          isImage: sentmessage.isImage);
      updatemessage.id = sentmessage.id;
      LocalMessageEntity localMessageEntity = LocalMessageEntity(
          chatId: event.message.receiver,
          message: updatemessage,
          receiptStatus: ReceiptStatus.sent);

      await updateMessageWithId.call(localMessageEntity, event.message.id);

      add(MessageImageSentSuccess(event.message));
    });
    on<MessageImageDownloadStartedEvent>((event, emit) async {
      emit(MessageImageDownloadStarted(event.message));
    });
    on<MessageImageDownloadCompletedEvent>((event, emit) async {
      emit(MessageImageReceivedDownlodeCompleteState(event.message));
    });
    on<MessageImageReceivedEvent>((event, emit) async {
      add(MessageImageDownloadStartedEvent(event.message));
      String imagePath = await saveNetworkImage.call(event.message.contents);
      final updatemessage = MessageEntity(
          imageStatus: ImageStatus.done,
          sender: event.message.sender,
          receiver: event.message.receiver,
          timestamp: event.message.timestamp,
          contents: imagePath,
          isImage: event.message.isImage);
      updatemessage.id = event.message.id;
      LocalMessageEntity localMessageEntity = LocalMessageEntity(
          chatId: event.message.sender,
          message: updatemessage,
          receiptStatus: ReceiptStatus.sent);
      await updateMessageUsecase.call(localMessageEntity);
      add(MessageImageDownloadCompletedEvent(event.message));
    });
  }
  @override
  Future<void> close() async {
    print('closing message bloc');
    // streamSubscription?.cancel();
    // dispose.call();
    super.close();
  }
}
