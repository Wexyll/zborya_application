import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zboryar_application/constants/constants.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../database/storage.dart';
import 'navigationPage.dart';

class pinLogin extends StatefulWidget {
  const pinLogin({Key? key}) : super(key: key);

  @override
  State<pinLogin> createState() => _pinLoginState();
}

class _pinLoginState extends State<pinLogin> {
  //PIN Login page
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      title: Text("PIN Secure Login"),
      backgroundColor: bg_login,
    ),
        backgroundColor: bg_reg,
        body:Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 24),
          //PIN text field
          child: PinCodeTextField(
            keyboardType: TextInputType.number,
            appContext: context,
            controller: controller,
            length: 6,
            cursorHeight: 15,
            enableActiveFill: true,
            textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly
            ],
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              fieldWidth: 50,
              inactiveFillColor: Colors.grey,
              inactiveColor: Colors.grey,
              activeFillColor: Colors.green[300],
              activeColor: Colors.green[300],
              selectedFillColor: Colors.green[500],
              selectedColor: Colors.green[500],
              borderWidth: 1,
              borderRadius: BorderRadius.circular(8),
            ),
            onChanged: ((value) async {
              final StorageService _storageService = StorageService();
              String? pin = await _storageService.readSecureData("Pin");
              if(controller.text == pin){
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => navigationPage()),
                );
              } else{
                print("false");
              }
            }),
          ),
        ),
      ],
    ),
    );
  }
}
