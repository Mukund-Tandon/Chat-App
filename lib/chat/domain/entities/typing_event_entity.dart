enum Typing { start, stop }

extension TypingParser on Typing {
  String value() {
    return this.toString().split('.').last;
  }

//static keyword for class level methors with can be accessed without creating an object
  static Typing fromString(String status) {
    return Typing.values.firstWhere((element) => element.value() == status);
  }
}

class TypingEventEntity {
  final String from;
  final String to;
  final Typing event;
  late String id;
  TypingEventEntity(
      {required this.from, required this.to, required this.event});
}
