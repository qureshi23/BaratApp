import 'dart:async';

import 'package:barat/screens/forget_password.dart';
import 'package:barat/screens/signUpPage.dart';
import 'package:barat/screens/verification_screen.dart';
import 'package:barat/services/credentialservices.dart';
import 'package:barat/utils/color.dart';
import 'package:barat/utils/constants.dart';
import 'package:barat/widgets/buildPasswordField.dart';
import 'package:barat/widgets/buildTextField.dart';
import 'package:barat/widgets/loadingButton.dart';
import 'package:barat/widgets/password_TextField.dart';
import 'package:barat/widgets/reusableTextField.dart';
import 'package:barat/widgets/reusableTextIconButton.dart';
import 'package:barat/widgets/reusablealreadytext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  static const routeName = '/login-page';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final box = GetStorage();
  bool obserText = true;

  // final CredentialServices credentialServices = CredentialServices();
  final credentialServices = Get.put(CredentialServices());
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 3),
    vsync: this,
  );
  late final Animation<double> _animation =
      Tween<double>(begin: 0.2, end: 1.2).animate(_controller);

  StreamController<double?>? streamController =
      StreamController<double?>.broadcast();
  double? position;
  // final String username = "admin@gmail.com";
  // final int password = 12345;

  Widget _buildForgotPasswordBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => Get.to(() => const ForgetPassword()),
        child: Text(
          'Forgot Password?',
          style: kLabelStyle,
        ),
      ),
    );
  }

  Widget _buildLoginBtn() {
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
          if (credentialServices.getisLoading == false) {
            if (_username.text.trim().toString().isEmpty &&
                _password.text.trim().toString().isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                duration: Duration(seconds: 3),
                content: Text(
                  "Field is Empty",
                ),
              ));
            } else {
              credentialServices.signInWithUsername(
                Usermail: _username.text.trim().toString(),
                password: _password.text.trim().toString(),
                context: context,
              );
            }
          } else {
            print("Nothing Happening in Progess Indicator");
          }
        },
        child: const Padding(
          padding: EdgeInsets.all(15.0),
          child: Text(
            'LOGIN',
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

  Widget steps(int i, String description) {
    return RichText(
      text: TextSpan(
          text: 'Step $i: \n',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: secondaryColor,
            fontSize: 16,
          ),
          children: [
            TextSpan(
              text: description,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                color: secondaryColor,
                fontSize: 15,
              ),
            )
          ]),
    );
  }

  guideLines(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final _form = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            title: const Text(
              "How to become Hall Owner",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: secondaryColor,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            content: SizedBox(
              width: size.width,
              height: size.height * 0.3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  steps(1, 'You need to sign up as user.'),
                  const SizedBox(height: 20),
                  steps(2,
                      'Contact admin and provide the data of your hall.\nAdmin Email: iamsubhanqureshi@gmail.com'),
                  const SizedBox(height: 20),
                  steps(
                      3, 'Admin will make you hall owner after above 2 steps.'),
                  const Spacer(),
                ],
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: secondaryColor),
                  child: const Text('OK'),
                  onPressed: () => Get.back()),
            ]);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _controller.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    _username.dispose();
    _password.dispose();
    streamController?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
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
                  child: SafeArea(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40.0,
                      ),
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: height * 0.08),
                          ScaleTransition(
                            scale: _animation,
                            child: FittedBox(
                              child: Image.asset(
                                'images/logo1.png',
                                width: 140,
                                height: 140,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Row(
                            children: const [
                              Text(
                                'Sign In',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0),
                          BuildTextFormField(
                            controller: _username,
                            hintText: 'Enter your Email',
                            keyboardType: TextInputType.text,
                            titleText: 'Email',
                          ),
                          const SizedBox(height: 20.0),
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
                          _buildForgotPasswordBtn(),
                          Obx(
                            () => InkWell(
                              onTap: () {
                                // Get.off(() => '/sign-in');
                              },
                              child: credentialServices.getisLoading == false
                                  ? _buildLoginBtn()
                                  // const ReusableTextIconButton(
                                  //     text: "Login",
                                  //   )
                                  : LoadingButton(),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          InkWell(
                            onTap: () {
                              credentialServices.signInWithGoogle();
                            },
                            child: Container(
                              width: double.infinity,
                              height: height / 14,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadiusDirectional.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 7,
                                    offset: const Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'images/google_signin.png',
                                      width: 18,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      "Sign in with Google",
                                      style: TextStyle(
                                          fontSize: 18.sp,
                                          color: secondaryColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          ReusableAlreadyText(
                            text: 'Signup',
                            onClick: () => Get.off(() => const SignUpPage()),
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                        ],
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: StreamBuilder<double?>(
        stream: streamController!.stream,
        builder: (context, AsyncSnapshot<double?> snapshot) => GestureDetector(
          onVerticalDragUpdate: (details) {
            position = height - details.globalPosition.dy;
            if (!position!.isNegative && position! < 140 && position! > 30) {
              streamController!.add(position);
            }
          },
          onVerticalDragEnd: (details) {
            streamController!.add(30);
            guideLines(context);
          },
          child: Container(
            decoration: const BoxDecoration(
                color: Colors.white60,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(80.0),
                  topRight: Radius.circular(80.0),
                )),
            width: width * 0.5,
            height: snapshot.hasData ? snapshot.data : height * 0.04,
            child: Column(
              children: const [
                Icon(
                  Icons.arrow_upward,
                  color: Colors.black54,
                  size: 16.0,
                ),
                Text(
                  "How to become Hall Owner",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 10.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
