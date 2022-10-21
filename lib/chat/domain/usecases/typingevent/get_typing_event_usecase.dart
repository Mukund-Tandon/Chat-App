import '../../entities/typing_event_entity.dart';
import '../../entities/user_entity.dart';
import '../../repository/typing_event_repository.dart';

class GetTypingEvents {
  final TypingEventRepository typingEventRepository;
  GetTypingEvents(this.typingEventRepository);

  Stream<TypingEventEntity> call(UserEntity userEntity, List<String> userIds) {
    return typingEventRepository.getAllTypingEvents(userEntity, userIds);
  }
}
