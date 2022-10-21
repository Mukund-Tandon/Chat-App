import 'package:whatsapp_clone/chat/domain/repository/user_repository.dart';
import 'package:whatsapp_clone/chat/domain/entities/user_entity.dart';

class FetchUserFromPhoneNumber {
  final UserRepository userRepository;
  FetchUserFromPhoneNumber({required this.userRepository});

  Future<UserEntity?> call(String phoneNumber) async {
    return await userRepository.fetch(phoneNumber);
  }
}
