import 'dart:ui';

import 'package:whatsapp_clone/chat/data/datasources/localdatasources/local_chat_local_datasource.dart';
import 'package:whatsapp_clone/chat/data/models/cache_chat_model.dart';
import 'package:whatsapp_clone/chat/domain/entities/cache_chat_entity.dart';
import 'package:whatsapp_clone/chat/domain/entities/chat_entity.dart';
import 'package:whatsapp_clone/chat/domain/entities/local_message_entity.dart';
import 'package:whatsapp_clone/chat/domain/entities/message_entity.dart';
import 'package:whatsapp_clone/chat/domain/entities/receipt_entity.dart';
import 'package:whatsapp_clone/chat/domain/repository/local_chat_repository.dart';

import '../datasources/remotedatasources/user_remote_data_source.dart';

class LocalChatRepositoryImpl implements LocalChatRepository {
  final LocalChatLocalDataSource localChatLocalDataSource;
  final UserRemoteDataSource userRemoteDataSource;
  LocalChatRepositoryImpl(
      this.localChatLocalDataSource, this.userRemoteDataSource);
  @override
  Future<String> addMessage(LocalMessageEntity localMessageEntity) async {
    if (!await localChatLocalDataSource.chatExist(localMessageEntity.chatId)) {
      await _createNewChat(localMessageEntity.chatId);
    } else {}
    return await localChatLocalDataSource.addMessage(localMessageEntity);
  }

  @override
  Future<void> receivedMessage(MessageEntity messageEntity) async {
    LocalMessageEntity localMessageEntity = LocalMessageEntity(
        chatId: messageEntity.sender,
        message: messageEntity,
        receiptStatus: ReceiptStatus.delivered);
    await addMessage(localMessageEntity);
  }

  @override
  Future<List<LocalMessageEntity>> getMessages(String ChatId) async {
    final message = await localChatLocalDataSource.findMessages(ChatId);
    return message;
  }

  @override
  Future<String> sendMessage(MessageEntity messageEntity) async {
    LocalMessageEntity localMessageEntity = LocalMessageEntity(
        chatId: messageEntity.receiver,
        message: messageEntity,
        receiptStatus: ReceiptStatus.sent);
    return await addMessage(localMessageEntity);
  }

  @override
  Future<void> deleteChat(String chatId) {
    // TODO: implement deleteChat
    throw UnimplementedError();
  }

  @override
  Future<List<ChatEntity>> findAllChats() async {
    final List<ChatEntity> chats =
        await localChatLocalDataSource.findAllChats();

    for (var chat in chats) {
      final user = await userRemoteDataSource.fetch(chat.id);
      chat.from = user!;
    }
    Map<String, List> cacheChatData = {'message': []};
    if (chats.length > 10) {
      for (int i = 0; i < 10; i++) {
        cacheChatData['message']?.add({
          'id': chats[i].id,
          'contents': chats[i].mostRecent.message.contents,
          'unread': chats[i].unread,
          'username': chats[i].from.username,
          'photourl': chats[i].from.photoUrl,
          'timestamp': chats[i].mostRecent.message.timestamp.toString()
        });
      }
    } else {
      for (int i = 0; i < chats.length; i++) {
        cacheChatData['message']?.add({
          'id': chats[i].id,
          'contents': chats[i].mostRecent.message.contents,
          'unread': chats[i].unread,
          'username': chats[i].from.username,
          'photourl': chats[i].from.photoUrl,
          'timestamp': chats[i].mostRecent.message.timestamp.toString(),
          'isImage': chats[i].mostRecent.message.isImage.toString()
        });
      }
    }
    await cacheChats(cacheChatData);
    return chats;
  }

  @override
  Future<ChatEntity> findChat(String chadId) {
    // TODO: implement findChat
    throw UnimplementedError();
  }

  @override
  Future<List<LocalMessageEntity>> findMessages(String ChatId) {
    // TODO: implement findMessages
    throw UnimplementedError();
  }

  @override
  Future<void> updateMessage(LocalMessageEntity localMessageEntity) async {
    await localChatLocalDataSource.updateMessage(localMessageEntity);
  }

  Future<void> _createNewChat(String chatId) async {
    final chat = ChatEntity(chatId);
    await localChatLocalDataSource.addChat(chat);
  }

  @override
  Future<void> updatemessageReceipt(
      String messageId, ReceiptStatus status) async {
    await localChatLocalDataSource.updatemessageReceipt(messageId, status);
  }

  @override
  Future<void> cacheChats(Map<String, dynamic> jsonData) async {
    await localChatLocalDataSource.cacheChats(jsonData);
  }

  @override
  List<CacheChats> getCachedchats() {
    List? res = localChatLocalDataSource.getCachedchats()?['message'];
    List<CacheChats> list = [];
    if (res == null) {
      return list;
    }
    res.forEach((element) {
      list.add(CacheChatModel.fromJson(element));
    });

    return list;
  }

  @override
  Future<String> saveImage(MessageEntity messageEntity) async {
    final imagePath =
        await localChatLocalDataSource.saveImage(messageEntity.contents);
    final message = MessageEntity(
        imageStatus: ImageStatus.uploading,
        sender: messageEntity.sender,
        receiver: messageEntity.receiver,
        timestamp: messageEntity.timestamp,
        contents: imagePath,
        isImage: messageEntity.isImage);
    message.id = messageEntity.id;
    LocalMessageEntity localMessageEntity = LocalMessageEntity(
        chatId: messageEntity.sender,
        message: message,
        receiptStatus: ReceiptStatus.sent);

    await localChatLocalDataSource.updateMessage(localMessageEntity);
    return imagePath;
  }

  @override
  Future<String> saveNetworkImage(String url) async {
    return await localChatLocalDataSource.saveNetworkImage(url);
  }

  @override
  Future<void> updateMessageWithId(
      LocalMessageEntity localMessageEntity, String oldId) async {
    await localChatLocalDataSource.updateMessageWithId(
        localMessageEntity, oldId);
  }
}
