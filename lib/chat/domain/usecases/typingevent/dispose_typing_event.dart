import 'package:whatsapp_clone/chat/domain/repository/typing_event_repository.dart';

class DisposeTypingEvent {
  final TypingEventRepository typingEventRepository;
  DisposeTypingEvent(this.typingEventRepository);

  call() {
    typingEventRepository.dispose();
  }
}
