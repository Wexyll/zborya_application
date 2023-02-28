import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
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

  final TextEditingController password = TextEditingController();

  final TextEditingController confirmPass = TextEditingController();

  /*Future<void> save(String key, String value) async {
    secureStorage.write(key: key, value: value);
  }

  Future<String> getValue(String key) async{
    return await secureStorage.read(key: key) ?? "";
  }

  void getValues(String key) async{
    username.text = await getValue(key);
  }

  void saveDetails() {
    save("Username", username.text);
    save("Password", password.text);
  }*/

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.13),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //Spacer(),
          SizedBox(height: 60,),
          Text(
            "Zbroyar",
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
                }else {
                  final encryptData eUsername = encryptData("Username", username.text);
                  final encryptData ePassword = encryptData("Password", password.text);
                  final encryptData eIsLoggedIn = encryptData("isLoggedIn", "true");
                  _storageService.writeSecureData(eUsername);
                  _storageService.writeSecureData(ePassword);
                  _storageService.writeSecureData(eIsLoggedIn);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => navigationPage()),
                  );
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
