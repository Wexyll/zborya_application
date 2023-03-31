import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:zboryar_application/screens/navigationPage.dart';
import 'package:zboryar_application/screens/login.dart';
import 'package:zboryar_application/database/hive/model/invWeapon.dart';
import 'package:camera/camera.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zboryar_application/screens/pinLogin.dart';
import '../database/storage.dart';
import 'database/hive/model/squadWeapon.dart';

List<CameraDescription> cameras = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  cameras = await availableCameras();

  await Hive.initFlutter();

  final StorageService _storageService = StorageService();
  
  String? _Value;
  Widget page;
  _Value = await _storageService.check();

  //Deciding what page to initially show the user whether they're logged in or not
  if (_Value == null) {
    log("Null Value Found");
    page = LoginScreen();
  } else {
    log(_Value);
    page = pinLogin();
  }

  //Opening Hive boxes
  Hive.registerAdapter(InventoryWeaponAdapter());
  await Hive.openBox<InventoryWeapon>('inventoryWeapons');

  Hive.registerAdapter(squadWeaponAdapter());
  await Hive.openBox<squadWeapon>('squadWeapons');

  runApp(MyApp(
    defaultHome: page,
  ));
}

class MyApp extends StatelessWidget {
  final Widget defaultHome;
  const MyApp({super.key, required this.defaultHome});

  void dispose(){
    Hive.box<InventoryWeapon>('inventoryWeapons').close();
  }

  Widget build(BuildContext context) {
    String Value;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Zbroyar',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: defaultHome);
  }
}
