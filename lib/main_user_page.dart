import 'package:flutter/material.dart';
import 'package:flutter_ec_0711/login_page.dart';
import 'package:flutter_ec_0711/personal_page.dart';
import 'package:flutter_ec_0711/product_list_page.dart';
import 'package:flutter_ec_0711/shopping_car_page.dart';

import 'global.dart';

class MainUserPage extends StatefulWidget {
  const MainUserPage({super.key});

  @override
  State<MainUserPage> createState() => _MainUserPageState();
}

class _MainUserPageState extends State<MainUserPage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset("assets/changli.png"),
        ),
        title: Text("電商購物平臺"),
        actions: [
          IconButton(onPressed: () {
            if (Global.getJwt() != null) {
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
            } else {
              Navigator.push(context, PageRouteBuilder(
                  pageBuilder: (context, ani, secondAni) => LoginPage(),
                  transitionsBuilder: (context, ani, secondAni, child) {
                    final tween = Tween(
                        begin: Offset(0, 1),
                        end: Offset.zero
                    ).chain(CurveTween(curve: Curves.easeInOut));

                    return SlideTransition(position: ani.drive(tween), child: child,);
                  },
                  transitionDuration: Duration(milliseconds: 300)
              ));
            }
          }, icon: const Icon(Icons.shopping_cart))
        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: const [
            ProductListPage(),
            PersonalPage()
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        color: Colors.red,
        child: TabBar(
          indicator: UnderlineTabIndicator(),
          controller: _tabController,
          tabs: [
            Tab(text: "主頁", icon: Icon(Icons.home), iconMargin: EdgeInsets.zero,),
            Tab(text: "個人頁面", icon: Icon(Icons.person), iconMargin: EdgeInsets.zero,)
          ],
        ),
      ),
    );
  }
}
