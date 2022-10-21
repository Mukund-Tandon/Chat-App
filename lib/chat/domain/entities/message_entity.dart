enum ImageStatus { saving, uploading, downloading, done, notPresent }

extension ImageStatusParser on ImageStatus {
  String value() {
    return this.toString().split('.').last;
  }

//static keyword for class level methors with can be accessed without creating an object
  static ImageStatus fromString(String status) {
    return ImageStatus.values
        .firstWhere((element) => element.value() == status);
  }
}

class MessageEntity {
  final String sender;
  final String receiver;
  final DateTime timestamp;
  final String contents;
  final bool isImage;
  final ImageStatus imageStatus;
  late String id;
  MessageEntity({
    required this.imageStatus,
    required this.sender,
    required this.receiver,
    required this.timestamp,
    required this.contents,
    required this.isImage,
  });
}
