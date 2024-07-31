import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:to_do_list/Screens/todolis_main_screen.dart';
import 'package:to_do_list/Services/google_loggin.dart';
import 'package:to_do_list/componets/MyTextField.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;

  // Sign In Method
  void signInUser() async {
    try {
      setState(() {
        _isLoading = true;
      });

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ToDoScreen()));
      setState(() {
        _isLoading = false;
      });
    } on FirebaseAuthException catch (e) {
      ShowErrorMsg(e.code);
      setState(() {
        _isLoading = false;
      });
    }
  }
  //ShowErrorMsg

  void ShowErrorMsg(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.grey[300],
            title: Center(
              child: Text(
                message,
                style: TextStyle(color: Colors.black),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40),
                // Logo

                SizedBox(height: 200),
                // Username
                MyTextField(
                  controller: emailController,
                  hintText: "Enter your email",
                  obscureText: false,
                  textInputStyle: TextInputType.emailAddress,
                  isPass: false,
                ),
                SizedBox(height: 10),
                // Password
                MyTextField(
                  controller: passwordController,
                  hintText: "Enter your password",
                  obscureText: true,
                  textInputStyle: TextInputType.emailAddress,
                  isPass: false,
                ),
                SizedBox(height: 40),
                // Sign In Button
                GestureDetector(
                  onTap: signInUser,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: const ShapeDecoration(
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                    ),
                    child: Center(
                      child: !_isLoading
                          ? const Text(
                              "Sign In",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 150,
                ),

                SizedBox(height: 10),

                Center(
                  child: GestureDetector(
                    onTap: signInWithGoogle,
                    child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          icon: Image.asset('assets/google.png'),
                          iconSize: 50,
                          onPressed: () {},
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
