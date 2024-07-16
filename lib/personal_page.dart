import 'package:flutter/material.dart';
import 'package:flutter_ec_0711/component/fade_in_network_image.dart';
import 'package:flutter_ec_0711/global.dart';
import 'package:flutter_ec_0711/login_page.dart';
import 'package:flutter_ec_0711/utils/api_util.dart';

class PersonalPage extends StatefulWidget {
  const PersonalPage({super.key});

  @override
  State<PersonalPage> createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Global.getJwt() == null ? Future.value(null) : ApiUtil(context).getAccountInfo(),
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

          final info = snapshot.data;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    height: 150,
                    child: Card(
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Container(
                              clipBehavior: Clip.hardEdge,
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black, width: 3),
                                shape: BoxShape.circle
                              ),
                              child: info == null || info.avatar == null ? Image.asset("assets/changli.png", width: 100, height: 100,) : FadeInNetworkImage(url: info!.avatar!.url, width: 100, height: 100,),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: info == null ? ElevatedButton(onPressed: (){
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
                                )).then((value) => setState(() {}));
                              }, child: Text("登入")): Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(info.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                                  Row(
                                    children: [
                                      Icon(Icons.person),
                                      Text(info.roleType),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.email),
                                      Text(info.email ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    child: Card(
                      elevation: 5,
                      child: Column(
                        children: [
                          info == null ? Container() : SizedBox(
                            height: 50,
                            child: MaterialButton(
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              onPressed: (){

                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.favorite),
                                      SizedBox(width: 10,),
                                      Text("我的最愛", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                                    ],
                                  ),
                                  const Icon(Icons.navigate_next)
                                ],
                              ),
                            ),
                          ),
                          info == null ? Container() : SizedBox(
                            height: 50,
                            child: MaterialButton(
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              onPressed: (){
                                final key = GlobalKey<FormState>();
                                final name = TextEditingController();
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text("編輯帳號"),
                                        content: Container(
                                          height: 100,
                                          child: Form(
                                            key: key,
                                            child: Column(
                                              children: [
                                                TextFormField(
                                                  controller: name,
                                                  decoration: const InputDecoration(
                                                    labelText: "暱稱",
                                                  ),
                                                  validator: (value) {
                                                    if (value == null || value.isEmpty) {
                                                      return "欄位不可為空";
                                                    }

                                                    return null;
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        actions: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              ElevatedButton(onPressed: () async {
                                                if (!key.currentState!.validate()) {
                                                  return;
                                                }

                                                await ApiUtil(context).updateAccountInfo(name.text);

                                                if (mounted) {
                                                  Navigator.pop(context);
                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("編輯帳號資訊成功")));

                                                  setState(() {

                                                  });
                                                }

                                              }, child: Text("確認編輯"))
                                            ],
                                          )
                                        ],
                                      );
                                    }
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.edit),
                                      SizedBox(width: 10,),
                                      Text("編輯帳號", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                                    ],
                                  ),
                                  const Icon(Icons.navigate_next)
                                ],
                              ),
                            ),
                          ),
                          info == null ? Container() : SizedBox(
                            height: 50,
                            child: MaterialButton(
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              onPressed: (){
                                final key = GlobalKey<FormState>();
                                final pw = TextEditingController();
                                final newPw = TextEditingController();
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text("更改密碼"),
                                        content: Container(
                                          height: 200,
                                          child: Form(
                                            key: key,
                                            child: Column(
                                              children: [
                                                TextFormField(
                                                  controller: pw,
                                                  decoration: const InputDecoration(
                                                    labelText: "舊密碼",
                                                  ),
                                                  obscureText: true ,
                                                  validator: (value) {
                                                    if (value == null || value.isEmpty) {
                                                      return "欄位不可為空";
                                                    }

                                                    return null;
                                                  },
                                                ),
                                                TextFormField(
                                                  controller: newPw,
                                                  decoration: const InputDecoration(
                                                    labelText: "新密碼",
                                                  ),
                                                  obscureText: true,
                                                  validator: (value) {
                                                    if (value == null || value.isEmpty) {
                                                      return "欄位不可為空";
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        actions: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              ElevatedButton(onPressed: () async {
                                                if (!key.currentState!.validate()) {
                                                  return;
                                                }

                                                await ApiUtil(context).updatePassword(pw.text, newPw.text);

                                                if (mounted) {
                                                  Navigator.pop(context);
                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("修改密碼成功")));

                                                  setState(() {

                                                  });
                                                }

                                              }, child: Text("確認更改密碼"))
                                            ],
                                          )
                                        ],
                                      );
                                    }
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.password),
                                      SizedBox(width: 10,),
                                      Text("修改密碼", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                                    ],
                                  ),
                                  const Icon(Icons.navigate_next)
                                ],
                              ),
                            ),
                          ),
                          info == null ? Container() : SizedBox(
                            height: 50,
                            child: MaterialButton(
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              onPressed: (){

                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.shopping_cart),
                                      SizedBox(width: 10,),
                                      Text("訂單記錄", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                                    ],
                                  ),
                                  const Icon(Icons.navigate_next)
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 50,
                            child: MaterialButton(
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              onPressed: (){

                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.settings),
                                      SizedBox(width: 10,),
                                      Text("設定", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                                    ],
                                  ),
                                  const Icon(Icons.navigate_next)
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 50,
                            child: MaterialButton(
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              onPressed: (){

                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.info),
                                      SizedBox(width: 10,),
                                      Text("關於", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                                    ],
                                  ),
                                  const Icon(Icons.navigate_next)
                                ],
                              ),
                            ),
                          ),
                          info == null ? Container() : SizedBox(
                            height: 50,
                            child: MaterialButton(
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              onPressed: () async {
                                Global.setJwt(null);
                                setState(() {

                                });

                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("登出成功")));
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.logout, color: Colors.red,),
                                      SizedBox(width: 10,),
                                      Text("登出", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.red),),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
