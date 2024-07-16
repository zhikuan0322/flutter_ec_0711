import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_ec_0711/component/fade_in_network_image.dart';

import '../models/product.dart';
import '../product_detail_page.dart';

class ProductGridView extends StatefulWidget {
  final List<Product> products;
  const ProductGridView({super.key, required this.products});

  @override
  State<ProductGridView> createState() => _ProductGridViewState();
}

class _ProductGridViewState extends State<ProductGridView> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 0.75),
        itemCount: widget.products.length,
        itemBuilder: (_, index) {
          final product = widget.products[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(context, PageRouteBuilder(
                  pageBuilder: (context, ani, secondAni) => ProductDetailPage(product: product),
                  transitionsBuilder: (context, ani, secondAni, child) {
                    final tween = Tween(
                        begin: Offset(1, 0),
                        end: Offset.zero
                    ).chain(CurveTween(curve: Curves.easeInOut));

                    return SlideTransition(position: ani.drive(tween), child: child,);
                  },
                  transitionDuration: Duration(milliseconds: 300)
              ));
            },
            child: Card(
              clipBehavior: Clip.hardEdge,
              elevation: 10,
              child: SizedBox(
                width: 192,
                height: 192,
                child: Column(
                  children: [
                    product.productMedias.isNotEmpty ? Stack(
                      children: [
                        ImageFiltered(
                          imageFilter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                          child: FadeInNetworkImage(url: product.productMedias.first.fileAgentData.url, width: 172, height: 172, fit: BoxFit.cover,),
                        ),
                        FadeInNetworkImage(url: product.productMedias.first.fileAgentData.url, width: 192, height: 192, fit: BoxFit.contain,)
                      ],
                    ) : Image.asset("assets/changli.png", width: 192, height: 192,),

                    Text(product.name, overflow: TextOverflow.ellipsis, maxLines: 1,),
                    Text("\$${product.price.toInt()}", overflow: TextOverflow.ellipsis, maxLines: 1, style: TextStyle(color: Colors.red),)
                  ],
                ),
              ),
            ),
          );
        }
    );
  }
}
