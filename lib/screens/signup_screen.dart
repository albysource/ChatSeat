import 'package:flutter/material.dart';
import 'package:onionchatflutter/viewmodel/registration_view_model.dart';

import '../constants.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/signUp';
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isSigningUp = false;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _password_visible = false;

  final registrationViewModel = RegistrationViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: (() {
          FocusScope.of(context).requestFocus(FocusNode());
        }),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(28),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Replace the sized box with the logo or leave it like this
                const SizedBox(height: 150),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Create new username',
                      style: form_heading,
                    ),
                    Text(
                      'minimum 5 characters',
                      style: form_heading,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  scrollPadding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  decoration: const InputDecoration(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Create new password', style: form_heading),
                    Text('minimum 7 characters', style: form_heading),
                  ],
                ),
                const SizedBox(height: 10),

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
                      color: const Color(0xff4A4A4A),
                      onPressed: () {
                        setState(() {
                          _password_visible = !_password_visible;
                        });
                      },
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    hintText: 'Enter password',
                    fillColor: const Color(0xffE5E5E5),
                    filled: true,
                    focusedBorder: const OutlineInputBorder(
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
                  // add the sign up function here
                  onPressed: () async {
                    setState(() {
                      isSigningUp = true;
                    });
                    final username = _usernameController.text;
                    final password = _passwordController.text;
                    final result = await registrationViewModel.register(
                        username, password);
                    if (result.isLeft) {
                      final error = result.left;
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Connection failed: ${error.message}")));
                    } else {
                      final registrationResult = result.right;
                      if (registrationResult.isLeft) {
                        final error = registrationResult.left;
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Error: ${error.code} - ${error.name}")));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                "Successfully registered! Welcome, $username!")));
                      }
                    }
                    setState(() {
                      isSigningUp = false;
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
                    child: const SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: Center(
                        child: Text(
                          'Sign Up',
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
                    const Text(
                      'Already have an account? ',
                      style: TextStyle(
                        fontFamily: FontFamily_main,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff626262),
                      ),
                    ),
                    GestureDetector(
                      child: const Text(
                        'Login here',
                        style: TextStyle(
                          fontFamily: FontFamily_main,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Color(0xff4A4A4A),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
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
