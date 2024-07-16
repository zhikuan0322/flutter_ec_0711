import 'package:flutter/material.dart';
import 'package:flutter_ec_0711/utils/api_util.dart';

class ShoppingCarPage extends StatefulWidget {
  const ShoppingCarPage({super.key});

  @override
  State<ShoppingCarPage> createState() => _ShoppingCarPageState();
}

class _ShoppingCarPageState extends State<ShoppingCarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon: const Icon(Icons.arrow_back)),
        title: Text("購物車"),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: FutureBuilder(
            future: ApiUtil(context).getShoppingCar(),
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

              return Container(
                child: Text(snapshot.requireData.toString(), style: TextStyle(fontSize: 10),),
              );
            },
          ),
        ),
      ),
    );
  }
}
