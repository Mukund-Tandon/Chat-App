import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/chat/domain/entities/cache_chat_entity.dart';
import 'package:whatsapp_clone/chat/presentation/widgets/home/profile_image.dart';

import '../../../../domain/entities/chat_entity.dart';

class CachedChatTile extends StatelessWidget {
  final CacheChats chat;
  const CachedChatTile({required this.chat});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85,
      padding: EdgeInsets.symmetric(horizontal: 7, vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              height: 85,
              alignment: Alignment.center,
              child: ProfileImage(
                imgUrl: chat.receiver.photoUrl,
                imageHeight: 52,
                imageWidth: 52,
              ),
            ),
          ),
          Expanded(
              flex: 4,
              child: Container(
                padding: EdgeInsets.only(left: 2),
                child: Column(
                  children: [
                    Container(
                      height: 40,
                      child: Row(
                        children: [
                          Text(
                            chat.receiver.username,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Spacer(),
                          Text(
                            DateFormat('h:mm a').format(chat.timestamp),
                            style: const TextStyle(
                                fontWeight: FontWeight.w300, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 250,
                          child: Text(
                            chat.contents,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                        const Spacer(),
                        // chat.unread > 0
                        //     ? ClipRRect(
                        //         borderRadius: BorderRadius.circular(50),
                        //         child: Container(
                        //           height: 18,
                        //           width: 18,
                        //           color: Color(0xff25D366),
                        //           alignment: Alignment.center,
                        //           child: Text(
                        //             chat.unread.toString(),
                        //             style: const TextStyle(
                        //                 fontSize: 12,
                        //                 fontWeight: FontWeight.w500,
                        //                 color: Colors.white),
                        //           ),
                        //         ),
                        //       )
                        Container(),
                      ],
                    )
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
