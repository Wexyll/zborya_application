import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:zboryar_application/components/components.dart';
import 'package:zboryar_application/screens/securityPage.dart';
import '../database/hive/model/boxes.dart';
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    username.dispose();
    pin.dispose();
    password.dispose();
    confirmPass.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery
              .of(context)
              .size
              .width * 0.13),
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
            child: LoginTextField(
                textController: username, hintText: "Username"),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: LoginTextField(
                textController: password, hintText: "Password", isPass: true),
          ),

          Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding),
              child: LoginTextField(textController: confirmPass,
                  hintText: "Password",
                  isPass: true)
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                LengthLimitingTextInputFormatter(6),
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
                if (await confirmPass.text != password.text) {
                  showSnackBar(context, "Passwords Don't Match");
                } else if (password.text.length < 6) {
                  showSnackBar(context, "Min 6 Character Password");
                } else {
                  //Writing correct sign up data to the data base
                  Boxes.getWeapons().clear();
                  Boxes.getSquadWeapons().clear();
                  final encryptData eUsername = encryptData(
                      "Username", username.text.toLowerCase().trim());
                  final encryptData ePassword = encryptData(
                      "Password", password.text.trim());
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

        ],
      ),
    );
  }
}