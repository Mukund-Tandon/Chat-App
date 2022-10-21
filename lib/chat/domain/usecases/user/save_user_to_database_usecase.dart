import 'package:whatsapp_clone/chat/domain/entities/user_entity.dart';
import 'package:whatsapp_clone/chat/domain/repository/user_repository.dart';

class SaveUserToDatabase {
  final UserRepository userRepository;
  SaveUserToDatabase(this.userRepository);

  Future<UserEntity> call(UserEntity userEntity) async {
    return await userRepository.saveUserToDatabase(userEntity);
  }
}
