import 'package:flutter/material.dart';

Widget buildTextField({
  required TextEditingController textController,
  required String hintText
}) =>
    TextFormField(
      controller: textController,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.grey,
        hintStyle: TextStyle(color: Colors.white),
      ),
    );