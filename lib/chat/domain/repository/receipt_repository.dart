import 'package:whatsapp_clone/chat/domain/entities/receipt_entity.dart';
import 'package:whatsapp_clone/chat/domain/entities/user_entity.dart';

abstract class ReceiptRepository {
  Future<bool> sendReceipt(ReceiptEntity receiptEntity);
  Stream<ReceiptEntity> getAllReceipt({required UserEntity userEntity});
  dispose();
}
