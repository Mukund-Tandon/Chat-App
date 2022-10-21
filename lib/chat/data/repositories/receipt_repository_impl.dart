import 'package:whatsapp_clone/chat/data/datasources/remotedatasources/receipt_remote_data_source.dart';
import 'package:whatsapp_clone/chat/domain/entities/receipt_entity.dart';
import 'package:whatsapp_clone/chat/domain/entities/user_entity.dart';
import 'package:whatsapp_clone/chat/domain/repository/receipt_repository.dart';

class ReceiptRepositoryImpl implements ReceiptRepository {
  final ReceiptRemoteDataSource receiptRemoteDataSource;
  ReceiptRepositoryImpl(this.receiptRemoteDataSource);
  @override
  dispose() {
    receiptRemoteDataSource.dispose();
  }

  @override
  Stream<ReceiptEntity> getAllReceipt({required UserEntity userEntity}) {
    Stream<ReceiptEntity> s =
        receiptRemoteDataSource.getAllReceipt(userEntity: userEntity);

    return s;
  }

  @override
  Future<bool> sendReceipt(ReceiptEntity receiptEntity) {
    return receiptRemoteDataSource.sendReceipt(receiptEntity);
  }
}
