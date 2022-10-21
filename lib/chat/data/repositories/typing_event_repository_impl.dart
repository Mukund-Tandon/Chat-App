import 'package:whatsapp_clone/chat/data/datasources/remotedatasources/typing_event_remote_data_source.dart';
import 'package:whatsapp_clone/chat/domain/entities/typing_event_entity.dart';
import 'package:whatsapp_clone/chat/domain/entities/user_entity.dart';
import 'package:whatsapp_clone/chat/domain/repository/typing_event_repository.dart';

import '../datasources/remotedatasources/user_remote_data_source.dart';

class TypingEventRepositoryImpl implements TypingEventRepository {
  final TypingEventRemotedataSource typingEventRemotedataSource;
  final UserRemoteDataSource userRemoteDataSource;
  TypingEventRepositoryImpl(
      this.typingEventRemotedataSource, this.userRemoteDataSource);
  @override
  Stream<TypingEventEntity> getAllTypingEvents(
      UserEntity userEntity, List<String> userIds) {
    return typingEventRemotedataSource.getAllTypingEvents(userEntity, userIds);
  }

  @override
  Future<bool> sendTypingEvent(TypingEventEntity typingEventEntity) async {
    final receiver = await userRemoteDataSource.fetch(typingEventEntity.to);
    return typingEventRemotedataSource.sendTypingEvent(typingEventEntity);
  }

  @override
  dispose() {
    typingEventRemotedataSource.dispose();
  }
}
