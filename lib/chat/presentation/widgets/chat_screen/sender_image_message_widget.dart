import 'package:flutter/material.dart';
import 'package:whatsapp_clone/chat/domain/entities/message_entity.dart';
import 'dart:io';

class SenderImageMessageWidget extends StatelessWidget {
  const SenderImageMessageWidget(
      {Key? key, required this.imageStatus, required this.filePath})
      : super(key: key);
  final String filePath;
  final ImageStatus imageStatus;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 140,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.file(File(filePath)),
          imageStatus != ImageStatus.done
              ? Center(
                  child: imageStatus == ImageStatus.saving
                      ? const SizedBox(
                          height: 50,
                          width: 50,
                          child: CircularProgressIndicator(),
                        )
                      : Container(
                          height: 50,
                          width: 100,
                          decoration:
                              BoxDecoration(color: Colors.red.withOpacity(.4)),
                          child: Text(
                            'UpLoading',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
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
