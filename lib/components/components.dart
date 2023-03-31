import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_validator/form_validator.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:zboryar_application/database/hive/model/squadWeapon.dart';

import '../constants/constants.dart';

//TODO add required
Widget buildTextField(
        {required TextEditingController textController,
        required String hintText}) =>
    TextFormField(
      validator: ValidationBuilder().required("This field is required.").build(),
      controller: textController,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.grey,
        hintStyle: TextStyle(color: Colors.white),
      ),
    );

showSnackBar(context, String message) {
  AnimatedSnackBar(
    mobileSnackBarPosition: MobileSnackBarPosition.top,
    duration: Duration(milliseconds: 5),
    snackBarStrategy: RemoveSnackBarStrategy(),
    builder: ((context) {
      return Container(
        height: 40,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: bg_login,
        ),
        child: Text(
          message,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
        ),
      );
    }),
  ).show(context);
}

Future<bool?> deleteDialog(context, DismissDirection direction) async {
  return await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Delete Weapon?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text("Okay"),
            ),
            TextButton(
              onPressed: () {
                return Navigator.of(context).pop(false);
              },
              child: Text("Cancel"),
            ),
          ],
        ),
      ) ??
      false;
}

Widget LoginTextField(
        {required TextEditingController textController,
        required String hintText,
        final bool isPass = false}) =>
    TextFormField(
      controller: textController,
      obscureText: isPass,
      validator: ValidationBuilder().required("This field is required.").build(),
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.white38,
        hintStyle: TextStyle(color: Colors.white),
        contentPadding: EdgeInsets.symmetric(
            vertical: defaultPadding * 1.2, horizontal: defaultPadding),
      ),
    );
