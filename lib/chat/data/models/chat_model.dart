import 'package:whatsapp_clone/chat/domain/entities/chat_entity.dart';
import 'package:whatsapp_clone/chat/domain/entities/local_message_entity.dart';

class ChatModel extends ChatEntity {
  ChatModel(String id) : super(id);
  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(json['id']);
  }
}
