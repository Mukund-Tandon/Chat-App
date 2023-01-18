import 'package:whatsapp_clone/chat/data/datasources/remotedatasources/message_remote_data_source.dart';
import 'package:whatsapp_clone/chat/data/models/message_model.dart';
import 'package:whatsapp_clone/chat/domain/entities/message_entity.dart';
import 'package:whatsapp_clone/chat/domain/entities/user_entity.dart';
import 'package:whatsapp_clone/chat/domain/repository/message_repository.dart';
import 'package:whatsapp_clone/core/encryption/encryption.dart';

class MessageRepositoryImpl implements MessageRepository {
  final MessageRemoteDataSource messageRemoteDataSource;
  MessageRepositoryImpl(this.messageRemoteDataSource);
  @override
  Stream<MessageEntity> getAllMessages({required UserEntity userEntity}) {
    Stream<MessageEntity> s =
        messageRemoteDataSource.getAllMessages(userEntity: userEntity);

    return s;
  }

  @override
  Future<void> sendMessage(MessageEntity messageEntity) {
    return messageRemoteDataSource.sendMessage(messageEntity);
  }

  @override
  dispose() {
    messageRemoteDataSource.dispose();
  }

  @override
  Future<String> uploadImage(MessageEntity messageEntity) async {
    String url = await messageRemoteDataSource.uploadImage(messageEntity);
    return url;
  }
}
