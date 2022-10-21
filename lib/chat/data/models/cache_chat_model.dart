import 'package:whatsapp_clone/chat/data/models/user_model.dart';
import 'package:whatsapp_clone/chat/domain/entities/cache_chat_entity.dart';
import 'package:whatsapp_clone/chat/domain/entities/user_entity.dart';

class CacheChatModel extends CacheChats {
  CacheChatModel(
      {required UserEntity receiver,
      required DateTime timestamp,
      required int unread,
      required String contents})
      : super(
            receiver: receiver,
            timestamp: timestamp,
            unread: unread,
            contents: contents);

  factory CacheChatModel.fromJson(Map<String, dynamic> json) {
    UserModel receiver = UserModel(
        username: json['username'],
        photoUrl: json['photourl'],
        phoneNumber: json['id']);
    return CacheChatModel(
        receiver: receiver,
        contents: json['contents'],
        unread: json['unread'],
        timestamp: DateTime.parse(json['timestamp']));
  }
}
