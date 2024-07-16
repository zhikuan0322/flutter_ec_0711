import 'dart:ffi';

import 'package:flutter/material.dart';

class FadeInNetworkImage extends StatefulWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit? fit;
  const FadeInNetworkImage({super.key, required this.url, this.width, this.height, this.fit});

  @override
  State<FadeInNetworkImage> createState() => _FadeInNetworkImageState();
}

class _FadeInNetworkImageState extends State<FadeInNetworkImage> {
  @override
  Widget build(BuildContext context) {
    return FadeInImage.assetNetwork(
      placeholder: "assets/changli.png",
      image: widget.url,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      imageErrorBuilder: (context, err, stack) {
        return Image.asset("assets/changli.png");
      },
    );
  }
}
