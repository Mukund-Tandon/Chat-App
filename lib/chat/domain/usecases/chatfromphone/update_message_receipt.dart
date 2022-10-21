import 'package:whatsapp_clone/chat/domain/entities/receipt_entity.dart';
import 'package:whatsapp_clone/chat/domain/repository/local_chat_repository.dart';

class UpdateMessageReceipt {
  final LocalChatRepository localChatRepository;
  UpdateMessageReceipt({required this.localChatRepository});

  Future<void> call(ReceiptEntity receiptEntity) async {
    await localChatRepository.updatemessageReceipt(
        receiptEntity.messageId, receiptEntity.status);
  }
}
