import 'package:flutter/cupertino.dart';
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

class securityPage extends StatefulWidget {
  const securityPage({Key? key}) : super(key: key);

  @override
  State<securityPage> createState() => _securityPageState();
}

class _securityPageState extends State<securityPage> {

  final StorageService _storageService = StorageService();

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Spacer(),
              SizedBox(height: 60,),
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
                  controller: question1,
                  decoration: InputDecoration(
                    hintText: "Security Question 1",
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
                  decoration: InputDecoration(
                    hintText: "Security Question 2",
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

              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: ElevatedButton(
                  onPressed: () async {
                      final encryptData eQ1 = encryptData("Question1", question1.text);
                      final encryptData eA1 = encryptData("Answer1", answer1.text.toLowerCase());
                      final encryptData eQ2 = encryptData("Question2", question2.text);
                      final encryptData eA2 = encryptData("Answer2", answer2.text.toLowerCase());
                      final encryptData eIsLoggedIn = encryptData("isLoggedIn", "true");
                      _storageService.writeSecureData(eQ1);
                      _storageService.writeSecureData(eA1);
                      _storageService.writeSecureData(eQ2);
                      _storageService.writeSecureData(eA2);
                      _storageService.writeSecureData(eIsLoggedIn);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => navigationPage()),
                      );
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
    ],
      ),
    );
  }
}
