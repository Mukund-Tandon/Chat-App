import 'package:whatsapp_clone/chat/domain/entities/typing_event_entity.dart';

class TypingEventModel extends TypingEventEntity {
  TypingEventModel(
      {required String from, required String to, required Typing event})
      : super(from: from, to: to, event: event);

  Map<String, dynamic> toJson() {
    return {'from': from, 'to': to, 'event': event.value()};
  }

  factory TypingEventModel.fromJson(Map<String, dynamic> json) {
    var event = TypingEventModel(
        from: json['from'],
        to: json['to'],
        event: TypingParser.fromString(json['event']));
    event.id = json['id'];
    return event;
  }
}
