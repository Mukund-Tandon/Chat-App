import 'package:whatsapp_clone/chat/domain/entities/user_entity.dart';
import 'package:whatsapp_clone/chat/domain/repository/logged_in_user_local_cache_repository.dart';

class FetchLoggedInUser {
  final LoggedInUserLocalCacheRepository loggedInUserLocalCacheRepository;
  FetchLoggedInUser({required this.loggedInUserLocalCacheRepository});
  UserEntity? call(String key) {
    return loggedInUserLocalCacheRepository.fetch(key);
  }
}
