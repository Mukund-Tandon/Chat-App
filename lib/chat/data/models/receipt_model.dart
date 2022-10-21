import 'package:whatsapp_clone/chat/domain/entities/receipt_entity.dart';

class ReceiptModel extends ReceiptEntity {
  ReceiptModel(
      {required String recipient,
      required String messageId,
      required ReceiptStatus status,
      required DateTime timestamp})
      : super(
            recipient: recipient,
            messageId: messageId,
            status: status,
            timestamp: timestamp);

  Map<String, dynamic> toJson() {
    return {
      'recipient': recipient,
      'message_id': messageId,
      'status': status.value(),
      'timestamp': timestamp.toString()
    };
  }

  factory ReceiptModel.fromJson(Map<String, dynamic> json) {
    var receipt = ReceiptModel(
        recipient: json['recipient'],
        messageId: json['message_id'],
        status: ReceiptStatusParser.fromString(json['status']),
        timestamp: DateTime.parse(json['timestamp']));
    receipt.id = json['id'];
    return receipt;
  }
}
