import 'package:whatsapp_clone/chat/domain/entities/message_entity.dart';
import 'package:whatsapp_clone/chat/domain/entities/user_entity.dart';

abstract class MessageRepository {
  Future<MessageEntity> sendMessage(MessageEntity messageEntity);
  Stream<MessageEntity> getAllMessages({required UserEntity userEntity});
  dispose();
  Future<String> uploadImage(MessageEntity messageEntity);
}
