import 'package:flutter/material.dart';
import 'package:whatsapp_clone/chat/domain/entities/local_message_entity.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/chat/domain/entities/receipt_entity.dart';
import 'package:whatsapp_clone/chat/presentation/widgets/chat_screen/reciever_image_message_widget.dart';
import 'package:whatsapp_clone/chat/presentation/widgets/chat_screen/sender_image_message_widget.dart';
import 'package:whatsapp_clone/chat/presentation/widgets/chat_screen/sender_text_message_widget.dart';

class ReceiverMessageBubble extends StatelessWidget {
  final LocalMessageEntity localMessageEntity;
  final String receiverUsername;
  const ReceiverMessageBubble({
    Key? key,
    required this.localMessageEntity,
    required this.receiverUsername,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      alignment: Alignment.centerLeft,
      widthFactor: 0.75,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(20.0),
                  bottomLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    localMessageEntity.message.isImage
                        ? ReceiverImageMessageWidget(
                            imageStatus: localMessageEntity.message.imageStatus,
                            filePath: localMessageEntity.message.contents,
                          )
                        : TextMessageWidget(
                            contents: localMessageEntity.message.contents,
                          ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          DateFormat('h:mm a')
                              .format(localMessageEntity.message.timestamp),
                          style: const TextStyle(
                              color: Colors.black38, fontSize: 12),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
