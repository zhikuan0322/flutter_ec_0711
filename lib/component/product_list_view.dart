import 'package:flutter/material.dart';
import 'package:flutter_ec_0711/component/fade_in_network_image.dart';
import 'package:flutter_ec_0711/product_detail_page.dart';

import '../models/product.dart';

class ProductListView extends StatefulWidget {
  final List<Product> products;
  const ProductListView({super.key, required this.products});

  @override
  State<ProductListView> createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
          child: ListTile(
            leading: product.productMedias.isNotEmpty ? FadeInNetworkImage(url: product.productMedias.first.fileAgentData.url, width: 50, height: 50, fit: BoxFit.contain,)
                : Image.asset("assets/changli.png"),
            title: Text(product.name, overflow: TextOverflow.ellipsis, maxLines: 1,),
            subtitle: Text(product.description, overflow: TextOverflow.ellipsis, maxLines: 2,),
            trailing: Text("\$${product.price.toInt()}", style: TextStyle(color: Colors.red),),
          ),
        );
      },
    );
  }
}
