import 'package:whatsapp_clone/chat/data/models/user_model.dart';
import 'package:whatsapp_clone/chat/domain/entities/cache_chat_entity.dart';
import 'package:whatsapp_clone/chat/domain/entities/user_entity.dart';

class CacheChatModel extends CacheChats {
  CacheChatModel(
      {required UserEntity receiver,
      required DateTime timestamp,
      required int unread,
      required String contents,
      required bool isImage})
      : super(
            receiver: receiver,
            timestamp: timestamp,
            unread: unread,
            contents: contents,
            isImage: isImage);

  factory CacheChatModel.fromJson(Map<String, dynamic> json) {
    bool isImage = true;
    if (json['isImage'] == 'false') {
      isImage = false;
    }
    UserModel receiver = UserModel(
        username: json['username'],
        photoUrl: json['photourl'],
        phoneNumber: json['id']);
    return CacheChatModel(
        receiver: receiver,
        contents: json['contents'],
        unread: json['unread'],
        timestamp: DateTime.parse(
          json['timestamp'],
        ),
        isImage: isImage);
  }
}
