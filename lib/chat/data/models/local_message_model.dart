import 'package:whatsapp_clone/chat/data/models/message_model.dart';
import 'package:whatsapp_clone/chat/domain/entities/local_message_entity.dart';
import 'package:whatsapp_clone/chat/domain/entities/message_entity.dart';
import 'package:whatsapp_clone/chat/domain/entities/receipt_entity.dart';

class LocalMessageModel extends LocalMessageEntity {
  LocalMessageModel(
      {required String chatId,
      required MessageEntity message,
      required ReceiptStatus receiptStatus})
      : super(chatId: chatId, message: message, receiptStatus: receiptStatus);

  Map<String, dynamic> toJson() {
    return {
      'chat_id': chatId,
      'id': message.id,
      'sender': message.sender,
      'receiver': message.receiver,
      'contents': message.contents,
      'received_at': message.timestamp.toString(),
      'receipt': receiptStatus.value(),
      'isImage': message.isImage.toString(),
      'imageStatus': message.imageStatus.value(),
    };
  }

  factory LocalMessageModel.fromJson(Map<String, dynamic> json) {
    var message = MessageModel(
        sender: json['sender'],
        receiver: json['receiver'],
        timestamp: DateTime.parse(json['received_at']),
        contents: json['contents'],
        isImage: json['isImage'] == "true" ? true : false,
        imageStatus: ImageStatusParser.fromString(json['imageStatus']));
    final localMessage = LocalMessageModel(
        chatId: json['chat_id'],
        message: message,
        receiptStatus: ReceiptStatusParser.fromString(json['receipt']));
    localMessage.id = json['id'];
    return localMessage;
  }
}
