import 'package:whatsapp_clone/chat/data/datasources/remotedatasources/user_remote_data_source.dart';
import 'package:whatsapp_clone/chat/domain/entities/user_entity.dart';
import 'package:whatsapp_clone/chat/domain/repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource userRemoteDataSource;
  UserRepositoryImpl(this.userRemoteDataSource);
  @override
  Future<UserEntity> saveUserToDatabase(UserEntity userEntity) async {
    return await userRemoteDataSource.connect(userEntity);
  }

  @override
  Future<void> disconnect(UserEntity userEntity) async {
    await userRemoteDataSource.disconnect(userEntity);
  }

  @override
  Future<List<UserEntity>> getOnlineUsers() async {
    return await userRemoteDataSource.getOnlineUsers();
  }

  @override
  Future<UserEntity?> fetch(String id) async {
    var user = await userRemoteDataSource.fetch(id);
    return user;
  }

  @override
  Future<void> register(String phoneNumber) {
    // TODO: implement register
    throw UnimplementedError();
  }

  @override
  Future<void> signIn(String phoneNumber) {
    // TODO: implement signIn
    throw UnimplementedError();
  }

  @override
  Future<bool> verifyOTP(String otp) {
    // TODO: implement verifyOTP
    throw UnimplementedError();
  }
}
