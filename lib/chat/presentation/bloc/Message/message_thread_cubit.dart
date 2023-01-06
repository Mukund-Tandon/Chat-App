import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/local_message_entity.dart';
import '../../../domain/entities/message_entity.dart';
import '../../../domain/usecases/chatfromphone/get_message_usecase.dart';
import '../../../domain/usecases/chatfromphone/save_message_locally.dart';
import '../../../domain/usecases/chatfromphone/received_message_usecase.dart';
import '../../../domain/usecases/chatfromphone/update_message_receipt.dart';

part 'message_thread_state.dart';

class MessageThreadCubit extends Cubit<MessageThreadState> {
  final GetMessagesFromPhoneLocalWithChatId getMessagesFromPhoneLocalWithChatId;
  final ReceivedMessage receivedMessage;
  final SaveMessageLocallyUsecase saveMessageLocallyUsecase;
  final UpdateMessageReceipt updateMessageReceipt;
  MessageThreadCubit(
      {required this.getMessagesFromPhoneLocalWithChatId,
      required this.receivedMessage,
      required this.saveMessageLocallyUsecase,
      required this.updateMessageReceipt})
      : super(MessageThreadInitial());
  Future<void> getMessagesFromPhoneusingchatId(String chatId) async {
    final messages = await getMessagesFromPhoneLocalWithChatId.call(chatId);
    print('ddd ${messages.length}');
    emit(MessageThreadLoaded(messages: messages));
  }

  Future<void> messageReceived(MessageEntity messageEntity) async {
    await receivedMessage.call(messageEntity);
  }

  // void messageSentFromDevice(MessageEntity messageEntity) async {
  //   await messageSentUsecase.call(messageEntity);
  // }
}
