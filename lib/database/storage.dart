import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'item.dart';

//init storage db
class StorageService {
  final _secureStorage = const FlutterSecureStorage();

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  Future<void> writeSecureData(encryptData newData) async {
    await _secureStorage.write(
        key: newData.key, value: newData.value, aOptions: _getAndroidOptions());
  }

  Future<String?> readSecureData(String key) async {
    var readData =
        await _secureStorage.read(key: key, aOptions: _getAndroidOptions());
    return readData;
  }

  Future<void> deleteSecureData(encryptData newData) async {
    await _secureStorage.delete(
        key: newData.key, aOptions: _getAndroidOptions());
  }

  Future<bool> containsKeyInSecureData(String key) async {
    var containsKey = await _secureStorage.containsKey(
        key: key, aOptions: _getAndroidOptions());
    return containsKey;
  }

  Future<List<encryptData>> readAllSecureData() async {
    var allData = await _secureStorage.readAll(aOptions: _getAndroidOptions());
    List<encryptData> list =
        allData.entries.map((e) => encryptData(e.key, e.value)).toList();
    return list;
  }

  Future<void> deleteAllSecureData() async {
    await _secureStorage.deleteAll(aOptions: _getAndroidOptions());
  }

  //Function made for checking if the user has logged in. If they have it will skip the login screens.
  Future<String?> check() async {
    final StorageService _storageService = StorageService();
    final TextEditingController _keyControl = TextEditingController();
    String? _Value;

    _keyControl.text = "isLoggedIn";
    _Value = await _storageService.readSecureData(_keyControl.text);
    log("FOUND: $_Value");
    return _Value;
  }

  Future<String?> User() async{
    final StorageService _storageService = StorageService();
    final TextEditingController _keyControl = TextEditingController();
    String? _Value;
    _keyControl.text ="Username";
    _Value = await _storageService.readSecureData(_keyControl.text);
    log("Username: $_Value");
    return _Value;
  }

  Future<String?> Pass() async{
    final StorageService _storageService = StorageService();
    final TextEditingController _keyControl = TextEditingController();
    String? _Value;
    _keyControl.text ="Password";
    _Value = await _storageService.readSecureData(_keyControl.text);
    log("Username: $_Value");
    return _Value;
  }

  Future<String?> Question1() async{
    final StorageService _storageService = StorageService();
    final TextEditingController _keyControl = TextEditingController();
    String? _Value;
    _keyControl.text ="Question1";
    _Value = await _storageService.readSecureData(_keyControl.text);
    log("Question1: $_Value");
    return _Value;
  }

  Future<String?> Question2() async{
    final StorageService _storageService = StorageService();
    final TextEditingController _keyControl = TextEditingController();
    String? _Value;
    _keyControl.text ="Question2";
    _Value = await _storageService.readSecureData(_keyControl.text);
    log("Question2: $_Value");
    return _Value;
  }

  Future<String?> Answer1() async{
    final StorageService _storageService = StorageService();
    final TextEditingController _keyControl = TextEditingController();
    String? _Value;
    _keyControl.text ="Question1";
    _Value = await _storageService.readSecureData(_keyControl.text);
    log("Question1: $_Value");
    return _Value;
  }

  Future<String?> Answer(String Answer) async{
    final StorageService _storageService = StorageService();
    final TextEditingController _keyControl = TextEditingController();
    String? _Value;
    _keyControl.text =Answer;
    _Value = await _storageService.readSecureData(_keyControl.text);
    log("${Answer}: $_Value");
    return _Value;
  }

  Future<String?> Password() async{
    final StorageService _storageService = StorageService();
    final TextEditingController _keyControl = TextEditingController();
    String? _Value;
    _keyControl.text ="Password";
    _Value = await _storageService.readSecureData(_keyControl.text);
    log("Password: $_Value");
    return _Value;
  }

}
