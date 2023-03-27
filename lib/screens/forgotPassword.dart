import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:zboryar_application/components/components.dart';
import '../database/hive/model/boxes.dart';
import '../database/item.dart';
import '../database/storage.dart';
import '../main.dart';

import '../constants/constants.dart';
import 'cameraScreen/camera.dart';
import 'navigationPage.dart';

class forgotPassword extends StatefulWidget {
  String? question1;
  String? question2;

  forgotPassword({
    Key? key,
    required this.question1,
    required this.question2,
  }) : super(key: key);

  @override
  State<forgotPassword> createState() => _forgotPasswordState();
}

class _forgotPasswordState extends State<forgotPassword> {
  final StorageService _storageService = StorageService();

  final TextEditingController answer1 = TextEditingController();
  final TextEditingController answer2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    int failure = 3;

    return Scaffold(
      appBar: AppBar(
        title: Text("Security Questions"),
        backgroundColor: bg_login,
      ),
      backgroundColor: bg_reg,
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Spacer(),
                SizedBox(
                  height: 60,
                ),
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                  child: Text(
                    "Security Questions \n"
                    "Attempts Left : ${failure}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),

                Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: defaultPadding),
                    child: LoginTextField(
                        textController: answer1,
                        hintText: "${widget.question1}")),

                Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: defaultPadding),
                    child: LoginTextField(
                        textController: answer2,
                        hintText: "${widget.question2}")),

                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      final StorageService _storageService = StorageService();
                      String? A1 = await _storageService.Answer("Answer1");
                      String? A2 = await _storageService.Answer("Answer2");
                      String? pass = await _storageService.Password();
                      if (answer1.text.toLowerCase().trim() == A1 &&
                          answer2.text.toLowerCase().trim() == A2) {
                        failure = 3;
                        showSnackBar(context, pass!);
                      } else {
                        failure = failure - 1;
                        if (failure <= 0) {
                          _storageService.deleteAllSecureData();
                          showSnackBar(context, "DATA DELETED");
                          Boxes.getWeapons().clear();
                          Boxes.getSquadWeapons().clear();
                          Navigator.pop(context);
                        } else {
                          showSnackBar(context, "Warning: Wrong Answers");
                        }
                        setState(() {});
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
        ],
      ),
    );
  }
}
