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
        width: 150,
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
                            height: 35,
                            width: 110,
                            decoration: BoxDecoration(
                                color: Colors.blueGrey.withOpacity(.4),
                                borderRadius: BorderRadius.circular(12)),
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 5),
                                  child: Text(
                                    'Uploading..',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  ),
                                ),
                                SizedBox(),
                                Container(
                                  height: 26,
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
      ),
    );
  }
}
