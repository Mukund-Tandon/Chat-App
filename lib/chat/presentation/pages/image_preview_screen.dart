import 'package:flutter/material.dart';
import 'dart:io';

class ImagePreviewScreen extends StatelessWidget {
  const ImagePreviewScreen({Key? key, required this.imageFile})
      : super(key: key);
  final File imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Image.file(imageFile),
          const RawMaterialButton(
            fillColor: Colors.red,
            onPressed: null,
            shape: CircleBorder(),
          )
        ],
      ),
    );
  }
}
