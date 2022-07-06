import 'package:barat/screens/loginPage.dart';
import 'package:barat/services/credentialservices.dart';
import 'package:barat/utils/color.dart';
import 'package:barat/widgets/buildTextField.dart';
import 'package:barat/widgets/loadingButton.dart';
import 'package:barat/widgets/password_TextField.dart';
import 'package:barat/widgets/reusableBigText.dart';
import 'package:barat/widgets/reusableTextField.dart';
import 'package:barat/widgets/reusableTextIconButton.dart';
import 'package:barat/widgets/reusablealreadytext.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../widgets/buildPasswordField.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final CredentialServices credentialServices = CredentialServices();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _fullname = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  RegExp regExp = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  int userRoll = 1;
  bool obserText = true;
  // User? user;
  // final auth = FirebaseAuth.instance;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // _username.clear
    _username.dispose();
    _fullname.dispose();
    _phone.dispose();
    _email.dispose();
    _password.dispose();
  }

  Widget _buildRegisterBtn() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          primary: Colors.white,
        ),
        onPressed: () {
          credentialServices.getisLoading == false
              ? validation(context)
              : () {
                  print("Nothing Happen in register Screen");
                };
        },
        child: const Padding(
          padding: EdgeInsets.all(15.0),
          child: Text(
            'SIGNUP',
            style: TextStyle(
              color: secondaryColor,
              letterSpacing: 1.5,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),
          ),
        ),
      ),
    );
  }

  void validation(BuildContext context) async {
    if (_username.text.trim().isEmpty &&
        _email.text.trim().isEmpty &&
        _password.text.trim().isEmpty &&
        _phone.text.trim().isEmpty &&
        _fullname.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("All Field Are Empty"),
        ),
      );
    } else if (_fullname.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("FullName is Empty"),
        ),
      );
    } else if (_phone.text.trim().length > 13 ||
        _phone.text.toString().trim().length < 11) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid Phone Number"),
        ),
      );
    } else if (_email.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Email Is Empty"),
        ),
      );
    } else if (!regExp.hasMatch(_email.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please Try Vaild Email"),
        ),
      );
    } else if (_password.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password Is Empty"),
        ),
      );
    } else if (_password.text.trim().length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password  Is Too Short"),
        ),
      );
    } else {
      try {
        await credentialServices.registerAccount(
            context: context,
            email: _email.text.toString(),
            fullname: _fullname.text.trim().toString().toLowerCase(),
            password: _password.text.toString(),
            phNo: _phone.text.toString(),
            name: _username.text.trim().toString().toLowerCase(),
            routename: "/signup");
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please Try Vaild Email ${e.toString()}"),
          ),
        );
      }
    }
  }

  // Future<void> checkEmailVerified() async {
  //   user = auth.currentUser;
  // }

  @override
  void initState() {
    // user = auth.currentUser;
    // user!.sendEmailVerification();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("32   $userRoll");
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Form(
            key: _formKey,
            child: Stack(
              children: [
                Container(
                    height: height,
                    width: width,
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
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40.0,
                      ),
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: height * 0.1,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'Register',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          BuildTextFormField(
                            controller: _username,
                            hintText: 'Enter Username',
                            keyboardType: TextInputType.text,
                            titleText: 'User Name',
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          BuildTextFormField(
                            controller: _fullname,
                            hintText: 'Enter Full name',
                            keyboardType: TextInputType.text,
                            titleText: 'Full Name',
                          ),

                          SizedBox(
                            height: height * 0.01,
                          ),
                          BuildTextFormField(
                            controller: _phone,
                            hintText: 'Phone: +9233546586',
                            keyboardType: TextInputType.text,
                            titleText: 'Phone',
                          ),

                          SizedBox(
                            height: height * 0.01,
                          ),
                          BuildTextFormField(
                            controller: _email,
                            hintText: 'Enter Email',
                            keyboardType: TextInputType.text,
                            titleText: 'E-mail',
                          ),

                          // TextFormField(
                          //   controller: _phone,
                          //   maxLength: 11,
                          //   decoration: const InputDecoration.collapsed(
                          //     hintText: 'Phone: +9233546586',
                          //   ),
                          //   // hintText: 'Phone: +9233546586',
                          //   keyboardType: TextInputType.text,
                          // ),

                          SizedBox(
                            height: height * 0.01,
                          ),
                          BuildPasswordField(
                            controller: _password,
                            hintText: 'Enter your Password',
                            keyboardType: TextInputType.visiblePassword,
                            titleText: 'Password',
                            obscure: obserText,
                            onTap: () {
                              setState(() {
                                obserText = !obserText;
                              });
                            },
                          ),

                          SizedBox(
                            height: height * 0.02,
                          ),
                          Obx(
                            () => InkWell(
                              onTap: () async {
                                credentialServices.getisLoading == false
                                    ? validation(context)
                                    : () {
                                        print(
                                            "Nothing Happen in register Screen");
                                      };
                              },
                              child: credentialServices.getisLoading == false
                                  ? _buildRegisterBtn()
                                  // const ReusableTextIconButton(
                                  //     text: "SignUp",
                                  //   )
                                  : LoadingButton(),
                            ),
                          ),
                          ReusableAlreadyText(
                            text: "Login",
                            onClick: () => Get.off(
                              () => const LoginPage(),
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
