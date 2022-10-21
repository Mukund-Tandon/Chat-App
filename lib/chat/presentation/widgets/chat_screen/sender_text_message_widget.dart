import 'package:flutter/material.dart';

class TextMessageWidget extends StatelessWidget {
  const TextMessageWidget({Key? key, required this.contents}) : super(key: key);
  final String contents;
  @override
  Widget build(BuildContext context) {
    return Text(
      contents,
      softWrap: true,
      style: const TextStyle(
        color: Colors.black,
      ),
    );
  }
}
