import 'package:flutter/material.dart';
import 'package:whatsapp_clone/chat/domain/entities/message_entity.dart';
import 'dart:io';

class ReceiverImageMessageWidget extends StatelessWidget {
  const ReceiverImageMessageWidget(
      {Key? key, required this.imageStatus, required this.filePath})
      : super(key: key);
  final String filePath;
  final ImageStatus imageStatus;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: Alignment.center,
        children: [
          imageStatus != ImageStatus.done
              ? Image.network(filePath)
              : Image.file(File(filePath)),
          imageStatus != ImageStatus.done
              ? Center(
                  child: imageStatus == ImageStatus.saving
                      ? const SizedBox(
                          height: 50,
                          width: 50,
                          child: CircularProgressIndicator(),
                        )
                      : const SizedBox(
                          height: 50,
                          width: 90,
                          child: Text('Loading'),
                        ),
                )
              : Container(
                  color: Colors.transparent,
                )
        ],
      ),
    );
  }
}
