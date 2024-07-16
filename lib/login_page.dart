import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ec_0711/register_page.dart';
import 'package:flutter_ec_0711/utils/api_util.dart';

import 'global.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _key = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _pw = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back)),
        title: Text("登入"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset("assets/changli.png", width: 200, height: 200,),
                ),
                Text("電商購物平台", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
                  child: Form(
                    key: _key,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _email,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "電子郵件",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "欄位不可為空";
                            }

                            if (!(value.contains("@") && value.contains("."))) {
                              return "電子郵件格式錯誤";
                            }

                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _pw,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "密碼",
                          ),
                          obscureText: true ,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "欄位不可為空";
                            }

                            return null;
                          },
                        ),
                        SizedBox(width: 150, child: ElevatedButton(onPressed: () async {
                          if (!_key.currentState!.validate()) {
                            return;
                          }

                          final jwt = await ApiUtil(context).login(_email.text, _pw.text);
                          await Global.setJwt(jwt);

                          if (mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("登入成功")));
                          }
                        }, child: Text("登入"))),
                        SizedBox(width: 150, child: ElevatedButton(onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));
                        }, child: Text("註冊"))),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
