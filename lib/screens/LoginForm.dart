import 'dart:developer';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zboryar_application/components/components.dart';
import 'package:zboryar_application/constants/constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:zboryar_application/screens/navigationPage.dart';

import '../database/item.dart';
import '../database/storage.dart';
import 'cameraScreen/camera.dart';
import 'forgotPassword.dart';

class LoginForm extends StatefulWidget {
  LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  int failure = 3;

  final StorageService _storageService = StorageService();
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  final _FormKey = GlobalKey<FormState>();

  String? _user;
  String? _pass;

  @override
  void dispose() {
    super.dispose();
    username.dispose();
    password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.13),
      child: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Spacer(),
            Text(
              "Zbroya",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 40,
              ),
            ),
            SizedBox(
              height: 26,
            ),
            Form(
              key: _FormKey,
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: defaultPadding),
                    child: LoginTextField(textController: username, hintText: "Username")
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: defaultPadding),
                    child: LoginTextField(textController: password, hintText: "Password", isPass: true)
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: ElevatedButton(
                onPressed: () async {
                  _user = await _storageService.User();
                  _pass = await _storageService.Pass();
                  if (_user == null) {
                    failure = failure -1;
                    var snackbar = SnackBar(content: Text("No Users Created"));
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                  } else if (_user != username.text.toLowerCase().trim()) {
                    failure = failure -1;
                    var snackbar =
                        SnackBar(content: Text("Username is Incorrect"));
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                  } else if (_pass != password.text.trim()) {
                    failure = failure -1;
                    var snackbar =
                        SnackBar(content: Text("Password is Incorrect"));
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                  } else {
                    failure = 3;
                    final encryptData eIsLoggedIn =
                        encryptData("isLoggedIn", "true");
                    _storageService.writeSecureData(eIsLoggedIn);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => navigationPage()),
                    );
                  }
                  if(failure == 1){
                    showSnackBar(context, "One Attempt Remaining");
                  }
                  if(failure <= 0){
                    final StorageService _storageService = StorageService();
                    _storageService.deleteAllSecureData();
                    showSnackBar(context, "FAIL: DATA DELETED");
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white38,
                ),
                child: Center(
                  child: Text(
                    "Sign In",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                final StorageService _storageService = StorageService();
                String? _Question1 = await _storageService.Question1();
                String? _Question2 = await _storageService.Question2();

                if (_Question1 == null) {
                  showSnackBar(context, "No Account Exist");
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => forgotPassword(
                            question1: _Question1, question2: _Question2)),
                  );
                }
              },
              child: Text(
                "Forgot Password?",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
            ),

            /*Spacer(
              flex: 2,
            )*/
          ],
        ),
      ),
    );
  }
}
