import 'dart:convert';
import 'package:banksampah/model/loginResponModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:banksampah/dashboard.dart';
import 'package:banksampah/register.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class login extends StatefulWidget {
  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  late Future<String> name, token;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name = _prefs.then((SharedPreferences prefs) {
      return prefs.getString("name") ?? "";
    });
    token = _prefs.then((SharedPreferences prefs) {
      return prefs.getString("token") ?? "";
    });
  }

  void looginProces(String email, String password) async {
    LoginResponseModel? loginResponseModel;
    if (email.isEmpty || password.isEmpty) {
      Alert(context: context, title: "Data Harap Diisi", type: AlertType.error)
          .show();
      return;
    }
    try {
      Response response =
          await post(Uri.parse('http://127.0.0.1:8000/api/login'), body: {
        'email': email,
        'password': password,
      });
      if (response.statusCode == 200) {
        loginResponseModel =
            LoginResponseModel.fromJson(json.decode(response.body));
        saveUser(loginResponseModel.data.token, loginResponseModel.data.name);
        //
      } else {
        Alert(
                context: context,
                title: "Pasword Dan Email Tidak ditemukan",
                type: AlertType.error)
            .show();
        print('response failed');
        return;
      }
    } catch (e) {
      print(e.toString());
    }
  }
S
  Future saveUser(token, name) async {
    final SharedPreferences pref = await _prefs;
    pref.setString("name", name);
    pref.setString("token", token);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => menu()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xFF1AD443),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/bwi.png',
                    height: 100,
                    width: 100,
                  ),
                ],
              ),
            ),
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(100)),
              ),
              child: Padding(
                padding: EdgeInsets.all(30),
                child: Column(
                  children: <Widget>[
                    Text(
                      "login",
                      style: TextStyle(
                        color: Colors.brown,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(
                      height: 80,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromRGBO(181, 182, 181, 1),
                                blurRadius: 20,
                                offset: Offset(0, 1))
                          ]),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: TextField(
                              controller: emailController,
                              decoration: InputDecoration(
                                  hintText: "Email", border: InputBorder.none),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromRGBO(181, 182, 181, 1),
                                blurRadius: 20,
                                offset: Offset(0, 1))
                          ]),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: TextField(
                              obscureText: true,
                              controller: passwordController,
                              decoration: InputDecoration(
                                  hintText: "Password",
                                  border: InputBorder.none),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 80,
                    ),
                    Container(
                      child: MaterialButton(
                        height: 40,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                        color: Color(0xFF1AD443),
                        onPressed: () {
                          looginProces(emailController.text.toString(),
                              passwordController.text.toString());
                        },
                        child: Center(
                            child: Text(
                          "Login",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        )),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => register()),
                          );
                        },
                        child: Text(
                          "Belum Punya Akun",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
