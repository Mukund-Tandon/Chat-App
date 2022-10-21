import 'package:whatsapp_clone/chat/domain/entities/user_entity.dart';

import '../../data/models/user_model.dart';

abstract class LoggedInUserLocalCacheRepository {
  Future<void> save(String key, Map<String, dynamic> json);
  UserEntity? fetch(String key);
}
