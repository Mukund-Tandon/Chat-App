import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {
  final String imgUrl;
  final double imageWidth;
  final double imageHeight;
  ProfileImage(
      {required this.imgUrl,
      required this.imageHeight,
      required this.imageWidth});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.transparent,
      radius: 26,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(52),
        child: Image.network(
          imgUrl,
          width: imageWidth,
          height: imageHeight,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
