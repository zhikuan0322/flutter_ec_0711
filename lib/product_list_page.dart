import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_ec_0711/component/product_grid_view.dart';
import 'package:flutter_ec_0711/component/product_list_view.dart';
import 'package:flutter_ec_0711/utils/api_util.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  var category = "";
  var isGridMode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 250,
                    child: FutureBuilder(
                      future: ApiUtil(context).getProductCategory(),
                      builder: (_, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Container();
                        }

                        if (snapshot.hasError) {
                          return Container();
                        }

                        final result = snapshot.requireData.map((e) => DropdownMenuItem(value: e.productCategoryId,child: Text(e.name),)).toList();
                        result.insert(0, const DropdownMenuItem(value: "",child: Text(""),));
                        return DropdownButton(value: category, items: result, onChanged: (value) {
                          category = value!;
                          setState(() {

                          });
                        });
                      },
                    ),
                  ),
                  IconButton(onPressed: isGridMode ? null : () {
                    setState(() {
                      isGridMode = true;
                    });
                  }, icon: Icon(Icons.image), disabledColor: Colors.black, color: Colors.grey),
                  IconButton(onPressed: isGridMode ? () {
                    setState(() {
                      isGridMode = false;
                    });
                  } : null, icon: Icon(Icons.list), disabledColor: Colors.black, color: Colors.grey,),
                ],
              ),
              Expanded(
                child: FutureBuilder(
                  future: ApiUtil(context).getProducts(),
                  builder: (_, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          children: [
                            Text("無法連接伺服器", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                            ElevatedButton(onPressed: () {
                              setState(() {

                              });
                            }, child: Text("重新連線"))
                          ],
                        ),
                      );
                    }

                    var products = snapshot.requireData;

                    if (category.isNotEmpty) {
                      products = products.where((element) => element.productCategory.productCategoryId == category).toList();
                    }

                    return isGridMode ? ProductGridView(products: products,) : ProductListView(products: products);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
