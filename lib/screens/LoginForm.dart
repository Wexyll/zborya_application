import 'dart:developer';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  String? _user;
  String? _pass;

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
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: defaultPadding),
                    child: TextFormField(
                      controller: username,
                      obscureText: false,
                      decoration: InputDecoration(
                        hintText: "Username",
                        filled: true,
                        fillColor: Colors.white38,
                        hintStyle: TextStyle(color: Colors.white),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: defaultPadding * 1.2,
                            horizontal: defaultPadding),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: defaultPadding),
                    child: TextFormField(
                      controller: password,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Password",
                        filled: true,
                        fillColor: Colors.white38,
                        hintStyle: TextStyle(color: Colors.white),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: defaultPadding * 1.2,
                            horizontal: defaultPadding),
                      ),
                    ),
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
                    var snackbar =
                        SnackBar(content: Text("Username Does Not Exist"));
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                  } else if (_user != username.text.toLowerCase()) {
                    failure = failure -1;
                    var snackbar =
                        SnackBar(content: Text("Username is Incorrect"));
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                  } else if (_pass != password.text) {
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
                    AnimatedSnackBar(
                      mobileSnackBarPosition: MobileSnackBarPosition.top,
                      duration: Duration(milliseconds: 2000),
                      snackBarStrategy: RemoveSnackBarStrategy(),
                      builder: ((context) {
                        return Container(
                          height: 40,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                                Radius.circular(20)),
                            color: bg_login,
                          ),
                          child: Text('One Try Remaining', style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white),),
                        );
                      }),
                    ).show(context);
                  }
                  if(failure <= 0){
                    final StorageService _storageService = StorageService();
                    _storageService.deleteAllSecureData();
                    AnimatedSnackBar(
                      mobileSnackBarPosition: MobileSnackBarPosition.top,
                      duration: Duration(milliseconds: 2000),
                      snackBarStrategy: RemoveSnackBarStrategy(),
                      builder: ((context) {
                        return Container(
                          height: 40,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                                Radius.circular(20)),
                            color: bg_login,
                          ),
                          child: Text('Deleting Data', style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white),),
                        );
                      }),
                    ).show(context);
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
                print(_Question1);

                if (_Question1 == null) {
                  AnimatedSnackBar(
                    mobileSnackBarPosition: MobileSnackBarPosition.top,
                    duration: Duration(milliseconds: 2000),
                    snackBarStrategy: RemoveSnackBarStrategy(),
                    builder: ((context) {
                      return Container(
                        height: 40,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: bg_login,
                        ),
                        child: Text('No Account Created', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),),
                      );
                    }),
                  ).show(context);
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
