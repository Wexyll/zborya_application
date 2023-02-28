import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zboryar_application/constants/constants.dart';
import 'package:zboryar_application/screens/signup_form.dart';
import 'LoginForm.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool _regShown = false;
  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [

          //Login
          AnimatedPositioned(
            width: _size.width * .88,
            height: _size.height,
            left: _regShown ? -_size.width *.76 : 0,
            duration: defaultDuration,
              child: Container(
                color: bg_login,
                child: LoginForm(),
              ),
            ),

          //SING UP
          AnimatedPositioned(
            duration: defaultDuration,
            height: _size.height,
            width: _size.width * 0.88,
            left: _regShown ? _size.width * .12: _size.width*.88,
            child: Container(
              color: bg_reg,
              child: RegistrationForm(),
            ),
          ),

          //LOGO
          AnimatedPositioned(
            duration: defaultDuration,
            top: _size.height * 0.05,
            left: 0,
            right: _regShown ? -_size.width*.06 : _size.width*0.06,
            child:  Column(
                  children: [
                    Image.asset('assets/icon/ammo.png'),
                  ],
                ),
          ),

          //Text Sign in
          AnimatedPositioned(
            duration: defaultDuration,
            top: _size.height*0.45,
            right: _regShown ? -_size.width * .2 : _size.width*.01,
              child: GestureDetector(
              onTap: () {
                setState(() {
                  _regShown = !_regShown;
                });
              },
              child: Container(
                child: RotatedBox(
                  quarterTurns: 1,
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              ),
          ),

          AnimatedPositioned(
            duration: defaultDuration,
            top: _size.height*0.45,
            left: _regShown ? _size.width * .01: -_size.width*.2,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _regShown = !_regShown;
                });
              },
              child: Container(
                child: RotatedBox(
                  quarterTurns: 3,
                  child: Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
