import '../../repository/message_repository.dart';

class Dispose {
  final MessageRepository messageRepository;
  Dispose(this.messageRepository);

  call() {
    messageRepository.dispose();
  }
}
