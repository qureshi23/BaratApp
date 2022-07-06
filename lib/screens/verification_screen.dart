import 'dart:async';

import 'package:async/async.dart';
import 'package:barat/screens/HomePage.dart';
import 'package:barat/screens/admin.dart';
import 'package:barat/screens/loginPage.dart';
import 'package:barat/services/credentialservices.dart';
import 'package:barat/utils/color.dart';
import 'package:barat/widgets/buildTextField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class VerificationScreen extends StatefulWidget {
  final name;
  final fullname;
  final phNo;
  final email;

  final password;
  final routename;
  final usercredential;
  VerificationScreen({
    this.name = " ",
    this.fullname = " ",
    this.phNo = " ",
    required this.email,
    required this.password,
    required this.routename,
    required this.usercredential,
  });
  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  bool isEmaiLVerified = false;
  bool canResendEmail = false;
  Timer? timer;
  final credentialServices = Get.find<CredentialServices>();
  final box = GetStorage('myData');

  Future _sendVerificationEmail() async {
    try {
      final User? userAuth = widget.usercredential.user;
      // final user = FirebaseAuth.instance.userAuth;
      await userAuth!.sendEmailVerification();
      setState(() => canResendEmail = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Verification Email Sent "),
        ),
      );
      await Future.delayed(const Duration(seconds: 5), () {
        setState(() => canResendEmail = true);
      });
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 5),
          content: Text(" ${e.message}"),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 5),
          content: Text("Dont Send Message ${e.toString()}"),
        ),
      );
    }
  }

  Future _checkEmailVerified() async {
    try {
      await FirebaseAuth.instance.currentUser?.reload();
      setState(() {
        isEmaiLVerified = FirebaseAuth.instance.currentUser!.emailVerified;
      });

      if (isEmaiLVerified) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 5),
            content: Text("Email has been Verified"),
          ),
        );
        print('widget.routename  =  ${widget.routename}');
        if (widget.routename == '/signin') {
          credentialServices.userUid.value = widget.usercredential.user!.uid;
          credentialServices.username.value = widget.name;
          credentialServices.useremail.value = widget.email;

          box.write('user', credentialServices.userUid.value);
          box.write('name', credentialServices.username.value);
          box.write('email', credentialServices.useremail.value);
          Get.close(2);
        } else if (widget.routename == "/signup") {
          await FirebaseAuth.instance.signOut();
          Get.off(() => const LoginPage());
        } else if (widget.routename == '/create-hall-user') {
          Get.off(() => const AdminPage());
        }

        timer?.cancel();
      }
    } catch (e) {
      //  ScaffoldMessenger.of(context).showSnackBar(
      //    SnackBar(
      //     duration:const Duration(seconds: 5),
      //     content: Text(e.toString()),
      //   ),
      // );
      print(e.toString());
    }
  }

  @override
  @override
  void initState() {
    isEmaiLVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmaiLVerified) {
      _sendVerificationEmail();
      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => _checkEmailVerified(),
      );
    }
    super.initState();
  }

  @override
  void dispose() async {
    timer?.cancel();
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<bool> _willpopscope() async {
    if (widget.routename == '/signin') {
      FirebaseAuth.instance.signOut();
      Get.back();
    } else if (widget.routename == "/signup") {
      FirebaseAuth.instance.signOut();
      Get.off(() => const LoginPage());
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: _willpopscope,
      child: Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Email Verification',
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
                                TextSpan(text: " For Verification Email."),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30.0),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 40.0),
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  minimumSize: const Size.fromHeight(50),
                                  primary: whiteColor),
                              icon: const Icon(
                                Icons.email,
                                size: 32,
                                color: deepOrange,
                              ),
                              label: const Text(
                                "Resent Email",
                                style: TextStyle(
                                    fontSize: 24.0, color: deepOrange),
                              ),
                              onPressed: () {
                                print("Resend 1 {$canResendEmail}");
                                canResendEmail == true
                                    ? {_sendVerificationEmail()}
                                    : print("Send $canResendEmail");
                              },
                            ),
                          ),
                          const SizedBox(height: 25.0),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            child: InkWell(
                              onTap: () {
                                if (widget.routename == '/signin') {
                                  FirebaseAuth.instance.signOut();
                                  Get.back();
                                } else if (widget.routename == "/signup") {
                                  FirebaseAuth.instance.signOut();
                                  Get.off(() => const LoginPage());
                                } else if (widget.routename ==
                                    '/create-hall-user') {
                                  Get.off(() => const AdminPage());
                                }
                              },
                              child: const Text(
                                "Cancel",
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.white,
                                  decorationThickness: 3.0,
                                  fontSize: 24.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
