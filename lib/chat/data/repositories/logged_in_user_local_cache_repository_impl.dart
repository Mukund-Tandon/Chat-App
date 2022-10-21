import 'package:whatsapp_clone/chat/data/datasources/localdatasources/logged_in_user_local_cache_datasource.dart';
import 'package:whatsapp_clone/chat/domain/entities/user_entity.dart';

import '../../domain/repository/logged_in_user_local_cache_repository.dart';

class LoggedInUserLocalCacheRepositoryImpl
    implements LoggedInUserLocalCacheRepository {
  final LoggedInUserLocalCacheDataSource loggedInUserLocalCacheDataSource;

  LoggedInUserLocalCacheRepositoryImpl(
      {required this.loggedInUserLocalCacheDataSource});

  @override
  UserEntity? fetch(String key) {
    Map<String, dynamic>? map = loggedInUserLocalCacheDataSource.fetch(key);
    if (map == null)
      return null;
    else {
      UserEntity user = UserEntity(
          username: map['username'],
          photoUrl: map['photo_url'],
          phoneNumber: map['phoneNumber']);
      return user;
    }
  }

  @override
  Future<void> save(String key, Map<String, dynamic> json) async {
    await loggedInUserLocalCacheDataSource.save(key, json);
  }
}
