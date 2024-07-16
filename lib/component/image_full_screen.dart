import 'package:flutter/material.dart';
import 'package:flutter_ec_0711/component/fade_in_network_image.dart';

import '../models/product_media.dart';

class ImageFullScreen extends StatefulWidget {
  final List<ProductMedia> medias;
  final int index;
  const ImageFullScreen({super.key, required this.medias, required this.index});

  @override
  State<ImageFullScreen> createState() => _ImageFullScreenState();
}

class _ImageFullScreenState extends State<ImageFullScreen> {
  var currentPage = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.index);
    currentPage = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, currentPage);
        return false;
      },
      child: Scaffold(
        body: Container(
          color: Colors.black,
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                itemBuilder: (_, index) {
                  return FadeInNetworkImage(url: widget.medias[index].fileAgentData.url, fit: BoxFit.contain,);
                },
                itemCount: widget.medias.length,
                onPageChanged: (value){
                  setState(() {
                    currentPage = value;
                  });
                },
              ),
              Positioned(
                left: 10,
                top: 50,
                child: IconButton(onPressed: () {
                  Navigator.pop(context, currentPage);
                }, icon: Icon(Icons.arrow_back, size: 30, color: Colors.red,)),
              ),
              Positioned(
                bottom: 50,
                right: MediaQuery.of(context).size.width / 2.5,
                child: Align(
                  alignment: Alignment.center,
                  child: Row(
                    children: List.generate(widget.medias.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: SizedBox(
                          width: 16,
                          height: 16,
                          child: InkWell(
                            child: ClipOval(
                              child: Container(
                                color: currentPage == index ? Colors.red : Colors.white,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                currentPage = index;
                              });
                            },
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
