import 'package:whatsapp_clone/chat/domain/repository/local_chat_repository.dart';

class SaveNetworkImage {
  final LocalChatRepository localChatRepository;
  SaveNetworkImage({required this.localChatRepository});

  Future<String> call(String url) async {
    return await localChatRepository.saveNetworkImage(url);
  }
}
