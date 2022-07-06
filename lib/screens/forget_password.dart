import 'package:barat/screens/loginPage.dart';
import 'package:barat/utils/color.dart';
import 'package:barat/widgets/buildTextField.dart';
import 'package:barat/widgets/reusableTextIconButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../widgets/reusableTextField.dart';

class ForgetPassword extends StatefulWidget {
  static String route = 'forgot-password';

  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController _email = TextEditingController();

  RegExp regExp = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  Future veriyEmail() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _email.text.trim().toString());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 5),
          content: Text("Password Reset Email Sent"),
        ),
      );

      Get.off(() => const LoginPage());
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 5),
          content: Text(error.toString()),
        ),
      );
      Get.back();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 5),
          content: Text(e.toString()),
        ),
      );
      Get.back();
    }
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: whiteColor,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Form(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Stack(
              children: [
                Container(
                  width: size.width,
                  height: size.height,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        background1Color,
                        secondaryColor,
                      ],
                      stops: [0.2, 0.9],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Reset Password',
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            RichText(
                              textAlign: TextAlign.center,
                              text: const TextSpan(
                                text: "Please check ",
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                                children: [
                                  TextSpan(
                                    text: "\"Spam Folder\"",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800),
                                  ),
                                  TextSpan(text: " For Reset Password Email."),
                                ],
                              ),
                            ),

                            const SizedBox(height: 30.0),
                            BuildTextFormField(
                              controller: _email,
                              hintText: 'Enter your Email',
                              keyboardType: TextInputType.text,
                              titleText: 'Email',
                            ),

                            const SizedBox(height: 30.0),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                    minimumSize: const Size.fromHeight(40),
                                    primary: whiteColor),
                                icon: const Icon(
                                  Icons.email,
                                  size: 32,
                                  color: deepOrange,
                                ),
                                label: const Text(
                                  "Reset Password",
                                  style: TextStyle(
                                      fontSize: 20.0, color: deepOrange),
                                ),
                                onPressed: () {
                                  if (_email.text.trim().toString().isEmpty ||
                                      !regExp.hasMatch(
                                          _email.text.trim().toString())) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      duration: Duration(seconds: 3),
                                      content: Text(
                                        "Invalid Email Address",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ));
                                  } else {
                                    veriyEmail();
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                            InkWell(
                              onTap: () => Get.off(() => const LoginPage()),
                              child: const Text(
                                'Sign In',
                                style: TextStyle(
                                    color: whiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24.0,
                                    decoration: TextDecoration.underline,
                                    decorationThickness: 3.0),
                              ),
                            ), // I(
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
