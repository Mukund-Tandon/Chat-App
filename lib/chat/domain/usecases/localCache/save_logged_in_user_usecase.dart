import 'package:whatsapp_clone/chat/domain/repository/logged_in_user_local_cache_repository.dart';

class SaveLoggedInUser {
  final LoggedInUserLocalCacheRepository loggedInUserLocalCacheRepository;
  SaveLoggedInUser({required this.loggedInUserLocalCacheRepository});

  Future<void> call(String key, Map<String, dynamic> json) async {
    await loggedInUserLocalCacheRepository.save(key, json);
  }
}
