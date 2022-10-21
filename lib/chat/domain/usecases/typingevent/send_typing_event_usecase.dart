import '../../entities/typing_event_entity.dart';
import '../../entities/user_entity.dart';
import '../../repository/typing_event_repository.dart';

class SendTypingEvents {
  final TypingEventRepository typingEventRepository;
  SendTypingEvents(this.typingEventRepository);

  Future<bool> call(TypingEventEntity typingEventEntity) {
    return typingEventRepository.sendTypingEvent(typingEventEntity);
  }
}
