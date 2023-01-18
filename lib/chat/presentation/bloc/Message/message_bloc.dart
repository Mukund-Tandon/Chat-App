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
import '../../../domain/usecases/chatfromphone/save_message_locally.dart';
import '../../../domain/usecases/chatfromphone/save_network_image.dart';
import '../../../domain/usecases/chatfromphone/update_message_usecase.dart';
import '../../../domain/usecases/message/upload_image_usecase.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  GetAllMessages getAllMessages;
  SaveMessageLocallyUsecase saveMessageLocallyUsecase;
  Dispose dispose;
  SendMessage sendMessage;
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
    required this.sendMessage,
    required this.getAllMessages,
    required this.saveMessageLocallyUsecase,
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

        add(MessageReceived(message));
      }).onDone(() {
        print('stream closed');
      });
    });
    on<MessageReceived>((event, emit) {
      emit(MessageReceivedSuccess(event.message));
    });
    on<MessageSent>((event, emit) async {
      String id = await saveMessageLocallyUsecase.call(event.message);
      event.message.id = id;
      emit(MessageSavedSuccess(event.message));
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
      String id = event.message.id;
      add(MessageImageinTempDirectoryEvent(event.message));

      print('Image in Saving ');
      String imagePath = await saveImageUsecase.call(event.message);
      var message = MessageEntity(
          imageStatus: ImageStatus.uploading,
          sender: event.message.sender,
          receiver: event.message.receiver,
          timestamp: event.message.timestamp,
          contents: imagePath,
          isImage: event.message.isImage);

      message.id = id;
      LocalMessageEntity localMessageEntity = LocalMessageEntity(
          chatId: event.message.receiver,
          message: message,
          receiptStatus: ReceiptStatus.sent);
      await updateMessageWithId.call(localMessageEntity, id);
      add(MessageImageUploadingEvent(message));

      print('Image Uploading');
      String url =
          await uploadImageUsecase.call(event.message); //uploading to supabase
      print('Image Uploaded');
      message = MessageEntity(
          imageStatus: ImageStatus.downloading,
          sender: event.message.sender,
          receiver: event.message.receiver,
          timestamp: event.message.timestamp,
          contents: url,
          isImage: event.message.isImage);
      print('Sending message to firebase');
      message.id = id;
      await sendMessage.call(message);
      print('Sending message to firebase');
      message = MessageEntity(
          imageStatus: ImageStatus.done,
          sender: event.message.sender,
          receiver: event.message.receiver,
          timestamp: event.message.timestamp,
          contents: imagePath,
          isImage: event.message.isImage);
      message.id = id;
      localMessageEntity = LocalMessageEntity(
          chatId: event.message.receiver,
          message: message,
          receiptStatus: ReceiptStatus.sent);
      print('Updating message');
      await updateMessageWithId.call(localMessageEntity, id);
      print('Image sent success');
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
