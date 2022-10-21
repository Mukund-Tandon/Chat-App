enum ReceiptStatus { sent, delivered, read }

extension ReceiptStatusParser on ReceiptStatus {
  String value() {
    return this.toString().split('.').last;
  }

//static keyword for class level methors with can be accessed without creating an object
  static ReceiptStatus fromString(String status) {
    return ReceiptStatus.values
        .firstWhere((element) => element.value() == status);
  }
}

class ReceiptEntity {
  final String recipient;
  final String messageId;
  final ReceiptStatus status;
  final DateTime timestamp;
  late String id;
  ReceiptEntity(
      {required this.recipient,
      required this.messageId,
      required this.status,
      required this.timestamp});
}
