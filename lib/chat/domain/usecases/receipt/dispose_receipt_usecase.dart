import '../../repository/receipt_repository.dart';

class DisposeReceipt {
  final ReceiptRepository receiptRepository;
  DisposeReceipt(this.receiptRepository);

  call() {
    receiptRepository.dispose();
  }
}
