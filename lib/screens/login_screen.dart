// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_socks_proxy/socks_proxy.dart';
import 'package:onionchatflutter/constants.dart';
import 'package:onionchatflutter/main.dart';
import 'package:onionchatflutter/screens/post_authentication_screen.dart';
import 'package:onionchatflutter/viewmodel/login_view_model.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  static const torChannel = MethodChannel("io.github.secure.onionchat/tor");

  LoginScreen({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoggingIn = false;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _password_visible = false;

  final loginViewModel = LoginViewModel();

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      // ),
      body: GestureDetector(
        onTap: (() {
          FocusScope.of(context).requestFocus(new FocusNode());
        }),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(28),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Replace the sized box with the logo or leave it like this
                SizedBox(height: 150),
                Text(
                  'OnionChat',
                  style: TextStyle(
                    fontFamily: FontFamily_main,
                    fontSize: 56,
                    fontWeight: FontWeight.w900,
                    foreground: Paint()..shader = headingGradient,
                  ),
                ),
                const Text(
                  'Enjoy true anonymity',
                  style: TextStyle(
                    fontFamily: FontFamily_main,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: sub_heading_color,
                  ),
                ),
                const SizedBox(
                  height: 60,
                ),
                TextField(
                  scrollPadding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    hintText: 'Enter username',
                    fillColor: Color(0xffE5E5E5),
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: text_field_color, width: 3),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                  ),
                  controller: _usernameController,
                ),
                const SizedBox(
                  height: 25,
                ),
                TextField(
                  scrollPadding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  controller: _passwordController,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      enableFeedback: false,
                      splashColor: Colors.transparent,
                      icon: Icon(_password_visible
                          ? Icons.visibility_rounded
                          : Icons.visibility_off_rounded),
                      color: Color(0xff4A4A4A),
                      onPressed: () {
                        setState(() {
                          _password_visible = !_password_visible;
                        });
                      },
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    hintText: 'Enter password',
                    fillColor: Color(0xffE5E5E5),
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: text_field_color, width: 3),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                  ),
                  obscureText: !_password_visible,
                ),
                const SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                  onPressed: () async {
                    final http = createProxyHttpClient()
                      ..findProxy = (url) => 'SOCKS5 onionuser:torpass@localhost:9050';
                    http
                      .getUrl(Uri.parse('https://check.torproject.org/'))
                      .then((value) {
                        return value.close();
                      })
                      .then((value) {
                        return value.transform(utf8.decoder);
                      })
                      .then((value) {
                        return value.fold(
                          '', (dynamic previous, element) => previous + element);
                      }).then(print)
                      .catchError((e) => print("Error checking tor: $e"));
                    setState(() {
                      isLoggingIn = true;
                    });
                    final result = await loginViewModel.login(
                        _usernameController.text, _passwordController.text);
                    if (result.isLeft) {
                      final error = result.left;
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Error: ${error.message}")));
                    } else {
                      final connection = result.right;
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              "Logged in: ${connection.account.username}")));
                      Navigator.of(context).pushNamedAndRemoveUntil(PostAuthenticationScreen.routeName, (Route<dynamic> route) => false, arguments: AuthenticatedArguments(connection));
                    }
                    setState(() {
                      isLoggingIn = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                  child: Ink(
                    decoration: BoxDecoration(
                        gradient: button_gradient,
                        borderRadius: BorderRadius.circular(20)),
                    child: Container(
                      width: double.infinity,
                      height: 55,
                      child: Center(
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontFamily: FontFamily_main,
                            fontSize: 23,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 100,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'New to OnionChat? ',
                      style: TextStyle(
                        fontFamily: FontFamily_main,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff626262),
                      ),
                    ),
                    GestureDetector(
                      child: Text(
                        'Sign Up here',
                        style: TextStyle(
                          fontFamily: FontFamily_main,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Color(0xff4A4A4A),
                        ),
                      ),
                      onTap: () async {
                        try {
                          final res = await LoginScreen.torChannel.invokeMethod("startTor");
                          print("Received:: $res");
                        } catch (e) {
                          print(e);
                        }
                        //Navigator.of(context).pushNamed('/signUp');
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
