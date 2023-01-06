import 'package:flutter/material.dart';
import 'package:whatsapp_clone/chat/domain/entities/local_message_entity.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/chat/domain/entities/receipt_entity.dart';
import 'package:whatsapp_clone/chat/presentation/widgets/chat_screen/sender_image_message_widget.dart';
import 'package:whatsapp_clone/chat/presentation/widgets/chat_screen/sender_text_message_widget.dart';

class SenderMessageBubble extends StatelessWidget {
  final LocalMessageEntity localMessageEntity;
  const SenderMessageBubble({Key? key, required this.localMessageEntity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      alignment: Alignment.centerRight,
      widthFactor: 0.75,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(20.0),
                    bottomLeft: Radius.circular(20.0),
                    topLeft: Radius.circular(20.0)),
                color: Color(0xffE7FFDB),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    localMessageEntity.message.isImage
                        ? SenderImageMessageWidget(
                            imageStatus: localMessageEntity.message.imageStatus,
                            filePath: localMessageEntity.message.contents)
                        : TextMessageWidget(
                            contents: localMessageEntity.message.contents),
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
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.check_circle_rounded,
                          color: localMessageEntity.receiptStatus ==
                                  ReceiptStatus.read
                              ? Colors.green[700]
                              : Colors.grey,
                          size: 15.0,
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
