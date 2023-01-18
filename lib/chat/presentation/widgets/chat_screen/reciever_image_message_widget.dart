import 'package:flutter/material.dart';
import 'package:whatsapp_clone/chat/domain/entities/message_entity.dart';
import 'dart:io';

class ReceiverImageMessageWidget extends StatelessWidget {
  const ReceiverImageMessageWidget({
    Key? key,
    required this.imageStatus,
    required this.filePath,
  }) : super(key: key);
  final String filePath;
  final ImageStatus imageStatus;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          print('tab');
          if (imageStatus == ImageStatus.done) {
            showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  child: InteractiveViewer(
                    child: Container(
                      child: Image.file(
                        File(filePath),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
        child: Container(
          height: 200,
          width: 140,
          child: Stack(
            alignment: Alignment.center,
            children: [
              imageStatus != ImageStatus.done
                  ? Image.network(filePath)
                  : Image.file(File(filePath)),
              imageStatus != ImageStatus.done
                  ? Center(
                      child: Container(
                        height: 50,
                        width: 120,
                        decoration: BoxDecoration(
                            color: Colors.blueGrey.withOpacity(.5),
                            borderRadius: BorderRadius.circular(12)),
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 5),
                              child: Text(
                                'Downloading..',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 14),
                              ),
                            ),
                            SizedBox(),
                            Container(
                              height: 28,
                              width: 26,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  : Container(
                      color: Colors.transparent,
                    )
            ],
          ),
        ));
  }
}
