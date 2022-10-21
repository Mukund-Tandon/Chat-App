import 'package:whatsapp_clone/chat/domain/repository/receipt_repository.dart';

import '../../entities/receipt_entity.dart';
import '../../entities/user_entity.dart';

class GetAllReceipts {
  final ReceiptRepository receiptRepository;
  GetAllReceipts(this.receiptRepository);
  Stream<ReceiptEntity> call({required UserEntity userEntity}) {
    return receiptRepository.getAllReceipt(userEntity: userEntity);
  }
}
