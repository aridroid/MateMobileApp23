import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MediaViewer extends StatelessWidget {
  final String url;
  final bool isGif;
  const MediaViewer({Key? key, required this.url, this.isGif=false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: const Key('key'),
      direction: DismissDirection.vertical,
      onDismissed: (_) => Navigator.of(context).pop(),
      child: SafeArea(
        child: Scaffold(
          body: Center(
            child: CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.contain,
                placeholder: (context, url) => Center(child: SizedBox(width: 30,height: 30,child: CircularProgressIndicator())),
                errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
        ),
      ),
    );
  }
}
