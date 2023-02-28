import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:zboryar_application/screens/navigationPage.dart';
import 'package:zboryar_application/screens/login.dart';
import 'package:camera/camera.dart';
import '../database/storage.dart';

List<CameraDescription> cameras = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  cameras = await availableCameras();

  final StorageService _storageService = StorageService();
  String? _Value;
  Widget page;
  _Value = await _storageService.check();
  if (_Value == null) {
    log("Null Value Found");
    page = LoginScreen();
  } else {
    log(_Value);
    page = navigationPage();
  }
  runApp(MyApp(
    defaultHome: page,
  ));
}

class MyApp extends StatelessWidget {
  final Widget defaultHome;
  const MyApp({super.key, required this.defaultHome});

  Widget build(BuildContext context) {
    String Value;

    //value = _storageService.check();
    //log(value);

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Zbroyar',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: defaultHome);
  }
}

/*
@override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zbroyar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }



 */
