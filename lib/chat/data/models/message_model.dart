import 'package:whatsapp_clone/chat/domain/entities/message_entity.dart';

class MessageModel extends MessageEntity {
  MessageModel(
      {required ImageStatus imageStatus,
      required String sender,
      required String receiver,
      required DateTime timestamp,
      required String contents,
      required bool isImage})
      : super(
            imageStatus: imageStatus,
            sender: sender,
            receiver: receiver,
            timestamp: timestamp,
            contents: contents,
            isImage: isImage);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> res = {
      'sender': sender,
      'receiver': receiver,
      'timestamp': timestamp.toString(),
      'contents': contents,
      'isImage': isImage,
      'imageStatus': imageStatus.value(),
    };

    return res;
  }

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    var message = MessageModel(
      sender: json['sender'],
      receiver: json['receiver'],
      timestamp: DateTime.parse(json['timestamp']),
      contents: json['contents'],
      isImage: json['isImage'],
      imageStatus: ImageStatusParser.fromString(json['imageStatus']),
    );
    message.id = json['id'];

    return message;
  }
}
