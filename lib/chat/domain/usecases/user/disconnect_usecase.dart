import 'package:whatsapp_clone/chat/domain/entities/user_entity.dart';
import 'package:whatsapp_clone/chat/domain/repository/user_repository.dart';

class Disconnect {
  final UserRepository userRepository;
  Disconnect(this.userRepository);

  Future<void> call(UserEntity userEntity) async {
    return await userRepository.disconnect(userEntity);
  }
}
