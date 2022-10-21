import 'package:whatsapp_clone/chat/domain/entities/typing_event_entity.dart';
import 'package:whatsapp_clone/chat/domain/entities/user_entity.dart';

abstract class TypingEventRepository {
  Future<bool> sendTypingEvent(TypingEventEntity typingEventEntity);
  Stream<TypingEventEntity> getAllTypingEvents(
      UserEntity userEntity, List<String> userIds);
  dispose();
}
