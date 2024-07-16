import 'package:flutter/material.dart';
import 'package:flutter_ec_0711/utils/api_util.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _key = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _name = TextEditingController();
  final _pw = TextEditingController();
  final _confirmPw = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back)),
        title: Text("註冊"),
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
                          controller: _name,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "暱稱",
                          ),
                          obscureText: true ,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "欄位不可為空";
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

                            if (_pw.text != _confirmPw.text) {
                              return "密碼與確認密碼不同";
                            }

                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _confirmPw,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "確認密碼",
                          ),
                          obscureText: true ,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "欄位不可為空";
                            }

                            if (_pw.text != _confirmPw.text) {
                              return "密碼與確認密碼不同";
                            }

                            return null;
                          },
                        ),
                        SizedBox(width: 150, child: ElevatedButton(onPressed: () async {
                          if (!_key.currentState!.validate()) {
                            return;
                          }

                          await ApiUtil(context).register(_email.text, _name.text, _pw.text, "buyer");

                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("註冊成功")));
                            Navigator.pop(context);
                          }
                        }, child: Text("確認註冊"))),
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
