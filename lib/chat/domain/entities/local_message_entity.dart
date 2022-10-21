import 'package:whatsapp_clone/chat/domain/entities/message_entity.dart';
import 'package:whatsapp_clone/chat/domain/entities/receipt_entity.dart';

class LocalMessageEntity {
  String chatId;
  late String id;
  MessageEntity message;
  ReceiptStatus receiptStatus;
  LocalMessageEntity(
      {required this.chatId,
      required this.message,
      required this.receiptStatus});
}
