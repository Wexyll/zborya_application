import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:zboryar_application/screens/securityPage.dart';
import '../database/item.dart';
import '../database/storage.dart';
import '../main.dart';

import '../constants/constants.dart';
import 'cameraScreen/camera.dart';
import 'navigationPage.dart';

class RegistrationForm extends StatefulWidget {
  RegistrationForm({Key? key}) : super(key: key);

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {

  final StorageService _storageService = StorageService();

  final TextEditingController username = TextEditingController();

  final TextEditingController pin = TextEditingController();

  final TextEditingController password = TextEditingController();

  final TextEditingController confirmPass = TextEditingController();

  final TextEditingController question1 = TextEditingController();
  final TextEditingController answer1 = TextEditingController();

  final TextEditingController question2 = TextEditingController();
  final TextEditingController answer2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.13),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Spacer(),
            SizedBox(height: 85,),
            Text(
              "Zbroya",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 40,
              ),
            ),
            SizedBox(height: 26,),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding),
              child: TextFormField(
                controller: username,
                obscureText: false,
                decoration: InputDecoration(
                  hintText: "Username",
                  filled: true,
                  fillColor: Colors.white38,
                  hintStyle: TextStyle(color: Colors.white),
                  contentPadding: EdgeInsets.symmetric(
                      vertical: defaultPadding * 1.2, horizontal: defaultPadding),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding),
              child: TextFormField(
                controller: password,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Password",
                  filled: true,
                  fillColor: Colors.white38,
                  hintStyle: TextStyle(color: Colors.white),
                  contentPadding: EdgeInsets.symmetric(
                      vertical: defaultPadding * 1.2, horizontal: defaultPadding),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding),
              child: TextFormField(
                controller: confirmPass,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Confirm Password",
                  filled: true,
                  fillColor: Colors.white38,
                  hintStyle: TextStyle(color: Colors.white),
                  contentPadding: EdgeInsets.symmetric(
                      vertical: defaultPadding * 1.2, horizontal: defaultPadding),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding),
              child: TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                controller: pin,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "6-Digit Pin",
                  filled: true,
                  fillColor: Colors.white38,
                  hintStyle: TextStyle(color: Colors.white),
                  contentPadding: EdgeInsets.symmetric(
                      vertical: defaultPadding * 1.2, horizontal: defaultPadding),
                ),
              ),
            ),

            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: ElevatedButton(
                onPressed: () async {
                  if(await confirmPass.text != password.text){
                    var snackbar = SnackBar(content: Text("Passwords Do Not Match!"));
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                  }else if(password.text.length < 6){
                    var snackbar = SnackBar(content: Text("Password is Too Short! (Minimum 6 Characters!)"));
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                  }else if(pin.text.length != 6){
                    var snackbar = SnackBar(content: Text("PIN must be 6 Numbers"));
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                  }else {
                    final encryptData eUsername = encryptData("Username", username.text.toLowerCase());
                    final encryptData ePassword = encryptData("Password", password.text);
                    final encryptData ePin = encryptData("Pin", pin.text);
                    _storageService.writeSecureData(eUsername);
                    _storageService.writeSecureData(ePassword);
                    _storageService.writeSecureData(ePin);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => securityPage()),
                    );

                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => navigationPage()),
                    // );
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white38,
                ),
                child: Center(
                  child: Text(
                    "Save Details",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            /*Spacer(
              flex: 2,
            )*/
          ],
        ),
    );
  }
}
/*
Padding(
padding: const EdgeInsets.symmetric(vertical: defaultPadding),
child: TextFormField(
controller: question1,
obscureText: true,
decoration: InputDecoration(
hintText: "Enter a Security Question",
filled: true,
fillColor: Colors.white38,
hintStyle: TextStyle(color: Colors.white),
contentPadding: EdgeInsets.symmetric(
vertical: defaultPadding * 1.2, horizontal: defaultPadding),
),
),
),

Padding(
padding: const EdgeInsets.symmetric(vertical: defaultPadding),
child: TextFormField(
controller: answer1,
obscureText: true,
decoration: InputDecoration(
hintText: "Question Answer",
filled: true,
fillColor: Colors.white38,
hintStyle: TextStyle(color: Colors.white),
contentPadding: EdgeInsets.symmetric(
vertical: defaultPadding * 1.2, horizontal: defaultPadding),
),
),
),

Padding(
padding: const EdgeInsets.symmetric(vertical: defaultPadding),
child: TextFormField(
controller: question2,
obscureText: true,
decoration: InputDecoration(
hintText: "Answer a Second Question",
filled: true,
fillColor: Colors.white38,
hintStyle: TextStyle(color: Colors.white),
contentPadding: EdgeInsets.symmetric(
vertical: defaultPadding * 1.2, horizontal: defaultPadding),
),
),
),

Padding(
padding: const EdgeInsets.symmetric(vertical: defaultPadding),
child: TextFormField(
controller: answer2,
obscureText: true,
decoration: InputDecoration(
hintText: "Answer",
filled: true,
fillColor: Colors.white38,
hintStyle: TextStyle(color: Colors.white),
contentPadding: EdgeInsets.symmetric(
vertical: defaultPadding * 1.2, horizontal: defaultPadding),
),
),
),*/
