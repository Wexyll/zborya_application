import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';



const Color bg_login = Color(0xFF333F1D);
const Color bg_reg = Color(0xFFBD8E6B);
const Color highlight = Color(0xFFE6E6E6);
const Color selected = Color(0xFFBD8E6B);

const double defaultPadding = 12.0;
const Duration defaultDuration = Duration(milliseconds: 300);

Widget customEmailTextField(String hintText, TextEditingController controller) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: defaultPadding),
    child: TextFormField(
      controller: controller,
      obscureText:  false,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.white38,
        hintStyle: TextStyle(color: Colors.white),
        contentPadding: EdgeInsets.symmetric(
            vertical: defaultPadding * 1.2, horizontal: defaultPadding),
      ),
    ),
  );
}

Widget customPasswordTextField(String hintText, TextEditingController controller) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: defaultPadding),
    child: TextFormField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.white38,
        hintStyle: TextStyle(color: Colors.white),
        contentPadding: EdgeInsets.symmetric(
            vertical: defaultPadding * 1.2, horizontal: defaultPadding),
      ),
    ),
  );
}
/*
final _formKey = GlobalKey<FormBuilderState>();
final _emailFieldKey = GlobalKey<FormBuilderFieldState>();
final _passFieldKey = GlobalKey<FormBuilderFieldState>();
final _confirmPassFieldKey = GlobalKey<FormBuilderFieldState>();


Widget emailFormField(String hintText) {
  return FormBuilderTextField(
    key: _emailFieldKey,
    name: "Email",
    decoration: InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: Colors.white38,
      hintStyle: TextStyle(color: Colors.white),
      contentPadding: EdgeInsets.symmetric(
          vertical: defaultPadding * 1.2, horizontal: defaultPadding),
    ),
    validator: FormBuilderValidators.compose([
      FormBuilderValidators.required(),
      FormBuilderValidators.email(),
    ]),
  );
}

Widget passFormField(String hintText) {
  return FormBuilderTextField(
    key: _passFieldKey,
    name: "Password",
    decoration: InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: Colors.white38,
      hintStyle: TextStyle(color: Colors.white),
      contentPadding: EdgeInsets.symmetric(
          vertical: defaultPadding * 1.2, horizontal: defaultPadding),
    ),
    validator: FormBuilderValidators.compose([
      FormBuilderValidators.required(),
      FormBuilderValidators.minLength(6),
    ]),
  );
}

Widget confirmPassFormField(String hintText){
  return FormBuilderTextField(
    key: _confirmPassFieldKey,
    name: "Confirm Password",
    decoration: InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: Colors.white38,
      hintStyle: TextStyle(color: Colors.white),
      contentPadding: EdgeInsets.symmetric(
          vertical: defaultPadding * 1.2, horizontal: defaultPadding),
    ),
    validator: FormBuilderValidators.compose([
      FormBuilderValidators.required(),
      FormBuilderValidators.minLength(6),
      FormBuilderValidators.equal(_passFieldKey),
    ]),
  );
}

Widget CustomFormField(String hintText) {
  return FormBuilder(
    key: _formKey,
    child: Column(
      children: [
        emailFormField("Email"),
        passFormField("Password"),
        confirmPassFormField("Confirm Password"),
      ],
    ),
  );
}

Widget Submit(){
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 25.0),
    child: ElevatedButton(
      onPressed: () {
        //saveDetails();
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
  );
}
(*/


