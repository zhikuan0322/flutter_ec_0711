import 'package:flutter_ec_0711/models/account_information.dart';
import 'package:flutter_ec_0711/models/product_category.dart';
import 'package:flutter_ec_0711/models/product_media.dart';

class Product {
  final String productId;
  final AccountInformation seller;
  final String name;
  final String description;
  final double price;
  final int storageQuantity;
  final String sellStatus;
  final ProductCategory productCategory;
  final List<ProductMedia> productMedias;
  final List<String> tags;

  Product(
      this.productId,
      this.seller,
      this.name,
      this.description,
      this.price,
      this.storageQuantity,
      this.sellStatus,
      this.productCategory,
      this.productMedias,
      this.tags);

  Product.fromJson(Map<String, dynamic> json):
      productId = json["product_id"],
  seller = AccountInformation.fromJson(json["seller"]),
  name = json["name"],
  description = json["description"],
  price = json["price"],
  storageQuantity = json["storage_quantity"],
  sellStatus = json["sell_status"],
  productCategory = ProductCategory.fromJson(json["product_category"]),
        productMedias = (json["product_medias"] as List<dynamic>).map((e) => ProductMedia.fromJson(e)).toList(),
        tags = (json["tags"] as List<dynamic>).map((e) => e.toString()).toList();
}