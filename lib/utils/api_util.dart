import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ec_0711/main_user_page.dart';
import 'package:flutter_ec_0711/models/product.dart';
import 'package:flutter_ec_0711/models/product_category.dart';
import 'package:flutter_ec_0711/models/shopping_car.dart';

import '../global.dart';
import '../models/account_information.dart';

class ApiUtil {
  String baseUrl = "http://172.20.10.3:5000/";

  late Dio _dio;

  ApiUtil(BuildContext context) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers["accept"] = "application/json";

        if (Global.getJwt() != null) {
          options.headers["Authorization"] = "Bearer ${Global.getJwt()}";
        }

        handler.next(options);
      },
      onError: (err, handler) async {
        final msg = err.response?.data["message"];

        if (err.response!.statusCode == 401) {
          if (err.response!.data["result_code"] == "email_or_password_incorrect") {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("帳號或密碼錯誤")));
            }
            handler.reject(err);
            return;
          }

          await Global.setJwt(null);

          if (context.mounted) {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainUserPage()), (route) => route.isFirst);
          }
          handler.reject(err);
          return;
        }

        if (err.response!.statusCode == 400) {
          if (msg == null) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("發生未知錯誤")));
            handler.reject(err);
            return;
          }
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
          handler.reject(err);
          return;
        }
      }
    ));
  }

  Future<Response> _request(String path, {required String method, Object? data}) async {
    return await _dio.request(path, options: Options(method: method), data: data);
  }

  Future<List<ProductCategory>> getProductCategory() async {
    final response = await _request("/public/product-category", method: "get");
    return (response.data["value"] as List<dynamic>).map((e) => ProductCategory.fromJson(e)).toList();
  }

  Future<List<Product>> getProducts() async {
    final response = await _request("public/product", method: "get");
    return (response.data["value"] as List<dynamic>).map((e) => Product.fromJson(e)).toList();
  }
  
  Future<AccountInformation> getAccountInfo() async {
    final response = await _request("public/account", method: "get");
    return AccountInformation.fromJson(response.data);
  }

  Future<String> login(String email, String password) async {
    final response = await _request("public/account/user-token", method: "post", data: {
      "email": email,
      "password": password
    });
    return response.data["token"];
  }

  Future<void> register(String email, String name, String password, String roleType) async {
    await _request("public/account/register", method: "post", data: {
      "email": email,
      "name": name,
      "password": password,
      "role_type": roleType
    });
  }

  Future<void> updateAccountInfo(String name) async {
    await _request("public/account", method: "put", data: {
      "name": name
    });
  }

  Future<void> updatePassword(String oldPw, String newPw) async {
    await _request("public/account/password", method: "put", data: {
      "old_password": oldPw,
      "new_password": newPw
    });
  }

  Future<dynamic> getShoppingCar() async {
    final response = await _request("buyer/shopping-car", method: "get");
    return response;
  }

  Future<void> addShoppingCar(String productId, int quantity) async {
    await _request("buyer/shopping-car", method: "post", data: {
      "product_id": productId,
      "quantity": quantity
    });
  }

  Future<void> updateShoppingCar(String shoppingCarId, int quantity) async {
    await _request("buyer/shopping-car/$shoppingCarId", method: "put", data: {
      "quantity": quantity
    });
  }
}