import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/chat/data/models/chat_model.dart';
import 'package:whatsapp_clone/chat/data/models/local_message_model.dart';
import 'package:whatsapp_clone/chat/domain/entities/message_entity.dart';

import '../../../domain/entities/chat_entity.dart';
import '../../../domain/entities/local_message_entity.dart';
import '../../../domain/entities/receipt_entity.dart';
import 'package:dio/dio.dart';

abstract class LocalChatLocalDataSource {
  Future<void> addChat(ChatEntity chatEntity);
  Future<String> addMessage(LocalMessageEntity localMessageEntity);
  Future<ChatModel> findChat(String chadId);
  Future<List<ChatModel>> findAllChats();
  Future<void> updateMessage(LocalMessageEntity localMessageEntity);
  Future<void> updateMessageWithId(
      LocalMessageEntity localMessageEntity, String oldId);
  Future<List<LocalMessageModel>> findMessages(String ChatId);
  Future<void> deleteChat(String chatId);
  Future<bool> chatExist(String chatId);
  Future<void> updatemessageReceipt(String messageId, ReceiptStatus status);
  Future<void> cacheChats(Map<String, dynamic> jsonData);
  Map<String, dynamic>? getCachedchats();
  Future<String> saveImage(String imageFilePath);
  Future<String> saveNetworkImage(String url);
}

class LocalChatLocalDataSourceImpl implements LocalChatLocalDataSource {
  final Database db;
  final SharedPreferences sharedPreferences;
  final Uuid uuid;
  LocalChatLocalDataSourceImpl(
      {required this.db, required this.sharedPreferences, required this.uuid});
  @override
  Future<void> addChat(ChatEntity chatEntity) async {
    var chat = ChatModel(chatEntity.id);
    // await db.insert('chats', chat.toJson(),
    //     conflictAlgorithm: ConflictAlgorithm.rollback);
    await db.transaction((txn) async {
      await txn.insert('chats', chat.toJson(),
          conflictAlgorithm: ConflictAlgorithm.rollback);
    });
  }

  @override
  Future<String> addMessage(LocalMessageEntity localMessageEntity) async {
    print(
        'Adding message with contents ${localMessageEntity.message.contents}');
    var message = LocalMessageModel(
        chatId: localMessageEntity.chatId,
        message: localMessageEntity.message,
        receiptStatus: localMessageEntity.receiptStatus);

    if (message.receiptStatus != ReceiptStatus.delivered) {
      message.message.id = uuid.v1();
    }
    print('Mesage Id = ${message.message.id}');
    // await db.insert('messages', message.toJson(),
    //     conflictAlgorithm: ConflictAlgorithm.ignore);
    await db.transaction((txn) async {
      await txn.insert('messages', message.toJson(),
          conflictAlgorithm: ConflictAlgorithm.ignore);
    });
    return message.message.id;
  }

  @override
  Future<void> deleteChat(String chatId) async {
    final batch = db.batch();
    batch.delete('messages', where: 'chat_id = ?', whereArgs: [chatId]);
    batch.delete('chats', where: 'id = ?', whereArgs: [chatId]);
    await batch.commit(noResult: true);
  }

  @override
  Future<List<ChatModel>> findAllChats() {
    return db.transaction((txn) async {
      final chatsWithLatestMessage =
          await txn.rawQuery('''SELECT messages.* FROM
      (SELECT 
        chat_id, MAX(received_at) AS received_at
       FROM messages
       GROUP BY chat_id
      ) AS latest_messages
      INNER JOIN messages
      ON messages.chat_id = latest_messages.chat_id
      AND messages.received_at = latest_messages.received_at
      ORDER BY received_at DESC''');

      final chatsWithUnreadMessages =
          await txn.rawQuery('''SELECT chat_id,count(*) as unread
          FROM messages
          WHERE receipt = ?
          GROUP BY chat_id''', ['delivered']);

      return chatsWithLatestMessage.map<ChatModel>((row) {
        int unread = 0;
        if (chatsWithUnreadMessages.isEmpty) {
          unread = 0;
        } else {
          unread = chatsWithUnreadMessages.firstWhere(
              (ele) => row['chat_id'] == ele['chat_id'],
              orElse: () => {'unread': 0})['unread'] as int;
        }

        final chat = ChatModel.fromJson({"id": row['chat_id']});

        chat.unread = unread;
        chat.mostRecent = LocalMessageModel.fromJson(row);

        return chat;
      }).toList();
    });
  }

  @override
  Future<ChatModel> findChat(String chadId) async {
    return await db.transaction((txn) async {
      final listOfChatMaps =
          await txn.query('chats', where: 'id = ?', whereArgs: [chadId]);
      final unread = Sqflite.firstIntValue(await txn.rawQuery(
          'SELECT COUNT(*) FROM MESSAGES WHERE chat_id = ? AND receipt = ?',
          [chadId, 'delivered']));
      final mostRecentMessage = await txn.query('messages',
          where: 'chat_id = ?',
          whereArgs: [chadId],
          orderBy: 'timestamp DESC',
          limit: 1);
      final chat = ChatModel.fromJson(listOfChatMaps.first);
      chat.unread = unread!;
      chat.mostRecent = LocalMessageModel.fromJson(mostRecentMessage.first);
      return chat;
    });
  }

  @override
  Future<List<LocalMessageModel>> findMessages(String ChatId) async {
    final listOfMaps = await db.query('messages',
        where: 'chat_id = ?', whereArgs: [ChatId], orderBy: 'received_at');
    var listOfMessages = listOfMaps
        .map<LocalMessageModel>((map) => LocalMessageModel.fromJson(map))
        .toList();

    listOfMessages.forEach((element) {});
    return listOfMessages;
  }

  @override
  Future<void> updateMessage(LocalMessageEntity localMessageEntity) async {
    var message = LocalMessageModel(
        chatId: localMessageEntity.chatId,
        message: localMessageEntity.message,
        receiptStatus: localMessageEntity.receiptStatus);

    int res = await db.update('messages', message.toJson(),
        where: 'id = ?',
        whereArgs: [message.message.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<bool> chatExist(String chatId) async {
    final listofChat =
        await db.query('chats', where: 'id = ?', whereArgs: [chatId]);
    if (listofChat.isEmpty) {
      return false;
    }
    return true;
  }

  @override
  Future<void> updatemessageReceipt(
      String messageId, ReceiptStatus status) async {
    // await _db.update('messages', {'receipt': status.value()},
    //     where: 'id = ?',
    //     whereArgs: [messageId],
    //     conflictAlgorithm: ConflictAlgorithm.replace);
    // await _db.execute(
    //     ''' UPDATE messages SET receipt='${status.value()}' WHERE id='$messageId' ''');
    print('Updating Status of message $messageId with ${status.value()}');
    var batch = db.batch();
    batch.update('messages', {'receipt': status.value()},
        where: 'id = ?',
        whereArgs: [messageId],
        conflictAlgorithm: ConflictAlgorithm.replace);
    await batch.commit();
  }

  @override
  Future<void> cacheChats(Map<String, dynamic> jsonData) async {
    await sharedPreferences.setString('chats', jsonEncode(jsonData));
  }

  @override
  Map<String, dynamic>? getCachedchats() {
    var jsonData = sharedPreferences.getString('chats');
    if (jsonData == null) {
      return null;
    }
    return jsonDecode(jsonData);
  }

  @override
  Future<String> saveImage(String imageFilePath) async {
    final extDir = await Directory('/storage/emulated/0/DCIM/chatapp')
        .create(recursive: true);
    File image = File(imageFilePath);
    final String imagepath =
        '${extDir.path}/${imageFilePath.substring(imageFilePath.length - 15)}';
    File newImage = await image.copy(imagepath);

    return newImage.path.toString();
  }

  @override
  Future<String> saveNetworkImage(String url) async {
    final extDir = await Directory('/storage/emulated/0/DCIM/chatapp')
        .create(recursive: true);
    var response = await Dio()
        .get(url, options: Options(responseType: ResponseType.bytes));
    String imagePath = '${extDir.path}/${url.substring(url.length - 20)}';
    final file = await File(imagePath).create(recursive: true);
    await file.writeAsBytes(response.data);
    return imagePath;
  }

  @override
  Future<void> updateMessageWithId(
      LocalMessageEntity localMessageEntity, String oldId) async {
    var message = LocalMessageModel(
        chatId: localMessageEntity.chatId,
        message: localMessageEntity.message,
        receiptStatus: localMessageEntity.receiptStatus);
    print('Updated message = ${message.message.imageStatus.value()}');
    int res = await db.update('messages', message.toJson(),
        where: 'id = ?',
        whereArgs: [oldId],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
