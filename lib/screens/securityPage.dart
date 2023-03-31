import 'package:flutter/cupertino.dart';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:zboryar_application/components/components.dart';
import '../database/item.dart';
import '../database/storage.dart';
import '../main.dart';

import '../constants/constants.dart';
import 'cameraScreen/camera.dart';
import 'navigationPage.dart';

class securityPage extends StatefulWidget {
  const securityPage({Key? key}) : super(key: key);

  @override
  State<securityPage> createState() => _securityPageState();
}

class _securityPageState extends State<securityPage> {

  final StorageService _storageService = StorageService();
  final _editingFormKey = GlobalKey<FormState>();
  final TextEditingController question1 = TextEditingController();
  final TextEditingController answer1 = TextEditingController();
  final TextEditingController question2 = TextEditingController();
  final TextEditingController answer2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Security Questions"),
        backgroundColor: bg_login,
      ),
      backgroundColor: bg_reg,
      body: ListView(
        children: [Padding(
          padding: EdgeInsets.all(8),
          child: Form(
            key: _editingFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/icon/ammo.png', height: 200, width: 200,),
                Text(
                  "Zbroya",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 40,
                  ),
                ),
                //Security Questions
                SizedBox(height: 13,),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                  child: LoginTextField(textController: question1, hintText: "Security Question 1")
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                  child: LoginTextField(textController: answer1, hintText: "Security Answer")
                ),

                Padding(
                    padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                    child: LoginTextField(textController: question2, hintText: "Security Question 1")
                ),

                Padding(
                    padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                    child: LoginTextField(textController: answer2, hintText: "Security Answer")
                ),

                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: ElevatedButton(
                    onPressed: () async {
                    if(_editingFormKey.currentState!.validate()) {
                      final encryptData eQ1 = encryptData(
                          "Question1", question1.text);
                      final encryptData eA1 = encryptData("Answer1", answer1.text
                          .toLowerCase().trim());
                      final encryptData eQ2 = encryptData(
                          "Question2", question2.text);
                      final encryptData eA2 = encryptData("Answer2", answer2.text
                          .toLowerCase().trim());
                      final encryptData eIsLoggedIn = encryptData(
                          "isLoggedIn", "true");
                      _storageService.writeSecureData(eQ1);
                      _storageService.writeSecureData(eA1);
                      _storageService.writeSecureData(eQ2);
                      _storageService.writeSecureData(eA2);
                      _storageService.writeSecureData(eIsLoggedIn);
                      Navigator.pushReplacement(
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
          ),
        ),
    ],
      ),
    );
  }
}
