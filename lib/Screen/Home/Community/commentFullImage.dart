import 'dart:io';

import 'package:flutter/material.dart';

class CommentFullImage extends StatelessWidget {
  final String imageNetworkPath;
  final File imageFilePath;

  const CommentFullImage({Key key, this.imageNetworkPath, this.imageFilePath}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        onTap: () => Navigator.pop(context),
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: imageNetworkPath!=null?
          Image.network(
            imageNetworkPath,
            fit: BoxFit.contain,
            // height: 300,
            // width: 400,
          ):Image.file(
            imageFilePath,
            fit: BoxFit.contain,
            // height: 300,
            // width: 400,
          ),
        ),
      ),
    );
  }
}
