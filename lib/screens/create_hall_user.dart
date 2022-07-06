import 'package:barat/services/credentialservices.dart';
import 'package:barat/utils/color.dart';
import 'package:barat/widgets/reusableBigText.dart';
import 'package:barat/widgets/reusableTextField.dart';
import 'package:barat/widgets/reusableTextIconButton.dart';
import 'package:flutter/material.dart';

class CreateHallUser extends StatefulWidget {
  const CreateHallUser({Key? key}) : super(key: key);
  static const routeName = '/create-hall-user';

  @override
  _CreateHallUserState createState() => _CreateHallUserState();
}

class _CreateHallUserState extends State<CreateHallUser> {
  final CredentialServices credentialServices = CredentialServices();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _fullname = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _username.dispose();
    _fullname.dispose();
    _phone.dispose();
    _email.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    // final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: background1Color,
        centerTitle: true,
        title: const Text('Create Hall User'),
      ),
      body: SingleChildScrollView(
        child: Container(
            decoration: BoxDecoration(
                color: whiteColor, borderRadius: BorderRadius.circular(8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 30,
                ),
                ReusableTextField(
                  controller: _username,
                  hintText: 'username',
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(
                  height: 30,
                ),
                ReusableTextField(
                  controller: _fullname,
                  hintText: 'Full Name',
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(
                  height: 30,
                ),
                ReusableTextField(
                  controller: _phone,
                  hintText: 'Phone: +9233546586',
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(
                  height: 30,
                ),
                ReusableTextField(
                  controller: _email,
                  hintText: 'E-mail',
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(
                  height: 30,
                ),
                ReusableTextField(
                  controller: _password,
                  hintText: 'Password',
                  keyboardType: TextInputType.visiblePassword,
                  obscure: true,
                ),
                const SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: () {
                    credentialServices.registerAccount(
                        context: context,
                        email: _email.text.trim().toString(),
                        fullname: _fullname.text.trim().toString(),
                        password: _password.text.trim().toString(),
                        phNo: _phone.text.trim().toString(),
                        name: _username.text.trim().toString(),
                        routename: '/create-hall-user');
                  },
                  child: const ReusableTextIconButton(
                    text: "SignUp",
                    color: background1Color,
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
