import 'package:whatsapp_clone/chat/domain/entities/cache_chat_entity.dart';
import 'package:whatsapp_clone/chat/domain/entities/chat_entity.dart';
import 'package:whatsapp_clone/chat/domain/entities/local_message_entity.dart';
import 'package:whatsapp_clone/chat/domain/entities/receipt_entity.dart';

import '../entities/message_entity.dart';

abstract class LocalChatRepository {
  Future<void> addMessage(LocalMessageEntity localMessageEntity);
  Future<void> receivedMessage(MessageEntity messageEntity);
  Future<List<LocalMessageEntity>> getMessages(String ChatId);
  Future<String> sendMessage(MessageEntity messageEntity);
  Future<ChatEntity> findChat(String chadId);
  Future<List<ChatEntity>> findAllChats();
  Future<void> updateMessage(LocalMessageEntity localMessageEntity);
  Future<void> updateMessageWithId(
      LocalMessageEntity localMessageEntity, String oldId);
  Future<List<LocalMessageEntity>> findMessages(String ChatId);
  Future<void> deleteChat(String chatId);
  Future<void> updatemessageReceipt(String messageId, ReceiptStatus status);
  Future<void> cacheChats(Map<String, dynamic> jsonData);
  List<CacheChats> getCachedchats();
  Future<String> saveImage(MessageEntity messageEntity);
  Future<String> saveNetworkImage(String url);
}
