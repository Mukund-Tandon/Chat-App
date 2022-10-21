import 'package:whatsapp_clone/chat/domain/entities/user_entity.dart';

class CacheChats {
  String contents;
  int unread;
  UserEntity receiver;

  DateTime timestamp;
  CacheChats(
      {required this.receiver,
      required this.timestamp,
      required this.unread,
      required this.contents});
}
