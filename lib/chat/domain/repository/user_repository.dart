import 'package:whatsapp_clone/chat/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<UserEntity> saveUserToDatabase(UserEntity userEntity);
  Future<List<UserEntity>> getOnlineUsers();
  Future<void> disconnect(UserEntity userEntity);
  Future<UserEntity?> fetch(String phoneNumber);
}
