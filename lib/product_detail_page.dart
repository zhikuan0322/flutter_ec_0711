import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_ec_0711/component/fade_in_network_image.dart';
import 'package:flutter_ec_0711/component/image_full_screen.dart';
import 'package:flutter_ec_0711/models/product.dart';
import 'package:flutter_ec_0711/shopping_car_page.dart';
import 'package:flutter_ec_0711/utils/api_util.dart';

import 'models/product_media.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;
  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late List<ProductMedia> _medias;
  late PageController _pageController;
  var currentPage = 0;

  @override
  void initState() {
    super.initState();

    _medias = widget.product.productMedias.where((element) => element.fileAgentData.mimeType.startsWith("image/")).toList();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    final pages = List.generate(_medias.length, (index) {
      return GestureDetector(
        onTap: () async {
          final result = await Navigator.push(context, PageRouteBuilder(
              pageBuilder: (context, ani, secondAni) => ImageFullScreen(medias: _medias, index: currentPage),
              transitionsBuilder: (context, ani, secondAni, child) {
                final tween = Tween(
                    begin: Offset(1, 0),
                    end: Offset.zero
                ).chain(CurveTween(curve: Curves.easeInOut));

                return SlideTransition(position: ani.drive(tween), child: child,);
              },
              transitionDuration: Duration(milliseconds: 300)
          ));

          setState(() {
            _pageController.jumpToPage(result);
          });
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            ImageFiltered(imageFilter: ImageFilter.blur(sigmaY: 5.0, sigmaX: 5.0), child: FadeInNetworkImage(url: _medias[index].fileAgentData.url, width: double.infinity, height: double.infinity, fit: BoxFit.cover,),),
            FadeInNetworkImage(url: _medias[index].fileAgentData.url, width: double.infinity, height: double.infinity, fit: BoxFit.contain,)
          ],
        ),
      );
    });

    final list = List.generate(_medias.length, (index) {
      return GestureDetector(
        onTap: () {
          _pageController.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.easeInCubic);
        },
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            border: Border.all(color: currentPage == index ? Colors.red : Colors.black, width: 2),
            borderRadius: BorderRadius.circular(8)
          ),
          child: FadeInNetworkImage(url: _medias[index].fileAgentData.url, width: double.infinity, height: double.infinity, fit: BoxFit.contain,),
        ),
      );
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon: const Icon(Icons.arrow_back)),
        title: Text("${widget.product.name} - 商品詳情"),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 2.5,
                    child: _medias.isNotEmpty ? PageView.builder(
                      controller: _pageController,
                      itemBuilder: (_, index) {
                        return pages[index];
                      },
                      itemCount: pages.length,
                      onPageChanged: (value) {
                        setState(() {
                          currentPage = value;
                        });
                      },
                    ) : Image.asset("assets/changli.png")
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(36),
                      child: Container(
                        width: 50,
                        height: 20,
                        color: Colors.white.withOpacity(0.5),
                        child: Center(
                          child: Text(_medias.isEmpty ? "1/1" : "${currentPage + 1} / ${_medias.length}"),
                        ),
                      ),
                    ),
                  )
                ]
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_medias[currentPage].description, style: TextStyle(fontWeight: FontWeight.bold),),
                    SizedBox(height: 10,),
                    SizedBox(
                      width: double.infinity,
                      height: 80,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (_, index) {
                          return list[index];
                        },
                        separatorBuilder: (_, index) => SizedBox(width: 10,),
                        itemCount: _medias.length
                      ),
                    ),
                    Divider(color: Colors.black,),
                    Text("賣家資訊", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        widget.product.seller.avatar != null ? FadeInNetworkImage(url: widget.product.seller.avatar!.url, width: 80, height: 80, fit: BoxFit.contain,)
                            : Image.asset("assets/changli.png", width: 80, height: 80, fit: BoxFit.contain,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.product.seller.name, style: TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 1,),
                              Row(
                                children: [
                                  Icon(Icons.email, size: 20,),
                                  Text(widget.product.seller.email, overflow: TextOverflow.ellipsis, maxLines: 1,)
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Divider(color: Colors.black,),
                    Text("商品詳細", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                    SizedBox(height: 10,),
                    Text("商品類別: ${widget.product.productCategory.name}"),
                    widget.product.tags.isNotEmpty ? Text("商品標籤: ${widget.product.tags.join(",")}") : Container(),
                    Text("商品庫存: ${widget.product.productCategory.name}"),
                    SizedBox(height: 10,),
                    Text("商品備註", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                    SizedBox(height: 10,),
                    Text(widget.product.description)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.red,
        height: 50,
        child: Row(
          children: [
            GestureDetector(
              onTap: () async {
                await ApiUtil(context).addShoppingCar(widget.product.productId, 1);

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("加入購物車成功")));
                }
              },
              child: Container(
                width: 100,
                color: Colors.green,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_cart, size: 20, color: Colors.white,),
                    Text("加入購物車", style: TextStyle(color: Colors.white, fontSize: 12),)
                  ],
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  await ApiUtil(context).addShoppingCar(widget.product.productId, 1);

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("加入購物車成功")));

                    Navigator.push(context, PageRouteBuilder(
                        pageBuilder: (context, ani, secondAni) => ShoppingCarPage(),
                        transitionsBuilder: (context, ani, secondAni, child) {
                          final tween = Tween(
                              begin: Offset(1, 0),
                              end: Offset.zero
                          ).chain(CurveTween(curve: Curves.easeInOut));

                          return SlideTransition(position: ani.drive(tween), child: child,);
                        },
                        transitionDuration: Duration(milliseconds: 300)
                    ));
                  }
                },
                child: Center(child: Text("直接購買", style: TextStyle(color: Colors.white),))
              ),
            )
          ],
        ),
      ),
    );
  }
}
