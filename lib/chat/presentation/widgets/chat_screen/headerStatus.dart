import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/chat/presentation/widgets/home/profile_image.dart';

import 'chat_profile_image.dart';

class HeaderStatus extends StatelessWidget {
  final String username;
  final String imgurl;
  final bool typing;
  const HeaderStatus(
      {required this.imgurl, this.typing = false, required this.username});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      child: Row(
        children: [
          ProfileImage(
            imgUrl: imgurl,
            imageWidth: 45,
            imageHeight: 45,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  username.trim(),
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: typing == false
                    ? const Text('')
                    : const Text(
                        'typing..',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 18),
                      ),
              )
            ],
          )
        ],
      ),
    );
  }
}
