import 'package:animated_snack_bar/animated_snack_bar.dart';
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

class forgotPassword extends StatefulWidget {
  String? question1;
  String? question2;

  forgotPassword({Key? key, required this.question1, required this.question2,}) : super(key: key);

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
                child: Text(
                  "Q1: ${widget.question1}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 25,
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
                child: Text(
                  "Q2: ${widget.question2}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 25,
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
                    final StorageService _storageService = StorageService();
                    String? A1 = await _storageService.Answer("Answer1");
                    String? A2 = await _storageService.Answer("Answer2");
                    String? pass = await _storageService.Password();
                    if(answer1.text == A1 && answer2.text == A2) {
                      failure = 3;
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
                            child: Text('${pass}', style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white),),
                          );
                        }),
                      ).show(context);
                    } else{
                      failure = failure-1;
                      if(failure <= 0){
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
                              child: Text('SECURITY: DATA DELETED', style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white),),
                            );
                          }),
                        ).show(context);
                      } else{
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
                              child: Text('WARNING: Wrong Information', style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white),),
                            );
                          }),
                        ).show(context);
                      }
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
