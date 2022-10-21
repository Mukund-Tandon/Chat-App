import 'package:whatsapp_clone/chat/domain/entities/local_message_entity.dart';
import 'package:whatsapp_clone/chat/domain/entities/user_entity.dart';

class ChatEntity {
  String id;
  int unread = 0;
  late List<LocalMessageEntity> messages = [];
  late LocalMessageEntity mostRecent;
  late UserEntity from;
  ChatEntity(this.id);
}
