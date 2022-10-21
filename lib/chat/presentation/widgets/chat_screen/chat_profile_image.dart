import 'package:flutter/material.dart';

import 'onlineIndicator.dart';

class ProfileImageChat extends StatelessWidget {
  final String imageUrl;
  final bool online;

  const ProfileImageChat({required this.imageUrl, this.online = false});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.transparent,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(126.0),
            child: Image.network(
              imageUrl,
              width: 126,
              height: 126,
              fit: BoxFit.fill,
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: online ? const OnlineIndicator() : Container(),
          )
        ],
      ),
    );
  }
}
