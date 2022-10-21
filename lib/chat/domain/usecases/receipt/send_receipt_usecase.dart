import 'package:whatsapp_clone/chat/domain/entities/receipt_entity.dart';

import '../../repository/receipt_repository.dart';

class SendReceipt {
  final ReceiptRepository receiptRepository;
  SendReceipt(this.receiptRepository);

  Future<bool> call(ReceiptEntity receiptEntity) {
    return receiptRepository.sendReceipt(receiptEntity);
  }
}
